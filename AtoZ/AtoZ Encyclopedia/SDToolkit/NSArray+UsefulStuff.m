//
//  NSArray+UsefulStuff.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "NSArray+UsefulStuff.h"
@implementation NSArray (UsefulStuff)

- (NSA*) reversedArray {
	return [[self reverseObjectEnumerator] allObjects];
}

- (id) firstObject {
	if ([self count] > 0)
		return self[0];
	else
		return nil;
}

@end

@implementation NSMutableArray (UsefulStuff)

- (void) moveObjectFromIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex {
	if (oldIndex == newIndex)
		return;
	
	if (newIndex > oldIndex)
		newIndex--;
	
	id object = self[oldIndex];
	
	[object retain];
	
	[self removeObjectAtIndex:oldIndex];
	[self insertObject:object atIndex:newIndex];
	
	[object release];
}

@end
