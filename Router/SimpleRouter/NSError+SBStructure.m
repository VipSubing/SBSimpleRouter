//
//  NSError+SBStructure.m
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//
#import <objc/runtime.h>
#import "NSError+SBStructure.h"
#import "SBSimpleRouter.h"
@implementation NSError (SBStructure)


+ (instancetype)sb_errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(NSDictionary *)dict{
    NSError *error = [self errorWithDomain:domain code:code userInfo:dict];
    if (code < -10000 && code > -10100) {
        if ([[SBSimpleRouter shareRouter].delegate respondsToSelector:@selector(routeDidCalled:andResult:error:)]) {
            [[SBSimpleRouter shareRouter].delegate routeDidCalled:error.userInfo[@"url"] andResult:NO error:error];
        }
    }
    if ([SBSimpleRouter shareRouter].outputLog) {
        NSLog(@"SBSimpleRouterLog: %@",error);
    }
    return error;
}
@end
