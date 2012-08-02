//
//  NSObject+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSObject+AtoZ.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "AtoZ.h"


@implementation NSObject (AutoCoding)

+ (id)objectWithContentsOfFile:(NSString *)filePath
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
			if ([object respondsToSelector:@selector(objectForKey:)] && [object objectForKey:@"$archiver"])
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

- (void)writeToFile:(NSString *)filePath atomically:(BOOL)useAuxiliaryFile
{
    //note: NSData, NSDictionary and NSArray already implement this method
    //and do not save using NSCoding, however the objectWithContentsOfFile
    //method will correctly recover these objects anyway
    
    //archive object
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToFile:filePath atomically:YES];
}

- (NSArray *)codableKeys
{
    NSMutableArray *array = [NSMutableArray array];
    Class class = [self class];
    while (class != [NSObject class])
    {
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList(class, &count);
        for (int i = 0; i < count; i++)
        {
            objc_property_t property = properties[i];
            const char *name = property_getName(property);
            NSString *key = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
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

- (void)setNilValueForKey:(NSString *)key
{
    //don't throw exception
}

- (void)setWithCoder:(NSCoder *)aDecoder
{
    for (NSString *key in [self codableKeys])
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
    for (NSString *key in [self codableKeys])
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@>", NSStringFromClass([self class])];
}

@end


@interface HRCoder ()

@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) NSMutableDictionary *knownObjects;
@property (nonatomic, strong) NSMutableDictionary *unresolvedAliases;
@property (nonatomic, strong) NSString *keyPath;

+ (NSString *)classNameKey;

@end


@implementation HRCoder

@synthesize stack;
@synthesize knownObjects;
@synthesize unresolvedAliases;
@synthesize keyPath;

+ (NSString *)classNameKey
{
    //used by BaseModel
    return HRCoderClassNameKey;
}

- (id)init
{
    if ((self = [super init]))
    {
        stack = [[NSMutableArray alloc] initWithObjects:[NSMutableDictionary dictionary], nil];
        knownObjects = [[NSMutableDictionary alloc] init];
        unresolvedAliases = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id)unarchiveObjectWithPlist:(id)plist
{
    return [AZ_AUTORELEASE([[self alloc] init]) unarchiveObjectWithPlist:plist];
}

+ (id)unarchiveObjectWithFile:(NSString *)path
{
    return [AZ_AUTORELEASE([[self alloc] init]) unarchiveObjectWithFile:path];
}

+ (id)archivedPlistWithRootObject:(id)object
{
    return [AZ_AUTORELEASE([[self alloc] init]) archivedPlistWithRootObject:object];
}

+ (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path
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
        [knownObjects setObject:rootObject forKey:HRCoderRootObjectKey];
        for (NSString *_keyPath in unresolvedAliases)
        {
            id aliasKeyPath = [unresolvedAliases objectForKey:_keyPath];
            id aliasedObject = [knownObjects objectForKey:aliasKeyPath];
            id node = rootObject;
            for (NSString *key in [_keyPath componentsSeparatedByString:@"."])
            {
                id _node = nil;
                if ([node isKindOfClass:[NSArray class]])
                {
                    NSInteger index = [key integerValue];
                    _node = [node objectAtIndex:index];
                    if (_node == [HRCoderAliasPlaceholder placeholder])
                    {
                        [node replaceObjectAtIndex:index withObject:aliasedObject];
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

- (id)unarchiveObjectWithFile:(NSString *)path
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
    [knownObjects setObject:rootObject forKey:HRCoderRootObjectKey];
    id plist = [rootObject archivedObjectWithHRCoder:self];
    [knownObjects removeAllObjects];
    [stack removeAllObjects];
    return plist;
}

- (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path
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

- (BOOL)containsValueForKey:(NSString *)key
{
    return [[stack lastObject] objectForKey:key] != nil;
}

- (id)encodedObject:(id)objv forKey:(NSString *)key
{
    NSInteger knownIndex = [[knownObjects allValues] indexOfObject:objv];
    if (knownIndex != NSNotFound)
    {
        //create alias
        NSString *aliasKeyPath = [[knownObjects allKeys] objectAtIndex:knownIndex];
        NSDictionary *alias = [NSDictionary dictionaryWithObject:aliasKeyPath forKey:HRCoderObjectAliasKey];
        return alias;
    }
    else
    {
        //encode object
        NSString *oldKeyPath = keyPath;
        self.keyPath = keyPath? [keyPath stringByAppendingPathExtension:key]: key;
        [knownObjects setObject:objv forKey:keyPath];
        id encodedObject = [objv archivedObjectWithHRCoder:self];
        self.keyPath = oldKeyPath;
        return encodedObject;
    }
}

- (void)encodeObject:(id)objv forKey:(NSString *)key
{
    id object = [self encodedObject:objv forKey:key];
    [[stack lastObject] setObject:object forKey:key];
}

- (void)encodeConditionalObject:(id)objv forKey:(NSString *)key
{
    if ([[knownObjects allValues] containsObject:objv])
    {
        [self encodeObject:objv forKey:key];
    }
}

- (void)encodeBool:(BOOL)boolv forKey:(NSString *)key
{
    [[stack lastObject] setObject:[NSNumber numberWithBool:boolv] forKey:key];
}

- (void)encodeInt:(int)intv forKey:(NSString *)key
{
    [[stack lastObject] setObject:[NSNumber numberWithInt:intv] forKey:key];
}

- (void)encodeInt32:(int32_t)intv forKey:(NSString *)key
{
    [[stack lastObject] setObject:[NSNumber numberWithLong:intv] forKey:key];
}

- (void)encodeInt64:(int64_t)intv forKey:(NSString *)key
{
    [[stack lastObject] setObject:[NSNumber numberWithLongLong:intv] forKey:key];
}

- (void)encodeFloat:(float)realv forKey:(NSString *)key
{
    [[stack lastObject] setObject:[NSNumber numberWithFloat:realv] forKey:key];
}

- (void)encodeDouble:(double)realv forKey:(NSString *)key
{
    [[stack lastObject] setObject:[NSNumber numberWithDouble:realv] forKey:key];
}

- (void)encodeBytes:(const uint8_t *)bytesp length:(NSUInteger)lenv forKey:(NSString *)key
{
    [[stack lastObject] setObject:[NSData dataWithBytes:bytesp length:lenv] forKey:key];
}

- (id)decodeObject:(id)object forKey:(NSString *)key
{
    if (object && key)
    {
        //new keypath
        NSString *newKeyPath = keyPath? [keyPath stringByAppendingPathExtension:key]: key;
        
        //check if object is an alias
        if ([object isKindOfClass:[NSDictionary class]])
        {
            NSString *aliasKeyPath = [(NSDictionary *)object objectForKey:HRCoderObjectAliasKey];
            if (aliasKeyPath)
            {
                //object alias
                id decodedObject = [knownObjects objectForKey:aliasKeyPath];
                if (!decodedObject)
                {
                    [unresolvedAliases setObject:aliasKeyPath forKey:newKeyPath];
                    decodedObject = [HRCoderAliasPlaceholder placeholder];
                }
                return decodedObject;
            }
        }
        
        //new object
        NSString *oldKeyPath = keyPath;
        self.keyPath = newKeyPath;
        id decodedObject = [object unarchiveObjectWithHRCoder:self];
        [knownObjects setObject:decodedObject forKey:keyPath];
        self.keyPath = oldKeyPath;
        return decodedObject;
    }
    return nil;
}

- (id)decodeObjectForKey:(NSString *)key
{
    return [self decodeObject:[[stack lastObject] objectForKey:key] forKey:key];
}

- (BOOL)decodeBoolForKey:(NSString *)key
{
    return [[[stack lastObject] objectForKey:key] boolValue];
}

- (int)decodeIntForKey:(NSString *)key
{
    return [[[stack lastObject] objectForKey:key] intValue];
}

- (int32_t)decodeInt32ForKey:(NSString *)key
{
    return [[[stack lastObject] objectForKey:key] longValue];
}

- (int64_t)decodeInt64ForKey:(NSString *)key
{
    return [[[stack lastObject] objectForKey:key] longLongValue];
}

- (float)decodeFloatForKey:(NSString *)key
{
    return [[[stack lastObject] objectForKey:key] floatValue];
}

- (double)decodeDoubleForKey:(NSString *)key
{
    return [[[stack lastObject] objectForKey:key] doubleValue];
}

- (const uint8_t *)decodeBytesForKey:(NSString *)key returnedLength:(NSUInteger *)lengthp
{
    NSData *data = [[stack lastObject] objectForKey:key];
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
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [coder.stack addObject:result];
    [result setObject:NSStringFromClass([self class]) forKey:HRCoderClassNameKey];
    [(id <NSCoding>)self encodeWithCoder:coder];
    [coder.stack removeLastObject];
    return result;
}

@end    


@implementation NSDictionary(HRCoding)

- (id)unarchiveObjectWithHRCoder:(HRCoder *)coder
{
    NSString *className = [self objectForKey:HRCoderClassNameKey];
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
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        for (NSString *key in self)
        {
            id object = [coder decodeObjectForKey:key];
            if (object)
            {
                [result setObject:object forKey:key];
            }
        }
        return AZ_AUTORELEASE([result copy]);
    }
}

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [coder.stack addObject:result];
    for (NSString *key in self)
    {
        [coder encodeObject:[self objectForKey:key] forKey:key];
    }
    [coder.stack removeLastObject];
    return result;
}

@end


@implementation NSArray(HRCoding)

- (id)unarchiveObjectWithHRCoder:(HRCoder *)coder
{
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < [self count]; i++)
    {
        NSString *key = [NSString stringWithFormat:@"%i", i];
        id encodedObject = [self objectAtIndex:i];
        id decodedObject = [coder decodeObject:encodedObject forKey:key];
        [result addObject:decodedObject];
    }
    return result;
}

- (id)archivedObjectWithHRCoder:(HRCoder *)coder
{
    NSMutableArray *result = [NSMutableArray array];
    for (int i = 0; i < [self count]; i++)
    {
        id object = [self objectAtIndex:i];
        NSString *key = [NSString stringWithFormat:@"%i", i];
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

- (NSMutableDictionary*) getDictionary
{
  if (objc_getAssociatedObject(self, @"dictionary")==nil) 
  {
    objc_setAssociatedObject(self,@"dictionary",[[NSMutableDictionary alloc] init],OBJC_ASSOCIATION_RETAIN);
  }
  return (NSMutableDictionary *)objc_getAssociatedObject(self, @"dictionary");
}


@end

@implementation NSObject (SubclassEnumeration)

+(NSArray *)subclasses
{
	NSMutableArray *subClasses = [NSMutableArray array];
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
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /* 
			 if you want a list of what will be returned for these primitives, search online for
			 "objective-c" "Property Attribute Description Examples"
			 apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.            
			 */
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }        
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}


+ (NSDictionary *)classPropsFor:(Class)klass
{    
    if (klass == NULL) {
        return nil;
    }
	
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
	
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
	
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

/**- (NSArray*) methodDumpForClass:(NSString *)Class {
 
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
 NSMutableArray *rtn = [[NSMutableArray alloc] init];
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
 }*/


// aps suffix to avoid namespace collsion
//   ...for Andrew Paul Sardone
//- (NSDictionary *)propertiesDictionariate;


- (NSDictionary *)propertiesPlease {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}



- (NSString *)stringFromClass
{
	return NSStringFromClass([self class]);
}


-(void)setIntValue:(NSInteger)i forKey:(NSString *)key {
	[self setValue:[NSNumber numberWithInt:i] forKey:key];
}

-(void)setIntValue:(NSInteger)i forKeyPath:(NSString *)keyPath {
	[self setValue:[NSNumber numberWithInt:i] forKeyPath:keyPath];
}

-(void)setFloatValue:(CGFloat)f forKey:(NSString *)key {
	[self setValue:[NSNumber numberWithFloat:f] forKey:key];
}

-(void)setFloatValue:(CGFloat)f forKeyPath:(NSString *)keyPath {
	[self setValue:[NSNumber numberWithFloat:f] forKeyPath:keyPath];
}

-(BOOL)isEqualToAnyOf:(id<NSFastEnumeration>)enumerable {
	for (id o in enumerable) {
		if ([self isEqual:o]) {
			return YES;
		}
	}
	
	return NO;
}

-(void)fire:(NSString *)notificationName {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:notificationName object:self];
}

-(void)fire:(NSString *)notificationName userInfo:(NSDictionary *)context {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc postNotificationName:notificationName object:self userInfo:context];
}

-(id)observeName:(NSString *)notificationName 
      usingBlock:(void (^)(NSNotification *))block
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	return [nc addObserverForName:notificationName
						   object:self
							queue:nil
					   usingBlock:block];
}

-(void)observeObject:(NSObject *)object
             forName:(NSString *)notificationName
             calling:(SEL)selector
{
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self 
		   selector:selector 
			   name:notificationName
			 object:object];
}

-(void)stopObserving:(NSObject *)object forName:(NSString *)notificationName {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:notificationName object:object];
}

-(void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)seconds {
	[self performSelector:aSelector withObject:nil afterDelay:seconds];
}

-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
	[self addObserver:observer
		   forKeyPath:keyPath
			  options:0
			  context:nil
	 ];
}

-(void)addObserver:(NSObject *)observer 
       forKeyPaths:(id<NSFastEnumeration>)keyPaths
{
	for (NSString *keyPath in keyPaths) {
		[self addObserver:observer forKeyPath:keyPath];
	}
}

-(void)removeObserver:(NSObject *)observer 
          forKeyPaths:(id<NSFastEnumeration>)keyPaths
{
	for (NSString *keyPath in keyPaths) {
		[self removeObserver:observer forKeyPath:keyPath];
	}
}

-(void)willChangeValueForKeys:(id<NSFastEnumeration>)keys {
	for (id key in keys) {
		[self willChangeValueForKey:key];
	}
}

-(void)didChangeValueForKeys:(id<NSFastEnumeration>)keys {
	for (id key in keys) {
		[self didChangeValueForKey:key];
	}
}

@end



@implementation NSObject (SetClass)
- (void)setClass:(Class)aClass {
	NSAssert(
			 class_getInstanceSize([self class]) ==
			 class_getInstanceSize(aClass),
			 @"Classes must be the same size to swizzle.");
	object_setClass(self, aClass);
}
@end