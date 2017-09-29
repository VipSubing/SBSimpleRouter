//
//  ReceiveObjectTest.m
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBSReceiveObject.h"
#import "SBSMethodObject.h"
@interface ReceiveObjectTest : XCTestCase

@end

@implementation ReceiveObjectTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    SBSReceiveObject *receive1 = [SBSReceiveObject initWithClass:@"test" hostUrl:@"Test"];
    [receive1 addMethods:@{@"yangbo":[SBSMethodObject classMethodName:@"yangbo:de:" parameter:@"vcc"],@"lulu":[SBSMethodObject classMethodName:@"subing" parameter:@"v"]}];
    XCTAssert([receive1 methodsCount] == 2, @"");
    XCTAssert([receive1.Class isEqualToString:@"test"],@"");
    XCTAssert([receive1.hostUrl isEqualToString:@"Test"], @"");
    
    SBSReceiveObject *receive2 = [SBSReceiveObject initWithClass:@"ttest" hostUrl:@"SB/Test" methodList:@{@"lulu":[SBSMethodObject classMethodName:@"eeee" parameter:@"v"]}];
    [receive2 addMethod:[SBSMethodObject classMethodName:@"subing" parameter:@"v"] forKey:@"subing"];
    [receive2 addMethods:@{@"subing":[SBSMethodObject classMethodName:@"subing" parameter:@"v"]}];
    XCTAssert([receive2 methodsCount] == 2, @"");
    XCTAssert([receive2.Class isEqualToString:@"ttest"],@"");
    XCTAssert([receive2.hostUrl isEqualToString:@"SB/Test"], @"");
    
    SBSMethodObject *method = [receive2 methodForKey:@"lulu"];
    XCTAssert([method.methodName isEqualToString:@"eeee"]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
