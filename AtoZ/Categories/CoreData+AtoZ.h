//
//  CoreData+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 5/14/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//


//NSManagedObject+EasyFetching.h

@interface NSManagedObjectContext (EasyFetch)
#pragma mark -
#pragma mark Fetch all unsorted

/** @brief Convenience method to fetch all objects for a given Entity name in
 * this context.
 *
 * The objects are returned in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName;

#pragma mark -
#pragma mark Fetch all sorted

/** @brief Convenience method to fetch all objects for a given Entity name in
 * the context.
 *
 * The objects are returned in the order specified by the provided key and
 * order.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending;

/** @brief Convenience method to fetch all objects for a given Entity name in
 * the context.
 *
 * If the sort descriptors array is not nil, the objects are returned in the
 * order specified by the sort descriptors. Otherwise, the objects are returned
 * in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors;

#pragma mark -
#pragma mark Fetch filtered unsorted

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * If the predicate is not nil, the selection is filtered by the provided
 * predicate.
 *
 * The objects are returned in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                        withPredicate:(NSPredicate*)predicate;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * The selection is filtered by the provided formatted predicate string and
 * arguments.
 *
 * The objects are returned in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                  predicateWithFormat:(NSString*)predicateFormat, ...;

#pragma mark -
#pragma mark Fetch filtered sorted

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * If the predicate is not nil, the selection is filtered by the provided
 * predicate.
 *
 * The objects are returned in the order specified by the provided key and
 * order.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                        withPredicate:(NSPredicate*)predicate;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * If the predicate is not nil, the selection is filtered by the provided
 * predicate.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortWith:(NSArray*)sortDescriptors
                        withPredicate:(NSPredicate*)predicate;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * The selection is filtered by the provided formatted predicate string and
 * arguments.
 *
 * The objects are returned in the order specified by the provided key and
 * order.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                  predicateWithFormat:(NSString*)predicateFormat, ...;

/** @brief Convenience method to fetch selected objects for a given Entity name
 * in the context.
 *
 * The selection is filtered by the provided formatted predicate string and
 * arguments.
 *
 * If the sort descriptors array is not nil, the objects are returned in the
 * order specified by the sort descriptors. Otherwise, the objects are returned
 * in the order specified by Core Data.
 */
- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
                  predicateWithFormat:(NSString*)predicateFormat, ...;
@end

//@interface NSManagedObject (EasyFetching)
// 
//+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
//+ (NSArray *)findAllObjects;
//+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context;
// 
//@end
