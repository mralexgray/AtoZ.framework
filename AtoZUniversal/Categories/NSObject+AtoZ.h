

#import <AtoZUniversal/AZObserversAndBinders.h>
@import ObjectiveC;

#if TARGET_OS_IPHONE
@interface NSObject (Name) - (NSString *) className; @end
#else
@interface NSObject (NibLoading) + (INST) loadFromNib; @end
#endif

@interface NSObject (HidingAssocitively)
@property BOOL folded;
@end

@interface NSObject (GCD)
- _Void_ performAsynchronous:(Blk)_;
- _Void_ performOnMainThread:(Blk)_         wait:(BOOL)wait;
- _Void_        performAfter:(NSTimeInterval)sec block:(Blk)_;
@end

@interface NSObject (ClassAssociatedReferences)
+ (void) setValue:v forKey:(NSS*)k;
+              valueForKey:(NSS*)k;
@end


//  Lookup the next implementation of the given selector after the default one. \
    Returns nil if no alternate implementation is found.

#define invokeSupersequent(...) \
  ([self getImplementationOf:_cmd after:impOfCallingMethod(self, _cmd)]) (self, _cmd, ##__VA_ARGS__)

IMP impOfCallingMethod (id lookupObject, SEL selector);

@interface NSObject (SupersequentImplementation)
- (IMP)getImplementationOf:(SEL)lookup after:(IMP)skip;
@end

/* AWESOME!!

	[@["methodOne", @"methodtwo"] each:^(id x) {

		[Foo addMethodForSelector:NSSelectorFromString(x) typed:"v@:" implementation:^(id self,SEL _cmd) {
			NSLog(@"Called -[%@ %@] with void return", [self class], NSStringFromSelector(_cmd));
		}];
		[foo performSelector:stringified];
	}];

	[@["returnWithInputOne:", @"returnWithInputTwo:"] eachWithIndex:^(id obj, NSUI idx){
		[Foo addMethodForSelector:stringified typed:"@@:" implementation:^id(id self, SEL _cmd) {
			return NSS.randomDicksonism;
		}];
		NSLog(@"%@", [foo performSelector:stringified]);
	}
	[Foo addMethodForSelector:@selector(idreturn) typed:"@@:" implementation:^ id (id self, SEL _cmd) {
		return [NSString stringWithFormat:@"Called -[%@ %@] with id return", [self class], NSStringFromSelector(_cmd)];
	}];
	NSLog(@"%@", [foo idreturn]);
}
*/

@interface NSObject (AddMethod)

+ (BOOL)   addMethodFromString:(NSS*)s    withArgs:(NSA*)a;  //NEEDSWORK NSMethodSignature
+ (BOOL)  addMethodForSelector:(SEL)selector typed:(const char*)types implementation:blockPtr;
- (NSA*)  methodSignatureArray:(SEL)sel;
+ (NSA*)  methodSignatureArray:(SEL)sel;
- (NSA*) methodSignatureString:(SEL)sel;
+ (NSA*) methodSignatureString:(SEL)sel;

@end

#define PLCY objc_AssociationPolicy

@interface NSObject   (AssociatedValues)

- _Void_          setAssociatedValue:val      forKey:(NSS*)k; // DEFAULTS TO OBJC_ASSOCIATION_RETAIN
- _Void_          setAssociatedValue:val      forKey:(NSS*)k policy:(PLCY)p;
-              associatedValueForKey:(NSS*)k orSetTo:def     policy:(PLCY)p;
-              associatedValueForKey:(NSS*)k orSetTo:def; // DEFAULTS TO OBJC_ASSOCIATION_RETAIN_NONATOMIC
//-            associatedValueForKey:(NSS*)k; // or nil!
- _Void_ removeAssociatedValueForKey:(NSS*)k;
- (BOOL)    hasAssociatedValueForKey:(NSS*)k;
- _Void_   removeAllAssociatedValues;


@end

//	- _Void_ registerObservation{	[observee addObserverForKeyPath:@"someValue" task:^(id obj, NSDictionary *change) {	NSLog(@"someValue changed: %@", change);  }]; }
//	-(void)observeKeyPath:(NSS*)keyPath;
//	@interface NSObject (AMBlockObservation)


@interface AZValueTransformer : NSValueTransformer
@prop_NC Obj_ObjBlk transformBlock;
+ (INST) transformerWithBlock:(Obj_ObjBlk)block;
@end

typedef void(^bSelf)(id _self);

@interface NSObject (AtoZ)

// Return all superclasses of object
- (NSA*) superclasses;
- (NSA*) superclassesAsStrings;

- _Void_  setYesForKey: k;
- _Void_  setYesForKeys:(NSA*)ks;
- _Void_  setNoForKey: k;
- _Void_  setNoForKeys:(NSA*)ks;


- _Void_ sV: v fK: k;  // setValue:forKey:
- _Void_ sV: v fKP: k; // setValue:forKeyPath:

- _Void_  blockSelf:(bSelf)block;
- _Void_ triggerKVO:(NSS*)k 
              block:(bSelf)blk;

@prop_RO NSAS *attributedDescription;
@prop_RO const char *cDesc;

- (NSString*) descriptionForKey:(NSS*)k;

- _Void_ willChangeValueForKeysBlock:(ObjBlk)blk keys:(NSString*)keys, ...;

- _Void_ sVs:(NSA*)v fKs:(NSA*)k;
-(void) setValues:(NSA*)x forKeys:(NSA*)ks;
-(void) setValue: x forKeys:(NSA*)ks;

@property (readonly) NSS * uuid; // Associated with custom getter
@property (strong) 	NSMA		* propertiesThatHaveBeenSet;

- (BOOL) valueWasSetForKey:(NSS*)key;
- (BOOL) ISA:(Class)k;

//@property NSMA* undefinedKeys;
/* USAGE:

	id scoop = @"poop";
	[scoop setValue:@2 forKey:@"farts"];
	LOG_EXPR( scoop[@"undefinedKeys"] ); 	-> ( farts ) 												*/

+ (instancetype) instanceWithProperties:(NSS*)firstKey,... NS_REQUIRES_NIL_TERMINATION;	/*  USAGE:	
	
	id whatever = [CAL instanceWithProperties:@"stupid", @(YES), @"sexy", @(NO), nil];  	*/

- _Void_ performBlockWithVarargsInArray:(void(^)(NSO*_self,NSA*varargs))block, ...NS_REQUIRES_NIL_TERMINATION; /*	USAGE:  	

	[NSS.randomBadWord performBlockWithVarargsInArray: ^(NSO*_self, NSA*args){
  
      LOG_EXPR([args map:^(id o){ return [o withString:_self]; }]);
  
  }, @"Fuck my ", @"What a huge ", nil];

	-> ( "Fuck my shagger", "What a huge shagger" )	
*/


/*  USAGE: 	[@"Apple is "performBlockEachVararg:^(NSO*_self,id v){ LOG_EXPR([_self withString:v]); }, @"Whatever!", @"Sexy", @"fruitful", nil];
	-> Apple is Whatever!	-> Apple is Sexy	-> Apple is fruitful */
- _Void_ performBlockEachVararg:(void(^)(NSO*_self,id obj))block, ... NS_REQUIRES_NIL_TERMINATION;


-filterKeyPath:(NSS*)kp recursively:(id(^)(id))mayReturnOtherObjectOrNil;

- _Void_ performBlock:(Blk)block;
//- _Void_ performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

// adapted from the CocoaDev MethodSwizzling page

//+ (BOOL) exchangeInstanceMethod:(SEL)sel1 withMethod:(SEL)sel2;
//+ (BOOL) exchangeClassMethod:(SEL)sel1 withMethod:(SEL)sel2;

- (NSURL*)urlified;

//-(void) propagateValue: value forBinding:(NSString*)binding;

//-(void) 	DDLogError;
//-(void) 	DDLogWarn;
//-(void) 	DDLogInfo	;
//-(void) 	DDLogVerbose;

#if !TARGET_OS_IPHONE
- _Void_ bindArrayKeyPath:(NSS*)array toController:(NSArrayController*)controller;
#endif

- performString:(NSS*)string;
- performString:(NSS*)string withObject:obj;

//-- performSelectorARC:(SEL)selector withObject: obj;
//-- performSelectorARC:(SEL)selector withObject: one withObject: two;

//- (NSS*) instanceMethods;
//- (NSA*) instanceMethodArray;
- (NSA*) instanceMethodNames;
//+ (NSA*) instanceMethods;
//- (NSS*) instanceMethodsInColumns;


/* USAGE:
-(void)mouseDown:(NSEvent*)theEvent {
	NSColor* newColor = //mouse down changes the color somehow (view-driven change)
	self.color = newColor;
	[self propagateValue:newColor forBinding:@"color"];  } */
//-(void) propagateValue: value forBinding:(NSString*)binding;
//- (NSA*) settableKeys;
//- (NSA*) keysWorthReading;
//-(void) setWithDictionary:(NSD*)dic;

/*
[WSLObjectSwitch switchOn:<id object> defaultBlock:^{ NSLog (@"Dee Fault"); }
					cases:	@"sausage", ^{ NSLog (@"Hello, sweetie."); },
							@"test",	^{ NSLog (@"A test"); }, nil];
*/

-(BOOL) isKindOfAnyClass:(NSA*)classes;
typedef void (^caseBlock)();
+(void)switchOn:(id<NSObject>)obj cases:casesList, ...;
+(void)switchOn:(id<NSObject>)obj
   defaultBlock:(caseBlock)defaultBlock
		  cases:casesList, ...;

/* DISABLED
	// To add array style subscripting:
- _Void_ setObject: obj atIndexedSubscript:(NSUInteger)idx; // setter
- objectAtIndexedSubscript:(NSUInteger)idx;			   // getter

*/
	// To add dictionary style subscripting
//- _Void_ setObject: obj forKeyedSubscript:(id <NSCopying>)key; // setter
//-- objectForKeyedSubscript: key;						   // getter
//- _Void_ performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay; // conflict BlocksKit

- _Void_ fireBlockAfterDelay:(void (^)(void))block;


+ (NSMA*)newInstances:(NSUI)count;

//- existsOrElse:(id(^)(BOOL yesOrNO))block {
//
//}
//+(void)immediately:(void (^)())block
//{
//	[self begin];
//	[self setDisableActions:YES];
//	block();
//	[self commit];
//}
	// Finds all properties of an object, and prints each one out as part of a string describing the class.
//+ (NSString*)  autoDescribeWithClassType:	(Class) classType;

+ (NSString*)  autoDescribe;
- (NSString*)  autoDescription;



/*	Now every instance (of every class) has a dictionary, where you can store your custom attributes. With Key- Value Coding you can set a value like this:

//[myObject setValue: attributeValue forKeyPath: @"dictionary.attributeName"]

	And you can get the value like this:
//[myObject valueForKeyPath: @"dictionary.attributeName"]

	That even works great with the Interface Builder and User Defined Runtime Attributes.

	Key Path				   Type					 Value
	dictionary.attributeName   String(or other Type)	attributeValue
*/
- (NSMutableDictionary*) getDictionary;

//- (BOOL) debug;

- (NSS*) strKey:		(NSS*)def;
- (NSA*) arrKey: 		(NSS*)def;
- (NSD*) dicKey: 		(NSS*)def;
- (DTA*) dataKey:   (NSS*)d;
-  (NSI) iKey:			(NSS*)def;
-  (CGF) fKey:			(NSS*)def;
- (BOOL) boolKey:		(NSS*)def;
//- (NSURL*)URLKey:	(NSS*)defaultName;

@end

@interface NSObject (SubclassEnumeration)
+ _List_ subclasses;
@end

@interface NSString (VARARGLOGGING)

- (NSS*)formatWithArguments:(NSA*)arr;
+ (NSS*)evaluatePseudoFormat:(NSS*)fmt withArguments:(NSA*)arr;
//- _Void_ log:firstObject, ...;
@end

@interface NSObject (AG)

/* 
- _Void_ doSomethingWithFloat:(float)f;														// Example 1
	float value = 7.2661; 																		// Create a float
	float *height = &value; 																	// Create a _pointer_ to the float (a floater?)
	[self performSelector:@selector(doSomethingWithFloat:) withValue:height]; 	// Now pass the pointer to the float
	free(height); 																					// Don't forget to free the pointer!

- (int)addOne:(int)i;																			// Example 2
	int ten = 10; 																					// As above
	int *i = &ten;
	int *result = [self performSelector:@selector(addOne:) withValue:i]; 		// Returns a __pointer__ to the int
	NSLog(@"result is %d", *result); 														// Remember that it's a pointer, so keep the *!
 	free(result);

- (NSObject *)objectIfTrue:(BOOL)b;															// Example 3
	BOOL y = YES; 																					// Same as previously
 	BOOL *valid = &y;
 	void **p = [self performSelector:@selector(objectIfTrue:) withValue:valid];// Returns a pointer to an NSObject (standard Objective-C behaviour)
 	NSObject *obj = (__bridge NSObject *)*p;												// bridge the pointer to Objective-C
 	NSLog(@"object is %@", obj);
 	free(p);

- (NSS*)strWithView:(UIView *)v;														// Example 4
	UIView *view = UIView.new;
 	void **p = [self performSelector:@selector(strWithView:) withValue:&view];
	NSString *str = (__bridge NSString *)*p;
	NSLog(@"string is %@", str);
	free(p);
*/

- (void*)performSelector:(SEL)selector withValue:(void *)value;
- (void*)performSelector:(SEL)selector withValue:(void *)value andValue:(void*)value2;


//	void **pp = [RED performSelector:@selector(colorWithSaturation:brightness:) withValues:oneP,twoP, nil];
//	NSLog(@"string is %@", (__bridge NSC*)*pp);
//	free(pp)
- (void*) performSelector:(SEL)aSelector withValues:(void *)context, ...;

+ (NSS*) stringFromType:(const char*)type;

//- (NSValue*) invoke:(SEL)selector withArgs:(NSA*)args;

/*
	NSView *vv = [NSV.alloc init];
 	[vv invokeSelector:@selector(setFrame:), AZVrect(AZRectFromDim(100))];
 	NSLog(@"%@",AZStringFromRect(vv.frame)); -> [x.0 y.0 [100 x 100]]
*/

- (NSValue*) invokeSelector:(SEL)selector, ...;

- _Void_ log;
//- _Void_ logInColor:(NSC*)color; FIX

//- (NSMethodSignature*) methodSignatureForSelector:(SEL)selector;
//- _Void_ forwardInvocation:(NSInvocation *)invocation;


/**	Additional performSelector signatures that support up to 7 arguments.	*/
- performSelector:(SEL)selector withObject: p1 withObject: p2 withObject: p3;
- performSelector:(SEL)selector withObject: p1 withObject: p2 withObject: p3
		   withObject: p4;
- performSelector:(SEL)selector withObject: p1 withObject: p2 withObject: p3
		   withObject: p4 withObject: p5;
- performSelector:(SEL)selector withObject: p1 withObject: p2 withObject: p3
		   withObject: p4 withObject: p5 withObject: p6;
- performSelector:(SEL)selector withObject: p1 withObject: p2 withObject: p3
		   withObject: p4 withObject: p5 withObject: p6 withObject: p7;



- responds:(NSS*)selStr do: doBlock;

BOOL respondsTo(id obj, SEL selector);
BOOL respondsToString(id obj,NSS* string);

-(SEL) firstResponsiveSelFromStrings:(NSA*)selectors;
-(NSS*) firstResponsiveString:(NSA*)selectors;

- (BOOL) respondsToString:(NSS*)string;
- respondsToStringThenDo: (NSS*)string withObject: obj withObject: objtwo;
- respondsToStringThenDo: (NSS*)string withObject: obj;
- respondsToStringThenDo: (NSS*)string;

#if !TARGET_OS_IPHONE

@prop_RO NSS* segmentLabel;

- (IBAction)increment:_;
- (IBAction)setFromSegmentLabel:_;
- (IBAction)performActionFromSegmentLabel:_;
- (IBAction)performActionFromLabel:_;
#endif

//- (BOOL) respondsToSelector:	(SEL) aSelector;

//+ (NSDictionary*) classPropsFor:	(Class) klass; // COnflig AQProperties
//- (NSA*) methodDumpForClass:	(NSString*) Class;
+ (NSA*) classMethods;
- (NSS*) methods;

- (NSString*) stringFromClass;

- _Void_ setIntValue:	(NSInteger) i forKey:	(NSString*) key;
- _Void_ setIntValue:	(NSInteger) i forKeyPath:	(NSString*) keyPath;

- _Void_ setFloatValue:	(CGFloat) f forKey:	(NSString*) key;
- _Void_ setFloatValue:	(CGFloat) f forKeyPath:	(NSString*) keyPath;

- (BOOL) isEqualToAnyOf:	(id<NSFastEnumeration>) enumerable;

- _Void_ fire:	(NSString*) notificationName;
- _Void_ fire:	(NSString*) notificationName userInfo:	(NSDictionary*) userInfo;


- observeName:(NSString*)noteName usingBlock:(void(^)(NSNotification*n))blk;

- _Void_ observeObject:	(NSObject*) object
			 forName:	(NSString*) notificationName
			 calling:	(SEL) selector;

-(void)observeName:(NSS*) notificationName
		   calling:(SEL)selector;

- _Void_ stopObserving:	(NSObject*) object forName:	(NSString*) notificationName;

- _Void_ observeNotificationsUsingBlocks:(NSS*) firstNotificationName, ... NS_REQUIRES_NIL_TERMINATION;


// This awesome method was found at Stackoverflow From Rob Mayoff - http://stackoverflow.com/users/77567/rob-mayoff
// Initial Solution by Scott Thompson - http://stackoverflow.com/users/415303/scott-thompson http://stackoverflow.com/a/7933931/1320374

#define PerformSelectorWithoutLeakWarning(Stuff) do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

- (BOOL) canPerformSelector: (SEL)aSelector;
- performSelectorSafely:(SEL)aSelector;
- performSelectorIfResponds:(SEL)sel;
- performSelectorWithoutWarnings:(SEL)aSelector;

- performSelectorWithoutWarnings:(SEL) aSelector withObject: obj;
- performSelectorWithoutWarnings:(SEL)aSelector withObject: obj withObject: obj2;
//- _Void_ performSelector:	(SEL) aSelector afterDelay:	(NSTimeInterval) seconds;
- _Void_ addObserver:	(NSObject*) observer forKeyPath:	(NSString*) keyPath;
- _Void_ addObserver:	(NSObject*) observer 
	   forKeyPaths:	(id<NSFastEnumeration>) keyPaths;
- _Void_ removeObserver:	(NSObject*) observer 
		  forKeyPaths:	(id<NSFastEnumeration>) keyPaths;

- _Void_ az_willChangeValueForKeys:(NSA*)keys;//	(id<NSFastEnumeration>) keys;
- _Void_ az_didChangeValueForKeys:(NSA*)keys;//	(id<NSFastEnumeration>) keys;
- _Void_ triggerChangeForKeys:(NSA*)keys;

#pragma mark - PropertyArray
//- (NSDictionary*) dictionaryWithValuesForKeys;
//- (NSA*)  allKeys;

/** Example:
	MyObject *obj = MyObject.new;
	obj.a = @"Hello A";  //setting some values to attrtypedef existing new;ibutes
	obj.b = @"Hello B";

	//dictionaryWithValuesForKeys requires keys in NSArray. You can now
	//construct such NSArray using `allKeys` from NSObject(PropertyArray) category
	NSDictionary *objDict = [obj dictionaryWithValuesForKeys: [obj allKeys]];

	//Resurrect MyObject from NSDictionary using setValuesForKeysWithDictionary
	MyObject *objResur = MyObject.new;
	[objResur setValuesForKeysWithDictionary: objDict];
*/

#pragma mark - SetClass
- _Void_ setClass:	(Class) aClass;	// In your custom class
+ (instancetype) customClassWithProperties:(NSD*) properties;
- (instancetype) initWithProperties:		 (NSD*) properties;
- (instancetype) initWithDictionary:		 (NSD*) properties;
+ (instancetype) instanceWithDictionary:	 (NSD*) properties;
+ (instancetype) newFromDictionary:			 (NSD*) properties;


@end


@interface NSObject (KVCExtensions)

//- _Void_ setPropertiesWithDictionary:(NSD*)dictionary;
- (BOOL) canSetValueForKey:	   (NSString*) key;
- (BOOL) canSetValueForKeyPath: (NSString*) keyPath;

@end

/*
@interface NSObject (NoodlePerformWhenIdle)

- _Void_ performSelector:(SEL)aSelector withObject: anArgument afterSystemIdleTime:(NSTimeInterval)delay;

- _Void_ performSelector:(SEL)aSelector withObject: anArgument afterSystemIdleTime:(NSTimeInterval)delay withinTimeLimit:(NSTimeInterval)maxTime;

@end
*/


 // thanks Landon Fuller
#define VERIFIED_CLASS(className) ((className *) NSClassFromString(@"" # className))

@interface NSObject (SadunUtilities)

+ (NSA*) selectorList; // Return an array of all an object's selectors
+ (NSA*) propertyList; // Return an array of all an object's properties
+ (NSA*)     ivarList;     // Return an array of all an object's properties
+ (NSA*) protocolList; // Return an array of all an object's properties

/*
// Return all superclasses of object
@prop_RO NSA* superclasses;
// Selector Utilities
- (NSInvocation *) invocationWithSelectorAndArguments: (SEL) selector,...;
- (BOOL) performSelector: (SEL) selector withReturnValueAndArguments: (void *) result, ...;
// Return a C-string with a selector's return type may extend this idea to return a class
- (const char*)returnTypeForSelector:(SEL)selector;
// Choose the first selector that an object can respond to. Thank Kevin Ballard for assist!
- (SEL)chooseSelector:(SEL)aSelector, ...;


// Request return value from performing selector
- objectByPerformingSelectorWithArguments: (SEL) selector, ...;
- objectByPerformingSelector:(SEL)selector withObject:object1 withObject: object2;
- objectByPerformingSelector:(SEL)selector withObject:object1;
- objectByPerformingSelector:(SEL)selector;

// Delay Utilities
- _Void_ performSelector: (SEL)select withCPointer:(void*)cPointer afterDelay:(NSTI)delay;
- _Void_ performSelector: (SEL)select withInt: 	(int)iVal  			 afterDelay:(NSTI) delay;
- _Void_ performSelector: (SEL)select withFloat:(CGF)fVal  		    afterDelay:(NSTI) delay;
- _Void_ performSelector: (SEL)select withBool: (BOOL)bVal         afterDelay:(NSTI) delay;
- _Void_ performSelector: (SEL)select 							          afterDelay:(NSTI) delay;
- _Void_ performSelector: (SEL)select withDelayAndArguments: (NSTI)delay,...;

// Return Values, allowing non-object returns
- valueByPerformingSelector:(SEL)selector withObject:object1 withObject: object2;
- valueByPerformingSelector:(SEL)selector withObject:object1;
- valueByPerformingSelector:(SEL)selector;


- (BOOL)          hasProperty:(NSS*)pName; // Runtime checks of properties, etc.
- (BOOL)              hasIvar:(NSS*)iName;
//+ (BOOL)          classExists:(NSS*)cName;
+   instanceOfClassNamed:(NSS*)cName;
// Access to object essentials for run-time checks. Stored by class in dictionary.
@prop_RO NSD * selectors, 
                      * properties, // a dictionary with class/selectors entries, all the way up to NSObject
                      * ivars, 
                      * protocols;

// Attempt selector if possible
- tryPerformSelector: (SEL) aSelector withObject: object1 withObject: object2;
- tryPerformSelector: (SEL) aSelector withObject: object1;
- tryPerformSelector: (SEL) aSelector;
*/
@end

// Check for properties, ivar. Use respondsToSelector: and conformsToProtocol: as well
//- (BOOL) hasProperty: (NSS*)propertyName;
//- (BOOL) hasIvar: 	 (NSS*)ivarName;
//+ (BOOL) classExists: (NSS*)className;
//+ instanceOfClassNamed:(NSS*)className;
//typedef void (^KVOFullBlock)(NSString *keyPath, id object, NSDictionary *change);
//@interface NSObject (NSObject_KVOBlock)
//-- addKVOBlockForKeyPath:(NSS*)inKeyPath options:(NSKeyValueObservingOptions)inOptions handler:(KVOFullBlock)inHandler;
//- _Void_ removeKVOBlockForToken: inToken;
///// One shot blocks remove themselves after they've been fired once.
//-- addOneShotKVOBlockForKeyPath:(NSS*)inKeyPath options:(NSKeyValueObservingOptions)inOptions handler:(KVOFullBlock)inHandler;
//- _Void_ KVODump;
//@end

@interface AZBool : NSObject
@end

@interface 		     		 	  NSObject  (FOOCoding)


//-       		 initWithDictionary : (NSD*)dictionary;
-    (NSA*)        	     arrayForKey : (NSS*)key;
-    (NSA*) arrayOfDictionariesForKey : (NSS*)key;
-    (NSA*)      arrayOfStringsForKey : (NSS*)key;

-    (BOOL)						     boolForKey : (NSS*)key;
-    (BOOL)          toggleBoolForKey : (id)k;
- (DATA*)			    		   dataForKey : (NSS*)key;
- (DATE*)				   	dateForKey : (NSS*)key;
-    (NSD*)  			dictionaryForKey : (NSS*)key;
-  (double)              doubleForKey : (NSS*)key;
-     (CGF) 				  floatForKey : (NSS*)key;
-     (NSI)             integerForKey : (NSS*)key;
-    (NSS*)              stringForKey : (NSS*)key;
-    (NSUI)     unsignedIntegerForKey : (NSS*)key;
-  (NSURL*)                 URLForKey : (NSS*)key;


/* Depend on \c shadySetValue:forKey: + shadyValueForKey: in AtoZSwizzles */
-     (SEL)            selectorForKey : (NSS*)key;
-    (void) setSelector:(SEL)s forKey : (NSS*)key;


- mutableArrayValueForKeyOrKeyPath: keyOrKeyPath;
- valueForKeyOrKeyPath: keyOrKeyPath transform:(THBinderTransformationBlock)tBlock;
- valueForKeyOrKeyPath: keyOrKeyPath;  //AZAddition
- valueForKey:(NSS*)key assertingProtocol:(Protocol*)proto;  //AZAddition
- valueForKey:(NSS*)key assertingClass:(Class)klass;
- valueForKey:(NSS*)key assertingRespondsToSelector:(SEL)theSelector;
- (BOOL)contentsOfCollection:(id <NSFastEnumeration>)theCollection areKindOfClass:(Class)theClass;


@end


#define PROXY_DECLARE(__NAME__) @interface __NAME__ : NSProxy @end

#define PROXY_DEFINE_BLOCK(__NAME__,__BACKING_CLASS__,__BACKING_BLOCK__) \
\
  @implementation __NAME__ { __BACKING_CLASS__*backing; } \
  \
  - init 	{ backing = (__BACKING_CLASS__*)__BACKING_BLOCK__(backing);  return self;	}\
  \
  - (NSMethodSignature*) methodSignatureForSelector:(SEL)s 	{ \
  \
    return [backing methodSignatureForSelector:s] ?: nil;	} \
  \
  - _Void_ forwardInvocation:(NSInvocation*)inv { [inv invokeWithTarget: backing]; } \
  \
  - (BOOL)respondsToSelector:(SEL)s { return [backing respondsToSelector:s]; \
  \
  - (BOOL) conformsToProtocol:(Protocol*)p { \
  \
    return [@[@protocol(NSCopying),@protocol(NSObject)] containsObject:p]; \
  } \
  @end

#define PROXY_DEFINE(__NAME__,__BACKING_CLASS__) \
	PROXY_DEFINE_BLOCK(__NAME__,__BACKING_CLASS__,^(__BACKING_CLASS__*setter){ return setter = __BACKING_CLASS__.new; })

// Override some of NSProxy's implementations to forward them...
 
#define AZBindWDefVs(binder,binding,objectToBindTo,keyPath)   											\
	[binder bind:binding toObject:objectToBindTo withKeyPathUsingDefaults:keyPath]
#define AZBindButNil(binder,binding,objectToBindTo,keyPath,nilValuecase) 							\
	[binder bind:binding toObject:objectToBindTo withKeyPath:keyPath nilValue:nilValuecase]
#define AZBindTransf(binder,binding,objectToBindTo,keyPath,transformer)								\
	[binder bind:binding toObject:objectToBindTo withKeyPath:keyPath  transform:transformer]
#define AZBindNegate(binder,binding,objectToBindTo,keyPath)												\
	[binder bind:binding toObject:objectToBindTo withNegatedKeyPath:keyPath]

