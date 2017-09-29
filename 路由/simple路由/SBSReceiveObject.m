//
//  SBSReceiveObject.m
//  路由
//
//  Created by qyb on 2017/7/27.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "SBSReceiveObject.h"
#import "SBSMethodObject.h"

#define methodsLock() dispatch_semaphore_wait(_globalInstancesLock, DISPATCH_TIME_FOREVER)
#define methodsUnlock() dispatch_semaphore_signal(_globalInstancesLock)



@interface SBSReceiveObject()
@property (copy,nonatomic,readwrite) NSString *hostUrl;
@property (copy,nonatomic,readwrite) NSString *Class;
@property (strong,nonatomic,readwrite) NSDictionary * methodList;
@end
@implementation SBSReceiveObject
{
    NSMutableDictionary *_methodTable;
    dispatch_semaphore_t _globalInstancesLock;
}

- (instancetype)init{
    if (self = [super init]) {
        _methodTable = [NSMutableDictionary new];
        _globalInstancesLock = dispatch_semaphore_create(1);
        //初始化两个默认的方法
        SBSMethodObject *instance = [SBSMethodObject classMethodName:@"new" parameter:@"@"];
        SBSMethodObject *class = [SBSMethodObject classMethodName:@"class" parameter:@"@"];
        [_methodTable setObject:instance forKey:@"instance"];
        [_methodTable setObject:class forKey:@"class"];
    }
    return self;
}

#pragma mark - public
- (id)sb_class{
    Class class = NSClassFromString(_Class);
    return class;
}
- (id)sb_instance{
    id instance = _highObjc;
    if (!instance) {
        Class class = [self sb_class];
        instance = [class alloc];
    }
    return instance;
}

+ (instancetype)initWithClass:(NSString *)class hostUrl:(NSString *)hostUrl{
    return [self initWithClass:class hostUrl:hostUrl methodList:nil];
}
+ (instancetype)initWithClass:(NSString *)class hostUrl:(NSString *)hostUrl methodList:(NSDictionary *)methodList{
    SBSReceiveObject *receive = [self new];
    receive.hostUrl = hostUrl;
    receive.Class = class;
    for (NSString *key in methodList.allKeys) {
        [receive addMethod:methodList[key] forKey:key];
    }
    return receive;
}
- (NSDictionary *)methodList{
    if (_methodTable) {
        return _methodTable.copy;
    }
    return nil;
}
- (void)addMethods:(NSDictionary *)methodList{
    if (!methodList.count) {
        return;
    }
    for (NSString *key in methodList.allKeys) {
        SBSMethodObject *method = methodList[key];
        [self addMethod:method forKey:key];
    }
}
- (void)addMethod:(SBSMethodObject *)method forKey:(NSString *)key{
    
    NSAssert([method isKindOfClass:[SBSMethodObject class]], @"字典对象应该为 SBSMethodObject对象");
    NSAssert(![key isEqualToString:@"class"], @"class 为初始化默认方法 不应该覆盖");
    NSAssert(![key isEqualToString:@"instance"], @"instance 为初始化默认方法 不应该覆盖");
    methodsLock();
    [_methodTable setObject:method forKey:key];
    methodsUnlock();
    
}

- (SBSMethodObject *)methodForKey:(NSString *)key{
    methodsLock();
    id objc = [_methodTable objectForKey:key];
    methodsUnlock();
    return objc;
}
- (NSInteger)methodsCount{
    if (_methodTable.count >= 2) {
        return _methodTable.count-2;
    }
    return 0;
}
@end
