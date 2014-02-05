
#import "NSManagedObjectContext+EasyFetch.h"


@implementation NSManagedObjectContext (EasyFetch)

// Convenience method to fetch the array of objects for a given Entity
// name in the context, optionally limiting by a predicate or by a predicate
// made from a format NSString and variable arguments.
//
- (NSSet *)fetchObjectsForEntityName:(NSS*)newEntityName
					   withPredicate:(id)stringOrPredicate, ...
{
  NSEntityDescription *entity = [NSEntityDescription
								 entityForName:newEntityName inManagedObjectContext:self];
  
  NSFetchRequest *request = [[NSFetchRequest.alloc init] autorelease];
  [request setEntity:entity];
  
  if (stringOrPredicate)
  {
	NSPredicate *predicate;
	if ([stringOrPredicate isKindOfClass:NSString.class])
	{
	  va_list variadicArguments;
	  va_start(variadicArguments, stringOrPredicate);
	  predicate = [NSPredicate predicateWithFormat:stringOrPredicate
										 arguments:variadicArguments];
	  va_end(variadicArguments);
	}
	else
	{
	  NSAssert2([stringOrPredicate isKindOfClass:[NSPredicate class]],
				@"Second parameter passed to %s is of unexpected class %@",
				sel_getName(_cmd), [stringOrPredicate className]);
	  predicate = (NSPredicate *)stringOrPredicate;
	}
	[request setPredicate:predicate];
  }
  
  NSError *error = nil;
  NSArray *results = [self executeFetchRequest:request error:&error];
  if (error != nil)
  {
	[NSException raise:NSGenericException format:@"%@",[error description]];
  }
  
  return [NSSet setWithArray:results];
}

- (NSManagedObject*)copyObject:(NSManagedObject*)object
						parent:(NSString*)parentEntity
{
  NSString *entityName = [[object entity] name];
  
  NSManagedObject *newObject = [NSEntityDescription 
								insertNewObjectForEntityForName:entityName 
								inManagedObjectContext:self];
  
  NSMutableDictionary* lookup = NSMutableDictionary.new;
  [lookup setObject:newObject forKey:[object objectID]];
  
  NSArray *attKeys = [[[object entity] attributesByName] allKeys];
  NSDictionary *attributes = [object dictionaryWithValuesForKeys:attKeys];
  
  [newObject setValuesForKeysWithDictionary:attributes];
  
  id oldDestObject = nil;
  id temp = nil;
  NSDictionary *relationships = [[object entity] relationshipsByName];
  for (NSString *key in [relationships allKeys]) {
	
	NSRelationshipDescription *desc = [relationships valueForKey:key];
	NSString *destEntityName = [[desc destinationEntity] name];
	if ([destEntityName isEqualToString:parentEntity]) continue;
	
	if ([desc isToMany]) {
	  
	  NSMutableSet *newDestSet = [NSMutableSet set];
	  
	  for (oldDestObject in [object valueForKey:key]) {
		temp = [lookup objectForKey:[oldDestObject objectID]];
		if (!temp) {
		  temp = [self copyObject:oldDestObject 
						   parent:entityName];
		}
		[newDestSet addObject:temp];
	  }
	  
	  [newObject setValue:newDestSet forKey:key];
	  
	} else {
	  oldDestObject = [object valueForKey:key];
	  if (!oldDestObject) continue;
	  
	  temp = [lookup objectForKey:[oldDestObject objectID]];
	  if (!temp && ![destEntityName isEqualToString:parentEntity]) {
		temp = [self copyObject:oldDestObject 
						 parent:entityName];
	  }
	  
	  [newObject setValue:temp forKey:key];
	}
  }
  
  return newObject;
}

@end
