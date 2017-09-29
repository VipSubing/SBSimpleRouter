//
//  SBSRouteObejct.m
//  路由
//
//  Created by qyb on 2017/8/7.
//  Copyright © 2017年 qyb. All rights reserved.
//
#import <objc/runtime.h>
#import "SBSRAutoRegistModel.h"

NSString *const kMethodKeyCharacterTag = @"__";

@implementation SBSRAutoRegistModel

- (void)setHost:(NSString *)host{
    _host = host;
    if (host.length == 0) {
        _host = _className;
    }
}

+ (instancetype)fetchInstanceMethodListToClass:(Class)sClass host:(NSString *)host{
    NSAssert(sClass, @"提供nil的class");
    SBSRAutoRegistModel *model = [SBSRAutoRegistModel new];
    model.className = [NSString stringWithCString:class_getName(sClass) encoding:NSUTF8StringEncoding];
    model.host = host;
    
    //对象方法
    unsigned int methodCount;
    Method *objc_methodList = class_copyMethodList(sClass, &methodCount);
    //instanceMethodNames
    NSMutableArray *instanceMethodNames = [NSMutableArray new];
    NSMutableArray *instanceMethodKeys = [NSMutableArray new];
    NSMutableArray *instanceMethodParams = [NSMutableArray new];
    for (int i = 0; i < methodCount; i++) {
        Method method = objc_methodList[i];
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
        NSUInteger location = [methodName rangeOfString:kMethodKeyCharacterTag].location;
        if (location != NSNotFound) {
            [instanceMethodNames addObject:methodName];
            NSString *methodKey = [methodName substringWithRange:NSMakeRange(0, location)];
            NSAssert(methodKey.length, @"你必须为你的公共方法定一个Key 在__之前");
            [instanceMethodKeys addObject:methodKey];
            NSMutableString *params = [NSMutableString new];
            char * returnTypes = method_copyReturnType(method);
            [params appendString:[[NSString stringWithUTF8String:returnTypes] stringByReplacingOccurrencesOfString:@"?" withString:@""]];
            free(returnTypes);
            unsigned int methodCount = method_getNumberOfArguments(method);
            for (int i = 2; i < methodCount; i ++) {
                char * args = method_copyArgumentType(method, i);
                NSString *args_format = [NSString stringWithUTF8String:args];
                args_format = [args_format stringByReplacingOccurrencesOfString:@"?" withString:@""];
                [params appendString:args_format];
                free(args);
            }
            [instanceMethodParams addObject:params.copy];
        }
    }
    model.instanceMethodNames = instanceMethodNames.copy;
    model.instanceMethodKeys = instanceMethodKeys.copy;
    model.instanceMethodParams = instanceMethodParams.copy;
    
    //类方法
    [instanceMethodParams removeAllObjects];
    [instanceMethodKeys removeAllObjects];
    [instanceMethodNames removeAllObjects];
    free(objc_methodList);
    id meteClass = objc_getMetaClass([model.className UTF8String]);
    Method *class_methodList = class_copyMethodList(meteClass, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        Method method = class_methodList[i];
        NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
        NSUInteger location = [methodName rangeOfString:kMethodKeyCharacterTag].location;
        if (location != NSNotFound) {
            [instanceMethodNames addObject:methodName];
            NSString *methodKey = [methodName substringWithRange:NSMakeRange(0, location)];
            NSAssert(methodKey.length, @"你必须为你的公共方法定一个Key 在__之前");
            [instanceMethodKeys addObject:methodKey];
            NSMutableString *params = [NSMutableString new];
            char * returnTypes = method_copyReturnType(method);
            [params appendString:[[NSString stringWithUTF8String:returnTypes] stringByReplacingOccurrencesOfString:@"?" withString:@""]];
            free(returnTypes);
            unsigned int methodCount = method_getNumberOfArguments(method);
            for (int i = 2; i < methodCount; i ++) {
                char * args = method_copyArgumentType(method, i);
                NSString *args_format = [NSString stringWithUTF8String:args];
                args_format = [args_format stringByReplacingOccurrencesOfString:@"?" withString:@""];
                [params appendString:args_format];
                free(args);
            }
            [instanceMethodParams addObject:params.copy];
        }
    }
    model.classMethodNames = instanceMethodNames.copy;
    model.classMethodKeys = instanceMethodKeys.copy;
    model.classMethodParams = instanceMethodParams.copy;
    free(class_methodList);
    return model;
}

@end
