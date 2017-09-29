//
//  SBSimpleRouteUrl.m
//  BossCockpit
//
//  Created by qyb on 2017/7/25.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import "SBSimpleRouteUrl.h"

NSString *const _default_app_scheme = @"";
NSString *const __scheme_mark = @"://";
NSString *const __host_mark = @"#";
NSString *const __target_mark = @"?";
NSString *const __target_unit_mark = @"/";
NSString *const __param_unit_mark = @":";

@interface SBSRUrlParameter()<NSCopying>
@property (assign,nonatomic,readwrite) char returnType;
@property (strong,nonatomic,readwrite) NSArray *params;
@end

@implementation SBSRUrlParameter
+ (instancetype)parameterParse:(NSString *)parameter{
    SBSRUrlParameter *p = [SBSRUrlParameter new];
    p.returnType = [parameter characterAtIndex:0];
    NSString *temp = [parameter substringFromIndex:1];
    NSMutableArray *charArray = [NSMutableArray new];
    for (int i = 0; i < temp.length; i ++) {
        [charArray addObject:@([temp characterAtIndex:i])];
    }
    p.params = charArray.copy;
    return p;
}
#pragma mark - copy delegate
- (id)copyWithZone:(NSZone *)zone{
    SBSRUrlParameter *objc = [SBSRUrlParameter new];
    objc.returnType = _returnType;
    objc.params = _params.copy;
    return objc;
}
@end

@interface SBSRUrlHost()<NSCopying>
@property (copy,nonatomic,readwrite) NSString *host;
@property (strong,nonatomic,readwrite) NSArray *paths;
@end
@implementation SBSRUrlHost


+ (instancetype)targetParse:(NSString *)targets{
    SBSRUrlHost *target = [SBSRUrlHost new];
    target.host = targets;
    target.paths = [targets componentsSeparatedByString:__target_unit_mark];
    return target;
}
#pragma mark - copy delegate
- (id)copyWithZone:(NSZone *)zone{
    SBSRUrlHost *objc = [SBSRUrlHost new];
    objc.host = _host.copy;
    objc.paths = _paths.copy;
    return objc;
}
@end

@interface SBSimpleRouteUrl()<NSCopying>
@property (copy,nonatomic,readwrite) NSString *url;
@property (copy,nonatomic,readwrite) NSString *appScheme;
@property (copy,nonatomic,readwrite) NSString *action;
@property (strong,nonatomic,readwrite) SBSRUrlHost *host;
@property (strong,nonatomic,readwrite) SBSRUrlParameter *parameter;
@end
@implementation SBSimpleRouteUrl


- (instancetype)initUrl:(NSString *)url{
    if (self = [super init]) {
        _url = url.copy;
        if (![self parseUrl]) {
            return nil;
        }
    }
    return self;
}
#pragma mark - copy delegate
- (id)copyWithZone:(NSZone *)zone{
    SBSimpleRouteUrl *objc = [SBSimpleRouteUrl new];
    objc.url = _url.copy;
    objc.appScheme = _appScheme.copy;
    objc.host = _host.copy;
    objc.action = _action.copy;
    objc.parameter = _parameter.copy;
    return objc;
}
#pragma mark - parse
- (BOOL)parseUrl{
    if (_url.length == 0) {
        return NO;
    }
    NSArray *schemes = [_url componentsSeparatedByString:__scheme_mark];
    if (schemes.count == 2) {
        _appScheme = [schemes firstObject];
    }else _appScheme = _default_app_scheme;
    
    NSArray *hosts = [[schemes lastObject] componentsSeparatedByString:__host_mark];
    if (hosts.count != 2) {
        return NO;
    }
    _host = [self parseTarget:[hosts firstObject]];
    
    NSArray *actions = [[hosts lastObject] componentsSeparatedByString:__target_mark];
    
    _action = [actions firstObject];
    
    if (actions.count == 2) {
        _parameter = [SBSRUrlParameter parameterParse:[actions lastObject]];
    }
    return YES;
}
- (SBSRUrlHost *)parseTarget:(NSString *)targets{
    return [SBSRUrlHost targetParse:targets];
}
#pragma mark - write over
- (NSString *)appScheme{
    if (_appScheme.length == 0) {
        return _default_app_scheme;
    }
    return _appScheme;
}
@end
