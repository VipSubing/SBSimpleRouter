//
//  TestAotuViewController.m
//  路由
//
//  Created by qyb on 2017/9/27.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "TestAotuViewController.h"
#import "SBSimpleRouter.h"
@interface TestAotuViewController ()

@end

@implementation TestAotuViewController
+ (void)load{
    SBRouteAutoRegistWithHost(@"Test/TestAuto");
}
#pragma mark - 主动注册方法
- (void)playMusic__playMusicWithSource:(id)source{
    NSLog(@"playing music : %@",source);
}

- (int)addMethod__addNumber:(int)num other:(int)other{
    return num+other;
}
+ (void)inputMethod__inputName:(NSString *)name{
    NSLog(@"%@",name);
}
- (void(^)(NSString *msg))blockMethod__myBlock:(void(^)(NSString *msg))block :(void(^)(NSString *msg))block1{
    if (block) {
        block(@"我错了");
    }
    return nil;
}

@end
