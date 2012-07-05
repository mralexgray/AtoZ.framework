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
