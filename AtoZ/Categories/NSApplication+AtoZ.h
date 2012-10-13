//
//  NSApplication+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *const kShowDockIconUserDefaultsKey;

@interface NSApplication (AtoZ)

+ (id)		infoValueForKey:(NSString *)key;
- (BOOL)	showsDockIcon;
- (void)	setShowsDockIcon:(BOOL)flag;
@end

#import <Foundation/Foundation.h>

// All extensions methods in this file are thread-safe

#define kMultipartFileKey_MimeType @"mimeType" // NSString
#define kMultipartFileKey_FileName @"fileName"  // NSString
#define kMultipartFileKey_FileData @"fileData"  // NSData

@interface NSDate (Extensions)
+ (NSDate*) dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
+ (NSDate*) dateWithYear:(NSUInteger)year
                   month:(NSUInteger)month
                     day:(NSUInteger)day
                    hour:(NSUInteger)hour
                  minute:(NSUInteger)minute
                  second:(NSUInteger)second;  // All numbers are 1 based
+ (NSDate*) dateWithDaysSinceReferenceDate:(NSInteger)days;
+ (NSDate*) dateWithString:(NSString*)string cachedFormat:(NSString*)format;  // Uses current locale and timezone
+ (NSDate*) dateWithString:(NSString*)string cachedFormat:(NSString*)format localIdentifier:(NSString*)identifier;  // Uses current timezone
+ (NSDate*) dateWithString:(NSString*)string
              cachedFormat:(NSString*)format
           localIdentifier:(NSString*)identifier  // Pass nil for current locale
                  timeZone:(NSTimeZone*)timeZone;  // Pass nil for current timezone
- (void) getYear:(NSUInteger*)year month:(NSUInteger*)month day:(NSUInteger*)day;
- (void) getYear:(NSUInteger*)year
           month:(NSUInteger*)month
             day:(NSUInteger*)day
            hour:(NSUInteger*)hour
          minute:(NSUInteger*)minute
          second:(NSUInteger*)second;  // All numbers are 1 based
- (NSDate*) dateRoundedToMidnight;
- (NSUInteger) daySinceBeginningOfTheYear;
- (NSInteger) daysSinceReferenceDate;
- (NSString*) stringWithCachedFormat:(NSString*)format;  // Uses current locale and timezone
- (NSString*) stringWithCachedFormat:(NSString*)format localIdentifier:(NSString*)identifier;  // Uses current timezone
- (NSString*) stringWithCachedFormat:(NSString*)format localIdentifier:(NSString*)identifier timeZone:(NSTimeZone*)timeZone;  // Pass nil for current locale and timezone
@end
@interface NSProcessInfo (Extensions)
- (BOOL) isDebuggerAttached;
@end

@interface NSURL (Extensions)
- (NSDictionary*) parseQueryParameters:(BOOL)unescape;
@end

@interface NSMutableURLRequest (Extensions)
+ (NSData*) HTTPBodyWithMultipartBoundary:(NSString*)boundary formArguments:(NSDictionary*)arguments;  // Pass file attachments as dictionaries containing kMultipartFileKey_xxx keys
- (void) setHTTPBodyWithMultipartFormArguments:(NSDictionary*)arguments;
@end

@interface NSTimeZone (Extensions)
+ (NSTimeZone*) GMTTimeZone;
@end


@interface NSDate (Extensions)
+ (NSDate*) dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day;
+ (NSDate*) dateWithYear:(NSUInteger)year
                   month:(NSUInteger)month
                     day:(NSUInteger)day
                    hour:(NSUInteger)hour
                  minute:(NSUInteger)minute
                  second:(NSUInteger)second;  // All numbers are 1 based
+ (NSDate*) dateWithDaysSinceReferenceDate:(NSInteger)days;
+ (NSDate*) dateWithString:(NSString*)string cachedFormat:(NSString*)format;  // Uses current locale and timezone
+ (NSDate*) dateWithString:(NSString*)string cachedFormat:(NSString*)format localIdentifier:(NSString*)identifier;  // Uses current timezone
+ (NSDate*) dateWithString:(NSString*)string
              cachedFormat:(NSString*)format
           localIdentifier:(NSString*)identifier  // Pass nil for current locale
                  timeZone:(NSTimeZone*)timeZone;  // Pass nil for current timezone
- (void) getYear:(NSUInteger*)year month:(NSUInteger*)month day:(NSUInteger*)day;
- (void) getYear:(NSUInteger*)year
           month:(NSUInteger*)month
             day:(NSUInteger*)day
            hour:(NSUInteger*)hour
          minute:(NSUInteger*)minute
          second:(NSUInteger*)second;  // All numbers are 1 based
- (NSDate*) dateRoundedToMidnight;
- (NSUInteger) daySinceBeginningOfTheYear;
- (NSInteger) daysSinceReferenceDate;
- (NSString*) stringWithCachedFormat:(NSString*)format;  // Uses current locale and timezone
- (NSString*) stringWithCachedFormat:(NSString*)format localIdentifier:(NSString*)identifier;  // Uses current timezone
- (NSString*) stringWithCachedFormat:(NSString*)format localIdentifier:(NSString*)identifier timeZone:(NSTimeZone*)timeZone;  // Pass nil for current locale and timezone
@end

@interface NSProcessInfo (Extensions)
- (BOOL) isDebuggerAttached;
@end

@interface NSURL (Extensions)
- (NSDictionary*) parseQueryParameters:(BOOL)unescape;
@end

