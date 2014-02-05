


#import "AZLogUnit.h"
static AZLogUnit *instance = nil;
static void __attribute__ ((constructor)) OCUnitToJUnitLoggerStart(void){ instance = [AZLogUnit new];	}
static void __attribute__ ((destructor)) OCUnitToJUnitLoggerStop(void)	{  [instance writeResultFile];	instance = nil;  }  //[instance release];	}

@implementation AZLogUnit

- (id)init;	{ if (self != super.init ) return nil;

//  [AZNOTCENTER addObserver:self selector:@selector(testSuiteStarted:) 	name:XCTestSuiteDidStartNotification object:nil];
//  [AZNOTCENTER addObserver:self selector:@selector(testSuiteStopped:) 	name:XCTestSuiteDidStopNotification object:nil];
//  [AZNOTCENTER addObserver:self selector:@selector(testCaseStarted:) 	name:XCTestCaseDidStartNotification object:nil];
//  [AZNOTCENTER addObserver:self selector:@selector(testCaseStopped:) 	name:XCTestCaseDidStopNotification object:nil];
//  [AZNOTCENTER addObserver:self selector:@selector(testCaseFailed:) 		name:XCTestCaseDidFailNotification object:nil];

	  _document = GDataXMLDocument.new;
	[_document initWithRootElement:[GDataXMLElement elementWithName:@"testsuites"]];
	self.suitesElement = [_document rootElement];
	return self;
}
- (void)dealloc;				{  [AZNOTCENTER removeObserver:self];	}
- (void)writeResultFile		{ if (self.document)[_document.XMLData writeToFile:@"ocunit.xml" atomically:NO];	}
#pragma mark Notification Callbacks
- (void)testSuiteStarted:(NSNotification*)notification	{

    XCTest *test = notification.userInfo[@"test"];
    self.currentSuiteElement = [GDataXMLElement elementWithName:@"testsuite"];
    [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[test name]]];
}
- (void)testSuiteStopped:(NSNotification*)notification	{
	playTrumpet();
   XCTestSuiteRun *testSuiteRun = (XCTestSuiteRun *)[notification object];
	if (!_currentSuiteElement) return
	[	@[@[@"name",  testSuiteRun.test.name], 										@[@"tests",		@(testSuiteRun.testCaseCount).stringValue],
		@[@"errors",@(testSuiteRun.unexpectedExceptionCount).stringValue],	@[@"failures",	@(testSuiteRun.failureCount).stringValue],
		@[@"time",	@(testSuiteRun.testDuration).stringValue], 					@[@"skipped",@"0"]] each:^(id obj) {
			[_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:obj[0] stringValue:obj[1]]];
	}];
	[_suitesElement addChild:_currentSuiteElement];		self.currentSuiteElement = nil;
}
- (void)testCaseStarted:(NSNotification*)notification;	{
   self.currentCaseElement = [GDataXMLElement elementWithName:@"testcase"];
//		[_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:notification.test.name]];
}
- (void)testCaseStopped:(NSNotification*)notification;	{

    XCTestCaseRun *testCaseRun = (XCTestCaseRun *)[notification object];
//	[_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:NSStringFromSelector(((XCTestCase*)notification.test).selector)]];
//   [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"classname" stringValue:NSStringFromClass([((XCTestCase*)notification.test) class])]];
	[_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"time" stringValue:@(testCaseRun.testDuration).stringValue]];
	[_currentSuiteElement addChild:self.currentCaseElement];
	self.currentCaseElement = nil;
}
- (void)testCaseFailed:(NSNotification*)notification;	{
    GDataXMLElement *failureElement = [GDataXMLElement elementWithName:@"failure"];
//    [failureElement setStringValue:notification.exception.description];
    [_currentCaseElement addChild:failureElement];
}

@end
