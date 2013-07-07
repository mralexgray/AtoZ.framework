/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk	*/

#import <Foundation/Foundation.h>


@interface NSInvocation (jr_block)

/* Usage example:		https://github.com/rentzsch/NSInvocation-blocks/blob/master/NSInvocation%2Bblocks.h
    NSInvocation *invocation = [NSInvocation jr_invocationWithTarget:myObject block:^(id myObject){
        [myObject someMethodWithArg:42.0];	}];
*/
+ (id)invocationWithTarget:(id)target block:(void (^)(id target))block;
// http://www.numbergrinder.com/2008/12/callable-objects-in-cocoa-nsinvocation/
+ (NSInvocation *)createInvocationOnTarget:(id)target selector:(SEL)selector;
+ (NSInvocation *)createInvocationOnTarget:(id)target selector:(SEL)selector withArguments:(id)arg1, ...;
@end


@interface NSInvocation(OCMAdditions)

- (id)getArgumentAtIndexAsObject:(int)argIndex;

- (NSString *)invocationDescription;

- (NSString *)argumentDescriptionAtIndex:(int)argIndex;

- (NSString *)objectDescriptionAtIndex:(int)anInt;
- (NSString *)charDescriptionAtIndex:(int)anInt;
- (NSString *)unsignedCharDescriptionAtIndex:(int)anInt;
- (NSString *)intDescriptionAtIndex:(int)anInt;
- (NSString *)unsignedIntDescriptionAtIndex:(int)anInt;
- (NSString *)shortDescriptionAtIndex:(int)anInt;
- (NSString *)unsignedShortDescriptionAtIndex:(int)anInt;
- (NSString *)longDescriptionAtIndex:(int)anInt;
- (NSString *)unsignedLongDescriptionAtIndex:(int)anInt;
- (NSString *)longLongDescriptionAtIndex:(int)anInt;
- (NSString *)unsignedLongLongDescriptionAtIndex:(int)anInt;
- (NSString *)doubleDescriptionAtIndex:(int)anInt;
- (NSString *)floatDescriptionAtIndex:(int)anInt;
- (NSString *)structDescriptionAtIndex:(int)anInt;
- (NSString *)pointerDescriptionAtIndex:(int)anInt;
- (NSString *)cStringDescriptionAtIndex:(int)anInt;
- (NSString *)selectorDescriptionAtIndex:(int)anInt;

@end


 // thanks Landon Fuller
#define VERIFIED_CLASS(className) ((className *) NSClassFromString(@"" # className))

@interface NSObject (Utilities)

// Return all superclasses of object
- (NSA*) superclasses;

// Selector Utilities
- (NSInvocation *) invocationWithSelectorAndArguments: (SEL) selector,...;
- (BOOL) performSelector: (SEL) selector withReturnValueAndArguments: (void *) result, ...;
- (const char *) returnTypeForSelector:(SEL)selector;

// Request return value from performing selector
- (id) objectByPerformingSelectorWithArguments: (SEL) selector, ...;
- (id) objectByPerformingSelector:(SEL)selector withObject:(id) object1 withObject: (id) object2;
- (id) objectByPerformingSelector:(SEL)selector withObject:(id) object1;
- (id) objectByPerformingSelector:(SEL)selector;

// Delay Utilities
- (void) performSelector: (SEL) selector withCPointer: (void *) cPointer afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector withInt: (int) intValue afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector withFloat: (float) floatValue afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector withBool: (BOOL) boolValue afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector afterDelay: (NSTimeInterval) delay;
- (void) performSelector: (SEL) selector withDelayAndArguments: (NSTimeInterval) delay,...;

// Return Values, allowing non-object returns
- (id) valueByPerformingSelector:(SEL)selector withObject:(id) object1 withObject: (id) object2;
- (id) valueByPerformingSelector:(SEL)selector withObject:(id) object1;
- (id) valueByPerformingSelector:(SEL)selector;

// Access to object essentials for run-time checks. Stored by class in dictionary.
@property (RONLY) NSDictionary *selectors;
@property (RONLY) NSDictionary *properties;
@property (RONLY) NSDictionary *ivars;
@property (RONLY) NSDictionary *protocols;

// Check for properties, ivar. Use respondsToSelector: and conformsToProtocol: as well
- (BOOL) hasProperty: (NSS*) propertyName;
- (BOOL) hasIvar: (NSS*) ivarName;
+ (BOOL) classExists: (NSS*) className;
+ (id) instanceOfClassNamed: (NSS*) className;

// Attempt selector if possible
- (id) tryPerformSelector: (SEL) aSelector withObject: (id) object1 withObject: (id) object2;
- (id) tryPerformSelector: (SEL) aSelector withObject: (id) object1;
- (id) tryPerformSelector: (SEL) aSelector;

// Choose the first selector that the object responds to
- (SEL) chooseSelector: (SEL) aSelector, ...;
@end


#define overrideSEL az_overrideSelector
@interface NSProxy (AZOverride)
- (BOOL)az_overrideSelector:(SEL)selector withBlock:(void *)block;
- (void *)az_superForSelector:(SEL)selector;
+ (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS;
@end

@interface NSObject (AZOverride)
 /*
 * Dynamically overrides the specified method on this particular instance.
 
 * The block's parameters and return type must match those of the method you
 * are overriding. However, the first parameter is always "id _self", which
 * points to the object itself.
 
 * You do have to cast the block's type to (__bridge void *), e.g.:
 *
 *	 [self mh_overrideSelector:@selector(viewDidAppear:)
 *					 withBlock:(__bridge void *)^(id _self, BOOL animated) { ... }];
 */
- (BOOL)az_overrideSelector:(SEL)selector withBlock:(void *)block;

 /*
 * To call super from the overridden method, do the following:
 * 
 *	 SEL sel = @selector(viewDidAppear:);
 *	 void (*superIMP)(id, SEL, BOOL) = [_self mh_superForSelector:sel];
 *	 superIMP(_self, sel, animated);
 *
 * This first gets a function pointer to the super method and then you call it.
 */
- (void *)az_superForSelector:(SEL)selector;


+ (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS;

@end
