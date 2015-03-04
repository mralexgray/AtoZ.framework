
#import <AtoZ/AtoZ.h>
#import "NSIndexSet+AtoZ.h"

@implementation NSIndexPath (AtoZ)

#pragma mark - CFIAdditions
 
+ (INST) indexPathForRow:(NSI)row inSection:(NSI)section {
    NSUInteger indexArr[] = {section, row};
    return [NSIndexPath indexPathWithIndexes:indexArr length:2];
}
 
+ (INST) indexPathForItem:(NSInteger)item inSection:(NSInteger)section {
    NSUInteger indexArr[] = {section, item};
    return [NSIndexPath indexPathWithIndexes:indexArr length:2];
}

#pragma mark - JAListViewExtensions

+ (INST) indexPathForIndex:(NSUI)index inSection:(NSUI)section {

	NSUInteger indices[2];	indices[0] = section;	indices[1] = index;

	return [NSIP indexPathWithIndexes:indices length:2];
}

+ (NSIP*)indexPathForSection:(NSUI)section { return [NSIP indexPathWithIndex:section]; }

- (NSI) index   { return [self indexAtPosition:1]; }
- (NSI) section { return [self indexAtPosition:0]; }

#pragma mark - ESExtensions

- (NSUI) firstIndex { return [self indexAtPosition:0];  }
- (NSUI) lastIndex  { return [self indexAtPosition:self.length - 1]; }

- (NSIP*) indexPathByIncrementingLastIndex {

	NSUInteger lastIndex = [self lastIndex];
	NSIndexPath *temp = [self indexPathByRemovingLastIndex];
	return [temp indexPathByAddingIndex:++lastIndex];
}

- (NSIP*) indexPathByReplacingIndexAtPosition:(NSUI)pos withIndex:(NSUI)idx {

	NSUInteger indexes[self.length];  [self getIndexes:indexes]; 	indexes[pos] = idx;

	return [NSIP.alloc initWithIndexes:indexes length:self.length];
}

@end

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



