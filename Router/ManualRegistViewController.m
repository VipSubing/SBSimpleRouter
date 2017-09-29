//
//  ManualRegistViewController.m
//  路由
//
//  Created by qyb on 2017/9/26.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "ManualRegistViewController.h"
#import "SBSimpleRouter.h"
#import "YBPopupMenu.h"
@interface ManualRegistViewController ()<UITableViewDelegate,UITableViewDataSource,YBPopupMenuDelegate>

@end

@implementation ManualRegistViewController
{
    NSArray *_datas;
    NSArray *_params;
    NSArray *_routes;
    id _callObject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手动注册";
    [self registRoute];
    [self createTableView];
}

- (void)registRoute{
    //手动注册 分3步
    //第一步 创建 方法执行对象 SBSReceiveObject 如下：TestViewController  一般为类名    Test/TestVC 业务模块/具体业务或功能抽象名称
    SBSReceiveObject *object = [SBSReceiveObject initWithClass:@"TestViewController" hostUrl:@"Test/Mock_Object"];
    //第二步 添加 方法对象
    [object addMethod:[SBSMethodObject instanceMethodName:@"playMusicWithSource:" parameter:@"v@"] forKey:@"playMusic"];
    [object addMethod:[SBSMethodObject instanceMethodName:@"addNumber:other:" parameter:@"iii"] forKey:@"addMethod"];
    //字典添加
    [object addMethods:@{@"inputName":[SBSMethodObject classMethodName:@"inputName:" parameter:@"v@"],@"testBlock":[SBSMethodObject instanceMethodName:@"myBlock:" parameter:@"v@"]}];
    //第三步 提交注册 注意不要注册 相同路径 hostURL的对象 后一个会覆盖前一个
    [[SBSimpleRouter shareRouter] registObject:object forRoute:object.hostUrl];
    
    
    _callObject = [[NSClassFromString(@"TestViewController") alloc] init];
    //UI目录名称
    _datas = @[@"instance 打印单一参数:playMusic",@"instance 输入2个int值然后相加 输入和:addMethod",@"class 类方法log 测试:inputName",@"instance block 作为参数:testBlock"];
    _params = @[@[@"我是iOSer"],@[@101,@12],@[@"你好，hello!"],@[^(NSString *msg){
        NSLog(@"%@",msg);
    }]];
    _routes = @[@"Test/Mock_Object#playMusic",@"Test/Mock_Object#addMethod",@"Test/Mock_Object#inputName",@"Test/Mock_Object#testBlock"];
}

- (void)createTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.rowHeight = 50;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
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
