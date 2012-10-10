/**
 
 \category  NSArray(NUExtension)
 
 \brief     Adds a number of facilities to NSArray for a more functional style
            of programming. Additional properties make some statements more
            obvious.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <Foundation/Foundation.h>


#define NSArrayFromEllipsisFirstValue(value)\
    ({\
        NSMutableArray *_array = [NSMutableArray array];\
        va_list ap;\
        va_start(ap, value);\
        while (value) {\
            [_array addObject:value];\
            value = va_arg(ap,id);\
        }\
        va_end(ap);\
        _array;\
    })


@interface NSArray (NUExtensions)

/// ----------------------------------------------------------------------------
/// # Properties
/// ----------------------------------------------------------------------------

/// Returns the first object in the array or nil if the array is empty.
@property(readonly) id firstObject;

/// Returns YES if the array is empty and NO otherwise.
@property(readonly) BOOL isEmpty;

/// Returns NO if the array is empty and YES otherwise.
@property(readonly) BOOL isNotEmpty;



/// ----------------------------------------------------------------------------
/// # Creating Arrays
/// ----------------------------------------------------------------------------

/// Creates an array with a specified number of double values.
/// Each double gets stored in the array using an NSNumber.
+ (NSArray*) arrayWithDoubles:(NSUInteger)count,...;

/// Creates an array with a specified number of integers.
/// Each integer gets stored in the array using an NSNumber.
+ (NSArray*) arrayWithInts:(NSUInteger)count,...;



/// ----------------------------------------------------------------------------
/// # Generating Arrays
/// ----------------------------------------------------------------------------

/**
 
 arrayByRemovingObjectAtIndex:
 
 \brief   returns a copy of this array from which the object at the
          specified `index` has been removed.
 
 \details If `index` is out of range an exception will be raised.
 
 \param   in  index  zero-based index of the object to remove.
 
 \returns an array with one fewer object in it.
 
 */
- (NSArray*) arrayByRemovingObjectAtIndex:(NSUInteger) index;

/// Returns a copy of this array from which the first object has been removed.
- (NSArray*) arrayByRemovingFirstObject;

/// Returns a copy of this array from which the last object has been removed.
- (NSArray*) arrayByRemovingLastObject;

/// Returns a copy of this array in which the elements appear in reverse order.
- (NSArray*) arrayInReverseOrder;

/// Returns a copy of this array in whith object was removed.
- (NSArray*) arrayByRemovingObject:(id)object;

/**
 
 objectsAtIndexesInArray:
 
 \brief   Same semantics as objectsAtIndexes but uses an array parameter instead.
 
 \details If any of the indexes are out of range an exception is raised.
 
 \param   in  indexes  an array of NSNumber
 
 \returns an array with one element for each value in indexes.
 
 */
- (NSArray*) objectsAtIndexesInArray:(NSArray*)indexes;


/**
 
 objectsAtIndexesInArray:
 
 \brief   Returns an array of values uniformaly distributed between startValue and endValue.
 
 \details There are three edge cases. If count is zero an empty array is returned. 
          If count is one then the result will contain only the `startValue`. If count 
          is two the result will contain both the `startValue` and `endValue`. 
          Any other value will also produce intermediate values uniformally spaced
          between startValue and endValue.
 
 \param   in  startValue    lower bound of the range.
 \param   in  endValue      upper bound of the range.
 \param   in  count         number of values to generate.
 
 \returns an array with count NSNumber objects.
 
 */
+ (NSArray*) arrayWithUniformDistributionFromValue:(double)startValue 
                                           toValue:(double)endValue 
                                             count:(NSUInteger)count
;


/// ----------------------------------------------------------------------------
/// # Mapping Methods
/// ----------------------------------------------------------------------------

/**
 
 map:
 
 \brief   calls the given block once for each object in the array and collects 
          the results in the returned array.
 
 \details The block is passed the object which it is supposed to map. If any of 
          the values returned by the block are nil then they are substituted 
          with an NSNull object.
 
 \param   in  aBlock  block mapping our objects to other objects.
  
 */
- (NSArray*) map:(id(^)(id object)) aBlock;


/**
 
 mapWithIndex:
 
 \brief   calls the given block once for each object in the array and collects 
          the results in the returned array.
 
 \details The block is passed the object which it is supposed to map as well as 
          its index in the array. If any of the values returned by the block are 
          nil then they are substituted with an NSNull object.
 
 \param   in  aBlock  block mapping our objects to other objects.
 
 */
- (NSArray*) mapWithIndex:(id(^)(id object, NSUInteger index)) aBlock;



/**
 
 mapKeyPath:
 
 \brief   calls valueForKeyPath:`aKeyPath` on all objects in the array and 
          collects the results into a new array.
 
 \details If any of the values returned are nil then they are substituted with 
          an NSNull object.
 
 \param   in  aKeyPath  string to be passed to valueForKeyPath.
 
 */
- (NSArray*) mapKeyPath:(NSString*)aKeyPath;


/**
 
 mapSelector:
 
 \brief   calls the selector on all objects in the array and collects the 
          results into a new array.
 
 \details If any of the values returned are nil then they are substituted with NSNull.
          If any of the objects does not respond to the selector the result is also NSNull.
 
 \param   in  aSelector  string to be passed to valueForKeyPath.
 
 */
- (NSArray*) mapSelector:(SEL)aSelector;




/// ----------------------------------------------------------------------------
/// # Filtering Methods
/// ----------------------------------------------------------------------------


/**
 
 filter:
 
 \brief   calls the block on all objects in the array and builds a new array
          with the objects for which the block return YES. If no such object
          is found the result is nil.
 
 */
- (NSArray*) filter:(BOOL(^)(id object)) aBlock;


/**
 
 filter:
 
 \brief   calls the block on all objects in the array and builds a new array
          with the objects for which the block return YES. If no such object
          is found the result is nil.
 
 \details the block is passed both the object to map as well as its index 
          within the array.
 
 */
- (NSArray*) filterWithIndex:(BOOL(^)(id object, NSUInteger index)) aBlock;



/**
 
 findFirst:
 
 \brief   calls the block on all objects in order and returns the first one
          for which the block returns YES.
 
 */
- (id) findFirst:(BOOL(^)(id object)) aBlock;

/**
 
 findFirst:
 
 \brief   calls the block on all objects in order and returns the first one
          for which the block returns YES. The block is passed both the object
          and its index within the array.
 
 */
- (id) findFirstWithIndex:(BOOL(^)(id object, NSUInteger index)) aBlock;



/// ----------------------------------------------------------------------------
/// # Sorting Methods
/// ----------------------------------------------------------------------------

/**
 
 sortByKeyPaths
 
 \brief     sorts by keyPath but on equality will sort by the second key path and so on.
 
 \details   This is equivalent to sorting by each key successively in reverse order.
 
 */
- (NSArray*) sortedArrayByKeyPaths:(NSString*)keyPath,...; 


/// ----------------------------------------------------------------------------
/// # Miscellaneous Methods
/// ----------------------------------------------------------------------------


/**
 
 indexSetForObjectsInArray
 
 \brief   creates an indexSet from the objects in the `values` array. 
 
 \details Any object in `values` that is not found in the array is 
 silently ignored.
 
 \param   in  values    an array of objects
 
 \returns an indexSet with upto values.count indexes.
 
 */
- (NSIndexSet*) indexSetForObjectsInArray:(NSArray*)values;




@end
