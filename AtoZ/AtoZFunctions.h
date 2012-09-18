//
//  AtoZFunctions.h
//  AtoZ
//
//  Created by Alex Gray on 9/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AtoZ.h"
#import <AtoZ/AtoZ.h>


NS_INLINE NSRect SFCopyRect(NSRect toCopy) {	return NSMakeRect(toCopy.origin.x, toCopy.origin.y, toCopy.size.width, toCopy.size.height); }

NS_INLINE NSRect SFMakeRect(NSPoint origin, NSSize size) {	return NSMakeRect(origin.x, origin.y, size.width, size.height); }

NS_INLINE NSPoint SFCopyPoint(NSPoint toCopy) {	return NSMakePoint(toCopy.x, toCopy.y);	}

static inline CGRect convertToCGRect(NSRect rect) {	return *(const CGRect *)&rect;}

static inline NSRect convertToNSRect(CGRect rect) { 	return *(const NSRect *)&rect;	}

static inline NSPoint convertToNSPoint(CGPoint point) {	return *(const NSPoint *)&point;	}

static inline CGPoint convertToCGPoint(NSPoint point) {	return *(const CGPoint *)&point;	}


#define AZLOG(log) NSLog(@"%@", log)
#define AZWORKSPACE [NSWorkspace sharedWorkspace]
#define AZNOTCENTER [NSNotificationCenter defaultCenter]

#define CAMEDIAEASY [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut]

static double frandom(double start, double end);

extern void DrawLabelAtCenterPoint(NSString* string, NSPoint center);

extern void DrawGlossGradient(CGContextRef context, NSColor *color, NSRect inRect);

extern CGFloat perceptualGlossFractionForColor(CGFloat *inputComponents);

static void glossInterpolation(void *info, const CGFloat *input, CGFloat *output);



@interface Slice : NSObject
@property NSInteger start;
@property NSInteger length;
@end

//@interface NSArray (Slicing)
//- (id)objectForKeyedSubscript: (id)subscript;
//@end

@interface NSNumber (SliceCreation)
- (Slice *): (NSInteger)length;
@end


/*
	// make sure non-Clang compilers can still compile
#ifndef __has_feature
#define __has_feature(x) 0
#endif

	// no ARC ? -> declare the ARC attributes we use to be a no-op, so the compiler won't whine
#if ! __has_feature( objc_arc )
#define __autoreleasing
#define __bridge
#endif


#define ARRAY(...) ([NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])
#define SET(...) ([NSSet setWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])

	// this is key/object order, not object/key order, thus all the fuss
#define DICT(...) MADictionaryWithKeysAndObjects(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

#define MAP(collection, ...) EACH_WRAPPER([collection ma_map: ^id (id obj) { return (__VA_ARGS__); }])
#define SELECT(collection, ...) EACH_WRAPPER([collection ma_select: ^BOOL (id obj) { return (__VA_ARGS__) != 0; }])
#define REJECT(collection, ...) EACH_WRAPPER([collection ma_select: ^BOOL (id obj) { return (__VA_ARGS__) == 0; }])
#define MATCH(collection, ...) EACH_WRAPPER([collection ma_match: ^BOOL (id obj) { return (__VA_ARGS__) != 0; }])
#define REDUCE(collection, initial, ...) EACH_WRAPPER([collection ma_reduce: (initial) block: ^id (id a, id b) { return (__VA_ARGS__); }])

#define EACH(array) MAEachHelper(array, &MA_eachTable)
*/

/**  Sometimes it's useful to work on multiple arrays in parallel. For example, imagine that you have two arrays of strings and you want to create a third array that contains the contents of the two arrays combined into a single string. With MACollectionUtilities this is extremely easy:
*/

//	NSArray *first = ARRAY(@"alpha", @"air", @"bicy");
//	NSArray *second = ARRAY(@"bet", @"plane", @"cle");
//	NSArray *words = MAP(first, [obj stringByAppendingString: EACH(second)]);

// 		words now contains alphabet, airplane, bicycle

/*** The EACH macro depends on context set up by the other macros. You can only use it with the macros, not with the methods.
	You can use multiple arrays with multiple EACH macros to enumerate several collections in parallel:
***/

///	NSArray *result = MAP(objects, [obj performSelector: NSSelectorFromString(EACH(selectorNames))
///                                        withObject: EACH(firstArguments)
///										withObject: EACH(secondArguments)];

/*** The EACH macro works by creating and tracking an NSEnumerator internally. It lazily creates the enumerator on the first use, and then uses nextObject at each call. Thus if your arrays are not the same length, it will begin to return nil, watch out.

Because they are unordered, parallel enumeration doesn't make sense for NSSet and EACH is not supported for them.
***/

/*
#define SORTED(collection, ...) [collection ma_sorted: ^BOOL (id a, id b) { return (__VA_ARGS__) != 0; }]

	// ===========================================================================
	// internal utility whatnot that needs to be externally visible for the macros
#define IDARRAY(...) ((__autoreleasing id[]){ __VA_ARGS__ })
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))
#define EACH_WRAPPER(...) (^{ __block CFMutableDictionaryRef MA_eachTable = nil; \
(void)MA_eachTable; \
__typeof__(__VA_ARGS__) MA_retval = __VA_ARGS__; \
if(MA_eachTable) \
CFRelease(MA_eachTable); \
return MA_retval; \
}())

static inline NSDictionary *MADictionaryWithKeysAndObjects(id *keysAndObjs, NSUInteger count)
{
    id keys[count];
    id objs[count];
    for(NSUInteger i = 0; i < count; i++)
    {
        keys[i] = keysAndObjs[i * 2];
        objs[i] = keysAndObjs[i * 2 + 1];
    }

    return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
}

static inline id MAEachHelper(NSArray *array, CFMutableDictionaryRef *eachTablePtr)
{
    if(!*eachTablePtr)
    {
        CFDictionaryKeyCallBacks keycb = {
            0,
            kCFTypeDictionaryKeyCallBacks.retain,
            kCFTypeDictionaryKeyCallBacks.release,
            kCFTypeDictionaryKeyCallBacks.copyDescription,
            NULL,
            NULL
        };
        *eachTablePtr = CFDictionaryCreateMutable(NULL, 0, &keycb, &kCFTypeDictionaryValueCallBacks);
    }

    NSEnumerator *enumerator = (__bridge id)CFDictionaryGetValue(*eachTablePtr, (__bridge CFArrayRef)array);
    if(!enumerator)
    {
        enumerator = [array objectEnumerator];
        CFDictionarySetValue(*eachTablePtr, (__bridge CFArrayRef)array, (__bridge void *)enumerator);
    }
    return [enumerator nextObject];
}

*/