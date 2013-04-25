//
//  AZCLITests.m
//  AtoZ
//
//  Created by Alex Gray on 4/17/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZCLITests.h"

JREnumDefine(AZTestCase);

@implementation AZCLITests

- (void) setUp {
	NSLog(@"Loading tests!");
	_tests = [self instanceMethodNames].mutableCopy;
	LOGCOLORS(@"TESTS TO RUN", _tests, [NSC.randomPalette withMinItems:_tests.count + 10], nil);
	_results =	[_tests nmap:^id(id obj, NSUInteger index) {
		NSLog(@"Running test %ld of %ld", index, _tests.count);
		return AZTestCaseToString( (int) [self performSelectorWithoutWarnings:NSSelectorFromString(obj)] );
	}];
}

- (AZTestCase) testiconForURL	{

	__block AZTestCase test = AZTestUnset;
	NSA* urls = NSS.testDomains;
	[urls each:^(id obj) {
		if (test == AZTestFailed) return;
			__block NSIMG* testIMG = nil;
		NSS* stopwatchString = $(@"favicon test for:%@", [obj stringValue]);
		[AZStopwatch start:stopwatchString];
		[AZFavIconManager iconForURL:obj downloadHandler:^(NSImage *icon) {
			testIMG = icon;
			test = testIMG && [testIMG isKindOfClass:NSIMG.class] ? AZTestNoFailures : AZTestFailed;
			[AZStopwatch stop:stopwatchString];

		}];
	}];
	return test;
}

//- (AZTestCase) colorNames	{

//	__block AZTestCase test = AZTestUnset;
//	NSA* colorNames = [NSC colorNames];

//	[colorNames each:^(id obj) {

//}];
//return test;
//}
@end
