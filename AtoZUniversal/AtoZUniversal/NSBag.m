


#import <AtoZUniversal/AtoZUniversal.h>


@implementation NSBag { NSMutableDictionary *dict; } SYNTHESIZE_CLASS_FACTORY(bag)

- init { 	return self = super.init ? dict = NSMD.new, self : nil;	}

- _Void_ add:__ { NSParameterAssert(__); NSN*ct; dict[__] = @(((ct = dict[__]) ? ct.iV : 0) + 1); }

+ (NSBag *) bagWithObjects:__, ... {

	NSBag *bag = self.bag; if (!__) return bag;

  [bag add:__];

	va_list objects;  va_start(objects,__);  id obj;

	while ((obj = va_arg(objects, id)))	{		[bag add:obj]; }

	va_end(objects);

  return bag;
}

- _Void_ addObjects:__, ... {

	if (!__) return;
	[self add:__];

	va_list objects;	va_start(objects,__); id obj;

	while ((obj = va_arg(objects, id))) [self add:obj];

	va_end(objects);
}

- _Void_ remove:anObject	{

	NSNumber *num = dict[anObject];
	if (!num) return;
	if ([num intValue] == 1) return [dict removeObjectForKey:anObject];
	dict[anObject] = @(num.iV - 1);
}

- (NSI) occurrencesOf:anObject	{	return [dict[anObject] intValue]; }
- (NSA*)      objects	{	return [dict.allKeys reduce:@[].mC withBlock:^id(id sum, id obj) {

    for ( int i = 0; i < [dict[obj] iV]; i++) [sum addObject:obj]; return sum;
  }];
}
- (NSA*) uniqueObjects {

  return [self.objects reduce:@[].mC withBlock:^id(id sum, id obj) {
    [sum containsObject:obj] ?: [sum addObject:obj]; return sum;
	}];
}

- (NSA*) sortedObjects {

  return [self.uniqueObjects sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

    NSUI a = [self occurrencesOf:obj1], b = [self occurrencesOf:obj2];

    return  a > b ? (NSComparisonResult)NSOrderedAscending  :
            a < b ? (NSComparisonResult)NSOrderedDescending : (NSComparisonResult)NSOrderedSame;

  }];
}
+ (instancetype) bagWithArray:(NSArray *)a {
	NSBag *b = self.bag;
	for (id x in a) [b add:x];
	return b;
}

- (NSS*) description { return $(@"NSBag with %lu objects (%lu unique)", (unsigned long)self.objects.count, (unsigned long)self.uniqueObjects.count);  /* return dict.description; */ }

@end
