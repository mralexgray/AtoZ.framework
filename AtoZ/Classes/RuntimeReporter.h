//
//  RuntimeReporter.h
//  Runtime Browser
//
//  Created by John  C. Randolph on 7/22/04.
//  Copyright 2004-2009 John C. Randolph. All rights reserved.

#import <Cocoa/Cocoa.h>

@interface RuntimeReporter : NSObject {}  // Simple singleton, only has class methods.

+ (NSArray *) rootClasses;

+ (NSString *) superclassNameForClassNamed:(NSString *) className;
+ (NSString *) superclassNameForClass:(Class) aClass;

+ (NSArray *) inheritanceForClassNamed:(NSString *) className;
+ (NSArray *) inheritanceForClass:(Class) aClass;

+ (NSArray *) iVarNamesForClassNamed:(NSString *) className;
+ (NSArray *) iVarNamesForClass:(Class) aClass;

+ (NSArray *) methodNamesForClassNamed:(NSString *) className;
+ (NSArray *) methodNamesForClass:(Class) aClass;

+ (NSArray *) propertyNamesForClassNamed:(NSString *) className;
+ (NSArray *) propertyNamesForClass:(Class) aClass;

+ (NSArray *) subclassNamesForClassNamed:(NSString *) className;  // Pass nil for the root classes.
+ (NSArray *) subclassNamesForClass:(Class) aClass;

+ (NSArray *) protocolNamesForClassNamed:(NSString *) className;
+ (NSArray *) protocolNamesForClass:(Class) aClass;

+ (BOOL) classHasSubclasses:(Class) aClass;

+ (int) numberOfSubclassesOfClass:(Class) aClass;
+ (int) numberOfClasses;

@end
