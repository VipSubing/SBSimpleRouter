//
//  EventTest.m
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBSimpleRouteEvent.h"
#import "SBSimpleRouter.h"
@interface EventTest : XCTestCase
@property (strong,nonatomic) SBSimpleRouteEvent *event;
@end

@implementation EventTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    SBSReceiveObject *receive = [SBSReceiveObject initWithClass:@"TestViewController" hostUrl:@"Test"];
    SBSMethodObject *method = [SBSMethodObject classMethodName:@"classAddOne:two:" parameter:@"fff"];
    [receive addMethod:method forKey:@"test"];
    SBSimpleRouteUrl *url = [[SBSimpleRouteUrl alloc] initUrl:@"Test#test"];
    _event = [[SBSimpleRouteEvent alloc] initWithReceiveObject:receive method:method routeUrl:url];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [_event handleEventParams:@[@(12.f),@(22.f)] response:^(id response, NSString *url, BOOL finished, NSError *error) {
        XCTAssert(!error);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
