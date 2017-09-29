//
//  SBSimpleEventQueue.h
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SBSimpleRouteEvent;
@interface SBSimpleEventQueue : NSObject

- (instancetype)initWithMax:(NSInteger)max;

- (void)addEventToTop:(SBSimpleRouteEvent *)event;

- (SBSimpleRouteEvent *)eventForUrl:(NSString *)url;

- (void)setMax:(NSInteger)max;
@end
