//
//  AtoZUniversalTests.m
//  AtoZUniversalTests
//
//  Created by Alex Gray on 3/3/15.
//  Copyright (c) 2015 Alex Gray. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface AtoZUniversalTests : XCTestCase

@end

@implementation AtoZUniversalTests

- _Void_ setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- _Void_ tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- _Void_ testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- _Void_ testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
