// 
//  UserOrderableObject.m
//  Soapbox
//
//  Created by Steven Degutis on 6/12/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "NSManagedObject+SDAdditions.h"
//#import "SDModelController.h"

#define SD_THROW_IF_ERROR if (error) \
	@throw [NSException exceptionWithName:[error localizedDescription] \
								   reason:[error localizedFailureReason] \
								 userInfo:[NSDictionary dictionaryWithObject:error forKey:@"error"]];

@implementation NSManagedObject (SDAdditions)

// MARK: -
// MARK: General Accessors

+ (id) createObjectInManagedObjectContext:(NSManagedObjectContext*)MOC {
	NSString *entityName = NSStringFromClass(self);
	return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:MOC];
}

+ (id) fetchAllObjectsInManagedObjectContext:(NSManagedObjectContext*)MOC {
	NSString *entityName = NSStringFromClass(self);
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
											  inManagedObjectContext:MOC];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	
	NSError *error = nil;
	NSArray *results = [MOC executeFetchRequest:request error:&error];
	
	SD_THROW_IF_ERROR;
	
	return results;
}

+ (id) fetchObjectsInManagedObjectContext:(NSManagedObjectContext*)MOC
					returnOnlyFirstResult:(BOOL)firstOnly
						useSortDescriptor:(NSSortDescriptor*)sortDesciptor
						  predicateFormat:(NSString*)predicateFormat, ...
{
	NSPredicate *predicate = nil;
	{
		va_list arguments;
		va_start(arguments, predicateFormat);
		if (predicateFormat)
			predicate = [NSPredicate predicateWithFormat:predicateFormat arguments:arguments];
		va_end(arguments);
	}
	
	return [self fetchObjectsInManagedObjectContext:MOC
							  returnOnlyFirstResult:firstOnly
								  useSortDescriptor:sortDesciptor
										  predicate:predicate];
}

+ (id) fetchObjectsInManagedObjectContext:(NSManagedObjectContext*)MOC
					returnOnlyFirstResult:(BOOL)firstOnly
						useSortDescriptor:(NSSortDescriptor*)sortDesciptor
								predicate:(NSPredicate*)predicate
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self)
											  inManagedObjectContext:MOC];
	
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entity];
	
	if (firstOnly)
		[request setFetchLimit:1];
	
	if (sortDesciptor)
		[request setSortDescriptors:@[sortDesciptor]];
	
	if (predicate)
		[request setPredicate:predicate];
	
	NSError *error = nil;
	NSArray *results = [MOC executeFetchRequest:request error:&error];
	
	SD_THROW_IF_ERROR;
	
	if ([results count] > 0)
		return (firstOnly == YES ? [results firstObject] : results);
	else
		return nil;
}

@end
