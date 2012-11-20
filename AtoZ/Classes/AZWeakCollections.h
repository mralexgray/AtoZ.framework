//
//  AZWeakCollections.h
//  AtoZ
//
//  Created by Alex Gray on 11/20/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeakMutableArray : NSMutableArray
@end

@interface WeakReferenceObject : NSObject

@property (weak, nonatomic, readonly) id baseObject;

- (id)initWithObject:(id)anObject;
+ (WeakReferenceObject *)weakReferenceObjectWithObject:(id)anObject;

@end

//For the WeakMutableSet to be complete we need a new WeakSetEnumerator that skips objects that are no more valid:

@interface WeakSetEnumerator : NSEnumerator


- (id)initWithSet:(NSSet *)set;

@end

@interface WeakMutableSet : NSMutableSet
-(id) firstObject;
@end
