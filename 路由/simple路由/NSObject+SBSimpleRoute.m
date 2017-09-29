//
//  NSObject+SBSimpleRoute.m
//  路由
//
//  Created by qyb on 2017/7/31.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "NSObject+SBSimpleRoute.h"
#import "SBSimpleRouteUrl.h"
#import "SBSReceiveObject.h"
#import "SBSimpleRouteEvent.h"
#import "SBSMethodObject.h"
#import "SBSimpleRouter.h"
@implementation NSObject (SBSimpleRoute)


- (void)callActionRequest:(NSString *)request params:(NSArray *)params response:(void(^)(id response,NSString *url,BOOL success,NSError *error))response{
    if (request.length == 0) {
        response(nil,request,NO,[NSError sb_errorWithDomain:@"访问路径格式有误" code:SBSimpleRouteFormatError userInfo:@{@"url":request}]);
        return;
    }
    if (![params isKindOfClass:[NSArray class]]) {
        response(nil,request,NO,[NSError sb_errorWithDomain:@"参数 not array" code:SBSimpleRouteFormatError userInfo:@{@"url":request}]);
        return;
    }
    if ([[SBSimpleRouter shareRouter].delegate respondsToSelector:@selector(routeShouldCalled:params:)]) {
        if (![[SBSimpleRouter shareRouter].delegate routeShouldCalled:request params:params]) {
            response(nil,request,NO,[NSError sb_errorWithDomain:@"此路由被拦截" code:SBSimpleRouteInitiativeInterceptError userInfo:@{@"url":request}]);
            return;
        }
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SBSimpleRouteEvent *cacheEvent = [[SBSimpleRouter shareRouter] performSelector:@selector(_eventForUrl:) withObject:request];
#pragma clang diagnostic pop
    if (cacheEvent) {
        [cacheEvent handleEventParams:params response:response];
        return;
    }
    SBSimpleRouteUrl *routeUrl = [[SBSimpleRouteUrl alloc] initUrl:request];
    if (!routeUrl) {
        response(nil,request,NO,[NSError sb_errorWithDomain:@"访问路径格式有误" code:SBSimpleRouteFormatError userInfo:@{@"url":routeUrl.url}]);
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SBSReceiveObject *object = [[SBSimpleRouter shareRouter] performSelector:@selector(_routeObjectForKey:) withObject:routeUrl.host.host];
#pragma clang diagnostic pop
    if (!object) {
        response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"访问路径host不存在" code:SBSimpleRouteHostNotFindError userInfo:@{@"url":routeUrl.url}]);
        return;
    }
    SBSMethodObject *method = [object methodForKey:routeUrl.action];
    if (!method) {
        response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"访问路径action不存在" code:SBSimpleRouteActionNotFindError userInfo:@{@"url":routeUrl.url}]);
        return;
    }
    SBSimpleRouteEvent *event = [[SBSimpleRouteEvent alloc] initWithReceiveObject:object method:method routeUrl:routeUrl];
    if (!event) {
        response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"其他错误" code:SBSimpleRouteOtherError userInfo:@{@"url":routeUrl.url}]);
        return;
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [[SBSimpleRouter shareRouter] performSelector:@selector(_addEventToTop:) withObject:event];
#pragma clang diagnostic pop
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

@end
