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

//Returns NO if `anObject` is nil; can be used by the sender of the message or ignored if it is irrelevant.
- (BOOL)setObjectOrNull:(id)anObject forKey:(id)aKey
{
	if(anObject!=nil) {		[self setObject:anObject forKey:aKey]; 		return YES; }
	else {					[self setObject:[NSNull null] forKey:aKey];	return NO;	}
}


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
@implementation NSDictionary (objectForKeyList)

- (id)objectForKeyList:(id)key, ...
{
	id object = self;	va_list ap; 	va_start(ap, key);
	for ( ; key; key = va_arg(ap, id))	object = [object objectForKey:key];
	va_end(ap);	return object;
}
@end

@implementation NSDictionary(GetObjectForKeyPath)

//	syntax of path similar to Java: record.array[N].item
//	items are separated by . and array indices in []
//	example: a.b[N][M].c.d

- (id)objectForKeyPath:(NSString *)inKeyPath
{
	NSArray	*components = [inKeyPath componentsSeparatedByString:@"."]	;
	int		i, j, n = [components count], m	;
	id		curContainer = self	;

	for (i=0; i<n ; i++)	{
		NSString	*curPathItem = [components objectAtIndex:i]	;
		NSArray		*indices = [curPathItem componentsSeparatedByString:@"["]	;

		m = [indices count]	;
		if (m == 1)	{	// no [ -> object is a dict or a leave
			curContainer = [curContainer objectForKey:curPathItem]	;
		}
		else	{
			//	indices is an array of string "arrayKeyName" "i1]" "i2]" "i3]"
			//	arrayKeyName equal to curPathItem

			if (![curContainer isKindOfClass:[NSDictionary class]])
				return nil	;

			curPathItem = [curPathItem substringToIndex:[curPathItem rangeOfString:@"["].location]	;
			curContainer = [curContainer objectForKey:curPathItem]	;

			for(j=1;j<m;j++)	{
				int	index = [[indices objectAtIndex:j] intValue]	;

				if (![curContainer isKindOfClass:[NSArray class]])
					return nil	;

				if (index >= [curContainer count])
					return nil	;

				curContainer = [curContainer objectAtIndex:index];
			}
		}

	}

	return curContainer	;
}

-(void)setObject:(id)inValue forKeyPath:(NSString *)inKeyPath
{
	NSArray	*components = [inKeyPath componentsSeparatedByString:@"."]	;
	int		i, j, n = [components count], m	;
	id		containerContainer = nil	;
	id		curContainer = self	;
	NSString	*curPathItem = nil	;
	NSArray		*indices	;
	int			index	;
	BOOL		needArray = NO	;

	for (i=0; i<n ; i++)	{

		curPathItem = [components objectAtIndex:i]	;
		indices = [curPathItem componentsSeparatedByString:@"["]	;
		m = [indices count]	;


		if (m == 1)	{
			if ([curContainer isKindOfClass:[NSNull class]])	{
				curContainer = [NSMutableDictionary dictionary]	;
				if (needArray)	{
					[containerContainer replaceObjectAtIndex:index  withObject:curContainer]	;
				}
				else	{
					[containerContainer setObject:curContainer forKey:curPathItem]	;
				}
			}

			containerContainer = curContainer	;
			curContainer = [curContainer objectForKey:curPathItem]	;

			needArray = NO	;
			if (![containerContainer isKindOfClass:[NSDictionary class]])
				[NSException raise:@"Path item not a dictionary" format:@"(keyPath %@ - offending %@)",inKeyPath,curPathItem]	;

			if (curContainer == nil)	{
				curContainer = [NSMutableDictionary dictionary]	;
				[containerContainer setObject:curContainer forKey:curPathItem]	;
			}
		}
		else	{
			needArray = YES	;
			//	indices is an array of string "arrayKeyName" "i1]" "i2]" "i3]"
			//	arrayKeyName equal to curPathItem
			curPathItem = [curPathItem substringToIndex:[curPathItem rangeOfString:@"["].location]	;
			containerContainer = curContainer	;
			curContainer = [curContainer objectForKey:curPathItem]	;

			if (curContainer == nil)	{
				curContainer = [NSMutableArray array]	;
				[containerContainer setObject:curContainer forKey:curPathItem]	;
			}

			if (![curContainer isKindOfClass:[NSArray class]])
				[NSException raise:@"Path item not an array" format:@"(keyPath %@ - offending %@)",inKeyPath,curPathItem]	;

			for(j=1;j<m-1;j++)	{
				index = [[indices objectAtIndex:j] intValue]	;

				containerContainer = curContainer	;
				curContainer = [curContainer objectAtIndex:index]	;
				if ([curContainer isKindOfClass:[NSNull class]])	{
					curContainer = [NSMutableArray array]	;
					[containerContainer replaceObjectAtIndex:index withObject:curContainer]	;
				}
				else	if (![curContainer isKindOfClass:[NSArray class]])
					[NSException raise:@"Path item not an array" format:@"(keyPath %@ - offending %@ index %d)",inKeyPath,curPathItem,j-1]	;
			}

			index = [[indices objectAtIndex:m-1] intValue]	;

			if (index >= [curContainer count])	{
				int	k	;

				for (k=[curContainer count]; k<=index; k++)
					[curContainer addObject:[NSNull null]]	;
			}

			containerContainer = curContainer	;
			curContainer = [curContainer objectAtIndex:index]	;
		}

	}

	if (needArray)	{	// containerContainer must be an array
		if (![containerContainer isKindOfClass:[NSArray class]])
			[NSException raise:@"Last path item is not an array" format:@"(keyPath %@)",inKeyPath]	;
		[containerContainer	replaceObjectAtIndex:index withObject:inValue]	;
	}
	else	{
		if (![containerContainer isKindOfClass:[NSDictionary class]])
			[NSException raise:@"Before-last path item is not a dictionary" format:@"(keyPath %@)",inKeyPath]	;

		[containerContainer setObject:inValue forKey:curPathItem]	;
	}
}
@end


@implementation NSArray (FindDictionary)

- (id)findDictionaryWithValue:(id)value
{
    __block id match = nil;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		match = [obj isKindOfClass:[NSArray class]] ? [self findDictionaryWithValue:value]
		: [obj isKindOfClass:[NSDictionary class]]  ? [(NSD*)obj findDictionaryWithValue:value] : nil;
		*stop = (match!=nil);
	}];
	return match;
}
@end



@implementation  NSObject  (BagofKeysValue)

//- (NSBag*) bagWithValuesForKey:(NSString *)key
//{
//	__block NSBag* newbag = [NSBag new];
//	if ([self isKindOfClass:[NSDictionary class]]) {
//		if([self.allKeys containsObject:key]) {  [newbag add:self[key]]; }
//  		[self.allKeys each:^(NSS* k){
//			id obj = [self objectForKey:k];
//			if([obj isKindOfClass:[NSDictionary class]]) {
//            // we found a child dictionary, let's traverse it
//            NSDictionary *d = (NSDictionary *)obj;
//            id child = [d recursiveObjectForKey:key];
//            if(child) return child;
//        }
//	else if([obj isKindOfClass:[NSArray class]]) {
//            // loop through the NSArray and traverse any dictionaries found
//            NSArray *a = (NSArray *)obj;
//            for(id child in a) {
//                if([child isKindOfClass:[NSDictionary class]]) {
//                    NSDictionary *d = (NSDictionary *)child;
//                    id o = [d recursiveObjectForKey:key];
//                    if(o) return o;
//                }
//            }
//        }
//    }
////
////    // the key was not found in this dictionary or any of it's children
////    return nil;
//}


@end
@implementation NSArray (Recurse)

//- (NSA*) recursiveValuesForKey:(NSS*) key
//{
// 	NSA* u = [self findDictionaryWithValue:<#(id)#>:^id(id obj) {
//		if ( [obj isKindOfClass:[NSDictionary class]]) {
//                if([child isKindOfClass:[NSDictionary class]]) {
//                    NSDictionary *d = (NSDictionary *)child;
//                    id o = [d recursiveObjectForKey:key];
//                    if(o) return o;
//                }
//            }

@end

@implementation  NSDictionary (AtoZ)

//- (NSA*) recursiveObjectsForKey:(NSString *)key;
//{
//	__block NSMA *bag = [NSMA array];
//   if([self.allKeys containsObject:key]) {
//        // this dictionary contains the key, return the value
//        return [self objectForKey:key];
//    }
//     
//    for(NSString *k in self.allKeys) {
//        id obj = [self objectForKey:k];
//        if([obj isKindOfClass:[NSDictionary class]]) {
//            // we found a child dictionary, let's traverse it
//            NSDictionary *d = (NSDictionary *)obj;
//            id child = [d recursiveObjectForKey:key];
//            if(child) return child;
//        } else if([obj isKindOfClass:[NSArray class]]) {
//            // loop through the NSArray and traverse any dictionaries found
//            NSArray *a = (NSArray *)obj;
//            for(id child in a) {
//                if([child isKindOfClass:[NSDictionary class]]) {
//                    NSDictionary *d = (NSDictionary *)child;
//                    id o = [d recursiveObjectForKey:key];
//                    if(o) return o;
//                }
//            }
//        }
//    }
//     
//    // the key was not found in this dictionary or any of it's children
//    return nil;
//
//
//}


- (id) recursiveObjectForKey:(NSString *)key {
    if([self.allKeys containsObject:key]) {
        // this dictionary contains the key, return the value
        return [self objectForKey:key];
    }
     
    for(NSString *k in self.allKeys) {
        id obj = [self objectForKey:k];
        if([obj isKindOfClass:[NSDictionary class]]) {
            // we found a child dictionary, let's traverse it
            NSDictionary *d = (NSDictionary *)obj;
            id child = [d recursiveObjectForKey:key];
            if(child) return child;
        } else if([obj isKindOfClass:[NSArray class]]) {
            // loop through the NSArray and traverse any dictionaries found
            NSArray *a = (NSArray *)obj;
            for(id child in a) {
                if([child isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *d = (NSDictionary *)child;
                    id o = [d recursiveObjectForKey:key];
                    if(o) return o;
                }
            }
        }
    }
     
    // the key was not found in this dictionary or any of it's children
    return nil;
}


- (id)findDictionaryWithValue:(id)value
{
	__block id match = nil;
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		match = [obj isEqual:value] ? self
			  :	[obj isKindOfClass:[NSArray class]] ? [obj findDictionaryWithValue:value]
			  : [obj isKindOfClass:[self class]]    ? [obj findDictionaryWithValue:value] : nil;
		*stop = (match!=nil);
	}];
	return match;
}

// NSDictionary *resultDict = [self findDictionaryForValue:@"i'm an id" inArray:array];



+ (NSDictionary*) dictionaryWithValue:(id)value forKeys:(NSA*)keys
{
	__block NSMutableDictionary *dict = [NSMutableDictionary new];
	[keys do:^(id obj) { dict[obj] = value; }];
	return dict;
}


- (NSDictionary*) dictionaryWithValue:(id)value forKey:(id)key
{
	// Would be nice to make our own dictionary subclass that made this
	// more efficient.
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
	[dict setValue:value forKey:key];
	return dict;
}

- (NSDictionary*) dictionaryWithoutKey:(id)key
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
	[dict removeObjectForKey:key];
	return dict;
}

- (NSDictionary*) dictionaryWithKey:(id)newKey replacingKey:(id)oldKey;
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
	id value = dict[oldKey];
	if (value != nil) {
		[dict removeObjectForKey:oldKey];
		[dict setObject:value forKey:newKey];
	}
	return dict;
}

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


@implementation NSCountedSet (Votes)

- (id)winner {
	id winner = nil ;
	NSInteger highestCount = 0 ;
	for (id object in self) {
		NSInteger count = [self countForObject:object] ;
		if (count > highestCount) {
			highestCount = count ;
			winner = object ;
		}
		else if (count == highestCount) {
			winner = nil ;
		}
	}

	return winner ;
}

@end


@implementation NSArray (Subdictionaries)

//- (NSBag*) ojectsInSubdictionariesForKey:(id)key {
//	__block NSBag* objects = [NSBag bag];
//	[self each:^(id obj) {
//		if ([obj isKindOfClass:[NSDictionary class]]){
//			[(NSD*)obj objectsInSubdictionariesForKey:key withBag:objects]
//
//
//		id object = [obj objectForKey:key] ;
//		if (object) [objects add:object];
//	}];
////		else if (defaultObject) {
////			[objects add:defaultObject] ;
////		}
////	}
//	return objects ;
//}
@end
@implementation NSDictionary (Subdictionaries)

- (NSCountedSet*)objectsInSubdictionariesForKey:(id)key
								  defaultObject:(id)defaultObject {
	NSCountedSet* objects = [NSCountedSet set] ;
	for (NSDictionary* subdictionary in [self allValues]) {
		id object = [subdictionary objectForKey:key] ;
		if (object) {
			[objects addObject:object] ;
		}
		else if (defaultObject) {
			[objects addObject:defaultObject] ;
		}
	}

	return objects ;
}

@end

@implementation NSDictionary (SimpleMutations)

- (NSDictionary*)dictionaryBySettingValue:(id)value
								   forKey:(id)key {
	if (!key) {
		return [NSDictionary dictionaryWithDictionary:self] ;
	}

	NSMutableDictionary* mutant = [self mutableCopy] ;
	[mutant setValue:value
			  forKey:key] ;
	NSDictionary* newDic = [NSDictionary dictionaryWithDictionary:mutant] ;
	[mutant release] ;

	return newDic ;
}

- (NSDictionary*)dictionaryByAddingEntriesFromDictionary:(NSDictionary*)otherDic {
	NSMutableDictionary* mutant = [self mutableCopy] ;
	if (otherDic) {
		[mutant addEntriesFromDictionary:otherDic] ;
	}
	NSDictionary* newDic = [NSDictionary dictionaryWithDictionary:mutant] ;
	[mutant release] ;

	return newDic ;
}

- (NSDictionary*)dictionaryByAppendingEntriesFromDictionary:(NSDictionary*)otherDic {
	NSMutableDictionary* mutant = [self mutableCopy] ;
	for (id key in otherDic) {
		if ([self objectForKey:key] == nil) {
			[mutant setObject:[otherDic objectForKey:key]
					   forKey:key] ;
		}
	}
	NSDictionary* newDic = [NSDictionary dictionaryWithDictionary:mutant] ;
	[mutant release] ;

	return newDic ;
}

+ (void)mutateAdditions:(NSMutableDictionary*)additions
			  deletions:(NSMutableSet*)deletions
		   newAdditions:(NSMutableDictionary*)newAdditions
		   newDeletions:(NSMutableSet*)newDeletions {
	NSSet* immuterator ;

	// Remove from newAdditions and newDeletions any members
	// in these new inputs which cancel one another out
	immuterator = [[NSSet alloc] initWithArray:[newAdditions allKeys]] ;
	for (id key in immuterator) {
		id member = [newDeletions member:key] ;
		if (member) {
			[newAdditions removeObjectForKey:key] ;
			[newDeletions removeObject:member] ;
		}
	}
	[immuterator release] ;

	// Remove from newAdditions any which cancel out existing deletions,
	// and do the cancellation
	immuterator = [[NSSet alloc] initWithArray:[newAdditions allKeys]] ;
	for (id key in immuterator) {
		id member = [deletions member:key] ;
		if (member) {
			[newAdditions removeObjectForKey:key] ;
			[deletions removeObject:member] ;
		}
	}
	[immuterator release] ;
	// Add surviving new additions to existing additions
	[additions addEntriesFromDictionary:newAdditions] ;

	// Remove from newDeletions any which cancel out existing additions,
	// and do the cancellation
	immuterator = [newDeletions copy] ;
	for (id key in immuterator) {
		id object = [additions objectForKey:key] ;
		if (object) {
			[newDeletions removeObject:key] ;
			[additions removeObjectForKey:key] ;
		}
	}
	[immuterator release] ;
	// Add surviving new deletions to existing deletions
	[deletions unionSet:newDeletions] ;
}

@end


@implementation NSDictionary (subdictionaryWithKeys)

- (NSDictionary*)subdictionaryWithKeys:(NSArray*)keys {
	//  Probably premature optimization…
	//	if ([[NSSet setWithArray:[self allKeys]] isEqualToSet:[NSSet setWithArray:keys]]) {
	//		return self ;
	//	}

	NSMutableDictionary* mutant = [[NSMutableDictionary alloc] init] ;
	for (id key in keys) {
		[mutant setValue:[self objectForKey:key]
				  forKey:key] ;
	}

	NSDictionary* answer = [[mutant copy] autorelease] ;
	[mutant release] ;

	return answer ;
}

@end


NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent)
{
	NSString *objectString;
	if ([object isKindOfClass:[NSString class]])
	{
		objectString = (NSString *)[[object retain] autorelease];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)])
	{
		objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:)])
	{
		objectString = [(NSSet *)object descriptionWithLocale:locale];
	}
	else
	{
		objectString = [object description];
	}
	return objectString;
}

@implementation OrderedDictionary
{
	NSMutableDictionary *dictionary;
	NSMutableArray *array;
}

- (id)init
{
	return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)capacity
{
	self = [super init];
	if (self != nil)
	{
		dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
		array = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	return self;
}

- (void)dealloc
{
	[dictionary release];
	[array release];
}

- (id)copy
{
	return [self mutableCopy];
}

- (void)setObject:(id)anObject forKey:(id)aKey
{
	if (![dictionary objectForKey:aKey])
	{
		[array addObject:aKey];
	}
	[dictionary setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
	[dictionary removeObjectForKey:aKey];
	[array removeObject:aKey];
}

- (NSUInteger)count
{
	return [dictionary count];
}

- (id)objectForKey:(id)aKey
{
	return [dictionary objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
	return [array objectEnumerator];
}

- (NSEnumerator *)reverseKeyEnumerator
{
	return [array reverseObjectEnumerator];
}

- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex
{
	if ([dictionary objectForKey:aKey])
	{
		[self removeObjectForKey:aKey];
	}
	[array insertObject:aKey atIndex:anIndex];
	[dictionary setObject:anObject forKey:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex
{
	return [array objectAtIndex:anIndex];
}

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
	NSMutableString *indentString = [NSMutableString string];
	NSUInteger i, count = level;
	for (i = 0; i < count; i++)
	{
		[indentString appendFormat:@"    "];
	}

	NSMutableString *description = [NSMutableString string];
	[description appendFormat:@"%@{\n", indentString];
	for (NSObject *key in self)
	{
		[description appendFormat:@"%@    %@ = %@;\n",
		 indentString,
		 DescriptionForObject(key, locale, level),
		 DescriptionForObject([self objectForKey:key], locale, level)];
	}
	[description appendFormat:@"%@}\n", indentString];
	return description;
}

@end
