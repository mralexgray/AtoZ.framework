
#import "AtoZUmbrella.h"
#import "AtoZTypes.h"
//#import "KVOMap/KVOMap.h"


@interface AZSparseArray : NSO <FakeArray>

+ (instancetype) arrayWithObjectsAndIndexes:(id) first,... NS_REQUIRES_NIL_TERMINATION;
+ (void) test;

@end

extern NSString * const NSMutableArrayDidInsertObjectNotification;

@interface NSArray (EnumExtensions)
- (NSS*) stringWithEnum:(NSUI)enumVal;
- (NSUI) enumFromString:(NSS*)strVal;
- (NSUI) enumFromString:(NSS*)strVal default:(NSUI)def;
@end

@interface  NSArray (NSTableDataSource)
-  (id) tableView:(NSTV*)tv objectValueForTableColumn:(NSTC*)tc row:(NSI)idx;
- (NSI) numberOfRowsInTableView:(NSTableView *)aTableView;
@end

@interface NSArray (AtoZCLI)
- (NSS*) stringValueInColumnsCharWide:(NSUI)characters;
- (NSS*)      formatAsListWithPadding:(NSUI)characters;
@end

#define AZKP AZKeyPair
#define AZKPMake(KEY_PAIR_KEY,KEY_PAIR_VALUE) [AZKP key:KEY_PAIR_KEY value:KEY_PAIR_VALUE]
#define $AZKP(K,V) AZKPMake(K,V)

/** Abbreviated, AZKP, these re good for returning a Key pair to a dictionary from an array block.  
	  Designated init. + (instancetype) key:(id)k value:(id)v; */

//GENERICSABLE(AZKeyPair)

@interface AZKeyPair : NSO + (INST) key:(id)k value:(id)v; +(INST) withDuo:(NSA*)a;
@property (copy) id key, value;
@end

@interface NSSet (AtoZ)
- (id)filterOne:(BOOL (^)(id object))block;
- (NSET*)  setByRemovingObject:(id)x;
@end
@interface NSMutableArray (AtoZ)
VOID(addObjectIfMissing:(id)x);
VOID(addObjectsIfMissing:(id<NSFastEnumeration>)x);
@end
@interface NSArray (AtoZ)

- (NSMA*) mapM:(BKTransformBlock)block;

- (NSA*) arrayOfClass:(Class)oClass forKey:(NSS*)k;
- (NSA*) arrayOfClass:(Class)oClass;
-   (id)       reduce:(id)initial 
                 with:(AZIndexedAccumulationBlock)block;

@property (RONLY) NSA* jumbled, *splitByParity;

/*! @param pairs the array to be "mixed in"
    @code   [@[@1, @2, @3] pairedWith:@[@"a", @"b", @"c"]] -> @[@[@1,@"a"],@[@2,@"b"],@[@3,@"c"]]
*/
- (NSA*) pairedWith:(NSA*)secondVal;

/*! @param combines the array to be "mixed in"
    @code   [@[@1, @2, @3] pairedWith:@[@"a", @"b", @"c"]] -> @[@1,@"a",@2,@"b",@3,@"c"] 
*/
- (NSA*) combinedWith:(NSA*)another;


//     azva_list_to_nsarray(firstVal, values);  [values eachWithVariadicPairs:^(id a, id b) { [x setValue:b forKey:a]; }]
- (void) eachWithVariadicPairs:(void(^)(id a, id b))pairs;

+ (instancetype) arrayWithCopies:(NSUI)copies of:(id<NSCopying>)obj;

@property (RONLY) NSS * joinedByNewlines, * joinedWithSpaces, * componentString;

/** Iterates objects with Timer, executing a block on each step.
 @param time Speed of the timer interval
 @param repeat Should it loop?
 @param block A three-arguent, void return block.  Gives iterated object, its index, and a STOP pointer for the timer.
 @return Returns an NSTimer, for future invalidation, etc.
 */
-  (NST*) enumerateWithInterval:(NSTI)time repeat:(BOOL)repeat usingBlock:(AZObjIdxStopBlock)block;

-  (NSS*)  stringAtIdx:(NSUI)idx;
- (NSMS*) mstringAtIdx:(NSUI)idx;
-  (NSD*)    dictAtIdx:(NSUI)idx;
- (NSMD*)   mdictAtIdx:(NSUI)idx;
-  (NSA*)   arrayAtIdx:(NSUI)idx;
- (NSMA*)  marrayAtIdx:(NSUI)idx;


+ (NSA*) arrayWithRects:(NSR)firstRect,...NS_REQUIRES_NIL_TERMINATION;
-  (int) createArgv:(char***)argv;
+ (NSA*) from:(NSI)from to:(NSI)to;       // shortcut for [@(from) to:@(to)], I think

@property (RONLY) id nextObject,          // keeps tack, ad returns the "next" object from an array.  until it runs out, then trurns nil.
                      nextNormalObject;   // same as "nextObject", but is a everlasting font of normalized, looping vals

- (NSA*) arrayByAddingAbsentObjectsFromArray:(NSA*)otherArray;
- (NSRNG) rangeOfSubarray:(NSA*)sub;
/*!
 @brief	Returns an array of NSNumbers whose -integerValues
 span a given range, each value being one more than the previous
 value.	*/
+ (NSA*) arrayWithRange:	 (NSRNG)range;
- (NSA*) withMinRandomItems:(NSUI)items;
- (NSA*) withMaxRandomItems:(NSUI)items;
- (NSA*) withMin:     (NSUI)min max:(NSUI)max;
- (NSA*) withMaxItems:(NSUI) items;
- (NSA*) withMinItems:(NSUI)items;
- (NSA*) withMinItems:(NSUI)items usingFiller:(id) fill;
- (void) setStringsToNilOnbehalfOf:(id)entity;  // FIX:  DOCUMENT!!

@property (RONLY) CSET * countedSet;
@property (RONLY)  NSN * maxNumberInArray, * minNumberInArray;
@property (RONLY)  NSA * shifted, * popped, * reversed,
                       * ascending, * descending,
                       * URLsForPaths,
                       * colorValues,
                       * arrayWithEach,
                       * allKeysInChildDictionaries,
                       * allvaluesInChildDictionaries;
@property (RONLY) NSMA * mutableCopies;  // Make each object mutable, if possible. Returns mutable itself.

//- (NSA<NSN>*) ascending; - (NSA<NSN>*) descending;

- (NSA*) sorted:(AZOrder)o;
@prop_RO NSA * sorted;

- (void) logEachPropertiesPlease;
- (void) logEachProperties;
- (void) logEach;

+ (NSA*)    arrayFromPlist:(NSS*)path;
- (void) saveToPlistAtPath:(NSS*)path;
- (NSS*)    stringWithEnum:(NSUI)e;
- (NSUI)    enumFromString:(NSS*)s default:(NSUI)def;
- (NSUI)    enumFromString:(NSS*)s;

+ (NSMA*) mutableArrayWithArrays:(NSA*)arrays;
+  (NSA*)        arrayWithArrays:(NSA*)arrays;

#define vsForKeys dictionaryWithValuesForKeys

- (NSA*) arrayUsingIndexedBlock:(id(^)(id o,NSUI idx))b;
- (NSA*)          sortedWithKey:(NSS*)k ascending:(BOOL)ascending;

@prop_RO NSA* sortedColors;
//- (NSA*)sortedArrayUsingArray:(NSA*)otherArray;
/*** Returns an NSArray containing a number of NSNumber elements that have been initialized with NSInteger values. As this method takes a variadic argument list you have to terminate the input with a NSNotFound entry This is done automatically via the $ints(...) macro */
+ (NSA*) arrayWithInts:(NSI)i,...;

/*** Returns an NSArray containing a number of NSNumber elements that have been initialized with double values. As this method takes a variadic argument list you have to terminate the input with a FLOAT_MAX entry This is done automatically via the $doubles(...) macro */
+ (NSA*) arrayWithDoubles:(double)d,...;

/*** Returns an NSSet containing the same elements as the array (unique of course, as the set does not keep doubled entries) */
@prop_RO NSET *asSet;

/*** Returns an array of the same size as the original one with the result of calling the keyPath on each object */
- (NSA*)arrayWithKey:(NSS*)keyPath;

/** will not brick if not all obects have the key etc */
- (NSA*)arrayWithObjectsMatchingKeyOrKeyPath:(NSS*)keyPath;
- (NSA*) arrayBySettingValue:(id)v forObjectsKey:(NSS*)k;

/**	Calls performSelector on all objects that can receive the selector in the array.
 * Makes an iterable copy of the array, making it possible for the selector to modify
 * the array. Contrast this with makeObjectsPerformSelector which does not allow side effects of
 * modifying the array.	*/
- (void)perform:(SEL)sel;
- (void)perform:(SEL)sel withObject:(id)p1;
- (void)perform:(SEL)sel withObject:(id)p1 withObject:(id)p2;
- (void)perform:(SEL)sel withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;

/**	Extensions to makeObjectsPerformSelector to provide support for more than one object
 * parameter.	*/
- (void)makeObjectsPerformSelector:(SEL)s withObject:(id)o1 withObject:(id)o2;
- (void)makeObjectsPerformSelector:(SEL)s withObject:(id)o1	withObject:(id)o2 withObject:(id)o3;

- (void)makeObjectsPerformSelector:(SEL)s withBool:(BOOL)b;

/**	@return nil or an object that matches value with isEqual:	*/
-   (id)  objectWithValue:(id)v forKey:(id)k;
-   (id) objectsWithValue:(id)v forKey:(id)k;
/**	@return the first object with the given class.	*/
-   (id) objectWithClass:(Class)cls;
/**	@param selector Required format: - (NSNumber*)method:(id)object;	*/
- (BOOL) containsObject:(id)obj withSelector:(SEL)sel;
/*** Returns an array of the same size as the original one with the result of performing the selector on each object */
- (NSA*) arrayPerformingSelector:(SEL)sel;

/*** Returns an array of the same size as the original one with the result of performing the selector on each object */
- (NSA*)arrayPerformingSelector:(SEL)sel withObject:(id)obj;

/*** Returns an array of the same size as the original one with the results of performing the block on each object */
- (NSA*)arrayUsingBlock:(id(^)(id obj))blk;

/*** Shortcut for the arrayUsingBlock method map is better known in more functional oriented languages */
- (NSA*)az_map:(id (^)(id obj))blk;

- (NSA*)nmap:(id(^)(id obj,NSUI index))blk;

/*** performs consecutive calls of block for every pair of elements in this array */
- (id)reduce:(id (^)(id a, id b))block;

/*** Returns a subArray that does not contain the argument object */
- (NSA*)arrayWithoutObject:(id)object;

/*** Returns a subArray that does not contain any of the passed arguments */
- (NSA*)arrayWithoutObjects:(id)object,...;

/*** Returns a subArray that does not contain any value that the passed NSArray contains */
- (NSA*)arrayWithoutArray:(NSA*)value;

/*** Returns a subArray that does not contain any value that the passed NSSet contains */
- (NSA*)arrayWithoutSet:(NSSet *)values;

//Will return only strings NOT containing string.
- (NSA*) arrayWithoutStringContaining:(NSS*)str;

/*** Returns a subArray in wich all object returned true for the block Reduced version of filteredArrayUsingBlock, without the dictionary */
- (NSA*)filter:(BOOL (^)(id object))block;

/*** Returns the first object (non-nil) from the block.  Not necessarily the object passed in, but somethig. */
- (id)filterOneBlockObject:(id(^)(id object))block;


// returns  the first non-nil response.
- (id)filterNonNil:(id(^)(id))block;

- (NSUI)indexOfFirstObjectPassing:(BOOL(^)(id obj))block;

- (NSA*)subIndex:(NSUI)subIndex filter:   (BOOL (^)(id object))block;
- (id)		 subIndex:(NSUI)subIndex filterOne:(BOOL (^)(id object))block;

//performs block on subindex of array and returns the result of the block
- (id)subIndex:(NSUI)subIndex block:(MapArrayBlock)block;
//performs block on subindex of array and returns the original index object that return from the block
- (id)subIndex:(NSUI)subIndex blockReturnsIndex:(MapArrayBlock)block;
/*** Filters one element from the array that returns YES from the called block might not always be the same, it just will return any match! In case you are not absolutely sure that there is only ONE match better use filter and grab the result manually will return nil for no match */
- (id)filterOne:(BOOL (^)(id object))block;
/*** Returns YES when all members of the current array pass the isKindOfClass test with the given Class */

/** [@[@2,@3,@4] testThatAllReturn:YES block:^BOOL(NSN*o){ return o.uIV < 4; }] -> NO.  but with 5, returns YES! */
//- (BOOL) testThatAllReturn:(BOOL)response block:(BOOL(^)(id o))b; // Iterates until gets a NO, and returns NO.  YES, if all pass!

- (BOOL) hasMemberEqualToString:(NSS*)s;

- (BOOL)allKindOfClass:(Class)aClass;
/*** Returns a subArray with all members of the original array that pass the isKindOfClass test with the given Class */
- (NSA*)elementsOfClass:(Class)aClass;
/*** Shortcut for elementsOfClass:NSNumber.class */
@property (RONLY) NSArray *numbers;
/*** Shortcut for elementsOfClass:NSString.class */
@property (RONLY) NSArray *strings;
/*** Returns a subArray with all NSString members and calls trim on each before returning */
@property (RONLY) NSArray *trimmedStrings;

- (NSA*)             after:(NSUI)subarrayFromIndex; /* subarrayFromIndex alias; */
- (NSA*)  subarrayFromIndex:(NSUI)start;
- (NSA*)     subarrayToIndex:(NSUI)end;
- (NSA*)   subarrayFromIndex:(NSUI)start toIndex:(NSUI)end;
- (NSA*) subarrayWithIndexes:(NSIS*)idxs;

/*** Returns a random element from this array */
@property (RONLY) id randomElement;
/*** Returns a random subArray of this array with up to 'size' elements */
- (NSA*)randomSubarrayWithSize:(NSUI)size;
/*** Returns a shuffeled version of this array */
@property (RONLY) NSArray *shuffeled;
/*** A failsave version of objectAtIndex When the given index is outside the bounds of the array it will be projected onto the bounds of the array Just imagine the array to be a ring  that will have its first and last element connected to each other */
- (id)objectAtNormalizedIndex:(NSI)index;
- (NSUI) normalizedIndex:(NSI)index;  // Gives the normalized index for an out of range index.
- (id)normal:(NSI)index;

/*** A failsave version of objectAtIndex that will return the fallback value in case an error occurrs or the value is nil */
- (id)objectAtIndex:(NSUI)index fallback:(id)fallback;
/*** Will at least return nil in case the index does not fit the array */
- (id)objectOrNilAtIndex:(NSUI)index;

@property (RONLY) NSA * alphabetized, * sum, * uniqueObjects, * uniqueStrings;
@prop_RO IndexedKeyMap * alphaMap;
@property (RONLY)  id   first, second, thrid, fourth, fifth, sixth, last, firstObject;

- (NSI)              sumIntWithKey:(NSS*)keyPath;
- (CGF)            sumFloatWithKey:(NSS*)keyPath;
/*** Returns YES when this array contains any of the elements in enumerable */
- (BOOL)               containsAny:(id<NSFastEnumeration>)enumerable;
/*** Returns YES when this array contains all of the elements in enumerable */
- (BOOL)               containsAll:(id<NSFastEnumeration>)enumerable;
- (BOOL)     doesNotContainObjects:(id<NSFastEnumeration>)enumerable;
- (BOOL)      doesNotContainObject:(id)object;

/*** Just a case study at the moment. Just another way of writing enumerateUsingBlock, but as it's written kvc conform the foreach macro can be used to write code like foreach (id o, array) {   ... } */
- (void)         setAndExecuteEnumeratorBlock:(void(^)(id o, NSUI idx, BOOL*s))b;

- (NSA*)                    objectsWithFormat:(NSS*)format, ...;
-   (id)                firstObjectWithFormat:(NSS*)format, ...;
-   (id)                   firstObjectOfClass:(Class)k;
- (NSA*)              filteredArrayUsingBlock:(BOOL(^)(id evaluatedObject, NSDictionary *bindings))block;
- (NSA*)     uniqueObjectsSortedUsingSelector:(SEL)comparator;
- (void) eachDictionaryKeyAndObjectUsingBlock:(void(^)(id k, id o))b;
- (void)                              az_each:(void(^)(id o, NSUI idx, BOOL *s))b;
- (void)         az_eachConcurrentlyWithBlock:(void (^)(NSI idx, id o, BOOL *s))b;
-   (id)                        findWithBlock:(BOOL(^)(id o))b;
- (BOOL)             isObjectInArrayWithBlock:(BOOL(^)(id o))b;
- (NSA*)                     findAllWithBlock:(BOOL(^)(id o))b;
- (void)                              doUntil:(BOOL(^)(id o))b;

#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
-(NSHashTable*)findAllIntoWeakRefsWithBlock:(BOOL (^)(id))block;
#endif

- (NSA*)             mapArray:(id(^)(id o))b;
- (NSD*) mapToDictForgivingly:(AZKeyPair*(^)(id))b;
- (NSD*) mapToDictValuesForgivingly:(id(^)(id))b;
- (NSD*)   mapToDictKeysForgivingly:(id(^)(id))b;
- (NSD*)      mapToDictionaryForKey:(NSS*)k;
@end

@interface NSArray(ListComprehensions) 
// Create a new array with a block applied to each index to create a new element 
+ (NSA*)arrayWithBlock:(id(^)(int index))block range:(NSRange)range;

// The same with a condition 
+ (NSA*)arrayWithBlock:(id(^)(int index))block range:(NSRange)range if:(BOOL(^)(int index))blockTest;

-(NSR)rectAtIndex:(NSUInteger)index;
@end

@interface NSArray (WeakReferences)
- (NSMA*)weakReferences;
@end

@interface NSMutableArray (WeakReferences)
+ (id)mutableArrayUsingWeakReferences;
+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity;
@end

@interface NSMutableArray (AG)

@property (RONLY) NSMA * alphabetize;
-  (void) addPoint:(NSP)p;
-  (void)  addRect:(NSR)r;

@property (RONLY) id advance;  /* returns first object.. moves it to last. */
-  (void) firstToLast;
-  (void) lastToFirst;


-(void)removeFirstObject; // alike removeLastObject
// shift & pop for stacklike operations -  they will return the removed objects removes and returns the first object in the array  if no elements are present, nil will be returned
@property (RONLY) id shift;

// insert at index: 0
- (void) shove: (id) object;

/** Helper method for adding the given object to the end of the receiver.
 	Internally the method sends the receiver `addObject:`, but using this method makes usage of array as stack more obvious.
 	@param object The object to push to the end of the receiver.	*/
- (void)push:(id)object;

/** Helper method to removing the last object from the receiver. removes and returns the last object in the array
	Internally the method sends the receiver `removeLastObject` and returns the removed object.
	@return Returns the object removed from the receiver.
	@exception if no elements are present, nil will be returned   FALSE: NSException Raised if the receiver is an empty array.	*/
@property (RONLY) id pop;

/**	Helper method for looking at the last object in the receiver.
 	Internally, the method sends the receiver `lastObject` message and returns the result. If the receiver is an empty array, `nil` is returned.
 	@return Returns the last object in the receiver.	 */
@property (RONLY) id peek;

@property (RONLY) NSMA * sort,        // shortcut for the default sortUsingSelector:@selector(compare:)
                       * az_reverse,  // reverses the whole array
                       * shuffle;     // randomizes the order of the array

- (void) moveObject:(id)obj toIndex:(NSUI)toIndex;

- (void) moveObjectAtIndex:(NSUI)fromIdx toIndex:(NSUI)toIdx;
- (void) moveObjectAtIndex:(NSUI)fromIdx toIndex:(NSUI)toIdx withBlock:(void(^)(id,NSUInteger))block;

@end

/*!
 @brief	 Methods for showing arrays as formatted strings	*/
@interface NSArray (Stringing)

/*!
 @brief	Lists items in the receiver in a list with newlines
 between adjacent items.

 @param	key  The key for which the value will be extracted
 and inserted into the list for each item, or nil to use the
 default key of 'description'.

 @param	bullet  A string which, if not nil, will be prepended
 to each line in the output.  You'll probably want this string to
 end in one or two space characters.	*/
- (NSString*)listValuesOnePerLineForKeyPath:(NSString*)key
									 bullet:(NSString*)bullet ;

/*!
 @brief	Invokes listValuesOnePerLineForKeyPath:bullet: with
 bullet = nil	*/
- (NSString*)listValuesOnePerLineForKeyPath:(NSString*)key ;

/*!
 @brief	Returns a comma-separated list of the responses to
 each item in the receiver to a given key.

 @details  If the receiver is empty, returns an empty string.&nbsp;

 If an item does not respond to the given 'key', its response
 to -description will appear in the list.  For example, if you
 pass 'key' = "name", items which respond to -name will be
 listed as their -name and items which do not respond will be
 listed as their -description.

 If an item does respond to the given 'key', but the response
 is nil, not an NSString instance, or an NSString instance of
 length 0, then its contribution will be omitted from the result.

 Note that if you are using truncateTo, you probably don't
 want to give a conjunction and vice versa.
 @param	key  The key for which the value will be extracted
 and inserted into the list for each item, or nil to use the
 default key of 'description'.
 @param	conjunction  If non-nil, and there are more than two
 items, inserts this word before the last item.  Typically this
 is a localized "&", "and" or "or"
 @param	truncateTo  The maximum number of items desired in
 the returned list.&nbsp;  If the number of items in the receiver
 exceeds this parameter, another comma and an ellipsis will
 be appended to the end.&nbsp;  For convenience, a value of 0
 is interpreted to mean NSIntegerMax.	*/
- (NSString*)listValuesForKey:(NSString*)key
				  conjunction:(NSString*)conjunction
				   truncateTo:(NSInteger)truncateTo ;

/*!
 @brief	Invokes -[self listValuesForKey:@"name" parameters
 conjunction=nil and truncateTo=0]	*/
- (NSString*)listNames ;

@end

//	Category:
// Methods to treat an NSArray with three/four elements as an RGB/RGBA color.
//  Useful for storing colors in NSUserDefaults and other Property Lists.
//  Note that this isn't quite the same as storing an NSData of the color, as
//  some colors can't be correctly represented in RGB, but this makes for more
//  readable property lists than NSData.
// If we wanted to get fancy, we could use an NSDictionary instead and save
//	different color types in different ways.
@interface NSArray (UKColor)
+ (NSArray*)		arrayWithColor: (NSColor*) col;
- (NSColor*)		colorValue;
@end

@interface NSArray (StringExtensions)
@property (RONLY) NSA * reversedArray, *sortedStrings, * uniqueMembers,
                      * unionOfObjects; //  valueForKeyPath:@"@unionOfObjects"]
@property (RONLY) NSS * stringValue;
@property (RONLY)  id   firstObject;

- (NSA*)        unionWithArray:(NSA*)a;
- (NSA*) intersectionWithArray:(NSA*)a;

- (NSA*)     map:(SEL)sel; // Note also see: makeObjectsPeformSelector: withObject:. Map collects the results a la mapcar in Lisp
- (NSA*) collect:(SEL)sel;
- (NSA*)  reject:(SEL)sel;
- (NSA*)     map:(SEL)sel withObject:(id)o;
- (NSA*) collect:(SEL)sel withObject:(id)o;
- (NSA*)  reject:(SEL)sel withObject:(id)o;
- (NSA*)     map:(SEL)sel withObject:(id)o1 withObject:(id)o2;
- (NSA*) collect:(SEL)sel withObject:(id)o1 withObject:(id)o2;
- (NSA*)  reject:(SEL)sel withObject:(id)o1 withObject:(id)o2;
@end

@interface NSMutableArray (UtilityExtensions)
-  (void) moveObjectFromIndex:(NSI)oldIndex toIndex:(NSI)newIndex;
@property (RONLY)                 NSMA * removeFirstObject, * reverse, *scramble;
@property (RONLY, getter=reverse) NSMA * reversed;
@end

@interface NSMutableArray (StackAndQueueExtensions) 
- (NSMA*)  pushObject:(id)o;
- (NSMA*)        push:(id)o; // aka pushObject
- (NSMA*) pushObjects:(id)o,...;

@property (RONLY) id popObject, pop, pullObject, pull; // With Synonyms for traditional use
@end

@interface NSArray (FilterByProperty)

- (NSA*)    subArrayWithMembersOfKind:(Class)klass;
- (NSUI)  lengthOfLongestMemberString;
- (NSA*)             filterByProperty:(NSS*) p;
- (NSA*) stringsPaddedToLongestMember;

@end


/** Adds recursive lookup to traditional Key-Value Coding  */
@interface NSObject (RecursiveKVC)
/** Returns the result of recursively invoking `valueForKey:` on each returned object until it reaches a `nil` value. 
 @param key The name of one of the receiver's properties.
 @return The objects returned by recursively calling the `valueForKey:` method on objects returned by `valueForKey:`
*/
- (NSA*)recursiveValueForKey:(NSS*)k;
@end
@interface NSArray (RecursiveKVC)
/** Returns an array containing the results of invoking `recursiveValueForKey:` using `key` on each of the array's objects. 
 Importantly, this method does not follow the `valueForKey:` approach of adding `NSNull` objects to the 
 returned array when `nil` is returned. It merely does not add these objects to the array.
 @param key The key to retrieve.
 @return An array
 */
- (NSA*)recursiveValueForKey:(NSS*)k;
@end





