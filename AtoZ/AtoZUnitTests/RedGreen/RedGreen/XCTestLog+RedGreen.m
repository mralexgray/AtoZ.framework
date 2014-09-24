
#define CLR_BEG "\033[fg"
#define CLR_END "\033[;"
#define CLR_WHT CLR_BEG "239,239,239;%s"CLR_END
#define CLR_GRY CLR_BEG "150,150,150;%s" CLR_END
#define CLR_WOW CLR_BEG "241,196,15;%s" CLR_END
#define CLR_GRN CLR_BEG "46,204,113;%s" CLR_END
#define CLR_RED CLR_BEG "211,84,0;%s" CLR_END

#define SHOW_SECONDS 0
#define PRINT_START_FINISH_NOISE 0

#define ENABLED(X) X ? "ENABLED" : "DISABLED"

@import XCTest; /**  XCTestLog+RedGreen.m  *//* © 𝟮𝟬𝟭𝟯 𝖠𝖫𝖤𝖷 𝖦𝖱𝖠𝖸  𝗀𝗂𝗍𝗁𝗎𝖻.𝖼𝗈𝗆/𝗺𝗿𝗮𝗹𝗲𝘅𝗴𝗿𝗮𝘆 */

@implementation XCTest (Shutup) static BOOL onlyOnFail;

+ (void) setOnlyOnFail:(BOOL)only {

  @synchronized(self) {

    printf("Only Log On FAIL: " CLR_BEG "%s;%s\n", (onlyOnFail = only) ? "46,204,113" : "211,84,0", ENABLED(onlyOnFail));

  }


}
+ (BOOL) onlyOnFail { return onlyOnFail; }

@end

@interface RedGreenTestObserver : XCTestObserver
@property (readonly) BOOL xColorsON;
//@property XCTestRun *run;
//@property NSMutableDictionary *suitesElement,
//                              *currentSuiteElement,
//                              *currentCaseElement;
@end

@implementation RedGreenTestObserver   // (RedGreen)

__attribute__((constructor))
static void initialize_redgreen() {
  [NSUserDefaults.standardUserDefaults setObject:@"RedGreenTestObserver" forKey:@"XCTestObserverClass"];
  [NSUserDefaults.standardUserDefaults synchronize];

}

__attribute__((destructor))
static void destroy_redgreen() {
  [NSUserDefaults.standardUserDefaults setObject:@"XCTestLog" forKey:@"XCTestObserverClass"];
  [NSUserDefaults.standardUserDefaults synchronize];
}


//+ (void) load	{

//  [NSUserDefaults.standardUserDefaults setObject:@"RedGreenTestObserver,XCTestLog" forKey:@"XCTestObserverClass"];
//  [NSUserDefaults.standardUserDefaults synchronize];


//  method_exchangeImplementations(	class_getInstanceMethod(self, @selector(testLogWithFormat:)),
//																	class_getInstanceMethod(self, @selector(testLogWithColorFormat:)));
//}

- init { self = super.init;
	_xColorsON = getenv("XcodeColors") && !strcmp(getenv("XcodeColors"), "YES");
  printf( CLR_WHT " : " CLR_WOW "  " CLR_WHT " : " CLR_WOW "\n",
                                            "xcodecolors",
                                              ENABLED(_xColorsON),
                                              "Noisy",
                                              ENABLED(PRINT_START_FINISH_NOISE));
//  _document = @{}.mutableCopy;
  return self;
}


- (void)startObserving {
//    printf("%s\n",NSStringFromSelector(_cmd).UTF8String);
    [super startObserving];
}

- (void)stopObserving {

//    printf("%s\n",NSStringFromSelector(_cmd).UTF8String);

    [super stopObserving];
}

- (void)testSuiteDidStart:(XCTestRun *)testRun { // self.run = testRun;

    printf(CLR_WOW " %lu \n", [testRun test].name.UTF8String,[(id)testRun testCaseCount]);//object_getClassName([(id)testRun testRunClass]));

//    XCTestSuite *testSuite = (XCTestSuite *) [testRun test];
//    _tests[testSuite.name] = @[].mutableCopy;
//    _currentSuiteElement = @{@"testsuite:"];
//    [_currentSuiteElement addAttribute:[@"name" stringValue:[testSuite name]]];

//    printf("%s\n%s\n\n",NSStringFromSelector(_cmd).UTF8String, testSuite.description.UTF8String);

//    self.currentSuiteElement = [GDataXMLElement elementWithName:@"testsuite"];
//    [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[testSuite name]]];
}

- (void)testSuiteDidStop:(XCTestRun *)testRun {
//    XCTestSuiteRun *testSuiteRun = (XCTestSuiteRun *) testRun;
//    printf("%s\n%s\n\n",NSStringFromSelector(_cmd).UTF8String, testSuiteRun.description.UTF8String);
//    if (_currentSuiteElement) {
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[[testSuiteRun test] name]]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"tests" stringValue:[NSString stringWithFormat:@"%d", [testSuiteRun testCaseCount]]]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"errors" stringValue:[NSString stringWithFormat:@"%d", [testSuiteRun unexpectedExceptionCount]]]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"failures" stringValue:[NSString stringWithFormat:@"%d", [testSuiteRun failureCount]]]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"skipped" stringValue:@"0"]];
//        [_currentSuiteElement addAttribute:[GDataXMLNode attributeWithName:@"time" stringValue:[NSString stringWithFormat:@"%f", [testSuiteRun testDuration]]]];
//        [_suitesElement addChild:_currentSuiteElement];
//        self.currentSuiteElement = nil;
//    }
}

- (void)testCaseDidStart:(XCTestRun *)testRun { // self.run = testRun;
    XCTest *test = [testRun test];
    printf(CLR_GRY " (" CLR_WOW " Tests) \n", object_getClassName(test.testRunClass),
                                    @(test.testCaseCount).stringValue.UTF8String);

//      if (testRun.failureCount==1)
//    printf(CLR_BEG CLR_WHT ";START:%s - %s\n\n" CLR_END,test.name.UTF8String, test.description.UTF8String);
//    self.currentCaseElement = [GDataXMLElement elementWithName:@"testcase"];
//    [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[test name]]];
}

- (void)testCaseDidStop:(XCTestRun *)testRun {
//    XCTestCaseRun *testCaseRun = (XCTestCaseRun *) testRun;
//    XCTest *test = [testCaseRun test];
    if (!testRun.totalFailureCount)
      printf(CLR_GRN CLR_GRY "\n", "PASS    ", testRun.test.name.UTF8String);
}

- (void)testCaseDidFail:(XCTestRun *)testRun withDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber; {

  XCTest *test = [testRun test];


  printf( CLR_RED " #%lu " CLR_GRY " " CLR_WHT "\n", "FAIL",
    testRun.failureCount,
    [[test.name substringToIndex:test.name.length-1]
              substringFromIndex:[test.name rangeOfString:@" "].location].UTF8String,
    description.UTF8String);
}

@end

/*
    printf("\n%s\n%s & %s\n\n",NSStringFromSelector(_cmd).UTF8String, test.description.UTF8String, testRun.description.UTF8String);
    [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"name" stringValue:[test name]]];
    [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"classname" stringValue:NSStringFromClass([test class])]];
    [_currentCaseElement addAttribute:[GDataXMLNode attributeWithName:@"time" stringValue:[NSString stringWithFormat:@"%f", [testCaseRun testDuration]]]];
    [_currentSuiteElement addChild:_currentCaseElement];
    self.currentCaseElement = nil;

  printf("\n%s\n%s\ndescription:%s\nfile[%lu]:%s\n\n",NSStringFromSelector(_cmd).UTF8String, , description.UTF8String, lineNumber, filePath.description.UTF8String);

    GDataXMLElement *failureElement = [GDataXMLElement elementWithName:@"failure"];
    [failureElement setStringValue:description];
    [_currentCaseElement addChild:failureElement];

+ (NSMutableArray*) errors	{	static dispatch_once_t pred;	static NSMutableArray *_errors = nil;

	dispatch_once(&pred, ^{ _errors = NSMutableArray.new; });	return _errors;
}

+ (NSString*) updatedOutputFormat:(NSString*)fmt	{ return [fmt isEqualToString:kXCTestCaseFormat] ? kRGTestCaseFormat : fmt; }



- (void) testLogWithColorFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)	{

	va_list arguments;	va_start(arguments, format);

//  printf("has prefix: %s", [format hasPrefix:@"Test Suite"] ? "YES" : "NO");  // format:\n\"%s\"\n", format.UTF8String);

	if      ([format hasPrefix:@"Test Suite"] && PRINT_START_FINISH_NOISE) {

  //   || [format hasSuffix:@"started.\n"]) && PRINT_START_FINISH_NOISE) {

    printf("%s%s%s", xColorsON ? CLR_BEG CLR_GRY : "",
                    [NSString stringWithFormat:format,arguments].UTF8String,
                    xColorsON ? CLR_END : "");
											
	}

  else if ([format hasPrefix:@"Test Case"]) {

		NSArray   * args = [[NSString.alloc initWithFormat:kXCTestCaseArgsFormat arguments:arguments]
                           componentsSeparatedByString:kRGArgsSeparator];

		NSArray * mParts = [args[0] componentsSeparatedByString:@" "];
		NSString   * log = args[1],
             * color = [NSString stringWithUTF8String:[log.uppercaseString isEqualToString:kXCTestPassed] ? CLR_GRN : CLR_RED],
         * messenger = mParts[0],
            * method = [mParts[1] stringByReplacingOccurrencesOfString:@"]" withString:@""],
            * output = xColorsON
                     ? [NSString stringWithFormat:kRGTestCaseXCOutputFormat, color, log.uppercaseString, messenger, method, SHOW_SECONDS ? args[2] : @""]
							       : [NSString stringWithFormat:kRGTestCaseOutputFormat, log.uppercaseString, args[0], SHOW_SECONDS ? args[2] : @""];

		if (!SHOW_SECONDS) output = [output stringByReplacingOccurrencesOfString:@"(s)" withString:@""];

		printf("%s", output.UTF8String);

		if (![_errors[self.className]count]) return;

		[_errors[self.className] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { printf("%s\n", [obj UTF8String]); }];
		[_errors[self.className] removeAllObjects];

	}

  else if ([format rangeOfString:@"error"].location != NSNotFound) {

		NSArray *args = [[NSString.alloc initWithFormat:kXCTestErrorArgsFormat arguments:arguments]
                        componentsSeparatedByString:kRGArgsSeparator];
    id x = !xColorsON ? ({ [NSString stringWithFormat:kRGTestErrorOutputFormat, args[1], args[3]]; }) : ({

			NSUInteger  failureLoc;

      (failureLoc = [args[3] rangeOfString:@"failed"].location) != NSNotFound ?

				[NSString stringWithFormat:kRGTestErrorXCOutputFormat,CLR_RED, args[1], args[3]] : ({

			NSString * problem = [args[3] substringToIndex:failureLoc],
                * reason = [args[3] substringFromIndex:failureLoc + @"failed ".length];


      [NSString stringWithFormat:@""   CLR_BEG CLR_WOW ";#%lu"  CLR_END
                                  "%s" CLR_BEG CLR_GRY ";%@"	  CLR_END
                                       CLR_BEG CLR_WHT ";  %@ " CLR_END
                                       CLR_BEG CLR_RED ";%@"	  CLR_END,
        (NSUInteger)[_errors[self.className]count]+1,
        [_errors[self.className]count] < 10 ? " ": "", args[1],
        problem,
        reason];

    }); });
    if (x) [_errors[self.className] = _errors[self.className] ?: @[].mutableCopy addObject:x];

	}

//  else printf("format:\n\"%s\"\n\nFELL THROUGH!\n", format.UTF8String); // objc_msgSend(self, @selector(testLogWithFormat:arguments:),format,arguments);

	va_end(arguments);
}



          * const kXCTestCaseFormat 				= @"Test Case '%@' %s (%.3f seconds).\n",
          * const kXCTestSuiteStartFormat		= @"Test Suite '%@' started at %@\n",
          * const kXCTestSuiteFinishFormat 		= @"Test Suite '%@' finished at %@.\n",
          * const kXCTestSuiteFinishLongFormat	= @"Test Suite '%@' finished at %@.\n"
                                                  "Executed %ld test%s, with %ld failure%s (%ld unexpected) in %.3f (%.3f) seconds\n",
          * const kXCTestSuiteFinishLongFormatNew	=
@"Test Suite '%@' %s at %@.\n",
 "\t Executed %lu test%s, with %lu failure%s (%lu unexpected) in %.3f (%.3f) seconds",

#define ENABLED(X) X ? "ENABLED" : "DISABLED"

NSString  * const kRGTestCaseFormat 				= @"%@: %s (%.3fs)",
          * const kXCTestErrorFormat	 			= @"%@:%lu: error: %@ : %@\n",
          * const kXCTestCaseArgsFormat 			= @"%@|%s|%.5f",
          * const kXCTestErrorArgsFormat 		= @"%@|%lu|%@|%@",
          * const kRGArgsSeparator 				= @"|",

          * const kXCTestPassed 					= @"PASSED",
          * const kXCTTestFailed 					= @"FAILED",
          * const kRGTestCaseXCOutputFormat 	= @"" CLR_BEG       "%@;%@:" CLR_END CLR_BEG CLR_GRY ";%@ " 		CLR_END
                                                    CLR_BEG CLR_WHT ";%@"  CLR_END CLR_BEG CLR_GRY ";] (%@s)" CLR_END "\n",
          * const kRGTestCaseOutputFormat 		= @"%@: %@ (%@s)\n",
          * const kRGTestErrorXCOutputFormat 	= @"\t\033[fg%s;Line %@: %@\033[;\n",
          * const kRGTestErrorOutputFormat 		= @"\tLine %@: %@\n";
@import ObjectiveC;
 #import <stdarg.h>

 */
