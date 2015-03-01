
@import Foundation;

#define   NSIFACE(X)        @interface X : NSObject + (instancetype)
#define INTERFACE(X,...)    @interface X : __VA_ARGS__ + (instancetype)
#define    EXTEND(X)        @interface X ()
#define      VOID(X)      - (void) X
#define FACTORY + (instancetype)
#define TYPEDEF_V(X)        typedef void(^X)

#define PROP_READ property (readonly)
#define PROP_COPY property (copy)
#define PROP_NATM property (nonatomic)
#define PROP_WEAK property (weak)
#define PROP_ASSN property (assign)

/*! Advertise your subsctriptability with these simple protocols!

 KeyGet + KeySet:  Override, otherwise goes to default NSObject @c valueForKey: / @c setValue:forKey:
 ClassIndexGet:    Declare + implement for indexed access to Class. Example.. your Class Singleton is an Array!
 */

@protocol KeyGet   <NSObject> @optional -               objectForKeyedSubscript:_;                @end
@protocol KeySet   <NSObject> @optional - (void) setObject:_  forKeyedSubscript:(id<NSCopying>)k; @end
@protocol IndexSet <NSObject> @optional - (void) setObject:_ atIndexedSubscript:(NSUInteger)i;    @end
@protocol IndexGet <NSObject> @optional -              objectAtIndexedSubscript:(NSUInteger)i;    @end

@protocol ClassKeyGet   <NSObject>  +               objectForKeyedSubscript:_;                @end
@protocol ClassKeySet   <NSObject>  + (void) setObject:_  forKeyedSubscript:(id<NSCopying>)k; @end
@protocol ClassIndexSet <NSObject>  + (void) setObject:_ atIndexedSubscript:(NSUInteger)i;    @end
@protocol ClassIndexGet <NSObject>  +              objectAtIndexedSubscript:(NSUInteger)i;   @end

@protocol KeySub              <KeyGet,               KeySet> @end
@protocol IndexSub            <IndexGet,           IndexSet> @end
@protocol ClassIndexSub       <ClassIndexGet, ClassIndexSet> @end
@protocol ClassKeySub         <ClassKeyGet,     ClassKeySet> @end

@protocol Subscriptable       <IndexSub,             KeySub> @end
@protocol ClassSubscriptable  <ClassIndexSub,   ClassKeySub> @end


/*!  Access to class methods via Keyed Subscript! Even with keypaths!  Just cast the class to id first!

 ((id)NSColor.class)[@"greenColor"]                -> NSCalibratedRGBColorSpace 0 1 0 1
 ((id)NSColor.class)[@"greenColor.greenComponent"] -> 1
 ((id)NSClassFromString(@"NSWindow"))[@"new"]      -> <NSWindow: 0x7fa1e8e061b0>

 */
@interface NSObject (Subscriptions) <KeySub,IndexSub,ClassKeyGet> @end
