	//
	//  NSObject+AtoZ.m
	//  AtoZ
	//
	//  Created by Alex Gray on 7/1/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+AtoZ.h"
#import "AtoZ.h"



@implementation NSObject (AssociatedValues)
- (void)setAssociatedValue:(id)value forKey:(NSS*)key {
    [self setAssociatedValue:value forKey:key policy:OBJC_ASSOCIATION_ASSIGN];
}

- (void)setAssociatedValue:(id)value forKey:(NSS*)key policy:(objc_AssociationPolicy)policy {
    objc_setAssociatedObject(self, (__bridge const void *)(key), value, policy);
}

- (id)associatedValueForKey:(NSS*)key {
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}

- (void)removeAssociatedValueForKey:(NSS*)key {
    objc_setAssociatedObject(self, (__bridge const void *)(key), nil, OBJC_ASSOCIATION_ASSIGN);
}

- (void)removeAllAssociatedValues {
    objc_removeAssociatedObjects(self);
}
@end


@implementation NSObject (AutoCoding)

+ (id)objectWithContentsOfFile:(NSS*)filePath
{
		//load the file
    NSData *data = [NSData dataWithContentsOfFile:filePath];

		//attempt to deserialise data as a plist
    id object = nil;
    if (data)
		{
        NSPropertyListFormat format;
        if ([NSPropertyListSerialization respondsToSelector:@selector(propertyListWithData:options:format:error:)])
			{
            object = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:&format error:NULL];
			}
        else
			{
            object = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:NULL];
			}

			//success?
		if (object)
			{
				//check if object is an NSCoded unarchive
			if ([object respondsToSelector:@selector(objectForKey:)] && object[@"$archiver"])
				{
				object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
				}
			}
		else
			{
				//return raw data
			object = data;
			}
		}

		//return object
	return object;
}

- (void)writeToFile:(NSS*)filePath atomically:(BOOL)useAuxiliaryFile
{
		//note: NSData, NSD and NSArray already implement this method
		//and do not save using NSCoding, however the objectWithContentsOfFile
		//method will correctly recover these objects anyway

		//archive object
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToFile:filePath atomically:YES];
}

- (NSArray *)codableKeys
{
    NSMA*array = [NSMA array];
    Class class = [self class];
    while (class != [NSObject class])
		{
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(class, &count);
        for (int i = 0; i < count; i++)
			{
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            NSS*key = @(name);
            [array addObject:key];
			}
        free(properties);
        class = [class superclass];
		}
    [array removeObjectsInArray:[self uncodableKeys]];
    return array;
}

- (NSArray *)uncodableKeys
{
    return nil;
}

- (void)setNilValueForKey:(NSS*)key
{
		//don't throw exception
}

- (void)setWithCoder:(NSCoder *)aDecoder
{
    for (NSS*key in [self codableKeys])
		{
        id object = [aDecoder decodeObjectForKey:key];
        [self setValue:object forKey:key];
		}
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [self init]))
		{
        [self setWithCoder:aDecoder];
		}
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSS*key in [self codableKeys])
		{
        id object = [self valueForKey:key];
        [aCoder encodeObject:object forKey:key];
		}
}

@end

	//
	//  HRCoder.m
	//
	//  Version 1.0
	//
	//  Created by Nick Lockwood on 24/04/2012.
	//  Copyright (c) 2011 Charcoal Design
	//
	//  Distributed under the permissive zlib License
	//  Get the latest version from here:
	//
	//  https://github.com/nicklockwood/HRCoder
	//

@interface NSObject (HRCoding)

- (id)unarchiveObjectWithHRCoder:(HRCoder *)coder;
- (id)archivedObjectWithHRCoder:(HRCoder *)coder;

@end


@implementation HRCoderAliasPlaceholder

+ (HRCoderAliasPlaceholder *)placeholder
{
    static HRCoderAliasPlaceholder *sharedInstance = nil;
    if (sharedInstance == nil)
		{
        sharedInstance = [[self alloc] init];
		}
    return sharedInstance;
}

- (NSS*)description
{
    return [NSString stringWithFormat:@"<%@>", NSStringFromClass([self class])];
}

@end


@interface HRCoder ()

@property (nonatomic, strong) NSMA*stack;
@property (nonatomic, strong) NSMD *knownObjects;
@property (nonatomic, strong) NSMD *unresolvedAliases;
@property (nonatomic, strong) NSS*keyPath;

+ (NSS*)classNameKey;

@end


@implementation HRCoder

@synthesize stack;
@synthesize knownObjects;
@synthesize unresolvedAliases;
@synthesize keyPath;

+ (NSS*)classNameKey
{
		//used by BaseModel
    return HRCoderClassNameKey;
}

- (id)init
{
    if ((self = [super init]))
		{
        stack = [[NSMA alloc] initWithObjects:[NSMD dictionary], nil];
        knownObjects = [[NSMD alloc] init];
        unresolvedAliases = [[NSMD alloc] init];
		}
    return self;
}

+ (id)unarchiveObjectWithPlist:(id)plist
{
    return [AZ_AUTORELEASE([[self alloc] init]) unarchiveObjectWithPlist:plist];
}

+ (id)unarchiveObjectWithFile:(NSS*)path
{
    return [AZ_AUTORELEASE([[self alloc] init]) unarchiveObjectWithFile:path];
}

+ (id)archivedPlistWithRootObject:(id)object
{
    return [AZ_AUTORELEASE([[self alloc] init]) archivedPlistWithRootObject:object];
}

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSS*)path
{
    return [AZ_AUTORELEASE([[self alloc] init]) archiveRootObject:rootObject toFile:path];
}

- (id)unarchiveObjectWithPlist:(id)plist
{
    [stack removeAllObjects];
    [knownObjects removeAllObjects];
    [unresolvedAliases removeAllObjects];
    id rootObject = [plist unarchiveObjectWithHRCoder:self];
    if (rootObject)
		{
        knownObjects[HRCoderRootObjectKey] = rootObject;
        for (NSS*_keyPath in unresolvedAliases)
			{
            id aliasKeyPath = unresolvedAliases[_keyPath];
            id aliasedObject = knownObjects[aliasKeyPath];
            id node = rootObject;
            for (NSS*key in [_keyPath componentsSeparatedByString:@"."])
				{
                id _node = nil;
                if ([node isKindOfClass:[NSArray class]])
					{
                    NSInteger index = [key integerValue];
                    _node = node[index];
                    if (_node == [HRCoderAliasPlaceholder placeholder])
						{
                        node[index] = aliasedObject;
                        break;
						}
					}
                else
					{
                    _node = [node valueForKey:key];
                    if (_node == nil || _node == [HRCoderAliasPlaceholder placeholder])
						{
                        [node setValue:aliasedObject forKey:key];
                        break;
						}
					}
                node = _node;
				}
			}
		}
    [unresolvedAliases removeAllObjects];
    [knownObjects removeAllObjects];
    [stack removeAllObjects];
    return rootObject;
}

- (id)unarchiveObjectWithFile:(NSS*)path
{
		//load the file
    NSData *data = [NSData dataWithContentsOfFile:path];

		//attempt to deserialise data as a plist
    id plist = nil;
    if (data)
		{
        NSPropertyListFormat format;
        NSPropertyListReadOptions options = NSPropertyListMutableContainersAndLeaves;
        plist = [NSPropertyListSerialization propertyListWithData:data options:options format:&format error:NULL];
		}

		//unarchive
    return [self unarchiveObjectWithPlist:plist];
}

- (id)archivedPlistWithRootObject:(id)rootObject
{
    [stack removeAllObjects];
    [knownObjects removeAllObjects];
    knownObjects[HRCoderRootObjectKey] = rootObject;
    id plist = [rootObject archivedObjectWithHRCoder:self];
    [knownObjects removeAllObjects];
    [stack removeAllObjects];
    return plist;
}

- (BOOL)archiveRootObject:(id)rootObject toFile:(NSS*)path
{
    id object = [self archivedPlistWithRootObject:rootObject];
    NSPropertyListFormat format = NSPropertyListBinaryFormat_v1_0;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:object format:format options:0 error:NULL];
    return [data writeToFile:path atomically:YES];
}

- (void)dealloc
{
    AZ_RELEASE(stack);
    AZ_RELEASE(knownObjects);
    AZ_RELEASE(unresolvedAliases);
    AZ_SUPER_DEALLOC;
}

- (BOOL)allowsKeyedCoding
{
    return YES;
}

- (BOOL)containsValueForKey:(NSS*)key
{
    return [stack lastObject][key] != nil;
}

- (id)encodedObject:(id)objv forKey:(NSS*)key
{
    NSInteger knownIndex = [[knownObjects allValues] indexOfObject:objv];
    if (knownIndex != NSNotFound)
		{
			//create alias
        NSS*aliasKeyPath = [knownObjects allKeys][knownIndex];
        NSD *alias = @{HRCoderObjectAliasKey: aliasKeyPath};
        return alias;
		}
    else
		{
			//encode object
        NSS*oldKeyPath = keyPath;
        self.keyPath = keyPath? [keyPath stringByAppendingPathExtension:key]: key;
        knownObjects[keyPath] = objv;
        id encodedObject = [objv archivedObjectWithHRCoder:self];
        self.keyPath = oldKeyPath;
        return encodedObject;
		}
}

- (void)encodeObject:(id)objv forKey:(NSS*)key
{
    id object = [self encodedObject:objv forKey:key];
    [stack lastObject][key] = object;
}

- (void)encodeConditionalObject:(id)objv forKey:(NSS*)key
{
    if ([[knownObjects allValues] containsObject:objv])
		{
        [self encodeObject:objv forKey:key];
		}
}

- (void)encodeBool:(BOOL)boolv forKey:(NSS*)key
{
    [stack lastObject][key] = @(boolv);
}

- (void)encodeInt:(int)intv forKey:(NSS*)key
{
    [stack lastObject][key] = @(intv);
}

- (void)encodeInt32:(int32_t)intv forKey:(NSS*)key
{
    [stack lastObject][key] = [NSNumber numberWithLong:intv];
}

- (void)encodeInt64:(int64_t)intv forKey:(NSS*)key
{
    [stack lastObject][key] = @(intv);
}

- (void)encodeFloat:(float)realv forKey:(NSS*)key
{
    [stack lastObject][key] = @(realv);
}

- (void)encodeDouble:(double)realv forKey:(NSS*)key
{
    [stack lastObject][key] = @(realv);
}

- (void)encodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSS*)key
{
    [stack lastObject][key] = [NSData dataWithBytes:bytesp length:lenv];
}

- (id)decodeObject:(id)object forKey:(NSS*)key
{
    if (object && key)
		{
			//new keypath
        NSS*newKeyPath = keyPath? [keyPath stringByAppendingPathExtension:key]: key;

			//check if object is an alias
        if ([object isKindOfClass:[NSD class]])
			{
            NSS*aliasKeyPath = ((NSD *)object)[HRCoderObjectAliasKey];
            if (aliasKeyPath)
				{
					//object alias
                id decodedObject = knownObjects[aliasKeyPath];
                if (!decodedObject)
					{
                    unresolvedAliases[newKeyPath] = aliasKeyPath;
                    decodedObject = [HRCoderAliasPlaceholder placeholder];
					}
                return decodedObject;
				}
			}

			//new object
        NSS*oldKeyPath = keyPath;
        self.keyPath = newKeyPath;
        id decodedObject = [object unarchiveObjectWithHRCoder:self];
        knownObjects[keyPath] = decodedObject;
        self.keyPath = oldKeyPath;
        return decodedObject;
		}
    return nil;
}

- (id)decodeObjectForKey:(NSS*)key
{
    return [self decodeObject:[stack lastObject][key] forKey:key];
}

- (BOOL)decodeBoolForKey:(NSS*)key
{
    return [[stack lastObject][key] boolValue];
}

- (int)decodeIntForKey:(NSS*)key
{
    return [[stack lastObject][key] intValue];
}

- (int32_t)decodeInt32ForKey:(NSS*)key
{
    return [[stack lastObject][key] longValue];
}

- (int64_t)decodeInt64ForKey:(NSS*)key
{
    return [[stack lastObject][key] longLongValue];
}

- (float)decodeFloatForKey:(NSS*)key
{
    return [[stack lastObject][key] floatValue];
}

- (double)decodeDoubleForKey:(NSS*)key
{
    return [[stack lastObject][key] doubleValue];
}

- (const uint8_t *)decodeBytesForKey:(NSS*)key returnedLength:(NSUInteger *)lengthp
{
    NSData *data = [stack lastObject][key];
    *lengthp = [data length];
    return data.bytes;
}

@end


@implementation NSObject(HRCoding)

- (id)unarchiveObjectWithHRCoder:(HRCoder *)coder
{
    return self;
}

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    NSMD *result = [NSMD dictionary];
    [coder.stack addObject:result];
    result[HRCoderClassNameKey] = NSStringFromClass([self class]);
    [(id <NSCoding>)self encodeWithCoder:coder];
    [coder.stack removeLastObject];
    return result;
}

@end


@implementation NSD(HRCoding)

- (id)unarchiveObjectWithHRCoder:(HRCoder *)coder
{
    NSS*className = self[HRCoderClassNameKey];
    if (className)
		{
			//encoded object
        [coder.stack addObject:self];
        Class class = NSClassFromString(className);
        id object = AZ_AUTORELEASE([[class alloc] initWithCoder:coder]);
        [coder.stack removeLastObject];
        return object;
		}
    else
		{
			//ordinary dictionary
        NSMD *result = [NSMD dictionary];
        for (NSS*key in self)
			{
            id object = [coder decodeObjectForKey:key];
            if (object)
				{
                result[key] = object;
				}
			}
        return AZ_AUTORELEASE([result copy]);
		}
}

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    NSMD *result = [NSMD dictionary];
    [coder.stack addObject:result];
    for (NSS*key in self)
		{
        [coder encodeObject:self[key] forKey:key];
		}
    [coder.stack removeLastObject];
    return result;
}

@end


@implementation NSArray(HRCoding)

- (id)unarchiveObjectWithHRCoder:(HRCoder *)coder
{
    NSMA*result = [NSMA array];
    for (int i = 0; i < [self count]; i++)
		{
        NSS*key = [NSString stringWithFormat:@"%i", i];
        id encodedObject = self[i];
        id decodedObject = [coder decodeObject:encodedObject forKey:key];
        [result addObject:decodedObject];
		}
    return result;
}

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    NSMA*result = [NSMA array];
    for (int i = 0; i < [self count]; i++)
		{
        id object = self[i];
        NSS*key = [NSString stringWithFormat:@"%i", i];
        [result addObject:[coder encodedObject:object forKey:key]];
		}
    return result;
}

@end


@implementation NSString(HRCoding)

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    return self;
}

@end


@implementation NSData(HRCoding)

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    return self;
}

@end


@implementation NSNumber(HRCoding)

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    return self;
}

@end


@implementation NSDate(HRCoding)

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    return self;
}

@end


@implementation NSObject (AtoZ)


- (id)objectForKeyedSubscript:(id)key {
	return  [self respondsToSelector:@selector(key)] ? [self valueForKey:key] : nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
//	[self respondsToSelector:@selector(backingtore
//			   [self respondsToSelector:@selector($(@"set%@", [key uppercaseString]))] ? nil;
}

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    block = [[block copy] autorelease];
    [self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay:(void (^)(void))block { block(); }


- (NSMD*) getDictionary
{
	if (objc_getAssociatedObject(self, @"dictionary")==nil)
		objc_setAssociatedObject(self,@"dictionary",[NSMD dictionary],OBJC_ASSOCIATION_RETAIN);
	return (NSMD *)objc_getAssociatedObject(self, @"dictionary");
}


static char windowPosition;

- (void) setWindowPosition:(AZWindowPosition)pos { objc_setAssociatedObject( self, &windowPosition, @(pos), OBJC_ASSOCIATION_RETAIN ); }

- (AZWindowPosition) windowPosition { return [objc_getAssociatedObject( self, &windowPosition ) intValue]; }

// 	Finds all properties of an object, and prints each one out as part of a string describing the class.
- (NSS*) autoDescribeWithClassType:(Class)classType
{
    unsigned int count;
    objc_property_t *propList 	= class_copyPropertyList(classType, &count);
    NSMutableString *propPrint 	= [NSMutableString string];
    for ( int i = 0; i < count; i++ ) {
        objc_property_t prop 	= propList[i];
        const char *propName 	= property_getName(prop);
        NSS*propNameStr 	= [NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
        if(propName) { id value = [self valueForKey:propNameStr];
					   [propPrint appendString:[NSString stringWithFormat:@"%@=%@ ; ", propNameStr, value]]; }
	}
    free(propList);
	// Now see if we need to map any superclasses as well.
    Class superClass = class_getSuperclass( classType );
    if ( superClass != nil && ! [superClass isEqual:[NSObject class]] ) {
        NSS*superString = [self autoDescribeWithClassType:superClass];
        [propPrint appendString:superString];
	}
    return propPrint;
}

- (NSS*) autoDescribe { return [$(@"%@:%p:: ",[self class], self) stringByAppendingString:[self autoDescribeWithClassType:[self class]]]; }


@end

@implementation NSObject (SubclassEnumeration)

+(NSArray *)subclasses
{
	NSMA*subClasses = [NSMA array];
	Class	*classes	= nil;
	int		count		= objc_getClassList(NULL, 0);

	if (count) {
		classes = (Class*)malloc(sizeof(Class) * count);
		NSAssert (classes != NULL, @"Memory Allocation Failed in [Content +subclasses].");

		(void) objc_getClassList(classes, count);
	}

	if (classes) {
		for (int i=0; i<count; i++) {
			Class myClass    = classes[i];
			Class superClass = class_getSuperclass(myClass);

			if (superClass == self)
				[subClasses addObject:myClass];
		}

		free(classes);
	}

	return subClasses;
}
@end

@implementation NSObject (AG)


- (IBAction)showMethodsInFrameWork:(id)sender {

//	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/say" arguments:@[s]];

		//	BOOL isSelected;	NSS*label;
//	BOOL isSegmented = [sender isKindOfClass:[NSSegmentedControl class]];
//		//	if (isSegmented) {
//	NSInteger selectedSegment = [sender selectedSegment];
//		//		 = [sender isSelectedForSegment:selectedSegment];
//	label = [sender labelForSegment:selectedSegment];
//	BOOL *optionPtr = &isSelected;
//		//	} else
//		//		label = [sender label];
//	SEL fabricated = NSSelectorFromString($(@"set%@:", label));
//	[[sender delegate] performSelector:fabricated withValue:optionPtr];
		//	[[AZTalker sharedInstance] say:$(@"%@ is %@ selected", string, isSelected ? @"" : @"NOT")];
}


- (void)performActionFromSegment:(id)sender {

	BOOL isSelected;	NSS*label;
	BOOL isSegmented = [sender isKindOfClass:[NSSegmentedControl class]];
		//	if (isSegmented) {
	NSInteger selectedSegment = [sender selectedSegment];
		//		 = [sender isSelectedForSegment:selectedSegment];
	label = [sender labelForSegment:selectedSegment];
	BOOL *optionPtr = &isSelected;
		//	} else
		//		label = [sender label];
	SEL fabricated = NSSelectorFromString($(@"set%@:", label));
	[[sender delegate] performSelector:fabricated withValue:optionPtr];
		//	[[AZTalker sharedInstance] say:$(@"%@ is %@ selected", string, isSelected ? @"" : @"NOT")];
}

	//- (BOOL) respondsToSelector: (SEL) aSelector {
	//    NSLog (@"%s", (char *) aSelector);
	//    return ([super respondsToSelector: aSelector]);
	//} // respondsToSelector



static const char * getPropertyType(objc_property_t property) {
	const char *attributes = property_getAttributes(property);
	printf("attributes=%s\n", attributes);
	char buffer[1 + strlen(attributes)];
	strcpy(buffer, attributes);
	char *state = buffer, *attribute;
	while ((attribute = strsep(&state, ",")) != NULL) {
//	If you want a list of what will be returned for these primitives, search online for "objective-c" "Property Attribute Description Examples" apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
			// it's a C primitive type:
		return attribute[0] == 'T' && attribute[1] != '@' ? (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes]
			// it's an ObjC id type:
		: attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2  ? "id"
			// it's another ObjC object type:
		: attribute[0] == 'T' && attribute[1] == '@' ? (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes]
		: "";
	}
}


+ (NSD *)classPropsFor:(Class)klass
{
	if (klass == NULL) return nil;
	NSMD *results = [NSMD dictionary];
	unsigned int outCount, i;
	objc_property_t *properties = class_copyPropertyList(klass, &outCount);
	for (i = 0; i < outCount; i++) {
		objc_property_t property = properties[i];
		const char *propName = property_getName(property);
		if(propName) {
			const char *propType = getPropertyType(property);
			NSS*propertyName = @(propName);
			NSS*propertyType = @(propType);
			results[propertyName] = propertyType;
		}
	}
	free(properties);	return results; 	// returning a copy here to make sure the dictionary is immutable
}

/*
 - (NSArray*) methodDumpForClass:(Class)klass {

 int numClasses;
 Class *classes = NULL;
 classes = NULL;
 numClasses = objc_getClassList(NULL, 0);
 NSLog(@"Number of classes: %d", numClasses);

 if (numClasses > 0 )
 {
 classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
 numClasses = objc_getClassList(classes, numClasses);
 for (int i = 0; i < numClasses; i++) {
 NSLog(@"Class name: %s", class_getName(classes[i]));
 }
 free(classes);
 }

 int numClasses;
 Class *classes = NULL;

 classes = NULL;
 numClasses = objc_getClassList(NULL, 0);

 if (numClasses &lt; 1 ) { return nil; }
 classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
 numClasses = objc_getClassList(classes, numClasses);

 // Convert to NSArray of NSStrings
 NSMA*rtn = [[NSMA alloc] init];
 const char *cname;
 for (int i=0; i&lt;numClasses; i++) {
 cname = class_getName(classes[i]);
 //      if (NULL == strstr(cname, &quot;MusicalScale&quot;))
 //          continue;
 [rtn addObject:[NSString stringWithCString:cname
 encoding:NSStringEncodingConversionAllowLossy]];
 }
 free(classes);

 //    return rtn;
 return [rtn filteredArrayUsingPredicate:predicate];
 }
 */

+ (NSArray*)classMethods {
	const char* className = class_getName([self class]);
	int unsigned numMethods;
	NSMA *ii = [NSMA array];
	Method *methods = class_copyMethodList(objc_getMetaClass(className), &numMethods);
	for (int i = 0; i < numMethods; i++) {
		[ii addObject:NSStringFromSelector(method_getName(methods[i]))];
//	    NSLog(@"%@", NSStringFromSelector(method_getName(methods[i])));
	}
	return ii.copy;
}	

	// aps suffix to avoid namespace collsion
	//   ...for Andrew Paul Sardone
	//- (NSD *)propertiesDictionariate;

- (NSD*)propertiesSans:(NSS*)someKey { return [[self propertiesPlease] filter:^BOOL(id key,id value) { return [key isNotEqualTo:someKey] ? YES : NO; }]; }

- (NSD *)propertiesPlease {	NSMD *props = [NSMD dictionary];	unsigned int outCount, i;
										objc_property_t *properties = class_copyPropertyList([self class], &outCount);
	for (i = 0; i < outCount; i++) {	objc_property_t property = properties[i];
		NSS*propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
		id propertyValue = [self valueForKey:(NSS*)propertyName];
		if (propertyValue) props[propertyName] = propertyValue;
	}
	free(properties);
	return props;
}



- (NSS*)stringFromClass {	return NSStringFromClass( [self class]); }

- (void)setIntValue:(NSInteger)i forKey:(NSS*)key { [self setValue:[NSNumber numberWithInt:i] forKey:key]; }

-(void)setIntValue:(NSInteger)i forKeyPath:(NSS*)keyPath { [self setValue:[NSNumber numberWithInt:i] forKeyPath:keyPath]; }

-(void)setFloatValue:(CGFloat)f forKey:(NSS*)key {[self setValue:[NSNumber numberWithFloat:f] forKey:key]; }

-(void)setFloatValue:(CGFloat)f forKeyPath:(NSS*)keyPath {	[self setValue:[NSNumber numberWithFloat:f] forKeyPath:keyPath]; }

-(BOOL)isEqualToAnyOf:(id<NSFastEnumeration>)enumerable {	for (id o in enumerable) { if ([self isEqual:o]) return YES; } return NO; }

-(void)fire:(NSS*)notificationName { [AZNOTCENTER postNotificationName:notificationName object:self]; }

-(void)fire:(NSS*)notificationName userInfo:(NSD *)context {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:notificationName object:self userInfo:context];
}


-(id)observeObject:(NSS*)notificationName
	  usingBlock:(void (^)(NSNotification *))block
{
	return [AZNOTCENTER addObserverForName:notificationName
									object:self
									 queue:nil
								usingBlock:block];
}


-(id)observeName:(NSS*)notificationName
	  usingBlock:(void (^)(NSNotification *))block
{
	return [AZNOTCENTER addObserverForName:notificationName
						   object:self
							queue:nil
					   usingBlock:block];
}

-(void)observeObject:(NSObject *)object
			 forName:(NSS*)notificationName
			 calling:(SEL)selector
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:selector
			   name:notificationName
			 object:object];
}


-(void)observeName:(NSS*)notificationName
		   calling:(SEL)selector
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self
		   selector:selector
			   name:notificationName
			 object:nil];
}


-(void)stopObserving:(NSObject *)object forName:(NSS*)notificationName {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:notificationName object:object];
}


- (void) performSelectorWithoutWarnings:(SEL)aSelector withObject:(id)obj{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[self performSelector:aSelector withObject:obj];
#pragma clang diagnostic pop
}



-(void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)seconds {
	[self performSelector:aSelector withObject:nil afterDelay:seconds];
}

-(void)addObserver:(NSObject *)observer forKeyPath:(NSS*)keyPath {
	[self addObserver:observer
		   forKeyPath:keyPath
			  options:0
			  context:nil
	 ];
}

-(void)addObserver:(NSObject *)observer
	   forKeyPaths:(id<NSFastEnumeration>)keyPaths
{
	for (NSS*keyPath in keyPaths) {
		[self addObserver:observer forKeyPath:keyPath];
	}
}

-(void)removeObserver:(NSObject *)observer
		  forKeyPaths:(id<NSFastEnumeration>)keyPaths
{
	for (NSS*keyPath in keyPaths) {
		[self removeObserver:observer forKeyPath:keyPath];
	}
}

-(void)willChangeValueForKeys:(id<NSFastEnumeration>)keys {	for (id key in keys) [self willChangeValueForKey:key];  }

-(void)didChangeValueForKeys:(id<NSFastEnumeration>)keys { for (id key in keys)		[self didChangeValueForKey:key]; }

- (NSD*) dictionaryWithValuesForKeys { return [self dictionaryWithValuesForKeys:[self allKeys]]; }

- (NSArray *) allKeys {	Class clazz = [self class];	 u_int count;
	objc_property_t* properties 	= class_copyPropertyList(clazz, &count);
	NSMA* propertyArray = [NSMA arrayWithCapacity:count];
	for (int i = 0; i < count ; i++) {
		const char* propertyName = property_getName(properties[i]);
		[propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
	}
	free(properties);
	return [NSArray arrayWithArray:propertyArray];
}

- (void)setClass:(Class)aClass {	NSAssert( class_getInstanceSize([self class]) == class_getInstanceSize(aClass),
			 									@"Classes must be the same size to swizzle.");
	object_setClass(self, aClass);
}

	// In your custom class
+ (id)customClassWithProperties:(NSD *)properties {
	return [[[self alloc] initWithProperties:properties] autorelease];
}

- (id)initWithProperties:(NSD *)properties {
	if (self = [self init]) {
		[self setValuesForKeysWithDictionary:properties];
	}
	return self;
}


@end


@implementation NSObject (PrimitiveEvocation)

- (void *)performSelector:(SEL)selector withValue:(void *)value {
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
	[invocation setSelector:selector];
	[invocation setTarget:self];
	[invocation setArgument:value atIndex:2];
	[invocation invoke];
	NSUInteger length = [[invocation methodSignature] methodReturnLength];

	if (length > 0) {		// If method is non-void:
		void *buffer = (void *)malloc(length);
		[invocation getReturnValue:buffer];
		return buffer;
	}
	return NULL;			// If method is void:

}
@end

@implementation NSD (PropertyMap)

- (void)mapPropertiesToObject:(id)instance	{
	for (NSS* propertyKey in [self allKeys])	{
		[instance setValue:[self objectForKey:propertyKey]	forKey:propertyKey];
	}
}
@end
