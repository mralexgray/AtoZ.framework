
#import "AtoZ.h"
#import "NSArray+AtoZ.h"


@interface AZSparseArray () @property (nonatomic) NSPointerArray *storage; @end
 
@implementation AZSparseArray

+ (instancetype) arrayWithObjectsAndIndexes:(id) first,... {

//  id sentinel = @1;
//  va_list args;  va_start(args, first);
//  while ((detector = va_arg(args, id)) != nil);
//  NSRect r;
//  (r = va_arg(args, NSRect));
//  [re addObject:AZVrect(r)];
//  va_end(args);
  return nil;

}

- (id) init { return self = super.init ? _storage = NSPointerArray.strongObjectsPointerArray, self: nil; }

#pragma mark - NSArray primitive methods
 
- (NSUInteger)count { return _storage.count; }
- (id)objectAtIndex:(NSUInteger)x { return [_storage pointerAtIndex:x]; }

#pragma mark - NSMutableArray primitive methods
 
- (void)insertObject:(id)o atIndex:(NSUInteger)x {

  if (x >= _storage.count) [_storage setCount:x];
  [_storage insertPointer:(__bridge void *)o atIndex:x];
}
 
- (void)removeObjectAtIndex:(NSUInteger)x {[_storage removePointerAtIndex:x]; }
- (void)addObject:(id)o { [_storage addPointer:(__bridge void *)o]; }
- (void)removeLastObject { [_storage removePointerAtIndex:_storage.count]; }

- (void)replaceObjectAtIndex:(NSUInteger)x withObject:(id)o {

  if (x >= _storage.count) [_storage setCount:x];
  [_storage replacePointerAtIndex:x withPointer:(__bridge void *)o];
}
 
#pragma mark - Subscript Overrides
 
// Avoids NSRangeException thrown in setObject:atIndex: (Private?)
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
  [self replaceObjectAtIndex:idx withObject:obj];
}
// Don't need to override but it's nice to be sure
- (id)objectAtIndexedSubscript:(NSUInteger)idx {
  return [self objectAtIndex:idx];
}
 
@end


//#import "AZLog.h"
NSString * const NSMutableArrayDidInsertObjectNotification = @"com.mrgray.NSMutableArrayDidInsertObjectNotification";
@implementation NSArray (EnumExtensions)
- (NSS*) stringWithEnum:(NSUI)enumVal                   { return self[enumVal]; }
- (NSUI) enumFromString:(NSS*)strVal default:(NSUI)def  {  NSUI n; return ((n = [self indexOfObject:strVal]) == NSNotFound) ? def : n; }
- (NSUI) enumFromString:(NSS*)strVal                    { return [self enumFromString:strVal default:0]; }
@end
@implementation NSArray (NSTableDataSource)
- (id)tableView:(NSTV*)v objectValueForTableColumn:(NSTC*)c row:(NSI)r {
  id obj = self[r]; return !obj ? nil : ![obj ISADICT] ? obj : ((NSD*)obj)[c.identifier];
}
- (NSI)numberOfRowsInTableView:(NSTC*)v {  return self.count; }
@end
@implementation NSArray (AtoZCLI)
- (NSS*) stringValueInColumnsCharWide:(NSUI)characters {
  return [self reduce:^id (id memo, id obj) {
    NSUI min = MAX(characters - [obj length], 0);
    return [memo withString:[obj stringByPaddingToLength:characters withString:@" " startingAtIndex:0]];
  } withInitialMemo:@""];
}
- (NSS*) formatAsListWithPadding:(NSUI)characters	{
	return /*$(@"\n%@",*/  [self.alphabetized map:^id (id obj) {
//		return [obj stringByPaddingToLength:characters withString:@" " startingAtIndex:0]; }].joinedWithSpaces; // );
		return [obj justifyRight:characters]; }].joinedWithSpaces; // );
}
@end
@implementation NSSet (AtoZ)
- (id)filterOne:(BOOL(^)(id))block {   __block id x = nil;
  [self.allObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {  if (block(obj)) x = obj;  if (x != nil) *stop = YES;  }];
  return x;
}
@end
@implementation NSArray (AtoZ)
-    (id) reduce:(id)initial with:(AZIndexedAccumulationBlock)block {	NSParameterAssert(block != nil); __block id result = initial;
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) { result = block(result, obj, idx); }];
	return result;
}
-  (NSA*) alphabetized {
    return [self.mutableCopy alphabetize].copy;
}
+  (NSA*) arrayWithCopies:(NSUI)copies of:(id<NSCopying>)obj {
  NSAssert([(NSO*)obj conformsToProtocol:@protocol(NSCopying)], @"only NSCopying items may pass!");
  return [@(copies) mapTimes:^id(NSN*num) { return [(NSO<NSCopying>*)obj copy]; }];
}
-  (NST*) enumerateWithInterval:(NSTI)time repeat:(BOOL)repeat usingBlock:(AZObjIdxStopBlock)block {
  __block NSUInteger idx = 0;
  __block BOOL stop = NO;
  __block NST *t = [NSTimer scheduledTimerWithTimeInterval:time block:^(NSTimer *timer) {
    block([self normal:idx],idx,stop);
    idx++;
    if (stop) [t invalidate];
 	} repeats:repeat];
  return t;
}
-  (NSS*) joinedByNewlines { return [self componentsJoinedByString: zNL]; }
-  (NSS*) joinedWithSpaces { return [self componentsJoinedByString:zSPC]; }
-  (NSS*) componentString  { return [self componentsJoinedByString:zNIL]; }
-    (id) assertedValueAtIndex:(NSUI)idx isKindOf:(Class)k {
	id x = self[idx];
	if (![x ISKINDA:k] && [x respondsToSelector:@selector(mutableCopy)])	x = [x mutableCopy];
	NSAssert([x class] == k, $(@"wrong class!  asked for %@, got a %@", NSStringFromClass(k), NSStringFromClass([x class])));
	return x;
}
-  (NSS*)   stringAtIdx:(NSUI)idx { return  (NSS*)[self assertedValueAtIndex:index isKindOf: NSS.class]; }
- (NSMS*) mstringAtIdx:(NSUI)idx { return (NSMS*)[self assertedValueAtIndex:index isKindOf:NSMS.class]; }
-  (NSD*)     dictAtIdx:(NSUI)idx { return  (NSD*)[self assertedValueAtIndex:index isKindOf: NSD.class]; }
- (NSMD*)   mdictAtIdx:(NSUI)idx { return (NSMD*)[self assertedValueAtIndex:index isKindOf:NSMD.class]; }
-  (NSA*)    arrayAtIdx:(NSUI)idx { return  (NSA*)[self assertedValueAtIndex:index isKindOf: NSA.class]; }
- (NSMA*)  marrayAtIdx:(NSUI)idx { return (NSMA*)[self assertedValueAtIndex:index isKindOf:NSMA.class]; }
-  (NSA*) arrayByAddingAbsentObjectsFromArray:(NSA*)otherArray {
	__block NSMA* newself = self.mutableCopy;
	[otherArray each:^(id obj) {
		[newself containsObject:obj] ? nil : [newself addObject:obj];
	}];
	return newself;
}
+  (NSA*) arrayWithRects:(NSR)firstRect,...NS_REQUIRES_NIL_TERMINATION {
 	NSMA*re = NSMA.new; id detector;
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
+ (NSA*) from:(NSI)from to:(NSI)to { return [NSA arrayFrom:from to:to]; }
-   (id) nextNormalObject {
	NSN    * n = [self associatedValueForKey:@"AZNextNormalObjectInternalIndex" orSetTo:@0 policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	NSUI indie = n.unsignedIntegerValue > self.count ? 0 : n.unsignedIntegerValue;
  n = indie ? n : @0;
	[self setAssociatedValue:n.increment forKey:@"AZNextNormalObjectInternalIndex" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
 	return [self normal:indie];
}
-   (id) nextObject       {
	NSN    * n = [self associatedValueForKey:@"AZNextObjectInternalIndex" orSetTo:@(0) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	NSUI indie = n.unsignedIntegerValue;
	if (indie > self.count) return nil;
	[self setAssociatedValue:n.increment forKey:@"AZNextObjectInternalIndex" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
 	return [self normal:indie];
  //	static NSS *intIDX = nil;  intIDX = intIDX ? : @"internalIndexNextObject";
  //    NSUI intIndex = [self hasAssociatedValueForKey:intIDX] ? [[self associatedValueForKey:intIDX]unsignedIntegerValue] : 0;
  //    [self setAssociatedValue:@(intIndex + 1) forKey:intIDX policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
  //    return [self normal:intIndex];
}
- (NSCountedSet*) countedSet {
  return [NSCountedSet.alloc initWithArray:self];
}
- (NSRNG) rangeOfSubarray:(NSA*)sub {
  NSUI first = [self indexOfObject:sub.first];
  NSRNG rng = NSMakeRange(first, sub.count);
  BOOL identical = [[self subarrayWithRange:rng] corresponds:sub withBlock:^BOOL(id key, id obj) {
    return [key isEqual:obj];
  }];
  return identical ? rng : NSZeroRange;
}
+ (NSA*) arrayWithRange:(NSRNG)range {
  NSMA*array = NSMutableArray.new;
  NSI i;
  for (i = range.location; i < (range.location + range.length); i++)
    [array addObject:[NSN numberWithInteger:i]];
  return array.copy;
}
@dynamic trimmedStrings;
- (NSA*) withMinItems:(NSUI)items usingFiller:(id)fill  {
  if (self.count >= items) return self;
  NSMA *upgrade = [NSMA arrayWithArray:self];
  for (NSUI i = self.count; i < items; i++) {
    id filler = fill == self ? [[self normal:i]copy] : [fill copy];
    if (!filler) return (id)nil;
    else [upgrade addObject:filler];
  }
  //    NSLog(@"grew array from %ld to %ld", self.count, upgrade.count);
  return upgrade;
}
- (NSA*) withMin:(NSUI)min max:(NSUI)max                {  return [[self withMinItems:min ] withMaxItems:max]; }
- (NSA*) withMinItems:(NSUI)items                       {
  return [self withMinItems:items usingFiller:self];
}
- (NSA*) withMinRandomItems:(NSUI)items                 {
  return [self.shuffeled withMinItems:items];
}
- (NSA*) withMaxRandomItems:(NSUI)items                 {
  return self.count <= items ? self : [self.shuffeled subarrayToIndex:items];
}
- (NSA*) withMaxItems:(NSUI)items                       {
  return self.count <= items ? self : [self subarrayToIndex:items];
}
- (void) setStringsToNilOnbehalfOf:(id)entity {
  [self each:^(id obj) { [entity setValue:nil forKey:obj]; }];
}
- (NSA*)     sorted:(AZOrder)o  {
  return o != AZAscending && o != AZDescending ? self.alphabetized : [self sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending: o == AZAscending]]];
}
- (NSA*)  ascending             { return [self sorted:AZAscending];  }
- (NSA*) descending             { return [self sorted:AZDescending]; }
- (NSN*) maxNumberInArray { return self.descending.firstObject; }
- (NSN*) minNumberInArray { return self.ascending.firstObject; }
//	return (NSN*).first;	[self sortedArrayUsingSelector: @selector(compare:)].first; }
//	NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
//	return (NSN*)[self sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]].first;
//return (NSN*)[self sortedArrayUsingSelector: @selector(compare:)].last;
- (NSA*) URLsForPaths {
  return [self map:^id (id obj) { return [NSURL fileURLWithPath:obj]; }];
}
- (void) logEachPropertiesPlease  {      [self eachWithIndex:^(id obj, NSI idx) {                NSLog(@"%@", [obj propertiesPlease]); }]; }
- (void) logEachProperties        {
  [self eachWithIndex:^(NSO* obj, NSI idx) { NSLog(@"%@", [obj properties]); }];
}
- (void) logEach                  {
  [self eachWithIndex:^(id obj, NSI idx) {                NSLog(@"Index %ld: %@", idx, obj);  }];
}
+ (NSA*) arrayFromPlist:(NSS*) path {
  return [NSPropertyListSerialization propertyListFromData:
          [NSData dataWithContentsOfFile:path] mutabilityOption:NSPropertyListImmutable
                                                    format:nil errorDescription:nil];
}
- (void) saveToPlistAtPath:(NSS*) path {
  //	[HRCoder archiveRootObject:self toFile:path];
  //	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/plutil" arguments:@[@"-convert", @"xml1", path]];
}
- (NSA*) arrayWithEach {
  return [NSArray arrayWithArrays:self];
}
+ (NSA*) arrayWithArrays:(NSA*) arrays {
  return [[self mutableArrayWithArrays:arrays] copy];
}
+ (NSMA*) mutableArrayWithArrays:(NSA*)arrays {
  NSMA*array = [NSMA arrayWithCapacity:0];
  for (NSArray *a in arrays) {
    [array addObjectsFromArray:a];
  }
  return array;
}
- (NSS*) stringWithEnum:(NSUI)anEnum                    { return self[anEnum];    }
- (NSUI) enumFromString:(NSS*)aString default:(NSUI)def {
  NSUI n = [self indexOfObject:aString];  check(n != NSNotFound); if (n == NSNotFound) n = def; return n;
}
- (NSUI) enumFromString:(NSS*)aString                   {       return [self enumFromString:aString default:0]; }
- (NSA*) allKeysInChildDictionaries   {
	return [self cw_mapArray:^id(id object) {
		return [object respondsToSelector:@selector(allKeys)] || [object ISKINDA:NSD.class] ? [object allKeys][0] : nil;
	}];
}
- (NSA*) allvaluesInChildDictionaries {
	return [self cw_mapArray:^id(id object) {
		return [object respondsToSelector:@selector(allValues)] || [object ISKINDA:NSD.class] ? [object allValues][0] : nil;
	}];
}
- (NSMS*) mutableCopies { return [self map:^id(id obj) { return [obj respondsToStringThenDo:@"mutableCopy"]; }].mutableCopy; }
- (NSA*) colorValues {
  return [self arrayUsingBlock:^id (id obj) {
    return [obj colorValue];
  }];
  //	[self arrayPerformingSelector:@selector(colorValue)];
}
// array evaluating a selector
- (NSA*)arrayPerformingSelector:(SEL)selector {
	NSMA*re = [NSMA arrayWithCapacity:self.count];
	for (id o in self) {
		id v = [o performSelectorWithoutWarnings:selector];
		if (v) {
			[re addObject:v];
		}
	}
	return re;
}
- (NSA*)arrayPerformingSelector:(SEL)selector withObject:(id)object {
	NSMA*re = [NSMA arrayWithCapacity:self.count];
	for (id o in self) {
		id v = [o performSelectorWithoutWarnings:selector withObject:object];
		if (v) {			[re addObject:v];		}
	}
	return re;
}
- (NSA*) arrayUsingIndexedBlock:(id (^)(id obj, NSUI idx))block {
  NSMA*result = [NSMA arrayWithCapacity:[self count]];
  [self enumerateObjectsUsingBlock:^(id obj, NSUI idx, BOOL *stop) {
    [result addObject:block(obj, idx)];
  }];
  return result;
}
// NSArray *sortedArray = [theArray sortedWithKey:@"theKey" ascending:YES];
- (NSA*) sortedWithKey:(NSS*) theKey ascending:(BOOL)ascending {
  return [self sortedArrayUsingDescriptors:@[[NSSortDescriptor.alloc initWithKey:theKey ascending:ascending]]];
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
// an array of NSNs with Integer values, NSNotFound is the terminator
+ (NSA*) arrayWithInts:(NSI)i, ...{
  NSMA*re = NSMA.new;
  [re addObject:[NSN numberWithInt:i]];
  va_list args;
  va_start(args, i);
  NSI v;
  while ((v = va_arg(args, NSI)) != NSNotFound)
    [re addObject:[NSN numberWithInt:v]];
  va_end(args);
  return re;
}
// an array of NSNUmbers with double values, MAXFLOAT is the terminator
+ (NSA*) arrayWithDoubles:(double)f, ...{
  NSMA*re = NSMA.new;
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
- (NSSet*) set        { return [NSSet setWithArray:self]; }
- (NSA*) shifted    {
  NSMA*re = self.mutableCopy;
  [re removeFirstObject];
  return re;
}
- (NSA*) popped {
  NSMA*re = self.mutableCopy;
  [re removeLastObject];
  return re;
}
- (NSA*) reversed { NSMA *r = NSMA.new; for (int i = self.count - 1; i >= 0; i--)  [r addObject:self[i]]; return r; }
//    return [self.mutableCopy az_reverse];
//}
- (NSA*)arrayWithObjectsMatchingKeyOrKeyPath:(NSS*)keyPath;
{
	return [self cw_mapArray:^id(id object) {
		id x = [object valueForKeyOrKeyPath:keyPath];  return x?:nil;
	}];
}
// array evaluating the keyPath
- (NSA*) arrayWithKey:(NSS*) keyPath {
  NSMA*re = [NSMA arrayWithCapacity:self.count];
  for (id o in self) {
    id v = [o vFKP:keyPath];
    if (v) {
      [re addObject:v];
    }
  }
  return re;
}
/**	Additions.	*/
//@implementation NSArray (TTCategory)
- (void)perform:(SEL)selector {
  NSArray *copy = [NSA arrayWithArray:self];
  NSEnumerator *e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelectorWithoutWarnings:selector withObject:nil];
    }
  }
  //    [copy release];
}
- (void)perform:(SEL)selector withObject:(id)p1 {
  NSArray *copy = [NSA arrayWithArray:self];
  NSEnumerator *e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelectorWithoutWarnings:selector withObject:p1];
    }
  }
  //    [copy release];
}
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
  NSArray *copy = [NSA arrayWithArray:self];
  NSEnumerator *e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
      [delegate performSelector:selector withObject:p1 withObject:p2];
#pragma clang diagnostic pop
    }
  }
}
- (void)perform:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
  NSArray *copy = [NSA arrayWithArray:self];
  NSEnumerator *e = [copy objectEnumerator];
  for (id delegate; (delegate = [e nextObject]); ) {
    if ([delegate respondsToSelector:selector]) {
      [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
    }
  }
}
- (void)makeObjectsPerformSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 {
  for (id delegate in self) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [delegate performSelector:selector withObject:p1 withObject:p2];
#pragma clang diagnostic pop
  }
}
- (void)makeObjectsPerformSelector:(SEL)selector
                        withObject:(id)p1
                        withObject:(id)p2
                        withObject:(id)p3 {
  for (id delegate in self) {
    [delegate performSelector:selector withObject:p1 withObject:p2 withObject:p3];
  }
}
- (void)makeObjectsPerformSelector:(SEL)selector withBool:(BOOL)b {
  for (id x in self) {
    if (![x respondsToSelector:selector]) continue;
    BOOL local = b;
    BOOL *p = &local;
    [x performSelector:selector withValue:p];
    free(p);
  }
}
- (id) objectsWithValue:(id)value forKey:(id)key	{
	NSMA *subsample = NSMA.new;
  for (id object in self) {
    id propertyValue = [object vFK:key];
    if ([propertyValue isEqual:value])   [subsample addObject:object];
  }
  return subsample.count ? subsample : nil;
}
- (id)objectWithValue:(id)value forKey:(id)key {
  for (id object in self) {
    id propertyValue = [object vFK:key];
    if ([propertyValue isEqual:value]) {
      return object;
    }
  }
  return nil;
}
- (id)objectWithClass:(Class)cls {
  for (id object in self) {
    if ([object isKindOfClass:cls]) {
      return object;
    }
  }
  return nil;
}
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
- (NSA*) arrayBySettingValue:(id)v forObjectsKey:(NSS*)k { if (!v) return self;
  for (id x in self) x[k] = v;
  return self;
}
- (NSA*) arrayUsingBlock:(id (^)(id obj))block {
  return [self map:block];
}
- (NSA*) map:(id (^)(id obj))block {
  NSMA*re = [NSMA arrayWithCapacity:self.count];
  for (id o in self) {
    id v = block(o);
    if (v) [re addObject:v];
  }
  return re;
}
- (NSA*) nmap:(id (^)(id obj, NSUI index))block {
  NSMA*re = [NSMA arrayWithCapacity:self.count];
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
- (NSA*) arrayWithoutStringContaining:(NSS*)str { return [self filter:^BOOL(id obj){ return !ISA(obj, NSS) ? NO : ![obj containsString:str]; }]; }
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
- (id)filterNonNil:(id(^)(id))block { __block id x = nil;
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    x = block(obj);
    if (x) *stop = YES;
	}];
	return x;
}
- (NSA*) filter:(BOOL (^)(id object))blk {
  return [self filteredArrayUsingBlock:^(id o, NSD *d) { return (BOOL)blk(o); }];
}
- (id) filterOneBlockObject:(id(^)(id object))block {
  __block id x = nil;
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    *stop = ((x = block(obj)));
  }];
  return x;
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
-    (NSA*) arrayOfClass:(Class)aClass forKey:(NSS*)k { return [[self vFK:k] arrayOfClass:aClass]; }
-    (NSA*) arrayOfClass:(Class)aClass { return [self mapArray:^id(id o) { return ISA(o,aClass) ? o : nil;  }]; }
- (NSA*) elementsOfClass:(Class)aClass {
  return [self cw_mapArray:^id (id o) { return [o isKindOfClass:aClass] ? o : nil; }];
}
- (NSA*) numbers {
  return [self elementsOfClass:NSN.class];
}
- (NSA*) strings {
  return [self elementsOfClass:NSString.class];
}
//- (NSA*)trimmedStrings {
//	NSMA*re = NSMA.new;
//
//	for (id o in self) {
//		if ([o isKindOfClass:NSString.class]) {
//			NSS*s = [o trim];
//			if (!s.isEmpty) {
//				[re addObject:s];
//			}
//		}
//	}
//	return re;
//}
// accessing
- (id)objectAtIndex:(NSUI)index fallback:(id)fallback {
  if (self.count <= index)     return fallback;
  @try { id re = self[index];  return !re ? fallback : re;  }
  @catch (NSException *e) {    return fallback;             }
}
- (id) objectOrNilAtIndex:(NSUI)index { return self.count <= index ? nil : self[index]; }
- (id) first    { return [self objectOrNilAtIndex:0]; }
- (id) second   { return [self objectOrNilAtIndex:1]; }
- (id) thrid    { return [self objectOrNilAtIndex:2]; }
- (id) fourth   { return [self objectOrNilAtIndex:3]; }
- (id) fifth    { return [self objectOrNilAtIndex:4]; }
- (id) sixth    { return [self objectOrNilAtIndex:5]; }
- (NSA*) subarrayFromIndex:(NSUI)start                    { return [self subarrayFromIndex:start toIndex:self.count - 1]; }
- (NSA*)   subarrayToIndex:(NSUI)end                      { return [self subarrayFromIndex:0 toIndex:end];                }
- (NSA*) subarrayFromIndex:(NSUI)start toIndex:(NSUI)end  {
  NSAssert(self.count, @"im emtpy, b!");
//  if (start + end < self.count) return @[];
  //  NSParameterAssert(start + end < self.count);
  //  if (start > self.count || (start + end) > self.count) return nil;
  return [self subarrayWithRange:NSMakeRange(start, MIN(self.count -1, end - start))];
  //    NSI from = start;
  //    while (from < 0) from += self.count;
  //    if (from > self.count) return nil;
  //
  //    NSI to = end;
  //    while (to < 0) to += self.count;
  //    if (from >= to) {
  //        // this behaviour is somewhat different it will return anything from this array except the passed range
  //        NSA *re = @[];
  //        if (from > 0) re = [self subarrayWithRange:(NSRNG) {0, from - 1 }];
  //        if (to < self.count) {
  //            if (re != nil) re = [re arrayByAddingObjectsFromArray:[self subarrayWithRange:(NSRNG) {to - 1, self.count - 1 }]];
  //        }
  //        return re;
  //    }
  //    return [self subarrayWithRange:(NSRNG) {from, to }];
}
- (void) eachWithVariadicPairs:(void(^)(id a, id b))pairs {
  NSA* split = self.splitByParity;
  NSA* valsA = split[0], *valsB = split[1];
  [valsA eachWithIndex:^(id obj, NSI idx) {  pairs(obj, valsB[idx]); }];
}
- (NSA*) pairedWith:(NSA*)pairs {   NSAssert(self.count == pairs.count, @"Arrays must by of equzl count!");
  return [self reduce:@[].mutableCopy with:^id(id sum, id obj, NSUInteger idx) {
    [sum addObject:obj]; [sum addObject:pairs[idx]]; return sum;
  }];
}
- (NSA*) splitByParity {
  NSAssert(isEven(self.count), @"must split evenly");
  NSMA*uno, *dos;   uno = NSMA.new; dos = NSMA.new;
  for (int i = 0; i < self.count; i = i + 2) {
    [uno addObject:self[i]];
    [dos addObject:self[i+1]];
  }
  return @[uno,dos];
}
- (NSA*) jumbled { NSMA*jumbled = self.mutableCopy;
  NSUI x = self.count-1;
  while(x) {  [jumbled exchangeObjectAtIndex:x withObjectAtIndex:arc4random_uniform(x)];  x--; }
  return jumbled;
}
-   (id) randomElement {  return !self.count ? nil : [self normal:(arc4random() % self.count)];	}
- (NSA*) shuffeled { return self.count < 2 ? self : ((NSMA*)self.mutableCopy).shuffle; }
- (NSA*) randomSubarrayWithSize:(NSUInteger)size {
  if (self.count == 0) {
    return @[];
  }
  NSUI capacity = MIN(size, self.count);
  NSMA*re = [NSMA arrayWithCapacity:capacity];
  while (re.count < capacity) {
    NSUI index = random() % (self.count - re.count);
    id e = self[index];
    while ([re containsObject:e])
      e = self[++index];
    [re addObject:e];
  }
  return re;
}
-   (id)objectAtNormalizedIndex:(NSI)index {
  return [self normal:index];
}
- (NSUI) normalizedIndex:(NSI)index { NSI x = index;
  if (!self.count) return nil;
  while (x < 0) x += self.count;
  return x % self.count;
}
-   (id)normal:(NSI)index { return self[[self normalizedIndex:index]]; }
- (NSI)sumIntWithKey:(NSS*) keyPath {
  NSI re = 0;
  for (id v in self) {
    id k = v;
    if (keyPath != nil) {
      k = [v vFKP:keyPath];
    }
    if ([k isKindOfClass:NSN.class]) {
      re += [k intValue];
    }
  }
  return re;
}
- (CGF)sumFloatWithKey:(NSS*) keyPath {
  CGF re = 0;
  for (id v in self) {
    id k = v;
    if (!!keyPath)         k = [v vFKP:keyPath];
    if (ISA(k,NSN)) re += [k fV];
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
-(id) firstObjectOfClass:(Class)k {
	return [self filterOne:^BOOL(id object) {return [[object class] ISKINDA: k.class]; }];
}
- (NSA*) filteredArrayUsingBlock:(BOOL (^)(id evaluatedObject, NSDictionary *bindings))block {
  NSPredicate *p = [NSPredicate predicateWithBlock:block];
  return [self filteredArrayUsingPredicate:p];
}
- (NSA*) uniqueStrings {
	NSMA* unique = NSMA.new;
	NSMutableSet * processed = [NSMutableSet set];
	for (NSString * string in self)
		if ([processed containsObject:string] == NO) {
			[unique addObject:string];
			[processed addObject:string];
    }
	return  unique;
}
- (NSA*) uniqueObjects {
  NSBag *set = [NSBag bagWithArray:self];
  return set.uniqueObjects;
}
- (NSA*) uniqueObjectsSortedUsingSelector:(SEL)comparator {
  NSSet *set =
  [NSSet.alloc initWithArray:self];
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
  //    dispatch_release(group);
  //    dispatch_release(queue);
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
- (void)doUntil:(BOOL(^)(id obj))block {
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    *stop =! block(obj);
  }];
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
  __block NSMA *cwArray = NSMA.new; [self do:^(id obj) { id rObj = block(obj); if (rObj) [cwArray addObject:rObj]; }];
  return cwArray;
}
-(NSD*)mapToDictForgivingly:(AZKeyPair*(^)(id))b {
  return [self reduce:NSMD.new withBlock:^id(NSMD*sum, id obj) {  AZKP *kp;
    if ((kp = b(obj))) sum[kp.key] = kp.value; return sum;
  }];
}
- (NSD*)   mapToDictByReturningValue:(BOOL)returnsVal block:(id(^)(id))b {
  return [self reduce:NSMD.new withBlock:^id(NSMD*sum, id obj) {  id bObj = b(obj) ?: nil;
    if ((bObj)) sum[returnsVal ? obj : bObj] = returnsVal ? bObj : obj; return sum;
  }];
}
- (NSD*) mapToDictValuesForgivingly:(id(^)(id))b { return [self mapToDictByReturningValue:YES block:b]; }
- (NSD*)   mapToDictKeysForgivingly:(id(^)(id))b { return [self mapToDictByReturningValue:NO  block:b]; }
@end
@implementation NSArray (ListComprehensions) // Create a new array with a block applied to each index to create a new element
+ (NSA*) arrayWithBlock:(id (^)(int index))block range:(NSRNG)range {
  NSMA* array = NSMA.new; for (int i = range.location; i < range.location + range.length; i++) {
    [array addObject:block(i)];
  }
  return array;
}                                                                                                                                                                                                        // The same with a condition
+ (NSA*) arrayWithBlock:(id (^)(int index))block range:(NSRNG)range if:(BOOL (^)(int index))blockTest {
  NSMA * array = NSMA.new; for (int i = range.location; i < range.location + range.length; i++) {
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
//  Found through: http://stackoverflow.com/questions/4692161/non-retaining-array-for-delegates
//  Created by Tod Cunningham on 8/31/12.  www.fivelakesstudio.com
@implementation NSMA (WeakReferences)
+ (INST) mutableArrayUsingWeakReferences                      {	return [self mutableArrayUsingWeakReferencesWithCapacity:0];	}
+ (INST) mutableArrayUsingWeakReferencesWithCapacity:(NSUI)c	{
	// The two NULLs are for the CFArrayRetainCallBack and CFArrayReleaseCallBack methods.
  // Since they are NULL no retain or releases sill be done.
	CFArrayCallBacks callbacks = {0, NULL, NULL, CFCopyDescription, CFEqual};
	return (__bridge id)(CFArrayCreateMutable(0, c, &callbacks)); 	// We create a weak reference array
}
@end
@implementation NSArray (Extensions)
- (id) firstObject {
	return self.count ? [self objectAtIndex:0] : nil;
}
@end
@implementation NSMA (Extensions)
- (void) removeFirstObject {
	[self removeObjectAtIndex:0];
}
@end
@implementation NSMA (AG)
-  (NSA*) alphabetize { return [self sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];	}
-  (void) swizzleInsertObject:(id) o atIndex:(NSUInteger)idx {
	[self swizzleInsertObject:o atIndex:idx];
	[AZNOTCENTER postNotificationName:NSMutableArrayDidInsertObjectNotification object:self userInfo:nil];
}
-  (void) swizzleAddObject:(id) o {
	[self swizzleAddObject:o];
	[AZNOTCENTER postNotificationName:NSMutableArrayDidInsertObjectNotification object:self userInfo:nil];
}
-  (void) swizzleAddObjectsFromArray:(NSA*)a {
	[self swizzleAddObjectsFromArray:a];
	[AZNOTCENTER postNotificationName:NSMutableArrayDidInsertObjectNotification object:self userInfo:nil];
}
+  (void) load  {
	[$ swizzleMethod:@selector(insertObject:atIndex:) with:@selector(swizzleInsertObject:atIndex:) in:self.class];
	[$ swizzleMethod:@selector(addObject:) with:@selector(swizzleAddObject:) in:self.class];
	[$ swizzleMethod:@selector(addObjectsFromArray:) with:@selector(swizzleAddObjectsFromArray:) in:self.class];
}
-  (void) addPoint:(NSPoint)point {
  [self addObject:AZVpoint(point)];
}
-  (void) addRect:(NSRect)rect {
  [self addObject:AZVrect(rect)];
}
-    (id) advance {
	id first = self.firstObject;
	[self firstToLast];
	return first;
}
-    (id) last {
  return self.lastObject;
}
-  (void) setLast:(id)anObject {
  if (anObject) [self triggerKVO:@"last" block:^(id _self) { [_self addObject:anObject]; }];
}
-    (id) first { return [super first]; }
-  (void) firstToLast {
  if (self.count == 0) return;      //there is no object to move, return
  int toIndex = self.count - 1;     //toIndex too large, assume a move to end
  [self moveObjectAtIndex:0 toIndex:toIndex];
}
-  (void) lastToFirst {
  if (self.count == 0) return;      //there is no object to move, return
  [self moveObjectAtIndex:self.count - 1 toIndex:0];
}
-  (void) setFirst:(id)anObject {
  if (anObject == nil) return;
  [self willChangeValueForKey:@"first"];
  [self insertObject:anObject atIndex:0];
  [self didChangeValueForKey:@"first"];
}
-  (void) removeFirstObject {
  [self shift];
}
-    (id) shift {
  if (self.count == 0) return nil;
  id re = self.first;
  [self removeObjectAtIndex:0];
  return re;
}
-    (id) pop {
  if (self.count == 0) return nil;
  id o = self.lastObject;
  [self removeLastObject];
  return o;
}
-  (void) shove:(id)object {
  [self insertObject:object atIndex:0];
}
-    (id) peek {
  return self.lastObject;
}
-  (void) push:(id)obj  { [self addObject:obj]; }
- (NSMA*) sort          { [self sortUsingSelector:@selector(compare:)]; return self; }
- (NSMA*) az_reverse    { @synchronized(self) {
    for (NSUI i = 0; i < floor(self.count / 2); i++) 
      [self exchangeObjectAtIndex:i withObjectAtIndex:(self.count - i - 1)];
  } return self;
}
- (NSMA*) shuffle {
  @synchronized(self) {
    for (NSUI i = 0; i < self.count; i++) {
      NSUI one = random() % self.count;
      NSUI two = random() % self.count;
      [self exchangeObjectAtIndex:one withObjectAtIndex:two];
    }
  }
  return self;
}
-  (void) moveObject:(id)obj toIndex:(NSUI)toIndex { if (!obj) return;
	[self containsObject:obj] 	? 	[self moveObjectAtIndex:[self indexOfObject:obj] toIndex:toIndex]
  :	[self insertObject:obj atIndex:toIndex];
}
-  (void) moveObjectAtIndex:(NSUI)fromIndex toIndex:(NSUI)toIndex {
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
    NSS *value = [self[i] vFKP:keyPath];
    if (value) {
      if ((i > 0)) [string appendString:@"\n"];
      [string appendFormat:@"%@%@", bullet, value];
    }
  }
  return string.copy;
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
    ? [object vFK:key]
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
  return string.copy;
}
- (NSS*) listNames {
  return [self listValuesForKey:@"name" conjunction:nil truncateTo:0];
}
@end
@implementation NSArray (UKColor)
//		Converts the color to an RGB color if needed, and then creates an array
//		with its red, green, blue and alpha components (in that order).
+ (NSA*)arrayWithColor:(NSColor *)col          {
  CGFloat fRed = 0, fGreen = 0, fBlue = 0, fAlpha = 1.0;
  col = [col colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  [col getRed:&fRed green:&fGreen blue:&fBlue alpha:&fAlpha];
  return @[@(fRed), @(fGreen),@(fBlue), @(fAlpha)];
}
//		Converts an NSArray with three (or four) NSValues into an RGB Color (plus alpha, if specified).
- (NSColor *)colorValue              {
  float fRed = 0, fGreen = 0, fBlue = 0, fAlpha = 1.0;
  if ([self count] >= 3) { fRed = [self[0] fV];  fGreen = [self[1] fV];  fBlue = [self[2] fV];  }
  if ([self count] > 3)    fAlpha = [self[3] fV];       // Have alpha info?
  return [NSColor colorWithCalibratedRed:fRed green:fGreen blue:fBlue alpha:fAlpha];
}
@end
//#import "ArrayUtilities.h"
#import "NSObject-Utilities.h"
#import <time.h>
#import <stdarg.h>
/* Thanks to August Joki, Emanuele Vulcano, BlueLlama, Optimo, jtbandes To add Math Extensions like sum, product?  */
@implementation AZKeyPair
+ (instancetype) key:(id)k value:(id)v {  AZKeyPair *kp = self.new; kp.key = k; kp.value = v; return kp; }
@end
#pragma mark UtilityExtensions
@implementation NSArray (UtilityExtensions)
- (NSA*) arrayBySortingStrings {
  NSMA*sort = [NSMA arrayWithArray:self];
  for (id eachitem in self) if (![eachitem isKindOfClass:NSString.class]) [sort removeObject:eachitem];
  return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
- (NSS*) stringValue { return [self componentsJoinedByString:@" "]; }
- (NSA*) reversedArray {	return [[self reverseObjectEnumerator] allObjects]; }
-   (id) firstObject {
  return !self.count ? nil : self[0];
}
- (NSA*) uniqueMembers {
  NSMA*copy = self.mutableCopy;
  for (id object in self) {
    [copy removeObjectIdenticalTo:object];
    [copy addObject:object];
  }
  return [copy autorelease];
}
- (NSA*) unionWithArray:(NSA*)anArray {
  if (!anArray) return self;
  return [[self arrayByAddingObjectsFromArray:anArray] uniqueMembers];
}
- (NSA*) intersectionWithArray:(NSA*)anArray {
  NSMA*copy = [self.mutableCopy autorelease];
  for (id object in self) {
    if (![anArray containsObject:object]) [copy removeObjectIdenticalTo:object];
  }
  return [copy uniqueMembers];
}
// A la LISP, will return an array populated with values
- (NSA*) map:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
  NSMA*results = NSMA.new;
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
- (NSA*) map:(SEL)selector withObject:(id)object1 {
  return [self map:selector withObject:object1 withObject:nil];
}
- (NSA*) map:(SEL)selector {
  return [self map:selector withObject:nil];
}
// NOTE: Selector must return BOOL
- (NSA*) collect:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
  NSMA*riz = NSMA.new;
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
- (NSA*) collect:(SEL)selector withObject:(id)object1 {
  return [self collect:selector withObject:object1 withObject:nil];
}
- (NSA*) collect:(SEL)selector {
  return [self collect:selector withObject:nil withObject:nil];
}
// NOTE: Selector must return BOOL
- (NSA*) reject:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
  NSMA*riz = NSMA.new;
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
- (NSA*) reject:(SEL)selector withObject:(id)object1 {
  return [self reject:selector withObject:object1 withObject:nil];
}
- (NSA*) reject:(SEL)selector {
  return [self reject:selector withObject:nil withObject:nil];
}
@end
#pragma mark Mutable UtilityExtensions
@implementation NSMA (UtilityExtensions)
-  (void) moveObjectFromIndex:(NSI)oldIndex toIndex:(NSI)newIndex {
	if (oldIndex == newIndex)
		return;
	if (newIndex > oldIndex)
		newIndex--;
	id object = self[oldIndex];
	[self removeObjectAtIndex:oldIndex];
	[self insertObject:object atIndex:newIndex];
}
- (NSMA*) reverse {
  for (int i = 0; i < (floor([self count] / 2.0)); i++) {
    [self exchangeObjectAtIndex:i withObjectAtIndex:([self count] - (i + 1))];
  }
  return self;
}
// Make sure to run srandom([[NSDate date] timeIntervalSince1970]); or similar somewhere in your program
- (NSMA*) scramble {
  for (int i = 0; i < ([self count] - 2); i++) {
    [self exchangeObjectAtIndex:i withObjectAtIndex:(i + (random() % ([self count] - i)))];
  }
  return self;
}
- (NSMA*) removeFirstObject {
  [self removeObjectAtIndex:0];
  return self;
}
@end
#pragma mark StackAndQueueExtensions
@implementation NSMA (StackAndQueueExtensions)
-    (id) popObject                   {
  if ([self count] == 0) return nil;
  id lastObject = self.lastObject;
  [self removeLastObject];
  return lastObject;
}
- (NSMA*) pushObject:(id)object       {
  [self addObject:object];
  return self;
}
- (NSMA*) pushObjects:(id)object, ... {  if (!object) return self;  id obj = object;
  va_list objects; va_start(objects, object);
  do {
    [self addObject:obj]; obj = va_arg(objects, id);
  } while (obj);  va_end(objects);  return self;
}
-    (id) pullObject      {
  if ([self count] == 0) return nil;
  id firstObject = self[0];
  [self removeObjectAtIndex:0];
  return firstObject;
}
- (NSMA*) push:(id)object {
  return [self pushObject:object];
}
-    (id) pop             {
  return [self popObject];
}
-    (id) pull            {
  return [self pullObject];
}
@end
@implementation NSArray (FilterByProperty)
- (NSA*) subArrayWithMembersOfKind:(Class)k { return [self map:^id(id object) { return ISA(object,k) ? object : nil; }]; }
- (NSA*) stringsPaddedToLongestMember {
	NSUI ct = [self lengthOfLongestMemberString];										// deduce longest string
	return [self map:^id(id obj) {		return [obj paddedTo:ct];	}];
}
- (NSUI) lengthOfLongestMemberString {
	return [[[self subArrayWithMembersOfKind:NSS.class] sortedWithKey:@"length" ascending:NO][0]length];
}
- (NSA*)           filterByProperty:(NSS*) p
{
  NSMA*finalArray = NSMA.new;
  NSMutableSet *lookup = NSMutableSet.new;
  for (id item in self)
    {
    if (![lookup containsObject:[item vFK:p]])
      {
      [lookup addObject:[item vFK:p]];
      [finalArray addObject:item];
      }
    }
  //    [lookup release];
  return finalArray;
}
@end

@implementation NSObject (RecursiveKVC)

- (NSA*)recursiveValueForKey:(NSS*)k {   NSMA *prog = NSMA.new;

   return [[self vFK:k] MTrecursiveValueForKey:k progress:prog], prog;
}

- (void)MTrecursiveValueForKey:(NSS*)k progress:(NSMA*)prog {
  if (![self valueForKey:k]) return [prog addObject:self];
  [prog addObject:self];
  [[self valueForKey:k] MTrecursiveValueForKey:k progress:prog];
}
@end
@implementation NSArray (RecursiveKVC)
- (NSA*)recursiveValueForKey:(NSS*)k {  return [super recursiveValueForKey:k]; }
- (void)MTrecursiveValueForKey:(NSS*)key progress:(NSMA*)progress{
    for (id obj in self)[obj MTrecursiveValueForKey:key progress:progress];
}

@end

@implementation NSA (CustoKVC)

- (id) _distinctUnionOfPresentObjectsForKeyPath:(NSS*)kp {

  NSMA * values = NSMA.new; for (id obj in self) 
  @try {
    id value = [obj vFKP:kp];

    if(value && value != AZNULL && ![values containsObject:value])

        [values addObject:value];
  }
  @catch (id) { }
  return [NSA arrayWithArray:values];
}
@end

//id objects = @[@{@"color": @"blue"}, @{@"color": @"red"}, @{@"color": @"green"}, @"notacolor"];

//[objects valueForKeyPath:@"@distinctUnionOfPresentObjects.color"] // -> @[@"blue", @"red", @"green"]. 
