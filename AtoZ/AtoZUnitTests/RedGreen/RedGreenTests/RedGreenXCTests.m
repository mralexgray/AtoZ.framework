//
//  RedGreenXCTests.m
//  RedGreenXCTests
//
//  Created by Alex Gray on 10/5/13.
//  Copyright (c) 2013 Neil Cowburn. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface RedGreenXCTests : XCTestCase

@end

@implementation  RedGreenXCTests

- (void)testBooleanAssertions	{

    XCTAssertFalse(true, @"Expected true to be false.");
    XCTAssertTrue(false, @"Expected false to be true.");
}

- (void)testCanIProvideBetterOutput	{}

- (void)testDidIProvideBetterOutput	{}

- (void)testEqualityAssertions
{
    XCTAssertEqualObjects(@"a", @"a", @"Expected a to equal a");
    XCTAssertEqualObjects(@"(null)", @"Invalid user credentials.", @"Unexpected error messsage.");
}

- (void)testEstimatesAreEqual	{	XCTAssertEqual(1, 1, @"");	}

- (void)testSenTestLogOutput	{	XCTAssertEqual(1, 1, @"");	}

- (void)testFails					{ XCTFail(@"You deliberately called XCTFail().");	}

- (void)testSucceeds				{}

@end
