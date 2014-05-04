/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk	*/

#import "AtoZUmbrella.h"

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

- (NSS*) invocationDescription;

- (NSS*) argumentDescriptionAtIndex:(int)argIndex;

- (NSS*) objectDescriptionAtIndex:(int)anInt;
- (NSS*) charDescriptionAtIndex:(int)anInt;
- (NSS*) unsignedCharDescriptionAtIndex:(int)anInt;
- (NSS*) intDescriptionAtIndex:(int)anInt;
- (NSS*) unsignedIntDescriptionAtIndex:(int)anInt;
- (NSS*) shortDescriptionAtIndex:(int)anInt;
- (NSS*) unsignedShortDescriptionAtIndex:(int)anInt;
- (NSS*) longDescriptionAtIndex:(int)anInt;
- (NSS*) unsignedLongDescriptionAtIndex:(int)anInt;
- (NSS*) longLongDescriptionAtIndex:(int)anInt;
- (NSS*) unsignedLongLongDescriptionAtIndex:(int)anInt;
- (NSS*) doubleDescriptionAtIndex:(int)anInt;
- (NSS*) floatDescriptionAtIndex:(int)anInt;
- (NSS*) structDescriptionAtIndex:(int)anInt;
- (NSS*) pointerDescriptionAtIndex:(int)anInt;
- (NSS*) cStringDescriptionAtIndex:(int)anInt;
- (NSS*) selectorDescriptionAtIndex:(int)anInt;

@end

@interface AZInvocationGrabber : NSProxy { id _target; NSInvocation *_invocation;	}
@property				  NSInvocation * invocation;
@property                   id   target;
@end

#define VERIFIED_CLASS(className) ((className *) NSClassFromString(@"" # className))  // thanks Landon Fuller

@interface NSObject (Utilities)

// Return all superclasses of object
- (NSA*) superclasses;
- (NSA*) superclassesAsStrings;

// Selector Utilities
- (INV*) invocationWithSelectorAndArguments: (SEL) selector,...;
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
@property (RONLY) NSD *selectors, *properties, *ivars, *protocols;

// Check for properties, ivar. Use respondsToSelector: and conformsToProtocol: as well
- (BOOL)          hasProperty:(NSS*)propertyName;
- (BOOL)              hasIvar:(NSS*)ivarName;
+ (BOOL)          classExists:(NSS*)className;
+   (id) instanceOfClassNamed:(NSS*)className;

// Attempt selector if possible
- (id) tryPerformSelector: (SEL) aSelector withObject: (id) object1 withObject: (id) object2;
- (id) tryPerformSelector: (SEL) aSelector withObject: (id) object1;
- (id) tryPerformSelector: (SEL) aSelector;

// Choose the first selector that the object responds to
- (SEL) chooseSelector: (SEL) aSelector, ...;
@end

#define overrideSEL(X) az_overrideSelector:@selector(X)
#define    superSEL(X) az_superForSelector:@selector(X)

@interface NSProxy (AZOverride)
-  (BOOL) az_overrideSelector:(SEL)selector withBlock:(void *)block;
- (void*) az_superForSelector:(SEL)selector;
+  (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS;
@end


@interface NSObject (AZOverride)

- (void) setDescription:(NSS*)x;

//- (BOOL) conformToProtocol:(id)nameOrProtocol;

/*! Dynamically overrides the specified method on this particular instance.
  @param selector the @selector to override   
  @param block The block's parameters and return type must match those of the method you are overriding. 
  @note the first parameter is always "id _self", which points to the object itself.
  @warning You do have to cast the block's type to (__bridge void *), e.g.:

  @code [self overrideSEL(viewDidAppear:)
					      withBlock:(__bridge void*)^(id _self, BOOL animated) { ... }];
*/
- (BOOL)az_overrideSelector:(SEL)selector withBlock:(void *)block;

/*! To call super from the overridden method, do the following: 
  @return a function pointer to the super method (and then you call it.)  

@code void (*superIMP)(id, SEL, BOOL) = [_self superSEL(viewDidAppear:)];
           superIMP(_self, sel, animated);
  
*/
- (void *)az_superForSelector:(SEL)selector;

+ (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS;

@end
