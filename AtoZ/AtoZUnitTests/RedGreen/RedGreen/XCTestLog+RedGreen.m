
/**  XCTestLog+RedGreen.m  *//* © 𝟮𝟬𝟭𝟯 𝖠𝖫𝖤𝖷 𝖦𝖱𝖠𝖸  𝗀𝗂𝗍𝗁𝗎𝖻.𝖼𝗈𝗆/𝗺𝗿𝗮𝗹𝗲𝘅𝗴𝗿𝗮𝘆 */

#import "XCTestLog+RedGreen.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <stdarg.h>

#define CLR_BEG "\033[fg"
#define CLR_END "\033[;"
#define CLR_WHT "239,239,239"
#define CLR_GRY "150,150,150"
#define CLR_WOW "241,196,15"
#define CLR_GRN "46,204,113"
#define CLR_RED "211,84,0"

static     BOOL isXcodeColorsEnabled;
NSString *const kRGTestCaseFormat 				= @"%@: %s (%.3fs)",
			*const kXCTestCaseFormat 				= @"Test Case '%@' %s (%.3f seconds).\n",
			*const kXCTestSuiteStartFormat		= @"Test Suite '%@' started at %@\n",
			*const kXCTestSuiteFinishFormat 		= @"Test Suite '%@' finished at %@.\n",
			*const kXCTestSuiteFinishLongFormat	= @"Test Suite '%@' finished at %@.\n"
																"Executed %ld test%s, with %ld failure%s (%ld unexpected) in %.3f (%.3f) seconds\n",
			*const kXCTestErrorFormat	 			= @"%@:%lu: error: %@ : %@\n",
			*const kXCTestCaseArgsFormat 			= @"%@|%s|%.5f",
			*const kXCTestErrorArgsFormat 		= @"%@|%lu|%@|%@",
			*const kRGArgsSeparator 				= @"|",

			*const kXCTestPassed 					= @"PASSED",
			*const kXCTTestFailed 					= @"FAILED",
			*const kRGTestCaseXCOutputFormat 	= @"" CLR_BEG "%@;%@:" 		 CLR_END CLR_BEG CLR_GRY ";%@ " 		CLR_END
																	CLR_BEG CLR_WHT ";%@" CLR_END CLR_BEG CLR_GRY ";] (%@s)" CLR_END "\n",
			*const kRGTestCaseOutputFormat 		= @"%@: %@ (%@s)\n",
			*const kRGTestErrorXCOutputFormat 	= @"\t\033[fg%@;Line %@: %@\033[;\n",
			*const kRGTestErrorOutputFormat 		= @"\tLine %@: %@\n";

@implementation XCTestLog (RedGreen)

+ (void)load	{	method_exchangeImplementations(	class_getInstanceMethod(self, @selector(testLogWithFormat:)),
																	class_getInstanceMethod(self, @selector(testLogWithColorFormat:)));

	isXcodeColorsEnabled = (getenv("XcodeColors") && (strcmp(getenv("XcodeColors"), "YES") == 0));
		NSLog(@"XCODE COLORS :%@", isXcodeColorsEnabled ? @" ENABLED" : @"DISABLED");
}

+ (NSMutableArray*)errors	{		static dispatch_once_t pred;	static NSMutableArray *_errors = nil;

	dispatch_once(&pred, ^{ _errors = NSMutableArray.new; });	return _errors;
}

+ (NSString*) updatedOutputFormat:(NSString*)fmt	{ return [fmt isEqualToString:kXCTestCaseFormat] ? kRGTestCaseFormat : fmt; }

- (void)testLogWithColorFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)	{

	va_list arguments;	va_start(arguments, format);

	if ([@[	@"Test Case '%@' started.\n",	@"Test Suite '%@' started at %@\n",	kXCTestSuiteFinishLongFormat] containsObject:format]) {

		if (PRINT_START_FINISH_NOISE)
			isXcodeColorsEnabled 	? printf(CLR_BEG CLR_GRY "%s" CLR_END, [[NSString stringWithFormat:format,arguments] UTF8String])
										  	: printf("%s",[[NSString stringWithFormat:format,arguments]UTF8String]);
											
	} else if ( [format isEqualToString:kXCTestCaseFormat] ) {

		NSArray   		*args = [[NSString.alloc initWithFormat:kXCTestCaseArgsFormat arguments:arguments] componentsSeparatedByString:kRGArgsSeparator];
		NSArray *methodParts =		[args[0] componentsSeparatedByString:@" "];
		NSString        *log = args[1],
						  *color = [NSString stringWithUTF8String:[log.uppercaseString isEqualToString:kXCTestPassed] ? CLR_GRN : CLR_RED],
					 *messenger = methodParts[0],
						 *method = [methodParts[1] stringByReplacingOccurrencesOfString:@"]" withString:@""],
						 *output = isXcodeColorsEnabled
								   ? [NSString stringWithFormat:kRGTestCaseXCOutputFormat, color, log.uppercaseString, messenger, method, SHOW_SECONDS ? args[2] : @""]
							      : [NSString stringWithFormat:kRGTestCaseOutputFormat, log.uppercaseString, args[0], SHOW_SECONDS ? args[2] : @""];

		if (!SHOW_SECONDS) output = [output stringByReplacingOccurrencesOfString:@"(s)" withString:@""];

		printf("%s", output.UTF8String);

		if (!self.class.errors.count) return;

		[self.class.errors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { printf("%s\n", [obj UTF8String]); }];
		[self.class.errors removeAllObjects];

	} else if ([format isEqualToString:kXCTestErrorFormat]){

		NSArray *args = [[NSString.alloc initWithFormat:kXCTestErrorArgsFormat arguments:arguments]
								  componentsSeparatedByString:kRGArgsSeparator];

		[self.class.errors addObject: !isXcodeColorsEnabled ? [NSString stringWithFormat:kRGTestErrorOutputFormat, args[1], args[3]] : ^{

			NSInteger  failureLoc;		if ((failureLoc = [args[3] rangeOfString:@"failed"].location) == NSNotFound)
				return [NSString stringWithFormat:kRGTestErrorXCOutputFormat,[NSString stringWithUTF8String:CLR_RED], args[1], args[3]];

			NSString    *problem = [args[3] substringToIndex:failureLoc],  *reason = [args[3] substringFromIndex:failureLoc + @"failed ".length];

			return 	[NSString stringWithFormat:@"%@%@%@",
						[NSString stringWithFormat:@""	CLR_BEG CLR_WOW ";#%@"	CLR_END, @(self.class.errors.count+1).stringValue],
			 			[NSString stringWithFormat:@"%@"	CLR_BEG CLR_GRY ";@%@"	CLR_END, self.class.errors.count < 10 ? @" ":@"", args[1]],
						[NSString stringWithFormat:@""	CLR_BEG CLR_WHT ";  %@ "CLR_END CLR_BEG CLR_RED ";%@"	CLR_END, problem, reason]];
		}()];

	} else printf("format: %s FELL THROUGH!\n", format.UTF8String); // objc_msgSend(self, @selector(testLogWithFormat:arguments:),format,arguments);

	va_end(arguments);
}

@end