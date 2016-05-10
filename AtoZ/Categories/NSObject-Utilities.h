/* Erica Sadun, http://ericasadun.com iPhone Developer's Cookbook, 3.0 Edition BSD License, Use at your own risk	*/


@interface NSObject (ImageVsColor)

- (NSC*)colorValue;
- (NSIMG*)imageValue;

@end


@interface NSO (BlockIntrospection)
/** Block introspection!  Uses CTBlockDescription in AtoZAutoBox.
	@param anotherBlock an object (a block) to compare oneself to.
	@return If the signatures are an exact match.

      block1 one	= ^id(void){ id a= @"a"; return a;};
	    block1 oneA = ^id(void){ id b= @"a"; return b;};
	    block2 two	= ^id(id amber) { return amber;   };
	
	    LOG_EXPR([oneA isKindOfBlock:one]); -> YES
			LOG_EXPR([oneA isKindOfBlock:two]); -> NO

*/
@property (readonly) BOOL isaBlock;
@property (readonly) NSS* blockDescription;
@property (readonly) NSMethodSignature * blockSignature;
- _IsIt_ isKindOfBlock: anotherBlock;

@end

@interface NSObject (AtoZBindings)

//- (void) setWindowPosition:	(AZWindowPosition) pos;
//- (AZWindowPosition) windowPosition;

- (void) bind:(NSA*)paths toObject: o withKeyPaths:(NSA*)objKps;
- (void) bindToObject: o withKeyPaths:(NSA*)objKps;
- (void)    b:(NSS*)b tO: o wKP:(NSS*)kp o:(NSD*)opt;
- (void)    b:(NSS*)b tO: o wKP:(NSS*)kp t:(Obj_ObjBlk)b;
- (void)    b:(NSS*)b tO: o wKP:(NSS*)kp s:(SEL)select;

/*! @discussion let's try and make these binding types assignable with a single method. 
    @param b First kepypath, aka the "binding"
    @param kp What shall we bind to, eh?
    @param wild a selector, or a transform, or  a default... depending on...
    @param bType The binding type, an enum.
    @code [self b:@"lineWidth" to:@"dynamicStroke" using:@1 type:BindTypeIfNil];
*/
- (void)    b:(NSS*)b to:(NSS*)kp using: wild type:(BindType)bType;

- (void)    b:(NSS*)b       tO: o                      wKP:(NSS*)kp         n: nilV;

- (void)    b:(NSS*)b tO: o;
- (void)    bindKeys:(NSA*)b tO: o;
- (void) bindFrameToBoundsOf: obj;
- (void)    b:(NSS*)b toKP:(NSS*)selfkp;
/*
-(void)mouseDown:(NSEvent*)theEvent;	{
    NSColor* newColor = //mouse down changes the color somehow (view-driven change)
    self.color = newColor;
    [self propagateValue:newColor forBinding:@"color"];	} */
	 
-(void) propagateValue: value forBinding:(NSString*)binding;

// Calls -[NSObject bind:binding toObject:object withKeyPath:keyPath options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSContinuouslyUpdatesValueBindingOption, nil]]
- _Void_ bind:(NSS*)b toObject: x withKeyPathUsingDefaults:(NSS*)kp;

// Calls -[NSO bind:b toObject:o withKeyPath:kp options:@{ NSContinuouslyUpdatesValueBindingOption: @(YES), NSNullPlaceholderBindingOption: nilValue}];
- _Void_ bind:(NSS*)b toObject: x withKeyPath:(NSString *)kp nilValue: nilValue;

// Same as `-[NSObject bind:toObject:withKeyPath:] but also transforms values using the given transform block.
- _Void_ bind:(NSS*)b toObject: x withKeyPath:(NSS*)kp transform:(Obj_ObjBlk)transformBlock;

// Same as `-[NSObject bind:toObject:withKeyPath:] but the value is transformed by negating it.
- _Void_ bind:(NSS*)b toObject: x withNegatedKeyPath:(NSS*)kp;

- _Void_ bind:(NSS*)b toObject: x withKeyPath:(NSS*)kp selector:(SEL)select;

@end

@interface NSInvocation (jr_block)

/*! Usage example:		https://github.com/rentzsch/NSInvocation-blocks/blob/master/NSInvocation%2Bblocks.h
    
  NSInvocation *invocation = [NSInvocation jr_invocationWithTarget:myObject 
                                                             block:^(id myObject){
        [myObject someMethodWithArg:42.0];	
  }];   
*/

+   invocationWithTarget:t  block ＾ObjC_ b;
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

- (NSS*) xmlRepresentation;
- _IsIt_ saveAs:(NSS*)file;


// Selector Utilities
//- (INV*) invocationWithSelectorAndArguments:(SEL)s,...;
//- _IsIt_ performSelector:(SEL)s withReturnValueAndArguments: (void *) result, ...;
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

_RO NSD * protocols,
                      * selectors,
                      * properties,
                      * ivars;

/// Check for properties, ivar. Use respondsToSelector: and conformsToProtocol: as well

- _IsIt_ hasProperty:(NSS*)pName;
- _IsIt_     hasIvar:(NSS*)iName;
+ (BOOL) classExists:(NSS*)cName;
//+   (id) instanceOfClassNamed:(NSS*)className;

// Attempt selector if possible
- tryPerformSelector:(SEL)s withObject:o1 withObject:o2;
- tryPerformSelector:(SEL)s withObject:o1;
- tryPerformSelector:(SEL)s;

/// Choose the first selector that the object responds to
- (SEL) chooseSelector:(SEL)s, ...;

- _Void_ runUntil:(BOOL*)stop;

@end

#define overrideSEL(X) az_overrideSelector:@selector(X)
#define    superSEL(X) az_superForSelector:@selector(X)

@interface NSProxy (AZOverride)
-  (BOOL) az_overrideSelector:(SEL)s withBlock:(void *)block;
- (void*) az_superForSelector:(SEL)s;
+  (void) swizzleInstanceSelector:(SEL)oldS withNewSelector:(SEL)newS;
@end

@interface NSObject (AZOverride)

_NA NSS * description;

- _IsIt_ az_overrideBoolMethod:(SEL)selector returning:(BOOL)newB;

//- _IsIt_ conformToProtocol: nameOrProtocol;
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
