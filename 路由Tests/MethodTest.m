//
//  MethodTest.m
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBSMethodObject.h"
@interface MethodTest : XCTestCase

@end

@implementation MethodTest

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
    SBSMethodObject *method1 = [SBSMethodObject instanceMethodName:@"test1" parameter:@"i@@"];
    SBSMethodObject *method2 = [SBSMethodObject blockMethodName:@"test2" ];
    SBSMethodObject *method3 = [SBSMethodObject classMethodName:@"test3" parameter:@"viccc"];
     SBSMethodObject *method4 = [[SBSMethodObject alloc] initWithMethodType:1 methodName:@"test4" parameter:@"ccc"];
    XCTAssert(method1&&method2&&method3&&method4);
    XCTAssert(method1.returnType == 'i');
    XCTAssert(method2.returnType == '@');
    XCTAssert(method3.returnType == 'v');
    XCTAssert(method4.returnType == 'c');
    NSArray *method1Params = @[@('@'),@('@')];
    XCTAssert([method1.params isEqualToArray:method1Params]);
    NSArray *method2Params = @[];
    XCTAssert([method2.params isEqualToArray:method2Params]);
    NSArray *method3Params = @[@('i'),@('c'),@('c'),@('c')];
    XCTAssert([method3.params isEqualToArray:method3Params]);
    NSArray *method4Params = @[@('c'),@('c')];
    XCTAssert([method4.params isEqualToArray:method4Params]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
