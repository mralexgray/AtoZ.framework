

#import <AtoZUniversal/AtoZUniversal.h>

NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent)
{
return  ISA(object,NSS)
    ?   (NSS*)object
    :   [object respondsToSelector:@selector(descriptionWithLocale:indent:)]
    ?   [(NSDictionary *)object descriptionWithLocale:locale indent:indent]
    :   [object respondsToSelector:@selector(descriptionWithLocale:)]
    ?   [(NSSet *)object descriptionWithLocale:locale]
    :   [object description];
}

@implementation AZDict
{
    NSMutableDictionary *dictionary;
    NSMutableOrderedSet*keyset;
}

@dynamic count, reverseKeyEnumerator, keyEnumerator;


- (id) forwardingTargetForSelector:(SEL)s {

  return  s == @selector(count)|| s== @selector(objectForKey:) ? dictionary :
          s == @selector(reverseKeyEnumerator) || s == @selector(keyEnumerator) ? keyset :

  [super forwardingTargetForSelector:s];
}
- init
{
  if (!(self = super.init)) return nil;
  dictionary = NSMutableDictionary.new;
  keyset = NSMutableOrderedSet.new;
  return self;
}

- (id)copy
{
    return [self mutableCopy];
}

- _Void_ setObject: anObject forKey: aKey
{
    if (![keyset containsObject:aKey])
        [keyset addObject:aKey];
    [dictionary setObject:anObject forKey:aKey];
}

- _Void_ removeObjectForKey: aKey
{
    [dictionary removeObjectForKey:aKey];
    [keyset removeObject:aKey];
}

//+ (instancetype) dictWithSortedDict:(NSD*)dict byValues:(BOOL)byV {
//
//  
//}
//- (NSUInteger)count
//{
//    return [dictionary count];
//}
//
//- (id)objectForKey: aKey
//{
//    return [dictionary objectForKey:aKey];
//}

//- (NSEnumerator *)keyEnumerator
//{
//    return [keyset objectEnumerator];
//}
//
//- (NSEnumerator *)reverseKeyEnumerator
//{
//    return [keyset reverseObjectEnumerator];
//}

- _Void_ insertObject: anObject forKey: aKey atIndex:(NSUInteger)anIndex
{
    if ([dictionary objectForKey:aKey])
    {
        [keyset removeObject:aKey];
    }
    [keyset insertObject:aKey atIndex:anIndex];
    [dictionary setObject:anObject forKey:aKey];
}

- (id)keyAtIndex:(NSUInteger)anIndex
{
    return [keyset objectAtIndex:anIndex];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])stackbuf count:(NSUInteger)len
{
    return [keyset countByEnumeratingWithState: state
                                       objects: stackbuf
                                         count: len];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    id key = [keyset objectAtIndex:idx];

    return [dictionary objectForKey:key];
}

- _Void_ setObject: obj atIndexedSubscript:(NSUInteger)idx
{
    //NSAssert (idx <= keyset.count -1, @"index %ld is beyond max range %ld", idx, keyset.count - 1);

    id key = [keyset objectAtIndex:idx];
    [dictionary setObject:obj forKey:key];
}

- _Void_ setObject: obj forKeyedSubscript:(id <NSCopying>)key
{
    [self setObject:obj forKey:key];
}

- (id)objectForKeyedSubscript: key
{
    return [dictionary objectForKey:key];
}

- (NSString *)descriptionWithLocale: locale indent:(NSUInteger)level
{
    NSMutableString *indentString = [NSMutableString string];
    NSUInteger i, count = level;
    for (i = 0; i < count; i++)
    {
        [indentString appendFormat:@"    "];
    }

    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"%@{\n", indentString];
    for (NSObject *key in self)
    {
        [description appendFormat:@"%@    %@ = %@;\n",
         indentString,
         DescriptionForObject(key, locale, level),
         DescriptionForObject([self objectForKey:key], locale, level)];
    }
    [description appendFormat:@"%@}\n", indentString];
    return description;
}

@end

/**
@implementation NSOrderedDictionary (AtoZ)

- _Void_ forwardInvocation:(NSINV*)invocation 		{  // FIERCE

// Forward the message to the surrogate object if the surrogate object understands the message,
//	otherwise just pass the invocation up the inheritance chain, eventually hitting the default
// -[NSObject forwardInvocation:]; which will throw an unknown selector exception.

	SEL sel = invocation.selector;
	[self methodSignatureForSelector:sel] 	?	[invocation invokeWithTarget:self] 					:
	[@[] methodSignatureForSelector:sel] 	?	[invocation invokeWithTarget:self.allObjects] 	:
	[@{} methodSignatureForSelector:sel]	?	[invocation invokeWithTarget:(NSD*)self]			:
															[super forwardInvocation:invocation];

//	self.defaultCollection && [self.defaultCollection respondsToSelector:[invocation selector]]
//									?				   [invocation invokeWithTarget:self.defaultCollection]:nil;
//									:										 [super forwardInvocation:invocation];
}
- (SIG*) methodSignatureForSelector:(SEL)sel			{

// To build up the invocation passed to -forwardInvocation properly,
//	the object must provide the types for parameters and return values
//	for the NSInvocation through -methodSignatureForSelector:

	return 	[self methodSignatureForSelector:sel]  ?:		[@[] methodSignatureForSelector:sel]
 	?: 		[@{} methodSignatureForSelector:sel]   ?: 	nil;

//    return [self respondsToSelector:sel]  resolveInstanceMethod:selector] || [NSDictionary resolveInstanceMethod:selector];
//    return [super methodSignatureForSelector:sel] ?: [self.defaultCollection methodSignatureForSelector:sel];
}
- (BOOL) respondsToSelector:(SEL)selector 				{

	// Claim to respond to any selector that our surrogate object also responds to.
    return ([self methodSignatureForSelector:selector]) ||	[NSA resolveInstanceMethod:selector]
	 			||    [NSD resolveInstanceMethod:selector] 	 	  || 		[super  respondsToSelector:selector];

//	 [super respondsToSelector:selector] || [self.defaultCollection respondsToSelector:selector];
}	/// All methods above are fierce Posing classes
@end
*/

@implementation NSMutableDictionary (AtoZ)
//Returns NO if `anObject` is nil; can be used by the sender of the message or ignored if it is irrelevant.
- (BOOL)setObjectOrNull: anObject forKey: aKey	{
	if(anObject!=nil) {		[self setObject:anObject forKey:aKey]; 		return YES; }
	else {					[self setObject:[NSNull null] forKey:aKey];	return NO;	}
}
#if !TARGET_OS_IPHONE
- _Void_ setColor:(NSColor *)aColor forKey:(NSS*)aKey	{
	NSData *theData=[NSArchiver archivedDataWithRootObject:aColor];
	self[aKey] = theData;
}
- (NSColor *)colorForKey:(NSS*)aKey	{
	NSColor *theColor = nil;
	NSData *theData = self[aKey];
	if (theData != nil) theColor=(NSColor *)[NSUnarchiver unarchiveObjectWithData:theData];
	return theColor;
}
#endif
@end

//		http://appventure.me/2011/12/fast-nsdictionary-traversal-in-objective-c.html
@implementation NSDictionary (objectForKeyList)
- (id)objectForKeyList: key, ...
{
  id object = self;
  va_list ap;
  va_start(ap, key);
  for ( ; key; key = va_arg(ap, id))
      object = [object objectForKey:key];
  
  va_end(ap);
  return object;
}

- (id)objectMatching: match forKeyorKeyPath: kp {

	return [self.allValues filterOne:^BOOL(id object) {
		return [object valueForKeyOrKeyPath:kp] == match;
	}];
}
@end
@implementation NSDictionary(GetObjectForKeyPath)
//	syntax of path similar to Java: record.array[N].item items are separated by . and array indices in []
//	example: a.b[N][M].c.d
- (id)objectForKeyPath:(NSS*)inKeyPath	{
	NSArray	*components = [inKeyPath componentsSeparatedByString:@"."]	;
	int		i, j, n = [components count], m	;
	id		curContainer = self	;
	for (i=0; i<n ; i++)	{
		NSString	*curPathItem = [components objectAtIndex:i]	;
		NSArray		*indices = [curPathItem componentsSeparatedByString:@"["]	;
		m = [indices count]	;
		if (m == 1)	{	// no [ -> object is a dict or a leave
			curContainer = [curContainer objectForKey:curPathItem]	;
		}
		else	{
			//	indices is an array of string "arrayKeyName" "i1]" "i2]" "i3]"
			//	arrayKeyName equal to curPathItem
			if (![curContainer ISADICT])
				return nil	;
			curPathItem = [curPathItem substringToIndex:[curPathItem rangeOfString:@"["].location]	;
			curContainer = [curContainer objectForKey:curPathItem]	;
			for(j=1;j<m;j++)	{
				int	index = [[indices objectAtIndex:j] intValue]	;
				if (![curContainer isKindOfClass:[NSArray class]])
					return nil	;
				if (index >= [curContainer count])
					return nil	;
				curContainer = [curContainer objectAtIndex:index];
			}
		}
	}
	return curContainer	;
}
-(void)setObject: inValue forKeyPath:(NSS*)inKeyPath	{

	NSA	*components = [inKeyPath componentsSeparatedByString:@"."], *indices;
	int		i, j, n = [components count], m, index;
	id		containerContainer = nil, curContainer = self	;
	NSS	*curPathItem = nil;
	BOOL		needArray = NO	;
	for (i=0; i<n ; i++)	{

		curPathItem = [components objectAtIndex:i]	;
		indices = [curPathItem componentsSeparatedByString:@"["]	;
		m = [indices count]	;

		if (m == 1)	{
			if ([curContainer isKindOfClass:[NSNull class]])	{
				curContainer = @{}.mutableCopy	;
				if (needArray)	{
					[containerContainer replaceObjectAtIndex:index  withObject:curContainer]	;
				}
				else	{
					[containerContainer setObject:curContainer forKey:curPathItem]	;
				}
			}
			containerContainer = curContainer	;
			curContainer = [curContainer objectForKey:curPathItem]	;
			needArray = NO	;
			if (![containerContainer ISADICT])
				[NSException raise:@"Path item not a dictionary" format:@"(keyPath %@ - offending %@)",inKeyPath,curPathItem]	;
			if (curContainer == nil)	{
				curContainer = @{}.mutableCopy	;
				[containerContainer setObject:curContainer forKey:curPathItem]	;
			}
		}
		else	{
			needArray = YES	;
			//	indices is an array of string "arrayKeyName" "i1]" "i2]" "i3]"
			//	arrayKeyName equal to curPathItem
			curPathItem = [curPathItem substringToIndex:[curPathItem rangeOfString:@"["].location]	;
			containerContainer = curContainer	;
			curContainer = [curContainer objectForKey:curPathItem]	;
			if (curContainer == nil)	{
				curContainer = [NSMutableArray array]	;
				[containerContainer setObject:curContainer forKey:curPathItem]	;
			}
			if (![curContainer isKindOfClass:[NSArray class]])
				[NSException raise:@"Path item not an array" format:@"(keyPath %@ - offending %@)",inKeyPath,curPathItem]	;
			for(j=1;j<m-1;j++)	{
				index = [[indices objectAtIndex:j] intValue]	;
				containerContainer = curContainer	;
				curContainer = [curContainer objectAtIndex:index]	;
				if ([curContainer isKindOfClass:[NSNull class]])	{
					curContainer = [NSMutableArray array]	;
					[containerContainer replaceObjectAtIndex:index withObject:curContainer]	;
				}
				else	if (![curContainer isKindOfClass:[NSArray class]])
					[NSException raise:@"Path item not an array" format:@"(keyPath %@ - offending %@ index %d)",inKeyPath,curPathItem,j-1]	;
			}
			index = [[indices objectAtIndex:m-1] intValue]	;
			if (index >= [curContainer count])	{
				int	k	;
				for (k = [curContainer count]; k<=index; k++)
					[(NSMA*)curContainer addObject:[NSNull null]]	;
			}
			containerContainer = curContainer	;
			curContainer = [curContainer objectAtIndex:index]	;
		}
	}
	if (needArray)	{	// containerContainer must be an array
		if (![containerContainer isKindOfClass:[NSArray class]])
			[NSException raise:@"Last path item is not an array" format:@"(keyPath %@)",inKeyPath]	;
		[containerContainer	replaceObjectAtIndex:index withObject:inValue]	;
	}
	else	{
		if (![containerContainer ISADICT])
			[NSException raise:@"Before-last path item is not a dictionary" format:@"(keyPath %@)",inKeyPath]	;
		[containerContainer setObject:inValue forKey:curPathItem]	;
	}
}
@end
@implementation NSArray (FindDictionary)
- (id)findDictionaryWithValue: value	{	__block id match = nil;

	[self enumerateObjectsUsingBlock:^(NSO *obj, NSUI idx, BOOL *stop) {
  
		*stop = (!!(match = ISA(obj,NSA) ? [(NSA*)obj findDictionaryWithValue:value] : [obj ISADICT] && [obj[@"allValues"] containsObject:value] ? obj : nil));

	}];
	return match;
}
@end

/*
@implementation  NSObject  (BagofKeysValue)
- (NSBag*) bagWithValuesForKey:(NSS*)key
{
	__block NSBag* newbag = [NSBag new];
	if ([self ISADICT]) {
		if([self.allKeys containsObject:key]) {  [newbag add:self[key]]; }
  		[self.allKeys each:^(NSS* k){
			id obj = [self objectForKey:k];
			if([obj ISADICT]) {
			// we found a child dictionary, let's traverse it
			NSDictionary *d = (NSD*)obj;
			id child = [d recursiveObjectForKey:key];
			if(child) return child;
		}
	else if([obj isKindOfClass:[NSArray class]]) {
			// loop through the NSArray and traverse any dictionaries found
			NSArray *a = (NSA*)obj;
			for(id child in a) {
				if([child ISADICT]) {
					NSDictionary *d = (NSD*)child;
					id o = [d recursiveObjectForKey:key];
					if(o) return o;
				}
			}
		}
	}
//
//	// the key was not found in this dictionary or any of it's children
//	return nil;
}

@end
@implementation NSArray (Recurse)

//- (NSA*) recursiveValuesForKey:(NSS*) key
//{
// 	NSA* u = [self findDictionaryWithValue:<#(id)#>:^id(id obj) {
//		if ( [obj ISADICT]) {
//				if([child ISADICT]) {
//					NSDictionary *d = (NSD*)child;
//					id o = [d recursiveObjectForKey:key];
//					if(o) return o;
//				}
//			}

@end
*/

@implementation NSDictionary (Types)
- (id)objectForKey: key ofType:(Class)type default: defaultValue;	{
  id value = [self objectForKey:key];
  return [value isKindOfClass:type] ? value : defaultValue;
}
- (NSS*)stringForKey: key default:(NSS*)defaultValue	{
  return [self objectForKey:key ofType:NSString.class default:defaultValue];
}
- (NSS*)stringForKey: key;	{
  return [self stringForKey:key default:@""];
}
- (NSN*)numberForKey: key default:(NSN*)defaultValue;	{
  return [self objectForKey:key ofType:[NSNumber class] default:defaultValue];
}
- (NSN*)numberForKey: key;	{
  return [self numberForKey:key default:nil];
}
- (NSA*)arrayForKey: key default:(NSA*)defaultValue;	{
  return [self objectForKey:key ofType:[NSArray class] default:defaultValue];
}
- (NSA*)arrayForKey: key;	{
  return [self arrayForKey:key default:[NSArray array]];
}
@end

//@implementation NSArray (CustomKVCOperator)
//
//- (id) _allValuesForKeyPath:(NSS*)keyPath {
//  id keyPathValue = [self valueForKeyPath:keyPath];
////  size_t instanceSize = class_getInstanceSize([NSArray class]);
//  return [keyPathValue allValues];
//}
//
//@end

@implementation NSDictionary (CustomKVCOperator)
- (id) _allValuesForKeyPath:(NSS*)keyPath {
  id keyPathValue = [self valueForKeyPath:keyPath];
//  size_t instanceSize = class_getInstanceSize([NSArray class]);
  return [keyPathValue allValues];
}
- (id) _allKeysForKeyPath:(NSS*)keyPath {
  id keyPathValue = [self valueForKeyPath:keyPath];
//  size_t instanceSize = class_getInstanceSize([NSArray class]);
  return [keyPathValue allKeys];
}
@end

@implementation  NSDictionary (AtoZ)

- (id) randomValue { return self.allValues.randomElement; }
- (id) randomKey { return self.allKeys.randomElement; }
 

+ (NSD*) withFile:(NSS*)p { return [self dictionaryWithContentsOfFile:p]; }

- (NSS*) flattenedString {
  return [self reduce:^id(id memo, id key, id value) { 
    [memo appendFormat:@"%@ : %@.\n", key,  ISA(value,NSA) ? [value componentsJoinedByString:@", "] : 
                                            ISA(value,NSD) ? [value flattenedString] : 
                                            ISA(value,NSS) ? value : [value description]]; return memo;
  } withInitialMemo:NSMS.new];
}
- (VAL*) newVal { return [self vFK:@"new"]; }
- (VAL*) oldVal { return [self vFK:@"old"]; }
- (NSN*) newNum { return [self numberForKey:@"new"]; }
- (NSN*) oldNum { return [self numberForKey:@"old"]; }


- (NSA*) mapToArray:(id(^)(id k,id v))blk {

	__block NSMA *a = NSMA.new;
	[self enumerateEachKeyAndObjectUsingBlock:^(id key, id obj) {
    id x = blk(key, obj); if (x); [a addObject:x];
	}];
	return a;
}
//+ (NSD*) mapDict:(NSD*) dict withBlock:(Obj_ObjObjBlk) block {
//	else {	for (id key in dict) {id obj = [dict objectForKey:key];[mutDict setValue:block(key, obj) forKey:key];	}}
// [NSDictionary dictionaryWithDictionary:mutDict];

-(void)eachWithIndex:(void (^)(id key, id value, NSUI idx, BOOL *stop))block;	{
	[self.allKeys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		block (obj, self[obj], idx, *stop);
	}];
}
//- (NSA*) recursiveObjectsForKey:(NSS*)key;
//{
//	__block NSMA *bag = [NSMA array];
//   if([self.allKeys containsObject:key]) {
//		// this dictionary contains the key, return the value
//		return [self objectForKey:key];
//	}
//
//	for(NSString *k in self.allKeys) {
//		id obj = [self objectForKey:k];
//		if([obj ISADICT]) {
//			// we found a child dictionary, let's traverse it
//			NSDictionary *d = (NSD*)obj;
//			id child = [d recursiveObjectForKey:key];
//			if(child) return child;
//		} else if([obj isKindOfClass:[NSArray class]]) {
//			// loop through the NSArray and traverse any dictionaries found
//			NSArray *a = (NSA*)obj;
//			for(id child in a) {
//				if([child ISADICT]) {
//					NSDictionary *d = (NSD*)child;
//					id o = [d recursiveObjectForKey:key];
//					if(o) return o;
//				}
//			}
//		}
//	}
//
//	// the key was not found in this dictionary or any of it's children
//	return nil;
//
//
//}


- (NSS*) keyForValueOfClass:(Class)klass {

	return [self.allKeys filterOne:^BOOL(id object) {
		return [self[object] ISKINDA:klass];
	}];
}

//- (id) key: x {
//
//	if([self.allKeys containsObject:key]) {
//		// this dictionary contains the key, return the value
//		return [self objectForKey:key];
//	}
//	for(NSString *k in self.allKeys) {
//		id obj = [self objectForKey:k];
//		if([obj ISADICT]) {
//			// we found a child dictionary, let's traverse it
//			NSDictionary *d = (NSD*)obj;
//			id child = [d recursiveObjectForKey:key];
//			if(child) return child;
//		} else if([obj isKindOfClass:[NSArray class]]) {
//			// loop through the NSArray and traverse any dictionaries found
//			NSArray *a = (NSA*)obj;
//			for(id child in a) {
//				if([child ISADICT]) {
//					NSDictionary *d = (NSD*)child;
//					id o = [d recursiveObjectForKey:key];
//					if(o) return o;
//				}
//			}
//		}
//	}
//	// the key was not found in this dictionary or any of it's children
//	return nil;
//
//}
/* fierce */
- (id) recursiveObjectForKey:(NSS*)key {

	if([self.allKeys containsObject:key]) {
		// this dictionary contains the key, return the value
		return [self objectForKey:key];
	}
	for(NSString *k in self.allKeys) {
		id obj = [self objectForKey:k];
		if([obj ISADICT]) {
			// we found a child dictionary, let's traverse it
			NSDictionary *d = (NSD*)obj;
			id child = [d recursiveObjectForKey:key];
			if(child) return child;
		} else if([obj isKindOfClass:[NSArray class]]) {
			// loop through the NSArray and traverse any dictionaries found
			NSArray *a = (NSA*)obj;
			for(id child in a) {
				if([child ISADICT]) {
					NSDictionary *d = (NSD*)child;
					id o = [d recursiveObjectForKey:key];
					if(o) return o;
				}
			}
		}
	}
	// the key was not found in this dictionary or any of it's children
	return nil;
}

//- _Void_ recursiveObjectForKey:(NSS*)key rootBlock:(void(^)(id root))block {                                  // IN PROGRESS
//
//  id x = nil;
//	if((x = [self objectForKey:key])) {
//		// this dictionary contains the key, return the value
//		[results addObject:AZKPMake(key, x)];
//	}
//	for(NSString *k in self.allKeys) {
//		id obj = [self objectForKey:k];
//		if([obj ISADICT]) {
//			// we found a child dictionary, let's traverse it
//			NSDictionary *d = (NSD*)obj;
//			id child = [d recursiveObjectForKey:key];
//			if(child) return child;
//		} else if([obj isKindOfClass:[NSArray class]]) {
//			// loop through the NSArray and traverse any dictionaries found
//			NSArray *a = (NSA*)obj;
//			for(id child in a) {
//				if([child ISADICT]) {
//					NSDictionary *d = (NSD*)child;
//					id o = [d recursiveObjectForKey:key];
//					if(o) return o;
//				}
//			}
//		}
//	}
//	// the key was not found in this dictionary or any of it's children
//	return nil;
//}
//


- (NSD*)findDictionaryWithValue: value	{ __block id match = nil;

	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		*stop = (!!(match = [obj isEqual:value] ? self  :	ISA(obj,NSA) || ISA(obj,self.class)	? [obj findDictionaryWithValue:value] : nil));
	}];
	return match;
}
// NSDictionary *resultDict = [self findDictionaryForValue:@"i'm an id" inArray:array];

+ (NSDictionary*) dictionaryWithValue: value forKeys:(NSA*)keys	{
	__block NSMutableDictionary *dict = [NSMutableDictionary new];
	[keys each:^(id obj) { dict[obj] = value; }];
	return dict;
}
- (NSDictionary*) dictionaryWithValue: value forKeys:(NSA*)keys	{
	__block NSMutableDictionary *dict = self.mutableCopy;
	[keys each:^(id obj) { dict[obj] = value; }];
	return dict;
}
- (NSDictionary*) dictionaryWithValue: value forKey: key	{
	// Would be nice to make our own dictionary subclass that made this
	// more efficient.
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
	[dict setValue:value forKey:key];
	return dict;
}
- (NSDictionary*) dictionaryWithoutKey: key	{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
	[dict removeObjectForKey:key];
	return dict;
}
- (NSDictionary*) dictionaryWithKey: newKey replacingKey: oldKey;	{
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self];
	id value = dict[oldKey];
	if (value != nil) {
		[dict removeObjectForKey:oldKey];
		[dict setObject:value forKey:newKey];
	}
	return dict;
}
- _Void_ enumerateEachKeyAndObjectUsingBlock:(void(^)(id key, id obj))block{
	NSParameterAssert(block != nil);
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
		block(key, obj);
	}];
}
- _Void_ enumerateEachSortedKeyAndObjectUsingBlock:(void(^)(id key, id obj, NSUInteger idx))block{
	NSParameterAssert(block != nil);
	NSArray *keys = [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
	[keys enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		block(obj, [self objectForKey:obj], idx);
	}];
}
/*
- _Void_ obtainKeyPaths: val intoArray:(NSMutableArray*)arr withString:(NSString*)s {
    if ([val isKindOfClass:[NSDictionary class]]) {
        for (id aKey in [val allKeys]) {
            NSString* path = 
                (!s ? aKey : [NSString stringWithFormat:@"%@.%@", s, aKey]);
            [arr addObject: path];
            [self obtainKeyPaths: [val objectForKey:aKey] 
                       intoArray: arr
                      withString: path];
        }
    }
}

- (NSA*)allKeyPaths {

	return [self.allKeys reduce:@"" withBlock:^id(id sum, id obj) {
		NSString* path = (!s ? aKey : [NSString stringWithFormat:@"%@.%@", s, aKey]);
//            [arr addObject: path];
//            [self obtainKeyPaths: [val objectForKey:aKey]
//                       intoArray: arr
//                      withString: path];
		]
}*/
@end
// This horrible hack is hereby placed in the public domain. I recommend never using it for anything.
#if 0
#define LOG NSLog
#else
#define LOG(...) do {} while (0)
#endif
static NSString *PropertyNameFromSetter(NSString *setterName)	{
	setterName = [setterName substringFromIndex:3];				// Remove "set"
	NSString *firstChar = [[setterName substringToIndex:1] lowercaseString];
	NSString *tail = [setterName substringFromIndex:1];
	tail = [tail substringToIndex:[tail length] - 1];		// Remove ":"
	return [firstChar stringByAppendingString:tail];		// Convert first char to lowercase.
}
static id DynamicDictionaryGetter(id self, SEL _cmd)	{
	return self[NSStringFromSelector(_cmd)];
}
static void DynamicDictionarySetter(id self, SEL _cmd, id value)	{
	NSString *key = PropertyNameFromSetter(NSStringFromSelector(_cmd));
	if (value == nil)		[self removeObjectForKey:key]; else self[key] = value;
}
@implementation NSDictionary (DynamicAccessors)

+ (BOOL) resolveInstanceMethod:(SEL)sel	{	

		// Only handle selectors with no colon.
		return  [NSStringFromSelector(sel) rangeOfString:@":"].location == NSNotFound
		?	fprintf(stdout,"Generating dynamic NSD object accessor for key %s.\n",NSStringFromSelector(sel).UTF8String),
			class_addMethod(self, sel, (IMP)DynamicDictionaryGetter, @encode(id(*)(id, SEL)))
		:	fprintf(stdout,"Couldn't resove:%s Leaving this one to super!\n",NSStringFromSelector(sel).UTF8String), 
      [super resolveInstanceMethod:sel];
}
@end
/**
 @interface NSDictionary (MyProperties)
 @property (retain) NSString *stringProp;
 @property (retain) NSNumber *numberProp;
 @end
 NSMD *dict = [NSMD dictionary];
 dict.stringProp = @"This is a string";
 dict.numberProp = @42;
	*/
@implementation NSMutableDictionary (DynamicAccessors)
+ (BOOL)resolveInstanceMethod:(SEL)sel	{
	NSString *selStr = NSStringFromSelector(sel);
	// Only handle selectors beginning with "set", ending with a colon and with no intermediate colons.
	// Also, to simplify PropertyNameFromSetter, we requre a length of at least 5 (2 + "set").
	if ([selStr hasPrefix:@"set"] &&
		[selStr hasSuffix:@":"] &&
		[selStr rangeOfString:@":" options:0 range:NSMakeRange(0, [selStr length] - 1)].location == NSNotFound &&
		[selStr length] >= 6)
	{
		LOG(@"Generating dynamic accessor -%@ for property \"%@\"", selStr, PropertyNameFromSetter(selStr));
		return class_addMethod(self, sel, (IMP)DynamicDictionarySetter, @encode(id(*)(id, SEL, id)));
	}
	else
	{
		return [super resolveInstanceMethod:sel];
	}
}
@end
#include <stdlib.h>
#if !defined(TARGET_OS_IPHONE) || !TARGET_OS_IPHONE
#define CGPointValue pointValue
#define CGRectValue rectValue
#define CGSizeValue sizeValue
#else
#import <UIKit/UIGeometry.h>
#define NSPointFromString CGPointFromString
#define NSRectFromString CGRectFromString
#define NSSizeFromString CGSizeFromString
#define NSZeroPoint CGPointZero
#define NSZeroSize CGSizeZero
#define NSZeroRect CGRectZero
#endif
#define SAFE_ALLOCA_SIZE (8 * 8192)
@implementation NSDictionary (OFExtensions)
- (id)anyObject;	{
	for (NSString *key in self)
		return self[key];
	return nil;
}
/*" Returns an object which is a shallow copy of the receiver except that the given key now maps to anObj. anObj may be nil in order to remove the given key from the dictionary. "*/
- (NSD*)dictionaryWithObject: anObj forKey:(NSS*)key;	{
	NSUInteger keyCount = [self count];
	if (keyCount == 0 || (keyCount == 1 && self[key] != nil))
		return anObj ? @{key: anObj} : @{};
	if (self[key] == anObj)
		return [NSDictionary dictionaryWithDictionary:self];
	NSMutableArray *newKeys = [NSMutableArray.alloc initWithCapacity:keyCount+1];
	NSMutableArray *newValues = [NSMutableArray.alloc initWithCapacity:keyCount+1];
	for (NSString *aKey in self) {
		if (![aKey isEqual:key]) {
			[newKeys addObject:aKey];
			[newValues addObject:self[aKey]];
		}
	}
	if (anObj != nil) {
		[newKeys addObject:key];
		[newValues addObject:anObj];
	}
	NSDictionary *result = [NSDictionary dictionaryWithObjects:newValues forKeys:newKeys];
//	[newKeys release];
//	[newValues release];
	return result;
}
/*" Returns an object which is a shallow copy of the receiver except that the key-value pairs from aDictionary are included (overriding existing key-value associations if they existed). "*/
//struct dictByAddingContext {
//	id *keys;
//	id *values;
//	NSUInteger kvPairsUsed;
//	BOOL differs;
//	CFDictionaryRef older, newer;
//};
//static void copyWithOverride(const void *aKey, const void *aValue, void *_context)
//{
//	struct dictByAddingContext *context = _context;
//	NSUInteger used = context->kvPairsUsed;
//
//	const void *otherValue = CFDictionaryGetValue(context->newer, aKey);
//	if (otherValue && otherValue != aValue) {
//		context->values[used] = (id)otherValue;
//		context->differs = YES;
//	} else {
//		context->values[used] = (id)aValue;
//	}
//	context->keys[used] = (id)aKey;
//	context->kvPairsUsed = used+1;
//}
//static void copyNewItems(const void *aKey, const void *aValue, void *_context)
//{
//	struct dictByAddingContext *context = _context;
//
//	if(CFDictionaryContainsKey(context->older, aKey)) {
//			// Value will already have been chaecked by copyWithOverride().
//	} else {
//		NSUInteger used = context->kvPairsUsed;
//		context->keys[used] = (id)aKey;
//		context->values[used] = (id)aValue;
//		context->differs = YES;
//		context->kvPairsUsed = used+1;
//	}
//}
//- (NSD*)dictionaryByAddingObjectsFromDictionary:(NSD*)otherDictionary;
//{
//	struct dictByAddingContext context;
//
//	if (!otherDictionary)
//		goto nochange_noalloc;
//
//	NSUInteger myKeyCount = [self count];
//	NSUInteger otherKeyCount = [otherDictionary count];
//
//	if (!otherKeyCount)
//		goto nochange_noalloc;
//
//	context.keys = calloc(myKeyCount+otherKeyCount, sizeof(*(context.keys)));
//	context.values = calloc(myKeyCount+otherKeyCount, sizeof(*(context.values)));
//	context.kvPairsUsed = 0;
//	context.differs = NO;
//	context.older = (CFDictionaryRef)self;
//	context.newer = (CFDictionaryRef)otherDictionary;
//
//	CFDictionaryApplyFunction((CFDictionaryRef)self, copyWithOverride, &context);
//	CFDictionaryApplyFunction((CFDictionaryRef)otherDictionary, copyNewItems, &context);
//	if (!context.differs)
//		goto nochange;
//
//	NSDictionary *newDictionary = [NSDictionary dictionaryWithObjects:context.values forKeys:context.keys count:context.kvPairsUsed];
//	free(context.keys);
//	free(context.values);
//	return newDictionary;
//
//nochange:
//	free(context.keys);
//	free(context.values);
//nochange_noalloc:
//	return [NSDictionary dictionaryWithDictionary:self];
//}
- (NSS*) keyForObjectEqualTo: anObject;	{

  NSD *x = [self findDictionaryWithValue:anObject];
  if (!x) return nil;

  NSEnumerator *enumerator = [self keyEnumerator];
	id key;
	while (key = [enumerator nextObject])
		if ([self objectForKey:key] == anObject) return key;
	return nil;

//    ? [x keyForObjectIdenticalTo:anObject] : nil;
//		if ( isEqual:anObject])//			return key;//	return nil;
}
- (NSS*)stringForKey:(NSS*)key defaultValue:(NSS*)defaultValue;	{
	id object = self[key];
	if (![object isKindOfClass:NSString.class])
		return defaultValue;
	return object;
}
//- (NSS*)stringForKey:(NSS*)key;	{
//	return [self stringForKey:key defaultValue:nil];
//}
- (NSA*)stringArrayForKey:(NSS*)key defaultValue:(NSA*)defaultValue;	{
#ifdef OMNI_ASSERTIONS_ON
	for (id value in defaultValue)
		OBPRECONDITION([value isKindOfClass:NSString.class]);
#endif
	NSArray *array = self[key];
	if (![array isKindOfClass:[NSArray class]])
		return defaultValue;
	for (id value in array) {
		if (![value isKindOfClass:NSString.class])
			return defaultValue;
	}
	return array;
}
- (NSA*)stringArrayForKey:(NSS*)key;	{
	return [self stringArrayForKey:key defaultValue:nil];
}
- (float)floatForKey:(NSS*)key defaultValue:(float)defaultValue;	{
	id value = self[key];
	if (value)
		return [value floatValue];
	return defaultValue;
}
//- (float)floatForKey:(NSS*)key;	{
//	return [self floatForKey:key defaultValue:0.0f];
//}
- (double)doubleForKey:(NSS*)key defaultValue:(double)defaultValue;	{
	id value = self[key];
	if (value)
		return [value doubleValue];
	return defaultValue;
}
- (double)doubleForKey:(NSS*)key;	{
	return [self doubleForKey:key defaultValue:0.0];
}
- (CGPoint)pointForKey:(NSS*)key defaultValue:(CGPoint)defaultValue;	{
	id value = self[key];
	if ([value isKindOfClass:NSString.class] && ![(NSS*)value isEqualToString:@""])
		return NSPointFromString(value);
	else if ([value isKindOfClass:[NSValue class]])
		return [value CGPointValue];
	else
		return defaultValue;
}
//- (CGPoint)pointForKey:(NSS*)key;	{
//	return [self pointForKey:key defaultValue:NSZeroPoint];
//}
- (CGSize)sizeForKey:(NSS*)key defaultValue:(CGSize)defaultValue;	{
	id value = self[key];
	if ([value isKindOfClass:NSString.class] && ![(NSS*)value isEqualToString:@""])
		return NSSizeFromString(value);
	else if ([value isKindOfClass:[NSValue class]])
		return [value CGSizeValue];
	else
		return defaultValue;
}
- (CGSize)sizeForKey:(NSS*)key;	{
	return [self sizeForKey:key defaultValue:NSZeroSize];
}
- (CGRect)rectForKey:(NSS*)key defaultValue:(CGRect)defaultValue;	{
	id value = self[key];
	if ([value isKindOfClass:NSString.class] && ![(NSS*)value isEqualToString:@""])
		return NSRectFromString(value);
	else if ([value isKindOfClass:[NSValue class]])
		return [value CGRectValue];
	else
		return defaultValue;
}
- (CGRect)rectForKey:(NSS*)key;	{
	return [self rectForKey:key defaultValue:NSZeroRect];
}
/* Conflict COcoatechcore
- (BOOL)boolForKey:(NSS*)key defaultValue:(BOOL)defaultValue;	{
	id value = self[key];
	if ([value isKindOfClass:NSString.class] || [value isKindOfClass:[NSNumber class]])
		return [value boolValue];
	return defaultValue;
}
- (BOOL)boolForKey:(NSS*)key;	{
	return [self boolForKey:key defaultValue:NO];
}

- (int)intForKey:(NSS*)key defaultValue:(int)defaultValue;	{
	id value = self[key];
	if (!value)
		return defaultValue;
	return [value intValue];
}
- (int)intForKey:(NSS*)key;	{	return [self intForKey:key defaultValue:0];} */

- (unsigned int)unsignedIntForKey:(NSS*)key defaultValue:(unsigned int)defaultValue;	{
	id value = self[key];
	if (value == nil)
		return defaultValue;
	return [value unsignedIntValue];
}
- (unsigned int)unsignedIntForKey:(NSS*)key;	{
	return [self unsignedIntForKey:key defaultValue:0];
}
- (unsigned long long int)unsignedLongLongForKey:(NSS*)key defaultValue:(unsigned long long int)defaultValue;	{
	id value = self[key];
	if (value == nil)
		return defaultValue;
	return [value unsignedLongLongValue];
}
- (unsigned long long int)unsignedLongLongForKey:(NSS*)key;	{
	return [self unsignedLongLongForKey:key defaultValue:0ULL];
}
- (NSInteger)integerForKey:(NSS*)key defaultValue:(NSInteger)defaultValue;	{
	id value = self[key];
	if (!value)
		return defaultValue;
	return [value integerValue];
}
- (NSInteger)integerForKey:(NSS*)key;	{
	return [self integerForKey:key defaultValue:0];
}
/* COnflicts cocoatechcore
- (id)objectForKey:(NSS*)key defaultObject: defaultObject;	{
	id value = self[key];
	if (value)
		return value;
	return defaultObject;
}

- (NSMD*)deepMutableCopy;	{
	NSMutableDictionary *newDictionary = [self mutableCopy];
	// Run through the new dictionary and replace any objects that respond to -deepMutableCopy or -mutableCopy with copies.
	for (id aKey in self) {
		id anObject = newDictionary[aKey];
		if ([anObject respondsToSelector:@selector(deepMutableCopy)]) {
			anObject = [(NSD*)anObject deepMutableCopy];
			newDictionary[aKey] = anObject;
//			[anObject release];
		} else if ([anObject conformsToProtocol:@protocol(NSMutableCopying)]) {
			anObject = [anObject mutableCopy];
			newDictionary[aKey] = anObject;
//			[anObject release];
		} else
			newDictionary[aKey] = anObject;
	}
	return newDictionary;
}
*/
@end
@implementation NSDictionary (OFDeprecatedExtensions)
- valueForKey:(NSS*)key defaultValue: defaultValue;	{ return [self objectForKey:key] ?: defaultValue; }
@end

@implementation NSCountedSet (Votes)
- (id)winner {
	id winner = nil ;
	NSInteger highestCount = 0 ;
	for (id object in self) {
		NSInteger count = [self countForObject:object] ;
		if (count > highestCount) {
			highestCount = count ;
			winner = object ;
		}
		else if (count == highestCount) {
			winner = nil ;
		}
	}
	return winner ;
}
@end

@implementation NSArray (Subdictionaries)
//- (NSBag*) ojectsInSubdictionariesForKey: key
//{
//	__block NSBag* objects = [NSBag bag];
//	[self eac
//		id object = [subdictionary objectForKey:key] ;
//		if (object) {
//			[objects addObject:object] ;	}
//		else if (defaultObject) { 	[objects addObject:defaultObject] ; }
//	}
//	return objects ;
//}
//	__block NSBag* objects = [NSBag bag];
//	[self each:^(id obj) {
//		if ([obj ISADICT]){
//			[(NSD*)obj objectsInSubdictionariesForKey:key withBag:objects]
//		id object = [obj objectForKey:key] ;
//		if (object) [objects add:object];
//	}];	//		else if (defaultObject) {		[objects add:defaultObject] ;	}	}
//	return objects ;
//}
@end
@implementation NSDictionary (Subdictionaries)
- (NSCountedSet*)objectsInSubdictionariesForKey: key
								  defaultObject: defaultObject {
	NSCountedSet* objects = [NSCountedSet set] ;
	for (NSDictionary* subdictionary in [self allValues]) {
		id object = [subdictionary objectForKey:key] ;
		if (object) {
			[objects addObject:object] ;
		}
		else if (defaultObject) {
			[objects addObject:defaultObject] ;
		}
	}
	return objects ;
}
@end
@implementation NSDictionary (SimpleMutations)
- (NSDictionary*)dictionaryBySettingValue: value
								   forKey: key {
	if (!key) {
		return [NSDictionary dictionaryWithDictionary:self] ;
	}
	NSMutableDictionary* mutant = [self mutableCopy] ;
	[mutant setValue:value
			  forKey:key] ;
	NSDictionary* newDic = [NSDictionary dictionaryWithDictionary:mutant] ;
//	[mutant release] ;
	return newDic ;
}
- (NSDictionary*)dictionaryByAddingEntriesFromDictionary:(NSDictionary*)otherDic {
	NSMutableDictionary* mutant = [self mutableCopy] ;
	if (otherDic) {
		[mutant addEntriesFromDictionary:otherDic] ;
	}
	NSDictionary* newDic = [NSDictionary dictionaryWithDictionary:mutant] ;
//	[mutant release] ;
	return newDic ;
}
- (NSDictionary*)dictionaryByAppendingEntriesFromDictionary:(NSDictionary*)otherDic {
	NSMutableDictionary* mutant = [self mutableCopy] ;
	for (id key in otherDic) {
		if ([self objectForKey:key] == nil) {
			[mutant setObject:[otherDic objectForKey:key]
					   forKey:key] ;
		}
	}
	NSDictionary* newDic = [NSDictionary dictionaryWithDictionary:mutant] ;
//	[mutant release] ;
	return newDic ;
}
+ (void)mutateAdditions:(NSMutableDictionary*)additions
			  deletions:(NSMutableSet*)deletions
		   newAdditions:(NSMutableDictionary*)newAdditions
		   newDeletions:(NSMutableSet*)newDeletions {
	NSSet* immuterator ;
	// Remove from newAdditions and newDeletions any members
	// in these new inputs which cancel one another out
	immuterator = [NSSet.alloc initWithArray:[newAdditions allKeys]] ;
	for (id key in immuterator) {
		id member = [newDeletions member:key] ;
		if (member) {
			[newAdditions removeObjectForKey:key] ;
			[newDeletions removeObject:member] ;
		}
	}
//	[immuterator release] ;
	// Remove from newAdditions any which cancel out existing deletions,
	// and do the cancellation
	immuterator = [NSSet.alloc initWithArray:[newAdditions allKeys]] ;
	for (id key in immuterator) {
		id member = [deletions member:key] ;
		if (member) {
			[newAdditions removeObjectForKey:key] ;
			[deletions removeObject:member] ;
		}
	}
//	[immuterator release] ;
	// Add surviving new additions to existing additions
	[additions addEntriesFromDictionary:newAdditions] ;
	// Remove from newDeletions any which cancel out existing additions,
	// and do the cancellation
	immuterator = [newDeletions copy] ;
	for (id key in immuterator) {
		id object = [additions objectForKey:key] ;
		if (object) {
			[newDeletions removeObject:key] ;
			[additions removeObjectForKey:key] ;
		}
	}
//	[immuterator release] ;
	// Add surviving new deletions to existing deletions
	[deletions unionSet:newDeletions] ;
}
@end

@implementation NSDictionary (subdictionaryWithKeys)
- (NSDictionary*)subdictionaryWithKeys:(NSArray*)keys {
	//  Probably premature optimization…
	//	if ([[NSSet setWithArray:[self allKeys]] isEqualToSet:[NSSet setWithArray:keys]]) {
	//		return self ;
	//	}
	NSMutableDictionary* mutant = [NSMutableDictionary.alloc init] ;
	for (id key in keys) {
		[mutant setValue:[self objectForKey:key]
				  forKey:key] ;
	}
	NSDictionary* answer = [mutant copy];
//	[mutant release] ;
	return answer ;
}
@end


NSString *jsonIndentString = @"\t"; // Modify this string to change how the output formats.
const int jsonDoNotIndent = -1;
@implementation NSDictionary (BSJSONAdditions)
+ (NSD*)dictionaryWithJSONString:(NSS*)jsonString	{
	NSScanner *scanner = [NSScanner.alloc initWithString:jsonString];
	NSDictionary *dictionary = nil;
	[scanner scanJSONObject:&dictionary];
//	[scanner release];
	return dictionary;
}
- (NSS*)jsonStringValue	{
	return [self jsonStringValueWithIndentLevel:0];
}
@end
@implementation NSDictionary (PrivateBSJSONAdditions)
- (NSS*)jsonStringValueWithIndentLevel:(int)level	{
	NSMutableString *jsonString = NSMutableString.new;
	[jsonString appendString:jsonObjectStartString];
	
	NSEnumerator *keyEnum = [self keyEnumerator];
	NSString *keyString = [keyEnum nextObject];
	NSString *valueString;
	if (keyString != nil) {
		valueString = [self jsonStringForValue:[self objectForKey:keyString] withIndentLevel:level];
		if (level != jsonDoNotIndent) { // indent before each key
			[jsonString appendString:[self jsonIndentStringForLevel:level]];
		}			
		[jsonString appendFormat:@" %@ %@ %@", [self jsonStringForString:keyString], jsonKeyValueSeparatorString, valueString];
	}
	
	while (keyString = [keyEnum nextObject]) {
		valueString = [self jsonStringForValue:[self objectForKey:keyString] withIndentLevel:level]; // TODO bail if valueString is nil? How to bail successfully from here?
		[jsonString appendString:jsonValueSeparatorString];
		if (level != jsonDoNotIndent) { // indent before each key
			[jsonString appendFormat:@"%@", [self jsonIndentStringForLevel:level]];
		}
		[jsonString appendFormat:@" %@ %@ %@", [self jsonStringForString:keyString], jsonKeyValueSeparatorString, valueString];
	}
	
	//[jsonString appendString:@"\n"];
	[jsonString appendString:jsonObjectEndString];
	
	return jsonString;// autorelease];
}
- (NSS*)jsonStringForValue: value withIndentLevel:(int)level	{	
	NSString *jsonString;
	if ([value respondsToSelector:@selector(characterAtIndex:)]) // String
		jsonString = [self jsonStringForString:(NSS*)value];
	else if ([value respondsToSelector:@selector(keyEnumerator)]) // Dictionary
		jsonString = [(NSD*)value jsonStringValueWithIndentLevel:(level + 1)];
	else if ([value respondsToSelector:@selector(objectAtIndex:)]) // Array
		jsonString = [self jsonStringForArray:(NSA*)value withIndentLevel:level];
	else if (value == [NSNull null]) // null
		jsonString = jsonNullString;
	else if ([value respondsToSelector:@selector(objCType)]) { // NSNumber - representing true, false, and any form of numeric
		NSNumber *number = (NSN*)value;
		if (((*[number objCType]) == 'c') && ([number boolValue] == YES)) // true
			jsonString = jsonTrueString;
		else if (((*[number objCType]) == 'c') && ([number boolValue] == NO)) // false
			jsonString = jsonFalseString;
		else // attempt to handle as a decimal number - int, fractional, exponential
			// TODO: values converted from exponential json to dict and back to json do not format as exponential again
			jsonString = [[NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]] stringValue];
	} else {
		// TODO: error condition - it's not any of the types that I know about.
		return nil;
	}
	
	return jsonString;
}
- (NSS*)jsonStringForArray:(NSA*)array withIndentLevel:(int)level	{
	NSMutableString *jsonString = NSMutableString.new;
	[jsonString appendString:jsonArrayStartString];
	
	if ([array count] > 0) {
		[jsonString appendString:[self jsonStringForValue:[array objectAtIndex:0] withIndentLevel:level]];
	}
	
	int i;
	for (i = 1; i < [array count]; i++) {
		[jsonString appendFormat:@"%@ %@", jsonValueSeparatorString, [self jsonStringForValue:[array objectAtIndex:i] withIndentLevel:level]];
	}
	
	[jsonString appendString:jsonArrayEndString];
	return jsonString;
}
- (NSS*)jsonStringForString:(NSS*)string	{
	NSMutableString *jsonString = NSMutableString.new;
	[jsonString appendString:jsonStringDelimiterString];
	// Build the result one character at a time, inserting escaped characters as necessary
	int i;
	unichar nextChar;
	for (i = 0; i < [string length]; i++) {
		nextChar = [string characterAtIndex:i];
		switch (nextChar) {
		case '\"':
			[jsonString appendString:@"\\\""];
			break;
		case '\\':
			[jsonString appendString:@"\\n"];
			break;
		/* TODO: email out to json group on this - spec says to handlt his, examples and example code don't handle this.
		case '\/':
			[jsonString appendString:@"\\/"];
			break;
		*/ 
		case '\b':
			[jsonString appendString:@"\\b"];
			break;
		case '\f':
			[jsonString appendString:@"\\f"];
			break;
		case '\n':
			[jsonString appendString:@"\\n"];
			break;
		case '\r':
			[jsonString appendString:@"\\r"];
			break;
		case '\t':
			[jsonString appendString:@"\\t"];
			break;
		/* TODO: Find and encode unicode characters here?
		case '\u':
			[jsonString appendString:@"\\n"];
			break;
		*/
		default:
			[jsonString appendString:[NSString stringWithCharacters:&nextChar length:1]];
			break;
		}
	}
	[jsonString appendString:jsonStringDelimiterString];
	return jsonString;
}
- (NSS*)jsonIndentStringForLevel:(int)level	{
	NSMutableString *indentString = NSMutableString.new;
	if (level != jsonDoNotIndent) {
		[indentString appendString:@"\n"];
		int i;
		for (i = 0; i < level; i++) {
			[indentString appendString:jsonIndentString];
		}
	}
	
	return indentString;
}
@end

NSString *jsonObjectStartString = @"{";
NSString *jsonObjectEndString = @"}";
NSString *jsonArrayStartString = @"[";
NSString *jsonArrayEndString = @"]";
NSString *jsonKeyValueSeparatorString = @":";
NSString *jsonValueSeparatorString = @",";
NSString *jsonStringDelimiterString = @"\"";
NSString *jsonStringEscapedDoubleQuoteString = @"\\\"";
NSString *jsonStringEscapedSlashString = @"\\\\";
NSString *jsonTrueString = @"true";
NSString *jsonFalseString = @"false";
NSString *jsonNullString = @"null";

@implementation NSScanner (PrivateBSJSONAdditions)

- (BOOL)scanJSONObject:(NSDictionary *__autoreleasing*)dictionary	{
	//[self setCharactersToBeSkipped:nil];
	
	BOOL result = NO;
	
	/* START - April 21, 2006 - Updated to bypass irrelevant characters at the beginning of a JSON string */
	NSString *ignoredString;
	[self scanUpToString:jsonObjectStartString intoString:&ignoredString];
	/* END - April 21, 2006 */
	if (![self scanJSONObjectStartString]) {
		// TODO: Error condition. For now, return false result, do nothing with the dictionary handle
	} else {
		NSMutableDictionary *jsonKeyValues = NSMutableDictionary.new;
		NSString *key = nil;
		id value;
		[self scanJSONWhiteSpace];
		while (([self scanJSONString:&key]) && ([self scanJSONKeyValueSeparator]) && ([self scanJSONValue:&value])) {
			[jsonKeyValues setObject:value forKey:key];
			[self scanJSONWhiteSpace];
			// check to see if the character at scan location is a value separator. If it is, do nothing.
			if ([[[self string] substringWithRange:NSMakeRange([self scanLocation], 1)] isEqualToString:jsonValueSeparatorString]) {
				[self scanJSONValueSeparator];
			}
		}
		if ([self scanJSONObjectEndString]) {
			// whether or not we found a key-val pair, we found open and close brackets - completing an object
			result = YES;
			*dictionary = jsonKeyValues;
		}
	}
	return result;
}
- (BOOL) scanJSONArray:(NSArray*__autoreleasing*)array	{

	BOOL result = NO;
	NSMutableArray *values = NSMutableArray.new;
	[self scanJSONArrayStartString];
	id value = nil;
	
	while ([self scanJSONValue:&value]) {
		[values addObject:value];
		[self scanJSONWhiteSpace];
		if ([[self.string substringWithRange:NSMakeRange(self.scanLocation, 1)]
                         isEqualToString:jsonValueSeparatorString])
			[self scanJSONValueSeparator];
	}
	if ([self scanJSONArrayEndString]) {
		result = YES;
		*array = values;
	}
	
	return result;
}
- (BOOL)scanJSONString:(NSString *__autoreleasing*)string	{
	BOOL result = NO;
	if ([self scanJSONStringDelimiterString]) {
		NSMutableString *chars = NSMutableString.new;
		NSString *characterFormat = @"%C";
		
		// process character by character until we finish the string or reach another double-quote
		while ((![self isAtEnd]) && ([[self string] characterAtIndex:[self scanLocation]] != '\"')) {
			unichar currentChar = [[self string] characterAtIndex:[self scanLocation]];
			unichar nextChar;
			if (currentChar != '\\') {
				[chars appendFormat:characterFormat, currentChar];
				[self setScanLocation:([self scanLocation] + 1)];
			} else {
				nextChar = [[self string] characterAtIndex:([self scanLocation] + 1)];
				switch (nextChar) {
				case '\"':
					[chars appendString:@"\""];
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				case '\\':
					[chars appendString:@"\\"]; // debugger shows result as having two slashes, but final output is correct. Possible debugger error?
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				/* TODO: json.org docs mention this seq, so does yahoo, but not recognized here by xcode, note from crockford: not a required escape
				case '\/':
					[chars appendString:@"\/"];
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				*/
				case 'b':
					[chars appendString:@"\b"];
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				case 'f':
					[chars appendString:@"\f"];
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				case 'n':
					[chars appendString:@"\n"];
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				case 'r':
					[chars appendString:@"\r"];
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				case 't':
					[chars appendString:@"\t"];
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				case 'u': // unicode sequence - get string of hex chars, convert to int, convert to unichar, append
				{
					[self setScanLocation:([self scanLocation] + 2)]; // advance past '\u'
					NSString *digits = [[self string] substringWithRange:NSMakeRange([self scanLocation], 4)];
					/* START Updated code modified from code fix submitted by Bill Garrison - March 28, 2006 - http://www.standardorbit.net */
					NSScanner *hexScanner = [NSScanner scannerWithString:digits];
					NSString *verifiedHexDigits;
					NSCharacterSet *hexDigitSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEF"];
					if (NO == [hexScanner scanCharactersFromSet:hexDigitSet intoString:&verifiedHexDigits])
						return NO;
					if (4 != [verifiedHexDigits length])
						return NO;
						
					// Read in the hex value
					[hexScanner setScanLocation:0];
					unsigned unicodeHexValue;
					if (NO == [hexScanner scanHexInt:&unicodeHexValue]) {
						return NO;
					}
					[chars appendFormat:characterFormat, unicodeHexValue];
					/* END update - March 28, 2006 */
					[self setScanLocation:([self scanLocation] + 4)];
					break;
				}
				default:
					[chars appendFormat:@"\\%C", nextChar];
					[self setScanLocation:([self scanLocation] + 2)];
					break;
				}
			}
		}
		
		if (![self isAtEnd]) {
			result = [self scanJSONStringDelimiterString];
			*string = chars;
		}
		
		return result;
	
		/* this code is more appropriate if you have a separate method to unescape the found string
			for example, between inputting json and outputting it, it may make more sense to have a category on NSString to perform
			escaping and unescaping. Keeping this code and looking into this for a future update.
		unsigned int searchLength = [[self string] length] - [self scanLocation];
		unsigned int quoteLocation = [[self string] rangeOfString:jsonStringDelimiterString options:0 range:NSMakeRange([self scanLocation], searchLength)].location;
		searchLength = [[self string] length] - quoteLocation;
		while (([[[self string] substringWithRange:NSMakeRange((quoteLocation - 1), 2)] isEqualToString:jsonStringEscapedDoubleQuoteString]) &&
			   (quoteLocation != NSNotFound) &&
			   (![[[self string] substringWithRange:NSMakeRange((quoteLocation -2), 2)] isEqualToString:jsonStringEscapedSlashString])){
			searchLength = [[self string] length] - (quoteLocation + 1);
			quoteLocation = [[self string] rangeOfString:jsonStringDelimiterString options:0 range:NSMakeRange((quoteLocation + 1), searchLength)].location;
		}
		
		*string = [[self string] substringWithRange:NSMakeRange([self scanLocation], (quoteLocation - [self scanLocation]))];
		// TODO: process escape sequences out of the string - replacing with their actual characters. a function that does just this belongs
		// in another class. So it may make more sense to change this whole implementation to just go character by character instead.
		[self setScanLocation:(quoteLocation + 1)];
		*/
		result = YES;
		
	}
	
	return result;
}
- (BOOL)scanJSONValue:(__autoreleasing id *)value	{
	BOOL result = NO;
	
	[self scanJSONWhiteSpace];
	NSString *substring = [[self string] substringWithRange:NSMakeRange([self scanLocation], 1)];
	unsigned int trueLocation = [[self string] rangeOfString:jsonTrueString options:0 range:NSMakeRange([self scanLocation], ([[self string] length] - [self scanLocation]))].location;
	unsigned int falseLocation = [[self string] rangeOfString:jsonFalseString options:0 range:NSMakeRange([self scanLocation], ([[self string] length] - [self scanLocation]))].location;
	unsigned int nullLocation = [[self string] rangeOfString:jsonNullString options:0 range:NSMakeRange([self scanLocation], ([[self string] length] - [self scanLocation]))].location;
	
	if ([substring isEqualToString:jsonStringDelimiterString]) {
		result = [self scanJSONString:value];
	} else if ([substring isEqualToString:jsonObjectStartString]) {
		result = [self scanJSONObject:value];
	} else if ([substring isEqualToString:jsonArrayStartString]) {
		result = [self scanJSONArray:value];
	} else if ([self scanLocation] == trueLocation) {
		result = YES;
		*value = [NSNumber numberWithBool:YES];
		[self setScanLocation:([self scanLocation] + [jsonTrueString length])];
	} else if ([self scanLocation] == falseLocation) {
		result = YES;
		*value = [NSNumber numberWithBool:NO];
		[self setScanLocation:([self scanLocation] + [jsonFalseString length])];
	} else if ([self scanLocation] == nullLocation) {
		result = YES;
		*value = [NSNull null];
		[self setScanLocation:([self scanLocation] + [jsonNullString length])];
	} else if (([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[[self string] characterAtIndex:[self scanLocation]]]) ||
			   ([[self string] characterAtIndex:[self scanLocation]] == '-')){ // check to make sure it's a digit or -
		result =  [self scanJSONNumber:value];
	}
	return result;
}
- (BOOL)scanJSONNumber:(NSNumber *__autoreleasing*)number	{
	NSDecimal decimal;
	BOOL result = [self scanDecimal:&decimal];
	*number = [NSDecimalNumber decimalNumberWithDecimal:decimal];
	return result;
}
- (BOOL)scanJSONWhiteSpace	{
	//NSLog(@"Scanning white space - here are the next ten chars ---%@---", [[self string] substringWithRange:NSMakeRange([self scanLocation], 10)]);
	BOOL result = NO;
	NSCharacterSet *space = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	while ([space characterIsMember:[[self string] characterAtIndex:[self scanLocation]]]) {
		[self setScanLocation:([self scanLocation] + 1)];
		result = YES;
	}
	//NSLog(@"Done Scanning white space - here are the next ten chars ---%@---", [[self string] substringWithRange:NSMakeRange([self scanLocation], 10)]);
	return result;
}
- (BOOL)scanJSONKeyValueSeparator	{
	return [self scanString:jsonKeyValueSeparatorString intoString:nil];
}
- (BOOL)scanJSONValueSeparator	{
	return [self scanString:jsonValueSeparatorString intoString:nil];
}
- (BOOL)scanJSONObjectStartString	{
	return [self scanString:jsonObjectStartString intoString:nil];
}
- (BOOL)scanJSONObjectEndString	{
	return [self scanString:jsonObjectEndString intoString:nil];
}
- (BOOL)scanJSONArrayStartString	{
	return [self scanString:jsonArrayStartString intoString:nil];
}
- (BOOL)scanJSONArrayEndString	{
	return [self scanString:jsonArrayEndString intoString:nil];
}
- (BOOL)scanJSONStringDelimiterString;	{
	return [self scanString:jsonStringDelimiterString intoString:nil];
}
@end
