//
//  Protocols.m
//  AtoZUniversal
//
//  Created by Alex Gray on 3/5/15.
//  Copyright (c) 2015 Alex Gray. All rights reserved.
//

#import <AtoZUniversal/AtoZUniversal.h>

@concreteprotocol(TypedArray)
- (Class)objectClass { return objc_getAssociatedObject(self, _cmd); }
- _Void_ setObjectClass:(Class)objectClass { objc_setAssociatedObject(self, _cmd, objectClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC); }
@end

@concreteprotocol(Random)
+ (INST) random { return [NSException raise:@"YOU need to implement this yo damned self!" format:@"%@",nil], (id)nil; }
+ (NSA*) random:(NSUInteger)ct { return [@(ct) mapTimes:^id(NSNumber *num) { return [self random]; }]; }
@end

@implementation NSObject (Indexed)  // @dynamic backingStore;

-   (id) backingStore { return FETCH; }
- (NSUI) index        { NSAssert (self.backingStore && [self.backingStore count], @""); return [(NSA*)self.backingStore indexOfObject:self]; }
- (NSUI) indexMax     { NSAssert (self.backingStore && [self.backingStore count], @""); return [self.backingStore count] -1; }//NSUI max = NSNotFound; id x; return !(x = [self backingStore]) ? max : (!(max = [x count])) ?: max - 1; }

@end

@concreteprotocol(FakeArray)

- _UInt_ countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id __unsafe_unretained [])buffer count:_UInt_ len {

  return [self.enumerator countByEnumeratingWithState:state objects:buffer count:len];
}

- (P(NSFastEnumeration))enumerator { DEMAND_CONFORMANCE; return (id)nil; }

- _UInt_ indexOfObject:_ { DEMAND_CONFORMANCE; return NSNotFound; }

/// @note @required - (int) idexOfObject:(id)x;

- _Void_ eachWithIndex:(ObjIntBlk)block {

    for (_ObjC x in self) { _UInt idx;  if ((idx = [self indexOfObject:x]) != NSNotFound) block(x,idx); }
}
- _Void_ do:(void(^)(id obj))block { for (id z in self) block(z); }

@end


@concreteprotocol(Indexed)
SetKPfVA(IndexMax, @"index")
SetKPfVA(Index,@"backingStore")
@end

@concreteprotocol(ArrayLike)

- (NSUI) countByEnumeratingWithState:(NSFastEnumerationState*)s objects:(id __unsafe_unretained [])b count:(NSUInteger)l {
  return [self.storage countByEnumeratingWithState:s objects:b count:l];
}

- (NSMA<Indexed>*) storage { return objc_getAssociatedObject(self, _cmd) ?: ({ id x = NSMA.new; objc_setAssociatedObject(self, _cmd, x, OBJC_ASSOCIATION_RETAIN_NONATOMIC); x; }); }

- _Void_ addObject:       (NSO*)x { __block id storage = self.storage;

  [[x backingStore] isEqual:storage] ?: [x triggerKVO:@"backingStore" block:^(id _self) { ASSIGN_WEAK(_self,backingStore,storage); }];
  [self insertObject:x inStorageAtIndex:[storage count]];

}
- (NSUI) count { return self.storage.count; }
- _Void_ removeObject:    (id)x { [self removeObjectFromStorageAtIndex:[self.storage indexOfObject:x]]; }
- _Void_ addObjects:    (NSA*)x { for (id z in x) [self    addObject:z];                                }
- _Void_ removeObjects: (NSA*)x { for (id z in x) [self removeObject:z];                                }

- (NSUI)                 countOfStorage         { return self.storage.count;                  }
-   (id)         objectInStorageAtIndex:(NSUI)x { return self.storage[x];                     }
- _Void_ removeObjectFromStorageAtIndex:(NSUI)x { [(NSMA*)[self storage] removeObjectAtIndex:x];       }
- _Void_                   insertObject:(id)obj
                       inStorageAtIndex:(NSUI)x { [(NSMA*)[self storage] insertObject:obj atIndex:x];  }
- _Void_  replaceObjectInStorageAtIndex:(NSUI)x
                             withObject:(id)obj { [(NSMA*)[self storage] replaceObjectAtIndex:x withObject:obj];                      }

//int ssss() {  [@{@"ss" :@2} recursiveValueForKey:<#(NSString *)#>
@end

