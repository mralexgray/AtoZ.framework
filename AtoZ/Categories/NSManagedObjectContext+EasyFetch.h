#import <Cocoa/Cocoa.h>


@interface NSManagedObjectContext (EasyFetch)

- (NSSet *)fetchObjectsForEntityName:(NSString *)newEntityName
                       withPredicate:(id)stringOrPredicate, ...;

- (NSManagedObject*)copyObject:(NSManagedObject*)object
                        parent:(NSString*)parentEntity;

@end
