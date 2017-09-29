//
//  SBSMethodObject.h
//  路由
//
//  Created by qyb on 2017/7/27.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SBSRAutoRegistModel;
@interface SBSMethodObject : NSObject
@property (copy,nonatomic,readonly) NSString *key;
@property (assign,nonatomic,readonly) NSUInteger methodType; //方法类型:  - 0  +  1 b 2
@property (copy,nonatomic,readonly) NSString *methodName; //方法名: init
@property (copy,nonatomic,readonly) NSString *parameter; //参数: :i:s:f:id 参数类型，顺序 第一个为返回值参数  必填
@property (copy,nonatomic,readonly) id methodBlock;
@property (strong,nonatomic,readonly) NSArray *params;
@property (assign,nonatomic,readonly) char returnType;


- (instancetype)initWithMethodType:(NSUInteger)methodType methodName:(NSString *)methodName parameter:(NSString *)parameter;

+ (instancetype)classMethodName:(NSString *)methodName parameter:(NSString *)parameter;

+ (instancetype)instanceMethodName:(NSString *)methodName parameter:(NSString *)parameter;

+ (instancetype)blockMethodName:(NSString *)methodName;

- (void)setMethodBlock:(id)methodBlock;

+ (NSDictionary *)instanceMethodListWithAutoRegist:(SBSRAutoRegistModel *)regist;
+ (NSDictionary *)classMethodListWithAutoRegist:(SBSRAutoRegistModel *)regist;
@end
