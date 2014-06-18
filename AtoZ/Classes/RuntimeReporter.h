//
//  RuntimeReporter.h
//  Runtime Browser
//
//  Created by John  C. Randolph on 7/22/04.
//  Copyright 2004-2009 John C. Randolph. All rights reserved.

@import Foundation;

@interface RuntimeReporter : NSObject  // Simple singleton, only has class methods.

+ (NSArray*) rootClasses; /*! AOK  NSLeafProxy, NSObject, NSProxy, Object,"_CNZombie_"... */

+ (NSString*) superclassNameForClassNamed:(NSString*)x;
+ (NSString*) superclassNameForClass:(Class)x; /*! AOK [RuntimeReporter superclassNameForClass:NSString.class] = NSObject */

+ (NSArray*) inheritanceForClassNamed:(NSString*)x;
+ (NSArray*) inheritanceForClass:         (Class)x; /*! AOK [... inheritanceForClass:AtoZ.class] = ( NSObject, BaseModel, AtoZ ) */

+ (NSArray*) iVarNamesForClassNamed:(NSString*)x;
+ (NSArray*) iVarNamesForClass:         (Class)x;

+ (NSArray*) methodNamesForClassNamed:(NSString*)x;
+ (NSArray*) methodNamesForClass:         (Class)x;

+ (NSArray*) propertyNamesForClassNamed:(NSString*)x;
+ (NSArray*) propertyNamesForClass:         (Class)x;

+ (NSArray*) subclassNamesForClassNamed:(NSString*)x;  // Pass nil for the root classes.
+ (NSArray*) subclassNamesForClass:         (Class)x;

+ (NSArray*) protocolNamesForClassNamed:(NSString*)x;
+ (NSArray*) protocolNamesForClass:         (Class)x;

+ (BOOL) classHasSubclasses:(Class)x;

+ (int) numberOfSubclassesOfClass:(Class)x;
+ (int) numberOfClasses;

@end
