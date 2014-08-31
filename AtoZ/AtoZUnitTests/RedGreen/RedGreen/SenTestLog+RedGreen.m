//
//  SenTestLog+RedGreen.m
//  RedGreen
//
//  Created by Neil on 20/04/2013.
//  Copyright (c) 2013 Neil Cowburn. All rights reserved.
//

#import "SenTestLog+RedGreen.h"
#import <objc/runtime.h>
#import <stdarg.h>

@implementation SenTestLog (RedGreen)

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

@end