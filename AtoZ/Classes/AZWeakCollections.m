//
//  AZWeakCollections.m
//  AtoZ
//
//  Created by Alex Gray on 11/20/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
#import <Zangetsu/Zangetsu.h>
#import "AZWeakCollections.h"


@implementation WeakReferenceObject
//{
//	__weak id baseObject;
//}

@synthesize baseObject;

- (id)initWithObject:(id)anObject
{
	if (!(self = [super init])) return nil;
	baseObject = anObject;
	return self;
}

+ (WeakReferenceObject *)weakReferenceObjectWithObject:(id)anObject {
	return [self.alloc initWithObject:anObject];
}

- (NSString *)debugDescription {
	return [NSString stringWithFormat:@"%@ - %@", [super debugDescription], [baseObject debugDescription]];
}

- (NSString *)description {	return [baseObject description];		}

- (id)forwardingTargetForSelector:(SEL)aSelector {	return baseObject;	}

- (NSUInteger)hash {	return [baseObject hash];	}

- (BOOL)isEqual:(id)anObject
{
	BOOL result = [baseObject isEqual:anObject];

	return result ?: [anObject isKindOfClass:[self class]] ? [baseObject isEqual:[(WeakReferenceObject *)anObject baseObject]] : result;
}

@end


@implementation  NSArray (WeakMutableFilter)

-(WeakMutableArray*)weakFilterMap:(id (^)(id obj))block
{
	WeakMutableArray *weakling = WeakMutableArray.new;
	[self cw_each:^(id obj, NSUInteger index, BOOL *stop) {
		id rObj = block(obj);
		if (rObj) {
			WeakReferenceObject *weakO = [WeakReferenceObject weakReferenceObjectWithObject:rObj];
			[weakling addObject:weakO];
		}
	}];
	return weakling;
}
@end
@implementation WeakMutableArray {
	NSMutableArray *array;
}

/*
- initWithObjects:(const id [])objects count:(NSUInteger)cnt {
	self = [super init];
	if (self) {
		array = [NSMutableArray.alloc initWithCapacity:cnt];
		if (objects) {
			for (int i = 0; i < cnt; i++) {
				[array addObject:[WeakReferenceObject weakReferenceObjectWithObject:objects[i]]];
			}
		}
	}
	return self;
}
*/

//- initWithCapacity:(NSUInteger)numItems {
//	return [super initWithObjects:NULL count:numItems];
//}

//- init {
//	return [super initWithObjects:NULL count:0];
//}

- (NSUInteger)count {
	return array.count;
}

- (id)objectAtIndex:(NSUInteger)index {
	return [(WeakReferenceObject *)[array objectAtIndex:index] baseObject];
}

- (void) insertObject:(id)anObject atIndex:(NSUInteger)index {
	[array insertObject:[WeakReferenceObject weakReferenceObjectWithObject:anObject] atIndex:index];
}

- (void) addObject:(id)anObject {
	[array addObject:[WeakReferenceObject weakReferenceObjectWithObject:anObject]];
}

- (void) removeObjectAtIndex:(NSUInteger)index {
	[array removeObjectAtIndex:index];
}

- (void) removeLastObject {
	[array removeLastObject];
}

- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
	[array replaceObjectAtIndex:index withObject:[WeakReferenceObject weakReferenceObjectWithObject:anObject]];
}

@end

@implementation WeakMutableSet {
	NSMutableSet *set;
}

- (id)initWithWeakObjects:(const __autoreleasing id *)objects count:(NSUInteger)cnt {
	if (!(self = [super init] )) return nil;
	set = NSMutableSet.new;// alloc] initWithCapacity:cnt];
	if (objects) {
		for (int i = 0; i < cnt; i++) {
			[set addObject:[WeakReferenceObject weakReferenceObjectWithObject:objects[i]]];
		}
	}
	return self;
}

- (id)initWithCapacity:(NSUInteger)numItems {
	return [super initWithObjects:NULL count:numItems];
}

- (id)init {
	return [self initWithObjects:NULL count:0];
}

- (NSUInteger)count
{
	NSInteger count = 0;
	for (WeakReferenceObject *weakObject in set) {
		if (weakObject.baseObject)			count++;
	}

	return count;
}

-(id) firstObject {

	return [[self objectEnumerator]nextObject];
}
- (id)member:(id)object {
	return [set member:[WeakReferenceObject weakReferenceObjectWithObject:object]];
}

- (NSEnumerator *)objectEnumerator {
	return [WeakSetEnumerator.alloc initWithSet:set];
}

- (void) addObject:(id)object {
	if (object) {
		WeakReferenceObject *weakObject = [WeakReferenceObject weakReferenceObjectWithObject:object];
		[set addObject:weakObject];
	}
}

- (void) removeObject:(id)object {
	WeakReferenceObject *weakObject = [self member:object];
	if (weakObject) {
		[set removeObject:weakObject];
	}
}
@end

@implementation WeakSetEnumerator {
	NSSet *set;
	NSEnumerator *enumerator;
}

- (id)initWithSet:(NSSet *)aSet {
	self = [super init];
	if (self) {
		set = aSet;
		enumerator = [set objectEnumerator];
	}
	return self;
}

- (NSArray *)allObjects {
	WeakMutableArray *allObjects = WeakMutableArray.new;
	NSArray *tempArray = [NSArray arrayWithArray:[enumerator allObjects]];

	for (WeakReferenceObject *weakObject in tempArray) {
		if (weakObject.baseObject) {
			[allObjects addObject:weakObject.baseObject];
		}
	}

	return allObjects;
}

- (id)nextObject {
	WeakReferenceObject *weakObject = [enumerator nextObject];

	if (weakObject && !weakObject.baseObject) {
		return [self nextObject];
	}

	return weakObject.baseObject;
}

@end
