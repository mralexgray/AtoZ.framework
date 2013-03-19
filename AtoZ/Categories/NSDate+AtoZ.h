//
//  NSDate+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 12/13/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
//
// NSDate+Helper.h
//
// Created by Billy Gray on 2/26/09.
// Copyright (c) 2009, 2010, ZETETIC LLC
// All rights reserved.




@interface NSTimeZone (Extensions)
+ (NSTimeZone*) GMTTimeZone;
@end

@interface NSDate (SI)
+(NSString *)highestSignificantComponentStringFromDate:(NSDate *)date toDate:(NSDate *)toDate;
@end




@interface NSDate (AtoZ)

+ (NSS*)dayOfWeek;


- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;

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