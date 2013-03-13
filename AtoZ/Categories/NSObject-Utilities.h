/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk	*/

#import <Foundation/Foundation.h>

 // thanks Landon Fuller
#define VERIFIED_CLASS(className) ((className *) NSClassFromString(@"" # className))

@interface NSObject (Utilities)

// Return all superclasses of object
- (NSArray *) superclasses;

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
- (BOOL) hasProperty: (NSString *) propertyName;
- (BOOL) hasIvar: (NSString *) ivarName;
+ (BOOL) classExists: (NSString *) className;
+ (id) instanceOfClassNamed: (NSString *) className;

// Attempt selector if possible
- (id) tryPerformSelector: (SEL) aSelector withObject: (id) object1 withObject: (id) object2;
- (id) tryPerformSelector: (SEL) aSelector withObject: (id) object1;
- (id) tryPerformSelector: (SEL) aSelector;

// Choose the first selector that the object responds to
- (SEL) chooseSelector: (SEL) aSelector, ...;
@end

@interface NSObject (NSCoding)

- (void)autoEncodeWithCoder: (NSCoder *)coder;
- (void)autoDecode:(NSCoder *)coder;
- (NSDictionary *)properties;

@end


@interface NSObject (AZOverride)
 /*
 * Dynamically overrides the specified method on this particular instance.
 
 * The block's parameters and return type must match those of the method you
 * are overriding. However, the first parameter is always "id _self", which
 * points to the object itself.
 
 * You do have to cast the block's type to (__bridge void *), e.g.:
 *
 *     [self mh_overrideSelector:@selector(viewDidAppear:)
 *                     withBlock:(__bridge void *)^(id _self, BOOL animated) { ... }];
 */
- (BOOL)az_overrideSelector:(SEL)selector withBlock:(void *)block;

 /*
 * To call super from the overridden method, do the following:
 * 
 *     SEL sel = @selector(viewDidAppear:);
 *     void (*superIMP)(id, SEL, BOOL) = [_self mh_superForSelector:sel];
 *     superIMP(_self, sel, animated);
 *
 * This first gets a function pointer to the super method and then you call it.
 */
- (void *)az_superForSelector:(SEL)selector;
 
@end
