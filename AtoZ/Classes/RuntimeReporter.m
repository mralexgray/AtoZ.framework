//
//  RuntimeReporter.m
//  Runtime Browser
//
//  Created by John  C. Randolph on 7/22/04.
//  Copyright 2004-2009 John C. Randolph. All rights reserved.


#import "AtoZ.h"
#import "RuntimeReporter.h"
#import <objc/runtime.h>
#import <objc/Protocol.h>

#define ROOT_CLASSES_KEY @"ROOT_CLASSES_KEY"

@implementation RuntimeReporter NSMD *classLookupCache; NSMDATA *rawClassPointers;

+ (void) initialize         { [AZNOTCENTER addObserver:self selector:@selector(recache:) name:NSBundleDidLoadNotification object:nil]; }
+ (void) recache:(NSNOT*)a  {  // If a bundle loaded, then what we knew about the class tree is invalid

  NSMD * cache = self.cache; [cache removeObjectsForKeys:cache.allKeys];	// dump these, they'll be reloaded as necessary.
  rawClassPointers = nil;
}
+ (NSMD*) cache             { return classLookupCache = classLookupCache ?: NSMutableDictionary.new; }
+ (DATA*) rawClassPointers  { return rawClassPointers = rawClassPointers ?: ({

  int numClasses = self.numberOfClasses;
  rawClassPointers = [NSMutableData.alloc initWithLength: numClasses * sizeof(Class)];
  void *bytes = [rawClassPointers mutableBytes];
  objc_getClassList((__unsafe_unretained Class*)bytes, numClasses);
  rawClassPointers; });
}
+ (NSA*)  rootClasses       { return [self subclassNamesForClass: Nil];}   // Pass Nil for root classes.

+ (NSS*) superclassNameForClassNamed:(NSS*)k  { return [self superclassNameForClass:NSClassFromString(k)]; }
+ (NSS*)      superclassNameForClass:(Class)k { return NSStringFromClass(class_getSuperclass(k)); }
+ (NSA*)    inheritanceForClassNamed:(NSS*)k  { return [self inheritanceForClass:NSClassFromString(k)]; }
+ (NSA*)         inheritanceForClass:(Class)k {
  return class_getSuperclass(k)  ? [[self inheritanceForClass:class_getSuperclass(k)] arrayByAddingObject:NSStringFromClass(k)]
                                      : @[NSStringFromClass(k)];
}
+ (NSA*)  subclassNamesForClassNamed:(NSS*)k  {
  return [classLookupCache valueForKey:( k ? k : ROOT_CLASSES_KEY)]
      ?: [self subclassNamesForClass:NSClassFromString(k)];
} // Pass nil for the root classes.


// This method always checks the runtime, not the cached results!  Don't use this directly, use  -subclassNamesForClassNamed:  if you care about efficiency.
+ (NSA*)subclassNamesForClass:(Class)k   // Pass Nil for root classes.
{
  NSMA* names = @[].mC;  Class *classPointers = (Class*)self.rawClassPointers.bytes;

  int index = self.numberOfClasses;

  while (index --)	{
      Class thisClass = classPointers[index];
      if (class_getSuperclass(thisClass) ==k)
        if(thisClass) [names addObject:NSStringFromClass(thisClass)];
  }
  [names sortUsingSelector:@selector(compare:)];
  [self.cache setValue:names forKey:k ? NSStringFromClass(k) : ROOT_CLASSES_KEY];
  return names;
}

+ (BOOL) classHasSubclasses:(Class)k {  // Class*classPointers = (Class*)self.rawClassPointers.bytes;

  return [self subclassNamesForClass:k].count != 0;
//  int index = self.numberOfClasses;
//
//  return [@(index-1).toArray testThatAllReturn:NO block:^BOOL(id o) {
//      Class thisClass = (Class) classPointers[[o uIV]];
//      return class_getSuperclass(thisClass) ==k;
//  }];

//  while (index --) { Class thisClass = (Class) classPointers[index];
//      if (class_getSuperclass(thisClass) ==k)  return YES;
//  }
//  return NO;
}

+ (int) numberOfSubclassesOfClass:(Class)k  { return 0; }
+ (int) numberOfClasses                           { return objc_getClassList(nil, 0); }
+ (NSA*) methodNamesForClassNamed:(NSS*)k   { return [self methodNamesForClass:NSClassFromString(k)]; }
+ (NSA*)      methodNamesForClass:(Class)k  {

  unsigned int mCt; Method *meths = class_copyMethodList(k, &mCt); if (!meths) return nil;
  id z = [@(mCt-1) mapTimes:^id(NSN*num) { return @(sel_getName(method_getName(meths[num.uIV]))); }]; return free(meths), z;
}

+ (NSA*) iVarNamesForClassNamed:(NSS*)k   { return [self iVarNamesForClass:NSClassFromString(k)]; }
+ (NSA*)      iVarNamesForClass:(Class)k  {

  Ivar *ivars = NULL; unsigned int ivarCount; if (!(ivars = class_copyIvarList(k, &ivarCount))) return nil;
  id z = [@(ivarCount-1) mapTimes:^id(NSN*num) { return @(ivar_getName(ivars[num.uIV])); }]; return free(ivars), z;
}

+ (NSA*) propertyNamesForClassNamed:(NSS*)k   { return [self iVarNamesForClass:NSClassFromString(k)]; }
+ (NSA*)      propertyNamesForClass:(Class)k  {

  objc_property_t *props = NULL; unsigned int propsCount; if (!(props = class_copyPropertyList(k, &propsCount))) return nil;
  id z = [@(propsCount-1) mapTimes:^id(NSN*num) { return @(property_getName(props[num.uIV])); }]; return free(props), z;
}

+ (NSA*) protocolNamesForClassNamed:(NSS*)k   { return [self protocolNamesForClass:NSClassFromString(k)]; }
+ (NSA*)      protocolNamesForClass:(Class)k  {

  Protocol *__unsafe_unretained * pr; unsigned int prCt; if (!(pr = class_copyProtocolList(k, &prCt))) return nil;
  id z = [@(prCt-1) mapTimes:^id(NSN *num) {  return @(protocol_getName(pr[num.uIV]));  }];  return free(pr), z;
}

@end
