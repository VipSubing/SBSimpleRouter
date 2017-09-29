//
//  RootViewController.m
//  路由
//
//  Created by qyb on 2017/9/26.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "RootViewController.h"
#import "SBSimpleRouter.h"
@interface RootViewController ()

@end

@implementation RootViewController
{
    NSArray *_classs;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"sbsimplerouter";
    [self createNavigation];
    _classs = @[@"ManualRegistViewController",@"AutoRegistViewController",@"CustomRegistViewController"];
}

- (void)createNavigation{
    NSArray *titles = @[@"手动注册方法调用",@"自动注册方法调用",@"自定义方法注册",@"路由跳转"];
    
    for (int i = 0; i < titles.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 50+60*i, [UIScreen mainScreen].bounds.size.width, 60)];
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 1.f;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(navigation:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}
- (void)navigation:(UIButton *)btn{
    
    if (btn.tag-100 < _classs.count) {
        Class class = NSClassFromString(_classs[btn.tag - 100]);
        UIViewController *vc = [[class alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self registRoute];
        id target = [[SBSimpleRouter shareRouter] callActionRequest:@"Test/RouteViewController#initMethod" params:@[@"我是测试title"]];
        if (target) {
             [[SBSimpleRouter shareRouter] callActionRequest:@"Test/CustomTest#transition" params:@[target,@"push"]];
        }

    }
    
    
}
//这个方法注册了一个组合路由  两个部分组成 1，获取target  2.选择跳转方式
- (void)registRoute{
    
    __weak typeof(self) weak = self;
    //注册转场方法
    [[SBSimpleRouter shareRouter] registHandleBlock:^id(NSArray *params) {
        id target = [params firstObject];
        if ([params[1] isEqualToString:@"push"]) {
            [weak.navigationController pushViewController:target animated:YES];
        }else if ([params[1] isEqualToString:@"present"]){
            [weak presentViewController:target animated:YES completion:nil];
        }
        return nil;
    } forFullRoute:@"Test/CustomTest#transition?v@@"];
    //注册获取目标对象方法
    SBSReceiveObject *object = [SBSReceiveObject initWithClass:@"RouteViewController" hostUrl:@"Test/RouteViewController"];
    //第二步 添加 方法对象
    [object addMethod:[SBSMethodObject instanceMethodName:@"initWithTitle:" parameter:@"@@"] forKey:@"initMethod"];
    [[SBSimpleRouter shareRouter] registObject:object forRoute:object.hostUrl];
    
}

@end
