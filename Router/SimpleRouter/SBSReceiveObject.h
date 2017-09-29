//
//  SBSReceiveObject.h
//  路由
//
//  Created by qyb on 2017/7/27.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SBSMethodObject;

/**
 可以看成一个消息接收对象  该对象是你实体类的映射  包含所需要的路由的方法列表
 */
@interface SBSReceiveObject : NSObject
@property (copy,nonatomic,readonly) NSString *hostUrl;
@property (copy,nonatomic,readonly) NSString *Class;

@property (weak,nonatomic) id highObjc;
@property (strong,nonatomic,readonly) NSDictionary * methodList;
//class 实例
- (id)sb_class;
// instance 实例
- (id)sb_instance;

/**
 构造一个接收对象

 @param class 类名
 @param hostUrl 对象体制 exmple: Me/Setting/Login
 @return SBSReceiveObject Instance
 */
+ (instancetype)initWithClass:(NSString *)class hostUrl:(NSString *)hostUrl;

/**
 构造一个接受对象

 @param class 类名
 @param hostUrl 对象体制 exmple: Me/Setting/Login
 @param methodList 方法列表 dict :@{key:SBSMethodObject instance} key:route路径的@部分  SBSMethodObject:对象
 @return SBSReceiveObject Instance
 */
+ (instancetype)initWithClass:(NSString *)class hostUrl:(NSString *)hostUrl methodList:(NSDictionary *)methodList;

/**
 添加一个方法

 @param method SBSMethodObject instance
 @param key key
 */
- (void)addMethod:(SBSMethodObject *)method forKey:(NSString *)key;

/**
 获取方法实例 SBSMethodObject instance

 @param key key
 @return SBSMethodObject instance
 */
- (SBSMethodObject *)methodForKey:(NSString *)key;

/**
 添加多个方法 用dict的方式

 @param methodList 方法列表 dict :@{key:SBSMethodObject instance} key:route路径的@部分  SBSMethodObject:对象
 */
- (void)addMethods:(NSDictionary *)methodList;

/**
 方法列表元素个数

 @return 个数
 */
- (NSInteger)methodsCount;
@end
