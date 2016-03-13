//
//  zhihuDailyTests.m
//  zhihuDailyTests
//
//  Created by yang on 16/2/21.
//  Copyright © 2016年 yang. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SYAccount.h"
#import "SYZhihuTool.h"


@interface zhihuDailyTests : XCTestCase

@end

@implementation zhihuDailyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    
    NSLog(@"----> tear down");
    
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
}

- (void)testLogin {
    
    NSString *user = [NSString stringWithFormat:@"%@", @(arc4random())];
    
    BOOL result = [SYAccount loginWithName:user password:@"1456"];
    
    XCTAssert(result, @"新用户登录成功");
    
    result = [SYAccount loginWithName:user password:@"16"];
    XCTAssert(!result, @"第二次登录，密码不对，登录失败");
}

- (void)testRequestData {

    
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
