
/**  SenTestLog+RedGreen.m  *//* © 𝟮𝟬𝟭𝟯 𝖠𝖫𝖤𝖷 𝖦𝖱𝖠𝖸  𝗀𝗂𝗍𝗁𝗎𝖻.𝖼𝗈𝗆/𝗺𝗿𝗮𝗹𝗲𝘅𝗴𝗿𝗮𝘆 */

//#import "SenTestLog+RedGreen.h"
#import <SenTestingKit/SenTestingKit.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import <stdarg.h>

#define SHOW_SECONDS 0
#define PRINT_START_FINISH_NOISE 1


@interface SenTestLog (RedGreen)

+ (void)testLogWithColorFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

@end


#define CLR_BEG "\033[fg"
#define CLR_END "\033[;"
#define CLR_WHT "239,239,239"
#define CLR_GRY "150,150,150"
#define CLR_WOW "241,196,15"
#define CLR_GRN "46,204,113"
#define CLR_RED "211,84,0"

static      BOOL isXcodeColorsEnabled;
NSString * const kRGTestCaseFormat            = @"%@: %s (%.3fs)",
         * const kXCTestCaseFormat            = @"Test Case '%@' %s (%.3f seconds).\n",
         * const kXCTestSuiteStartFormat      = @"Test Suite '%@' started at %@\n",
         * const kXCTestSuiteFinishFormat 		= @"Test Suite '%@' finished at %@.\n",
         * const kXCTestSuiteFinishLongFormat	= @"Test Suite '%@' finished at %@.\n"
                                    "Executed %ld test%s, with %ld failure%s (%ld unexpected) in %.3f (%.3f) seconds\n",
         * const kXCTestErrorFormat           = @"%@:%lu: error: %@ : %@\n",
         * const kXCTestCaseArgsFormat        = @"%@|%s|%.5f",
         * const kXCTestErrorArgsFormat       = @"%@|%lu|%@|%@",
         * const kRGArgsSeparator             = @"|",

         * const kXCTestPassed                = @"PASSED",
         * const kXCTTestFailed               = @"FAILED",
         * const kRGTestCaseXCOutputFormat    = @"" CLR_BEG "%@;%@:" 		  CLR_END CLR_BEG CLR_GRY ";%@ " 		CLR_END
                                                    CLR_BEG CLR_WHT ";%@" CLR_END CLR_BEG CLR_GRY ";] (%@s)" CLR_END "\n",
         * const kRGTestCaseOutputFormat      = @"%@: %@ (%@s)\n",
         * const kRGTestErrorXCOutputFormat 	= @"\t\033[fg%@;Line %@: %@\033[;\n",
         * const kRGTestErrorOutputFormat 		= @"\tLine %@: %@\n";



@implementation SenTestLog (RedGreen)

+ (void)load	{	method_exchangeImplementations(	class_getInstanceMethod(self, @selector(testLogWithFormat:)),
																	class_getInstanceMethod(self, @selector(testLogWithColorFormat:)));

	isXcodeColorsEnabled = (getenv("XcodeColors") && (strcmp(getenv("XcodeColors"), "YES") == 0));
		NSLog(@"XCODE COLORS :%@", isXcodeColorsEnabled ? @" ENABLED" : @"DISABLED");
}

+ (NSMutableArray*)errors	{		static dispatch_once_t pred;	static NSMutableArray *_errors = nil;

	dispatch_once(&pred, ^{ _errors = NSMutableArray.new; });	return _errors;
}

+ (NSString*) updatedOutputFormat:(NSString*)fmt	{ return [fmt isEqualToString:kXCTestCaseFormat] ? kRGTestCaseFormat : fmt; }

+ (void)testLogWithColorFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)	{

	va_list arguments;	va_start(arguments, format);

	if ([@[	@"Test Case '%@' started.\n",	@"Test Suite '%@' started at %@\n",	kXCTestSuiteFinishLongFormat] containsObject:format]) {

		if (PRINT_START_FINISH_NOISE)
			isXcodeColorsEnabled 	? printf(CLR_BEG CLR_GRY "%s" CLR_END, [[NSString stringWithFormat:format,arguments] UTF8String])
										       	: printf("%s",[[NSString stringWithFormat:format,arguments] UTF8String]);
											
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

/*
NSString *const kRGTestCaseFormat = @"%@: %s (%.3fs)";
NSString *const kSTTestCaseFormat = @"Test Case '%@' %s (%.3f seconds).\n";
NSString *const kSTTestErrorFormat = @"%@:%@: error: %@ : %@\n";

NSString *const kSTTestCaseArgsFormat = @"%@|%s|%.5f";
NSString *const kSTTestErrorArgsFormat = @"%@|%@|%@|%@";
NSString *const kRGArgsSeparator = @"|";

NSString *const kSTTestPassed = @"PASSED";
NSString *const kSTTestFailed = @"FAILED";

NSString *const kRGTestCaseXCOutputFormat = @"\033[fg%@;%@: %@ (%@s)\033[;\n";
NSString *const kRGTestCaseOutputFormat = @"%@: %@ (%@s)\n";
NSString *const kRGTestErrorXCOutputFormat = @"\t\033[fg%@;Line %@: %@\033[;\n";
NSString *const kRGTestErrorOutputFormat = @"\tLine %@: %@\n";

NSString *const kRGColorGreen = @"0,160,0";
NSString *const kRGColorRed = @"225,0,0";

static BOOL isXcodeColorsEnabled;

+ (void)load
{
    Method _testLogWithFormat = class_getClassMethod(self, @selector(testLogWithFormat:));
    Method _testLogWithColorFormat = class_getClassMethod(self, @selector(testLogWithColorFormat:));
    
    method_exchangeImplementations(_testLogWithFormat, _testLogWithColorFormat);
    
    char *xcode_colors = getenv("XcodeColors");
    isXcodeColorsEnabled = (xcode_colors && (strcmp(xcode_colors, "YES") == 0));
}

+ (NSMutableArray *)errors
{
    static dispatch_once_t pred;
    static NSMutableArray *_errors = nil;
    dispatch_once(&pred, ^{ _errors = [[NSMutableArray alloc] init]; });
    return _errors;
}

+ (NSString *)updatedOutputFormat:(NSString *)format
{
    if ([format isEqualToString:kSTTestCaseFormat]) {
        return kRGTestCaseFormat;
    }
    
    return format;
}

+ (void)testLogWithColorFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2)
{
    if ([format rangeOfString:@"started."].location != NSNotFound) {
        return;
    }
    
    va_list arguments;
    va_start(arguments, format);
    
    if ([format isEqualToString:kSTTestCaseFormat]) {
        NSString *s = [[NSString alloc] initWithFormat:kSTTestCaseArgsFormat arguments:arguments];
        NSArray *args = [s componentsSeparatedByString:kRGArgsSeparator];
        
        NSString *color = [[args[1] uppercaseString] isEqualToString:kSTTestPassed] ? kRGColorGreen : kRGColorRed;
        NSString *output = isXcodeColorsEnabled ? [NSString stringWithFormat:kRGTestCaseXCOutputFormat, color, [args[1] uppercaseString], args[0], args[2]] :
            [NSString stringWithFormat:kRGTestCaseOutputFormat, [args[1] uppercaseString], args[0], args[2]];
        
        printf("%s", output.UTF8String);
        
        if ([SenTestLog errors].count > 0) {
            for (NSString *error in [SenTestLog errors]) {
                printf("%s", error.UTF8String);
            }
            
            [[SenTestLog errors] removeAllObjects];
        }
    } else if ([format isEqualToString:kSTTestErrorFormat]) {
        NSArray *args = NSArrayFromArguments(arguments);
        
        NSString *output = isXcodeColorsEnabled ? [NSString stringWithFormat:kRGTestErrorXCOutputFormat, kRGColorRed, args[1], args[3]] :
            [NSString stringWithFormat:kRGTestErrorOutputFormat, args[1], args[3]];
        [[SenTestLog errors] addObject:output];
        
    } else {
        [self testLogWithFormat:format arguments:arguments];
    }
    
    va_end(arguments);
}

NSArray *NSArrayFromArguments(va_list arguments)
{
    NSString *s = [[NSString alloc] initWithFormat:kSTTestErrorArgsFormat arguments:arguments];
    NSArray *args = [s componentsSeparatedByString:kRGArgsSeparator];
    
    return args;
}
*/
@end