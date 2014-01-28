//
//  RedGreenXCTests.m
//  RedGreenXCTests
//
//  Created by Alex Gray on 10/5/13.
//  Copyright (c) 2013 Neil Cowburn. All rights reserved.
//

#define XCT ST
//#define XCTest.h SenTestingKit.h

#import <SenTestingKit/SenTestingKit.h>

@interface RedGreenXCTests : SenTestCase

@end

@implementation  RedGreenXCTests

- (void)testBooleanAssertions	{

    STAssertFalse(true, @"Expected true to be false.");
    STAssertTrue(false, @"Expected false to be true.");
}

- (void)testCanIProvideBetterOutput	{}

- (void)testDidIProvideBetterOutput	{}

- (void)testEqualityAssertions
{
    STAssertEqualObjects(@"a", @"a", @"Expected a to equal a");
    STAssertEqualObjects(@"(null)", @"Invalid user credentials.", @"Unexpected error messsage.");
}

- (void)testEstimatesAreEqual	{	STAssertEquals(1, 1, @"");	}

- (void)testSenTestLogOutput	{	STAssertEquals(1, 1, @"");	}

- (void)testFails					{ STFail(@"You deliberately called XCTFail().");	}

- (void)testSucceeds				{}

@end
