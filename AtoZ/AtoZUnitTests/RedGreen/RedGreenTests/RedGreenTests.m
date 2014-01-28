//
//  RedGreenTests.m
//  RedGreenTests
//
//  Created by Neil on 20/04/2013.
//  Copyright (c) 2013 Neil Cowburn. All rights reserved.
//

#import "RedGreenTests.h"

@implementation RedGreenTests

- (void)testBooleanAssertions
{
    STAssertFalse(true, @"Expected true to be false.");
    STAssertTrue(false, @"Expected false to be true.");
}

- (void)testCanIProvideBetterOutput
{
}

- (void)testDidIProvideBetterOutput
{
}

- (void)testEqualityAssertions
{
    STAssertEqualObjects(@"a", @"a", @"Expected a to equal a");
    STAssertEqualObjects(@"(null)", @"Invalid user credentials.", @"Unexpected error messsage.");
}

- (void)testEstimatesAreEqual
{
    STAssertEquals(1, 1, @"");
}

- (void)testSenTestLogOutput
{
    STAssertEquals(1, 1, @"");
}

- (void)testFails
{
    STFail(@"You deliberately called STFail().");
}

- (void)testSucceeds
{
}

@end
