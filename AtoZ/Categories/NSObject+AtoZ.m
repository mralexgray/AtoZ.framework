
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+AtoZ.h"
#import "AtoZ.h"

@implementation NSObject (AssociatedValues)
- (void)setAssociatedValue: (id)value  forKey: (NSS*) key {
    [self setAssociatedValue:value forKey:key policy:OBJC_ASSOCIATION_ASSIGN];
}
- (void)setAssociatedValue: (id)value  forKey: (NSS*) key  policy: (objc_AssociationPolicy) policy {
    objc_setAssociatedObject(self, (__bridge const void *)(key), value, policy);
}
- (id)associatedValueForKey: (NSS*) key {
    return objc_getAssociatedObject(self, (__bridge const void *)(key));
}
- (void)removeAssociatedValueForKey: (NSS*) key {
    objc_setAssociatedObject(self, (__bridge const void *)(key), nil, OBJC_ASSOCIATION_ASSIGN);
}
- (void)removeAllAssociatedValues {
    objc_removeAssociatedObjects(self);
}
@end


#import <dispatch/dispatch.h>
#import <objc/runtime.h>

@interface AZObserverTrampoline : NSObject
{
    __weak id observee;
    NSString *keyPath;
    AZBlockTask task;
    NSOperationQueue *queue;
    dispatch_once_t cancellationPredicate;
}

- (AZObserverTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(AZBlockTask)task;
- (void)cancelObservation;
@end

@implementation AZObserverTrampoline

static NSString *AZObserverTrampolineContext = @"AZObserverTrampolineContext";

- (AZObserverTrampoline *)initObservingObject:(id)obj keyPath:(NSString *)newKeyPath onQueue:(NSOperationQueue *)newQueue task:(AZBlockTask)newTask
{
    if (!(self = [super init])) return nil;
    task = [newTask copy];
    keyPath = [newKeyPath copy];
    queue = newQueue;// retain];
    observee = obj;
    cancellationPredicate = 0;
    [observee addObserver:self forKeyPath:keyPath options:0 context:(__bridge void *)AZObserverTrampolineContext];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)aKeyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == (__bridge const void*)AZObserverTrampolineContext)
		{
        if (queue)
            [queue addOperationWithBlock:^{ task(object, change); }];
        else
            task(object, change);
		}
}

- (void)cancelObservation
{
    dispatch_once(&cancellationPredicate, ^{
        [observee removeObserver:self forKeyPath:keyPath];
        observee = nil;
    });
}

- (void)dealloc
{
    [self cancelObservation];
    [task release];
    [keyPath release];
    [queue release];
//    [super dealloc];
}

@end

static NSString *AZObserverMapKey = @"com.github.mralexgray.observerMap";
static dispatch_queue_t AZObserverMutationQueue = NULL;

static dispatch_queue_t AZObserverMutationQueueCreatingIfNecessary()
{
    static dispatch_once_t queueCreationPredicate = 0;
    dispatch_once(&queueCreationPredicate, ^{
        AZObserverMutationQueue = dispatch_queue_create("com.github.mralexgray.observerMutationQueue", 0);
    });
    return AZObserverMutationQueue;
}

@implementation NSObject (AZBlockObservation)

- (AZBlockToken *)addObserverForKeyPath:(NSString *)keyPath task:(AZBlockTask)task
{
    return [self addObserverForKeyPath:keyPath onQueue:nil task:task];
}

- (AZBlockToken *)addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(AZBlockTask)task
{
    AZBlockToken *token = [[NSProcessInfo processInfo] globallyUniqueString];
    dispatch_sync(AZObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *dict = objc_getAssociatedObject(self, (__bridge const void *)(AZObserverMapKey));
        if (!dict)
			{
            dict = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, (__bridge const void *)(AZObserverMapKey), dict, OBJC_ASSOCIATION_RETAIN);
            [dict release];
			}
        AZObserverTrampoline *trampoline = [[AZObserverTrampoline alloc] initObservingObject:self keyPath:keyPath onQueue:queue task:task];
        [dict setObject:trampoline forKey:token];
        [trampoline release];
    });
    return token;
}

- (void)removeObserverWithBlockToken:(AZBlockToken *)token
{
    dispatch_sync(AZObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *observationDictionary = objc_getAssociatedObject(self, (__bridge const void *)(AZObserverMapKey));
        AZObserverTrampoline *trampoline = [observationDictionary objectForKey:token];
        if (!trampoline)
			{
            NSLog(@"[NSObject(AZBlockObservation) removeObserverWithBlockToken]: Ignoring attempt to remove non-existent observer on %@ for token %@.", self, token);
            return;
			}
        [trampoline cancelObservation];
        [observationDictionary removeObjectForKey:token];

        // Due to a bug in the obj-c runtime, this dictionary does not get cleaned up on release when running without GC.
        if ([observationDictionary count] == 0)
            objc_setAssociatedObject(self, (__bridge const void *)(AZObserverMapKey), nil, OBJC_ASSOCIATION_RETAIN);
    });
}
@end
#import <stdarg.h>

@implementation NSObject (AtoZ)



-(void) setWithDictionary:(NSD*)dic;
{
	[[dic allKeys] each:^(id obj) {
		NSString *j = $(@"set%@", [obj capitalizedString]);
		SEL setter = @selector(j);
		[self performSelectorWithoutWarnings:setter withObject:dic[obj]];
	}];

}


+(void)switchOn:(id<NSObject>)obj cases:casesList, ...
{
    va_list list;    va_start(list, casesList);	id<NSObject> o = casesList;
    for (;;) { if (o) { caseBlock block = va_arg(list, caseBlock); [obj isEqual:o] ? block() : nil; break;}
        o = va_arg(list, id<NSObject>);
    }
    va_end(list);
}

+(void)switchOn:(id<NSObject>)obj defaultBlock:(caseBlock)defaultBlock cases:casesList, ...
{
    va_list list;    va_start(list, casesList);		id<NSObject> o = casesList;		__block BOOL match = NO;
    for (;;) {
        if (o) { caseBlock block = va_arg(list, caseBlock); [obj isEqual:o] ? ^{ block(); match = YES;}() : nil; break; }
        o = va_arg(list, id<NSObject>);
    }
    if (defaultBlock && ! match) defaultBlock();
    va_end(list);
}

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
	if (objc_getAssociatedObject( self, @"dictionary" ) == nil)
		objc_setAssociatedObject( self, @"dictionary", [NSMD dictionary], OBJC_ASSOCIATION_RETAIN);
	return (NSMD *)objc_getAssociatedObject( self, @"dictionary" );
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

- (NSS*) autoDescribe { return [$(@"%@:%p:: ", [self class], self) stringByAppendingString:
											   [self autoDescribeWithClassType:[self class]]]; }


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

//	In your custom class
+ (id)customClassWithProperties:(NSD *)properties { return [[[self alloc] initWithProperties:properties] autorelease];}

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

