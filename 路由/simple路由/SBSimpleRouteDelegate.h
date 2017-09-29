//
//  SBSimpleRouteDelegate.h
//  路由
//
//  Created by qyb on 2017/8/5.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SBSimpleRouteDelegate <NSObject>

/**
 路由将要调用

 @param url 路由地址
 @param params 参数
 @return 返回 NO则拦截该路由调用
 */
- (BOOL)routeShouldCalled:(NSString *)url params:(NSArray *)params;

/**
 路由正在调用

 @param url url
 @param params 参数
 */
- (void)routeCalling:(NSString *)url params:(NSArray *)params;

/**
 路由调用完成

 @param url url
 @param result 调用成功与否
 @param error 错误信息
 */
- (void)routeDidCalled:(NSString *)url andResult:(BOOL)result error:(NSError *)error;


@end
