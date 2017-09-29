//
//  NSObject+SBSimpleRoute.h
//  路由
//
//  Created by qyb on 2017/7/31.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SBSimpleRoute)


/**
 向对象发起路径调用  如果该对象没有注册 那么返回错误 block形式返回值
 
 @param request 路径
 @param params 参数
 @param response 调用结果 用block返回
 */
- (void)callActionRequest:(NSString *)request params:(NSArray *)params response:(void(^)(id response,NSString *url,BOOL success,NSError *error))response;
/**
 路径调用  返回值为当前函数返回值
 
 @param request 路径
 @param params 参数
 @return 被调用函数的返回值
 */
- (id)callActionRequest:(NSString *)request params:(NSArray *)params;
@end
