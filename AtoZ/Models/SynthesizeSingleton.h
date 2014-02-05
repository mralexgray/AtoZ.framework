//
//  SynthesizeSingleton.h
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Modified by Oliver Jones.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

//#if __has_feature(objc_arc)

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) 		\
+ (classname *)accessorname {														\
	static classname *accessorname = nil;										\
	static dispatch_once_t onceToken;											\
	dispatch_once(&onceToken, ^{ accessorname = classname.new; });		\
	return accessorname; 															\
}
/*
#else
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) \
static classname *shared##classname = nil; \
+ (void)cleanupFromTerminate { \
classname *temp = shared##classname; \
shared##classname = nil; \
[temp dealloc]; } \
+ (void)registerForCleanup { \
[AZNOTCENTER addObserver:self \
selector:@selector(cleanupFromTerminate) \
name:NSApplicationWillTerminateNotification \
object:nil]; \
} \
+ (classname *)accessorname \
{ \
static dispatch_once_t p; \
dispatch_once(&p, \
^{ \
if (shared##classname == nil) \
{ \
NSAutoreleasePool *pool = NSAutoreleasePool.new; \
shared##classname = self.new; \
[self registerForCleanup]; \
[pool drain]; \
} \
}); \
return shared##classname; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t p; \
__block classname* temp = nil; \
dispatch_once(&p, \
^{ \
if (shared##classname == nil) \
{ \
temp = shared##classname = [super allocWithZone:zone]; \
} \
}); \
return temp; \
} \
- (id)copyWithZone:(NSZone *)zone { return self; } \
- (id)retain { return self; } \
- (NSUI)retainCount { return NSUIntegerMax; } \
- (oneway void)release { } \
- (id)autorelease { return self; }
#endif
*/
/*
 #define $shared(Klass) [Klass shared##Klass]

 #ifdef ALLOW_ALLOC_INIT_FOR_SINGLETONS
 #define $singleton(Klass)\
 \
 static Klass *shared##Klass = nil;\
 \
 + (Klass *)shared##Klass {\
 @synchronized(self) {\
 if(shared##Klass == nil) {\
 shared##Klass = [[super allocWithZone:NULL] initSingleton];\
 }\
 }\
 return shared##Klass;\
 }\
 \
 - (id)init {\
 if((self = [super init])) {\
 [self initSingleton];\
 }\
 return self;\
 }
 #else
 #define $singleton(Klass)\
 \
 static Klass *shared##Klass = nil;\
 \
 + (Klass *)shared##Klass {\
 @synchronized(self) {\
 if(shared##Klass == nil) {\
 shared##Klass = [[super allocWithZone:NULL] init];\
 }\
 }\
 return shared##Klass;\
 }\
 \
 + (id)allocWithZone:(NSZone *)zone {\
 return [[self shared##Klass] retain];\
 }\
 \
 - (id)copyWithZone:(NSZone *)zone {\
 return self;\
 }\
 \
 - (id)retain {\
 return self;\
 }\
 \
 - (NSUI)retainCount {\
 return NSUIntegerMax;\
 }\
 \
 - (void)release {}\
 \
 - (id)autorelease {\
 return self;\
 }\
 \
 + (BOOL)isShared##Klass##Present {\
 return shared##Klass != nil;\
 }\
 \
 - (id)init {\
 if(![[self class] isShared##Klass##Present]) {\
 if((self = [super init])) {\
 [self initSingleton];\
 }\
 }\
 return self;\
 }
 #endif
 */
///* ConciseKit
// * Copyright 2010 Peter Jihoon Kim
// * Licensed under the MIT License.
// */
//#define $shared(Klass) [Klass shared##Klass]
//
//#ifdef ALLOW_ALLOC_INIT_FOR_SINGLETONS
//  #define $singleton(Klass)\
//  \
//  static Klass *shared##Klass = nil;\
//  \
//  + (Klass *)shared##Klass {\
//	@synchronized(self) {\
//	  if(shared##Klass == nil) {\
//		shared##Klass = [[super allocWithZone:NULL] initSingleton];\
//	  }\
//	}\
//	return shared##Klass;\
//  }\
//  \
//  - (id)init {\
//	if((self = [super init])) {\
//	  [self initSingleton];\
//	}\
//	return self;\
//  }
//#else
//  #define $singleton(Klass)\
//  \
//  static Klass *shared##Klass = nil;\
//  \
//  + (Klass *)shared##Klass {\
//	@synchronized(self) {\
//	  if(shared##Klass == nil) {\
//		shared##Klass = [[super allocWithZone:NULL] init];\
//	  }\
//	}\
//	return shared##Klass;\
//  }\
//  \
//  + (id)allocWithZone:(NSZone *)zone {\
//	return [[self shared##Klass] retain];\
//  }\
//  \
//  - (id)copyWithZone:(NSZone *)zone {\
//	return self;\
//  }\
//  \
//  - (id)retain {\
//	return self;\
//  }\
//  \
//  - (NSUI)retainCount {\
//	return NSUIntegerMax;\
//  }\
//  \
//  - (oneway void)release {}\
//  \
//  - (id)autorelease {\
//	return self;\
//  }\
//  \
//  + (BOOL)isShared##Klass##Present {\
//	return shared##Klass != nil;\
//  }\
//  \
//  - (id)init {\
//	if(![[self class] isShared##Klass##Present]) {\
//	  if((self = [super init])) {\
//		[self initSingleton];\
//	  }\
//	}\
//	return self;\
//  }
//#endif
//

//
//  SynthesizeSingleton.h
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Modified by Oliver Jones.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//


/*
#if __has_feature(objc_arc)
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) \
+ (classname *)accessorname\
{\
static classname *accessorname = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
accessorname = classname.new;\
});\
return accessorname;\
}
#else
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) \
static classname *shared##classname = nil; \
+ (void)cleanupFromTerminate \
{ \
classname *temp = shared##classname; \
shared##classname = nil; \
[temp dealloc]; \
} \
+ (void)registerForCleanup \
{ \
[[NSNotificationCenter defaultCenter] addObserver:self \
selector:@selector(cleanupFromTerminate) \
name:UIApplicationWillTerminateNotification \
object:nil]; \
} \
+ (classname *)accessorname \
{ \
static dispatch_once_t p; \
dispatch_once(&p, \
^{ \
if (shared##classname == nil) \
{ \
NSAutoreleasePool *pool = NSAutoreleasePool.new; \
shared##classname = self.new; \
[self registerForCleanup]; \
[pool drain]; \
} \
}); \
return shared##classname; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t p; \
__block classname* temp = nil; \
dispatch_once(&p, \
^{ \
if (shared##classname == nil) \
{ \
temp = shared##classname = [super allocWithZone:zone]; \
} \
}); \
return temp; \
} \
- (id)copyWithZone:(NSZone *)zone { return self; } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return NSUIntegerMax; } \
- (oneway void)release { } \
- (id)autorelease { return self; }
#endif

*/
