//
//  SBSMethodObject.m
//  路由
//
//  Created by qyb on 2017/7/27.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "SBSMethodObject.h"
#import "SBSRAutoRegistModel.h"
@interface SBSMethodObject()<NSCopying>
@property (copy,nonatomic,readwrite) NSString *key;
@property (assign,nonatomic,readwrite) NSUInteger methodType;
@property (copy,nonatomic,readwrite) NSString *methodName;
@property (copy,nonatomic,readwrite) NSString *parameter;
@property (copy,nonatomic,readwrite) id methodBlock;
@property (strong,nonatomic,readwrite) NSArray *params;
@property (assign,nonatomic,readwrite) char returnType;
@end
@implementation SBSMethodObject

- (instancetype)initWithMethodType:(NSUInteger)methodType methodName:(NSString *)methodName parameter:(NSString *)parameter{
    if (self = [super init]) {
        _methodType = methodType;
        _methodName = methodName;
        _parameter = parameter;
        [self parseParams:_parameter];
    }
    return self;
}

- (void)parseParams:(NSString *)parameter{
    if (_methodType != 2) {
        NSAssert(parameter.length, @"参数格式有误");
    }else{
        _returnType = '@';
        _params = @[];
        return;
    }
    NSAssert(parameter.length, @"非block Method必须包含一个参数 returnType");
#if DEBUG
    int charCount = 0;
    for (int i = 0; i < _methodName.length; i ++) {
        unichar c = [_methodName characterAtIndex:i];
        if (c == ':') {
            charCount ++;
        }
    }
    NSAssert(charCount == parameter.length-1, @"函数名称必须与实际名称想匹配，且参数个数也必须相符,符号 : 的错误");
#endif
    _returnType = [parameter characterAtIndex:0];
    NSString *temp = [parameter substringFromIndex:1];
    NSMutableArray *charArray = [NSMutableArray new];
    for (int i = 0; i < temp.length; i ++) {
        [charArray addObject:@([temp characterAtIndex:i])];
    }
    _params = charArray.copy;
}
#pragma mark - copy delegate
- (id)copyWithZone:(NSZone *)zone{
    SBSMethodObject *objc = [SBSMethodObject new];
    objc.methodType = _methodType;
    objc.methodName = _methodName.copy;
    NSMutableArray *params = [NSMutableArray new];
    for (id p in _params) {
        [params addObject:[p copy]];
    }
    if (_methodBlock) {
        objc.methodBlock = [_methodBlock copy];
    }
    objc.params = params.copy;
    objc.parameter = _parameter.copy;
    objc.returnType = _returnType;
    
    return objc;
}
#pragma mark - public
- (void)setMethodBlock:(id)methodBlock{
    _methodBlock = methodBlock;
}
+ (instancetype)classMethodName:(NSString *)methodName{
    SBSMethodObject *method = [[self alloc] initWithMethodType:1 methodName:methodName parameter:nil];
    return method;
}
+ (instancetype)classMethodName:(NSString *)methodName parameter:(NSString *)parameter{
    SBSMethodObject *method = [[self alloc] initWithMethodType:1 methodName:methodName parameter:parameter];
    return method;
}
+ (instancetype)instanceMethodName:(NSString *)methodName{
    SBSMethodObject *method = [[self alloc] initWithMethodType:0 methodName:methodName parameter:nil];
    return method;
}
+ (instancetype)instanceMethodName:(NSString *)methodName parameter:(NSString *)parameter{
    SBSMethodObject *method = [[self alloc] initWithMethodType:0 methodName:methodName parameter:parameter];
    return method;
}
+ (instancetype)blockMethodName:(NSString *)methodName{
    SBSMethodObject *method = [[self alloc] initWithMethodType:2 methodName:methodName parameter:nil];
    return method;
}
+ (instancetype)blockMethodName:(NSString *)methodName parameter:(NSString *)parameter{
    SBSMethodObject *method = [[self alloc] initWithMethodType:2 methodName:methodName parameter:parameter];
    return method;
}
+ (NSDictionary *)instanceMethodListWithAutoRegist:(SBSRAutoRegistModel *)regist{
    if (!regist.instanceMethodKeys.count) {
        return nil;
    }
    NSMutableDictionary *methodDict = [NSMutableDictionary new];
    [regist.instanceMethodKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *parameter = regist.instanceMethodParams[idx];
        NSString *methodName = regist.instanceMethodNames[idx];
        SBSMethodObject *method = [self instanceMethodName:methodName parameter:parameter];
        method.key = key;
        [methodDict setObject:method forKey:key];
    }];
    return methodDict.copy;
}
+ (NSDictionary *)classMethodListWithAutoRegist:(SBSRAutoRegistModel *)regist{
    if (!regist.classMethodKeys.count) {
        return nil;
    }
    NSMutableDictionary *methodDict = [NSMutableDictionary new];
    [regist.classMethodKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *parameter = regist.classMethodParams[idx];
        NSString *methodName = regist.classMethodNames[idx];
        SBSMethodObject *method = [self classMethodName:methodName parameter:parameter];
        method.key = key;
        [methodDict setObject:method forKey:key];
    }];
    return methodDict.copy;
}
@end
