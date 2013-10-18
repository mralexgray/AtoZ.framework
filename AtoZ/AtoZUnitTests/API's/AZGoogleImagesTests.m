//
//  AZGoogleImagesTests.m
//  AtoZ
//
//  Created by Alex Gray on 10/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface 			AZGoogleImagesTests : XCTestCase @end
@implementation 	AZGoogleImagesTests


- (NSA*) getSomeResults {  __block NSA*res;

//	BLK_START;
	[AZGoogleImages searchGoogleImages:NSS.randomBadWord withBlock:^(NSA *imageURLs) {	//BLK_STOP;  	
		res = [imageURLs copy];
	}];
//	BLK_WAIT;
	return res;
}
- (void)testDefaultResults	{ 		

	NSA* imageURLs = [self getSomeResults]; NSUInteger ct;

	__block NSUInteger ranTestCtr = 0;
	for (id obj in imageURLs) { 
		 XCTAssertTrue([obj ISKINDA:NSString.class], @"should all be URLS. Instead got:%@!", NSStringFromClass([obj class])); 
		ranTestCtr++; 
	}
	XCTAssertEqual(@(ranTestCtr), @(imageURLs.count), @"didnt run the tests inside the loop!");



	XCTAssertTrue(imageURLs.count == 10, 	@"should fetch 10 URL'd; Instead got...%@", @(imageURLs.count));
	XCTAssertTrue((ct = [imageURLs filter:^BOOL(id object) { return [object ISKINDA:NSURL.class]; }].count) == imageURLs.count, 
														@"should all be NSUrl's! Instead found...%@", @(ct));
}

- (void) testQueryCache {

	NSA* someURLs = [self getSomeResults];
	NSS* last = [AZGoogleImages lastQuery];
	[AZGoogleImages searchGoogleImages:last withBlock:^(NSA *imageURLs) {
	
			XCTAssertEqual(someURLs, imageURLs, @"i shoudl egt the same results, if i havent asked for more!");
	}];


}
@end
