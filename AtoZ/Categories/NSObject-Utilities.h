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

+   invocationWithTarget:t  block:(IDBlk)b;
// http://www.numbergrinder.com/2008/12/callable-objects-in-cocoa-nsinvocation/
+ (INV*) createInvocationOnTarget:t selector:(SEL)s;
+ (INV*) createInvocationOnTarget:t selector:(SEL)s
                                withArguments:a1, ...;
@end

@interface NSInvocation(OCMAdditions)

- (NSS*)              invocationDescription;

- (NSS*)           objectDescriptionAtIndex:(int)x;
- (NSS*)             charDescriptionAtIndex:(int)x;
- (NSS*)     unsignedCharDescriptionAtIndex:(int)x;
- (NSS*)              intDescriptionAtIndex:(int)x;
- (NSS*)      unsignedIntDescriptionAtIndex:(int)x;
- (NSS*)            shortDescriptionAtIndex:(int)x;
- (NSS*)    unsignedShortDescriptionAtIndex:(int)x;
- (NSS*)             longDescriptionAtIndex:(int)x;
- (NSS*)     unsignedLongDescriptionAtIndex:(int)x;
- (NSS*)         longLongDescriptionAtIndex:(int)x;
- (NSS*) unsignedLongLongDescriptionAtIndex:(int)x;
- (NSS*)           doubleDescriptionAtIndex:(int)x;
- (NSS*)            floatDescriptionAtIndex:(int)x;
- (NSS*)           structDescriptionAtIndex:(int)x;
- (NSS*)          pointerDescriptionAtIndex:(int)x;
- (NSS*)          cStringDescriptionAtIndex:(int)x;
- (NSS*)         selectorDescriptionAtIndex:(int)x;
- (NSS*)         argumentDescriptionAtIndex:(int)x;
-                getArgumentAtIndexAsObject:(int)x;
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
- objectByPerformingSelectorWithArguments:(SEL)s, ...;
- objectByPerformingSelector:(SEL)s withObject:x1 withObject:x2;
- objectByPerformingSelector:(SEL)s withObject:x1;
- objectByPerformingSelector:(SEL)s;

// Delay Utilities
- (void) performSelector:(SEL)s withCPointer:(void*)cPtr   afterDelay:(NSTimeInterval)d;
- (void) performSelector:(SEL)s      withInt:(int)intV     afterDelay:(NSTimeInterval)d;
//- (void) performSelector:(SEL)s    withFloat:(float)floatV afterDelay:(NSTimeInterval)d;
- (void) performSelector:(SEL)s     withBool:(BOOL)boolV   afterDelay:(NSTimeInterval)d;
- (void) performSelector:(SEL)s                            afterDelay:(NSTimeInterval)d;
- (void) performSelector:(SEL)s                 withDelayAndArguments:(NSTimeInterval)d,...;

/// Return Values, allowing non-object returns

- valueByPerformingSelector:(SEL)s withObject:x1 withObject:x2;
- valueByPerformingSelector:(SEL)s withObject:x1;
- valueByPerformingSelector:(SEL)s;

/// Access to object essentials for run-time checks. Stored by class in dictionary.

@prop_RO NSD * protocols,
                      * selectors,
                      * properties,
                      * ivars;

/// Check for properties, ivar. Use respondsToSelector: and conformsToProtocol: as well

- (BOOL) hasProperty:(NSS*)pName;
- (BOOL)     hasIvar:(NSS*)iName;
+ (BOOL) classExists:(NSS*)cName;
//+   (id) instanceOfClassNamed:(NSS*)className;

// Attempt selector if possible
- tryPerformSelector:(SEL)s withObject:o1 withObject:o2;
- tryPerformSelector:(SEL)s withObject:o1;
- tryPerformSelector:(SEL)s;

/// Choose the first selector that the object responds to
- (SEL) chooseSelector:(SEL)s, ...;

- (void)runUntil:(BOOL*)stop;

@end

#define overrideSEL(X) az_overrideSelector:@selector(X)
#define    superSEL(X) az_superForSelector:@selector(X)

@interface NSProxy (AZOverride)
-  (BOOL) az_overrideSelector:(SEL)s withBlock:(void *)block;
- (void*) az_superForSelector:(SEL)s;
+  (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS;
@end

@interface NSObject (AZOverride)


@prop_NA NSS * description;

- (BOOL) az_overrideBoolMethod:(SEL)selector returning:(BOOL)newB;

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
