

@interface NSIndexPath (AtoZ)

#pragma mark - CFIAdditions

/*! This is a reimplementation of the NSIndexPath UITableView category. */
+ (INST)  indexPathForRow:(NSI)row  inSection:(NSI)x;  // #ifdef TARGET_OS_IPHONE && __IPHONE_OS_VERSION_MIN_REQUIRED <= 60000

+ (INST) indexPathForItem:(NSI)item inSection:(NSI)x;

#pragma mark - JAListViewExtensions

+ (INST) indexPathForIndex:(NSUI)idx inSection:(NSUI)x;
+ (INST) indexPathForSection:(NSUI)section;

_RO NSI index, section, row;

#pragma mark - ESExtensions

_RO NSUI firstIndex, lastIndex;
_RO NSIP *indexPathByIncrementingLastIndex;

- (NSIP*) indexPathByReplacingIndexAtPosition:(NSUI)pos withIndex:(NSUI)idx;
@end

@interface NSObject (AtoZKVO)
+ (NSSet*)keyPathsForValuesAffecting: (NSS*)key fromDictionary:(NSD*)pairs;
//- (NSSet*)keyPathsForValuesAffecting:(NSS*)string includingSuper:(NSSet*(^)(NSS*key))block;
//+ (NSSet*) keyPathsForValuesAffectingValueForKey:(NSSet*(^)(NSS*key))block;
@end

@interface NSIndexSet (AtoZ)
+ (instancetype) indexWithIndexes:(NSA*)idxs;
+ (instancetype) indexesOfObjects:(NSA*)objs inArray:(NSA*)ref;
@end

