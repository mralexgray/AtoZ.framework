//
//  NSApplication+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSApplication+AtoZ.h"
#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#import <sys/xattr.h>
#else
#import <CoreServices/CoreServices.h>
#endif
#import <libkern/OSAtomic.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <unistd.h>
#import <dirent.h>
#import <sys/stat.h>

#import "AtoZ.h"



NSString *const kShowDockIconUserDefaultsKey = @"ShowDockIcon";
@implementation NSApplication (AtoZ)

+ (id)infoValueForKey:(NSString *)key {
    if ([[NSBundle mainBundle] localizedInfoDictionary][key]) {
        return [[NSBundle mainBundle] localizedInfoDictionary][key];
    }

    return [[NSBundle mainBundle] infoDictionary][key];
}

- (BOOL)showsDockIcon {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kShowDockIconUserDefaultsKey];
}

    /** this should be called from the application delegate's applicationDidFinishLaunching method or from some controller object's awakeFromNib method neat dockless hack using Carbon from <a href="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it" title="http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-to-do-it">http://codesorcery.net/2008/02/06/feature-requests-versus-the-right-way-...</a> */
	
- (void)setShowsDockIcon:(BOOL)flag {

    if (flag) {
        ProcessSerialNumber psn = { 0, kCurrentProcess };
        // display dock icon
        TransformProcessType(&psn, kProcessTransformToForegroundApplication);
        // enable menu bar
        SetSystemUIMode(kUIModeNormal, 0);

        // switch to Dock.app
        if ([[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.dock" options:NSWorkspaceLaunchDefault additionalEventParamDescriptor:nil launchIdentifier:nil] == NO) {
            NSLog(@"Could not launch application with identifier 'com.apple.dock'.");
        }

        // switch back
        [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    }
}
@end

@implementation NSArray (Extensions)

- (id) firstObject {
	return self.count ? [self objectAtIndex:0] : nil;
}

@end

@implementation NSMutableArray (Extensions)

- (void) removeFirstObject {
	[self removeObjectAtIndex:0];
}

@end




#import <TargetConditionals.h>
#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#import <sys/xattr.h>
#else
#import <CoreServices/CoreServices.h>
#endif
#import <libkern/OSAtomic.h>
#import <sys/xattr.h>
#import <sys/sysctl.h>
#import <unistd.h>
#import <dirent.h>
#import <sys/stat.h>

static OSSpinLock _calendarSpinLock = 0;
static OSSpinLock _formattersSpinLock = 0;
static OSSpinLock _staticSpinLock = 0;

typedef enum {
	kCharacterSet_Newline = 0,
	kCharacterSet_WhitespaceAndNewline,
	kCharacterSet_WhitespaceAndNewline_Inverted,
	kCharacterSet_UppercaseLetters,
	kCharacterSet_DecimalDigits_Inverted,
	kCharacterSet_WordBoundaries,
	kCharacterSet_SentenceBoundaries,
	kCharacterSet_SentenceBoundariesAndNewlineCharacter,
	kNumCharacterSets
} CharacterSet;

static NSCharacterSet* _GetCachedCharacterSet(CharacterSet set) {
	static NSCharacterSet* cache[kNumCharacterSets] = {0};
	if (cache[set] == nil) {
		OSSpinLockLock(&_staticSpinLock);
		if (cache[set] == nil) {
			switch (set) {
				case kCharacterSet_Newline:
					cache[set] = [[NSCharacterSet newlineCharacterSet] retain];
					break;
				case kCharacterSet_WhitespaceAndNewline:
					cache[set] = [[NSCharacterSet whitespaceAndNewlineCharacterSet] retain];
					break;
				case kCharacterSet_WhitespaceAndNewline_Inverted:
					cache[set] = [[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet] retain];
					break;
				case kCharacterSet_UppercaseLetters:
					cache[set] = [[NSCharacterSet uppercaseLetterCharacterSet] retain];
					break;
				case kCharacterSet_DecimalDigits_Inverted:
					cache[set] = [[[NSCharacterSet decimalDigitCharacterSet] invertedSet] retain];
					break;
				case kCharacterSet_WordBoundaries:
					cache[set] = [[NSMutableCharacterSet alloc] init];
					[(NSMutableCharacterSet*)cache[set] formUnionWithCharacterSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
					[(NSMutableCharacterSet*)cache[set] formUnionWithCharacterSet:[NSCharacterSet punctuationCharacterSet]];
					[(NSMutableCharacterSet*)cache[set] removeCharactersInString:@"-"];
					break;
				case kCharacterSet_SentenceBoundaries:
					cache[set] = [[NSMutableCharacterSet alloc] init];
					[(NSMutableCharacterSet*)cache[set] addCharactersInString:@".?!"];
					break;
				case kCharacterSet_SentenceBoundariesAndNewlineCharacter:
					cache[set] = [[NSMutableCharacterSet alloc] init];
					[(NSMutableCharacterSet*)cache[set] formUnionWithCharacterSet:[NSCharacterSet newlineCharacterSet]];
					[(NSMutableCharacterSet*)cache[set] addCharactersInString:@".?!"];
					break;
				case kNumCharacterSets:
					break;
			}
		}
		OSSpinLockUnlock(&_staticSpinLock);
	}
	return cache[set];
}

@implementation NSString (Extensions)

- (BOOL) hasCaseInsensitivePrefix:(NSString*)prefix {
	NSRange range = [self rangeOfString:prefix options:(NSCaseInsensitiveSearch | NSAnchoredSearch)];
	return range.location != NSNotFound;
}

- (NSString*) urlEscapedString {
	return [(id)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, CFSTR(":@/?&=+"),
														kCFStringEncodingUTF8) autorelease];
}

- (NSString*) unescapeURLString {
	return [(id)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)self, CFSTR(""),
																		kCFStringEncodingUTF8) autorelease];
}

static NSArray* _SpecialAbreviations() {
	static NSArray* array = nil;
	if (array == nil) {
		OSSpinLockLock(&_staticSpinLock);
		if (array == nil) {
			array = [[NSArray alloc] initWithObjects:@"vs", @"st", nil];
		}
		OSSpinLockUnlock(&_staticSpinLock);
	}
	return array;
}

// http://www.attivio.com/blog/57-unified-information-access/263-doing-things-with-words-part-two-sentence-boundary-detection.html
static void _ScanSentence(NSScanner* scanner) {
	NSUInteger initialLocation = scanner.scanLocation;
	while (1) {
		// Find next sentence boundary (return if at end)
		[scanner scanUpToCharactersFromSet:_GetCachedCharacterSet(kCharacterSet_SentenceBoundariesAndNewlineCharacter) intoString:NULL];
		if ([scanner isAtEnd]) {
			break;
		}
		NSUInteger boundaryLocation = scanner.scanLocation;

		// Skip sentence boundary (return if boundary is a newline or if at end)
		if (![scanner scanCharactersFromSet:_GetCachedCharacterSet(kCharacterSet_SentenceBoundaries) intoString:NULL]) {
			break;
		}
		if ([scanner isAtEnd]) {
			break;
		}

		// Make sure sentence boundary is followed by whitespace or newline
		NSRange range = [scanner.string rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline)
														options:NSAnchoredSearch
														  range:NSMakeRange(scanner.scanLocation, 1)];
		if (range.location == NSNotFound) {
			continue;
		}

		// Extract previous token
		range = [scanner.string rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline)
												options:NSBackwardsSearch
												  range:NSMakeRange(initialLocation, boundaryLocation - initialLocation)];
		if (range.location == NSNotFound) {
			continue;
		}
		range = NSMakeRange(range.location + 1, boundaryLocation - range.location - 1);

		// Make sure previous token is a not special abreviation
		BOOL match = NO;
		for (NSString* abreviation in _SpecialAbreviations()) {
			if (abreviation.length == range.length) {
				NSRange temp = [scanner.string rangeOfString:abreviation options:(NSAnchoredSearch | NSCaseInsensitiveSearch) range:range];
				if (temp.location != NSNotFound) {
					match = YES;
					break;
				}
			}
		}
		if (match) {
			continue;
		}

		// Make sure previous token does not contain a period or is more than 4 characters long or is followed by an uppercase letter
		NSRange subrange = [scanner.string rangeOfString:@"." options:0 range:range];
		if ((subrange.location != NSNotFound) && (range.length < 4)) {
			subrange = [scanner.string rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline_Inverted)
													   options:0
														 range:NSMakeRange(scanner.scanLocation,
																		   scanner.string.length - scanner.scanLocation)];
			subrange = [scanner.string rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_UppercaseLetters)
													   options:NSAnchoredSearch
														 range:NSMakeRange(subrange.location != NSNotFound ?
																		   subrange.location : scanner.scanLocation, 1)];
			if (subrange.location == NSNotFound) {
				continue;
			}
		}

		// We have found a sentence
		break;
	}
}

- (NSString*) extractFirstSentence {
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	scanner.charactersToBeSkipped = nil;
	_ScanSentence(scanner);
	self = [self substringToIndex:scanner.scanLocation];
	[scanner release];
	return self;
}

- (NSA*) extractAllSentences {
	NSMutableArray* array = [NSMutableArray array];
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	scanner.charactersToBeSkipped = nil;
	while (1) {
		[scanner scanCharactersFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline) intoString:NULL];
		if ([scanner isAtEnd]) {
			break;
		}
		NSUInteger location = scanner.scanLocation;
		_ScanSentence(scanner);
		if (scanner.scanLocation > location) {
			[array addObject:[self substringWithRange:NSMakeRange(location, scanner.scanLocation - location)]];
		}
	}
	[scanner release];
	return array;
}

- (NSIndexSet*) extractSentenceIndices {
	NSMutableIndexSet* set = [NSMutableIndexSet indexSet];
	NSScanner* scanner = [[NSScanner alloc] initWithString:self];
	scanner.charactersToBeSkipped = nil;
	while (1) {
		NSUInteger location = scanner.scanLocation;
		_ScanSentence(scanner);
		if (scanner.scanLocation > location) {
			[set addIndex:location];
		}
		[scanner scanCharactersFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline) intoString:NULL];
		if ([scanner isAtEnd]) {
			break;
		}
	}
	[scanner release];
	return set;
}

- (NSString*) stripParenthesis {
	NSMutableString* string = [NSMutableString string];
	NSRange range = NSMakeRange(0, self.length);
	while (range.length) {
		// Find location of start of parenthesis or end of string otherwise
		NSRange subrange = [self rangeOfString:@"(" options:0 range:range];
		if (subrange.location == NSNotFound) {
			subrange.location = range.location + range.length;
		} else {
			// Adjust the location to contain whitespace preceding the parenthesis
			NSRange subrange2 = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline_Inverted)
													  options:NSBackwardsSearch
														range:NSMakeRange(range.location, subrange.location - range.location)];
			if (subrange2.location + 1 < subrange.location) {
				subrange.length += subrange.location - subrange2.location - 1;
				subrange.location = subrange2.location + 1;
			}
		}

		// Copy characters until location
		[string appendString:[self substringWithRange:NSMakeRange(range.location, subrange.location - range.location)]];
		range.length -= subrange.location - range.location;
		range.location = subrange.location;

		// Skip characters from location to end of parenthesis or end of string otherwise
		if (range.length) {
			subrange = [self rangeOfString:@")" options:0 range:range];
			if (subrange.location == NSNotFound) {
				subrange.location = range.location + range.length;
			} else {
				subrange.location += 1;
			}
			range.length -= subrange.location - range.location;
			range.location = subrange.location;
		}
	}
	return string;
}

- (BOOL) containsString:(NSString*)string {
	NSRange range = [self rangeOfString:string];
	return range.location != NSNotFound;
}

- (NSA*) extractAllWords {
	NSCharacterSet* characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
	if (self.length) {
		NSMutableArray* array = [NSMutableArray array];
		NSScanner* scanner = [[NSScanner alloc] initWithString:self];
		scanner.charactersToBeSkipped = nil;
		while (1) {
			[scanner scanCharactersFromSet:characterSet intoString:NULL];
			NSString* string;
			if (![scanner scanUpToCharactersFromSet:characterSet intoString:&string]) {
				break;
			}
			[array addObject:string];
		}
		[scanner release];
		return array;
	}
	return nil;
}

- (NSRange) rangeOfWordAtLocation:(NSUInteger)location {
	NSCharacterSet* characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
	if (![characterSet characterIsMember:[self characterAtIndex:location]]) {
		NSRange start = [self rangeOfCharacterFromSet:characterSet options:NSBackwardsSearch range:NSMakeRange(0, location)];
		if (start.location == NSNotFound) {
			start.location = 0;
		} else {
			start.location = start.location + 1;
		}
		NSRange end = [self rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(location + 1, self.length - location - 1)];
		if (end.location == NSNotFound) {
			end.location = self.length;
		}
		return NSMakeRange(start.location, end.location - start.location);
	}
	return NSMakeRange(NSNotFound, 0);
}

- (NSRange) rangeOfNextWordFromLocation:(NSUInteger)location {
	NSCharacterSet* characterSet = _GetCachedCharacterSet(kCharacterSet_WordBoundaries);
	if ([characterSet characterIsMember:[self characterAtIndex:location]]) {
		NSRange start = [self rangeOfCharacterFromSet:[characterSet invertedSet] options:0 range:NSMakeRange(location,
																											 self.length - location)];
		if (start.location != NSNotFound) {
			NSRange end = [self rangeOfCharacterFromSet:characterSet options:0 range:NSMakeRange(start.location,
																								 self.length - start.location)];
			if (end.location == NSNotFound) {
				end.location = self.length;
			}
			return NSMakeRange(start.location, end.location - start.location);
		}
	}
	return NSMakeRange(NSNotFound, 0);
}

- (NSString*) stringByDeletingPrefix:(NSString*)prefix {
	if ([self hasPrefix:prefix]) {
		return [self substringFromIndex:prefix.length];
	}
	return self;
}

- (NSString*) stringByDeletingSuffix:(NSString*)suffix {
	if ([self hasSuffix:suffix]) {
		return [self substringToIndex:(self.length - suffix.length)];
	}
	return self;
}

- (NSString*) stringByReplacingPrefix:(NSString*)prefix withString:(NSString*)string {
	if ([self hasPrefix:prefix]) {
		return [string stringByAppendingString:[self substringFromIndex:prefix.length]];
	}
	return self;
}

- (NSString*) stringByReplacingSuffix:(NSString*)suffix withString:(NSString*)string {
	if ([self hasSuffix:suffix]) {
		return [[self substringToIndex:(self.length - suffix.length)] stringByAppendingString:string];
	}
	return self;
}

- (BOOL) isIntegerNumber {
	NSRange range = NSMakeRange(0, self.length);
	if (range.length) {
		unichar character = [self characterAtIndex:0];
		if ((character == '+') || (character == '-')) {
			range.location = 1;
			range.length -= 1;
		}
		range = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_DecimalDigits_Inverted) options:0 range:range];
		return range.location == NSNotFound;
	}
	return NO;
}

@end

@implementation NSMutableString (Extensions)

- (void) trimWhitespaceAndNewlineCharacters {
	NSRange range = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline_Inverted)];
	if ((range.location != NSNotFound) && (range.location > 0)) {
		[self deleteCharactersInRange:NSMakeRange(0, range.location)];
	}
	range = [self rangeOfCharacterFromSet:_GetCachedCharacterSet(kCharacterSet_WhitespaceAndNewline_Inverted)
								  options:NSBackwardsSearch];
	if ((range.location != NSNotFound) && (range.location < self.length - 1)) {
		[self deleteCharactersInRange:NSMakeRange(range.location, self.length - range.location)];
	}
}

@end


@implementation NSDate (Extensions)

// NSCalendar is not thread-safe so we use a singleton protected by a spinlock
static inline NSCalendar* _GetSharedCalendar() {
	static NSCalendar* calendar = nil;
	if (calendar == nil) {
		calendar = [NSCalendar currentCalendar];
	}
	DCHECK(calendar.timeZone == [NSTimeZone defaultTimeZone]);
	calendar.timeZone = [NSTimeZone defaultTimeZone];  // This should be a no-op if the timezone hasn't changed
	return calendar;
}

+ (NSDate*) dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
	return [self dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate*) dateWithYear:(NSUInteger)year
                   month:(NSUInteger)month
                     day:(NSUInteger)day
                    hour:(NSUInteger)hour
                  minute:(NSUInteger)minute
                  second:(NSUInteger)second {
	NSDateComponents* components = [[NSDateComponents alloc] init];
	components.year = year;
	components.month = month;
	components.day = day;
	components.hour = hour;
	components.minute = minute;
	components.second = second;
	OSSpinLockLock(&_calendarSpinLock);
	NSDate* date = [_GetSharedCalendar() dateFromComponents:components];
	OSSpinLockUnlock(&_calendarSpinLock);
	[components release];
	return date;
}

- (void) getYear:(NSUInteger*)year month:(NSUInteger*)month day:(NSUInteger*)day {
	[self getYear:year month:month day:day hour:NULL minute:NULL second:NULL];
}

- (void) getYear:(NSUInteger*)year
           month:(NSUInteger*)month
             day:(NSUInteger*)day
            hour:(NSUInteger*)hour
          minute:(NSUInteger*)minute
          second:(NSUInteger*)second {
	NSUInteger flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	OSSpinLockLock(&_calendarSpinLock);
	NSDateComponents* components = [_GetSharedCalendar() components:flags fromDate:self];
	OSSpinLockUnlock(&_calendarSpinLock);
	if (year) {
		*year = components.year;
	}
	if (month) {
		*month = components.month;
	}
	if (day) {
		*day = components.day;
	}
	if (hour) {
		*hour = components.hour;
	}
	if (minute) {
		*minute = components.minute;
	}
	if (second) {
		*second = components.second;
	}
}

- (NSUInteger) daySinceBeginningOfTheYear {
	OSSpinLockLock(&_calendarSpinLock);
	NSDateComponents* components = [_GetSharedCalendar() components:NSYearCalendarUnit fromDate:self];
	NSDate* date = [_GetSharedCalendar() dateFromComponents:components];
	components = [_GetSharedCalendar() components:NSDayCalendarUnit fromDate:date toDate:self options:0];
	OSSpinLockUnlock(&_calendarSpinLock);
	return components.day + 1;
}

- (NSDate*) dateRoundedToMidnight {
	NSUInteger year;
	NSUInteger month;
	NSUInteger day;
	[self getYear:&year month:&month day:&day];
	return [NSDate dateWithYear:year month:month day:day];
}

static NSDate* _GetReferenceDay() {
	static NSDate* date = nil;
	if (date == nil) {
		OSSpinLockLock(&_staticSpinLock);
		if (date == nil) {
			date = [[NSDate dateWithYear:2001 month:1 day:1] retain];
		}
		OSSpinLockUnlock(&_staticSpinLock);
	}
	return date;
}

+ (NSDate*) dateWithDaysSinceReferenceDate:(NSInteger)days {
	NSDate* date = _GetReferenceDay();
	NSDateComponents* components = [[NSDateComponents alloc] init];
	components.day = days;
	OSSpinLockLock(&_calendarSpinLock);
	date = [_GetSharedCalendar() dateByAddingComponents:components toDate:date options:0];
	OSSpinLockUnlock(&_calendarSpinLock);
	[components release];
	return date;
}

- (NSInteger) daysSinceReferenceDate {
	NSDate* date = _GetReferenceDay();
	OSSpinLockLock(&_calendarSpinLock);
	NSDateComponents* components = [_GetSharedCalendar() components:NSDayCalendarUnit fromDate:date toDate:self options:0];
	OSSpinLockUnlock(&_calendarSpinLock);
	return components.day;
}

// NSDateFormatter is not thread-safe so this function is protected with a spinlock
static NSDateFormatter* _GetDateFormatter(NSString* format, NSString* identifier, NSTimeZone* timeZone) {
	static NSMutableDictionary* cacheLevel0 = nil;
	if (cacheLevel0 == nil) {
		cacheLevel0 = [[NSMutableDictionary alloc] init];
	}

	NSMutableDictionary* cacheLevel1 = [cacheLevel0 objectForKey:(identifier ? identifier : @"")];
	if (cacheLevel1 == nil) {
		cacheLevel1 = [[NSMutableDictionary alloc] init];
		[cacheLevel0 setObject:cacheLevel1 forKey:(identifier ? identifier : @"")];
		[cacheLevel1 release];
	}

	NSMutableDictionary* cacheLevel2 = [cacheLevel1 objectForKey:(timeZone ? [timeZone name] : @"")];
	if (cacheLevel2 == nil) {
		cacheLevel2 = [[NSMutableDictionary alloc] init];
		[cacheLevel1 setObject:cacheLevel2 forKey:(timeZone ? [timeZone name] : @"")];
		[cacheLevel2 release];
	}

	NSDateFormatter* formatter = [cacheLevel2 objectForKey:format];
	if (formatter == nil) {
		formatter = [[NSDateFormatter alloc] init];
		formatter.locale = identifier ? [[[NSLocale alloc] initWithLocaleIdentifier:identifier] autorelease] : [NSLocale currentLocale];
		formatter.timeZone = timeZone ? timeZone : [NSTimeZone defaultTimeZone];
		formatter.dateFormat = format;
		[cacheLevel2 setObject:formatter forKey:format];
		[formatter release];
	}

	return formatter;
}

+ (NSDate*) dateWithString:(NSString*)string cachedFormat:(NSString*)format {
	return [self dateWithString:string cachedFormat:format localIdentifier:nil timeZone:nil];
}

+ (NSDate*) dateWithString:(NSString*)string cachedFormat:(NSString*)format localIdentifier:(NSString*)identifier {
	return [self dateWithString:string cachedFormat:format localIdentifier:identifier timeZone:nil];
}

+ (NSDate*) dateWithString:(NSString*)string
              cachedFormat:(NSString*)format
           localIdentifier:(NSString*)identifier
                  timeZone:(NSTimeZone*)timeZone {
	OSSpinLockLock(&_formattersSpinLock);
	NSDateFormatter* formatter = _GetDateFormatter(format, identifier, timeZone);
	NSDate* date = [formatter dateFromString:string];
	OSSpinLockUnlock(&_formattersSpinLock);
	return date;
}

- (NSString*) stringWithCachedFormat:(NSString*)format {
	return [self stringWithCachedFormat:format localIdentifier:nil timeZone:nil];
}

- (NSString*) stringWithCachedFormat:(NSString*)format localIdentifier:(NSString*)identifier {
	return [self stringWithCachedFormat:format localIdentifier:identifier timeZone:nil];
}
- (NSString*) stringWithCachedFormat:(NSString*)format localIdentifier:(NSString*)identifier timeZone:(NSTimeZone*)timeZone {
	OSSpinLockLock(&_formattersSpinLock);
	NSDateFormatter* formatter = _GetDateFormatter(format, identifier, timeZone);
	NSString* string = [formatter stringFromDate:self];
	OSSpinLockUnlock(&_formattersSpinLock);
	return string;
}

@end

@implementation NSProcessInfo (Extensions)

// From http://developer.apple.com/mac/library/qa/qa2004/qa1361.html
- (BOOL) isDebuggerAttached {
	struct kinfo_proc info;
	info.kp_proc.p_flag = 0;

	int mib[4];
	mib[0] = CTL_KERN;
	mib[1] = KERN_PROC;
	mib[2] = KERN_PROC_PID;
	mib[3] = getpid();
	size_t size = sizeof(info);
	int result = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);

	return !result && (info.kp_proc.p_flag & P_TRACED);  // We're being debugged if the P_TRACED flag is set
}

@end

@implementation NSURL (Extensions)

- (NSDictionary*) parseQueryParameters:(BOOL)unescape {
	NSMutableDictionary* parameters = nil;
	NSString* query = [self query];
	if (query) {
		parameters = [NSMutableDictionary dictionary];
		NSScanner* scanner = [[NSScanner alloc] initWithString:query];
		[scanner setCharactersToBeSkipped:nil];
		while (1) {
			NSString* key = nil;
			if (![scanner scanUpToString:@"=" intoString:&key] || [scanner isAtEnd]) {
				break;
			}
			[scanner setScanLocation:([scanner scanLocation] + 1)];

			NSString* value = nil;
			if (![scanner scanUpToString:@"&" intoString:&value]) {
				break;
			}

			if (unescape) {
				[parameters setObject:[value unescapeURLString] forKey:[key unescapeURLString]];
			} else {
				[parameters setObject:value forKey:key];
			}

			if ([scanner isAtEnd]) {
				break;
			}
			[scanner setScanLocation:([scanner scanLocation] + 1)];
		}
		[scanner release];
	}
	return parameters;
}

@end

@implementation NSMutableURLRequest (Extensions)

// http://www.w3.org/TR/html401/interact/forms.html#h-17.13.4.2 - TODO: Use "multipart/mixed" in case of multiple file attachments
+ (NSData*) HTTPBodyWithMultipartBoundary:(NSString*)boundary formArguments:(NSDictionary*)arguments {
	NSMutableData* body = [NSMutableData data];
	for (NSString* key in arguments) {
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		id value = [arguments objectForKey:key];
		if ([value isKindOfClass:[NSDictionary class]]) {
			NSString* disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
									 key, [value objectForKey:kMultipartFileKey_FileName]];  // TODO: Properly encode filename
			[body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
			NSString* type = [NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", [value objectForKey:kMultipartFileKey_MimeType]];
			[body appendData:[type dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[value objectForKey:kMultipartFileKey_FileData]];
		} else if ([value isKindOfClass:[NSString class]]) {
			NSString* disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];  // Content-Type defaults to "text/plain"
			[body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[(NSString*)value dataUsingEncoding:NSUTF8StringEncoding]];
		} else if ([value isKindOfClass:[NSData class]]) {
			NSString* disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];  // Content-Type defaults to "text/plain"
			[body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:value];
		} else {
			NOT_REACHED();
		}
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	return body;
}

- (void) setHTTPBodyWithMultipartFormArguments:(NSDictionary*)arguments; {
	NSString* boundary = @"0xKhTmLbOuNdArY";
	[self setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
	[self setHTTPBody:[[self class] HTTPBodyWithMultipartBoundary:boundary formArguments:arguments]];
}

@end

@implementation NSTimeZone (Extensions)

+ (NSTimeZone*) GMTTimeZone {
	static NSTimeZone* timeZone = nil;
	if (timeZone == nil) {
		timeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
		DCHECK(timeZone);
	}
	return timeZone;
}

@end
