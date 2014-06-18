/* Erica Sadun, http://ericasadun.com iPhone Developer's Cookbook, 3.0 Edition BSD License, Use at your own risk	*/

#import "AtoZUmbrella.h"
#import "AtoZTypes.h"

@interface NSInvocation (jr_block)

/*! Usage example:		https://github.com/rentzsch/NSInvocation-blocks/blob/master/NSInvocation%2Bblocks.h
    
  NSInvocation *invocation = [NSInvocation jr_invocationWithTarget:myObject 
                                                             block:^(id myObject){
        [myObject someMethodWithArg:42.0];	
  }];   
*/

+   (id)     invocationWithTarget:(id)t  block:(IDBlk)b;
// http://www.numbergrinder.com/2008/12/callable-objects-in-cocoa-nsinvocation/
+ (INV*) createInvocationOnTarget:(id)t selector:(SEL)s;
+ (INV*) createInvocationOnTarget:(id)t selector:(SEL)s
                                   withArguments:(id)a1, ...;
@end
@interface NSInvocation(OCMAdditions)

- (NSS*)              invocationDescription;
-   (id)         getArgumentAtIndexAsObject:(int)argIndex;
- (NSS*)         argumentDescriptionAtIndex:(int)argIndex;
- (NSS*)           objectDescriptionAtIndex:(int)anInt;
- (NSS*)             charDescriptionAtIndex:(int)anInt;
- (NSS*)     unsignedCharDescriptionAtIndex:(int)anInt;
- (NSS*)              intDescriptionAtIndex:(int)anInt;
- (NSS*)      unsignedIntDescriptionAtIndex:(int)anInt;
- (NSS*)            shortDescriptionAtIndex:(int)anInt;
- (NSS*)    unsignedShortDescriptionAtIndex:(int)anInt;
- (NSS*)             longDescriptionAtIndex:(int)anInt;
- (NSS*)     unsignedLongDescriptionAtIndex:(int)anInt;
- (NSS*)         longLongDescriptionAtIndex:(int)anInt;
- (NSS*) unsignedLongLongDescriptionAtIndex:(int)anInt;
- (NSS*)           doubleDescriptionAtIndex:(int)anInt;
- (NSS*)            floatDescriptionAtIndex:(int)anInt;
- (NSS*)           structDescriptionAtIndex:(int)anInt;
- (NSS*)          pointerDescriptionAtIndex:(int)anInt;
- (NSS*)          cStringDescriptionAtIndex:(int)anInt;
- (NSS*)         selectorDescriptionAtIndex:(int)anInt;
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
//- (INV*) invocationWithSelectorAndArguments:(SEL)s,...;
//- (BOOL) performSelector:(SEL)s withReturnValueAndArguments: (void *) result, ...;
- (const char *) returnTypeForSelector:(SEL)s;

// Request return value from performing selector
- (id) objectByPerformingSelectorWithArguments:(SEL)s, ...;
- (id) objectByPerformingSelector:(SEL)s withObject:(id)x1 withObject:(id)x2;
- (id) objectByPerformingSelector:(SEL)s withObject:(id)x1;
- (id) objectByPerformingSelector:(SEL)s;

// Delay Utilities
- (void) performSelector:(SEL)s withCPointer:(void*)cPtr   afterDelay:(NSTimeInterval)d;
- (void) performSelector:(SEL)s      withInt:(int)intV     afterDelay:(NSTimeInterval)d;
//- (void) performSelector:(SEL)s    withFloat:(float)floatV afterDelay:(NSTimeInterval)d;
- (void) performSelector:(SEL)s     withBool:(BOOL)boolV   afterDelay:(NSTimeInterval)d;
- (void) performSelector:(SEL)s                            afterDelay:(NSTimeInterval)d;
- (void) performSelector:(SEL)s                 withDelayAndArguments:(NSTimeInterval)d,...;

// Return Values, allowing non-object returns
- (id) valueByPerformingSelector:(SEL)s withObject:(id)x1 withObject:(id)x2;
- (id) valueByPerformingSelector:(SEL)s withObject:(id)x1;
- (id) valueByPerformingSelector:(SEL)s;

// Access to object essentials for run-time checks. Stored by class in dictionary.
@property (RONLY) NSD *selectors, *properties, *ivars, *protocols;

// Check for properties, ivar. Use respondsToSelector: and conformsToProtocol: as well
- (BOOL)          hasProperty:(NSS*)propertyName;
- (BOOL)              hasIvar:(NSS*)ivarName;
+ (BOOL)          classExists:(NSS*)className;
//+   (id) instanceOfClassNamed:(NSS*)className;

// Attempt selector if possible
- (id) tryPerformSelector:(SEL)s withObject: (id) object1 withObject: (id) object2;
- (id) tryPerformSelector:(SEL)s withObject: (id) object1;
- (id) tryPerformSelector:(SEL)s;

// Choose the first selector that the object responds to
- (SEL) chooseSelector:(SEL)s, ...;
@end

#define overrideSEL(X) az_overrideSelector:@selector(X)
#define    superSEL(X) az_superForSelector:@selector(X)

@interface NSProxy (AZOverride)
-  (BOOL) az_overrideSelector:(SEL)s withBlock:(void *)block;
- (void*) az_superForSelector:(SEL)s;
+  (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS;
@end

@interface NSObject (AZOverride)
- (void) setDescription:(NSS*)x;

-  (BOOL) az_overrideBoolMethod:(SEL)selector returning:(BOOL)newB;

//- (BOOL) conformToProtocol:(id)nameOrProtocol;
/*! Dynamically overrides the specified method on this particular instance.
  @param selector the @selector to override   
  @param block The block's parameters and return type must match those of the method you are overriding. 
  @note the first parameter is always "id _self", which points to the object itself.
  @warning You do have to cast the block's type to (__bridge void *), e.g.:

  @code [self overrideSEL(viewDidAppear:)
					      withBlock:(__bridge void*)^(id _self, BOOL animated) { ... }];
*/
- (BOOL)az_overrideSelector:(SEL)s withBlock:(void *)block;

/*! To call super from the overridden method, do the following: 
  @return a function pointer to the super method (and then you call it.)  

@code void (*superIMP)(id, SEL, BOOL) = [_self superSEL(viewDidAppear:)];
           superIMP(_self, sel, animated);
*/
- (void *)az_superForSelector:(SEL)s;
+ (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS;
@end
