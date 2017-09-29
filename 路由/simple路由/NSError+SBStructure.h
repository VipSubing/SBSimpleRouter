//
//  NSError+SBStructure.h
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SBSimpleRouteAccessError) {
    SBSimpleRouteFormatError = - 10001,
    SBSimpleRouteHostNotFindError = - 10002,
    SBSimpleRouteActionNotFindError = - 10003,
    SBSimpleRouteMethodNotFindError = - 10004,
    SBSimpleRouteParameterError = - 10005,
    SBSimpleRouteReturnTypeError = - 10006,
    SBSimpleRouteCustomBlockNotImplementationError = - 10006,
    SBSimpleRouteInitiativeInterceptError = - 10007,
    SBSimpleRouteOtherError = - 10099,
};

@interface NSError (SBStructure)
+ (instancetype)sb_errorWithDomain:(NSErrorDomain)domain code:(NSInteger)code userInfo:(NSDictionary *)dict;
@end
