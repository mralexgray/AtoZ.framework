//
//  AZWeakCollections.h
//  AtoZ
//
//  Created by Alex Gray on 11/20/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


@interface WeakMutableArray : NSMA
@end

@interface WeakReferenceObject : NSO
@prop_ (weak, nonatomic, readonly) id baseObject;
-                       initWithObject:x;
+ (INST) weakReferenceObjectWithObject:z;
@end

//For the WeakMutableSet to be complete we need a new WeakSetEnumerator that skips objects that are no more valid:

@interface WeakSetEnumerator : NSEnumerator
- initWithSet:(NSSet*)s;
@end

@interface WeakMutableSet : NSMutableSet
@prop_RO id firstObject;
@end

@interface NSArray (WeakMutableFilter)
-(WeakMutableArray*) weakFilterMap:(id (^)(id obj))block;
@end
