//
//  NSBag.m
//  AtoZ
//
//  Created by Alex Gray on 9/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSBag.h"

@implementation NSBag
- (id) init { 	if (!(self = [super init])) return self;
	dict = [[NSMutableDictionary alloc] init]; 	return self;
}

+ (NSBag *) bag { 	return [[NSBag alloc] init]; }

- (void) add: (id) anObject {
	int count = 0;	NSNumber *num = dict[anObject];
	if (num) count = [num intValue];
	NSNumber *newnum = @(count + 1);
	if ( (anObject) && (newnum) )	dict[anObject] = newnum;
}

+ (NSBag *) bagWithObjects:(id)item,... {
	NSBag *bag = [NSBag bag];	if (!item) return bag;
	[bag add:item];
	va_list objects;	va_start(objects, item);	id obj = va_arg(objects, id);
	while (obj)	{
		[bag add:obj];		obj = va_arg(objects, id);	}
	va_end(objects);	return bag;
}

- (void) addObjects:(id)item,...{
	if (!item) return;
	[self add:item];

	va_list objects;
	va_start(objects, item);
	id obj = va_arg(objects, id);
	while (obj)
	{
		[self add:obj];
		obj = va_arg(objects, id);
	}
	va_end(objects);
}

- (void) remove: (id) anObject
{
	NSNumber *num = dict[anObject];
	if (!num) return;
	if ([num intValue] == 1)
	{
		[dict removeObjectForKey:anObject];
		return;
	}
	NSNumber *newnum = @([num intValue] - 1);
	dict[anObject] = newnum;
}

- (NSInteger) occurrencesOf: (id) anObject
{
	NSNumber *num = dict[anObject];
	return [num intValue];
}

- (NSArray *) objects
{
	return [dict allKeys];
}

- (NSString *) description
{
	return [dict description];
}
@end
