
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObject+AtoZ.h"
#import "AtoZ.h"
//#import "Nu.h"


#import <objc/runtime.h>

@implementation NSObject (AMAssociatedObjects)

- (void)associate:(id)value with:(void *)key
{
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)weaklyAssociate:(id)value with:(void *)key
{
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)associatedValueFor:(void *)key
{
	return objc_getAssociatedObject(self, key);
}

@end

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

//- (void)dealloc
//{
//    [self cancelObservation];
//    [task release];
//    [keyPath release];
//    [queue release];
////    [super dealloc];
//}

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

- (NSA*)addObserverForKeyPaths:(NSA*)keyPaths task:(AZBlockTask)task{
	return [keyPaths map:^id(id obj) {
		return [self addObserverForKeyPath:obj onQueue:nil task:task];
	}];
}

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
        dict[token] = trampoline;
        [trampoline release];
    });
    return token;
}

- (void)removeObserverWithBlockToken:(AZBlockToken *)token
{
    dispatch_sync(AZObserverMutationQueueCreatingIfNecessary(), ^{
        NSMutableDictionary *observationDictionary = objc_getAssociatedObject(self, (__bridge const void *)(AZObserverMapKey));
        AZObserverTrampoline *trampoline = observationDictionary[token];
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

+ (NSArray *) instanceMethods
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int method_count;
    Method *method_list = class_copyMethodList([self class], &method_count);
    int i;
    for (i = 0; i < method_count; i++) {
//        [array addObject:[[[NuMethod alloc] initWithMethod:method_list[i]] autorelease]];
    }
    free(method_list);
    [array sortUsingSelector:@selector(compare:)];
    return array;
}
- (NSArray *) instanceMethods
{
    NSMutableArray *array = [NSMutableArray array];
    unsigned int method_count;
    Method *method_list = class_copyMethodList([self class], &method_count);
    int i;
    for (i = 0; i < method_count; i++) {
//        [array addObject:[[[NuMethod alloc] initWithMethod:method_list[i]] autorelease]];
    }
    free(method_list);
    [array sortUsingSelector:@selector(compare:)];
    return array;
}


/*! Get an array containing the names of the instance methods of a class. */
- (NSArray *) instanceMethodNames
{
    id methods = [self instanceMethods];
    return [methods mapSelector:@selector(name)];
}



-(void) propagateValue:(id)value forBinding:(NSString*)binding;
{
	NSParameterAssert(binding != nil);
	//WARNING: bindingInfo contains NSNull, so it must be accounted for
	NSDictionary* bindingInfo = [self infoForBinding:binding];
	if(!bindingInfo) return; //there is no binding
	//apply the value transformer, if one has been set
	NSDictionary* bindingOptions = [bindingInfo objectForKey:NSOptionsKey];
	if(bindingOptions){
		NSValueTransformer* transformer = [bindingOptions valueForKey:NSValueTransformerBindingOption];
		if(!transformer || (id)transformer == [NSNull null]){
			NSString* transformerName = [bindingOptions valueForKey:NSValueTransformerNameBindingOption];
			if(transformerName && (id)transformerName != [NSNull null]){
				transformer = [NSValueTransformer valueTransformerForName:transformerName];
			}
		}

		if(transformer && (id)transformer != [NSNull null]){
			if([[transformer class] allowsReverseTransformation]){
				value = [transformer reverseTransformedValue:value];
			} else {
				NSLog(@"WARNING: binding \"%@\" has value transformer, but it doesn't allow reverse transformations in %s", binding, __PRETTY_FUNCTION__);
	}}}
	id boundObject = [bindingInfo objectForKey:NSObservedObjectKey];
	if(!boundObject || boundObject == [NSNull null]){
		NSLog(@"ERROR: NSObservedObjectKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
		return;
	}
	NSString* boundKeyPath = [bindingInfo objectForKey:NSObservedKeyPathKey];
	if(!boundKeyPath || (id)boundKeyPath == [NSNull null]){
		NSLog(@"ERROR: NSObservedKeyPathKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
		return;
	}
	[boundObject setValue:value forKeyPath:boundKeyPath];
}

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

- (id)objectForKeyedSubscript:(id)key
{
//	NSArray *syms = [NSThread  callStackSymbols];
//	if ([syms count] > 1) {
//		NSLog(@"<%@ %p> %@ - caller: %@ ", [self class], self, NSStringFromSelector(_cmd),[syms objectAtIndex:1]);
//	} else {
//		NSLog(@"<%@ %p> %@", [self class], self, NSStringFromSelector(_cmd));
//	}
//	if (areSame(key, @"path")) NSLog(@"warning, path subscrip[t being set");
//	NSLog(@"CMD: %@ requesting subscript:%@", [NSString stringWithUTF8String:__func__], key);
	id result = nil;
//	if ([key isKindOfClass:[NSS class]])
		result = [self respondsToString:key] ? [self valueForKey:key] : nil;
		if (!result)
		result = [self respondsToSelector:@selector(valueForKeyPath:)] ? [self valueForKeyPath:key] : nil;
		if (!result)
		result = [self respondsToSelector:@selector(objectForKey:)] ? [(id)self objectForKey:key] : nil;
		if (!result)
		result = [self respondsToSelector:@selector(objectForKeyPath:)] ? [(id)self objectForKeyPath:key] : nil;

	if (!result) NSLog(@"%@ cannot coerce value for keyedSubstring: %@", self, key);
	return result;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {

//	if (areSame(key, @"path")) NSLog(@"warning, path subscrip[t being set");

	__block BOOL wasSet = NO;
	[(NSS*)key contains:@"."] ? ^{
		[self canSetValueForKeyPath:(NSS*)key] ? ^{
			NSLog(@"Setting Value: %@ forKeyPath:%@", obj, key);
			[self setValue:obj forKeyPath:(NSS*)key];
//			NSLog(@"New val: %@.", self[key]);
			wasSet = [self [key] isEqualTo:obj];
		}() : ^{  NSLog(@"Cannot set object:%@ for (dot)keypath:\"%@\" via subscript... \"%@\" does not respond. Current val:%@.",obj, key, self, self[key]);}();
	}() : [self canSetValueForKey:(NSS*)key] ? ^{
//			NSLog(@"Setting Value: %@ forKey:%@", obj, key);
			[self setValue:obj forKey:(NSS*)key];
			wasSet = [self[key] isEqualTo:obj];
//			NSLog(@"New val: %@.", self[key]);
	}() : ^{  NSLog(@"Cannot set object:%@ for key:\"%@\" via subscript... \"%@\" does not respond. Current val:%@.",obj, key, self, self[key]);
	}();
	wasSet ?: NSLog(@"subscrpipt key:%@ NOT set, despite edfforts", key);

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
        NSS*propNameStr 	= @(propName);
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
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
		   withObject:(id)p4 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
		   withObject:(id)p4 withObject:(id)p5 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo setArgument:&p5 atIndex:6];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
		   withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo setArgument:&p5 atIndex:6];
		[invo setArgument:&p6 atIndex:7];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
		   withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(id)p7 {
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo setArgument:&p4 atIndex:5];
		[invo setArgument:&p5 atIndex:6];
		[invo setArgument:&p6 atIndex:7];
		[invo setArgument:&p7 atIndex:8];
		[invo invoke];
		if (sig.methodReturnLength) {
			id anObject;
			[invo getReturnValue:&anObject];
			return anObject;
		} else {
			return nil;
		}
	} else {
		return nil;
	}
}


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

- (NSS*)segmentLabel {
	return    [self isKindOfClass:[NSSegmentedControl class]]
			? [(NSSegmentedControl*)self labelForSegment:[(NSSegmentedControl*)self selectedSegment]] : nil;
}

BOOL respondsToString(id obj,NSS* string){
	return [obj respondsToString:string];
}

BOOL respondsTo(id obj, SEL selector){
	return [obj respondsToSelector:selector];
}
- (BOOL) respondsToString:(NSS*)string{
	return [self respondsToSelector:NSSelectorFromString(string)];
}


- (IBAction)performActionFromSegmentLabel:(id)sender;
{
	BOOL isSegmented = [sender isKindOfClass:[NSSegmentedControl class]];
	if (isSegmented) {
		BOOL isSelected;	NSS*label;
		NSInteger selectedSegment = [sender selectedSegment];
		label = [sender labelForSegment:selectedSegment];
		BOOL *optionPtr = &isSelected;
		if ([self respondsToString:label]){
			SEL fabricated = NSSelectorFromString(label);
			[self performSelector:fabricated withValue:nil];
		}
	}
}

- (IBAction)increment:(id)sender;
{
	BOOL isSegmented = [sender isKindOfClass:[NSSegmentedControl class]];
	if (isSegmented) {
		BOOL isSelected;	NSS*label;
		NSInteger selectedSegment = [sender selectedSegment];
		label = [sender labelForSegment:selectedSegment];
		BOOL *optionPtr = &isSelected;
		
		NSI prop = [self integerForKey:label];
		NSI newVal = (prop+1);
		[self setValue:[NSVAL value:(const void*)newVal withObjCType:[self typeOfPropertyNamed:label]] forKey:label];
	}
}



- (void)setFromSegmentLabel:(id)sender {

	BOOL isSelected;	NSS*label;
	BOOL isSegmented = [sender isKindOfClass:[NSSegmentedControl class]];
		//	if (isSegmented) {
	NSInteger selectedSegment = [sender selectedSegment];
		//		 = [sender isSelectedForSegment:selectedSegment];
	label = [sender labelForSegment:selectedSegment];
	BOOL *optionPtr = &isSelected;

	SEL fabricated = NSSelectorFromString($(@"set%@:", label));
	[[sender delegate] performSelector:fabricated withValue:optionPtr];
		//	[[AZTalker sharedInstance] say:$(@"%@ is %@ selected", string, isSelected ? @"" : @"NOT")];
}
//- (void)performActionFromLabel:(id)sender {
//
//	BOOL isSelected;	NSS*label;
//	BOOL isButton = [sender isKindOfClass:[NSButton class]];
//	NSInteger buttonState = [sender state];
//	//		 = [sender isSelectedForSegment:selectedSegment];
//	label = [sender label];
//	BOOL *optionPtr = &buttonState;
//	//	} else
//	//		label = [sender label];
//	SEL fabricated = NSSelectorFromString(label);
//	[[sender delegate] performSelector:fabricated withValue:optionPtr];
//	//	[[AZTalker sharedInstance] say:$(@"%@ is %@ selected", string, isSelected ? @"" : @"NOT")];
//}
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

-(void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)seconds
{
	[self performSelector:aSelector withObject:nil afterDelay:seconds];
}

-(void)observeKeyPath:(NSS*)keyPath
{
	[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
-(void)addObserver:(NSObject *)observer forKeyPath:(NSS*)keyPath
{
	[self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}

-(void)addObserver:(NSObject *)observer forKeyPaths:(id<NSFastEnumeration>)keyPaths
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
		[propertyArray addObject:@(propertyName)];
	}
	free(properties);
	return [NSArray arrayWithArray:propertyArray];
}

- (void)setClass:(Class)aClass {	NSAssert( class_getInstanceSize([self class]) == class_getInstanceSize(aClass),
			 									@"Classes must be the same size to swizzle.");
	object_setClass(self, aClass);
}

+(id)newFromDictionary:(NSD*)dic {
	return [[self class] customClassWithProperties:dic];
}

//	In your custom class
+ (id)customClassWithProperties:(NSD *)properties { return [[[self alloc] initWithProperties:properties] autorelease];}

- (id)initWithProperties:(NSD *)properties {
//	if ([self isKindOfClass:[CALayer class]]) {
//		if ([[properties allKeys]containsObject:@"frame"]){
//			self[@"frame"] = [properties rectForKey:@"frame"] {
//			[self setValuesForKeysWithDictionary:[properties dictionaryWithoutKey:@"frame"]];
//		}
//	}
//
//	}
	if ([[properties allKeys]containsObject:@"frame"]){
		if (self = [(NSView*)self initWithFrame:[properties rectForKey:@"frame"]]) {
			[self setValuesForKeysWithDictionary:[properties dictionaryWithoutKey:@"frame"]];
		}
	}
//	if ([self isKindOfClass:[NSView class]])
//	if (self = [self init])
//else
	else if (self = [self init]) {
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
		[instance setValue:self[propertyKey]	forKey:propertyKey];
	}
}
@end


@implementation NSObject (KVCExtensions)


- (void) setPropertiesWithDictionary:(NSD*)dictionary;
{
	[dictionary mapPropertiesToObject:self];
}
// Can set value for key follows the Key Value Settings search pattern as defined in the apple documentation
- (BOOL)canSetValueForKey:(NSString *)key
{
	NSS* capKey = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) // Check for SEL-based setter
											   withString:[[key substringToIndex:1] uppercaseString]];
	if ([self respondsToString:$(@"set%@:",capKey)]) return YES;

    //	If you can access the instance variable directly, check if that exists.
	//	Patterns for instance variable naming:  1. _<key>  2. _is<Key>  3. <key>  4. is<Key>

    if ([[self class] accessInstanceVariablesDirectly]) {   // Declare all the patters for the key
        const char *pattern1 = [$(@"_%@",	   key) UTF8String];
        const char *pattern2 = [$(@"_is%@", capKey) UTF8String];
        const char *pattern3 = [$(@"%@",	   key) UTF8String];
        const char *pattern4 = [$(@"is%@",  capKey) UTF8String];  unsigned int numIvars = 0;

		Ivar *ivarList = class_copyIvarList([self class], &numIvars);
        for (unsigned int i = 0; i < numIvars; i++) {
			const char *name = ivar_getName(*ivarList);
            if (strcmp(name, pattern1) == 0 || strcmp(name, pattern2) == 0 ||
                strcmp(name, pattern3) == 0 || strcmp(name, pattern4) == 0) { return YES; }
            ivarList++;
        }
    }
    return NO;
}

// Traverse the key path finding you can set the values. Keypath is a set of keys delimited by "."
- (BOOL)canSetValueForKeyPath:(NSString *)keyPath
{
    NSRange delimeterRange = [keyPath rangeOfCharacterFromSet:
							 [NSCharacterSet characterSetWithCharactersInString: @"."]];
    if (delimeterRange.location == NSNotFound) return [self canSetValueForKey:keyPath];

    NSString *first	= [keyPath substringToIndex:	delimeterRange.location		];
    NSString *rest 	= [keyPath substringFromIndex: (delimeterRange.location + 1)];

    return [self canSetValueForKey:first] ? [[self valueForKey:first] canSetValueForKeyPath:rest] : NO;
}

@end
