//
//  SBSimpleRouteEvent.h
//  BossCockpit
//
//  Created by qyb on 2017/7/26.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSimpleRouteUrl.h"
#import "SBSReceiveObject.h"
#import "SBSMethodObject.h"
#import "NSError+SBStructure.h"
@interface SBSimpleRouteEvent : NSObject
@property (strong,nonatomic,readonly) SBSReceiveObject *receive;
@property (strong,nonatomic,readonly) SBSMethodObject *method;
@property (strong,nonatomic,readonly) SBSimpleRouteUrl *routeUrl;
@property (copy,nonatomic,readonly) id (^handleBlock)(NSArray *params);

@property (strong,nonatomic,readonly) NSArray *params;
@property (copy,nonatomic,readonly) void(^response)(id response,NSString *url,BOOL finished,NSError *error);

- (instancetype)initWithReceiveObject:(SBSReceiveObject *)object method:(SBSMethodObject *)method routeUrl:(SBSimpleRouteUrl *)routeUrl;
- (void)handleEventParams:(NSArray *)params response:(void(^)(id response,NSString *url,BOOL finished,NSError *error))response;
@end
