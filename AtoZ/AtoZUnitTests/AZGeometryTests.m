
#import <XCTest/XCTest.h>
#import <AtoZ/AtoZ.h>

AZTESTCASE(AZGeometryTests) { 

  NSR rect0, rect100; NSP pt0, pt100; NSSZ sz0, sz100; AZRect *azR0, *azR100; 
}

- (void) setUp { [super setUp];

  rect0 = NSZeroRect;
rect100 = AZRectFromDim(100);
    pt0 = NSZeroPoint;
  pt100 = AZPointFromDim(100);
    sz0 = NSZeroSize;
  sz100 = AZSizeFromDim(100);
    sz0 = NSZeroSize;    azR100 = AZRDim(100);             
}

AZTEST(PointIsInInsetRects,

  XCTAssertTrue  (AZPointIsInInsetRects(pt0, rect100, AZSizeFromDim(10)), @"{0, 0} SHOULD technically be inside insets of size {10,10} inside {0,0,100,100}");
  XCTAssertFalse (AZPointIsInInsetRects(AZPointFromDim(-10),rect100,AZSizeFromDim(10)), @"{-10, -10} should NOT be inside insets of size {10,10} inside {0,0,100,100}");
  XCTAssertFalse (AZPointIsInInsetRects(AZPointFromDim( 20),rect100,AZSizeFromDim(10)), @"{20,20} should NOT be in edges of size {10,10} inside {0,0,100,100}");
  XCTAssertThrows(AZPointIsInInsetRects(AZPointFromDim(101),rect100,AZSizeFromDim(100)), @"Should complain inset is too big!");
)

@end


JREnumDeclare(AZTestCase, AZTestFailed, AZTestPassed, AZTestUnset, AZTestNoFailures);

typedef  void (^AZCLITest)(void);

@interface AZTestNode : BaseModel
//+(NSA*) tests;
//+(NSA*) results;
@end

@interface     AZSizerTests  : AZTestNode @end
@interface  AZGeometryTestsA : AZTestNode @end
@interface   AZFavIconTests  : AZTestNode @end
@interface     NSImageTests :AZTestNode  @end


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
//	self.defaultCollectionKey = @"testsD.allValues";
	
//	LOGCOLORS($(@"TESTS in %@", AZCLSSTR), [, [NSC.randomPalette withMinItems:_tests.count + 10], nil);
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


@implementation AZGeometryTestsA

- (AZTestCase) testAZAlign	{

	__block __unused AZTestCase test = AZTestUnset;

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
  return (id) nil;
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
						hardCodeColumns = 10;  hardCodeItemSize = AZSizeFromDim(50); 	}

- (AZCLITest) forQuantityQofSizeWithColumnsTest {

	return ^{  id s = [AZSizer forQuantity:number.unsignedIntegerValue ofSize:hardCodeItemSize withColumns:hardCodeColumns]; 
					NSLog(@"%p: %@", _cmd, s);
	};
}
//+ (AZSizer*)   forObjects: (NSA*)objects  withFrame:(NSR)aFrame arranged:(AZOrient)arr;
//+ (AZSizer*)  forQuantity: (NSUI)aNumber aroundRect:(NSR)aFrame;
//+ (AZSizer*)  forQuantity: (NSUI)aNumber	 inRect:(NSR)aFrame;
//+ (NSR) structForQuantity: (NSUI)aNumber	 inRect:(NSR)aFrame;
//+ (NSR)   rectForQuantity: (NSUI)q 			 ofSize:(NSSize)s  	withColumns:(NSUI)c;
//- (NSR)		rectForPoint: (NSP)point;


@end