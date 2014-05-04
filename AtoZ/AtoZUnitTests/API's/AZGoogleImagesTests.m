//
//  AZGoogleImagesTests.m
//  AtoZ
//
//  Created by Alex Gray on 10/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface 			AZGoogleImagesTests : XCTestCase 
@property (NATOM) NSA* results;
@end
@implementation 	AZGoogleImagesTests

- (NSA*) results {  

	BLK_START;
	[AZGoogleImages searchGoogleImages:NSS.randomBadWord withBlock:^(NSA *imageURLs) {	BLK_STOP;
		_results = imageURLs;
	}];
	BLK_WAIT;
	return _results;
}
- (void) setUp { [super setUp]; [self results]; }

- (void) testDefaultResults	{ 		

	NSUInteger ct;

	__block NSUInteger ranTestCtr = 0;
	for (id obj in _results) { 
		 XCTAssertTrue([obj ISKINDA:NSString.class], @"should all be Strings. Instead got:%@!", NSStringFromClass([obj class])); 
		ranTestCtr++; 
	}
	XCTAssertEqual(@(ranTestCtr), @(_results.count), @"didnt run the tests inside the loop!");



	XCTAssertTrue(_results.count == 20, 	@"should fetch 10 URL'd; Instead got...%@", @(_results.count));
	ct = [_results filter:^BOOL(id object) { 
	
		return [object ISKINDA:NSString.class];
	}].count;
	XCTAssertTrue(ct == _results.count, @"should all be NSUrl's! Instead found...%@", @(ct));
}

- (void) testQueryCache {

	XCTAssertNotNil(_results, @"should have gotten results");
	NSS* last = [AZGoogleImages lastQuery]; 
	XCTAssert(last != nil, @"should return last query term.");
	if (last) {
		BLK_START;
		[AZGoogleImages searchGoogleImages:last withBlock:^(NSA *imageURLs) { BLK_STOP;
			
			XCTAssertEqual(_results, imageURLs, @"i shoudl egt the same results, if i havent asked for more!");
		}];
		BLK_WAIT;
	}
}
@end
