//
//  UserOrderableObject.h
//  Soapbox
//
//  Created by Steven Degutis on 6/12/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <CoreData/CoreData.h>
@interface NSManagedObject (SDAdditions)

+ createObjectInManagedObjectContext:(NSManagedObjectContext*)MOC;

+ fetchAllObjectsInManagedObjectContext:(NSManagedObjectContext*)MOC;

+ fetchObjectsInManagedObjectContext:(NSManagedObjectContext*)MOC
					returnOnlyFirstResult:(BOOL)firstOnly
						useSortDescriptor:(NSSortDescriptor*)sortDesciptor
						  predicateFormat:(NSString*)predicateFormat, ...;

+ fetchObjectsInManagedObjectContext:(NSManagedObjectContext*)MOC
					returnOnlyFirstResult:(BOOL)firstOnly
						useSortDescriptor:(NSSortDescriptor*)sortDesciptor
								predicate:(NSPredicate*)predicate;

@end
