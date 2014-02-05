
#import "AtoZ.h"
#import "BaseModel+AtoZ.h"
//static NSString *const BaseModelSharedInstanceKey = @"sharedInstance";
//static NSString *const BaseModelLoadingFromResourceFileKey = @"loadingFromResourceFile";
void logClassMethods(NSString *className)	{

    unsigned int numMethods = 0;
    Method *methodList = class_copyMethodList(object_getClass([NSClassFromString(className)  new]), &numMethods);
    NSMutableArray *methods = NSMutableArray.new;
    for (int i = 0; i < numMethods; i++)
    {
        const char *methodName = sel_getName(method_getName(methodList[i]));
        [methods addObject:[NSString stringWithUTF8String:methodName]];
    }
    NSArray *sortedMethods = [methods sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    for (int i = 0; i < [sortedMethods count]; i++)
        NSLog(@"%@: %@", className, [sortedMethods objectAtIndex:i]);
}

@interface BaseModel ()
@property (copy) KVOLastChangedBlock lastChangedBlock;
@property (copy) KVONewInstanceBlock newInstanceBlock;
@end

static NSMD *SUPERDICTIONARY	= nil;	static NSN	 *INSTANCE_CT 	= nil, *SUBCLASSES_CT = nil, *SUBCLASSES_INSTANCE_CT = nil;
static NSS 	*LAST_MOD_KEY 		= nil;	static 	id  LAST_MOD_INST	= nil;			 static char  CNVRT_XML_KEY = false;		
@implementation BaseModel (AtoZ)

- (instancetype) sharedInstance {

	return [self.class sharedInstance];
}


@synthesizeAssociation(BaseModel,defaultCollection)
@synthesizeAssociation(BaseModel,classSiblings)
@synthesizeAssociation(BaseModel,classSiblingIndex)
@synthesizeAssociation(BaseModel,classSiblingIndexMax)
/*#pragma mark - Inits, Overrides, and Swizzles
+  (void) load					{ 	[(NSO*)self performAsynchronous:^{

		SUPERDICTIONARY 			= @{ AZCLSSTR : NSMA.mutableArrayUsingWeakReferences }.mutableCopy;
		INSTANCE_CT 				= @0;
		SUBCLASSES_CT 				= @0;
		SUBCLASSES_INSTANCE_CT 	= @0;						}];
}
+ (NSMD*) superD 				{ return SUPERDICTIONARY; } 	*//*returns SUPERDICTIONARY */
/*

+  (void) initialize			{	//	invokeSupersequent();	if (!SUPERDICTIONARY) {		static dispatch_once_t onceToken;		dispatch_once(&onceToken, ^{    	});	}
//	AZLOGCMD;
	if ([SUPERDICTIONARY objectForKey:AZCLSSTR]) return;
	[(NSO*)self performAsynchronous:^{	
		[SUPERDICTIONARY setValue:NSMA.mutableArrayUsingWeakReferences forKey:AZCLSSTR];	
		[SUBCLASSES_CT increment];
	}];
	LOGCOLORS(@"new basemodel sublass: ", AZCLSSTR, @" Subclasses:", SUBCLASSES_CT, RANDOMPAL, nil);
	[$ swizzleMethod:@selector(setUp)  with:@selector(swizzleSetUp) in:BaseModel.class];	
//	[$ swizzleMethod:@selector(save)   with:@selector(swizzleSave)  in:[BaseModel class]];	

}	*//* Instantiate pointerarray, swizzle methods	 */

//	invokeSupersequent();	[AZSSOQ addOperation:[NSBlockOperation blockOperationWithBlock:^{		NSLog(@"created BaseModel SuperD:%@ via:%@", self.superD, AZCLSSTR);
//+ (void) initialize {	}	/* ASYNC superD instantiate...  Swizzles setUp. */
//			NSLog(@"created superD entry for %@.  %ld Subclasses existant.", AZCLSSTR, SUPERDICTIONARY.allKeys.count);

//	if (self == [Someclass class]) {	[super load];	printf(__PRETTY_FUNCTION__);
//	[@[@"init"] each:^(NSS* obj) {  		/ \*@"save"	[$ swizzleClassMethod:in:self.class with:in:self.class]; * /
//		NSS* swizzed = $(@"swizzle%@%@",obj.firstLetter.capitalize, [obj substringFromIndex:1]);
//		LOGCOLORS(GREEN, YELLOW,@"swizzling With:", swizzed, nil);
//		NSLog(@"settinging up swixzzle init in subclass?: %@", AZCLSSTR);
//	}];
//		[$ swizzleClassMethod:@selector(resourcePath) with:@selector(swizzleResourcePath) in:self.class];

//- (void)	swizzleSetUp		{			// increment class counter 		//	[self swizzleSetUp];

//	NSLog(@"adding instance: %@. BeforeCt: %ld",instance, self.instanceCt); //if ([DICTIONARY[AZCLSSTR] doesNotContainObject:self])
//	[(NSMA*)self.class.superD[AZCLSSTR] addObject:self]; 
//	[SUBCLASSES_INSTANCE_CT increment];
//}  	// Post NewInstance Notification, addself to PointerArray, Associate instance number.
/*
+ (instancetype) swizzleInstance {
	fprintf(stderr, "swizzleSetup:%s\n", AZCLSSTR.UTF8String);
	id selfi = [self swizzleInstance];	
	[self addInstance:selfi];// [self swizzleInit]];
	return selfi;
----
	return self;
INSTANCE_CT++;	//	NSLog(@"classinstances: %lu", INSTANCE_CT);
	[self setAssociatedValue:@(INSTANCE_CT) forKey:@"instanceNumber" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
----
	Class c = 	[[[BaseModel class]subclasses] filterOne:^BOOL(id object) {
		return [self ISKINDA:object];
	}];
	NSString *subclassSelect = $(@"allInstancesAccessor%@:",AZCLSSTR);
	
	[c addMethodForSelector:NSSelectorFromString(obj) typed:"@@:" implementation:^ (id self, SEL _cmd) {
		  static NSMA* internalAndWeak = nil;
		if (internalAndWeak == nil) 	internalAndWeak = NSMA.mutableArrayUsingWeakReferences;
		if (instance == nil) return  internalAndWeak;
		else [internalAndWeak addObject:instance];  
		return nil;	

			NSLog(@"Called -[%@ %@] with void return", [self class], NSStringFromSelector(_cmd));
	}];
	[foo performSelector:stringified];


	NSLog(@"Subclasses: %@   IMAKINDA:%@", [self class].subclasses, NSStringFromClass([self class]));
	[[self.classProxy valueForKey:NSStringFromClass(c)] performSelector:@selector(allInstancesAddOrReturn:) withObject:self];
	[AZNOTCENTER postNotificationName:BaseModelDidAddNewInstance object:self];
	[self.class.sharedInstance setValue:self forKey:@"keyChanged"];
	if (self == sharedI)	[iClass setLastModifiedKey:@"newSharedInstance" instance:self];
 Class method - set last modified
	else [self.class setLastModifiedKey:@"newInstance" instance:self];
 Instance method - dummy setValue to dispatch notifications
	[self.class.sharedInstance willChangeValueForKey:@"instances"];
	[self.class.sharedInstance setValue:@"newInstance" forKey:@"keyChanged"];
	[self.class.sharedInstance didChangeValueForKey:@"instances"];
	printf("%s",$(@"finished swizleInit for Instance %lu in class:  %@", INSTANCE_CT, self.class).UTF8String);
// [[NSKeyedUnarchiver unarchiveObjectWithFile:[self localStorePath]] mutableCopy];
//	if (DICTIONARY == nil) DICTIONARY = NSMD.new;// [[NSKeyedUnarchiver unarchiveObjectWithFile:[self localStorePath]] mutableCopy];
//	if (![self dictionary][NSStringFromClass([self class])])  [self.dictionary setValue:NSMA.new / *mutableArrayUsingWeakReferences* / forKey:AZCLSSTR];
//	if (internalAndWeak == nil) 	internalAndWeak = NSMA.mutableArrayUsingWeakReferences;
//	if (instance == nil) return  internalAndWeak;
//	else
----
- (void)addCustomMethodToObject:(id)object {
  Class objectClass = object_getClass(object);
  SEL selectorToOverride = ...; // this is the method name you want to override

  NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
  Class c = NSClassFromString(newClassName);
  if (c == nil) {
    // this class doesn't exist; create it
    // allocate a new class
    c = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
    // get the info on the method we're going to override
    Method m = class_getInstanceMethod(objectClass, selectorToOverride);
    // add the method to the new class
    class_addMethod(c, selectorToOverride, (IMP)myCustomFunction, method_getTypeEncoding(m));
    // register the new class with the runtime
    objc_registerClassPair(c);
  }
  // change the class of the object
  object_setClass(object, c);
}
id myCustomFunction(id self, SEL _cmd, [other params...]) {
  // this is the body of the instance-specific method
  // you may call super to invoke the original implementation
}
*/
#pragma mark - Deep Introspection

//- (NSA*) classSiblings					{
////	return [self.superlayer.sublayers arrayByRemovingObject:self];
//}
//- (NSUI) classSiblingIndex		  	{
////	return MAX([self.superlayer.sublayers indexOfObject:self] + 1, 0);
//}
//- (NSUI) classSiblingIndexMax	  	{
////	return MAX(self.superlayer.sublayers.count - 1, 0);
//}

/*
+ (NSN*) activeSubclasses	{ return SUBCLASSES_CT; 												}
+ (NSN*) allInstanceCt   	{ return SUBCLASSES_INSTANCE_CT; 									}
+ (NSN*) instanceCt			{ return [(NSA*)self.superD[AZCLSSTR] vFKP:@"@count"]; 		}	/ *		Number of class instamces TOTAL.  Living and dead.		* /
- (NSN*) instanceCt			{ return [(NSA*)self.class.superD[AZCLSSTR]vFKP:@"@count"];	}
- (NSA*) allInstances		{ return  self.class.superD[AZCLSSTR];		  						}
+ (NSA*) allInstances 		{ return  self.superD[AZCLSSTR];		 		 						}
//return [[self allInstancesAddOrReturn:nil] arrayOfClass:self.class]; }
//+ (NSMA*) superDictionary 	{
//	if (![SUPERDICTIONARY objectForKey:AZCLSSTR]) {
//		NSLog(@"creating superD for %@", AZCLSSTR);
//		[SUPERDICTIONARY setValue:NSMA.mutableArrayUsingWeakReferences forKey:AZCLSSTR];
//	}
//	return SUPERDICTIONARY[AZCLSSTR];
//}
- (NSN*) instanceNumber 										{ return @([self.class.allInstances indexOfObject:self]); }	// 	EAch object knows its "place" in the birthcycle.

- (void) forwardInvocation:(NSINV*)invocation 			{  // FIERCE

// Forward the message to the surrogate object if the surrogate object understands the message, otherwise just pass the invocation up the inheritance chain, eventually hitting the default -forwardInvocation: which will throw an unknown selector exception.
	self.defaultCollection && [self.defaultCollection respondsToSelector:[invocation selector]]
									?				   [invocation invokeWithTarget:self.defaultCollection]:nil;
//									:										 [super forwardInvocation:invocation];
}
- (SIG*) methodSignatureForSelector:(SEL)sel				{
	// To build up the invocation passed to -forwardInvocation properly, the object must provide the types for parameters and return values for the NSInvocation through -methodSignatureForSelector:
    return [super methodSignatureForSelector:sel] ?: [self.defaultCollection methodSignatureForSelector:sel];
}
- (BOOL) respondsToSelector:(SEL)selector 				{
	// Claim to respond to any selector that our surrogate object also responds to.
    return [super respondsToSelector:selector] || [self.defaultCollection respondsToSelector:selector];
}	/ * All methods above are fierce Posing classes * /

- (void) setValue:(id)v forKey:(NSS*)k						{

/ * 	sharedInstance -	returns our the singleton instance that will be used for global observing

	+ (SampleObject*)sharedInstance	{	 static SampleObject* singleton;	 @synchronized(self)	 {	if (!singleton) singleton = SampleObject.new;	return singleton;	 }	 return singleton; }	
	Key Value Bastard Observing (KVBO) is everything below.	 We overload setValue:forKey: to listen to all changes. 
	We save self and the key name to static variables with the class method 
	 	setLastModifiedKey:forInstance:	 
		setValue:forKey:	 
	then sets a new value for a dummy key (keyChanged) on a shared instance (a singleton for the observed class, here SampleObject).
	Changing this dummy key's value dispatches KVO notifications of our shared instance :any observer of that shared instance will receive all notifications of all changes of all instances of SampleObject.

	To receive KVBO notifications, register as an observer on the shared instance's dummy key. You'll need to setup a dummy key, its set method will be the notification recipient of KVBO.

	 [myObserver bind:@"myKey" toObject:[SampleObject sharedInstance] withKeyPath:@"keyChanged" options:nil];

	 myObserver's setMyKey will then be called for each change of any attribute of any instance.		* /

							//	overload to dispatch change notification to our shared instance

	if (![self canSetValueForKey:k]) {  NSLog(@"Asked to, but canot set val for: %@.  Will try.", k);
		[self setAssociatedValue:v forKey:k policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];	//	[super setValue:v forUndefinedKey:k];
	}
	self == sharedI ? nil : ^{			// If this is the shared instance, don't go any further
		NSLog(@"setting LAST_MOD_KEY: %@ forclass:%@  withInstance:%@  instance%@ of %@", k, AZCLSSTR, self, self.class.instanceCt, self.instanceNumber);
		[iClass  setLastModifiedKey:k instance:self];	// Class method - set last modified
		[sharedI setValue:self forKey:@"keyChanged"];	// Instance method - dummy setValue to dispatch notifications
	}();
// KVO  class-level block!
	[SampleObject setLastChangedBlock:^(NSS *whatKeyChanged, id whichInstance, id newVal) {
		_result = $(@"Object: %@'s valueForProp:\"%@\" changed to: %@\n",	[(BaseModel*)whichInstance uniqueID], whatKeyChanged, newVal);
	}];
* /
	KVOLastChangedBlock b = ((BaseModel*)self.class.sharedInstance).lastChangedBlock;
	b ? b(k, self, v) : nil;
	[super setValue:v forKey:k];
}
#pragma  mark - Default Collections
//-  (void) setDefaultCollectionKey:(NSS*)dK				{	[self setAssociatedValue:dK forKey:@"defaultCollectionKey" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];	}  // OK
//-  (NSS*) defaultCollectionKey 								{
//	return [self hasAssociatedValueForKey:@"defaultCollectionKey"] ? [self associatedValueForKey:@"defaultCollectionKey"] : @"items";
//}  // OK 
//
//- (void) setDefaultCollection:(id)defaultCollection	{
//	[self setAssociatedValue:defaultCollection forKey:@"collectionBackingStore" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
//	[self setDefaultCollectionKey:@"collectionBackingStore"];
//}
//- (NSO*) 	defaultCollection 									{ return [self associatedValueForKey:@"collectionBackingStore" orSetTo:NSMA.new]; }
//NSS* key;
//	id collection =  self.defaultCollectionIsMethods 	? [self instanceMethodNames] :
//						  self.defaultCollectionKey 			? ^{
//			if (SameString(self., id b):@"collectionBackingStore"]) return [self associatedValueForKey:@"collectionBackingStore" ];
//			return [self hasPropertyForKVCKey:key]  ? [self vFK:key] : nil;
//		}() : nil;	}
//			if ([self respondsToString:key] && [finder = [self performString:key] conformsToProtocol:@protocol(NSFastEnumeration)]) return finder;
			if ([key isEqualToString:@"items"]) self vFK:] ?: [self vFK:@"content"] ?: [self vFK:@"objects"] ?: nil;
//			if 
//				return  	? 	[self vFKP:key] : [self vFK:key]; }()	*/
#pragma mark - KVBO
+ (void) setLastModifiedKey:	 (NSS*)k instance:(id)x	{	LAST_MOD_KEY	= k;
																			LAST_MOD_INST	= x;
}
+ (INST) lastModifiedInstance									{	return LAST_MOD_INST;				}
+ (NSS*) lastModifiedKey										{	return LAST_MOD_KEY;						}
- (INST) keyChanged												{  return self.class.sharedInstance; 		}
/** keyChanged -	dummy key set by setValue:forKey: on sharedInstance, used 2 dispatch KVO notes. */
- (void) setKeyChanged: (id) dummy							{														}

#pragma mark - KVO Blocks
+ (void) setLastChangedBlock:(KVOLastChangedBlock)lastChgdBlk 	{
	[self.sharedInstance setLastChangedBlock:lastChgdBlk];
}
- (void) setLastChangedBlock:(KVOLastChangedBlock)lastChgdBlk	{
	[self setAssociatedValue:[lastChgdBlk copy] forKey:@"lastChangedBlockStorage" policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}
- (KVOLastChangedBlock) lastChangedBlock 								{	return [self associatedValueForKey:@"lastChangedBlockStorage"] ?: nil;
}
+ (void) setNewInstanceBlock:(KVONewInstanceBlock)onInitBlock	{	[self.sharedInstance setNewInstanceBlock:onInitBlock];	}
- (void) setNewInstanceBlock:(KVONewInstanceBlock)onInitBlock	{

	[self setAssociatedValue:[onInitBlock copy]
							forKey:@"onInitBlockStorage"
							policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}
- (KVONewInstanceBlock) newInstanceBlock 								{	return [self associatedValueForKey:@"onInitBlockStorage"] ?: nil; }
#pragma mark - BaseModel Related
+ (NSS*) saveFolder {
	//get the path to the application support folder
	__block NSString *folder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED		//append application name on Mac OS
	folder = [folder stringByAppendingPathComponent:[AZAPPBUNDLE bundleIdentifier]];
#endif
		//create the folder if it doesn't exist
	return [AZFILEMANAGER fileExistsAtPath:folder] ? folder : ^{ return 
				[AZFILEMANAGER createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL], folder; }();
}
- (NSS*) saveFolder {
	//get the path to the application support folder
	__block NSString *folder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED		//append application name on Mac OS
	folder = [folder stringByAppendingPathComponent:[AZAPPBUNDLE bundleIdentifier]];
#endif
		//create the folder if it doesn't exist
	return [AZFILEMANAGER fileExistsAtPath:folder] ? folder : ^{ return 
				[AZFILEMANAGER createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL], folder; }();
}
+ (NSS*) saveSharedFile { return   [[self.saveFolder withPath:AZCLSSTR]withExt:@"plist"]; }
- (NSS*) saveFile {  return [self.class hasSharedInstance] && self == self.class.sharedInstance ? [[self.saveFolder withPath:AZCLSSTR]withExt:@"plist"] : [[self.saveFolder withPath:self.uniqueID]withExt:@"plist"]; }
- (void) swizzleSave									{	//[self swizzleSave];

	NSLog(@"swizzlesavin!");
//	if ([self.class hasSharedInstance] && self == self.class.sharedInstance) {
//			[self writeToFile:saveP atomically:YES];
//			[AtoZ plistToXML:];
//	}
//	else  {
//		NSS* saveP = [[self.saveFolder withPath:self.uniqueID]withExt:@"plist"];
		[self writeToFile:self.saveFile atomically:YES];
		if ([AZFILEMANAGER fileExistsAtPath:self.saveFile])
//			printf("swizzlin / converting to XML: %s", saveP.UTF8String);
			[AtoZ plistToXML:self.saveFile];
//		}
//	}
}


- (BOOL) convertToXML								{
	return YES;
//	IMP d;
//	if ((d  = [[self class] instanceMethodForSelector:_cmd] ))  {
//		if (d != [[BaseModel class] instanceMethodForSelector:_cmd]) {
//			 NSLog(@"%@ directly implements %@", [self class], NSStringFromSelector(_cmd));  
//			return YES;
//		} else if ([self respondsToSelector:_cmd]) return [self convertToXML];
//	}
//	return [[self associatedValueForKey:@"convertToXML" orSetTo:@NO policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]boolValue];
	//hasAssociatedValueForKey: $UTF8(&CNVRT_XML_KEY)]? [objc_getAssociatedObject(self, &CNVRT_XML_KEY) boolValue] : NO;
}
- (void) setConvertToXML:(BOOL)convertToXML	{
	[self setAssociatedValue:@(convertToXML) forKey:@"convertToXML"];
//	 orSetTo:@NO policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]boolValue];
//	objc_setAssociatedObject(self, &CNVRT_XML_KEY, @(convertToXML), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSA*) superProperties 							{ return  [BaseModel propertyNames]; }
- (NSS*) uniqueID										{

	NSS* u 	=	[self associatedValueForKey:@"uniqueid"];
	if (!u)		[self setAssociatedValue: self.class.newUniqueIdentifier
			  								forKey: @"uniqueid" policy: OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	return u ?: [self associatedValueForKey:@"uniqueid"];
}
#pragma mark - Subscription
-   (id) objectAtIndexedSubscript:(NSUI)idx	 						{

	return 	[self respondsToString:@"objectAtIndex:"] 
			? 	[(NSA*)self objectAtIndex:idx] : AZNULL;
}
- (void) setObject:(id)o atIndexedSubscript:(NSUI)idx  			{

	if ([self respondsToString:@"setObject:atIndex:"])
		 [(NSMutableOrderedSet*)self setObject:o atIndex:idx];
}
- (void) setObject:(id)o forKeyedSubscript:(id<NSCopying>)key	{

	if ([self canSetValueForKey:[(id)key stringValue]]) [self setValue:o forKey:[(id)key stringValue]];
	else  [self setAssociatedValue:o forKey:[(id)key stringValue] policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}
-   (id) objectForKeyedSubscript:(id)key 								{

	return 	[self hasPropertyForKVCKey:key] ? [self valueForKey:key] :
				[self valueForKeyPath:[(id)key stringValue]] ?: objc_getAssociatedObject(self,(__bridge const void *)key) ?: AZNULL;
}
//-   (id) valueForUndefinedKey:(NSS*)key 								{
//	BOOL 	 hasASS 	= [self hasAssociatedValueForKey:key];
//		 	 hasASS	? LOGCOLORS(GRAY5, NSStringFromClass([self class]), GRAY3, @"only AssV. 4 Undef.key:", key, YELLOW, nil): nil;
//	return hasASS 	? [self associatedValueForKey:key] : nil;
//}
@end

//+ (INST) objectAtIndex:(NSUI)idx 				{		VoidBlock logNull = ^{ [@"Pointer array empty return NSNUll" log]; };
//
//	if (idx > [[self allInstancesAddOrReturn:nil]count]) {   logNull(); return (id)AZNULL; }	//	void *thePtf =
//	__weak id ptr =  [[self allInstancesAddOrReturn:nil] objectAtIndex:idx];
//	if ( ptr != NULL) return ptr; /* (__bridge id)thePtf; */ else {  logNull();  return  (id)AZNULL; 	}
//}		/*																				*/


//+ (NSS*) swizzleResourcePath 											{ return nil; }
//+ (NSS*) saveFilePath 								{	return [[NSBundle mainBundle]resourcePath]; } // ? [NSB.applicationSupportFolder withPath:self.saveFile];	}

/*- (void) swizzleSetUp 								{ 		 instanceNumber++;  COLORLOG(RED, @"swizzled setup... instance#: %ld", instanceNumber);
								 [self setAssociatedValue:@(instanceNumber) forKey:@"instanceNumber" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
								 [self swizzleSetUp];
}
+ (instancetype) swizzleInstance 				{   return [self swizzleInstance]; }
+ (instancetype) swizzleInstanceWithObject:(id)obj {	NSLog(@"swizzlin!");	[self swizzleInstanceWithObject:obj];	id theInstance = self.instance;	//	if ( [[theInstance methodNames] filterOne:^BOOL(NSS* o){	return [o contains:@"setWithDictionary"]; }] )	if ([theInstance respondsToSelector:@selector(setWithDictionary:)] && [obj isKindOfClass:NSD.class])		[theInstance setWithDictionary:obj];	else if (	[obj isKindOfClass:NSD.class])		[theInstance setPropertiesWithDictionary:obj];	else	theInstance = [self instanceWithObject:obj];	return theInstance;		} */
