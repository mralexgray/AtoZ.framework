//
//  AZCLITests.m
//  AtoZ
//
//  Created by Alex Gray on 4/17/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZCLITests.h"

JREnumDefine(AZTestCase);

@interface AZTestNode ()
@property (strong) NSMD *testD;
@end
@implementation AZTestNode


- (void) setUp {

	if (![self.class hasSharedInstance]) {
		[self.class setSharedInstance:self];
		_testD = [self.instanceMethodNames map:^id(id obj) {
			return @{obj:@{@"result" : @(AZTestUnset)}.mutableCopy};
		}].mutableCopy;
	}
	self.defaultCollectionKey = @"testsD.allValues";
	
//	LOGCOLORS($(@"TESTS in %@", NSStringFromClass(self.class)), [, [NSC.randomPalette withMinItems:_tests.count + 10], nil);
//	_results =	[_tests nmap:^id(id obj, NSUInteger index) {
//		NSLog(@"Running test %ld of %ld", index, _tests.count);
//		return AZTestCaseToString( (int) [self performSelectorWithoutWarnings:NSSelectorFromString(obj)] );
//	}];
}

@end
@implementation AZFavIconTests

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

@end

//- (AZTestCase) colorNames	{

//	__block AZTestCase test = AZTestUnset;
//	NSA* colorNames = [NSC colorNames];

//	[colorNames each:^(id obj) {

//}];
//return test;
//}




@implementation AZGeometryTests

- (AZTestCase) testAZAlign	{

	__block AZTestCase test = AZTestUnset;

	NSR testRect = AZRectFromDim(100);

	NSR a = AZRectFromDim(20);
	NSR b = AZRectOffsetFromDim(a,80);
	[[NSA arrayWithRects:a,b, nil] each:^(id obj) {
		NSR oRect = [obj rectValue];
		AZA e = AZAlignmentInsideRect(oRect,testRect);
		NSLog(@"%@'s Alignment in %@: %@", AZStringFromRect(oRect), AZStringFromRect(testRect), AZAlignToString(e));
	}];
	[[@0 to:@3] each:^(id obj) {
		NSR r = quadrant(testRect, [obj integerValue]);
		AZA e = AZAlignmentInsideRect([obj rectValue],testRect);
		NSLog(@"%@'s Alignment in %@: %@", AZStringFromRect(r), AZStringFromRect(testRect), AZAlignToString(e));
	}];

//	NSLog(@"%@",AZAlignByValue(AZAlignTop));
//	NSLog(@"%@",AZAlignToString(AZAlignBottomLeft));

}
@end


@implementation AZSizerTests
{
	id objects;
	NSN* number;
	NSR frame;
	NSSZ hardCodeItemSize;
	NSUI hardCodeColumns;
}

- (void) setUp {  objects = NSIMG.monoIcons;  number = @([objects count]);  frame = AZScreenFrameUnderMenu(); 
						hardCodeColumns = 10;  hardCodeItemSize = AZSizeFromDimension(50); 	}

- (AZCLITest) forQuantityQofSizeWithColumnsTest {

	return ^{  id s = [AZSizer forQuantity:number.unsignedIntegerValue ofSize:hardCodeItemSize withColumns:hardCodeColumns]; 
					NSLog(@"%s: %@", _cmd, s);
	};
}
//+ (AZSizer*)   forObjects: (NSA*)objects  withFrame:(NSR)aFrame arranged:(AZOrient)arr;
//+ (AZSizer*)  forQuantity: (NSUI)aNumber aroundRect:(NSR)aFrame;
//+ (AZSizer*)  forQuantity: (NSUI)aNumber	 inRect:(NSR)aFrame;
//+ (NSR) structForQuantity: (NSUI)aNumber	 inRect:(NSR)aFrame;
//+ (NSR)   rectForQuantity: (NSUI)q 			 ofSize:(NSSize)s  	withColumns:(NSUI)c;
//- (NSR)		rectForPoint: (NSP)point;




@end