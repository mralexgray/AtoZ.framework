//
//  NSDictionary+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 9/19/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSDictionary+AtoZ.h"



@implementation NSMutableDictionary (AtoZ)

- (void)setColor:(NSColor *)aColor forKey:(NSString *)aKey
{
    NSData *theData=[NSArchiver archivedDataWithRootObject:aColor];
    self[aKey] = theData;
}

- (NSColor *)colorForKey:(NSString *)aKey
{
    NSColor *theColor = nil;
    NSData *theData = self[aKey];
    if (theData != nil) theColor=(NSColor *)[NSUnarchiver unarchiveObjectWithData:theData];
    return theColor;
}

@end

@implementation  NSDictionary (AtoZ)
- (void)enumerateEachKeyAndObjectUsingBlock:(void(^)(id key, id obj))block{
    NSParameterAssert(block != nil);
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        block(key, obj);
    }];
}

- (void)enumerateEachSortedKeyAndObjectUsingBlock:(void(^)(id key, id obj, NSUInteger idx))block{
    NSParameterAssert(block != nil);
    NSArray *keys = [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, [self objectForKey:obj], idx);
    }];
}
@end


// This horrible hack is hereby placed in the public domain. I recommend never using it for anything.
#if 0
#define LOG NSLog
#else
#define LOG(...) do {} while (0)
#endif


static NSString *PropertyNameFromSetter(NSString *setterName)
{
	setterName = [setterName substringFromIndex:3];                // Remove "set"
	NSString *firstChar = [[setterName substringToIndex:1] lowercaseString];
	NSString *tail = [setterName substringFromIndex:1];
	tail = [tail substringToIndex:[tail length] - 1];        // Remove ":"
	return [firstChar stringByAppendingString:tail];        // Convert first char to lowercase.
}


static id DynamicDictionaryGetter(id self, SEL _cmd)
{
	return self[NSStringFromSelector(_cmd)];
}


static void DynamicDictionarySetter(id self, SEL _cmd, id value)
{
	NSString *key = PropertyNameFromSetter(NSStringFromSelector(_cmd));

	if (value == nil)
        {
		[self removeObjectForKey:key];
        }
	else
        {
		self[key] = value;
        }
}


@implementation NSDictionary (DynamicAccessors)

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
	NSString *selStr = NSStringFromSelector(sel);
        // Only handle selectors with no colon.
	if ([selStr rangeOfString:@":"].location == NSNotFound)
        {
		LOG(@"Generating dynamic accessor -%@", selStr);
		return class_addMethod(self, sel, (IMP)DynamicDictionaryGetter, @encode(id(*)(id, SEL)));
        }
	else
        {
		return [super resolveInstanceMethod:sel];
        }
}

@end

/**

@interface NSDictionary (MyProperties)
@property (retain) NSString *stringProp;
@property (retain) NSNumber *numberProp;
@end

NSMD *dict = [NSMD dictionary];
dict.stringProp = @"This is a string";
dict.numberProp = @42;

 */

@implementation NSMutableDictionary (DynamicAccessors)

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
	NSString *selStr = NSStringFromSelector(sel);
        // Only handle selectors beginning with "set", ending with a colon and with no intermediate colons.
        // Also, to simplify PropertyNameFromSetter, we requre a length of at least 5 (2 + "set").
	if ([selStr hasPrefix:@"set"] &&
		[selStr hasSuffix:@":"] &&
		[selStr rangeOfString:@":" options:0 range:NSMakeRange(0, [selStr length] - 1)].location == NSNotFound &&
		[selStr length] >= 6)
        {
		LOG(@"Generating dynamic accessor -%@ for property \"%@\"", selStr, PropertyNameFromSetter(selStr));
		return class_addMethod(self, sel, (IMP)DynamicDictionarySetter, @encode(id(*)(id, SEL, id)));
        }
	else
        {
		return [super resolveInstanceMethod:sel];
        }
}

@end


#include <stdlib.h>


#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
#define CGPointValue pointValue
#define CGRectValue rectValue
#define CGSizeValue sizeValue
#else
#import <UIKit/UIGeometry.h>
#define NSPointFromString CGPointFromString
#define NSRectFromString CGRectFromString
#define NSSizeFromString CGSizeFromString
#define NSZeroPoint CGPointZero
#define NSZeroSize CGSizeZero
#define NSZeroRect CGRectZero
#endif

#define SAFE_ALLOCA_SIZE (8 * 8192)

@implementation NSDictionary (OFExtensions)

- (id)anyObject;
{
    for (NSString *key in self)
        return self[key];
    return nil;
}

/*" Returns an object which is a shallow copy of the receiver except that the given key now maps to anObj. anObj may be nil in order to remove the given key from the dictionary. "*/
- (NSDictionary *)dictionaryWithObject:(id)anObj forKey:(NSString *)key;
{
    NSUInteger keyCount = [self count];

    if (keyCount == 0 || (keyCount == 1 && self[key] != nil))
        return anObj ? @{key: anObj} : @{};

    if (self[key] == anObj)
        return [NSDictionary dictionaryWithDictionary:self];

    NSMutableArray *newKeys = [[NSMutableArray alloc] initWithCapacity:keyCount+1];
    NSMutableArray *newValues = [[NSMutableArray alloc] initWithCapacity:keyCount+1];

    for (NSString *aKey in self) {
        if (![aKey isEqual:key]) {
            [newKeys addObject:aKey];
            [newValues addObject:self[aKey]];
        }
    }

    if (anObj != nil) {
        [newKeys addObject:key];
        [newValues addObject:anObj];
    }

    NSDictionary *result = [NSDictionary dictionaryWithObjects:newValues forKeys:newKeys];
    [newKeys release];
    [newValues release];

    return result;
}

/*" Returns an object which is a shallow copy of the receiver except that the key-value pairs from aDictionary are included (overriding existing key-value associations if they existed). "*/

//struct dictByAddingContext {
//    id *keys;
//    id *values;
//    NSUInteger kvPairsUsed;
//    BOOL differs;
//    CFDictionaryRef older, newer;
//};

//static void copyWithOverride(const void *aKey, const void *aValue, void *_context)
//{
//    struct dictByAddingContext *context = _context;
//    NSUInteger used = context->kvPairsUsed;
//
//    const void *otherValue = CFDictionaryGetValue(context->newer, aKey);
//    if (otherValue && otherValue != aValue) {
//        context->values[used] = (id)otherValue;
//        context->differs = YES;
//    } else {
//        context->values[used] = (id)aValue;
//    }
//    context->keys[used] = (id)aKey;
//    context->kvPairsUsed = used+1;
//}

//static void copyNewItems(const void *aKey, const void *aValue, void *_context)
//{
//    struct dictByAddingContext *context = _context;
//
//    if(CFDictionaryContainsKey(context->older, aKey)) {
//			// Value will already have been chaecked by copyWithOverride().
//    } else {
//        NSUInteger used = context->kvPairsUsed;
//        context->keys[used] = (id)aKey;
//        context->values[used] = (id)aValue;
//        context->differs = YES;
//        context->kvPairsUsed = used+1;
//    }
//}

//- (NSDictionary *)dictionaryByAddingObjectsFromDictionary:(NSDictionary *)otherDictionary;
//{
//    struct dictByAddingContext context;
//
//    if (!otherDictionary)
//        goto nochange_noalloc;
//
//    NSUInteger myKeyCount = [self count];
//    NSUInteger otherKeyCount = [otherDictionary count];
//
//    if (!otherKeyCount)
//        goto nochange_noalloc;
//
//    context.keys = calloc(myKeyCount+otherKeyCount, sizeof(*(context.keys)));
//    context.values = calloc(myKeyCount+otherKeyCount, sizeof(*(context.values)));
//    context.kvPairsUsed = 0;
//    context.differs = NO;
//    context.older = (CFDictionaryRef)self;
//    context.newer = (CFDictionaryRef)otherDictionary;
//
//    CFDictionaryApplyFunction((CFDictionaryRef)self, copyWithOverride, &context);
//    CFDictionaryApplyFunction((CFDictionaryRef)otherDictionary, copyNewItems, &context);
//    if (!context.differs)
//        goto nochange;
//
//    NSDictionary *newDictionary = [NSDictionary dictionaryWithObjects:context.values forKeys:context.keys count:context.kvPairsUsed];
//    free(context.keys);
//    free(context.values);
//    return newDictionary;
//
//nochange:
//    free(context.keys);
//    free(context.values);
//nochange_noalloc:
//    return [NSDictionary dictionaryWithDictionary:self];
//}

- (NSString *)keyForObjectEqualTo:(id)anObject;
{
    for (NSString *key in self)
        if ([self[key] isEqual:anObject])
			return key;
    return nil;
}

- (NSString *)stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
{
    id object = self[key];
    if (![object isKindOfClass:[NSString class]])
        return defaultValue;
    return object;
}

- (NSString *)stringForKey:(NSString *)key;
{
    return [self stringForKey:key defaultValue:nil];
}

- (NSArray *)stringArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
{
#ifdef OMNI_ASSERTIONS_ON
    for (id value in defaultValue)
        OBPRECONDITION([value isKindOfClass:[NSString class]]);
#endif
    NSArray *array = self[key];
    if (![array isKindOfClass:[NSArray class]])
        return defaultValue;
    for (id value in array) {
        if (![value isKindOfClass:[NSString class]])
            return defaultValue;
    }
    return array;
}

- (NSArray *)stringArrayForKey:(NSString *)key;
{
    return [self stringArrayForKey:key defaultValue:nil];
}

- (float)floatForKey:(NSString *)key defaultValue:(float)defaultValue;
{
    id value = self[key];
    if (value)
        return [value floatValue];
    return defaultValue;
}

- (float)floatForKey:(NSString *)key;
{
    return [self floatForKey:key defaultValue:0.0f];
}

- (double)doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
{
    id value = self[key];
    if (value)
        return [value doubleValue];
    return defaultValue;
}

- (double)doubleForKey:(NSString *)key;
{
    return [self doubleForKey:key defaultValue:0.0];
}

- (CGPoint)pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue;
{
    id value = self[key];
    if ([value isKindOfClass:[NSString class]] && ![(NSS*)value isEqualToString:@""])
        return NSPointFromString(value);
    else if ([value isKindOfClass:[NSValue class]])
        return [value CGPointValue];
    else
        return defaultValue;
}

- (CGPoint)pointForKey:(NSString *)key;
{
    return [self pointForKey:key defaultValue:NSZeroPoint];
}

- (CGSize)sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
{
    id value = self[key];
    if ([value isKindOfClass:[NSString class]] && ![(NSS*)value isEqualToString:@""])
        return NSSizeFromString(value);
    else if ([value isKindOfClass:[NSValue class]])
        return [value CGSizeValue];
    else
        return defaultValue;
}

- (CGSize)sizeForKey:(NSString *)key;
{
    return [self sizeForKey:key defaultValue:NSZeroSize];
}

- (CGRect)rectForKey:(NSString *)key defaultValue:(CGRect)defaultValue;
{
    id value = self[key];
    if ([value isKindOfClass:[NSString class]] && ![(NSS*)value isEqualToString:@""])
        return NSRectFromString(value);
    else if ([value isKindOfClass:[NSValue class]])
        return [value CGRectValue];
    else
        return defaultValue;
}

- (CGRect)rectForKey:(NSString *)key;
{
    return [self rectForKey:key defaultValue:NSZeroRect];
}

- (BOOL)boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
{
    id value = self[key];

    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
        return [value boolValue];

    return defaultValue;
}

- (BOOL)boolForKey:(NSString *)key;
{
    return [self boolForKey:key defaultValue:NO];
}

- (int)intForKey:(NSString *)key defaultValue:(int)defaultValue;
{
    id value = self[key];
    if (!value)
        return defaultValue;
    return [value intValue];
}

- (int)intForKey:(NSString *)key;
{
    return [self intForKey:key defaultValue:0];
}

- (unsigned int)unsignedIntForKey:(NSString *)key defaultValue:(unsigned int)defaultValue;
{
    id value = self[key];
    if (value == nil)
        return defaultValue;
    return [value unsignedIntValue];
}

- (unsigned int)unsignedIntForKey:(NSString *)key;
{
    return [self unsignedIntForKey:key defaultValue:0];
}

- (unsigned long long int)unsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long int)defaultValue;
{
    id value = self[key];
    if (value == nil)
        return defaultValue;
    return [value unsignedLongLongValue];
}

- (unsigned long long int)unsignedLongLongForKey:(NSString *)key;
{
    return [self unsignedLongLongForKey:key defaultValue:0ULL];
}

- (NSInteger)integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
{
    id value = self[key];
    if (!value)
        return defaultValue;
    return [value integerValue];
}

- (NSInteger)integerForKey:(NSString *)key;
{
    return [self integerForKey:key defaultValue:0];
}


- (id)objectForKey:(NSString *)key defaultObject:(id)defaultObject;
{
    id value = self[key];
    if (value)
        return value;
    return defaultObject;
}

- (id)deepMutableCopy;
{
    NSMutableDictionary *newDictionary = [self mutableCopy];
		// Run through the new dictionary and replace any objects that respond to -deepMutableCopy or -mutableCopy with copies.
    for (id aKey in self) {
		id anObject = newDictionary[aKey];
        if ([anObject respondsToSelector:@selector(deepMutableCopy)]) {
            anObject = [(NSDictionary *)anObject deepMutableCopy];
            newDictionary[aKey] = anObject;
            [anObject release];
        } else if ([anObject conformsToProtocol:@protocol(NSMutableCopying)]) {
            anObject = [anObject mutableCopy];
            newDictionary[aKey] = anObject;
            [anObject release];
        } else
            newDictionary[aKey] = anObject;
    }

    return newDictionary;
}


@end


@implementation NSDictionary (OFDeprecatedExtensions)

- (id)valueForKey:(NSString *)key defaultValue:(id)defaultValue;
{
    return [self objectForKey:key defaultObject:defaultValue];
}

@end
