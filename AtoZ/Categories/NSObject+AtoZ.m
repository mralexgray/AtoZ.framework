
#import "AtoZ.h"
#import "NSObject+AtoZ.h"
//#import "AutoCoding.h"

//#import "Nu.h"
//
//@implementation NSObject (AMAssociatedObjects)
//
//- (void)associate: (id)value with: (void*)key {			objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN); }
//
//- (void)weaklyAssociate: (id)value with: (void*)key {	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN); }
//
//- (id)associatedValueFor: (void*)key {			 return objc_getAssociatedObject(self, key);								 }
//
//@end

@implementation NSObject (AssociatedValues)

- (void)setAssociatedValue: (id)value  forKey: (NSS*) key {	[self setAssociatedValue:value forKey:key policy:OBJC_ASSOCIATION_ASSIGN]; }

- (void)setAssociatedValue: (id)value  forKey: (NSS*) key  policy: (objc_AssociationPolicy) policy {	objc_setAssociatedObject(self, (__bridge const void *)(key), value, policy); }

- (id)associatedValueForKey: (NSS*) key {	return objc_getAssociatedObject(self, (__bridge const void *)(key)); }

- (void)removeAssociatedValueForKey: (NSS*) key { 	objc_setAssociatedObject(self, (__bridge const void *)(key), nil, OBJC_ASSOCIATION_ASSIGN); }

- (void)removeAllAssociatedValues { 	objc_removeAssociatedObjects(self); }

- (BOOL)hasAssociatedValueForKey:(NSS*)string {  return [self associatedValueForKey:string] != nil; }

- (id)associatedValueForKey:(NSS*)key orSetTo:(id)anObject policy: (objc_AssociationPolicy) policy
{
	return 	[self hasAssociatedValueForKey:key]
			? 	[self associatedValueForKey:	 key]
			: ^{	[self setAssociatedValue:anObject forKey:key policy:policy];
					return [self associatedValueForKey:key];	}();
}

@end

@interface AZObserverTrampoline : NSObject
{
	__weak id observee;		NSS *keyPath;	AZBlockTask task;	NSOQ *queue;	dispatch_once_t cancellationPredicate;
}

- (AZObserverTrampoline *)initObservingObject: (id)obj keyPath: (NSS*)keyPath onQueue: (NSOQ*)queue task: (AZBlockTask)task;
- (void)cancelObservation;
@end

@implementation AZObserverTrampoline

static NSS *AZObserverTrampolineContext = @"AZObserverTrampolineContext";

- (AZObserverTrampoline *)initObservingObject: (id)obj keyPath: (NSS*)newKeyPath onQueue: (NSOQ*)newQueue task: (AZBlockTask)newTask
{
	if (!(self = [super init])) return nil;
	task = [newTask copy];
	keyPath = [newKeyPath copy];
	queue = newQueue;// retain];
	observee = obj;
	cancellationPredicate = 0;
	[observee addObserver:self forKeyPath:keyPath options:0 context: (__bridge void *)AZObserverTrampolineContext];
	return self;
}

- (void)observeValueForKeyPath: (NSS*)aKeyPath ofObject: (id)object change: (NSDictionary *)change context: (void*)context
{
	if (context == (__bridge const void*)AZObserverTrampolineContext)
		queue ? [queue addOperationWithBlock:^{ task(object, change); }] : task(object, change);
}

- (void)cancelObservation
{
	dispatch_once(&cancellationPredicate, ^{
		[observee removeObserver:self forKeyPath:keyPath];
		observee = nil;
	});
}

//- (void)dealloc {	[self cancelObservation]; [task release]; [keyPath release]; [queue release]; [super dealloc]; }

@end

static NSS *AZObserverMapKey = @"com.github.mralexgray.observerMap";
static dispatch_queue_t AZObserverMutationQueue = NULL;
static dispatch_queue_t AZObserverMutationQueueCreatingIfNecessary(void) {
	static dispatch_once_t queueCreationPredicate = 0;
	dispatch_once(&queueCreationPredicate, ^{
		AZObserverMutationQueue = dispatch_queue_create("com.github.mralexgray.observerMutationQueue", 0);
	});
	return AZObserverMutationQueue;
}

@implementation NSObject (AZBlockObservation)

- (NSA*)addObserverForKeyPaths: (NSA*)keyPaths task: (AZBlockTask)task
{
	return [keyPaths map:^id(id obj) { return [self addObserverForKeyPath:obj onQueue:nil task:task];	}];
}

- (AZBlockToken *)addObserverForKeyPath: (NSS*)keyPath task: (AZBlockTask)task
{
	return [self addObserverForKeyPath:keyPath onQueue:nil task:task];
}

- (AZBlockToken *)addObserverForKeyPath: (NSS*)keyPath onQueue: (NSOQ*)queue task: (AZBlockTask)task
{
	AZBlockToken *token = [NSProcessInfo.processInfo globallyUniqueString];
	dispatch_sync(AZObserverMutationQueueCreatingIfNecessary(), ^{
		NSMutableDictionary *dict = objc_getAssociatedObject(self, (__bridge const void *)(AZObserverMapKey));
		if (!dict)
		{
			dict = NSMD.new;
			objc_setAssociatedObject(self, (__bridge const void *)(AZObserverMapKey), dict, OBJC_ASSOCIATION_RETAIN);
//			[dict release];
		}
		AZObserverTrampoline *trampoline = [AZObserverTrampoline.alloc initObservingObject:self keyPath:keyPath onQueue:queue task:task];
		dict[token] = trampoline;
//		[trampoline release];
	});
	return token;
}

- (void)removeObserverWithBlockToken: (AZBlockToken *)token
{
	dispatch_sync(AZObserverMutationQueueCreatingIfNecessary(), ^{
		NSMD *observationDictionary = objc_getAssociatedObject(self, (__bridge const void *)(AZObserverMapKey));
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

#import "AtoZUmbrella.h"
#import "AtoZFunctions.h"

//static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation NSObject (AtoZ)

-(void) propagateValue:(id)value forBinding:(NSString*)binding;
{
	NSParameterAssert(binding != nil);
	
	//WARNING: bindingInfo contains NSNull, so it must be accounted for
	NSDictionary* bindingInfo = [self infoForBinding:binding];
	if(!bindingInfo)
		return; //there is no binding
	
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
			}
		}
	}
	
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


-(void) 	DDLogError   {	DDLogError  (@"%@",self);  } 	// Red
-(void) 	DDLogWarn    {	DDLogWarn   (@"%@",self);  } 	// Orange
-(void) 	DDLogInfo	    {	DDLogInfo   (@"%@",self);  } 	// Default (black)
-(void) 	DDLogVerbose {	DDLogVerbose(@"%@",self);	}	// Default (black)


- (void) bindArrayKeyPath: (NSS*)array toController: (NSArrayController*)controller
{
	[self bind:array toObject:controller withKeyPath:@"arrangedObjects" options:nil];
}

- (id) performString: (NSS*)string;
{
	return [self performSelectorWithoutWarnings:NSSelectorFromString(string) withObject:nil];
}

- (id) performString: (NSS*)string withObject: (id) obj;
{
	return [self performSelectorWithoutWarnings:NSSelectorFromString(string) withObject:obj];
}

+ (NSA*) instanceMethods
{
	NSMA *array = NSMA.new;
	unsigned int method_count;
	Method *method_list = class_copyMethodList([self class], &method_count);
	int i;
	for (i = 0; i < method_count; i++) {
		//		[array addObject:[[[NuMethod alloc] initWithMethod:method_list[i]] autorelease]];
	}
	free(method_list);
	[array sortUsingSelector:@selector(compare:)];
	return array;
}
- (NSA*) instanceMethodArray
{
	Class clazz = self.class;
	u_int count;
	Method* methods = class_copyMethodList(clazz, &count);
	NSMA *methodArray = NSMA.new;
	for (int i = 0; i < count ; i++)
	{
		SEL selector = method_getName(methods[i]);
		const char* methodName = sel_getName(selector);
		[methodArray addObject:[NSS stringWithCString:methodName encoding:NSUTF8StringEncoding]];
	}
	free(methods);
	return  methodArray;
}
- (NSS*) instanceMethods
{
	return [[self instanceMethodArray]formatAsListWithPadding:30];
}

/*! Get an array containing the names of the instance methods of a class. */
- (NSA*) instanceMethodNames
{
	id methods = [self instanceMethods];
	return [methods mapSelector:@selector(name)];
}

/**

-(void) propagateValue: (id)value forBinding: (NSS*)binding;
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
			NSS* transformerName = [bindingOptions valueForKey:NSValueTransformerNameBindingOption];
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
	NSS* boundKeyPath = [bindingInfo objectForKey:NSObservedKeyPathKey];
	if(!boundKeyPath || (id)boundKeyPath == [NSNull null]){
		NSLog(@"ERROR: NSObservedKeyPathKey was nil for binding \"%@\" in %s", binding, __PRETTY_FUNCTION__);
		return;
	}
	[boundObject setValue:value forKeyPath:boundKeyPath];
}
*/
//- (NSA*) settableKeys
//{
//	return [[[self class] uncodableKeys] filter:^BOOL(id object) {
//		return [self canSetValueForKey:object];
//	}];
//}

- (NSA*) keysWorthReading
{
	return [self.settableKeys filter:^BOOL(id object) {
		return [self hasPropertyNamed:object];
	}];
}

-(void) setWithDictionary: (NSD*)dic;
{

	NSCoder *aDecoder = NSCoder.new;
//	for (NSS *key in [dic codableKeys]) {
	[[self settableKeys] do:^(NSS *key) {		[self setValue:[aDecoder decodeObjectForKey:key] forKey:key]; }];
	//	[[dic allKeys] each:^(id obj) {
	//		NSS *j = $(@"set%@:", [obj capitalizedString]);
	//		if ([self respondsToString:j] )
	//			[self performSelectorWithoutWarnings:NSSelectorFromString(j) withObject:[dic[obj]copy]];
	//	}];
}
+(void)switchOn: (id<NSObject>)obj cases:casesList, ...
{
	va_list list;	va_start(list, casesList);	id<NSObject> o = casesList;
	for (;;) { if (o) { caseBlock block = va_arg(list, caseBlock); [obj isEqual:o] ? block() : nil; break;}
		o = va_arg(list, id<NSObject>);
	}
	va_end(list);
}

+(void)switchOn: (id<NSObject>)obj defaultBlock: (caseBlock)defaultBlock cases:casesList, ...
{
	va_list list;	va_start(list, casesList);		id<NSObject> o = casesList;		__block BOOL match = NO;
	for (;;) {
		if (o) { caseBlock block = va_arg(list, caseBlock); [obj isEqual:o] ? ^{ block(); match = YES;}() : nil; break; }
		o = va_arg(list, id<NSObject>);
	}
	if (defaultBlock && ! match) defaultBlock();
	va_end(list);
}


- (id)objectForKeyedSubscript: (id)key
{

	return  [self hasPropertyForKVCKey:key] ? [self valueForKey:key] : nil;
	//	NSArray *syms = [NSThread  callStackSymbols];
	//	if ([syms count] > 1) {
	//		NSLog(@"<%@ %p> %@ - caller: %@ ", [self class], self, NSStringFromSelector(_cmd),[syms objectAtIndex:1]);
	//	} else {
	//		NSLog(@"<%@ %p> %@", [self class], self, NSStringFromSelector(_cmd));
	//	}
	//	if (areSame(key, @"path")) NSLog(@"warning, path subscrip[t being set");
	//	NSLog(@"CMD: %@ requesting subscript:%@", [NSS stringWithUTF8String:__func__], key);

/**	id result = nil;
	//	if ([key isKindOfClass:[NSS class]])
	result = [self respondsToString:key] ? [self valueForKey:key] : nil;
	if (!result)
		result = [self respondsToSelector:@selector(valueForKeyPath:)] ? [self valueForKeyPath:key] : nil;
	if (!result)
		result = [self respondsToSelector:@selector(objectForKey:)] ? [(id)self objectForKey:key] : nil;
	if (!result)
		result = [self respondsToSelector:@selector(objectForKeyPath:)] ? [(id)self objectForKeyPath:key] : nil;
	if (!result)
		result = [self respondsToSelector:@selector(valueForKey:)] ? [self valueForKey:key] : nil;
	if (!result) result = [self valueForKey:key];
	if (!result) NSLog(@"Cannot coerce value from: %@ for keyedSubstring: %@", self.propertiesPlease, key);
	return result; */
}

-(BOOL) isKindOfAnyClass:(NSA*)classes;
{
	return [classes filterOne:^BOOL(Class object) {
		return  [self isKindOfClass:object];
	}];
}

- (void)setObject: (id)obj forKeyedSubscript: (id <NSCopying>)key
{
	if ( areSame(obj, [self valueForKey:(id)key] )) { AZLOG(@"Theyre already the same, doing nothing!") return;}
	__block BOOL wasSet = NO;
	[self canSetValueForKey: (id)key] ? ^{
		//			NSLog(@"Setting Value: %@ forKey:%@", obj, key);
		[self setValue:obj forKey:(id)key];
		wasSet = [self[key] isEqualTo:obj];
		//			NSLog(@"New val: %@.", self[key]);
	}() :  NSLog(@"Cannot set object:%@ for key:\"%@\" via subscript... \"%@\" does not respond. Current val:%@.",obj, key, self, self[key]);
	[self canSetValueForKeyPath: (NSS*)key] ? ^{
		NSLog(@"Setting Value: %@ forKeyPath:%@", obj, key);
		[self setValue:obj forKeyPath: (NSS*)key];
			//			NSLog(@"New val: %@.", self[key]);
		wasSet = [[self valueForKeyPath:(NSS*)key]isEqualTo:obj];
	}() : ^{  NSLog(@"Cannot set object:%@ for (dot)keypath:\"%@\" via subscript... \"%@\" does not respond. Current val:%@.",obj, key, self, self[key]);}();
//	}() :
//	}();
	wasSet ?: NSLog(@"subscrpipt key:%@ NOT set, despite edfforts", key);

}

- (void)performBlock: (void (^)(void))block afterDelay: (NSTimeInterval)delay
{
//	block = [[block copy] autorelease];
	[self performSelector:@selector(fireBlockAfterDelay:) withObject:block afterDelay:delay];
}

- (void)fireBlockAfterDelay: (void (^)(void))block { block(); }
- (NSMD*) getDictionary
{
	if (objc_getAssociatedObject( self, @"dictionary" ) == nil)
		objc_setAssociatedObject( self, @"dictionary", NSMD.new, OBJC_ASSOCIATION_RETAIN);
	return (NSMD *)objc_getAssociatedObject( self, @"dictionary" );
}


+ (NSMA*)newInstances:(NSUI)count;
{
	return [[@0 to: @(count)] map:^id(id obj) {	return  [self.class respondsToSelector:@selector(new)] ? self.new : [self.alloc init];
	}].mutableCopy;

}

static char windowPosition;

- (void) setWindowPosition: (AZWindowPosition)pos { objc_setAssociatedObject( self, &windowPosition, @(pos), OBJC_ASSOCIATION_RETAIN ); }

- (AZWindowPosition) windowPosition { return [objc_getAssociatedObject( self, &windowPosition ) integerValue]; }

// 	Finds all properties of an object, and prints each one out as part of a string describing the class.
- (NSS*) autoDescribeWithClassType: (Class)classType
{
	unsigned int count;
	objc_property_t *propList 	= class_copyPropertyList(classType, &count);
	NSMS *propPrint 	= NSMS.new;
	for ( int i = 0; i < count; i++ ) {
		objc_property_t prop 	= propList[i];
		const char *propName 	= property_getName(prop);
		NSS	*propNameStr 	= @(propName);
		if(propName) { id value = [self valueForKey:propNameStr];
			[propPrint appendString:[NSS stringWithFormat:@"%@=%@ ; ", propNameStr, value]]; }
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

+ (NSS*) autoDescribe
{
	return $(@"%@:%p::%@", self.class, self, [self autoDescribeWithClassType:[self class]]);
}

- (NSS*) autoDescribe
{
	Class clazz 	= self.class;
	u_int count;
	Ivar* ivars 	= class_copyIvarList(clazz, &count);
	NSMA *ivarArray = NSMA.new;
	for (int i = 0; i < count ; i++)
	{
		const char* ivarName = ivar_getName(ivars[i]);
		[ivarArray addObject:[NSS stringWithUTF8String:ivarName]];
	}
	free(ivars);
	objc_property_t* properties = class_copyPropertyList(clazz, &count);
	NSMA *propertyArray = NSMA.new;
	for (int i = 0; i < count ; i++)
	{
		const char* propertyName = property_getName(properties[i]);
		[propertyArray addObject:[NSS stringWithUTF8String:propertyName]];
	}
	free(properties);

	Method* methods = class_copyMethodList(clazz, &count);
	NSMA *methodArray = NSMA.new;
	for (int i = 0; i < count ; i++)
	{
		SEL selector = method_getName(methods[i]);
		const char* methodName = sel_getName(selector);
		[methodArray addObject:[NSS stringWithUTF8String:methodName]];
	}
	free(methods);
	NSLog(@"%@", 	@{ 	@"ivars" 		: [ivarArray formatAsListWithPadding:30],
						@"properties"	: [propertyArray formatAsListWithPadding:30],
						@"methods"		: [methodArray formatAsListWithPadding:30]});
}

@end

@implementation NSObject (SubclassEnumeration)

+(NSA*)subclasses
{
	NSMA *subClasses 	= NSMA.new;
	Class	*classes	= nil;
	int		count		= objc_getClassList(NULL, 0);
	if (count) {
		classes 		= (Class*)malloc(sizeof(Class) * count);
		NSAssert (classes != NULL, @"Memory Allocation Failed in [Content +subclasses].");
		(void) objc_getClassList(classes, count);
	}
	if (classes) {
		for (int i=0; i<count; i++) {
			Class myClass		= classes[i];
			Class superClass		= class_getSuperclass(myClass);
			if (superClass == self) [subClasses addObject:myClass];
		}
		free(classes);
	}
	return subClasses;
}
@end

@implementation NSObject (AG)

- (id)performSelector: (SEL)selector withObject: (id)p1 withObject: (id)p2 withObject: (id)p3
{
	NSMethodSignature *sig = [self methodSignatureForSelector:selector];
	if (sig) {
		NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
		[invo setTarget:self];
		[invo setSelector:selector];
		[invo setArgument:&p1 atIndex:2];
		[invo setArgument:&p2 atIndex:3];
		[invo setArgument:&p3 atIndex:4];
		[invo invoke];
		if (sig.methodReturnLength) {	id anObject;
										[invo getReturnValue:&anObject];
										return anObject;
		} else	return nil;
	} else 		return nil;
}

- (id)performSelector: (SEL)selector withObject: (id)p1 withObject: (id)p2 withObject: (id)p3  withObject: (id)p4
{
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
		if (sig.methodReturnLength) {	id anObject;
										[invo getReturnValue:&anObject];
										return anObject;
		} else	return nil;
	} else	return nil;
}

- (id)performSelector: (SEL)selector withObject: (id)p1 withObject: (id)p2 withObject: (id)p3
		   withObject: (id)p4 withObject: (id)p5 {
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

- (id)performSelector: (SEL)selector withObject: (id)p1 withObject: (id)p2 withObject: (id)p3
		   withObject: (id)p4 withObject: (id)p5 withObject: (id)p6 {
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

- (id)performSelector: (SEL)selector withObject: (id)p1 withObject: (id)p2 withObject: (id)p3
		   withObject: (id)p4 withObject: (id)p5 withObject: (id)p6 withObject: (id)p7
{
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
		} else 	return nil;
	} else	return nil;
}


//- (IBAction)showMethodsInFrameWork: (id)sender {

	//	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/say" arguments:@[s]];

	//	BOOL isSelected;	NSS*label;
	//	BOOL isSegmented = [sender isKindOfClass:[NSSegmentedControl class]];
	//		//	if (isSegmented) {
	//	NSI selectedSegment = [sender selectedSegment];
	//		//		 = [sender isSelectedForSegment:selectedSegment];
	//	label = [sender labelForSegment:selectedSegment];
	//	BOOL *optionPtr = &isSelected;
	//		//	} else
	//		//		label = [sender label];
	//	SEL fabricated = NSSelectorFromString($(@"set%@:", label));
	//	[[sender delegate] performSelector:fabricated withValue:optionPtr];
	//	[[AZTalker sharedInstance] say:$(@"%@ is %@ selected", string, isSelected ? @"" : @"NOT")];
//}

- (NSS*)segmentLabel
{
	return	[self isKindOfClass:[NSSegmentedControl class]]
	? [(NSSegmentedControl*)self labelForSegment:[(NSSegmentedControl*)self selectedSegment]] : nil;
}

BOOL respondsToString ( id obj, NSS* string) {
	return [obj respondsToString:string];
}

BOOL respondsTo(id obj, SEL selector){
	return [obj respondsToSelector:selector];
}

- (BOOL) respondsToString: (NSS*)string
{
	return [self respondsToSelector:NSSelectorFromString(string)];
}


- (id) respondsToStringThenDo:(NSS*)string 
{
	return 	[self respondsToStringThenDo:string.copy withObject:nil withObject:nil];
}

- (id) respondsToStringThenDo:(NSS*)string withObject:(id)obj {
	return 	[self respondsToStringThenDo:string.copy withObject:obj withObject:nil];
}

- (id) respondsToStringThenDo:(NSS*)string withObject:(id)obj withObject:(id)objtwo 
{
	SEL select = NSSelectorFromString(AZ_RETAIN([string copy]));
	BOOL doesit =  [self respondsToSelector:select];
	return 	doesit && obj && objtwo 	? [self performSelectorARC:select withObject:obj withObject:objtwo]
			:	doesit && obj 				? [self performSelectorARC:select withObject:obj]
			:	doesit 						? [self cw_ARCPerformSelector:select] : nil;
}



- (IBAction)performActionFromLabel: (id)sender;
{
	NSS *stringSel, *setter;
	if ([sender isKindOfClass:[NSPopUpButton class]]) stringSel = [sender titleOfSelectedItem];
	else if ([sender isKindOfClass:[NSButton class]]) stringSel = [sender title];
	else if ([sender respondsToSelector:@selector(label)]) stringSel = [sender label];
	setter = $(@"set%@:",[stringSel uppercaseString]);
	if ([self respondsToString:stringSel])  [self performSelectorSafely:NSSelectorFromString(stringSel)];
	else if ([self respondsToString:setter])  [self performSelectorWithoutWarnings:NSSelectorFromString(setter) withObject:nil];
}
- (IBAction)performActionFromSegmentLabel: (id)sender;
{
	if ([sender isKindOfClass:NSSegmentedControl.class]) {
		NSS *label = [sender labelForSegment:[sender selectedSegment]];	//		BOOL *optionPtr = &isSelected;
		if ([self respondsToString:label])
			[self  performSelector:NSSelectorFromString(label) withValue:nil];
	}
}

- (IBAction)increment: (id)sender;
{
	BOOL isSegmented = [sender isKindOfClass:[NSSegmentedControl class]];
	if (isSegmented) {
		BOOL isSelected;	NSS*label;
		NSI selectedSegment = [sender selectedSegment];
		label = [sender labelForSegment:selectedSegment];
//		BOOL *optionPtr = &isSelected;

		NSI prop = [self integerForKey:label];
		NSI newVal = (prop+1);
		[self setValue:[NSVAL value: (const void*)newVal withObjCType:[self typeOfPropertyNamed:label]] forKey:label];
	}
}



- (void)setFromSegmentLabel: (id)sender {

	BOOL isSelected;	NSS*label;
	BOOL isSegmented = [sender isKindOfClass:[NSSegmentedControl class]];
	if (isSegmented) {
		NSI selectedSegment = [sender selectedSegment];
		//		 = [sender isSelectedForSegment:selectedSegment];
		label = [sender labelForSegment:selectedSegment];
		BOOL *optionPtr = &isSelected;

		SEL fabricated = NSSelectorFromString($(@"set%@:", label));
		[[sender delegate] performSelector:fabricated withValue:optionPtr];
	}
	//	[[AZTalker sharedInstance] say:$(@"%@ is %@ selected", string, isSelected ? @"" : @"NOT")];
}
//- (void)performActionFromLabel: (id)sender {
//
//	BOOL isSelected;	NSS*label;
//	BOOL isButton = [sender isKindOfClass:[NSButton class]];
//	NSI buttonState = [sender state];
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
//	NSLog (@"%s", (char *) aSelector);
//	return ([super respondsToSelector: aSelector]);
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
		return attribute[0] == 'T' && attribute[1] != '@' ? (const char *)[[NSData dataWithBytes: (attribute + 1) length:strlen(attribute) - 1] bytes]
		// it's an ObjC id type:
		: attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2  ? "id"
		// it's another ObjC object type:
		: attribute[0] == 'T' && attribute[1] == '@' ? (const char *)[[NSData dataWithBytes: (attribute + 3) length:strlen(attribute) - 4] bytes]
		: "";
	}
}
+ (NSD *)classPropsFor: (Class)klass
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
 - (NSA*) methodDumpForClass: (Class)klass {

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

 // Convert to NSArray of NSSs
 NSMA*rtn = [[NSMA alloc] init];
 const char *cname;
 for (int i=0; i&lt;numClasses; i++) {
 cname = class_getName(classes[i]);
 //	  if (NULL == strstr(cname, &quot;MusicalScale&quot;))
 //		  continue;
 [rtn addObject:[NSS stringWithCString:cname
 encoding:NSSEncodingConversionAllowLossy]];
 }
 free(classes);

 //	return rtn;
 return [rtn filteredArrayUsingPredicate:predicate];
 }	*/

- (NSS*) methods {
	return [[[self class] classMethods]formatAsListWithPadding:30];
}

+ (NSA*)classMethods
{
	const char* className = class_getName([self class]);
	int unsigned numMethods;
	NSMA *ii = [NSMA array];
	Method *methods = class_copyMethodList(objc_getMetaClass(className), &numMethods);
	for (int i = 0; i < numMethods; i++) {
		[ii addObject:NSStringFromSelector(method_getName(methods[i]))];
		//		NSLog(@"%@", NSStringFromSelector(method_getName(methods[i])));
	}
	return ii.copy;
}

// aps suffix to avoid namespace collsion
//   ...for Andrew Paul Sardone
//- (NSD *)propertiesDictionariate;


- (NSS*) stringFromClass {	return NSStringFromClass(self.class); }
- (void) setIntValue:   (NSI)i forKey: 	   (NSS*)key 	 { [self setValue:[NSNumber numberWithInt:i] forKey:key]; }
- (void) setIntValue:   (NSI)i forKeyPath: (NSS*)keyPath { [self setValue:[NSNumber numberWithInt:i] forKeyPath:keyPath]; }
- (void) setFloatValue: (CGF)f forKey:     (NSS*)key 	 { [self setValue:[NSNumber numberWithFloat:f] forKey:key]; }
- (void) setFloatValue: (CGF)f forKeyPath: (NSS*)keyPath { [self setValue:[NSNumber numberWithFloat:f] forKeyPath:keyPath]; }

- (BOOL) isEqualToAnyOf: (id<NSFastEnumeration>)enumerable {	for (id o in enumerable) { if ([self isEqual:o]) return YES; } return NO; }

- (void) fire: (NSS*)notificationName { [AZNOTCENTER postNotificationName:notificationName object:self]; }

- (void) fire: (NSS*)notificationName userInfo: (NSD *)context	{	[AZNOTCENTER postNotificationName:notificationName object:self userInfo:context];	}

- (id) observeObject: (NSS*)notificationName usingBlock: (void (^)(NSNOT*))block
{
	return [AZNOTCENTER addObserverForName:notificationName	object:self queue:nil usingBlock:block];
}
- (id) observeName: (NSS*)notificationName  usingBlock: (void (^)(NSNOT*))block
{
	return [AZNOTCENTER addObserverForName:notificationName	object:self queue:nil usingBlock:block];
}
-(void) observeObject: (NSObject *)object forName: (NSS*)notificationName calling: (SEL)selector
{
	[AZNOTCENTER addObserver:self selector:selector name:notificationName object:object];
}
-(void)observeName: (NSS*)notificationName  calling: (SEL)selector
{
	[AZNOTCENTER addObserver:self selector:selector  name:notificationName object:nil];
}
-(void)stopObserving: (NSObject *)object forName: (NSS*)notificationName
{
	[AZNOTCENTER removeObserver:self name:notificationName object:object];
}

-(id) performSelectorSafely: (SEL)aSelector;
{
	NSParameterAssert ( aSelector != NULL );
	NSParameterAssert ( [self respondsToSelector:aSelector] );
	NSMethodSignature* methodSig = [self methodSignatureForSelector:aSelector];
	if ( methodSig == nil ) return nil;
	const char* retType = [methodSig methodReturnType];
	if(strcmp(retType, @encode(id)) == 0 || strcmp(retType, @encode(void)) == 0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		return [self performSelector:aSelector];
#pragma clang diagnostic pop
	} else {
		NSLog(@"-[%@ performSelector:@selector(%@)] shouldn't be used. The selector doesn't return an object or void", [self className], NSStringFromSelector(aSelector));
		return nil;
	}
}

- (id)performSelectorARC:(SEL)selector withObject:(id)obj {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	return [self performSelector:selector withObject:obj];
#pragma clang diagnostic pop
}
-(id)performSelectorARC:(SEL)selector withObject:(id)one withObject:(id)two
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	return [self performSelector:selector withObject:one withObject:two];
#pragma clang diagnostic pop
}

- (id) performSelectorWithoutWarnings: (SEL)aSelector {	return  [self performSelectorSafely:aSelector]; }

- (id) performSelectorWithoutWarnings: (SEL)aSelector withObject: (id)obj
{
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	//	return (id)
	[self performSelector:aSelector withObject:obj];
	#pragma clang diagnostic pop
}

- (id) performSelectorWithoutWarnings: (SEL)aSelector withObject: (id)obj withObject: (id)obj2 {
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	//	return	(id)
	[self performSelector:aSelector withObject:obj withObject:obj2];
	#pragma clang diagnostic pop
}

-(void)performSelector: (SEL)aSelector afterDelay: (NSTimeInterval)seconds
{
	[self performSelector:aSelector withObject:nil afterDelay:seconds];
}
-(void)observeKeyPath: (NSS*)keyPath
{
	[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
-(void)addObserver: (NSObject *)observer forKeyPath: (NSS*)keyPath
{
	[self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
}
-(void)addObserver: (NSObject *)observer forKeyPaths: (id<NSFastEnumeration>)keyPaths
{
	for (NSS*keyPath in keyPaths) [self addObserver:observer forKeyPath:keyPath];
}

-(void)removeObserver: (NSObject *)observer  forKeyPaths: (id<NSFastEnumeration>)keyPaths
{
	for (NSS*keyPath in keyPaths) { 	[self removeObserver:observer forKeyPath:keyPath]; }
}

-(void) willChangeValueForKeys: (id<NSFastEnumeration>)keys { for (id key in keys) [self willChangeValueForKey:key];  }

-(void) didChangeValueForKeys:  (id<NSFastEnumeration>)keys { for (id key in keys) [self didChangeValueForKey:key]; }

-(NSD*) dictionaryWithValuesForKeys { return [self dictionaryWithValuesForKeys:[self allKeys]]; }

-(NSA*) allKeys
{
	Class clazz = self.class;	 u_int count;
	objc_property_t* properties 	= class_copyPropertyList(clazz, &count);
	NSMA* propertyArray = [NSMA arrayWithCapacity:count];
	for (int i = 0; i < count ; i++) {
		const char* propertyName = property_getName(properties[i]);
		[propertyArray addObject:@(propertyName)];
	}
	free(properties);
	return propertyArray.copy;
}

- (void)setClass: (Class)aClass
{
	NSAssert( class_getInstanceSize([self class]) == class_getInstanceSize(aClass),	@"Classes must be the same size to swizzle.");
	object_setClass(self, aClass);
}

+(id)newFromDictionary: (NSD*)dic {	return [self.class customClassWithProperties:dic];	}

//	In your custom class
+ (id)customClassWithProperties: (NSD *)properties { return [[[self alloc] initWithProperties:properties] autorelease];}

- (id)initWithProperties: (NSD *)properties {
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

- (void*)performSelector: (SEL)selector withValue: (void*)value {
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
	[invocation setSelector:selector];
	[invocation setTarget:self];
	[invocation setArgument:value atIndex:2];
	[invocation invoke];
	NSUInteger length = [[invocation methodSignature] methodReturnLength];

	if (length > 0) {		// If method is non-void:
		void *buffer = (void*)malloc(length);
		[invocation getReturnValue:buffer];
		return buffer;
	}
	return NULL;			// If method is void:

}
@end

@implementation NSD (PropertyMap)

//- (void)mapPropertiesToObject: (id)instance
//{
//	[[instance class].codableKeys do:^(NSS* propertyKey) {
//		[instance canSetValueForKey:propertyKey] ? [instance setValue:self[propertyKey]	forKey:propertyKey] : nil;
//	}];
//}

@end

@implementation NSObject (KVCExtensions)

- (void) setPropertiesWithDictionary: (NSD*)dictionary {		[dictionary mapPropertiesToObject:self];	}

// Can set value for key follows the Key Value Settings search pattern as defined in the apple documentation
- (BOOL)canSetValueForKey: (NSS*)key
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
			if (strcmp(name, pattern1) == 0 || strcmp(name, pattern2) == 0 || strcmp(name, pattern3) == 0 || strcmp(name, pattern4) == 0) { return YES; }
			ivarList++;
		}
	}
	return NO;
}

// Traverse the key path finding you can set the values. Keypath is a set of keys delimited by "."
- (BOOL)canSetValueForKeyPath: (NSS*)keyPath
{
	NSRange delimeterRange = [keyPath rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"."]];
	if (delimeterRange.location == NSNotFound) return [self canSetValueForKey:keyPath];
	NSS *first	= [keyPath substringToIndex:	delimeterRange.location		];
	NSS *rest 	= [keyPath substringFromIndex: (delimeterRange.location + 1)];
	return [self canSetValueForKey:first] ? [[self valueForKey:first] canSetValueForKeyPath:rest] : NO;
}

@end


@implementation  NSObject (ImageVsColor)

- (NSC*)colorValue
{
	if ([self isKindOfClass:NSC.class]) return (NSC*)self;
	NSC *c = [self isKindOfClass:NSIMG.class] ? ((NSIMG*)self).quantize[0] : nil;
	return c ?: [self respondsToString:@"color"] ? [self valueForKey:@"color"] : nil;
}
- (NSIMG*)imageValue;
{
	if ([self isKindOfClass:NSIMG.class]) return (NSIMG*)self;
	NSIMG *i = [self isKindOfClass:NSC.class] ? [NSIMG swatchWithColor:(NSC*)self size:AZSizeFromDimension(256)] : nil;
	return  i ?: [self respondsToString:@"image"] ? [self valueForKey:@"image"] : nil;
}

@end

#import <ApplicationServices/ApplicationServices.h>

@implementation NSObject (NoodlePerformWhenIdle)

// Heard somewhere that this prototype may be missing in some cases so adding it here just in case.
CG_EXTERN CFTimeInterval CGEventSourceSecondsSinceLastEventType( CGEventSourceStateID source, CGEventType eventType )  AVAILABLE_MAC_OS_X_VERSION_10_4_AND_LATER;


// Semi-private method. Used by the public methods
- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterSystemIdleTime:(NSTimeInterval)delay withinTimeLimit:(NSTimeInterval)maxTime startTime:(NSTimeInterval)startTime
{
	CFTimeInterval	idleTime;
	NSTimeInterval	timeSinceInitialCall;

    timeSinceInitialCall = [NSDate timeIntervalSinceReferenceDate] - startTime;

	if (maxTime > 0)
	{
		if (timeSinceInitialCall >= maxTime)
		{
			[self performSelectorWithoutWarnings:aSelector withObject:anArgument];
			return;
		}
	}

	idleTime = CGEventSourceSecondsSinceLastEventType(kCGEventSourceStateHIDSystemState, kCGAnyInputEventType);
	if (idleTime < delay)
	{
		NSTimeInterval		fireTime;
		NSMethodSignature	*signature;
		NSInvocation		*invocation;

		signature = [self methodSignatureForSelector:@selector(performSelector:withObject:afterSystemIdleTime:withinTimeLimit:startTime:)];
		invocation = [NSInvocation invocationWithMethodSignature:signature];
		[invocation setSelector:@selector(performSelector:withObject:afterSystemIdleTime:withinTimeLimit:startTime:)];
		[invocation setTarget:self];
		[invocation setArgument:&aSelector atIndex:2];
		[invocation setArgument:&anArgument atIndex:3];
		[invocation setArgument:&delay atIndex:4];
		[invocation setArgument:&maxTime atIndex:5];
		[invocation setArgument:&startTime atIndex:6];

		fireTime = delay - idleTime;
		if (maxTime > 0)
		{
			fireTime = MIN(fireTime, maxTime - timeSinceInitialCall);
		}

		// Not idle for long enough. Set a timer and check back later
		[NSTimer scheduledTimerWithTimeInterval:fireTime invocation:invocation repeats:NO];
	}
	else
	{
		[self performSelectorWithoutWarnings:aSelector withObject:anArgument];
	}
}


- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterSystemIdleTime:(NSTimeInterval)delay
{
	[self performSelector:aSelector withObject:anArgument afterSystemIdleTime:delay withinTimeLimit:-1];
}


- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterSystemIdleTime:(NSTimeInterval)delay withinTimeLimit:(NSTimeInterval)maxTime
{
	SInt32	version;

	// NOTE: Even though CGEventSourceSecondsSinceLastEventType exists on Tiger,
	// it appears to hang on some Tiger systems. For now, only enabling for Leopard or later.
	if ((Gestalt(gestaltSystemVersion, &version) == noErr) && (version >= 0x1050))
	{
		NSTimeInterval		startTime;

		startTime = [NSDate timeIntervalSinceReferenceDate];

		[self performSelector:aSelector withObject:anArgument afterSystemIdleTime:delay withinTimeLimit:maxTime startTime:startTime];
	}
	else
	{
		// For pre-10.5, just call it after a delay. Change this if you want to throw an exception
		// instead.
		[self performSelector:aSelector withObject:anArgument afterDelay:delay];
	}
}


@end
