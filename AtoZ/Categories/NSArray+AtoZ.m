
//  NSArray+AtoZ.m
//  AtoZ

#import "NSArray+AtoZ.h"
//#import "AZLog.h"

NSString * const NSMutableArrayDidInsertObjectNotification = @"com.mrgray.NSMutableArrayDidInsertObjectNotification";

@implementation NSArray (EnumExtensions)

- (NSS*) stringWithEnum:(NSUInteger)enumVal {
    return self[enumVal];
}

- (NSUInteger)enumFromString:(NSS*) strVal default:(NSUInteger)def
{
    NSUI n = [self indexOfObject:strVal];
    if (n == NSNotFound) n = def;
    return n;
}

- (NSUInteger)enumFromString:(NSS*) strVal {
    return [self enumFromString:strVal default:0];
}

@end
@implementation NSArray (NSTableDataSource)

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSI)rowIndex {
    id obj = self[rowIndex]; if (obj == nil) return nil;
    if (![obj ISADICT]) return obj;
    return ((NSD*)obj)[[aTableColumn identifier]];
}

- (NSI)numberOfRowsInTableView:(NSTableView *)aTableView {
    return [self count];
}

@end

//#import "Nu.h"

@implementation NSArray (AtoZCLI)

- (NSS*) stringValueInColumnsCharWide:(NSUI)characters {
    return [self reduce:^id (id memo, id obj) {
        NSUI min = MAX(characters - [obj length], 0);
        return [memo withString:[obj stringByPaddingToLength:characters withString:@" " startingAtIndex:0]];
    } withInitialMemo:@""];
}
- (NSS*) formatAsListWithPadding:(NSUI)characters	{

	return /*$(@"\n%@",*/ [[[self alphabetize] map:^id (id obj) {
		return [obj stringByPaddingToLength:characters withString:@" " startingAtIndex:0];
	}] componentsJoinedByString:@" "]; // );
}
- (NSA*) alphabetize { return [self.mutableCopy sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];	}

@end

@implementation NSArray (AtoZ)

- (NSA*)arrayByAddingAbsentObjectsFromArray:(NSArray *)otherArray {
	__block NSMA* newself = self.mutableCopy;
	[otherArray each:^(id obj) {
		[newself containsObject:obj] ? nil : [newself addObject:obj];
	}];
	return newself;
}


+ (NSA*) arrayWithRects:(NSR)firstRect,...NS_REQUIRES_NIL_TERMINATION {

 	NSMutableArray *re = NSMutableArray.array; id detector;
   [re addObject:AZVrect(firstRect)];
	va_list args;
   va_start(args, firstRect);
		while ((detector = va_arg(args, id)) != nil);
		NSRect r;
		(r = va_arg(args, NSRect));
		[re addObject:AZVrect(r)];
    va_end(args);
    return re;
}
-(NSS*)swizzleDescription {
//	[NSPropertyListWriter_vintage stringWithPropertyList:self];
//	NSS *normal =
	[self swizzleDescription];
//	NSLog(@"normal: %@", normal);
	return [[[NSS stringWithData:[AZXMLWriter dataWithPropertyList:self] encoding:NSUTF8StringEncoding] stringByRemovingPrefix:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">"]stringByRemovingSuffix:@"</plist>"];

}

- (NSObject*) swizzledObjectAtIndexedSubscript: (NSUInteger) i {

	return i < self.count ? [self swizzledObjectAtIndexedSubscript:i]  : [self normal:i];
//	id try = nil;
//	if (i < self.count) {
//			try =  (id)[self swizzledObjectAtIndexedSubscript:i];
//		if (!try) {
//				try = [[self normal:i]copy];
//				try ? NSLog(@"found indexed subscript for arrray starting with: %@ from NORMALIZED subscript!", self[0]) :
//								NSLog(@"Array of length :%ld, with first item: %@ could not find index at subscript: %ld", self.count, self.first, i);
//		}
//	} else {	__block NSBag *b = NSBag.new; [self do:^(id obj) { [b add:NSStringFromClass([obj class])]; }];
//				NSS *types = [[b objects] reduce:^id(id memo, id obj) {
//					return [memo withString:$(@"%ld instances of class: %@\n", [b occurrencesOf:obj], obj)]; } withInitialMemo:@"In this array there are..\n"];
//				NSLog(@"%@ %s indexed subscript out of bounds.  last good valu was :%@.... my length is %ld.  I start with %@\n", types,__PRETTY_FUNCTION__, [self.last propertiesPlease], self.count, self[0] ); }
//	return try ?: @"";// AZNULL;
}

+ (void) load  {

//	[$ swizzleMethod:@selector(description) with:@selector(swizzleDescription) in:self.class];
//	[$ swizzleMethod:@selector(objectAtIndexedSubscript:) with:@selector(swizzledObjectAtIndexedSubscript:) in:self.class];

/*
        Method original, swizzle;

        // Get the "- (id)initWithFrame:" method.
        original = class_getInstanceMethod(self, @selector(objectat:));
        // Get the "- (id)swizzled_initWithFrame:" method.
        swizzle = class_getInstanceMethod(self, @selector(swizzledObjectAtIndexedSubscript:));
        // Swap their implementations.
   //	method_exchangeImplementations(original, swizzle);

   //	[self exchangeInstanceMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(swizzledObjectAtIndexedSubscript:)];
   //	[$ swizzleMethod:@selector(objectAtIndexedSubscript:) with:@selector(swizzledObjectAtIndexedSubscript:) in:NSA.class];
   }
   - (id)swizzledObjectAtIndexedSubscript:(NSUI)index
   {
   //	id anObj = [self swizzledObjectAtIndexedSubscript:index];
   //	if (!anObj)

        id anObj = [self objectAtIndexedSubscript:index];
   //	if (!anObj) anObj = [self normal:index];
        if (anObj)	NSLog(@"swizzle objAtSubscript.. found %@", anObj);
        return anObj ?: nil;
*/
}


- (int)createArgv:(char ***)argv {
    char **av;
    int i, ac = 0, actotal;

    if (self == nil || [ self count ] == 0) {
        *argv = NULL;
        return(0);
    }

    actotal = [ self count ];

    if ((av = (char **)malloc(sizeof(char *) * actotal)) == NULL) {
        NSLog(@"malloc: %s", strerror(errno));
        exit(2);
    }

    for (i = 0; i < [ self count ]; i++) {
        av[ i ] = (char *)[[ self objectAtIndex:i ] UTF8String ];
        ac++;

        if (ac >= actotal) {
            if ((av = (char **)realloc(av, sizeof(char *) * (actotal + 10))) == NULL) {
                NSLog(@"realloc: %s", strerror(errno));
                exit(2);
            }
            actotal += 10;
        }
    }
    if (ac >= actotal) {
        if ((av = (char **)realloc(av, sizeof(char *) * (actotal + 10))) == NULL) {
            NSLog(@"realloc: %s", strerror(errno));
            exit(2);
        }
        actotal += 10;
    }
    av[ i ] = NULL;
    *argv = av;
    return(ac);
}

+ (NSA*) from:(NSI)from to:(NSI)to;
{
    return [self.class arrayFrom:from To:to];
}


- (id)nextObject;
{
	NSNumber *n = [self associatedValueForKey:@"AZNextObjectInternalIndex" orSetTo:@(0) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];	
	NSUI indie = n.unsignedIntegerValue;
	if (indie < self.count) {
		[self setAssociatedValue:n.increment forKey:@"AZNextObjectInternalIndex" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	 	return [self normal:indie];
	}
	return  nil;
//	static NSS *intIDX = nil;  intIDX = intIDX ? : @"internalIndexNextObject";
//    NSUI intIndex = [self hasAssociatedValueForKey:intIDX] ? [[self associatedValueForKey:intIDX]unsignedIntegerValue] : 0;
//    [self setAssociatedValue:@(intIndex + 1) forKey:intIDX policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
//    return [self normal:intIndex];
}


- (NSCountedSet *)countedSet {
    return [[NSCountedSet alloc] initWithArray:self];
}

+ (NSA*)arrayWithRange:(NSRange)range {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:range.length];
    NSI i;
    for (i = range.location; i < (range.location + range.length); i++) {
        [array addObject:[NSNumber numberWithInteger:i]];
    }

    NSArray *answer = [[array copy] autorelease];
    [array release];

    return answer;
}

@dynamic trimmedStrings;

- (NSA*) withMinItems:(NSUI)items usingFiller:(id)fill {


	 if (self.count >= items) return self;
    NSMA *upgrade = [NSMA arrayWithArray:self];

    for (int i = self.count; i < items; i++) {

		  	id filler = fill == self ? [[self normal:i]copy] : [fill copy];
			if (!filler) return;
			else [upgrade addObject:filler];
    }
//    NSLog(@"grew array from %ld to %ld", self.count, upgrade.count);
    return upgrade;
}

- (NSA*) withMin:(NSUI)min max:(NSUI)max{  return [[self withMinItems:min ] withMaxItems:max]; }


- (NSA*) withMinItems:(NSUI)items;
{
    return [self withMinItems:items usingFiller:self];
}


- (NSA*) withMinRandomItems:(NSUI)items {
    return [self.shuffeled withMinItems:items];
}

- (NSA*) withMaxRandomItems:(NSUI)items;
{
    return self.count <= items ? self : [self.shuffeled subarrayToIndex:items];
}


- (NSA*) withMaxItems:(NSUI)items;
{
    return self.count <= items ? self : [self subarrayToIndex:items];
}

- (void)setStringsToNilOnbehalfOf:(id)entity;
{
    [self each:^(id obj) { [entity setValue:nil forKey:obj]; }];
}

- (NSN*)maxNumberInArray {	
	
	NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: NO];
	return (NSN*)[self sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]].first;
		//		[self sortedArrayUsingSelector: @selector(compare:)].first;	
}
- (NSN*)minNumberInArray {	
	
	NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
	return (NSN*)[self sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]].first;
//return (NSN*)[self sortedArrayUsingSelector: @selector(compare:)].last;		
}
- (NSA*) URLsForPaths {
    return [self map:^id (id obj) { return [NSURL fileURLWithPath:obj]; }];
}

- (void)logEachPropertiesPlease; {      [self eachWithIndex:^(id obj, NSI idx) {                NSLog(@"%@", [obj propertiesPlease]); }]; }

- (void)logEachProperties {
    [self eachWithIndex:^(NSO* obj, NSI idx) { NSLog(@"%@", [obj properties]); }];
}

- (void)logEach;
{
    [self eachWithIndex:^(id obj, NSI idx) {                NSLog(@"Index %ld: %@", idx, obj);  }];
}

+ (NSA*) arrayFromPlist:(NSS*) path {
    return [NSPropertyListSerialization propertyListFromData:
            [NSData dataWithContentsOfFile:path] mutabilityOption:NSPropertyListImmutable
                                                           format:nil errorDescription:nil];
}

- (void)saveToPlistAtPath:(NSS*) path {
//	[HRCoder archiveRootObject:self toFile:path];
//	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/plutil" arguments:@[@"-convert", @"xml1", path]];
}

- (NSA*) arrayWithEach {
    return [NSArray arrayWithArrays:self];
}

+ (NSA*) arrayWithArrays:(NSA*) arrays {
    return [[[self mutableArrayWithArrays:arrays] copy] autorelease];
}

+ (NSMutableArray *)mutableArrayWithArrays:(NSA*) arrays {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSArray *a in arrays) {
        [array addObjectsFromArray:a];
    }
    return array;
}


- (NSS*) stringWithEnum:(NSUInteger)anEnum; { return self[anEnum];    }

- (NSUInteger)enumFromString:(NSS*) aString default:(NSUInteger)def;
{
    NSUI n = [self indexOfObject:aString];  check(n != NSNotFound); if (n == NSNotFound) n = def; return n;
}

- (NSUInteger)enumFromString:(NSS*) aString;  {       return [self enumFromString:aString default:0]; }

- (NSA*) allKeysInChildDictionaries {

	return [self cw_mapArray:^id(id object) {
		return [object respondsToSelector:@selector(allKeys)] || [object ISKINDA:NSD.class] ? [object allKeys][0] : nil;
	}];

}
- (NSA*) allvaluesInChildDictionaries {

	return [self cw_mapArray:^id(id object) {
		return [object respondsToSelector:@selector(allValues)] || [object ISKINDA:NSD.class] ? [object allValues][0] : nil;
	}];
}


- (NSA*) colorValues {
    return [self arrayUsingBlock:^id (id obj) {
        return [obj colorValue];
    }];
//	[self arrayPerformingSelector:@selector(colorValue)];
}

// array evaluating a selector
- (NSA*)arrayPerformingSelector:(SEL)selector {
	NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
	for (id o in self) {
		id v = [o performSelectorWithoutWarnings:selector];
		if (v) {
			[re addObject:v];
		}
	}
	return re;
}

- (NSA*)arrayPerformingSelector:(SEL)selector withObject:(id)object {
	NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
	for (id o in self) {
		id v = [o performSelectorWithoutWarnings:selector withObject:object];
		if (v) {			[re addObject:v];		}
	}
	return re;
}

- (NSA*) arrayUsingIndexedBlock:(id (^)(id obj, NSUI idx))block {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id obj, NSUI idx, BOOL *stop) {
        [result addObject:block(obj, idx)];
    }];
    return result;
}

// NSArray *sortedArray = [theArray sortedWithKey:@"theKey" ascending:YES];
- (NSA*) sortedWithKey:(NSS*) theKey ascending:(BOOL)ascending {
    return [self sortedArrayUsingDescriptors:@[[[NSSortDescriptor alloc] initWithKey:theKey ascending:ascending]]];
}

static NSI comparatorForSortingUsingArray(id object1, id object2, void *context) {
    // Use NSArray's -indexOfObject:anObject rather than its "identical" form,
    // -indexOfObjectIdenticalTo:anObject. Note that converting object to index
    // answers an unsigned integer. A value of NSNotFound indicates, well, not
    // found! And, since this value equals -1 and therefore the maximum possible
    // unsigned integer, objects not found come last in the sorting order. Also
    // note, if the two objects have the same index, their values are compared
    // as normal.
    NSUI index1 = [(__bridge NSArray *)context indexOfObject : object1];
    NSUI index2 = [(__bridge NSArray *)context indexOfObject : object2];
    if (index1 < index2) return NSOrderedAscending;
    // else
    if (index1 > index2) return NSOrderedDescending;
    // else
    return [object1 compare:object2];
}

//- (NSA*)sortedArrayUsingArray:(NSA*)otherArray
//{	NSArray *array = [
//	return [self sortedArrayUsingFunction:comparatorForSortingUsingArray context:otherArray];
//}

// an array of NSNumbers with Integer values, NSNotFound is the terminator
+ (NSA*) arrayWithInts:(NSInteger)i, ...{
    NSMutableArray *re = NSMutableArray.array;

    [re addObject:[NSNumber numberWithInt:i]];

    va_list args;
    va_start(args, i);
    NSI v;
    while ((v = va_arg(args, NSInteger)) != NSNotFound)
        [re addObject:[NSNumber numberWithInt:v]];
    va_end(args);

    return re;
}

// an array of NSNUmbers with double values, MAXFLOAT is the terminator
+ (NSA*) arrayWithDoubles:(double)f, ...{
    NSMutableArray *re = NSMutableArray.array;

    [re addObject:@(f)];

    va_list args;
    va_start(args, f);
    double v;
    while ((v = va_arg(args, double)) != MAXFLOAT)
        [re addObject:@(v)];
    va_end(args);

    return re;
}
// NSArray instance methods
// set-version of this array
- (NSSet *)set {
    return [NSSet setWithArray:self];
}

- (NSA*) shifted {
    NSMutableArray *re = [self mutableCopy];
    [re removeFirstObject];
    return re;
}

- (NSA*) popped {
    NSMutableArray *re = [self mutableCopy];
    [re removeLastObject];
    return re;
}

- (NSA*) reversed {
    return [[self mutableCopy] az_reverse];
}

- (NSA*)arrayWithObjectsMatchingKeyOrKeyPath:(NSS*)keyPath;
{
	return [self cw_mapArray:^id(id object) {
		id x = [object valueForKeyOrKeyPath:keyPath];  return x?:nil;
	}];

}
// array evaluating the keyPath
- (NSA*) arrayWithKey:(NSS*) keyPath {
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
    for (id o in self) {
        id v = [o valueForKeyPath:keyPath];
        if (v) {
            [re addObject:v];
        }
    }
    return re;
}

/**	Additions.	*/
//@implementation NSArray (TTCategory)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector {
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator *e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelectorWithoutWarnings:selector withObject:nil];
        }
    }
    [copy release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 {
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator *e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelectorWithoutWarnings:selector withObject:p1];
        }
    }
    [copy release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator *e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [delegate performSelector:selector withObject:p1 withObject:p2];
#pragma clang diagnostic pop
        }
    }
    [copy release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
    NSArray *copy = [[NSArray alloc] initWithArray:self];
    NSEnumerator *e = [copy objectEnumerator];
    for (id delegate; (delegate = [e nextObject]); ) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
        }
    }
    [copy release];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
    for (id delegate in self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [delegate performSelector:selector withObject:p1 withObject:p2];
#pragma clang diagnostic pop
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)makeObjectsPerformSelector:(SEL)selector
                        withObject:(id)p1
                        withObject:(id)p2
                        withObject:(id)p3 {
    for (id delegate in self) {
        [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
    }
}

- (id) objectsWithValue:(id)value forKey:(id)key	{

	NSMA *subsample = NSMA.new;
   for (id object in self) {
        id propertyValue = [object valueForKey:key];
        if ([propertyValue isEqual:value])   [subsample addObject:object];
    }
    return subsample.count ? subsample : nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithValue:(id)value forKey:(id)key {
    for (id object in self) {
        id propertyValue = [object valueForKey:key];
        if ([propertyValue isEqual:value]) {
            return object;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)objectWithClass:(Class)cls {
    for (id object in self) {
        if ([object isKindOfClass:cls]) {
            return object;
        }
    }
    return nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)containsObject:(id)object withSelector:(SEL)selector {
    for (id item in self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([[item performSelector:selector withObject:object] boolValue]) {
#pragma clang diagnostic pop
            return YES;
        }
    }
    return NO;
}

- (NSA*) arrayUsingBlock:(id (^)(id obj))block {
    return [self map:block];
}

- (NSA*) map:(id (^)(id obj))block {
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
    for (id o in self) {
        id v = block(o);
        if (v) [re addObject:v];
    }
    return re;
}

- (NSA*) nmap:(id (^)(id obj, NSUI index))block {
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:self.count];
    for (int i = 0; i < self.count; i++) {
        id v, o = self[i];
        if ((v = block(o, i))) [re addObject:v];
    }
    return re;
}

- (id)reduce:(id (^)(id a, id b))block {
    if (!self.count) return nil;
    id re = self.first;
    for (int i = 1; i < self.count; i++) {
        re = block(re, self[i]);
    }
    return re;
}

- (NSA*) arrayWithoutObject:(id)object {
    return [self arrayWithoutSet:NSSET(object)];
}

- (NSA*) arrayWithoutObjects:(id)object, ...
{
    NSSet *s = NSSet.set;
    va_list args;
    va_start(args, object);
    id o = nil;
    while ((o = va_arg(args, id)) != nil) s = [s setByAddingObject:o];
    va_end(args);
    NSA *re = [self arrayWithoutSet:s];
    return re;
}

- (NSA*) arrayWithoutArray:(NSA*) value {
    return [self arrayWithoutSet:value.set];
}

- (NSA*) arrayWithoutSet:(NSSet *)values {
    NSArray *re = NSArray.array;
    for (id o in self) {
        if (![values containsObject:o]) re = [re arrayByAddingObject:o];
    }
    return re;
}

- (NSA*) subIndex:(NSUI)subIndex filter:(BOOL (^)(id object))block {
    return [self[subIndex] filter:block];
}

- (id)subIndex:(NSUI)subIndex filterOne:(BOOL (^)(id object))block {
    return [self[subIndex] filterOne:block];
}

- (id)subIndex:(NSUI)subIndex blockReturnsIndex:(MapArrayBlock)block {
    id theIndex = [self subIndex:subIndex block:block];
    return self[[self indexOfObject:theIndex]];
}

- (id)subIndex:(NSUI)subIndex block:(MapArrayBlock)block;
{
    return block(self[subIndex]);
}

- (NSUI)indexOfFirstObjectPassing:(BOOL(^)(id obj))block {
	__block NSUI index = NSNotFound;
	[self enumerateObjectsUsingBlock:^(id test, NSUInteger idx, BOOL *stop) {
		if (block(test)) {
			index = [self indexOfObject:test];
			*stop = YES;	
		}
	}];
	return index;
}


- (NSA*) filter:(BOOL (^)(id object))blk {
    return [self filteredArrayUsingBlock:^(id o, NSD *d) { return (BOOL)blk(o); }];
}

- (id)filterOne:(BOOL (^)(id))block {
	BOOL yeah = NO;
   for (id anO in self) { yeah = block(anO); if (yeah == YES) return anO; }
	return nil;
}

- (BOOL)allKindOfClass:(Class)aClass {
    for (id o in self) {
        if (![o isKindOfClass:aClass]) return NO;
    }
    return YES;
}

- (NSA*) elementsOfClass:(Class)aClass {
    return [self cw_mapArray:^id (id o) { return [o isKindOfClass:aClass] ? o : nil; }];
}

- (NSA*) numbers {
    return [self elementsOfClass:NSNumber.class];
}

- (NSA*) strings {
    return [self elementsOfClass:NSString.class];
}

//- (NSA*)trimmedStrings {
//	NSMutableArray *re = NSMutableArray.array;
//
//	for (id o in self) {
//		if ([o isKindOfClass:NSString.class]) {
//			NSS*s = [o trim];
//			if (!s.isEmpty) {
//				[re addObject:s];
//			}
//		}
//	}
//
//	return re;
//}
// accessing
- (id)objectAtIndex:(NSUI)index fallback:(id)fallback {
    if (self.count <= index) return fallback;
    @try                                    { id re = self[index];  return !re ? fallback : re; } @catch (NSException *e) {
        return fallback;
    }
}

- (id)objectOrNilAtIndex:(NSUI)index {
    return self.count <= index ? nil : self[index];
}

- (id)first    {
    return [self objectOrNilAtIndex:0];
}

- (id)second   {
    return [self objectOrNilAtIndex:1];
}

- (id)thrid    {
    return [self objectOrNilAtIndex:2];
}

- (id)fourth   {
    return [self objectOrNilAtIndex:3];
}

- (id)fifth    {
    return [self objectOrNilAtIndex:4];
}

- (id)sixth    {
    return [self objectOrNilAtIndex:5];
}

- (NSA*) subarrayFromIndex:(NSI)start {
    return [self subarrayFromIndex:start toIndex:(self.count - 1)];
}

- (NSA*) subarrayToIndex:(NSI)end         {
    return [self subarrayFromIndex:0 toIndex:end];
}

- (NSA*) subarrayFromIndex:(NSInteger)start toIndex:(NSInteger)end {
    NSI from = start;
    while (from < 0) from += self.count;
    if (from > self.count) return nil;

    NSI to = end;
    while (to < 0) to += self.count;
    if (from >= to) {
        // this behaviour is somewhat different it will return anything from this array except the passed range
        NSA *re = @[];
        if (from > 0) re = [self subarrayWithRange:(NSRNG) {0, from - 1 }];
        if (to < self.count) {
            if (re != nil) re = [re arrayByAddingObjectsFromArray:[self subarrayWithRange:(NSRNG) {to - 1, self.count - 1 }]];
        }
        return re;
    }
    return [self subarrayWithRange:(NSRNG) {from, to }];
}

- (id) randomElement {    return !self.count ? nil : [self normal:(arc4random() % self.count)];	}

- (NSA*) shuffeled {
    return self.count < 2 ? self : ((NSMA *)self.mutableCopy).shuffle;
}

- (NSA*) randomSubarrayWithSize:(NSUInteger)size {
    if (self.count == 0) {
        return @[];
    }

    NSUI capacity = MIN(size, self.count);
    NSMutableArray *re = [NSMutableArray arrayWithCapacity:capacity];

    while (re.count < capacity) {
        NSUI index = random() % (self.count - re.count);
        id e = self[index];
        while ([re containsObject:e])
            e = self[++index];
        [re addObject:e];
    }

    return re;
}

- (id)objectAtNormalizedIndex:(NSInteger)index {
    return [self normal:index];
}

- (id)normal:(NSInteger)index {
    if (self.count == 0) {
        return nil;
    }

    while (index < 0)
        index += self.count;

    return self[index % self.count];
}

- (NSInteger)sumIntWithKey:(NSS*) keyPath {
    NSI re = 0;
    for (id v in self) {
        id k = v;
        if (keyPath != nil) {
            k = [v valueForKeyPath:keyPath];
        }
        if ([k isKindOfClass:NSNumber.class]) {
            re += [k intValue];
        }
    }

    return re;
}

- (CGF)sumFloatWithKey:(NSS*) keyPath {
    CGF re = 0;
    for (id v in self) {
        id k = v;
        if (keyPath != nil) {
            k = [v valueForKeyPath:keyPath];
        }
        if ([k isKindOfClass:NSNumber.class]) {
            re += [k floatValue];
        }
    }

    return re;
}

- (BOOL)containsAny:(id <NSFastEnumeration>)enumerable {
    for (id o in enumerable) {
        if ([self containsObject:o]) {
            return YES;
        }
    }

    return NO;
}

- (BOOL)containsAll:(id <NSFastEnumeration>)enumerable {
    for (id o in enumerable) {
        if (![self containsObject:o]) {
            return NO;
        }
    }

    return YES;
}

- (BOOL)doesNotContainObjects:(id<NSFastEnumeration>)enumerable {
    for (id x in enumerable) {
        if ([self containsObject:x]) return NO;  // exists, abort!
    }
    return YES;  // it ain't in there, return TRUE;
}

- (BOOL)doesNotContainObject:(id)object {
    if ([self containsObject:object]) return NO; return YES;
}

// will always return nil
- (id)andExecuteEnumeratorBlock {
    return nil;
}

- (void)setAndExecuteEnumeratorBlock:(void (^)(id obj, NSUI idx, BOOL *stop))block {
    [self enumerateObjectsUsingBlock:block];
}

- (NSA*) objectsWithFormat:(NSS*) format, ...{
    va_list args;
    va_start(args, format);
    NSPredicate *p = [NSPredicate predicateWithFormat:format arguments:args];
    va_end(args);

    return [self filteredArrayUsingPredicate:p];
}

- (id)firstObjectWithFormat:(NSS*) format, ...{
    va_list args;
    va_start(args, format);
    NSPredicate *p = [NSPredicate predicateWithFormat:format arguments:args];
    va_end(args);

    NSArray *lookup = [self filteredArrayUsingPredicate:p];

    if (lookup.count) {
        return lookup.first;
    }

    return nil;
}

- (NSA*) filteredArrayUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block {
    NSPredicate *p = [NSPredicate predicateWithBlock:block];
    return [self filteredArrayUsingPredicate:p];
}

- (NSA*) uniqueObjects {
    NSSet *set = [[NSSet alloc] initWithArray:self];
    NSArray *vals = [set allObjects];
    return vals;
}

- (NSA*) uniqueObjectsSortedUsingSelector:(SEL)comparator {
    NSSet *set =
        [[NSSet alloc] initWithArray:self];
    NSArray *vals =
        [[set allObjects] sortedArrayUsingSelector:comparator];
    return vals;
}

/**	Convenience Method to return the first object in
 * a NSArray	*/
- (id)firstObject  {
    return self.count > 0 ? self[0] : nil;
}

- (id)last             {
    return self.lastObject;
}                                                         //return self.count > 0 ? self[self.count - 1] : nil;	}
- (NSN*) sum {  /*	!! @YES = 1, @NO = 0  !! */
	NSN* add = nil;
	for (NSN* n in self) {
		if (!add) add = n;
		else add = [add plus:n];
	}
	return add;
}
/**
   Iterates over all the objects in an array and calls the block on each object

   This iterates over all the objects in an array calling the block on each object
   until it reaches the end of the array or until the BOOL *stop pointer is set to YES.
   This method was inspired by Ruby's each method and works very similarly to it, while
   at the same time staying close to existing ObjC standards for block arguments which
   is why it passes a BOOL *stop pointer allowing you to signal for enumeration to end.

   Important! If block is nil then this method will throw an exception.

   @param obj (Block Parameter) this is the object in the array currently being enumerated over
   @param index (Block Parameter) this is the index of obj in the array
   @param stop (Block Parameter) set this to YES to stop enumeration, otherwise there is no need to use this	*/
- (void)az_each:(void (^)(id obj, NSUI index, BOOL *stop))block {
    [self enumerateObjectsUsingBlock:block];
}

- (void)eachDictionaryKeyAndObjectUsingBlock:(void (^)(id key, id obj))block;
{
    [self each:^(NSD *dict) {
        [dict enumerateEachKeyAndObjectUsingBlock:^(id key, id obj) {
                block(key, obj);
            }];
    }];
}


/**
   Enumerates over the receiving arrays objects concurrently in a synchronous method.

   Enumerates over all the objects in the receiving array concurrently. That is it will
   go over each object and execute a block passing that object in the array as a parameter
   in the block. This methods asynchronously executes a block for all objects in the array
   but waits for all blocks to finish executing before going on.

   @param index (Block Parameter) the position of the object in the array
   @param obj (Block Parameter) the object being enumerated over
   @param stop (Block Parameter) if you need to stop the enumeration set this to YES otherwise do nothing	*/
- (void)az_eachConcurrentlyWithBlock:(void (^)(NSI index, id obj, BOOL *stop))block {
    //make sure we get a unique queue identifier
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create([[NSString stringWithFormat:@"%@%@", @"com.AGFoundation.NSArray_", [NSString newUniqueIdentifier]] UTF8String], DISPATCH_QUEUE_CONCURRENT);
    __block BOOL _stop = NO;
    NSI idx = 0;
    for (id object in self) {
        if (_stop) {
            break;
        }
        dispatch_group_async(group, queue, ^{  block(idx, object, &_stop);      });
        idx++;
    }

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    dispatch_release(group);
    dispatch_release(queue);
}

/**	Finds the first instance of the object that you indicate
 * via a block (returning a bool) you are looking for	*/
- (id)findWithBlock:(BOOL (^)(id obj))block {
    __block id foundObject = nil;
    [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id object, NSUI idx, BOOL *stop) {
        if (block(object)) {
            foundObject = object;
            *stop = YES;
        }
    }];
    return foundObject;
}

/**	Exactly like findWithBlock except it returns a BOOL	*/
- (BOOL)isObjectInArrayWithBlock:(BOOL (^)(id obj))block {
    return ([self findWithBlock:block]) ? YES : NO;
}

/**	Like find but instead of returning the first object
 * that passes the test it returns all objects passing the
 * bool block test	*/
- (NSA*) findAllWithBlock:(BOOL (^)(id obj))block {
    NSMA *results = NSMA.new;
    [self az_each:^(id obj, NSUI index, BOOL *stop) {
        if (block(obj)) {
            [results addObject:obj];
        }
    }];
    return results;
}

#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

/**	experimental method
 * like find but instead uses NSHashTable to store weak pointers to
 * all objects passing the test of the bool block
 *
 * I don't particularly like this name but given objc's naming
 * structure this is as good as I can do for now	*/
- (NSHashTable *)findAllIntoWeakRefsWithBlock:(BOOL (^)(id))block {
    NSHashTable *results = [NSHashTable hashTableWithWeakObjects];
    [self az_each:^(id obj, NSUI index, BOOL *stop) {
        if (block(obj)) [results addObject:obj];
    }];
    return results;
}

#endif

/**	mapArray basically maps an array by enumerating
 * over the array to be mapped and executes the block while
 * passing in the object to map. You simply need to either
 * (1) return the object to be mapped in the new array or
 * (2) return nil if you don't want to map the passed in object
 *
 * @param block a block in which you return an object to be mapped to a new array or nil to not map it
 * @return a new mapped array	*/
- (NSA*) mapArray:(id (^)(id obj))block {
    NSMA *cwArray = NSMA.new;
    [self az_each:^(id obj, NSUI index, BOOL *stop) {
        id rObj = block(obj);
        if (rObj) [cwArray addObject:rObj];
    }];
    return cwArray;
}

@end

@implementation NSArray (ListComprehensions) // Create a new array with a block applied to each index to create a new element
+ (NSA*) arrayWithBlock:(id (^)(int index))block range:(NSRNG)range {
    id array = NSMA.new; for (int i = range.location; i < range.location + range.length; i++) {
        [array addObject:block(i)];
    }
    return array;
}                                                                                                                                                                                                        // The same with a condition

+ (NSA*) arrayWithBlock:(id (^)(int index))block range:(NSRNG)range if:(BOOL (^)(int index))blockTest {
    id array = NSMA.new; for (int i = range.location; i < range.location + range.length; i++) {
        if (blockTest(i)) [array addObject:block(i)];
    }
    return array;
}

- (NSR)rectAtIndex:(NSUI)index {
    return nanRectCheck([[self normal:index]rectValue]);
}

@end


@implementation NSArray (WeakReferences)
- (NSMA *)weakReferences {
    NSMA *u = [NSMA new];
    [self each:^(id obj) { [ u addObject:[NSValue valueWithNonretainedObject:obj]]; }];
    return u;
}

@end
//  Found through:
//      http://stackoverflow.com/questions/4692161/non-retaining-array-for-delegates
//  Created by Tod Cunningham on 8/31/12.  www.fivelakesstudio.com
@implementation NSMutableArray (WeakReferences)
+ (id)mutableArrayUsingWeakReferences	{	return [self mutableArrayUsingWeakReferencesWithCapacity:0];	}
+ (id)mutableArrayUsingWeakReferencesWithCapacity:(NSUInteger)capacity	{
	// The two NULLs are for the CFArrayRetainCallBack and CFArrayReleaseCallBack methods.  Since they are
	// NULL no retain or releases sill be done.
	CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
	// We create a weak reference array
	return (__bridge id)(CFArrayCreateMutable(0, capacity, &callbacks));
}
@end

@implementation NSMutableArray (AG)

- (void)swizzleInsertObject:(id) o atIndex:(NSUInteger)idx {
	[self swizzleInsertObject:o atIndex:idx];
	[AZNOTCENTER postNotificationName:NSMutableArrayDidInsertObjectNotification object:self userInfo:nil];
}
- (void)swizzleAddObject:(id) o {
	[self swizzleAddObject:o];
	[AZNOTCENTER postNotificationName:NSMutableArrayDidInsertObjectNotification object:self userInfo:nil];
}
- (void)swizzleAddObjectsFromArray:(NSA*)a {
	[self swizzleAddObjectsFromArray:a];
	[AZNOTCENTER postNotificationName:NSMutableArrayDidInsertObjectNotification object:self userInfo:nil];
}
+ (void) load  {
	[$ swizzleMethod:@selector(insertObject:atIndex:) with:@selector(swizzleInsertObject:atIndex:) in:self.class];
	[$ swizzleMethod:@selector(addObject:) with:@selector(swizzleAddObject:) in:self.class];
	[$ swizzleMethod:@selector(addObjectsFromArray:) with:@selector(swizzleAddObjectsFromArray:) in:self.class];
}

- (void)addPoint:(NSPoint)point {
    [self addObject:AZVpoint(point)];
}

- (void)addRect:(NSRect)rect {
    [self addObject:AZVrect(rect)];
}


- (id) advance {
	id first = self.firstObject;
	[self firstToLast];
	return first;
}

- (id)last {
    return self.lastObject;
}

- (void)setLast:(id)anObject {
    if (anObject) {
        [self willChangeValueForKey:@"last"];
        [self addObject:anObject];
        [self didChangeValueForKey:@"last"];
    }
}

- (id)first {
    return [super first];
}

- (void)firstToLast {
    if (self.count == 0) return;      //there is no object to move, return
    int toIndex = self.count - 1;     //toIndex too large, assume a move to end
    [self moveObjectAtIndex:0 toIndex:toIndex];
}

- (void)lastToFirst {
    if (self.count == 0) return;      //there is no object to move, return
    [self moveObjectAtIndex:self.count - 1 toIndex:0];
}

- (void)setFirst:(id)anObject {
    if (anObject == nil) return;
    [self willChangeValueForKey:@"first"];
    [self insertObject:anObject atIndex:0];
    [self didChangeValueForKey:@"first"];
}

- (void)removeFirstObject {
    [self shift];
}

- (id)shift {
    if (self.count == 0) return nil;
    id re = self.first;
    [self removeObjectAtIndex:0];
    return re;
}

- (id)pop {
    if (self.count == 0) return nil;
    id o = self.lastObject;
    [self removeLastObject];
    return o;
}

- (void)shove:(id)object {
    [self insertObject:object atIndex:0];
}

- (id)peek {
    return self.lastObject;
}

- (void)push:(id)obj  {
    [self addObject:obj];
}

- (NSMA *)sort {
    [self sortUsingSelector:@selector(compare:)];
    return self;
}

- (NSMA *)az_reverse {
    @synchronized(self) {
        for (NSUI i = 0; i < floor(self.count / 2); i++) {
            [self exchangeObjectAtIndex:i withObjectAtIndex:(self.count - i - 1)];
        }
    }
    return self;
}

- (NSMA *)shuffle {
    @synchronized(self) {
        for (NSUI i = 0; i < self.count; i++) {
            NSUI one = random() % self.count;
            NSUI two = random() % self.count;
            [self exchangeObjectAtIndex:one withObjectAtIndex:two];
        }
    }
    return self;
}

- (void)moveObjectAtIndex:(NSUI)fromIndex toIndex:(NSUI)toIndex {
    if (fromIndex == toIndex || fromIndex >= self.count) return;  //there is no object to move, return
    if (toIndex >= self.count) toIndex = self.count - 1;          //toIndex too large, assume a move to end
    id movingObject = self[fromIndex];

    if (fromIndex < toIndex) {
        for (int i = fromIndex; i <= toIndex; i++) {
            self[i] = (i == toIndex) ? movingObject : self[i + 1];
        }
    } else {
        id cObject;
        id prevObject;
        for (int i = toIndex; i <= fromIndex; i++) {
            cObject = self[i];
            self[i] = (i == toIndex) ? movingObject : prevObject;
            prevObject = cObject;
        }
    }
}

//Also, a small bonus to further increase functionality, if you're performing operations on the items moved (like updating a db or something), the following code has been very useful to me:

- (void)moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex withBlock:(void (^)(id, NSUInteger))block {
    if (fromIndex == toIndex) return;
    if (fromIndex >= self.count) return;                  //there is no object to move, return
    if (toIndex >= self.count) toIndex = self.count - 1;  //toIndex too large, assume a move to end
    id movingObject = self[fromIndex];
    id replacementObject;

    if (fromIndex < toIndex) {
        for (int i = fromIndex; i <= toIndex; i++) {
            replacementObject = (i == toIndex) ? movingObject : self[i + 1];
            self[i] = replacementObject;
            if (block) block(replacementObject, i);
        }
    } else {
        id cObject;
        id prevObject;
        for (int i = toIndex; i <= fromIndex; i++) {
            cObject = self[i];
            replacementObject = (i == toIndex) ? movingObject : prevObject;
            self[i] = replacementObject;
            prevObject = cObject;
            if (block) block(replacementObject, i);
        }
    }
}

@end




@implementation NSArray (Stringing)

- (NSS*) listValuesOnePerLineForKeyPath:(NSS*) keyPath bullet:(NSS*) bullet {
    NSI nItems = self.count;
    if (!keyPath) keyPath = @"description";
    if (!bullet) bullet = @"";
    NSMS *string = NSMS.new;
    NSI i;
    for (i = 0; i < nItems; i++) {
        NSS *value = [self[i] valueForKeyPath:keyPath];
        if (value) {
            if ((i > 0)) [string appendString:@"\n"];
            [string appendFormat:@"%@%@", bullet, value];
        }
    }
    NSS *output = string.copy;
    [string release];
    return [output autorelease];
}

- (NSS*) listValuesOnePerLineForKeyPath:(NSS*) keyPath {
    return [self listValuesOnePerLineForKeyPath:keyPath bullet:nil];
}

- (NSS*) listValuesForKey:(NSS*) key conjunction:(NSS*) conjunction truncateTo:(NSI)truncateTo {
    NSA *array;
    BOOL ellipsize = NO;
    if ((truncateTo > 0) && (truncateTo < [self count])) {
        array = [self subarrayWithRange:NSMakeRange(0, truncateTo)];
        ellipsize = YES;
    } else array = self;

    NSI nItems       = array.count;
    NSMS *string = NSMS.new;
    NSI i;
    for (i = 0; i < nItems; i++) {
        id object       = array[i];
        NSS *value  = [object respondsToSelector:NSSelectorFromString(key)]
            ? [object valueForKey:key]
            : [object description];
        if (![value isKindOfClass:NSS.class] || value.length == 0) continue;

        if ((i == (nItems - 1)) && (nItems > 1) && conjunction) {
            [string appendString:@" "];
            if (conjunction) [string appendString:conjunction];
            [string appendString:@" "];
        } else if ((i > 0)) [string appendString:@", "];
        [string appendString:value];
    }

    if (ellipsize) [string appendFormat:@", %C", (unsigned short)0x2026];
    NSS *output = string.copy;
    [string release];
    return [output autorelease];
}

- (NSS*) listNames {
    return [self listValuesForKey:@"name" conjunction:nil truncateTo:0];
}
@end



@implementation NSArray (UKColor)
//	arrayWithColor:
//		Converts the color to an RGB color if needed, and then creates an array
//		with its red, green, blue and alpha components (in that order).
//
//  REVISIONS:
//		2004-05-18  witness documented.
+ (NSA*)arrayWithColor:(NSColor *)col          {
    CGFloat fRed = 0, fGreen = 0, fBlue = 0, fAlpha = 1.0;

    col = [col colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    [col getRed:&fRed green:&fGreen blue:&fBlue alpha:&fAlpha];

    return [self arrayWithObjects:[NSNumber numberWithFloat:fRed], [NSNumber numberWithFloat:fGreen],
            [NSNumber numberWithFloat:fBlue], [NSNumber numberWithFloat:fAlpha], nil];
}

//	colorValue:
//		Converts an NSArray with three (or four) NSValues into an RGB Color
//		(plus alpha, if specified).
//
//  REVISIONS:
//		2004-05-18  witness documented.
- (NSColor *)colorValue              {
    float fRed = 0, fGreen = 0, fBlue = 0, fAlpha = 1.0;

    if ([self count] >= 3) {
        fRed = [self[0] floatValue];
        fGreen = [self[1] floatValue];
        fBlue = [self[2] floatValue];
    }
    if ([self count] > 3)       // Have alpha info?
        fAlpha = [self[3] floatValue];

    return [NSColor colorWithCalibratedRed:fRed green:fGreen blue:fBlue alpha:fAlpha];
}

@end

//#import "ArrayUtilities.h"
#import "NSObject-Utilities.h"
#import <time.h>
#import <stdarg.h>

/*
   Thanks to August Joki, Emanuele Vulcano, BlueLlama, Optimo, jtbandes

   To add Math Extensions like sum, product?
 */

#pragma mark StringExtensions
@implementation NSArray (StringExtensions)
- (NSA*)arrayBySortingStrings {
    NSMutableArray *sort = [NSMutableArray arrayWithArray:self];
    for (id eachitem in self) {
        if (![eachitem isKindOfClass:[NSString class]]) [sort removeObject:eachitem];
    }
    return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSS*)stringValue {
    return [self componentsJoinedByString:@" "];
}

@end

#pragma mark UtilityExtensions
@implementation NSArray (UtilityExtensions)
- (id)firstObject {
    return [self objectAtIndex:0];
}

- (NSA*)uniqueMembers {
    NSMutableArray *copy = [self mutableCopy];
    for (id object in self) {
        [copy removeObjectIdenticalTo:object];
        [copy addObject:object];
    }
    return [copy autorelease];
}

- (NSA*)unionWithArray:(NSA*)anArray {
    if (!anArray) return self;
    return [[self arrayByAddingObjectsFromArray:anArray] uniqueMembers];
}

- (NSA*)intersectionWithArray:(NSA*)anArray {
    NSMutableArray *copy = [[self mutableCopy] autorelease];
    for (id object in self) {
        if (![anArray containsObject:object]) [copy removeObjectIdenticalTo:object];
    }
    return [copy uniqueMembers];
}

// A la LISP, will return an array populated with values
- (NSA*)map:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
    NSMutableArray *results = [NSMutableArray array];
    for (id eachitem in self) {
        if (![eachitem respondsToSelector:selector]) {
            [results addObject:[NSNull null]];
            continue;
        }

        id riz = [eachitem objectByPerformingSelector:selector withObject:object1 withObject:object2];
        if (riz) [results addObject:riz];
        else [results addObject:[NSNull null]];
    }
    return results;
}

- (NSA*)map:(SEL)selector withObject:(id)object1 {
    return [self map:selector withObject:object1 withObject:nil];
}

- (NSA*)map:(SEL)selector {
    return [self map:selector withObject:nil];
}

// NOTE: Selector must return BOOL
- (NSA*)collect:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
    NSMutableArray *riz = [NSMutableArray array];
    for (id eachitem in self) {
        BOOL yorn;
        NSValue *eachriz = [eachitem valueByPerformingSelector:selector withObject:object1 withObject:object2];
        if (strcmp([eachriz objCType], "c") == 0) {
            [eachriz getValue:&yorn];
            if (yorn) [riz addObject:eachitem];
        }
    }
    return riz;
}

- (NSA*)collect:(SEL)selector withObject:(id)object1 {
    return [self collect:selector withObject:object1 withObject:nil];
}

- (NSA*)collect:(SEL)selector {
    return [self collect:selector withObject:nil withObject:nil];
}

// NOTE: Selector must return BOOL
- (NSA*)reject:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
    NSMutableArray *riz = [NSMutableArray array];
    for (id eachitem in self) {
        BOOL yorn;
        NSValue *eachriz = [eachitem valueByPerformingSelector:selector withObject:object1 withObject:object2];
        if (strcmp([eachriz objCType], "c") == 0) {
            [eachriz getValue:&yorn];
            if (!yorn) [riz addObject:eachitem];
        }
    }
    return riz;
}

- (NSA*)reject:(SEL)selector withObject:(id)object1 {
    return [self reject:selector withObject:object1 withObject:nil];
}

- (NSA*)reject:(SEL)selector {
    return [self reject:selector withObject:nil withObject:nil];
}

@end

#pragma mark Mutable UtilityExtensions
@implementation NSMutableArray (UtilityExtensions)
- (NSMutableArray *)reverse {
    for (int i = 0; i < (floor([self count] / 2.0)); i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:([self count] - (i + 1))];
    }
    return self;
}

// Make sure to run srandom([[NSDate date] timeIntervalSince1970]); or similar somewhere in your program
- (NSMutableArray *)scramble {
    for (int i = 0; i < ([self count] - 2); i++) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:(i + (random() % ([self count] - i)))];
    }
    return self;
}

- (NSMutableArray *)removeFirstObject {
    [self removeObjectAtIndex:0];
    return self;
}

@end


#pragma mark StackAndQueueExtensions
@implementation NSMutableArray (StackAndQueueExtensions)
- (id)popObject {
    if ([self count] == 0) return nil;

    id lastObject = self.lastObject;
    [self removeLastObject];
    return lastObject;
}

- (NSMutableArray *)pushObject:(id)object {
    [self addObject:object];
    return self;
}

- (NSMutableArray *)pushObjects:(id)object, ...
{
    if (!object) return self;
    id obj = object;
    va_list objects;
    va_start(objects, object);
    do {
        [self addObject:obj];
        obj = va_arg(objects, id);
    } while (obj);
    va_end(objects);
    return self;
}

- (id)pullObject {
    if ([self count] == 0) return nil;

    id firstObject = self[0];
    [self removeObjectAtIndex:0];
    return firstObject;
}

- (NSMutableArray *)push:(id)object {
    return [self pushObject:object];
}

- (id)pop {
    return [self popObject];
}

- (id)pull {
    return [self pullObject];
}

@end



@implementation NSArray (FilterByProperty)


- (NSA*) subArrayWithMembersOfKind:(Class)class {
	return [self cw_mapArray:^id(id object) {
		return  [object ISKINDA:class] ? object : nil;
	}];
}
- (NSA*) stringsPaddedToLongestMember {

	NSUI ct = [self lengthOfLongestMemberString];										// deduce longest string
	return [self map:^id(id obj) {		return [obj paddedTo:ct];	}];
}
- (NSUI) lengthOfLongestMemberString {

	return [[[self subArrayWithMembersOfKind:NSS.class] sortedWithKey:@"length" ascending:NO][0]length];
}
- (NSArray*) filterByProperty:(NSS*) p
{
    NSMutableArray *finalArray = [NSMutableArray array];
    NSMutableSet *lookup = [[NSMutableSet alloc]init];
    for (id item in self)
    {
        if (![lookup containsObject:[item valueForKey:p]])
        {
            [lookup addObject:[item valueForKey:p]];
            [finalArray addObject:item];
        }
    }
    [lookup release];
    
    return finalArray;
}

@end
