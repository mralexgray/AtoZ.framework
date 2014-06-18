//  AtoZFunctions.h


#import <Carbon/Carbon.h>
#import <ApplicationServices/ApplicationServices.h>
#import <CoreServices/CoreServices.h>
#import <BlocksKit/BlocksKit.h>
#import <objc/objc-class.h>
#import <objc/runtime.h>
#import "AtoZUmbrella.h"


/*! For Unit testing blocks etc... @code

  __block NSInteger newIndex = -1;

  [_noHitLayer addObserverForKeyPath:@"siblingIndexMax" task:^(id l) { newIndex = [l siblingIndexMax]; }];
  [_noHitLayer.superlayer addSublayer:CAL.layer];

  STAssertTrue(WaitFor(^BOOL { return newIndex != -1; }), @"still waiting");
*/

typedef BOOL(^UntilTrue)();
NS_INLINE BOOL WaitFor(UntilTrue until){  

  while(!until() && AZPROCINFO.systemUptime - AZPROCINFO.systemUptime <= 10)
    [AZRUNLOOP runMode:NSDefaultRunLoopMode beforeDate:NSDate.date];            return until();
}


NSString* AZTrace(void(^block)(void));

int lookup_function_pointers(const char* filename, ...);

/*	  
     [runCommand(@"ls -la /")log]; ->

     total 16751
     drwxrwxr-x+ 60 root        wheel     2108 May 24 15:19 .
     drwxrwxr-x+ 60 root        wheel     2108 May 24 15:19 ..
     drwxrwxrwt@  5 localadmin  admin      170 Jul 14  2012 .TemporaryItems ,,, 
*/
NSS* runCommand(NSS* c);

/* Do not use these things. If you think using something in this file is a good idea, stop, turn 360º, walk away, and give it some serious thought.
	The code was written by Satan himself with the blood of new born babies. */
Method GetImplementedInstanceMethod		  (Class aClass, SEL sel);
   IMP SwizzleImplementedInstanceMethods (Class aClass, const SEL origS, const SEL altS);

/** BLOCKS!  */
void profile (const char *name, VoidBlock block); 		// usage	 profile("Long Task", ^{ performLongTask() } );


// StringConsts.h
#ifdef SYNTHESIZE_CONSTS
# define STR_CONST(name, value) NSString* const name = @ value
#else
# define STR_CONST(name, value) extern NSString* const name
#endif

#define __VA_ARG_CT__(...) __VA_ARG_CT__IMPL(0, ## __VA_ARGS__, 5,4,3,2,1,0)
#define __VA_ARG_CT__IMPL(_0,_1,_2,_3,_4,_5,N,...) N

//#define __VA_ARG_CT__(...) (sizeof(#__VA_ARGS__) == sizeof("") ? 0 : VA_NUM_ARGS_IMPL(__VA_ARGS__, 5,4,3,2,1))


#define VA_NUM_ARGS(...) VA_NUM_ARGS_IMPL(__VA_ARGS__, 9,8,7,6,5,4,3,2,1) 	 	// USAGE int i = VA_NUM_ARGS("sssss",5,3);  -> i = 3
#define VA_NUM_ARGS_IMPL(_1,_2,_3,_4,_5,_6,_7,_8,_9,N,...) N

//@interface NSIMG (SizeLike) <SizeLike> @end

//#define    FORBIDDEN_CLASSES( ([NSA arrayWithObjects:__VA_ARGS__]contains           [NSException raise:@"We should never get here!" format:@"%@ should have implemented this:%@", self.className, AZSELSTR]
#define  ASSERTSAME(A,B)      NSAssert(A == B, @"These values should be same, but they are %@ and %@", @(A), @(B))
#define    CONFORMS(PROTO)    [self conformsToProtocol:@protocol(PROTO)]
#define IF_CONFORMS(PROTO,X)  if(CONFORMS(PROTO)){ ({ X; }) }

#define    GETALIASF(X)        return [self floatForKey:@#X]  // [self vFK:NSStringify(X)];    [value getValue: ptr];    (const char * typeCode, void * value); [self  X]
#define    SETALIAS(X,V)      [self sV:V fK:@#X]

//#define REFUSE_CLASSES(SPLIT)
//	[NSException raise:@"NonConformantProtocolMethodFallThrough" format:@"This concrete protocol NEEDS YOU (%@) to

#define YOU_DONT_BELONG return [NSException raise:@"ProtocolIsOverridingYourMethod" format:@"You already implement %@. why are you (%@) here?", AZSELSTR, self]

#define DEMAND_CONFORMANCE	[NSException raise:@"NonConformantProtocolMethodFallThrough" format:@"This concrete protocol NEEDS YOU (%@) to implement this method,.. %@ elsewhere... for internal peace and traquility.",self.className, AZSELSTR]

#ifndef AZO
#define AZO AZOrient
#endif
//- (BOOL) isVertical;


#define ISKINDA isKindOfClass                                 /*! @code  [@"d" ISKINDA:NSNumber.class]   -> NO     */
#define ISA(OBJ,KLS) (BOOL)([((id)OBJ) ISKINDA:[KLS class]])	/*! @code  ISA(@"apple",NSString)          -> YES    */
#define ISNOTA(OBJ,KLASS) (BOOL)(!ISA(((id)OBJ),KLASS))       /*! @code  ISA(@"apple",NSString)          -> YES    */
#define AM_I_A(KLASS) ISA(self,KLASS)                         /*! @code  AM_I_A(NSString)                -> YES    */

///#define ANYSUPERLAYERISA

//OBJC_EXPORT  BOOL AZISAAnyOfThese(Class x, ...); // under construction

//#define ISANYOF(OBJ,...) AZISAAnyOfThese([OBJ class],__VA_ARGS__,NULL) // under construction

OBJC_EXPORT BOOL AZEqualToAnyObject(id x, ...); 

#define EQUAL2ANYOF(OBJ,...) (BOOL)AZEqualToAnyObject(OBJ,__VA_ARGS__)

#define ISIN(X,ARRAY) [ARRAY containsObject:X]

#define IS_IN_STATIC_SPLIT(NEEDLE,...) ISIN(NEEDLE,SPLIT(__VA_ARGS__))

// ({ AZSTATIC_OBJ(NSA,HAYSTACK,SPLIT(HAYSTACK)); [HAYSTACK containsObject:NEEDLE]; })

#define ISACLASS(OBJ) class_isMetaClass(object_getClass(OBJ))

/*! ALLARE - check that all NSArray objects are a certain class.. @code  id x = @[RED, GREEN, @1]; ALLARE(x,NSC)) ? [x ...] : nil;  */

#define ALLARE(OBJS,KLS) ({ NSParameterAssert(ISA(OBJS,NSA)); [OBJS all:^BOOL(id obj) { return ISA(obj,KLS); }]; })

//object_getClass([a class]))					// USAGE  ISACLASS(NSString)					-> YES

// USAGE  IFKINDA( X, SomeClass, LOG_EXPR(((SomeClass*)X).someProperty) );
#define IFKINDA(_obj_,_meta_,_method_)				  ({ if([_obj_ ISKINDA:[_meta_ class]]) _method_; })
#define IFKINDAELSE(_obj_,_meta_,_method_,_else_) ({ if([_obj_ ISKINDA:[_meta_ class]]) _method_; else _else_; })
#define IFNOT(_condition_,_action_)					  ({ if(!(_condition_)) _action__; })


#define AZOL AZOutlineLayer

FOUNDATION_STATIC_INLINE void AZPlaySound(NSS *path) { runCommand([@"afplay " withString:path]); }

//#define PLAYMACRO(...) \
//static inline void ##metamacro_head(__VA_ARGS__)() { \
//            AZPlaySound([NSS.alloc initWithFormat:@"%s" arguments:metamacro_tail(__VA_ARGS__)]); }
////  \/\*fprintf(stderr,"%s", "##path\""); \*\/
//
//PLAYMACRO(Chirp, "/System/Library/PrivateFrameworks/ShareKit.framework/Versions/A/PlugIns/Twitter.sharingservice/Contents/Resources/tweet_sent.caf")


#define PLAYMACRO(name,path) \
 NS_INLINE void play##name (void){ fprintf(stderr,"%s", "##path\""); runCommand ([@"afplay " withString: @#path]); }

/*! playChirp();  -> SQUWAAAK! */

PLAYMACRO(Chirp, /System/Library/PrivateFrameworks/ShareKit.framework/Versions/A/PlugIns/Twitter.sharingservice/Contents/Resources/tweet_sent.caf)


// a function pointer is...			void(*pT)() = &playTrumpet;
// and is called like...						pT();

FOUNDATION_STATIC_INLINE void playTrumpet(void){ runCommand(@"afplay \"/System/Library/Frameworks/GameKit.framework/Versions/A/Resources/GKInvite.aif\""); }

void playTrumpetDeclared(void);

FOUNDATION_STATIC_INLINE void logger(NSS*toLog){ runCommand($(@"logger %@", toLog)); }


FOUNDATION_STATIC_INLINE NSS* AZRunAppleScipt(NSS*scriptText){   // multi line string literal

  return ((NSAppleEventDescriptor*)[[NSAppleScript.alloc initWithSource:scriptText]
                                                  executeAndReturnError:nil]).strV;
}

//NS_INLINE void playChirp  (void){ runCommand(@"afplay \"/System/Library/PrivateFrameworks/ShareKit.framework/Versions/A/PlugIns/Twitter.sharingservice/Contents/Resources/tweet_sent.caf\""); }
//NS_INLINE void playSound  (void){ runCommand(@"afplay \"/System/Library/Components/CoreAudio.component/Contents/SharedSupport/SystemSounds/accessibility/Sticky Keys ON.aif\"");}


NS_INLINE int  hexToInt ( char  hex ) { return  hex >= '0' && hex <= '9' ? hex - '0'
                          : hex >= 'a' && hex <= 'f' ? hex - 'a' + 10
                        :   hex >= 'A' && hex <= 'F'  ? hex - 'A' + 10 : -1;
} // Convert hex to an int

NS_INLINE  char intToHex ( NSI dig ) { return dig > 9 ? ( dig <= 0xf ? ('a' + dig - 10) : '\0') : dig >= 0 ? '0' + dig : '\0' ; /*NUL*/ } // Convert int to a hex

#define ONE_THIRD (1.0f / 3.0)
#define ONE_SIXTH (1.0f / 6.0)
#define TWO_THIRD (2.0f / 3.0)

#define AZNormalFloat(x) x = x < 0 ? 0 : x > 1 ? 1 : x

FOUNDATION_STATIC_INLINE CGFloat rF (){ return (CGFloat)((arc4random()%255)/255.); }

NSG* GradForClr(azkColor c);
NSC* Clr(azkColor c);

NSA* AZConstDefaults(AZO orientation);

CACONST * AZConstRelSuper                 ( CACONSTATTR attr);
CACONST * AZConst                         ( CACONSTATTR attr, NSS* rel);
CACONST * AZConstRelAttr                  ( CACONSTATTR aOne, NSS *rel, CACONSTATTR aTwo);
CACONST * AZConstScaleOff                 ( CACONSTATTR attr, NSS* rel,                  CGF scl, CGF off );
CACONST * AZConstRelSuperScaleOff         ( CACONSTATTR attr,                            CGF scl, CGF off );
CACONST * AZConstAttrRelNameAttrScaleOff 	( CACONSTATTR aOne, NSS* rel, CACONSTATTR aTwo, CGF scl, CGF off );

CAT3D  	m34();


/*		The in my .h/.m pair where I want to define the constant I do the following:

	myfile.h		#import <StringConsts.h>  STR_CONST(MyConst, "Lorem Ipsum");		STR_CONST(MyOtherConst, "Hello world");

	myfile.m		#define SYNTHESIZE_CONSTS		#import "myfile.h"		#undef SYNTHESIZE_CONSTS
*/

//@interface AZSingleton : NSObject
//+ (void) setSharedInstance:(id)i;
//+(instancetype) instance;
//+(instancetype) sharedInstance;  //alias for instance
////+(instancetype) uno;		  //alias for instance
//@end

/**  PYTHON!  */
typedef void (^PythonBlock)		 (NSS* path,   NSS*inDir, NSA* args,   NSS* anENV, NSS *pyPATH);
void pyRunWithArgsInDirPythonPath (NSS* script, NSA *args, NSS*working, NSS* pyPATH);
void pyRunWithArgsInDir				 (NSS* script, NSA *args, NSS*working);
void pyRunWithArgs					 (NSS* script, NSA *args);
void runPythonAtPathWithArgs		 (NSS* path, 	NSA *array);


char** cArrayFromNSArray 			 ( NSArray* array );
void 	 monitorTask					 ( NSTask* task	);
NSTSK* launchMonitorAndReturnTask ( NSTask* task	);

typedef void (^updateKVCKeyBlock)();
@interface NSObject (KVONotifyBlock)
- (void) setValueForKey:(NSString*)key andNotifyInBlock:(updateKVCKeyBlock)block;
@end

////must Initialize the value transformers used throughout the application bindings
//+ (void)initialize{ [NSVT setValueTransformer:[BoolToImageTransformer new] forName:@"BoolToImageTransformer"];	}
@interface BoolToImageTransformer : NSValueTransformer
@end
@interface AZInstallationStatusToImageTransformer : NSValueTransformer
@property (nonatomic, assign) NSSZ *size;
@end

/** 	Custom Table Action Cells!  */

@interface AZColorTableCell : NSActionCell
@end
@interface  AZInstallStatusCell : NSActionCell
@end
@interface NSTableView (CustomDataCell)
- (void) setColumnWithIdentifier:(NSS*)identifier toClass:(Class)actionCellClass;
@end

/** 	Custom Table Action Cell Blocks!  */

typedef void(^AZActionCellBlock)(id objVal);
@interface AZToggleClickTableCell : NSActionCell
@property (nonatomic, assign) AZActionCellBlock actionBlock;
@end

#define boardPositionToIndex(pos, boardSize) ((pos).x - 1) + (((pos).y - 1) * boardSize)
#define indexToBoardPosition(idx, boardSize) (CGPointMake((x) % boardSize, (int)((x) / boardSize) + 1))


///// ### SANDBOX
NSS*	realHomeDirectory		();
char*	GetPrivateIP			();
BOOL 	powerBox					();

void 	trackMouse				();


NSS*	WANIP						();
NSS* 	StringFromIPv4Addr(UInt32 ipv4Addr);	/** Converts a raw IPv4 address to an NSString in dotted-quad notation */
char*	GetPrivateIP			();
NSS* 	serialNumber			();

CGF 	AZDeviceScreenScale 	();
CGF	AZScreenWidth  	  	();
CGF	AZScreenHeight 	  	();

void 	ApplicationsInDirectory	( NSS *searchPath, NSMA *applications );
void 	PoofAtPoint					( NSP pt, CGF radius);
BOOL 	isPathAccessible 			( NSS *path, SandBox mode );


NSS*	googleSearchFor( NSS* string );   // broken!

BOOL 	SameChar			( const char *a, const char *b );
BOOL 	SameString		(          id a,          id b );
BOOL 	SameStringI		(          NSS* a,          NSS* b );
BOOL 	SameClass		(          id a, 			  id b );
NSS* 	bitString		( NSUI  bMask );
BOOL 	areSame 			( id a,  id b );
BOOL 	isEmpty			( id whatever );

BOOL 	areSameThenDo					( id a, id b, VoidBlock doBlock);

NSS* 	AZToStringFromTypeAndValue	( const char *typeCode, void *value );

NSCharacterSet* _GetCachedCharacterSet(CharacterSet set);
OSStatus HotKeyHandler				( EventHandlerCallRef nextHandler, EventRef theEvent, void *userData);
CIFilter* CIFilterDefaultNamed	( NSS* name );

//static inline NSString* typeStringForType(thing) { return 	SameString( @encode(typeof(thing)), @encode(typeof(CAConstraintAttribute)))
//	? [NSString stringWithFormat:NSLocalizedString( @"CAConstraintAttribute_%i",thing] 	: nil;
//	NSString *key = [NSString stringWithFormat:@"IngredientType_%i", _type]; }

static inline BOOL NSRangeContainsIndex( NSRNG range, NSUI index ) {
	return (range.location != NSNotFound) && range.length ? (index >= range.location) && (index < range.location + range.length): NO;
}
static inline BOOL NSRangeContainsRange( NSRNG range1, NSRNG range2) {
 	return ((range1.location != NSNotFound) && range1.length && (range2.location != NSNotFound) && range2.length)
	?	 (range2.location >= range1.location) && (range2.location   <  range1.location + range1.length)
	&&  (range2.location +  range2.length 	  >=  range1.location) && (range2.location + range2.length < range1.location + range1.length)
	:NO;
}

//static inline
//BOOL isEmpty(id thing);
//typedef int (^triple)(int number);

#define AZAPPMAIN int main(int c, const char * v[]) {	return NSApplicationMain(c,(const char**)v); }


//void (^now)(void) = ^ {	NSDate *date = [NSDate date]; NSLog(@"The date and time is %@", date); };

//NS_INLINE void AZShowWindow(NSW*w){  [w setHidden]

NS_INLINE	NSW* NSWINDOWINIT(NSR frame, NSUI mask){ AZSHAREDAPP; AZSHAREDAPP.activationPolicy = NSApplicationActivationPolicyRegular;

//  print(@"NSWINDOWINIT frame:", AZString(frame), @" mask:", AZString(mask), nil);
	NSW* w =	[NSW.alloc initWithContentRect:frame styleMask:mask == NSNotFound ? 1|2|4|8 : /* 1 << 3*/ mask backing:2 defer:NO]; [NSApp activateIgnoringOtherApps:YES]; [w makeKeyAndOrderFront:nil]; return w;
}
NS_INLINE	NSW* AZBORDLESSWINDOWINIT	(NSR frame) {

	return 	[NSW.alloc initWithContentRect:frame styleMask:(1|8) backing:2 defer:NO];
}
#define AZWINDOWINIT NSWINDOWINIT(AZRectFromDim(100),1|2|4|8)

#define AZBORDERLESSWIN AZBORDLESSWINDOWINIT(AZRectFromDim(100))

NSS * AZStringForTypeOfValue		(id *obj); 				 //(NSString* (^)(void))blk;
NSS * AZToStringFromTypeAndValue	(const char *typeCode, void *value);
NSS * AZStringFromRect						(NSRect rect);
NSS * AZStringFromPoint				(NSP p);
NSS * AZStringFromSize(NSSZ sz);
NSA * ApplicationPathsInDirectory			(NSString *searchPath);

void DrawLabelAtCenterPoint (NSS* string, NSPoint center);
void DrawGlossGradient(CGContextRef context, NSC *color, NSR inRect);
void drawResizeHandleInRect(NSR frame);

CGF perceptualGlossFractionForColor ( CGFloat *inputComponents 		);
CGImageRef 	CreateGradientImage		( int pixelsWide, int pixelsHigh );
NSIMG* 		reflectedView				( NSV* view 							); // Creates an autoreleased reflected image of the contents of the main view


CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh);
CGF percent ( CGFloat val );
CGF DegreesToRadians ( CGFloat degrees );
void NSRectFillWithGradient(NSR rect, NSG *grad);
void NSRectFillWithColor (NSRect rect, NSColor* color);
void NSFrameRectWithColor(NSR rect, NSC *color);
void NSFrameRectWithWidthWithColor(NSR rect, CGF frameWidth,NSC *color);
void AZSpinnerInViewWithColor(NSV * view, NSC * color);

//CGFloat DEG2RAD(CGFloat degrees);
//{return degrees * M_PI / 180;};
//CGFloat RAD2DEG(CGFloat radians) {return radians * 180 / M_PI;};

NSS* StringFromCATransform3D(CATransform3D transform);
NSS* prettyFloat(CGFloat f);

NS_INLINE void rebuildServicesMenu(void) {  NSUpdateDynamicServices(); printf("The services menu has been rebuilt. You must restart any active applications to see changes.\n"); }

CGImageRef ApplyQuartzComposition ( const char* compositionName, const CGImageRef srcImage );

//inline float RandomComponent() {  return (float)random() / (float)LONG_MAX; }

//	were static
void glossInterpolation(void *info, const CGFloat *input, CGFloat *output);


/**		MATH!   */

CGF 	randomComponent();
CGF 	frandom ( double start, double end );
NSUI 	AZNormalizedNumberLessThan (id number, NSUInteger max);
NSI 	AZNormalizedNumberGreaterThan (NSI number, NSI min);
NSN* 	AZNormalNumber (NSN* number, NSN *min, NSN* max);
CGF 	AZNormalCGF (CGF floatV, CGF minV, CGF maxV);
NSUI 	AZNormalNSUI (NSUI i, NSUI min, NSUI max);


BOOL isEven( NSI aNumber );
BOOL isOdd ( NSI aNumber );

NSN* 	DegreesToNumber	( CGF degrees 	);
CGF 	DegreesToRadians	( CGF degrees 	);
NSP	getCenter			( NSV *view		);

CGPathRef AZRandomPathWithStartingPointInRect(CGPoint firstPoint, NSR inRect);
CGPathRef AZRandomPathInRect(NSR rect);


//#pragma once
// Copyright (c) 2008-2010, Vincent Gable.
// vincent.gable@gmail.com


// WARNING: if NO_LOG_MACROS is #define-ed, than THE ARGUMENT WILL NOT BE EVALUATED
//#ifndef NO_LOG_MACROS


// http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html
//static inline BOOL IsEmpty(id thing) {
//	return thing == nil ||
//			([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
//			([thing respondsToSelector:@selector(count)]  && [(NSArray *)thing count] == 0);
//}


/*
 int main (int argc, const char * argv[]) {
 @autoreleasepool {
 if (argc < 3) PrintUsageAndQuit();
 NSS *verb = [NSS stringWithUTF8String:argv[1]];
 unsigned i;
 for (i = 2; i < argc; i++) {
 char buffer[PATH_MAX];
 NSS  *path  = [NSS stringWithUTF8String:argv[i]];
 realpath([[path stringByExpandingTildeInPath] UTF8String], buffer);
 path 	   	= [NSString stringWithUTF8String: buffer];
 NSURL *url 	= [NSURL fileURLWithPath: path];
 if ([verb isEqualToString:@"status"])  	{	AZLOG(@"STATUS");	}
 else if ([verb isEqualToString:@"include"]){	AZLOG(@"INCLUDE");	}
 else  										{	PrintUsageAndQuit();}
 }
 }
 return 0;
 }	*/
//static void PrintUsageAndQuit(void) __attribute__((noreturn));
//static void PrintStatus(NSURL *url);

/*
 // make sure non-Clang compilers can still compile
 #ifndef __has_feature
 #define __has_feature(x) 0
 #endif

 // no ARC ? -> declare the ARC attributes we use to be a no-op, so the compiler won't whine
 #if ! __has_feature( objc_arc )
 #define __autoreleasing
 #define __bridge
 #endif
 #define ARRAY(...) ([NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])
 #define SET(...) ([NSSet setWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)])

 // this is key/object order, not object/key order, thus all the fuss
 #define DICT(...) MADictionaryWithKeysAndObjects(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

 #define MAP(collection, ...) EACH_WRAPPER([collection ma_map: ^id (id obj) { return (__VA_ARGS__); }])
 #define SELECT(collection, ...) EACH_WRAPPER([collection ma_select: ^BOOL (id obj) { return (__VA_ARGS__) != 0; }])
 #define REJECT(collection, ...) EACH_WRAPPER([collection ma_select: ^BOOL (id obj) { return (__VA_ARGS__) == 0; }])
 #define MATCH(collection, ...) EACH_WRAPPER([collection ma_match: ^BOOL (id obj) { return (__VA_ARGS__) != 0; }])
 #define REDUCE(collection, initial, ...) EACH_WRAPPER([collection ma_reduce: (initial) block: ^id (id a, id b) { return (__VA_ARGS__); }])

 #define EACH(array) MAEachHelper(array, &MA_eachTable)	*/

/**  Sometimes it's useful to work on multiple arrays in parallel. For example, imagine that you have two arrays of strings and you want to create a third array that contains the contents of the two arrays combined into a single string. With MACollectionUtilities this is extremely easy:	*/

//	NSArray *first = ARRAY(@"alpha", @"air", @"bicy");
//	NSArray *second = ARRAY(@"bet", @"plane", @"cle");
//	NSArray *words = MAP(first, [obj stringByAppendingString: EACH(second)]);

// 		words now contains alphabet, airplane, bicycle

/*** The EACH macro depends on context set up by the other macros. You can only use it with the macros, not with the methods.
 You can use multiple arrays with multiple EACH macros to enumerate several collections in parallel:
 ***/

///	NSArray *result = MAP(objects, [obj performSelector: NSSelectorFromString(EACH(selectorNames))
///										withObject: EACH(firstArguments)
///										withObject: EACH(secondArguments)];

/*** The EACH macro works by creating and tracking an NSEnumerator internally. It lazily creates the enumerator on the first use, and then uses nextObject at each call. Thus if your arrays are not the same length, it will begin to return nil, watch out.

 Because they are unordered, parallel enumeration doesn't make sense for NSSet and EACH is not supported for them.
 ***/

/*
 #define SORTED(collection, ...) [collection ma_sorted: ^BOOL (id a, id b) { return (__VA_ARGS__) != 0; }]

 // ===========================================================================
 // internal utility whatnot that needs to be externally visible for the macros
 #define IDARRAY(...) ((__autoreleasing id[]){ __VA_ARGS__ })
 #define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))
 #define EACH_WRAPPER(...) (^{ __block CFMutableDictionaryRef MA_eachTable = nil; \
 (void)MA_eachTable; \
 __typeof__(__VA_ARGS__) MA_retval = __VA_ARGS__; \
 if(MA_eachTable) \
 CFRelease(MA_eachTable); \
 return MA_retval; \
 }())

 static inline NSDictionary *MADictionaryWithKeysAndObjects(id *keysAndObjs, NSUInteger count)
 {
 id keys[count];
 id objs[count];
 for(NSUInteger i = 0; i < count; i++)
 {
 keys[i] = keysAndObjs[i * 2];
 objs[i] = keysAndObjs[i * 2 + 1];
 }

 return [NSDictionary dictionaryWithObjects: objs forKeys: keys count: count];
 }

 static inline id MAEachHelper(NSArray *array, CFMutableDictionaryRef *eachTablePtr)
 {
 if(!*eachTablePtr)
 {
 CFDictionaryKeyCallBacks keycb = {
 0,
 kCFTypeDictionaryKeyCallBacks.retain,
 kCFTypeDictionaryKeyCallBacks.release,
 kCFTypeDictionaryKeyCallBacks.copyDescription,
 NULL,
 NULL
 };
 *eachTablePtr = CFDictionaryCreateMutable(NULL, 0, &keycb, &kCFTypeDictionaryValueCallBacks);
 }

 NSEnumerator *enumerator = (__bridge id)CFDictionaryGetValue(*eachTablePtr, (__bridge CFArrayRef)array);
 if(!enumerator)
 {
 enumerator = [array objectEnumerator];
 CFDictionarySetValue(*eachTablePtr, (__bridge CFArrayRef)array, (__bridge void *)enumerator);
 }
 return [enumerator nextObject];
 }
	*/

/*
 extern NSArray* iconic = [iconicStrings array]
 static NSArray* iconicStrings = @[ @"ampersand.pdf", @"aperture_alt.pdf", @"aperture.pdf", @"arrow_down_alt1.pdf", @"arrow_down_alt2.pdf", @"arrow_down.pdf", @"arrow_left_alt1.pdf", @"arrow_left_alt2.pdf", @"arrow_left.pdf", @"arrow_right_alt1.pdf", @"arrow_right_alt2.pdf", @"arrow_right.pdf", @"arrow_up_alt1.pdf", @"arrow_up_alt2.pdf", @"arrow_up.pdf", @"article.pdf", @"at.pdf", @"award_fill.pdf", @"award_stroke.pdf", @"bars_alt.pdf", @"bars.pdf", @"battery_charging.pdf", @"battery_empty.pdf", @"battery_full.pdf", @"battery_half.pdf", @"beaker_alt.pdf", @"beaker.pdf", @"bolt.pdf", @"book_alt.pdf", @"book_alt2.pdf", @"book.pdf", @"box.pdf", @"brush_alt.pdf", @"brush.pdf", @"calendar_alt_fill.pdf", @"calendar_alt_stroke.pdf", @"calendar.pdf", @"camera.pdf", @"cd.pdf", @"chart_alt.pdf", @"chart.pdf", @"chat_alt_fill.pdf", @"chat_alt_stroke.pdf", @"chat.pdf", @"check_alt.pdf", @"check.pdf", @"clock.pdf", @"cloud_download.pdf", @"cloud_upload.pdf", @"cloud.pdf", @"cog_alt.pdf", @"cog.pdf", @"comment_alt1_fill.pdf", @"comment_alt1_stroke.pdf", @"comment_alt2_fill.pdf", @"comment_alt2_stroke.pdf", @"comment_alt3_fill.pdf", @"comment_alt3_stroke.pdf", @"comment_fill.svg.pdf", @"comment_stroke.svg.pdf", @"compass.svg.pdf", @"cursor.svg.pdf", @"curved_arrow.svg.pdf", @"denied_alt.svg.pdf", @"denied.svg.pdf", @"dial.svg.pdf", @"document_alt_fill.svg.pdf", @"document_alt_stroke.svg.pdf", @"document_fill.svg.pdf", @"document_stroke.svg.pdf", @"download.svg.pdf", @"eject.svg.pdf", @"equalizer.svg.pdf", @"eye.svg.pdf", @"eyedropper.svg.pdf", @"first.svg.pdf", @"folder_fill.svg.pdf", @"folder_stroke.svg.pdf", @"fork.svg.pdf", @"fullscreen_alt.svg.pdf", @"fullscreen_exit_alt.svg.pdf", @"fullscreen_exit.svg.pdf", @"fullscreen.svg.pdf", @"hash.svg.pdf", @"headphones.svg.pdf", @"heart_fill.svg.pdf", @"heart_stroke.svg.pdf", @"home.svg.pdf", @"image.svg.pdf", @"info.svg.pdf", @"iphone.svg.pdf", @"key_fill.svg.pdf", @"key_stroke.svg.pdf", @"last.svg.pdf", @"layers_alt.svg.pdf", @"layers.svg.pdf", @"left_quote_alt.svg.pdf", @"left_quote.strV
 g.pdf", @"lightbulb.svg.pdf", @"link.svg.pdf", @"list.svg.pdf", @"lock_fill.svg.pdf", @"lock_stroke.svg.pdf", @"loop_alt1.svg.pdf", @"loop_alt2.svg.pdf", @"loop_alt3.svg.pdf", @"loop_alt4.svg.pdf", @"loop.svg.pdf", @"magnifying_glass_alt.svg.pdf", @"magnifying_glass.svg.pdf", @"mail_alt.svg.pdf", @"mail.svg.pdf", @"map_pin_alt.svg.pdf", @"map_pin_fill.svg.pdf", @"map_pin_stroke.svg.pdf", @"mic.svg.pdf", @"minus_alt.svg.pdf", @"minus.svg.pdf", @"moon_fill.svg.pdf", @"moon_stroke.svg.pdf", @"move_alt1.svg.pdf", @"move_alt2.svg.pdf", @"move_horizontal_alt1.svg.pdf", @"move_horizontal_alt2.svg.pdf", @"move_horizontal.svg.pdf", @"move_vertical_alt1.svg.pdf", @"move_vertical_alt2.svg.pdf", @"move_vertical.svg.pdf", @"move.svg.pdf", @"movie.svg.pdf", @"new_window.svg.pdf", @"pause.svg.pdf", @"pen_alt_fill.svg.pdf", @"pen_alt_stroke.svg.pdf", @"pen_alt2.svg.pdf", @"pen.svg.pdf", @"pilcrow.svg.pdf", @"pin.svg.pdf", @"play_alt.svg.pdf", @"play.svg.pdf", @"plus_alt.svg.pdf", @"plus.svg.pdf", @"question_mark.svg.pdf", @"rain.svg.pdf", @"read_more.svg.pdf", @"reload_alt.svg.pdf", @"reload.svg.pdf", @"right_quote_alt.svg.pdf", @"right_quote.svg.pdf", @"rss_alt.svg.pdf", @"rss.svg.pdf", @"share.svg.pdf", @"spin_alt.svg.pdf", @"spin.svg.pdf", @"star.svg.pdf", @"steering_wheel.svg.pdf", @"stop.svg.pdf", @"sun_alt_fill.svg.pdf", @"sun_alt_stroke.svg.pdf", @"sun.svg.pdf", @"tag_fill.svg.pdf", @"tag_stroke.svg.pdf", @"target.pdf", @"transfer.pdf", @"trash_fill.pdf", @"trash_stroke.pdf", @"umbrella.pdf", @"undo.pdf", @"unlock_fill.pdf", @"unlock_stroke.pdf", @"upload.pdf", @"user.pdf", @"volume_mute.pdf", @"volume.pdf", @"wrench.pdf", @"x_alt.pdf", @"x.pdf"];	*/


static __unused int runforpath(const char *path);
static __unused off_t totaldiratpath(const char *path);

NSUI sizeOfDirectoryAt(NSS* path);
NSS* prettySizeOfDirAt(NSS *path);

NSS* weatherForZip(NSUI zip);


