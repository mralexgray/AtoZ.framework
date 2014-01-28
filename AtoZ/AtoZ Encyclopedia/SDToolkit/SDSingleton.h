#define SDSingletonDeclare(singletonClass, globalVar)\
- (void) performSingletonInitialization;\
+ (singletonClass*) globalVar;

#define SDSingletonInitSpecial(singletonClass, globalVar, initStuff)\
static singletonClass *globalVar = nil;\
- (id) init {\
Class myClass = [self class];\
@synchronized(myClass) {\
if (globalVar == nil) {\
if (self = [super initStuff]) {\
globalVar = self;\
[self performSingletonInitialization];\
}\
}\
}\
return globalVar;\
}\
+ (singletonClass*) globalVar {\
@synchronized(self) { if (globalVar == nil) [[self alloc] init]; }\
return globalVar;\
}\
+ (id) allocWithZone:(NSZone *)zone {\
@synchronized(self) { if (globalVar == nil) return [super allocWithZone:zone]; }\
return globalVar;\
}\
- (id) copyWithZone:(NSZone *)zone { return self; }\
- (id) retain { return self; }\
- (unsigned) retainCount { return UINT_MAX; }\
- (void) release {}\
- (id) autorelease { return self; }\
\
- (void) performSingletonInitialization

#define SDSingletonInit(singletonClass, globalVar) SDSingletonInitSpecial(singletonClass, globalVar, init)
