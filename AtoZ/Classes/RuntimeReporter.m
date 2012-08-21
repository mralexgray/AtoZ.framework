//
//  RuntimeReporter.m
//  Runtime Browser
//
//  Created by John  C. Randolph on 7/22/04.
//  Copyright 2004-2009 John C. Randolph. All rights reserved.

#import "RuntimeReporter.h"
#import <objc/runtime.h>

#define ROOT_CLASSES_KEY @"ROOT_CLASSES_KEY"

@interface RuntimeReporter (private)

+ (NSMutableDictionary *) cache;

@end

@implementation RuntimeReporter

NSMutableDictionary *classLookupCache;
NSMutableData *rawClassPointers;

+ (void) initialize
	{
	[[NSNotificationCenter defaultCenter]
		addObserver:self
			 selector:@selector(recache:)
					 name:NSBundleDidLoadNotification
				 object:nil];
	}

+ (void) recache:(NSNotification *) aNotification  // If a bundle loaded, then what we knew about the class tree is invalid
	{
	id cache = [self cache];
	[cache removeObjectsForKeys:[cache allKeys]];		// dump these, they'll be reloaded as necessary.
	[rawClassPointers release];
	rawClassPointers = nil;
	}

+ (NSMutableDictionary *) cache
	{
	if (!classLookupCache)
		classLookupCache = [[NSMutableDictionary alloc] init];  
	return classLookupCache;
	}

+ (NSData *) rawClassPointers
	{
	if (!rawClassPointers)
		{
		int numClasses =  [self numberOfClasses];
		rawClassPointers = [[NSMutableData alloc] initWithLength: numClasses * sizeof(Class)];
		void *bytes = [rawClassPointers mutableBytes];
		objc_getClassList(bytes, numClasses);
		}
	return rawClassPointers;
	}

+ (NSString *) superclassNameForClassNamed:(NSString *) className { return [self superclassNameForClass:NSClassFromString(className)]; }
+ (NSString *) superclassNameForClass:(Class) aClass { return NSStringFromClass(class_getSuperclass(aClass)); }

+ (NSArray *) inheritanceForClassNamed:(NSString *) className { return [self inheritanceForClass:NSClassFromString(className)]; }
+ (NSArray *) inheritanceForClass:(Class) aClass
	{
	if (class_getSuperclass(aClass))
		{
		return [[self inheritanceForClass:class_getSuperclass(aClass)] arrayByAddingObject:NSStringFromClass(aClass)];
		}
	return @[NSStringFromClass(aClass)];	
	}

+ (NSArray *) subclassNamesForClassNamed:(NSString *) className  // Pass nil for the root classes.
	{
	NSArray *result = [classLookupCache valueForKey:( className ? className : ROOT_CLASSES_KEY)];
	return result ? result : [self subclassNamesForClass:NSClassFromString(className)];	
	}

+ (NSArray *) rootClasses { return [self subclassNamesForClass: Nil];}   // Pass Nil for root classes.  

	// This method always checks the runtime, not the cached results!  Don't use this directly, use  -subclassNamesForClassNamed:  if you care about efficiency.
+ (NSArray *) subclassNamesForClass:(Class) aClass   // Pass Nil for root classes.  
	{
	id 
		names = [NSMutableArray array]; 

	Class 
		*classPointers = (Class *) [[self rawClassPointers] bytes];

	int 
		index = [self numberOfClasses];

	while (index --)
		{ 
		Class thisClass = classPointers[index];
		if (class_getSuperclass(thisClass) == aClass)
			if(thisClass)
				[names addObject:NSStringFromClass(thisClass)];
		}
	names = [names sortedArrayUsingSelector:@selector(compare:)];
	[[self  cache] setValue:names forKey:(aClass ? NSStringFromClass(aClass) : ROOT_CLASSES_KEY)];
	return names;    
	}

+ (BOOL) classHasSubclasses:(Class) aClass 
	{
	Class 
		*classPointers = (Class *) [[self rawClassPointers] bytes];
	
	int 
		index = [self numberOfClasses];
		
	while (index --)
		{ 
		Class thisClass = (Class) classPointers[index];
		if (class_getSuperclass(thisClass) == aClass)
			return YES;
		}
	return NO;    
	}

+ (int) numberOfSubclassesOfClass:(Class) aClass { return 0; }
+ (int) numberOfClasses { return objc_getClassList(nil, 0); }

+ (NSArray *) methodNamesForClassNamed:(NSString *) className { return [self methodNamesForClass:NSClassFromString(className)]; }
+ (NSArray *) methodNamesForClass:(Class) aClass
		{
		Method *methods;
		unsigned int methodCount;
		if (methods = class_copyMethodList(aClass, &methodCount))
			{
			NSMutableArray *results = [NSMutableArray arrayWithCapacity:methodCount];

			while (methodCount--) 
			[results addObject:@(sel_getName(method_getName(methods[methodCount])))];

			free(methods);	
			return results;
			}
		return nil;
		}

+ (NSArray *) iVarNamesForClassNamed:(NSString *) className { return [self iVarNamesForClass:NSClassFromString(className)]; }
+ (NSArray *) iVarNamesForClass:(Class) aClass
	{
	Ivar *ivars;
	unsigned int ivarCount;
	if (ivars = class_copyIvarList(aClass, &ivarCount))
		{
		NSMutableArray *results = [NSMutableArray arrayWithCapacity:ivarCount];

		while (ivarCount--) 
		[results addObject:@(ivar_getName(ivars[ivarCount]))];

		free(ivars);	
		return results;
		}
	return nil;
	}

+ (NSArray *) propertyNamesForClassNamed:(NSString *) className { return [self iVarNamesForClass:NSClassFromString(className)]; }
+ (NSArray *) propertyNamesForClass:(Class) aClass
	{
	objc_property_t *props;
	unsigned int propsCount;
	if (props = class_copyPropertyList(aClass, &propsCount))
		{
		NSMutableArray *results = [NSMutableArray arrayWithCapacity:propsCount];

		while (propsCount--) 
			[results addObject:@(property_getName(props[propsCount]))];

		free(props);	
		return results;
		}
	return nil;			
	}

+ (NSArray *) protocolNamesForClassNamed:(NSString *) className { return [self protocolNamesForClass:NSClassFromString(className)]; }
+ (NSArray *) protocolNamesForClass:(Class) aClass
	{
	Protocol **protos;
	unsigned int protoCount;
	if (protos = class_copyProtocolList(aClass, &protoCount))
		{
		NSMutableArray *results = [NSMutableArray arrayWithCapacity:protoCount];

		while (protoCount--) 
			[results addObject:@(protocol_getName(protos[protoCount])) ];

		free(protos);	
		return results;
		}
	return nil;
	}

@end


