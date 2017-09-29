//
//  CustomRegistViewController.m
//  路由
//
//  Created by qyb on 2017/9/27.
//  Copyright © 2017年 qyb. All rights reserved.
//
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomRegistViewController.h"
#import "SBSimpleRouter.h"
@interface CustomRegistViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@end

@implementation CustomRegistViewController
{
    void (^_imageHandle)(UIImage *image);
    NSArray *_datas;
    NSArray *_params;
    NSArray *_routes;
    id _callObject;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义注册";
    // Do any additional setup after loading the view.
    [self registRoute];
    [self createTableView];
}
- (void)registRoute{
    //拨电话
    [[SBSimpleRouter shareRouter] registHandleBlock:^id(NSArray *params) {
        NSString *phone = [NSString stringWithFormat:@"tel://%@",params.firstObject];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phone]];
        return nil;
    } forFullRoute:@"Test/CustomTest#call?v@"];
    //调用系统相机
    __weak typeof(self) weak = self;
    [[SBSimpleRouter shareRouter] registHandleBlock:^id(NSArray *params) {
        void (^handle)(UIImage *image)  = params.firstObject;
        _imageHandle = handle;
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = weak;
        imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.videoMaximumDuration = 15;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
        
        //设置摄像头模式（拍照，录制视频）为录像模式
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [weak presentViewController:imagePickerController animated:YES completion:nil];
        return nil;
    } forFullRoute:@"Test/CustomTest#camera?v@"];
}
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"image:%@",image);
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (_imageHandle) {
        _imageHandle(image);
    }
}
#pragma mark - UI
- (void)createTableView{
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.rowHeight = 50;
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    _callObject = [[NSClassFromString(@"AutoRegistViewController") alloc] init];
    //UI目录名称
    _datas = @[@"class 调用拨号",@"class 调用系统相机"];
    _params = @[@[@"110"],@[^(UIImage *image){
        NSLog(@"image: %@",image);
    }]];
    _routes = @[@"Test/CustomTest#call",@"Test/CustomTest#camera"];
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
