
//  NSObject+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <dispatch/dispatch.h>
#import <stdarg.h>


//Here’s how you’d store a value with a strong reference:
//			objc_setAssociatedObject(obj, key, value, OBJC_ASSOCIATION_RETAIN);
//And how you’d get it back:
//			id value = objc_getAssociatedObject(obj, key);

//key can be any void *; it doesn’t have to implement NSCopying. See objc/runtime.h for the other memory management flags.

//@interface NSObject (AMAssociatedObjects)
//- (void)associate:(id)value with:(void *)key; // Strong reference
//- (void)weaklyAssociate:(id)value with:(void *)key;
//- (id)associatedValueFor:(void *)key;
//@end

@interface NSObject (AssociatedValues)
- (void)setAssociatedValue:(id)value forKey:(NSString *)key;
- (void)setAssociatedValue:(id)value forKey:(NSString *)key policy:(objc_AssociationPolicy)policy;
- (id)associatedValueForKey:(NSString *)key;
- (void)removeAssociatedValueForKey:(NSString *)key;
- (void)removeAllAssociatedValues;
- (BOOL)hasAssociatedValueForKey:(NSS*)string;

@end
//- (void)registerObservation{	[observee addObserverForKeyPath:@"someValue" task:^(id obj, NSDictionary *change) {
//								   NSLog(@"someValue changed: %@", change);  }]; }
typedef NSString AZBlockToken;
typedef void (^AZBlockTask)(id obj, NSDictionary *change);

@interface NSObject (AZBlockObservation)

//-(void)observeKeyPath:(NSS*)keyPath;

- (NSA*)addObserverForKeyPaths:(NSA*)keyPaths task:(AZBlockTask)task;
//@interface NSObject (AMBlockObservation)
- (AZBlockToken *)addObserverForKeyPath:(NSString *)keyPath task:(AZBlockTask)task;
- (AZBlockToken *)addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOQ*)queue task:(AZBlockTask)task;
- (void)removeObserverWithBlockToken:(AZBlockToken *)token;
@end
@interface NSObject (AtoZ)


- (void) bindArrayKeyPath:(NSS*)array toController:(NSArrayController*)controller;

- (id) performString:(NSS*)string;
- (id) performString:(NSS*)string withObject:(id) obj;

- (NSS*) instanceMethods;
- (NSA*) instanceMethodArray;
- (NSA*) instanceMethodNames;
+ (NSA*) instanceMethods;

/* USAGE:
-(void)mouseDown:(NSEvent*)theEvent {
	NSColor* newColor = //mouse down changes the color somehow (view-driven change)
	self.color = newColor;
	[self propagateValue:newColor forBinding:@"color"];  } */

-(void) propagateValue:(id)value forBinding:(NSString*)binding;

-(void) setWithDictionary:(NSD*)dic;

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

/*
	// To add array style subscripting:
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx; // setter
- (id)objectAtIndexedSubscript:(NSUInteger)idx;			   // getter
*/
	// To add dictionary style subscripting
//- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key; // setter
- (id)objectForKeyedSubscript:(id)key;						   // getter

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (void)fireBlockAfterDelay:(void (^)(void))block;

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
- (NSString*)  autoDescribe;


- (void) setWindowPosition:	(AZWindowPosition) pos;
- (AZWindowPosition) windowPosition;

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
@end

@interface NSObject (SubclassEnumeration)
+(NSA*) subclasses;
@end

@interface NSObject (AG)

/**	Additional performSelector signatures that support up to 7 arguments.	*/
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
		   withObject:(id)p4;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
		   withObject:(id)p4 withObject:(id)p5;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
		   withObject:(id)p4 withObject:(id)p5 withObject:(id)p6;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3
		   withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(id)p7;


- (NSS*)segmentLabel;

BOOL respondsTo(id obj, SEL selector);
BOOL respondsToString(id obj,NSS* string);

- (BOOL) respondsToString:(NSS*)string;

- (IBAction)increment:(id)sender;
- (IBAction)setFromSegmentLabel:(id)sender;
- (IBAction)performActionFromSegmentLabel:(id)sender;

- (IBAction)performActionFromLabel:(id)sender;

//- (BOOL) respondsToSelector:	(SEL) aSelector;



+ (NSDictionary*) classPropsFor:	(Class) klass;
//- (NSA*) methodDumpForClass:	(NSString*) Class;
+ (NSA*) classMethods;
- (NSS*) methods;

- (NSString*) stringFromClass;

- (void) setIntValue:	(NSInteger) i forKey:	(NSString*) key;
- (void) setIntValue:	(NSInteger) i forKeyPath:	(NSString*) keyPath;

- (void) setFloatValue:	(CGFloat) f forKey:	(NSString*) key;
- (void) setFloatValue:	(CGFloat) f forKeyPath:	(NSString*) keyPath;

- (BOOL) isEqualToAnyOf:	(id<NSFastEnumeration>) enumerable;

- (void) fire:	(NSString*) notificationName;
- (void) fire:	(NSString*) notificationName userInfo:	(NSDictionary*) userInfo;

- (id) observeName:	(NSString*) notificationName 
	  usingBlock:	(void (^) (NSNotification*) ) block;

- (void) observeObject:	(NSObject*) object
			 forName:	(NSString*) notificationName
			 calling:	(SEL) selector;

-(void)observeName:(NSString *)notificationName
		   calling:(SEL)selector;

- (void) stopObserving:	(NSObject*) object forName:	(NSString*) notificationName;

- (id) performSelectorSafely:(SEL)aSelector;
- (id) performSelectorWithoutWarnings:(SEL)aSelector;

- (id) performSelectorWithoutWarnings:(SEL) aSelector withObject:(id)obj;
- (id) performSelectorWithoutWarnings:(SEL)aSelector withObject:(id)obj withObject:(id)obj2;
- (void) performSelector:	(SEL) aSelector afterDelay:	(NSTimeInterval) seconds;
- (void) addObserver:	(NSObject*) observer forKeyPath:	(NSString*) keyPath;
- (void) addObserver:	(NSObject*) observer 
	   forKeyPaths:	(id<NSFastEnumeration>) keyPaths;
- (void) removeObserver:	(NSObject*) observer 
		  forKeyPaths:	(id<NSFastEnumeration>) keyPaths;

- (void) willChangeValueForKeys:	(id<NSFastEnumeration>) keys;
- (void) didChangeValueForKeys:	(id<NSFastEnumeration>) keys;
#pragma PropertyArray
- (NSDictionary*) dictionaryWithValuesForKeys;
- (NSA*)  allKeys;

/** Example:
	MyObject *obj = [[MyObject alloc] init];
	obj.a = @"Hello A";  //setting some values to attrtypedef existing new;ibutes
	obj.b = @"Hello B";

	//dictionaryWithValuesForKeys requires keys in NSArray. You can now
	//construct such NSArray using `allKeys` from NSObject(PropertyArray) category
	NSDictionary *objDict = [obj dictionaryWithValuesForKeys: [obj allKeys]];

	//Resurrect MyObject from NSDictionary using setValuesForKeysWithDictionary
	MyObject *objResur = [[MyObject alloc] init];
	[objResur setValuesForKeysWithDictionary: objDict];
*/

#pragma SetClass
- (void) setClass:	(Class) aClass;
// In your custom class
+ (id) customClassWithProperties:	(NSDictionary*) properties;
- (id) initWithProperties:	(NSDictionary*) properties;
+ (id) newFromDictionary:(NSD*)dic;
@end


//It actually works best if you create a category on NSObject and just drop that method straight in there, that way you can call it on any object.

@interface NSObject (PrimitiveEvocation)
- (void *)performSelector:(SEL)selector withValue:(void *)value;
@end

//Here are some examples. First of all, let’s just assume we have a class with the following methods:

//	- (void)doSomethingWithFloat:(float)f;  // Example 1
//	- (int)addOne:(int)i;				   // Example 2

// Example 1
//	float value = 7.2661; // Create a float
//	float *height = &value; // Create a _pointer_ to the float (a floater?)
//	[self performSelector:@selector(doSomethingWithFloat:) withValue:height]; // Now pass the pointer to the float
//	free(height); // Don't forget to free the pointer!

// Example 2
//	int ten = 10; // As above
//	int *i = &ten;
//	int *result = [self performSelector:@selector(addOne:) withValue:i]; // Returns a __pointer__ to the int
//	NSLog(@"result is %d", *result); // Remember that it's a pointer, so keep the *!
//	free(result);

/*  Things get a little more complicated when dealing with methods that return objects, as opposed to primitives or structs. For primitives, our performSelector:withValue: returns a pointer to the method’s return value (i.e. a primitive). However, when the underlying method returns an object, it’s actually returning a pointer to the object. So that means that when our code runs, it ends up returning a pointer to a pointer to the object (i.e. a void **), which you need to handle appropriately. If that wasn’t tricky enough, if you’re using ARC, you also need to bridge the void * pointer to bring it into Objective-C land.	*/

//	Here are some examples. Let’s assume you have a class with the following methods:
//	- (NSObject *)objectIfTrue:(BOOL)b;	 // Example 3
//	- (NSString *)strWithView:(UIView *)v;  // Example 4
//	Notice how both methods return objects (well, technically, pointers to objects, which is important!). We can now use performSelector:withValue: as follows:
/*
	BOOL y = YES; // Same as previously
	BOOL *valid = &y;
	void **p = [self performSelector:@selector(objectIfTrue:) withValue:valid]; // Returns a pointer to an NSObject (standard Objective-C behaviour)
	NSObject *obj = (__bridge NSObject *)*p; // bridge the pointer to Objective-C
	NSLog(@"object is %@", obj);
	free(p); */

//	Notice the return type of performSelector:withValue: is void **. In other words, a pointer to a pointer of type void (which means any type). We then reference the pointer once to get to a pointer to the actual object (to void * — a standard void pointer) and then use a bridged cast to convert that pointer to NSObject * which is a standard object (again, technically, a pointer to an object).

// 	Here’s one final example bringing everything to do with objects together, showing how to use performSelector:withValue: to call a selector on an object, with an object as an argument and as a return type:
/*
UIView *view = [[UIView alloc] init];
void **p = [self performSelector:@selector(strWithView:) withValue:&view];
NSString *str = (__bridge NSString *)*p;
NSLog(@"string is %@", str);
free(p);
*/
/// USAGE:  [someDictionary mapPropertiesToObject: someObject];

@interface NSDictionary  (PropertyMap)

- (void) mapPropertiesToObject:	(id) instance;

@end

@interface NSObject (KVCExtensions)

- (void) setPropertiesWithDictionary:(NSD*)dictionary;
- (BOOL) canSetValueForKey:	   (NSString*) key;
- (BOOL) canSetValueForKeyPath: (NSString*) keyPath;

@end

@interface NSObject (ImageVsColor)

- (NSC*)colorValue;
- (NSIMG*)imageValue;

@end

@interface NSObject (NoodlePerformWhenIdle)

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterSystemIdleTime:(NSTimeInterval)delay;

- (void)performSelector:(SEL)aSelector withObject:(id)anArgument afterSystemIdleTime:(NSTimeInterval)delay withinTimeLimit:(NSTimeInterval)maxTime;

@end
