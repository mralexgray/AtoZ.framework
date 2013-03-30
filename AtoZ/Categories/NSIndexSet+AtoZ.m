
#import "NSIndexSet+AtoZ.h"



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


@interface NoodleIndexSetEnumerator ()

+ enumeratorWithIndexSet:(NSIndexSet *)set;
- initWithIndexSet:(NSIndexSet *)set;

@end

@implementation NoodleIndexSetEnumerator

+ enumeratorWithIndexSet:(NSIndexSet *)set
{
	return [[self.class.alloc initWithIndexSet:set] autorelease];
}

- initWithIndexSet:(NSIndexSet *)set
{
	if ((self = [super init]) != nil)
	{
		_currentIndex = 0;
		_count = [set count];
		_indexes = (NSUInteger *)malloc(sizeof(NSUInteger) * _count);

		[set getIndexes:_indexes maxCount:_count inIndexRange:nil];
	}
	return self;
}

- (void)dealloc
{
	free(_indexes);
	_indexes = NULL;
}

- (void)finalize
{
	free(_indexes);
	[super finalize];
}

- (NSUInteger)nextIndex
{
	if (_currentIndex < _count)
	{
		NSUInteger		i;
		i = _indexes[_currentIndex];
		_currentIndex++;
		return i;
	}
	return NSNotFound;
}
@end

@implementation NSIndexSet (NoodleExtensions)

- (NoodleIndexSetEnumerator *)indexEnumerator
{
	return [NoodleIndexSetEnumerator enumeratorWithIndexSet:self];
}

@end

