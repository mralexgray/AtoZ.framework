


#import <AtoZUniversal/Rectlike.h>

@Plan TypedArray <NObj> @concrete _P Class objectClass;
@Stop

@Plan Random   <NObj>

             + _Kind_ random;              // implement random and you get random:ct for free!
@concrete    + _List_ random:_UInt_ ct;     // ie. +[NSColor random:10] -> 10 randos..
@Stop

@Plan Indexed   <NSO>

@concrete  _RO P(NSFastEnumeration) backingStore;
           _RO                NSUI  indexMax,
                                    index;

@Stop

@Plan FakeArray <NSO,NSFastEnumeration>

@required _RO id<NSFastEnumeration>enumerator;

                           - _UInt_ indexOfObject:_;

@concrete - _UInt_ countByEnumeratingWithState:(NSFastEnumerationState*)state
                                            objects:(id __unsafe_unretained [])buffer
                                              count:_UInt_ len;

- _Void_ eachWithIndex:(ObjIntBlk)block; // Dep's on indexOffObject:
- _Void_ do:(ObjBlk)block;               // Dep's on <NSFastEnumeration>

@Stop

@Plan ArrayLike <NSO,NSFastEnumeration>

@concrete _P   List <Indexed> *storage;
          _RO _UInt count;

- _Void_     addObject:_;
- _Void_  removeObject:_;
- _Void_    addObjects:_List_ _;
- _Void_ removeObjects:_List_ _;

@Stop

DECLARECONFORMANCE(List, FakeArray)


