//
//  EventQueueTest.m
//  路由
//
//  Created by qyb on 2017/8/1.
//  Copyright © 2017年 qyb. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SBSimpleEventQueue.h"
@interface EventQueueTest : XCTestCase
@property (strong,nonatomic) SBSimpleEventQueue *queue;
@end

@implementation EventQueueTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _queue = [[SBSimpleEventQueue alloc] initWithMax:10];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [_queue addEventToTop:@2];
    [_queue addEventToTop:@3];
    [_queue addEventToTop:@4];
    [_queue eventForUrl:@""];
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
