//
//  SBSimpleRouteEvent.m
//  BossCockpit
//
//  Created by qyb on 2017/7/26.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBSimpleRouteEvent.h"
#import "SBSimpleRouter.h"
#define eventLock() dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER)
#define eventUnlock() dispatch_semaphore_signal(_globalInstancesLock)

@interface SBSimpleRouteEvent()<NSCopying>
@property (strong,nonatomic,readwrite) SBSReceiveObject *receive;
@property (strong,nonatomic,readwrite) SBSMethodObject *method;
@property (strong,nonatomic,readwrite) SBSimpleRouteUrl *routeUrl;

@property (strong,nonatomic,readwrite) NSArray *params;
@property (copy,nonatomic,readwrite) void(^response)(id response,NSString *url,BOOL finished,NSError *error);
@end
@implementation SBSimpleRouteEvent
{
    id _receiveObject;
    dispatch_semaphore_t _globalInstancesLock;
}
- (instancetype)initWithReceiveObject:(SBSReceiveObject *)object method:(SBSMethodObject *)method routeUrl:(SBSimpleRouteUrl *)routeUrl{
    if (self = [super init]) {
        _globalInstancesLock = dispatch_semaphore_create(1);
        _receive = object;
        _method = method;
        _routeUrl = routeUrl;
    }
    return self;
}

#pragma mark - nscopy
- (id)copyWithZone:(NSZone *)zone{
    SBSimpleRouteEvent *event = [[SBSimpleRouteEvent alloc] initWithReceiveObject:_receive.copy method:_method.copy routeUrl:_routeUrl.copy];
    return event;
}
#pragma mark - public
- (void)handleEventParams:(NSArray *)params response:(void(^)(id response,NSString *url,BOOL finished,NSError *error))response{
    
    eventLock();
    _params = params.copy;
    _response = [response copy];
    _receiveObject = _method.methodType?[_receive sb_class]:[_receive sb_instance];
    eventUnlock();
    
    SBSMethodObject *method = [_method copy];
    SBSimpleRouteUrl *routeUrl = [_routeUrl copy];
    id receiveObject = _receiveObject;
    
    if (method.methodType == 2) {
        [self handleBlockParams:params response:response methodBlock:[method.methodBlock copy]];
        return;
    }
    
    SEL sel = NSSelectorFromString(method.methodName);
    
    NSMethodSignature* methodSig = [receiveObject methodSignatureForSelector:sel];
    if (!methodSig) {
        if (response) {
            response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"方法没有找到" code:SBSimpleRouteMethodNotFindError userInfo:@{@"url":routeUrl.url}]);
        }
        return;
    }
    if ((params.count != methodSig.numberOfArguments-2) || params.count != method.params.count || ![self params:params isEqualOther:method.params]) {
        if (response) {
            response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"参数错误" code:SBSimpleRouteParameterError userInfo:@{@"url":routeUrl.url}]);
        }
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    
    const char* retType = [methodSig methodReturnType];
    if (method.returnType != *retType) {
        if (response) {
            response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"返回值类型错误" code:SBSimpleRouteReturnTypeError userInfo:@{@"url":routeUrl.url}]);
        }
        return;
    }
    
    [invocation setSelector:sel];
    [invocation setTarget:receiveObject];
    NSInteger index = 2;
    NSInteger paramIndex = 0;
    NSArray *parameters = method.params.copy;

    for (id param in params) {
        
        switch ([[parameters objectAtIndex:paramIndex] charValue]) {
                
            case 'c':
            {
                char p = [param charValue];
                [invocation setArgument:&p atIndex:index];
            }
                break;
            case 'i':
            {
                int p = [param intValue];
                [invocation setArgument:&p atIndex:index];
            }
                break;
            case 'f':
            {
                float p = [param floatValue];
                [invocation setArgument:&p atIndex:index];
            }
                break;
            case 'd':
            {
                double p = [param doubleValue];
                [invocation setArgument:&p atIndex:index];
            }
                break;
                
            default:
            {
                void * p = (__bridge void *)param;
                [invocation setArgument:&p atIndex:index];
            }
                break;
        }
        
        index ++;
        paramIndex ++;
    }
    if ([[SBSimpleRouter shareRouter].delegate respondsToSelector:@selector(routeCalling:params:)]) {
        [[SBSimpleRouter shareRouter].delegate routeCalling:routeUrl.url params:params];
    }
// 调用方法
    [invocation invoke];
    
    if (strcmp(retType,"@") == 0) {
        void * result = NULL;
        
        if (methodSig.methodReturnLength > 0) {
            [invocation getReturnValue:&result];
        }
        
        if (response) {
            
            response((__bridge id)result,routeUrl.url,YES,nil);
        }
        
    }else if(strcmp(retType,"v") == 0){
        if (response) {
            response(nil,routeUrl.url,YES,nil);
        }
        
    }else{
        if (methodSig.methodReturnLength <= 0) {
            if (response) {
                response(nil,routeUrl.url,YES,nil);
            }
            return;
        }
        if (strcmp(retType,@encode(int)) == 0 || strcmp(retType,@encode(BOOL)) == 0 || strcmp(retType,@encode(NSInteger)) == 0 || strcmp(retType,@encode(NSUInteger)) == 0) {
            int result = 0;
            [invocation getReturnValue:&result];
            if (response) {
                response(@(result),routeUrl.url,YES,nil);
            }
            
        }else if (strcmp(retType,@encode(float)) == 0 || strcmp(retType,@encode(CGFloat)) == 0 || strcmp(retType,@encode(double)) == 0){
            double result = 0;
            [invocation getReturnValue:&result];
            if (response) {
                response(@(result),routeUrl.url,YES,nil);
            }
        }
    }
    if ([[SBSimpleRouter shareRouter].delegate respondsToSelector:@selector(routeDidCalled:andResult:error:)]) {
        [[SBSimpleRouter shareRouter].delegate routeDidCalled:routeUrl.url andResult:YES error:nil];
    }
}

- (void)handleBlockParams:(NSArray *)params response:(void(^)(id response,NSString *url,BOOL finished,NSError *error))response methodBlock:(id)methodBlock{
    id (^__methodBlock)(NSArray *params) = methodBlock;
    SBSimpleRouteUrl *routeUrl = [_routeUrl copy];
    id result = nil;
    if (__methodBlock) {
        if ([[SBSimpleRouter shareRouter].delegate respondsToSelector:@selector(routeCalling:params:)]) {
            [[SBSimpleRouter shareRouter].delegate routeCalling:routeUrl.url params:params];
        }
       result = __methodBlock(params);
    }else{
        if (response) {
            response(nil,routeUrl.url,NO,[NSError sb_errorWithDomain:@"自定义block未实现" code:SBSimpleRouteCustomBlockNotImplementationError userInfo:@{@"url":routeUrl.url}]);
            return;
        }
    }
    if (response) {
        response(result,routeUrl.url,YES,nil);
    }
    if ([[SBSimpleRouter shareRouter].delegate respondsToSelector:@selector(routeDidCalled:andResult:error:)]) {
        [[SBSimpleRouter shareRouter].delegate routeDidCalled:routeUrl.url andResult:YES error:nil];
    }
}

- (BOOL)params:(NSArray *)params isEqualOther:(NSArray *)other{
    if (params.count != other.count) {
        return NO;
    }
    
    return YES;
}
@end
