//
//  TestViewController.m
//  路由
//
//  Created by qyb on 2017/9/26.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - 主动注册方法 
- (void)playMusicWithSource:(id)source{
    NSLog(@"playing music : %@",source);
}

- (int)addNumber:(int)num other:(int)other{
    return num+other;
}
+ (void)inputName:(NSString *)name{
    NSLog(@"%@",name);
}
- (void)myBlock:(void(^)(NSString *msg))block{
    if (block) {
        block(@"我错了");
    }
}

@end
