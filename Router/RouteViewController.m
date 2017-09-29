//
//  RouteViewController.m
//  路由
//
//  Created by qyb on 2017/9/27.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "RouteViewController.h"

@interface RouteViewController ()

@end

@implementation RouteViewController
{
    UILabel *_label;
    NSString *_customTitle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"组合路由";
    // Do any additional setup after loading the view.
    _label = [UILabel new];
    _label.frame = CGRectMake(0, 64, self.view.bounds.size.width, 50);
    _label.textColor = [UIColor blackColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:20];
    _label.text = _customTitle;
    [self.view addSubview:_label];
}
- (instancetype)initWithTitle:(NSString *)title{
    if (self = [super init]) {
        _customTitle = title;
    }
    return self;
}
@end
