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

@import AtoZUniversal;

@interface NSTimeZone (Extensions)
+ (NSTimeZone*) GMTTimeZone;
@end

@interface NSDate (SI)
+(NSS*)highestSignificantComponentStringFromDate:(NSDate *)date toDate:(NSDate *)toDate;
@end


@interface NSDate (AtoZ)

+ (NSS*)dayOfWeek;
+ (NSS*) now;

- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSS*)stringDaysAgo;
- (NSS*)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSS*)string;
+ (NSDate *)dateFromString:(NSS*)string withFormat:(NSS*)format;
+ (NSS*)stringFromDate:(NSDate *)date withFormat:(NSS*)string;
+ (NSS*)stringFromDate:(NSDate *)date;
+ (NSS*)stringForDisplayFromDate:(NSDate *)date;
+ (NSS*)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;
+ (NSS*)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed alwaysDisplayTime:(BOOL)displayTime;

- (NSS*)string;
- (NSS*)stringWithFormat:(NSS*)format;
- (NSS*)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;

+ (NSS*)dateFormatString;
+ (NSS*)timeFormatString;
+ (NSS*)timestampFormatString;
+ (NSS*)dbFormatString;

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
