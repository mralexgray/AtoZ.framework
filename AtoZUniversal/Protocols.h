

#import <AtoZUniversal/EXTConcreteProtocol.h>

#define DECLARECONFORMANCE(_CLASS_,_PROTOCOL_) @interface _CLASS_ (_PROTOCOL_) <_PROTOCOL_> @end


@protocol TypedArray <NSO>
@concrete @prop_ Class objectClass;
@end

@protocol Random  <NSO>
@required + (INST) random;              // implement random and you get random:ct for free!
@concrete + (NSA*) random:(NSUI)ct;     // ie. +[NSColor random:10] -> 10 randos..
@end

@protocol Indexed <NSO>
@concrete @prop_RO id<NSFastEnumeration> backingStore;
          @prop_RO  NSUI index, indexMax;
@end

@protocol FakeArray <NSO,NSFastEnumeration>
@required @prop_RO id<NSFastEnumeration>enumerator;
          - (int) indexOfObject:(id)x;
@concrete - (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state
                                            objects:(id __unsafe_unretained [])buffer
                                              count:(NSUInteger)len;

- (void) eachWithIndex:(ObjIntBlk)block; // Dep's on indexOffObject:
- (void) do:(ObjBlk)block;               // Dep's on <NSFastEnumeration>

@end

@protocol ArrayLike <NSO,NSFastEnumeration>
@concrete @prop__  NSA<Indexed>*storage;
          @prop_RO NSUI count;

- (void)     addObject:(id)x;
- (void)  removeObject:(id)x;
- (void)    addObjects:(NSA*)x;
- (void) removeObjects:(NSA*)x;

@end

