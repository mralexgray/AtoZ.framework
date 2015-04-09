
#define _Copy id<NSCopying>
#define _Copy_ (_Copy)
#define forKSub         forKeyedSubscript
#define atIdxSub       atIndexedSubscript
#define xAtIndex objectAtIndexedSubscript
#define xForKSub  objectForKeyedSubscript
#define setXForKSub _Void_ setX:x forKSub
#define setXAtIndex _Void_ setX:x atIdxSub


/*! Advertise your subsctriptability with these simple protocols!

 KeyGet + KeySet:  Override, otherwise goes to default NSObject @c valueForKey: / @c setValue:forKey:
 ClassIndexGet:    Declare + implement for indexed access to Class. Example.. your Class Singleton is an Array!
 */

@Vows KeyGet        <NObj> -    xForKSub _ _Copy_ k ___ @end
@Vows KeySet        <NObj> - setXForKSub _ _Copy_ k ___ @end
@Vows IndexSet      <NObj> - setXAtIndex _ _UInt_ i ___ @end
@Vows IndexGet      <NObj> -    xAtIndex _ _UInt_ i ___ @end

// defaults to returning the method invoked by the subscript string.
@Vows ClassKeyGet   <NObj> +    xForKSub _ _Copy_ k ___ @end
@Vows ClassKeySet   <NObj> + setXForKSub _ _Copy_ k ___ @end
@Vows ClassIndexSet <NObj> + setXAtIndex _ _UInt_ i ___ @end
@Vows ClassIndexGet <NObj> +    xAtIndex _ _UInt_ i ___ @end

@Vows KeySub              <KeyGet,               KeySet> @end
@Vows IndexSub            <IndexGet,           IndexSet> @end
@Vows Subscriptable       <IndexSub,             KeySub> @end

@Vows ClassKeySub         <ClassKeyGet,     ClassKeySet> @end
@Vows ClassIndexSub       <ClassIndexGet, ClassIndexSet> @end
@Vows ClassSubscriptable  <ClassIndexSub,   ClassKeySub> @end


/*!  Access to class methods via Keyed Subscript! Even with keypaths!  Just cast the class to id first!

 ((id)NSColor.class)[@"greenColor"]                -> NSCalibratedRGBColorSpace 0 1 0 1
 ((id)NSColor.class)[@"greenColor.greenComponent"] -> 1
 ((id)NSClassFromString(@"NSWindow"))[@"new"]      -> <NSWindow: 0x7fa1e8e061b0>

 */
@interface NSObject (Subscriptions) <KeySub,IndexSub,ClassKeyGet> @end


