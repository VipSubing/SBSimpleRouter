//
//  RouteUrlTest.m
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBSimpleRouteUrl.h"
@interface RouteUrlTest : XCTestCase
@property (strong,nonatomic) SBSimpleRouteUrl *url;
@end

@implementation RouteUrlTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testIn{
    SBSimpleRouteUrl *url = [[SBSimpleRouteUrl alloc] initUrl:@"SB/Test#test?vcB"];
    XCTAssert(url);
    XCTAssert(url.action.length);
    XCTAssertEqualObjects(url.host.host,@"SB/Test",@"");
    XCTAssert(url.host.paths.count);
    NSArray *arrayPath = @[@"SB",@"Test"];
    XCTAssert([url.host.paths isEqualToArray:arrayPath]);
    XCTAssert(url.parameter.params.count);
    NSArray *params = @[[NSNumber numberWithChar:'c'],[NSNumber numberWithChar:'B']];
    XCTAssert([url.parameter.params isEqualToArray:params]);
    XCTAssert(url.parameter.returnType == 'v');
}
- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
