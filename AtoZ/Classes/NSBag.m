//
//  NSBag.m
//  AtoZ
//
//  Created by Alex Gray on 9/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
#import "AtoZ.h"
#import "NSBag.h"

@implementation NSBag
{
	NSMutableDictionary *dict;
}

- (id) init { 	return self = [super init] ? dict = NSMD.new, self : nil;	}
+ (instancetype) bag { 	return self.new; }
- (void) add: (id) anObject {

	NSNumber *num = dict[anObject];
	NSNumber *newnum = @((num ? [num intValue] : 0) + 1);
	if (anObject && newnum)	dict[anObject] = newnum;
}

+ (NSBag *) bagWithObjects:(id)item,... {
	NSBag *bag = self.bag;
	if (!item) return bag;
	[bag add:item];
	va_list objects;	va_start(objects, item);	id obj = va_arg(objects, id);
	while (obj)	{		[bag add:obj];						obj = va_arg(objects, id); }
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

- (void) remove: (id) anObject	{

	NSNumber *num = dict[anObject];
	if (!num) return;
	if ([num intValue] == 1) return [dict removeObjectForKey:anObject];
	dict[anObject] = @(num.iV - 1);
}

- (NSInteger) occurrencesOf: (id) anObject	{	return [dict[anObject] intValue]; }
- (NSArray*)  objects	{	return dict.allKeys;	}
- (NSA*) uniqueObjects {  return [self.objects reduce:@[] withBlock:^id(id sum, id obj) {
	return sum = [sum containsObject:obj] ? sum : [sum arrayByAddingObject:obj];
	}];
}
- (NSString*) description	{	return dict.description; }

+ (instancetype) bagWithArray:(NSArray *)a {
	NSBag *b = self.bag;
	for (id x in a) [b add:x];
	return b;
}
@end
