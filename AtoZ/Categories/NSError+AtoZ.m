//
//  NSError+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 10/18/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSError+AtoZ.h"

@implementation NSError (AtoZ)


static void _addMappedUserInfoValueToArray(const void *value, void *context);
static void _addMapppedUserInfoValueToDictionary(const void *key, const void *value, void *context);

static id _mapUserInfoValueToPlistValue(const void *value)
{
	id valueObject = (__bridge id)value;

	if (!valueObject)
		return @"<nil>";

	// Handle some specific non-plist values
	if ([valueObject isKindOfClass:[NSError class]])
		return [(NSError *)valueObject toPropertyList];

	if ([valueObject isKindOfClass:[NSURL class]])
		return [valueObject absoluteString];

	// Handle containers explicitly since they might contain non-plist values
	if ([valueObject isKindOfClass:[NSArray class]]) {
		NSMutableArray *mapped = [NSMutableArray array];
		CFArrayApplyFunction((CFArrayRef)valueObject, CFRangeMake(0, [valueObject count]), _addMappedUserInfoValueToArray, (__bridge void *)(mapped));
		return mapped;
	}
	if ([valueObject isKindOfClass:[NSSet class]]) {
		// Map sets to arrays.
		NSMutableArray *mapped = [NSMutableArray array];
		CFSetApplyFunction((CFSetRef)valueObject, _addMappedUserInfoValueToArray, (__bridge void *)(mapped));
		return mapped;
	}
	if ([valueObject ISADICT]) {
		NSMutableDictionary *mapped = [NSMutableDictionary dictionary];
		CFDictionaryApplyFunction((CFDictionaryRef)valueObject, _addMapppedUserInfoValueToDictionary, (__bridge void *)(mapped));
		return mapped;
	}

	// We can only bring along plist-able values (so, for example, no NSRecoveryAttempterErrorKey).
	if (![NSPropertyListSerialization propertyList:valueObject isValidForFormat:NSPropertyListXMLFormat_v1_0]) {
#ifdef DEBUG
		NSLog(@"'%@' of class '%@' is not a property list value.", valueObject, [valueObject class]);
#endif
		return [valueObject description];
	}

	return valueObject;
}

static void _addMappedUserInfoValueToArray(const void *value, void *context)
{
	id valueObject = _mapUserInfoValueToPlistValue(value);
//	OBASSERT(valueObject); // mapping returns something for nil
	[(NSMutableArray *)CFBridgingRelease(context) addObject:valueObject];
}

static void _addMapppedUserInfoValueToDictionary(const void *key, const void *value, void *context)
{
	NSString *keyString = (__bridge NSString *)key;
	id valueObject = (id)CFBridgingRelease(value);
	NSMutableDictionary *mappedUserInfo = (NSMutableDictionary *)CFBridgingRelease(context);

#if INCLUDE_BACKTRACE_IN_ERRORS
	if ([keyString isEqualToString:OBBacktraceAddressesErrorKey]) {
		// Transform this to symbol names when actually interested in it.
		NSData *frameData = valueObject;
		const void* const* frames = [frameData bytes];
		int frameCount = [frameData length] / sizeof(frames[0]);
		char **names = backtrace_symbols((void* const* )frames, frameCount);
		if (names) {
			NSMutableArray *namesArray = [NSMutableArray array];
			for (int nameIndex = 0; nameIndex < frameCount; nameIndex++)
				[namesArray addObject:[NSString stringWithCString:names[nameIndex] encoding:NSUTF8StringEncoding]];
			free(names);

			[mappedUserInfo setObject:namesArray forKey:OBBacktraceNamesErrorKey];
			return;
		}
	}
#endif

	valueObject = _mapUserInfoValueToPlistValue(CFBridgingRetain(valueObject));
	[mappedUserInfo setObject:valueObject forKey:keyString];
}


- (NSDictionary *)toPropertyList;
{
	NSMutableDictionary *plist = [NSMutableDictionary dictionary];

	[plist setObject:[self domain] forKey:@"domain"];
	[plist setObject:[NSNumber numberWithInteger:[self code]] forKey:@"code"];

	NSDictionary *userInfo = [self userInfo];
	if (userInfo)
		[plist setObject:_mapUserInfoValueToPlistValue(CFBridgingRetain(userInfo)) forKey:@"userInfo"];

	return plist;
}
@end
