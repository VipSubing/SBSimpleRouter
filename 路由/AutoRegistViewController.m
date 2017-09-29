//
//  AutoRegistViewController.m
//  路由
//
//  Created by qyb on 2017/9/27.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "AutoRegistViewController.h"
#import "SBSimpleRouter.h"
@interface AutoRegistViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation AutoRegistViewController
{
    NSArray *_datas;
    NSArray *_params;
    NSArray *_routes;
    id _callObject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自动注册";
    [self createTableView];
}

- (void)createTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.rowHeight = 50;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    _callObject = [[NSClassFromString(@"AutoRegistViewController") alloc] init];
    //UI目录名称
    _datas = @[@"instance 打印单一参数:playMusic",@"instance 输入2个int值然后相加 输入和:addMethod",@"class 类方法log 测试:inputName",@"instance block 作为参数:testBlock"];
    _params = @[@[@"我是iOSer"],@[@101,@12],@[@"你好，hello!"],@[^(NSString *msg){
        NSLog(@"1%@",msg);
    },^(NSString *msg){
        NSLog(@"2%@",msg);
    }]];
    _routes = @[@"Test/TestAuto#playMusic",@"Test/TestAuto#addMethod",@"Test/TestAuto#inputMethod",@"Test/TestAuto#blockMethod"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pb"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pb"];
    }
    cell.textLabel.text = _datas[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *title = _datas[indexPath.row];
    if ([title hasPrefix:@"class"]) {
        id result = [[SBSimpleRouter shareRouter] callActionRequest:_routes[indexPath.row] params:_params[indexPath.row]];
        if (result) NSLog(@"返回: %@",result);
        
    }else if ([title hasPrefix:@"instance"]){
        id result = [_callObject callActionRequest:_routes[indexPath.row] params:_params[indexPath.row]];
        if (result) NSLog(@"返回: %@",result);
    }
    
}

@end
