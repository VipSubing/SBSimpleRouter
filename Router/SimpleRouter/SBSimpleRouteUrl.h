//
//  SBSimpleRouteUrl.h
//  BossCockpit
//
//  Created by qyb on 2017/7/25.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SBSRUrlParameter : NSObject
@property (assign,nonatomic,readonly) char returnType;
@property (strong,nonatomic,readonly) NSArray *params;
@end


@interface SBSRUrlHost : NSObject
@property (copy,nonatomic,readonly) NSString *host;
@property (strong,nonatomic,readonly) NSArray *paths;
+ (instancetype)targetParse:(NSString *)targets;
@end

@interface SBSimpleRouteUrl : NSObject
@property (copy,nonatomic,readonly) NSString *url;
@property (copy,nonatomic,readonly) NSString *appScheme;
@property (copy,nonatomic,readonly) NSString *action;
@property (strong,nonatomic,readonly) SBSRUrlHost *host;
@property (strong,nonatomic,readonly) SBSRUrlParameter *parameter;
- (instancetype)initUrl:(NSString *)url;

@end
