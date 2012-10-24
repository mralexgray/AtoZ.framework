
//  NSArray+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Foundation/Foundation.h>
#import "AtoZ.h"

//#import "NSString+AG.h"
//#import "NSMutableArray+AG.h"
@interface NSArray (EnumExtensions)

- (NSString*) stringWithEnum: (NSUInteger) enumVal;
- (NSUInteger) enumFromString: (NSString*) strVal default: (NSUInteger) def;
- (NSUInteger) enumFromString: (NSString*) strVal;

@end
@interface  NSArray (NSTableDataSource)
- (id) tableView:(NSTableView*)aTableView objectValueForTableColumn:(NSTableColumn*)aTableColumn row:(int)rowIndex;
- (int) numberOfRowsInTableView:(NSTableView *)aTableView;
@end

@interface NSArray (AtoZ)

- (NSA*) URLsForPaths;
- (void) logEach;
+ (NSArray*) arrayFromPlist:(NSString*)path;
- (void) saveToPlistAtPath:(NSString*)path;

- (NSString*) stringWithEnum: (NSUInteger) anEnum;
- (NSUInteger) enumFromString: (NSString*) aString default: (NSUInteger) def;
- (NSUInteger) enumFromString: (NSString*) aString;
@property (RONLY) NSArray *colorValues;
+ (NSMutableArray *)mutableArrayWithArrays:(NSArray *)arrays;
+ (NSArray *)arrayWithArrays:(NSArray *)arrays;
- (NSArray *)arrayWithEach;

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


/**
 * Calls performSelector on all objects that can receive the selector in the array.
 * Makes an iterable copy of the array, making it possible for the selector to modify
 * the array. Contrast this with makeObjectsPerformSelector which does not allow side effects of
 * modifying the array.
 */
- (void)perform:(SEL)selector;
- (void)perform:(SEL)selector withObject:(id)p1;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;

/**
 * Extensions to makeObjectsPerformSelector to provide support for more than one object
 * parameter.
 */
- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)makeObjectsPerformSelector: (SEL)selector
                        withObject: (id)p1
                        withObject: (id)p2
                        withObject: (id)p3;

/**
 * @return nil or an object that matches value with isEqual:
 */
- (id)objectWithValue:(id)value forKey:(id)key;

/**
 * @return the first object with the given class.
 */
- (id)objectWithClass:(Class)cls;

/**
 * @param selector Required format: - (NSNumber*)method:(id)object;
 */
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

-(NSArray *)filteredArrayUsingBlock:
(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block;
-(NSArray*) uniqueObjects;

-(NSArray*) uniqueObjectsSortedUsingSelector: (SEL)comparator;

-(id)firstObject;

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
+ (NSArray*)arrayWithBlock:(id(^)(int index))block range:(NSRange)range;

// The same with a condition 
+ (NSArray*)arrayWithBlock:(id(^)(int index))block range:(NSRange)range if:(BOOL(^)(int index))blockTest;

-(NSR)rectAtIndex:(NSUInteger)index;
@end


@interface NSMutableArray (AG)

- (void) addPoint:(NSPoint)point;
- (void) addRect:(NSRect)rect;

// sugar properties
@property (retain) id last;
@property (retain) id first;
- (void) firstToLast;

- (void) lastToFirst;

// alike removeLastObject
-(void)removeFirstObject;
// shift & pop for stacklike operations
// they will return the removed objects
// removes and returns the first object in the array
// if no elements are present, nil will be returned
-(id)shift;

// removes and returns the last object in the array
// if no elements are present, nil will be returned
-(id)pop;

- (void)push:(id)obj;

// shortcut for the default sortUsingSelector:@selector(compare:)
-(NSMutableArray *)sort;

// reverses the whole array
-(NSMutableArray *)az_reverse;

// randomizes the order of the array
-(NSMutableArray *)shuffle;

- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

- (void) moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id, NSUInteger))block;

@end
