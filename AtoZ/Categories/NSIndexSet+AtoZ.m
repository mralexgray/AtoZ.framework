
#import "NSIndexSet+AtoZ.h"


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

