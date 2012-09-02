
//  NSObject+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Foundation/Foundation.h>

#import "AtoZ.h"

@interface NSUserDefaults (Subscript)
+ (NSUserDefaults*) defaults;
- (id) 	objectForKeyedSubscript:	(NSString*) key;
- (void) setObject:	(id) newValue forKeyedSubscription:	(NSString*) key;
@end;

//  HRCoder.h
//  Version 1.0
//  Created by Nick Lockwood on 24/04/2012.
//  Copyright (c) 2011 Charcoal Design

//  Distributed under the permissive zlib License
//  Get the latest version from here:
//  https: //github.com/nicklockwood/HRCoder

//  ARC Helper required;

static NSString *const HRCoderClassNameKey = @"$class";
static NSString *const HRCoderRootObjectKey = @"$root";
static NSString *const HRCoderObjectAliasKey = @"$alias";

@interface HRCoderAliasPlaceholder : NSObject

+ (HRCoderAliasPlaceholder*) placeholder;

@end

@interface HRCoder : NSCoder

+ (id) unarchiveObjectWithPlist: 	(id) plist;
+ (id) unarchiveObjectWithFile: 	(NSString*) path;
+ (id) archivedPlistWithRootObject:	(id) object;
+ (BOOL) archiveRootObject: 			(id) rootObject toFile:	(NSString*) path;

- (id) unarchiveObjectWithPlist:		(id) plist;
- (id) unarchiveObjectWithFile:		(NSString*) path;
- (id) archivedPlistWithRootObject:	(id) object;
- (BOOL) archiveRootObject:	(id) rootObject toFile:	(NSString*) path;

@end

@interface NSObject (AutoCoding) <NSCoding>

//coding

- (NSArray*) codableKeys;
- (NSArray*) uncodableKeys;

//loading / saving

+ (id) objectWithContentsOfFile:	(NSString*) path;
- (void) writeToFile:	(NSString*) filePath atomically:	(BOOL) useAuxiliaryFile;

@end

@interface NSObject (AtoZ)


	// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (NSString*)  autoDescribeWithClassType:	(Class) classType;

+ (NSString*)  autoDescribe;

- (void) setWindowPosition:	(AZWindowPosition) pos;
- (AZWindowPosition) windowPosition;

/*	Now every instance (of every class) has a dictionary, where you can store your custom attributes. With Key- Value Coding you can set a value like this:

//[myObject setValue: attributeValue forKeyPath: @"dictionary.attributeName"]

	And you can get the value like this:
//[myObject valueForKeyPath: @"dictionary.attributeName"]

	That even works great with the Interface Builder and User Defined Runtime Attributes.

	Key Path                   Type                     Value
	dictionary.attributeName   String(or other Type)    attributeValue
*/
- (NSMutableDictionary*) getDictionary;
- (BOOL) debug;
@end

@interface NSObject (SubclassEnumeration)
+(NSArray*) subclasses;
@end

@interface NSObject (AG)

//- (BOOL) respondsToSelector:	(SEL) aSelector;

- (NSDictionary*) propertiesPlease;
- (NSDictionary *)propertiesSans:(NSString*)someKey;

+ (NSDictionary*) classPropsFor:	(Class) klass;
//- (NSArray*) methodDumpForClass:	(NSString*) Class;

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

- (void) stopObserving:	(NSObject*) object forName:	(NSString*) notificationName;

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
- (NSArray*)  allKeys;

/** Example:
	MyObject *obj = [[MyObject alloc] init];
	obj.a = @"Hello A";  //setting some values to attributes
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

@end



/// USAGE:  [someDictionary mapPropertiesToObject: someObject];

@interface NSDictionary  (PropertyMap)

- (void) mapPropertiesToObject:	(id) instance;

@end
