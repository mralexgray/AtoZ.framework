

#import <AtoZUniversal/Rectlike.h>

@Plan TypedArray <NObj>
@concrete _P Class objectClass;
@Stop

@Plan Random  <NObj>
@required + _Kind_ random;              // implement random and you get random:ct for free!
@concrete + _List_ random:_UInt_ ct;     // ie. +[NSColor random:10] -> 10 randos..
@Stop

@Plan Indexed <NSO>
@concrete _RO P(NSFastEnumeration) backingStore;
          _RO  NSUI index, indexMax;
@Stop

@Plan FakeArray <NSO,NSFastEnumeration>
@required @prop_RO id<NSFastEnumeration>enumerator;
          - (int) indexOfObject:(id)x;
@concrete - (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state
                                            objects:(id __unsafe_unretained [])buffer
                                              count:(NSUInteger)len;

- _Void_ eachWithIndex:(ObjIntBlk)block; // Dep's on indexOffObject:
- _Void_ do:(ObjBlk)block;               // Dep's on <NSFastEnumeration>

@Stop

@Plan ArrayLike <NSO,NSFastEnumeration>
@concrete @prop__  NSA<Indexed>*storage;
          @prop_RO NSUI count;

- _Void_     addObject:x;
- _Void_  removeObject:x;
- _Void_    addObjects:_List_ x;
- _Void_ removeObjects:_List_ x;

@Stop

