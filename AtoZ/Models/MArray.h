
#import <Foundation/Foundation.h>
#import "AtoZ.h"

@interface MArray : NSProxy <NSObject> {
	id _proxiedObject;
}

-(id)proxiedObject;
@end

#pragma mark Method declarations to nuke compiler warnings
//copied from NSArray.h
@interface MArray (objectsWithFormat)
-(NSUI)addObjectsWithFormat:(NSString*)format,...;
@end

@interface MArray (Basic)
- (NSUI)count;
- (id)objectAtIndex:(NSUI)index;
@end

@interface MArray (NSExtendedArray)

- (MArray *)arrayByAddingObject:(id)anObject;
- (MArray *)arrayByAddingObjectsFromArray:(NSArray *)otherArray;
- (NSString *)componentsJoinedByString:(NSString *)separator;
- (BOOL)containsObject:(id)anObject;
- (NSString *)description;
- (NSString *)descriptionWithLocale:(NSDictionary *)locale;
- (NSString *)descriptionWithLocale:(NSDictionary *)locale indent:(unsigned)level;
- (id)firstObjectCommonWithArray:(MArray *)otherArray;
- (void)getObjects:(id *)objects;
- (void)getObjects:(id *)objects range:(NSRange)range;
- (NSUI)indexOfObject:(id)anObject;
- (NSUI)indexOfObject:(id)anObject inRange:(NSRange)range;
- (NSUI)indexOfObjectIdenticalTo:(id)anObject;
- (NSUI)indexOfObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (BOOL)isEqualToArray:(MArray *)otherArray;
- (id)lastObject;
- (NSEnumerator *)objectEnumerator;
- (NSEnumerator *)reverseObjectEnumerator;
- (NSData *)sortedArrayHint;
- (MArray *)sortedArrayUsingFunction:(int (*)(id, id, void *))comparator context:(void *)context;
- (MArray *)sortedArrayUsingFunction:(int (*)(id, id, void *))comparator context:(void *)context hint:(NSData *)hint;
- (MArray *)sortedArrayUsingSelector:(SEL)comparator;
- (MArray *)subarrayWithRange:(NSRange)range;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically;

- (void)makeObjectsPerformSelector:(SEL)aSelector;
- (void)makeObjectsPerformSelector:(SEL)aSelector withObject:(id)argument;

@end

@interface MArray (MArrayCreation)

+ (id)array;
+ (id)arrayWithContentsOfFile:(NSString *)path;
+ (id)arrayWithContentsOfURL:(NSURL *)url;
+ (id)arrayWithObject:(id)anObject;
+ (id)arrayWithObjects:(id)firstObj, ...;
- (id)initWithArray:(MArray *)array;
#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED
- (id)initWithArray:(MArray *)array copyItems:(BOOL)flag;
#endif
- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithContentsOfURL:(NSURL *)url;
- (id)initWithObjects:(id *)objects count:(unsigned)count;
- (id)initWithObjects:(id)firstObj, ...;

+ (id)arrayWithArray:(NSArray *)array;
+ (id)arrayWithObjects:(id *)objs count:(unsigned)cnt;

@end

/****************	Mutable Array		****************/

@interface MArray (NSMutableArrayAdditions)

- (void)addObject:(id)anObject;
- (void)insertObject:(id)anObject atIndex:(unsigned)index;
- (void)removeLastObject;
- (void)removeObjectAtIndex:(unsigned)index;
- (void)replaceObjectAtIndex:(unsigned)index withObject:(id)anObject;

@end

@interface MArray (NSExtendedMutableArray)

- (void)addObjectsFromArray:(MArray *)otherArray;
- (void)exchangeObjectAtIndex:(unsigned)idx1 withObjectAtIndex:(unsigned)idx2;
- (void)removeAllObjects;
- (void)removeObject:(id)anObject inRange:(NSRange)range;
- (void)removeObject:(id)anObject;
- (void)removeObjectIdenticalTo:(id)anObject inRange:(NSRange)range;
- (void)removeObjectIdenticalTo:(id)anObject;
- (void)removeObjectsFromIndices:(unsigned *)indices numIndices:(unsigned)count;
- (void)removeObjectsInArray:(MArray *)otherArray;
- (void)removeObjectsInRange:(NSRange)range;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(MArray *)otherArray range:(NSRange)otherRange;
- (void)replaceObjectsInRange:(NSRange)range withObjectsFromArray:(MArray *)otherArray;
- (void)setArray:(MArray *)otherArray;
- (void)sortUsingFunction:(int (*)(id, id, void *))compare context:(void *)context;
- (void)sortUsingSelector:(SEL)comparator;

@end

@interface MArray (NSMutableArrayCreation)

+ (id)arrayWithCapacity:(unsigned)numItems;
- (id)initWithCapacity:(unsigned)numItems;

@end