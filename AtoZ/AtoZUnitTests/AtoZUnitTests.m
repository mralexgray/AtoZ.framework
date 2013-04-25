//
//  AtoZUnitTests.m
//  AtoZUnitTests
//
//  Created by Alex Gray on 4/17/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZUnitTests.h"
#import <AtoZ/AtoZ.h>

@implementation AtoZUnitTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in AtoZUnitTests");
}

- (void)testTestFramework
{
	NSString *string1 = @"test";
	NSString *string2 = @"test";
	STAssertEquals(string1,
						string2,
						@"FAILURE");
	NSUInteger uint_1 = 4;
	NSUInteger uint_2 = 4;
	STAssertEquals(uint_1,
						uint_2,
						@"FAILURE");
}

- (void) rgbColorValues {

	NSS	*stringColor 	= @"red";
	NSA	*stringResult 	=  rgbColorValues(stringColor);
	NSC	*colorColor	 	= RED;
	NSA	*colorResult	= rgbColorValues(colorColor);
	NSA	*arrayColor 	= @[@1,@0, @0];
	NSA	*arrayResult 	= rgbColorValues(arrayColor);
	NSLog(@"rgbColorValues:  string: %@   color: %@  array:  %@", stringResult, colorResult, arrayResult);
}

@end
