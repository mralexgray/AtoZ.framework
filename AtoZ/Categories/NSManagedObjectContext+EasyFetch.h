

@interface NSManagedObjectContext (EasyFetch)

- (NSSet *)fetchObjectsForEntityName:(NSS*)newEntityName
					   withPredicate:(id)stringOrPredicate, ...;

- (NSManagedObject*)copyObject:(NSManagedObject*)object
						parent:(NSString*)parentEntity;

@end
