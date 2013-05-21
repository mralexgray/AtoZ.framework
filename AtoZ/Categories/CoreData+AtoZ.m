//
//  CoreData+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 5/14/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "CoreData+AtoZ.h" 

@implementation NSManagedObjectContext (EasyFetch)

#pragma mark -
#pragma mark Fetch all unsorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
{
  return [self fetchObjectsForEntityName:entityName sortWith:nil
                           withPredicate:nil];
}

#pragma mark -
#pragma mark Fetch all sorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
{
  return [self fetchObjectsForEntityName:entityName sortByKey:key
                               ascending:ascending withPredicate:nil];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
{
  return [self fetchObjectsForEntityName:entityName sortWith:sortDescriptors
                           withPredicate:nil];
}

#pragma mark -
#pragma mark Fetch filtered unsorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                        withPredicate:(NSPredicate*)predicate
{
  return [self fetchObjectsForEntityName:entityName sortWith:nil
                           withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
  va_list variadicArguments;
  va_start(variadicArguments, predicateFormat);
  NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
                                                  arguments:variadicArguments];
  va_end(variadicArguments);

  return [self fetchObjectsForEntityName:entityName sortWith:nil
                           withPredicate:predicate];
}

#pragma mark -
#pragma mark Fetch filtered sorted

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                        withPredicate:(NSPredicate*)predicate
{
  NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:key
                                                       ascending:ascending];

#if !__has_feature(objc_arc)
  [sort autorelease];
#endif

  return [self fetchObjectsForEntityName:entityName sortWith:[NSArray
                         arrayWithObject:sort] withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
                        withPredicate:(NSPredicate*)predicate
{
  NSEntityDescription* entity = [NSEntityDescription entityForName:entityName
                                            inManagedObjectContext:self];
  NSFetchRequest* request = [[NSFetchRequest alloc] init];

#if !__has_feature(objc_arc)
  [request autorelease];
#endif

  [request setEntity:entity];

  if (predicate)
  {
    [request setPredicate:predicate];
  }

  if (sortDescriptors)
  {
    [request setSortDescriptors:sortDescriptors];
  }

  NSError* error = nil;
  NSArray* results = [self executeFetchRequest:request error:&error];

  if (error != nil)
  {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [NSException raise:NSGenericException format:@"%@", [error description]];
  }

  return results;
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                            sortByKey:(NSString*)key
                            ascending:(BOOL)ascending
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
  va_list variadicArguments;
  va_start(variadicArguments, predicateFormat);
  NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
                                                  arguments:variadicArguments];
  va_end(variadicArguments);

  return [self fetchObjectsForEntityName:entityName sortByKey:key
                               ascending:ascending withPredicate:predicate];
}

- (NSArray*)fetchObjectsForEntityName:(NSString*)entityName
                             sortWith:(NSArray*)sortDescriptors
                  predicateWithFormat:(NSString*)predicateFormat, ...
{
  va_list variadicArguments;
  va_start(variadicArguments, predicateFormat);
  NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateFormat
                                                  arguments:variadicArguments];
  va_end(variadicArguments);

  return [self fetchObjectsForEntityName:entityName sortWith:sortDescriptors
                           withPredicate:predicate];
}
@end

////NSManagedObject+EasyFetching.m
//@implementation NSManagedObject (EasyFetching)
// 
//+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;
//{
//    return [self respondsToSelector:@selector(entityInManagedObjectContext:)] ?
//    [self performSelector:@selector(entityInManagedObjectContext:) withObject:context] :
//    [NSEntityDescription entityForName:NSStringFromClass(self) inManagedObjectContext:context];
//}
// 
//+ (NSArray *)findAllObjects;
//{
//    NSManagedObjectContext *context = 
//	 [[[NSApplication sharedApplication] delegate] managedObjectContext];
//    return [self findAllObjectsInContext:context];
//}
// 
//+ (NSArray *)findAllObjectsInContext:(NSManagedObjectContext *)context;
//{
//    NSEntityDescription *entity = [self entityDescriptionInContext:context];
//    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
//    [request setEntity:entity];
//    NSError *error = nil;
//    NSArray *results = [context executeFetchRequest:request error:&amp;error];
//    if (error != nil)
//    {
//        //handle errors
//    }
//    return results;
//}
//@end
