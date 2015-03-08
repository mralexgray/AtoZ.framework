

/*! Advertise your subsctriptability with these simple protocols!

 KeyGet + KeySet:  Override, otherwise goes to default NSObject @c valueForKey: / @c setValue:forKey:
 ClassIndexGet:    Declare + implement for indexed access to Class. Example.. your Class Singleton is an Array!
 */
#define CopyObject id<NSCopying>
@protocol KeyGet        <NSObject> @optional -               objectForKeyedSubscript:(CopyObject)k;                @end
@protocol KeySet        <NSObject> @optional - (void) setObject:_  forKeyedSubscript:(CopyObject)k; @end
@protocol IndexSet      <NSObject> @required - (void) setObject:_ atIndexedSubscript:(NSUInteger)i;    @end
@protocol IndexGet      <NSObject> @required -              objectAtIndexedSubscript:(NSUInteger)i;    @end

// defaults to returning the method invoked by the subscript string.
@protocol ClassKeyGet   <NSObject> @optional +               objectForKeyedSubscript:(CopyObject)k;                @end
@protocol ClassKeySet   <NSObject> @optional + (void) setObject:_  forKeyedSubscript:(CopyObject)k; @end
@protocol ClassIndexSet <NSObject> @required + (void) setObject:_ atIndexedSubscript:(NSUInteger)i;    @end
@protocol ClassIndexGet <NSObject> @required +              objectAtIndexedSubscript:(NSUInteger)i;   @end

@protocol KeySub              <KeyGet,               KeySet> @end
@protocol IndexSub            <IndexGet,           IndexSet> @end
@protocol Subscriptable       <IndexSub,             KeySub> @end

@protocol ClassKeySub         <ClassKeyGet,     ClassKeySet> @end
@protocol ClassIndexSub       <ClassIndexGet, ClassIndexSet> @end
@protocol ClassSubscriptable  <ClassIndexSub,   ClassKeySub> @end


/*!  Access to class methods via Keyed Subscript! Even with keypaths!  Just cast the class to id first!

 ((id)NSColor.class)[@"greenColor"]                -> NSCalibratedRGBColorSpace 0 1 0 1
 ((id)NSColor.class)[@"greenColor.greenComponent"] -> 1
 ((id)NSClassFromString(@"NSWindow"))[@"new"]      -> <NSWindow: 0x7fa1e8e061b0>

 */
@interface NSObject (Subscriptions) <KeySub,IndexSub,ClassKeyGet> @end

