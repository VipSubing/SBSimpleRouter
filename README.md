# SBSimpleRouter  简洁优雅的路由管理
   
## Overview

SBSimpleRouter使用主要分为两部<br>
第一步——注册，相比传统的路由注册方式，它扩展的几个更方便的注册方式，包括自动注册，自定义注册<br>
第二步——调用，调用方式包括对象调用和非对象调用。

## Route Format (路由格式:host#action?params)

首先，在注册和调用之前，我们介绍路由格式的定义，这非常重要。<br>
简单的格式是这样的 ：host#action?params，非常的清晰简洁，

* host,理解为业务模块或者功能逻辑的简单规划，For example,它看起来应该是这样的：UserCenter/login 用'/'层叠递进，我对它的定义是:用户中心的登录业务模块<br>

* action,理解为调用的事件，应当是抽象化的，For example,承接上面的login模块，假设这个模块有一个loginWithAcount:Password:的方法，可以完成
提供账号密码在服务器返回登录验证的事件，它看起来应该是这样的 #callLogin，定义是调起登录,其中#是事件前缀,callLogin是抽象的事件名称<br>

* params,理解为参数格式，请注意它只是约定格式的抽象字符形式，千万不要在这里传入你真正的参数,还有记住第一个参数符号是方法的返回值类型，所以注册一个方法，那么它的参数字符串是>=1,因为必须有一个 reurnType。For example,还是承接上面的login，在#callLogin这个事件上,登录操作往往会是异步回调，所以这里我们需要传入一个 returnType 是 void ，在路由格式里面它是v,还有两个参数，acount password,他们都是字符串类型，所以params会是这样的:?v@@,其中'?'是参数类型前缀,@代表一个对象类型。

* final，总结下来一个完整的路由是这样子的,<br>
UserCenter/login#callLogin?v@@   调用在用户登录模块的callLogin事件，返回类型是v,参数类型是@@.

### 关于param 的类型标记

* 1.对象类型包括block ,一律用 @符号表示。<br>
* 2.原始类型，比如,int = i,float = f ,double = d 这与 runtime里面所定义的参数类型是一致的。<br>
* 3.void  = v.<br>
* 4.typeof structure 结构体需要转化成 对象类型，所以是 @.<br>


## Regist 注册
### 一般概念
注册分为3种样式，在一一介绍介绍3种样式之前，我们先要了解注册的一般概念和结构。<br>

* 概念，我们可以把一对注册和调用的相互关系看成是value-key,注册比喻为 setObject:forKey:, 调用比喻为  objectForKey:,当然的，注册必须发生在调用之前，否则会有无用的调用。<br>

* 结构，注册是对象化的操作，注册的模块一般是一个类，它被作为一个接收对象(receiveObject)，放在注册表里，route代表它对应的key.receiveObject包含一个methodList,methodList是方法的集合，receiveObject注册的方法都存在里面，#action作为这个method的key.它看起来是这样的,<br>
#### ![image](https://github.com/pubin563783417/SBSimpleRouter/blob/master/Screenshot/route结构.png)


### 手动注册
首先创建执行对象ReceiveObject，然后为ReceiveObject添加 method ,最后把ReceiveObject加入注册表,下面是一个完整的展示，
``` objc
//第一步 创建 方法执行对象 SBSReceiveObject 如下：TestViewController  一般为类名    Test/TestVC 业务模块/具体业务或功能抽象名称
    SBSReceiveObject *object = [SBSReceiveObject initWithClass:@"TestViewController" hostUrl:@"Test/Mock_Object"];
    //第二步 添加 方法对象
    [object addMethod:[SBSMethodObject instanceMethodName:@"playMusicWithSource:" parameter:@"v@"] forKey:@"playMusic"];
    [object addMethod:[SBSMethodObject instanceMethodName:@"addNumber:other:" parameter:@"iii"] forKey:@"addMethod"];
    //字典添加
    [object addMethods:@{@"inputName":[SBSMethodObject classMethodName:@"inputName:" parameter:@"v@"],@"testBlock":[SBSMethodObject instanceMethodName:@"myBlock:" parameter:@"v@"]}];
    //第三步 提交注册 注意不要注册 相同路径 hostURL的对象 后一个会覆盖前一个
    [[SBSimpleRouter shareRouter] registObject:object forRoute:object.hostUrl];
```

### 自动注册
自动注册，顾名思义不需要你一个对象一个对象那样添加，只需要在目标类里面做一些特殊的操作即可，像这样，
 
``` objc
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
```


首先在+ load 方法里面需要加入宏方法，参数为 目标路径host  SBRouteAutoRegistWithHost(@"Test/TestAuto")。

然后就是你需要注册的方法了，'__'双下划线作为一个特殊标记位，在它前面定义为method的key,它的结构是这样的  method__... ,多双下滑下函数名称是不被允许的。

就这样，我们在上面我们注册了4个方法。他们看齐来非常简洁.


### 自定义注册

自定义注册是一个特殊的注册扩展，它看起来像一个block,确实是这样，只需要提供一个自定义的block，再有一个特定的route即可。它看起来是这样的，

``` objc
//拨电话
    [[SBSimpleRouter shareRouter] registHandleBlock:^id(NSArray *params) {
        NSString *phone = [NSString stringWithFormat:@"tel://%@",params.firstObject];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:phone]];
        return nil;
    } forFullRoute:@"Test/CustomTest#call?v@"];
```
在上面，我自定义注册了一个系统拨号的方法，它看起来也很简单。

## 调用

相比与注册，调用有两种方式，对象调用和block调用。

###  对象调用
对于注册类型为实例方法 ，也就是 '-'的方法（）
``` objc
- (BOOL)playMusicWithSource:(id)source;
```
，一般选择对象调用的方式，像这样，
直接返回，
``` objc
BOOL playSuccess = [object callActionRequest:routeUrl params:@"http://musicUrl"];
``` 
block返回,
``` objc
[object callActionRequest:routeUrl params:@"http://musicUrl" response:^(id response, NSString *url, BOOL success, NSError *error){
	nslog(@"response : %@",response);
}];
```

routeUrl:路由
params:参数，这里是实际上的参数。像上面传入一个 URL播放地址。

### block 调用 

对于注册类型为类方法('+')，或者自定义注册的方法
``` objc
+ (void)inputName:(NSString *)name;
```
一般选择这种调用方式，
直接返回，
``` objc
[[SBSimpleRouter shareRouter] callActionRequest:routeUrl params:@"subing"];
```
block返回,
``` objc
[[SBSimpleRouter shareRouter] callActionRequest:routeUrl params:@"subing" response:^(id response, NSString *url, BOOL success, NSError *error){
	nslog(@"response : %@",response);
}];
```

## License
MIT
