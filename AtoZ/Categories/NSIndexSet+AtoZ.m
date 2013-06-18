
#import "NSIndexSet+AtoZ.h"




@implementation NSIndexSet (AtoZ)
+ (instancetype) indexWithIndexes:(NSA*)indexes {
	__block NSMutableIndexSet *mutableIndexSet = NSMutableIndexSet.new;
	[indexes each:^(id obj) { [mutableIndexSet addIndex:[obj integerValue]]; }];
	return mutableIndexSet;
}

+ (instancetype) indexesOfObjects:(NSA*)objs inArray:(NSA*)ref {

	__block NSMutableIndexSet *mutableIndexSet = NSMutableIndexSet.new;
	[objs each:^(id obj) { [mutableIndexSet addIndex:[ref indexOfObject:obj]]; }];
	return mutableIndexSet;
}
@end




@implementation NSObject (AtoZKVO)


//+ (NSSet*) keyPathsForValuesAffectingValueForKeys:(NSSet*(^)(NSS*key))block;

+ (NSSet*)keyPathsForValuesAffecting: (NSS*)key fromDictionary:(NSD*)pairs
{ 
	NSSet *keyPaths = [NSObject keyPathsForValuesAffectingValueForKey:key]; 
	return [pairs.allKeys doesNotContainObject:key] ? keyPaths :
				[keyPaths setByAddingObjectsFromSet:
								[NSSet setWithArray:pairs[key]]];
} 

@end



@implementation NSIndexPath (ESExtensions)
- (NSUInteger)firstIndex;
{
	return [self indexAtPosition:0]; 
}

- (NSUInteger)lastIndex;
{
	return [self indexAtPosition:[self length] - 1];
}

- (NSIndexPath *)indexPathByIncrementingLastIndex;
{
	NSUInteger lastIndex = [self lastIndex];
	NSIndexPath *temp = [self indexPathByRemovingLastIndex];
	return [temp indexPathByAddingIndex:++lastIndex];
}

- (NSIndexPath *)indexPathByReplacingIndexAtPosition:(NSUInteger)position withIndex:(NSUInteger)index;
{
	NSUInteger indexes[[self length]];
	[self getIndexes:indexes];
	indexes[position] = index;
	return [[[NSIndexPath alloc] initWithIndexes:indexes length:[self length]] autorelease];
}
@end

