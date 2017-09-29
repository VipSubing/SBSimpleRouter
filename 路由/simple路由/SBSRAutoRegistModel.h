//
//  SBSRouteObejct.h
//  路由
//
//  Created by qyb on 2017/8/7.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBSRAutoRegistModel : NSObject
@property (copy,nonatomic) NSString *className;
@property (copy,nonatomic) NSString *host;
@property (strong,nonatomic) NSArray *classMethodNames;
@property (strong,nonatomic) NSArray *classMethodParams;
@property (strong,nonatomic) NSArray *classMethodKeys;
@property (strong,nonatomic) NSArray *instanceMethodNames;
@property (strong,nonatomic) NSArray *instanceMethodParams;
@property (strong,nonatomic) NSArray *instanceMethodKeys;

+ (instancetype)fetchInstanceMethodListToClass:(Class)sClass host:(NSString *)host;
@end
