


#import <AtoZUniversal/Rectlike.h>

@Vows TypedArray <NObj> @concrete _P Class objectClass;
@Stop

@Vows Random   <NObj>

             + _Kind_ random;              // implement random and you get random:ct for free!
@concrete    + _List_ random:_UInt_ ct;     // ie. +[NSColor random:10] -> 10 randos..
@Stop

_Type struct  { _SInt rangeMin; _SInt rangeMax; _SInt currentIndex; } _Indx;

@Vows Indexed   <NSO>

@concrete  _RO P(NSFastEnumeration) backingStore;
//           _RO                NSUI  indexMax,
//                                    index;
￭

@Vows FakeArray <NSO,NSFastEnumeration>

@Reqd _RO P(NSFastEnumeration) enumerator;

  - _UInt_ indexOfObject:__ _

@concrete - _UInt_ countByEnumeratingWithState:(NSFastEnumerationState*)state
                                       objects:(_ObjC __unsafe_unretained [])buffer
                                          count:_UInt_ len;

- _Void_ eachWithIndex:_ObjIntBlk_ b;     // Dep's on indexOffObject:
- _Void_            do:_ObjBlk_ b;        // Dep's on <NSFastEnumeration>
￭

@Vows ArrayLike <NSO,NSFastEnumeration>

@concrete _P   List <Indexed> *storage;
          _RO _UInt count;

- _Void_     addObject:__ _
- _Void_  removeObject:__ _
- _Void_    addObjects:_List_ __ _
- _Void_ removeObjects:_List_ __ _

@Stop

DECLARECONFORMANCE(List, FakeArray)

@Vows PrimitiveAccess <NObj>

- _Void_       setBool:_IsIt_ b forKey:_Text_ k;
- _IsIt_    boolForKey:_Text_ k;
- _Void_    setInteger:_SInt_ i forKey:_Text_ k;
- _SInt_ integerForKey:_Text_ k;
- _Void_     setDouble:_Flot_ f forKey:_Text_ k;
- _Flot_   floatForKey:_Text_ k;
- _Void_     setString:_Text_ s forKey:_Text_ k;
- _Text_  stringForKey:_Text_ k;
- _Void_       setData:_Data_ d forKey:_Text_ k;
- _Data_    dataForKey:_Text_ k;

- _Void_          setObject:(P(NSCoding))v forKey:_Text_ k;
- (P(NSCoding))objectForKey:_Text_ k;
￭
