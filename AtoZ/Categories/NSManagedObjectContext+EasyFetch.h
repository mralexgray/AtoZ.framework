

@interface NSManagedObjectContext (EasyFetch)

- (NSSet *)fetchObjectsForEntityName:(NSS*)newEntityName
					   withPredicate: stringOrPredicate, ...;

- (NSManagedObject*)copyObject:(NSManagedObject*)object
						parent:(NSString*)parentEntity;

@end
