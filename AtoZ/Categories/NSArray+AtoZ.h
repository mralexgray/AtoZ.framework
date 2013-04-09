
//  NSArray+AtoZ.h
//  AtoZ

#import "AtoZ.h"

@interface NSArray (EnumExtensions)

- (NSString*) stringWithEnum: (NSUInteger) enumVal;
- (NSUInteger) enumFromString: (NSString*) strVal default: (NSUInteger) def;
- (NSUInteger) enumFromString: (NSString*) strVal;

@end
@interface  NSArray (NSTableDataSource)
- (id) tableView:(NSTableView*)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn row:(NSI)rowIndex;
- (NSI) numberOfRowsInTableView:(NSTableView *)aTableView;
@end

@interface NSArray (AtoZ)


- (int) createArgv:(char***)argv;

+ (NSArray *) from:(NSI)from to:(NSI)to;

- (id) nextObject;

- (NSA*) alphabetize;

- (NSS*) formatAsListWithPadding:(NSUI)characters;

- (NSCountedSet*)countedSet ;

/*!
 @brief	Returns an array of NSNumbers whose -integerValues
 span a given range, each value being one more than the previous
 value.	*/
+ (NSArray*)arrayWithRange:(NSRange)range ;


- (NSA*) withMinRandomItems:(NSUI) items;
- (NSA*) withMaxRandomItems:(NSUI) items;


- (NSA*) withMinItems:(NSUI) items;
- (NSA*) withMinItems:(NSUI) items usingFiller:(id) fill;

- (NSA*) withMaxItems:(NSUI) items;

- (void) setStringsToNilOnbehalfOf:(id)entity;  // FIX:  DOCUMENT!!

- (NSA*) URLsForPaths;
- (void) logEachPropertiesPlease;
- (void) logEachProperties;
- (void) logEach;
+ (NSA*) arrayFromPlist:(NSString*)path;
- (void) saveToPlistAtPath:(NSString*)path;

- (NSString*) stringWithEnum: (NSUInteger) anEnum;
- (NSUInteger) enumFromString: (NSString*) aString default: (NSUInteger) def;
- (NSUInteger) enumFromString: (NSString*) aString;
@property (RONLY) NSArray *colorValues;
+ (NSMutableArray *)mutableArrayWithArrays:(NSArray *)arrays;
+ (NSArray *)arrayWithArrays:(NSArray *)arrays;
- (NSArray *)arrayWithEach;
- (NSS*) stringValueInColumnsCharWide:(NSUI)characters;



#define vsForKeys dictionaryWithValuesForKeys

- (NSArray *)arrayUsingIndexedBlock:(id (^)(id obj, NSUInteger idx))block;

- (NSArray *)sortedWithKey:(NSString *)theKey ascending:(BOOL)ascending;
//- (NSArray *)sortedArrayUsingArray:(NSArray *)otherArray;
/*** Returns an NSArray containing a number of NSNumber elements that have been initialized with NSInteger values. As this method takes a variadic argument list you have to terminate the input with a NSNotFound entry This is done automatically via the $ints(...) macro */
+ (NSArray *)arrayWithInts:(NSInteger)i,...;

/*** Returns an NSArray containing a number of NSNumber elements that have been initialized with double values. As this method takes a variadic argument list you have to terminate the input with a FLOAT_MAX entry This is done automatically via the $doubles(...) macro */
+ (NSArray *)arrayWithDoubles:(double)d,...;

/*** Returns an NSSet containing the same elements as the array (unique of course, as the set does not keep doubled entries) */
@property (RONLY) NSSet *set;

@property (RONLY) NSArray *shifted;
@property (RONLY) NSArray *popped;
@property (RONLY) NSArray *reversed;

/*** Returns an array of the same size as the original one with the result of calling the keyPath on each object */
- (NSArray *)arrayWithKey:(NSString *)keyPath;


/**	Calls performSelector on all objects that can receive the selector in the array.
 * Makes an iterable copy of the array, making it possible for the selector to modify
 * the array. Contrast this with makeObjectsPerformSelector which does not allow side effects of
 * modifying the array.	*/
- (void)perform:(SEL)selector;
- (void)perform:(SEL)selector withObject:(id)p1;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;

/**	Extensions to makeObjectsPerformSelector to provide support for more than one object
 * parameter.	*/
- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)makeObjectsPerformSelector: (SEL)selector
						withObject: (id)p1
						withObject: (id)p2
						withObject: (id)p3;

/**	@return nil or an object that matches value with isEqual:	*/
- (id)objectWithValue:(id)value forKey:(id)key;

/**	@return the first object with the given class.	*/
- (id)objectWithClass:(Class)cls;

/**	@param selector Required format: - (NSNumber*)method:(id)object;	*/
- (BOOL)containsObject:(id)object withSelector:(SEL)selector;


/*** Returns an array of the same size as the original one with the result of performing the selector on each object */
//- (NSArray *)arrayPerformingSelector:(SEL)selector;

/*** Returns an array of the same size as the original one with the result of performing the selector on each object */
//- (NSArray *)arrayPerformingSelector:(SEL)selector withObject:(id)object;

/*** Returns an array of the same size as the original one with the results of performing the block on each object */
- (NSArray *)arrayUsingBlock:(id (^)(id obj))block;

/*** Shortcut for the arrayUsingBlock method map is better known in more functional oriented languages */
- (NSArray *)map:(id (^)(id obj))block;

- (NSArray *)nmap:(id (^)(id obj, NSUInteger index))block;

/*** performs consecutive calls of block for every pair of elements in this array */
- (id)reduce:(id (^)(id a, id b))block;

/*** Returns a subArray that does not contain the argument object */
- (NSArray *)arrayWithoutObject:(id)object;

/*** Returns a subArray that does not contain any of the passed arguments */
- (NSArray *)arrayWithoutObjects:(id)object,...;

/*** Returns a subArray that does not contain any value that the passed NSArray contains */
- (NSArray *)arrayWithoutArray:(NSArray *)value;

/*** Returns a subArray that does not contain any value that the passed NSSet contains */
- (NSArray *)arrayWithoutSet:(NSSet *)values;

/*** Returns a subArray in wich all object returned true for the block Reduced version of filteredArrayUsingBlock, without the dictionary */
- (NSArray *)filter:(BOOL (^)(id object))block;

- (NSArray *)subIndex:(NSUI)subIndex filter:   (BOOL (^)(id object))block;
- (id)	     subIndex:(NSUI)subIndex filterOne:(BOOL (^)(id object))block;

//performs block on subindex of array and returns the result of the block
- (id)subIndex:(NSUI)subIndex block:(MapArrayBlock)block;
//performs block on subindex of array and returns the original index object that return from the block
- (id)subIndex:(NSUI)subIndex blockReturnsIndex:(MapArrayBlock)block;

/*** Filters one element from the array that returns YES from the called block might not always be the same, it just will return any match! In case you are not absolutely sure that there is only ONE match better use filter and grab the result manually will return nil for no match */
- (id)filterOne:(BOOL (^)(id object))block;

/*** Returns YES when all members of the current array pass the isKindOfClass test with the given Class */
- (BOOL)allKindOfClass:(Class)aClass;

/*** Returns a subArray with all members of the original array that pass the isKindOfClass test with the given Class */
- (NSArray *)elementsOfClass:(Class)aClass;

/*** Shortcut for elementsOfClass:NSNumber.class */
@property (RONLY) NSArray *numbers;

/*** Shortcut for elementsOfClass:NSString.class */
@property (RONLY) NSArray *strings;
/*** Returns a subArray with all NSString members and calls trim on each before returning */
@property (RONLY) NSArray *trimmedStrings;

- (NSArray *)subarrayFromIndex:(NSInteger)start;
- (NSArray *)subarrayToIndex:(NSInteger)end;
- (NSArray *)subarrayFromIndex:(NSInteger)start toIndex:(NSInteger)end;

/*** Returns a random element from this array */
@property (RONLY) id randomElement;

/*** Returns a random subArray of this array with up to 'size' elements */
- (NSArray *)randomSubarrayWithSize:(NSUInteger)size;

/*** Returns a shuffeled version of this array */
@property (RONLY) NSArray *shuffeled;

/*** A failsave version of objectAtIndex When the given index is outside the bounds of the array it will be projected onto the bounds of the array Just imagine the array to be a ring  that will have its first and last element connected to each other */
- (id)objectAtNormalizedIndex:(NSInteger)index;
- (id)normal:(NSInteger)index;

/*** A failsave version of objectAtIndex that will return the fallback value in case an error occurrs or the value is nil */
- (id)objectAtIndex:(NSUInteger)index fallback:(id)fallback;

/*** Will at least return nil in case the index does not fit the array */
- (id)objectOrNilAtIndex:(NSUInteger)index;

@property (RONLY) id first;
@property (RONLY) id second;
@property (RONLY) id thrid;
@property (RONLY) id fourth;
@property (RONLY) id fifth;
@property (RONLY) id sixth;


@property (RONLY) id last;

- (NSInteger)sumIntWithKey:(NSString *)keyPath;
- (CGFloat)sumFloatWithKey:(NSString *)keyPath;

/*** Returns YES when this array contains any of the elements in enumerable */
- (BOOL)containsAny:(id <NSFastEnumeration>)enumerable;

/*** Returns YES when this array contains all of the elements in enumerable */
- (BOOL)containsAll:(id <NSFastEnumeration>)enumerable;
-(BOOL)doesNotContainObjects:(id<NSFastEnumeration>)enumerable;

-(BOOL)doesNotContainObject:(id)object;
/*** dummy, just for the 'foreach' macro */
-(id)andExecuteEnumeratorBlock;

/*** Just a case study at the moment. Just another way of writing enumerateUsingBlock, but as it's written kvc conform the foreach macro can be used to write code like foreach (id o, array) {   ... } */
-(void)setAndExecuteEnumeratorBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

/*** */
-(NSArray *)objectsWithFormat:(NSString *)format, ...;
-(id)firstObjectWithFormat:(NSString *)format, ...;

-(NSArray *)filteredArrayUsingBlock: (BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
-(NSA*) uniqueObjects;

-(NSA*) uniqueObjectsSortedUsingSelector: (SEL)comparator;

-(id)firstObject;

-(void) eachDictionaryKeyAndObjectUsingBlock:(void(^)(id key, id obj))block;



-(void) az_each:(void (^)(id obj, NSUInteger index, BOOL *stop))block;

-(void) az_eachConcurrentlyWithBlock:(void (^)(NSInteger index, id obj, BOOL * stop))block;

-(id)findWithBlock:(BOOL (^)(id obj))block;

-(BOOL)isObjectInArrayWithBlock:(BOOL (^)(id obj))block;

-(NSArray *)findAllWithBlock:(BOOL (^)(id obj))block;

#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
-(NSHashTable *)findAllIntoWeakRefsWithBlock:(BOOL (^)(id))block;
#endif

-(NSArray *)mapArray:(id (^)(id obj))block;
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

- (void) addPoint:(NSPoint)point;
- (void) addRect:(NSRect)rect;

- (void) firstToLast;

- (void) lastToFirst;

// alike removeLastObject
-(void)removeFirstObject;
// shift & pop for stacklike operations
// they will return the removed objects
// removes and returns the first object in the array
// if no elements are present, nil will be returned
-(id)shift;

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
- (id)pop;

/**	Helper method for looking at the last object in the receiver.
 	Internally, the method sends the receiver `lastObject` message and returns the result. If the receiver is an empty array, `nil` is returned.
 	@return Returns the last object in the receiver.	 */
- (id)peek;


// shortcut for the default sortUsingSelector:@selector(compare:)
-(NSMutableArray *)sort;

// reverses the whole array
-(NSMutableArray *)az_reverse;

// randomizes the order of the array
-(NSMutableArray *)shuffle;

- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id, NSUInteger))block;

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