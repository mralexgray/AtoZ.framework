//
//  AZGoogleImagesTests.m
//  AtoZ
//
//  Created by Alex Gray on 10/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AZGoogleImagesTests : XCTestCase

@end

@implementation AZGoogleImagesTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
	BLK_START;
	[AZGoogleImages searchGoogleImages:@"hitler" withBlock:^(NSA *imageURLs) {	BLK_STOP;

	 	XCTAssertTrue(imageURLs.count == 10, @"should fetch 10 Images;");
		[imageURLs each:^(id obj) { XCTAssertTrue([obj ISKINDA:NSString.class],@"should all be URLS. Instead got:%@!", NSStringFromClass([obj class])); }];
	}];
	BLK_WAIT;
}

@end
