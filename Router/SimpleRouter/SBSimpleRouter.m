//
//  SBSimpleRouter.m
//  BossCockpit
//
//  Created by qyb on 2017/7/25.
//  Copyright © 2017年 qyb. All rights reserved.
//


/*
 url:
 
 AppScheme://host@action?params
 AppScheme:app标志 host:me/list 模块名称  action:方法名 init  params:参数

 */
#import <UIKit/UIKit.h>
#import "SBSimpleRouter.h"
#import "SBSimpleRouteUrl.h"
#import "SBSimpleRouteEvent.h"
#import "SBSMethodObject.h"
#import "SBSimpleEventQueue.h"
#import "SBSRAutoRegistModel.h"

#define RoutesLock() dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER)
#define RoutesUnlock() dispatch_semaphore_signal(_globalInstancesLock)

static dispatch_semaphore_t _globalInstancesLock;
NSString *const __free_custom_service = @"FreeCustom/service";

@implementation SBSimpleRouter
{
    NSMutableDictionary *_toutesTable;
    SBSimpleEventQueue *_cacheQueue;
}
#pragma mark - init

+ (instancetype)shareRouter{
    static SBSimpleRouter *router = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _globalInstancesLock = dispatch_semaphore_create(1);
        });
        router = [[SBSimpleRouter alloc] init];
        router->_toutesTable = [NSMutableDictionary new];
        router->_cacheMaxCount = 5;
        router.outputLog = YES;
        router->_cacheQueue = [[SBSimpleEventQueue alloc] initWithMax:router->_cacheMaxCount];
        [router initializeToutes];
        
    });
    return router;
}
- (void)initializeToutes{
//    SBSReceiveObject *object = [SBSReceiveObject initWithClass:NSStringFromClass(@"") hostUrl:__free_custom_service];
//    [self _addRouteObject:object forKey:object.hostUrl];
}
#pragma mark - public
- (void)setCacheMaxCount:(NSInteger)cacheMaxCount{
    _cacheMaxCount = cacheMaxCount;
    [_cacheQueue setMax:cacheMaxCount];
}
- (void)autoRegistWithClass:(Class)sclass ahost:(NSString *)host{
    
    SBSRAutoRegistModel *autoRegist = [SBSRAutoRegistModel fetchInstanceMethodListToClass:sclass host:host];
    if (!autoRegist) return;
    NSDictionary *classMethods = [SBSMethodObject classMethodListWithAutoRegist:autoRegist];
    NSDictionary *instanceMethods = [SBSMethodObject instanceMethodListWithAutoRegist:autoRegist];
    if (!classMethods && !instanceMethods) return;
    NSString *className = NSStringFromClass(sclass);
    SBSReceiveObject *receive = [SBSReceiveObject initWithClass:className hostUrl:host];
    if (classMethods) {
        [receive addMethods:classMethods];
    }
    if (instanceMethods) {
        [receive addMethods:instanceMethods];
    }
    [self registObject:receive forRoute:receive.hostUrl];
}
- (void)registHandleBlock:(id (^)(NSArray *params))customBlock forFullRoute:(NSString *)route {
    
    NSAssert(route && customBlock, @"dont insert null value");
    SBSimpleRouteUrl *routeUrl = [[SBSimpleRouteUrl alloc] initUrl:route];
    NSAssert(routeUrl, @"URL format is wrong");
    SBSMethodObject *method = [SBSMethodObject blockMethodName:routeUrl.action];
    [method setMethodBlock:customBlock];
    SBSReceiveObject *object = [self _routeObjectForKey:routeUrl.host.host];
    if (!object) {
        RoutesLock();
        object = [SBSReceiveObject initWithClass:routeUrl.host.host hostUrl:routeUrl.host.host];
        RoutesUnlock();
    }
    [object addMethod:method forKey:routeUrl.action];
    [self _addRouteObject:object forKey:routeUrl.host.host];
    NSAssert(routeUrl, @"toute format illegal");
    
}
- (void)registObject:(SBSReceiveObject *)object forRoute:(NSString *)route{
    NSAssert(route, @"dont insert null value");
    SBSRUrlHost *host = [SBSRUrlHost targetParse:route];
    NSAssert(host.host, @"toute format illegal");
    [self _addRouteObject:object forKey:host.host];
    
}
- (void)callActionRequest:(NSString *)request params:(NSArray *)params response:(void(^)(id response,NSString *url,BOOL success,NSError *error))response{
    
    if (request.length == 0) {
        response(nil,request,NO,[NSError sb_errorWithDomain:@"访问路径格式有误" code:SBSimpleRouteFormatError userInfo:@{@"url":request}]);
        return;
    }
    if (![params isKindOfClass:[NSArray class]]) {
        response(nil,request,NO,[NSError sb_errorWithDomain:@"参数 not array" code:SBSimpleRouteFormatError userInfo:@{@"url":request}]);
        return;
    }
    if ([self.delegate respondsToSelector:@selector(routeShouldCalled:params:)]) {
        if (![self.delegate routeShouldCalled:request params:params]) {
            response(nil,request,NO,[NSError sb_errorWithDomain:@"此路由被拦截" code:SBSimpleRouteInitiativeInterceptError userInfo:@{@"url":request}]);
            return;
        }
        
    }
    SBSimpleRouteEvent *cacheEvent = [self _eventForUrl:request];
    if (cacheEvent) {
        [cacheEvent handleEventParams:params response:response];
        return;
    }
    SBSimpleRouteUrl *routeUrl = [[SBSimpleRouteUrl alloc] initUrl:request];
    if (!routeUrl) {
        response(nil,request,NO,[NSError sb_errorWithDomain:@"访问路径格式有误" code:SBSimpleRouteFormatError userInfo:@{@"url":request}]);
        return;
    }
    SBSReceiveObject *object = [self _routeObjectForKey:routeUrl.host.host];
    if (!object) {
        response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"访问路径host不存在" code:SBSimpleRouteHostNotFindError userInfo:@{@"url":request}]);
        return;
    }
    SBSMethodObject *method = [object methodForKey:routeUrl.action];
    if (!method) {
        response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"访问路径action不存在" code:SBSimpleRouteActionNotFindError userInfo:@{@"url":request}]);
        return;
    }
    SBSimpleRouteEvent *event = [[SBSimpleRouteEvent alloc] initWithReceiveObject:object method:method routeUrl:routeUrl];
    
    if (!event) {
        response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"其他错误" code:SBSimpleRouteOtherError userInfo:@{@"url":request}]);
        return;
    }
    [self _addEventToTop:event];
    [event handleEventParams:params response:response];
}
- (id)callActionRequest:(NSString *)request params:(NSArray *)params{
    __block id result = nil;
    [self callActionRequest:request params:params response:^(id response, NSString *url, BOOL success,NSError *error) {
        if (success) {
            result = response;
        }
    }];
    return result;
}
#pragma mark - private
- (void)_addEventToTop:(SBSimpleRouteEvent *)event{
    NSAssert([event isKindOfClass:[SBSimpleRouteEvent class]], @"路径对象必须为 SBSimpleRouteEvent instance");
    [_cacheQueue addEventToTop:event];
}
- (SBSimpleRouteEvent *)_eventForUrl:(NSString *)url{
    return [_cacheQueue eventForUrl:url];
}
- (void)_addRouteObject:(id)object forKey:(NSString *)key{
    NSAssert([object isKindOfClass:[SBSReceiveObject class]], @"路径对象必须为 SBSReceiveObject instance");
    RoutesLock();
    [_toutesTable setObject:object forKey:key];
    RoutesUnlock();
}
- (id)_routeObjectForKey:(NSString *)key{
    RoutesLock();
    id objc = [_toutesTable objectForKey:key];
    RoutesUnlock();
    return objc;
}
+ (NSString *)_conversionRoute:(NSString *)route  forKey:(NSString *)key{
    NSString *conversionRoute = route.copy;
    return [conversionRoute stringByReplacingOccurrencesOfString:@"/" withString:key];
}
@end
