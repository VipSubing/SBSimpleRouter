//
//  SBSimpleEventQueue.m
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "SBSimpleEventQueue.h"
#import "SBSimpleRouteEvent.h"

#define Lock() dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(_globalInstancesLock)


@implementation SBSimpleEventQueue
{
    NSMutableArray *_eventQueue;
    NSInteger _max;
    dispatch_semaphore_t _globalInstancesLock;
}
- (instancetype)initWithMax:(NSInteger)max{
    if (self = [super init]) {
        _globalInstancesLock = dispatch_semaphore_create(1);
        _eventQueue = [NSMutableArray new];
        _max = max;
    }
    return self;
}
#pragma mark - public
- (void)setMax:(NSInteger)max{
    _max = max;
    [self automaticallyBuildCount];
}
- (void)automaticallyBuildCount{
    Lock();
    if (_eventQueue.count>_max) {
        for (NSInteger i = _eventQueue.count-1; i >= _max ; i --) {
            [_eventQueue removeObjectAtIndex:i];
        }
    }
    Unlock();
}
- (void)addEventToTop:(SBSimpleRouteEvent *)event{
    if (!event || _max == 0) return;
    Lock();
    [_eventQueue insertObject:event atIndex:0];
    Unlock();
    [self automaticallyBuildCount];
}
- (SBSimpleRouteEvent *)eventForUrl:(NSString *)url{
    if (_eventQueue.count == 0) return nil;
    
    NSInteger index = 0;
    for (SBSimpleRouteEvent *event in _eventQueue) {
        if ([event.routeUrl.url isEqualToString:url]) {
            [self moveToQueueTop:event index:index];
            return event;
        }
        index ++;
    }
    return nil;
}
#pragma mark - private
- (void)moveToQueueTop:(SBSimpleRouteEvent *)event index:(NSInteger)index{
    Lock();
    [_eventQueue removeObjectAtIndex:index];
    [_eventQueue insertObject:event atIndex:0];
    Unlock();
}
@end
