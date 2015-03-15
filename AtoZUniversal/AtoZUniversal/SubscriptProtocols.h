
#define _Copy id<NSCopying>
#define _Copy_ (_Copy)
#define forKSub         forKeyedSubscript
#define atIdxSub       atIndexedSubscript
#define xAtIndex objectAtIndexedSubscript
#define xForKSub  objectForKeyedSubscript
#define setXForKSub _Void_ setX:_ forKSub
#define setXAtIndex _Void_ setX:_ atIdxSub


/*! Advertise your subsctriptability with these simple protocols!

 KeyGet + KeySet:  Override, otherwise goes to default NSObject @c valueForKey: / @c setValue:forKey:
 ClassIndexGet:    Declare + implement for indexed access to Class. Example.. your Class Singleton is an Array!
 */

_PRTO KeyGet        <NObj> -    xForKSub: _Copy_ k; @end
_PRTO KeySet        <NObj> - setXForKSub: _Copy_ k; @end
_PRTO IndexSet      <NObj> - setXAtIndex: _UInt_ i; @end
_PRTO IndexGet      <NObj> -    xAtIndex: _UInt_ i; @end

// defaults to returning the method invoked by the subscript string.
_PRTO ClassKeyGet   <NObj> +    xForKSub: _Copy_ k; @end
_PRTO ClassKeySet   <NObj> + setXForKSub: _Copy_ k; @end
_PRTO ClassIndexSet <NObj> + setXAtIndex: _UInt_ i; @end
_PRTO ClassIndexGet <NObj> +    xAtIndex: _UInt_ i; @end

_PRTO KeySub              <KeyGet,               KeySet> @end
_PRTO IndexSub            <IndexGet,           IndexSet> @end
_PRTO Subscriptable       <IndexSub,             KeySub> @end

_PRTO ClassKeySub         <ClassKeyGet,     ClassKeySet> @end
_PRTO ClassIndexSub       <ClassIndexGet, ClassIndexSet> @end
_PRTO ClassSubscriptable  <ClassIndexSub,   ClassKeySub> @end


/*!  Access to class methods via Keyed Subscript! Even with keypaths!  Just cast the class to id first!

 ((id)NSColor.class)[@"greenColor"]                -> NSCalibratedRGBColorSpace 0 1 0 1
 ((id)NSColor.class)[@"greenColor.greenComponent"] -> 1
 ((id)NSClassFromString(@"NSWindow"))[@"new"]      -> <NSWindow: 0x7fa1e8e061b0>

 */
@interface NSObject (Subscriptions) <KeySub,IndexSub,ClassKeyGet> @end


