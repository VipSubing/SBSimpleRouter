//
//  SBSimpleRouter.h
//  BossCockpit
//
//  Created by qyb on 2017/7/25.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSReceiveObject.h"
#import "SBSMethodObject.h"
#import "NSObject+SBSimpleRoute.h"
#import "NSError+SBStructure.h"
#import "SBSimpleRouteDelegate.h"

#define OpenAutoRegist 1
//自动注册宏方法
#define SBRouteAutoRegistWithHost(host) [[SBSimpleRouter shareRouter] autoRegistWithClass:self ahost:host];

extern NSString *const __system_open_service;


@interface SBSimpleRouter : NSObject
//最大 event 缓存 数量 default 5
@property (assign,nonatomic) NSInteger cacheMaxCount;
// route delegate  实现可监听方法调用
@property (weak,nonatomic) id <SBSimpleRouteDelegate> delegate;
//是否输出日志 默认 YES
@property (assign,nonatomic) BOOL outputLog;
+ (instancetype)shareRouter;


/**
 自动注册

 @param sclass class
 @param host host
 */
- (void)autoRegistWithClass:(Class)sclass ahost:(NSString *)host;
/**
 注册一条自定义路径

 @param customBlock 自定义block
 @param route 路径
 */
- (void)registHandleBlock:(id (^)(NSArray *params))customBlock forFullRoute:(NSString *)route;

/**
 注册一个响应对象

 @param object 响应对象
 @param route 路径
 */
- (void)registObject:(SBSReceiveObject *)object forRoute:(NSString *)route;

/**
 路径调用  返回值为当前函数返回值

 @param request 路径
 @param params 参数
 @return 被调用函数的返回值
 */
- (id)callActionRequest:(NSString *)request params:(NSArray *)params;

/**
 路径调用  block形式返回值

 @param request 路径
 @param params 参数
 @param response 调用结果 用block返回
 */
- (void)callActionRequest:(NSString *)request params:(NSArray *)params response:(void(^)(id response,NSString *url,BOOL success,NSError *error))response;
@end
