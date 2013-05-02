//  AtoZFunctions.h

#import "AtoZUmbrella.h"
#import <BlocksKit/BlocksKit.h>

/** BLOCKS!  */
void profile (const char *name, VoidBlock block); 		// usage	 profile("Long Task", ^{ performLongTask() } );


// StringConsts.h
#ifdef SYNTHESIZE_CONSTS
# define STR_CONST(name, value) NSString* const name = @ value
#else
# define STR_CONST(name, value) extern NSString* const name
#endif

#pragma mark - COLOR LOGGING

/*	Foreground color: 	Insert the ESCAPE_SEQ into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.
 Background color:	 	Insert the ESCAPE_SEQ into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.
 Reset the foreground color (to default value):	Insert the ESCAPE_SEQ into your string, followed by "fg;"
 Reset the background color (to default value):	Insert the ESCAPE_SEQ into your string, followed by "bg;"
 Reset the fground and bground color (to default values) in 1 operation: Insert the ESCAPE_SEQ into your string, followed by ";"
 */

#if TARGET_OS_IPHONE
#define XCODE_COLORS_ESCAPE  @"\xC2\xA0["
#else
#define XCODE_COLORS_ESCAPE  @"\033["
#endif
#define XCODE_COLORS_RESET_FG  	XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  	XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET	 		XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define COLOR_RESET 					XCODE_COLORS_RESET
#define COLOR_ESC 					XCODE_COLORS_ESCAPE
#define XCODE_COLORS 0

//void _AZSimpleLog					( 				  const char *file, int line, const char *funcName, NSS *format, ... );
extern void _AZColorLog 					( id color, const char *file, int line, const char *funcName, NSS *format, ... );

NSA * COLORIZE						( id colorsAndThings, ... );
/* Pass a variadic list of Colors, and Ovjects, in any order, TRMINATED BY NIL, abd it wiull use those colors to log those objects! */

#define LOGCOLORS(X...) logNilTerminatedListOfColorsAndStrings(__PRETTY_FUNCTION__,X)
void logNilTerminatedListOfColorsAndStrings ( const char*pretty, id colorsAndThings,...);
/*	NSColor, "name" (CSS, or named color) or @[@4, @44, @244] rgbIntegers 		*/
NSS* colorizeStringWithColor	( NSS* string, id color );
/* same as colorizeStringWithColor but does the back, too.  same formatting. 	*/
NSS* colorizeStringWithColors	( NSS* string, id color, id back );
/*  pass in color, or hex string, get an array of r, g, b integers... [ 0 - 255 ] (i think) */
NSA* rgbColorValues 				( id color );

#define NSLog(fmt...) _AZColorLog(nil,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
#define AZLOG(a) NSLog(@"%@", a)
#define LogProps(a) NSLog(@"%@", a.propertiesPlease)
#define logprop(a) NSLog(@"%@", [a propertiesPlease])
//#define logobj(a) id logit = a \		 NSLog(@"%@", a)
#define desc(a) NSLog(@"%@", [a description])


#define	vLOG(A)	[((AppDelegate*)[NSApp sharedApplication].delegate).textOutField appendToStdOutView:A] 


#define COLORLOG(fmt...) logNilTerminatedListOfColorsAndStrings(__PRETTY_FUNCTION__,fmt)
//#define COLORLOG(fmt...) _AZColorLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
#define LOGWARN(fmt...) _AZColorLog(nil,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
#define LOG_EXPR(_X_) do{ 	__typeof__(_X_) _Y_ = (_X_);	const char * _TYPE_CODE_ = @encode(__typeof__(_X_)); \
													 NSString *_STR_ = VTPG_DDToStringFromTypeAndValue(_TYPE_CODE_, &_Y_); \
															if(_STR_)								NSLog(@"%s = %@", #_X_, _STR_); \
										  else NSLog(@"Unknown _TYPE_CODE_:%s for expr:%s in func:%s file:%s line:%d",  \
													_TYPE_CODE_, #_X_, __func__, __FILE__, __LINE__);}while(0)


/*

#define LOG_NS(...)
#define LOG_FUNCTION()
#endif / * NO_LOG_MACROS  * /

	$(@"%s: %@", __PRETTY_FUNCTION__, [NSString stringWithFormat: args])]
 #define LOGWARN(fmt,...) 	ConditionalLog(__VA_ARGS__)
 void _AZSimpleLog( const char *file, int lineNumber, const char *funcName, NSString *format, ... ) {
 id (^logAndReturn)(id); //= ^(id toLog) { AZLOG(toLog); return toLog; };
 extern void  LOGWARN (NSString *format, ...);
 #define LOG_NS(...) NSLog(__VA_ARGS__)
 #define LOG_FUNCTION()	NSLog(@"%s", __func__)
 #else / * NO_LOG_MACROS * /
#define LOG_EXPR(_X_)

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif
#define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

#define NSLog(args...) _AZLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
void _AZSimpleLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);

static NSString* MakeCritical(NSString *format,...) { NSString *string;	va_list   arguments;	va_start(arguments,format);   string = $(format,arguments);	  va_end(arguments);	return string;	}

#define CRITICAL(A) MakeCritical(XCODE_COLORS_ESCAPE @"fg218,147,0;" @"%@" XCODE_COLORS_RESET, A)

#define COLOR_WARN COLOR_ESC @"fg:74,203,68;"
#define MAKEWARN(A) [NSString stringWithFormat:@"%@ %@ %@", COLOR_WARN, (A), COLOR_RESET]
#define WARN(A) NSLog(@"%@", MAKEWARN(A))
#define LOGWARN(fmt,...) 	ConditionalLog(__VA_ARGS__)
#define LOGWARN(fmt,...) _AZConditionalLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args)
#define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);

 BOOL YESORNO = strcmp(getenv(XCODE_COLORS), "YES") == 0;					\
 va_list vl;																				\
 va_start(vl, fmt);																	\
 NSS* str = [NSString.alloc initWithFormat:(NSS*)fmt arguments:vl];	\
 va_end(vl);																				\
 //	YESORNO 	? 	NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" @"%@" XCODE_COLORS_RESET, __PRETTY_FUNCTION__, __LINE__, str) \
 : 	NSLog(@"%@",str); \
 }()
 strcmp(getenv(XCODE_COLORS), "YES") == 0 \
 ? NSLog(	(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" fmt XCODE_COLORS_RESET)\
 , __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__) \
 : NSLog(fmt,__VA_ARGS__)


 static inline void AZLOG(id args){ _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args); }
 void _AZSimpleLog( const char *file, int lineNumber, const char *funcName, NSString *format, ... ) {
 NS_INLINE void ConditionalLog( const char *filename, int line, const char *funcName, NSS *format, ... ) {

 BOOL YESORNO = strcmp(getenv(XCODE_COLORS), "YES") == 0;
 va_list   argList;
 va_start (argList, format);
 NSS *path  	= [[NSS stringWithFormat:@"%s",filename] lastPathComponent];
 NSS *mess   = [NSString.alloc initWithFormat:format arguments:argList];
 char *xcode_colors = getenv(XCODE_COLORS);
 va_list vl;
 va_start(vl, formatted);
 NSS* str = [NSString.alloc initWithFormat:(NSS*)formatted arguments:vl];
 va_end(vl);
 YESORNO 	?
 NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0; %@" XCODE_COLORS_RESET,__PRETTY_FUNCTION__, __LINE__, str)	: 	NSLog(@"%@",str);	}

 #ifndef _logging_h_
 #define _logging_h_
 extern int logIndent;
 #ifndef FORCE_DEBUG
 #define NO_DEBUG
 #endif
 #ifdef DEBUG
 # undef DEBUG
 #endif

 #ifdef NO_DEBUG
 # define DEBUG(fmt, ...)
 #else
 # define DEBUG(fmt, ...) do { \
 NSString *ws = [@"" stringByPaddingToLength:logIndent*2 withString:@" " startingAtIndex:0]; \
 NSLog([NSString stringWithFormat:@"%s:%u: %@%@", __func__, __LINE__, ws, fmt], ## __VA_ARGS__); \
 } while(0)
 #endif

 #define INFO(fmt, ...) do { \
 NSString *ws = [@"" stringByPaddingToLength:logIndent*2 withString:@" " startingAtIndex:0]; \
 NSLog([NSString stringWithFormat:@"%s:%u: %@%@", __func__, __LINE__, ws, fmt], ## __VA_ARGS__); \
 } while(0)

 #endif

 #ifndef FORCE_MEMDEBUG
 # define NO_MEMDEBUG
 #endif

 #ifdef NO_MEMDEBUG
 # define MEMDEBUG(fmt, ...)
 # define DEBUG_FINALIZE()
 # define DEBUG_DEALLOC()
 # define DEBUG_INIT()
 #else
 # define MEMDEBUG INFO
 # define DEBUG_DEALLOC() MEMDEBUG(@"%p free", self)
 # define DEBUG_INIT() MEMDEBUG(@"%p init", self)
 # define DEBUG_FINALIZE()		\
 - (void)finalize			\
 {					\
 MEMDEBUG(@"%p", self);		\
 [super finalize];		\
 }
 #endif
 */
 


// STACK MACRO: "UIKit 0x00540c89 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1163"
#define STACKARRAY [[NSThread.callStackSymbols[1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"]]arrayByRemovingObject:@""]
#define STACKSTACK		STACKARRAY[0]
#define STACKFRAMEWORK 	STACKARRAY[1]
#define STACKADDRESS 	STACKARRAY[2]
#define STACKCLASS 		STACKARRAY[3]
#define STACKFUNCTION 	STACKARRAY[4]
#define STACKLINE	 		STACKARRAY[5]

id 	LogStackAndReturn		  ( id toLog				);	//USAGE: .... return (NSA*)logAndReturn( [NSArray arrayWithArrays:@[blah,blahb]] );
id 	LogAndReturn			  ( id toLog				); //= ^(id toLog) { AZLOG(toLog); return toLog; };
id 	LogAndReturnWithCaller ( id toLog, SEL caller);
void 	QuietLog 				  ( NSS *format, ...		);



@interface  NSColor (compare)
- (NSComparisonResult)compare:(NSColor*)otherColor;
@end


#define ISKINDA isKindOfClass
#define ISA(a,b) (BOOL)[a ISKINDA:[b class]]



/**	NSS *colorString = @"fg218,147,0";
	NSS* envStr = @(getenv("XCODE_COLORS")) ?: @"YES";
	BOOL YESORNO = [envStr boolValue];
	if (color !=nil && YESORNO) {
		float r, g, b;
		r = color.redComponent;
		g = color.greenComponent;
		b = color.blueComponent;
		colorString = $(@"fg%.0f,%.0f,%.0f; ", r*255, g*255, b*255);
	}
	va_list   argList;	va_start (argList, format);
	NSS*pathStr = $UTF8(filename);
	NSS *path  	= [pathStr lastPathComponent];
	NSS *mess   = [NSS.alloc initWithFormat:format arguments:argList];
	NSS *toLog  = YESORNO ? $(@"[%@]:%i" XCODE_COLORS_ESCAPE  @"%@%@" XCODE_COLORS_RESET @"\n", path, line,colorString, mess)
								 :	$(@"[%@]:%i %@\n", path, line, mess );
	fprintf ( stderr, "%s", toLog.UTF8String);//
	va_end  (argList);
}
#define _AZConditionalLog(fmt...) { _AZColorLog(nil, f, ln, func, fmt,...);	}

	va_list vl; va_start(vl, formatted);	NSS* str = [NSString.alloc initWithFormat:(NSS*)formatted arguments:vl];
	va_end(vl);	YESORNO 	? 	NSLog(@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0; %@" XCODE_COLORS_RESET,  __PRETTY_FUNCTION__, __LINE__, str)
				: 	NSLog(@"%@",str);}

*/

JREnumDeclare(Color,ColorNone,ColorRed,ColorOrange,ColorYellow,ColorGreen,ColorBlue,ColorPurple,ColorGray);
NSG* GradForClr(Color c);
NSC* Clr(Color c);


CACONST * AZConstRelSuper						( CACONSTATTR attrb																	);
CACONST * AZConst									( CACONSTATTR attrb, NSS* rel													   );
CACONST * AZConstScaleOff						( CACONSTATTR attrb, NSS* rel, 							 CGF scl, CGF off );
CACONST * AZConstRelSuperScaleOff 			( CACONSTATTR attrb, 										 CGF scl, CGF off );
CACONST * AZConstAttrRelNameAttrScaleOff 	( CACONSTATTR aOne, NSS* relName, CACONSTATTR aTwo, CGF scl, CGF off );

@interface CALayerNoHit : CALayer
@end
@interface CAShapeLayerNoHit : CAShapeLayer
@end
@interface CATextLayerNoHit : CATextLayer
@end

@interface CALayer (NoHit)
@property (NATOM,ASS) BOOL noHit;
- (void) setNoHit: (BOOL) nohit;
- (BOOL) noHit;
@end

@interface NSObject (AZLayerDelegate)
- (BOOL) boolForKey:	   (NSS*)key defaultValue:(BOOL)defaultValue;
- (BOOL) boolForKey:	   (NSS*)key;
- (void) toggleBoolForKey: (NSS*)key;
- (void) layerWasClicked:  (CAL*)layer;
@end

@interface CALayer (WasClicked)
- (void) wasClicked;
@end

/*		The in my .h/.m pair where I want to define the constant I do the following:

	myfile.h		#import <StringConsts.h>  STR_CONST(MyConst, "Lorem Ipsum");		STR_CONST(MyOtherConst, "Hello world");

	myfile.m		#define SYNTHESIZE_CONSTS		#import "myfile.h"		#undef SYNTHESIZE_CONSTS
*/

@interface AZSingleton : NSObject
+(id) instance;
+(id) sharedInstance;  //alias for instance
+(id) singleton;		  //alias for instance
@end

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
- (void)setValueForKey:(NSString*)key andNotifyInBlock:(updateKVCKeyBlock)block;
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


/**
PUT IN PRECOMP #define NSLog(args...) _AZSimpleLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args);
NS_INLINE  void QuietLog (const char *file, int lineNumber, const char *funcName, NSString *format, ...);
#define NSLog(args...) QuietLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,args)
NS_INLINE void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);
NS_INLINE NSRect SFCopyRect(NSRect toCopy) {	return NSMakeRect(toCopy.origin.x, toCopy.origin.y, toCopy.size.width, toCopy.size.height); }
NS_INLINE NSRect SFMakeRect(NSPoint origin, NSSize size) {	return NSMakeRect(origin.x, origin.y, size.width, size.height); }
NS_INLINE NSPoint SFCopyPoint(NSPoint toCopy) {	return NSMakePoint(toCopy.x, toCopy.y);	}
static inline CGRect convertToCGRect(NSRect rect) {	return *(const CGRect *)&rect;}
static inline NSRect convertToNSRect(CGRect rect) { 	return *(const NSRect *)&rect;	}
static inline NSPoint convertToNSPoint(CGPoint point) {	return *(const NSPoint *)&point;	}
static inline CGPoint convertToCGPoint(NSPoint point) {	return *(const CGPoint *)&point;	}
*/

#define boardPositionToIndex(pos, boardSize) ((pos).x - 1) + (((pos).y - 1) * boardSize)
#define indexToBoardPosition(idx, boardSize) (CGPointMake((x) % boardSize, (int)((x) / boardSize) + 1))

#define RNG AZRange
typedef struct _AZRange {	NSI min;	NSI max;	} AZRange;

RNG		AZMakeRange 	( 	NSI min,  NSI max	 );
NSUI		AZIndexInRange (	NSI fake, RNG rng  );
NSI  	AZNextSpotInRange (	NSI spot, RNG rng  );
NSI  	AZPrevSpotInRange (	NSI spot, RNG rng  );
NSUI		 AZSizeOfRange ( 				 RNG rng  );

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


//void (^now)(void) = ^ {	NSDate *date = [NSDate date]; NSLog(@"The date and time is %@", date); };

NS_INLINE 	NSW* NSWINDOWINIT		(NSR frame, NSUI mask){
	return	[NSW.alloc initWithContentRect:frame styleMask:( mask != NSNotFound ? mask : 1 << 3) backing:2 defer:NO];
}
NS_INLINE	NSW* AZBORDLESSWINDOWINIT	(NSR frame) {
	return 	[NSW.alloc initWithContentRect:frame styleMask:(1|8) backing:2 defer:NO];
}
#define AZWINDOWINIT NSWINDOWINIT(NSZeroRect,1)


NSS* AZStringFromRect(NSRect rect);
NSString* AZStringFromPoint(NSP p);
NSA* ApplicationPathsInDirectory(NSString *searchPath);

void DrawLabelAtCenterPoint (NSS* string, NSPoint center);
void DrawGlossGradient(CGContextRef context, NSC *color, NSR inRect);

CGF perceptualGlossFractionForColor ( CGFloat *inputComponents 		);
CGImageRef 	CreateGradientImage		( int pixelsWide, int pixelsHigh );
NSIMG* 		reflectedView				( NSV* view 							); // Creates an autoreleased reflected image of the contents of the main view


CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh);
CGF percent ( CGFloat val );
CGF DegreesToRadians ( CGFloat degrees );
void NSRectFillWithColor (NSRect rect, NSColor* color);

//CGFloat DEG2RAD(CGFloat degrees);
//{return degrees * M_PI / 180;};
//CGFloat RAD2DEG(CGFloat radians) {return radians * 180 / M_PI;};

NSS* StringFromCATransform3D(CATransform3D transform);
NSS* prettyFloat(CGFloat f);


CGImageRef ApplyQuartzComposition ( const char* compositionName, const CGImageRef srcImage );

//inline float RandomComponent() {  return (float)random() / (float)LONG_MAX; }

//	were static
void glossInterpolation(void *info, const CGFloat *input, CGFloat *output);


/**		MATH!   */

CGF 	randomComponent();
CGF 	frandom ( double start, double end );
NSUI 	AZNormalizedNumberLessThan (id number, NSUInteger max);
NSI 	AZNormalizedNumberGreaterThan (NSI number, NSI min);

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

//based off of http://www.dribin.org/dave/blog/archives/2008/09/22/convert_to_nsstring/
NSString * VTPG_DDToStringFromTypeAndValue(const char * typeCode, void * value);

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
static void PrintUsageAndQuit(void) __attribute__((noreturn));
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
 static NSArray* iconicStrings = @[ @"ampersand.pdf", @"aperture_alt.pdf", @"aperture.pdf", @"arrow_down_alt1.pdf", @"arrow_down_alt2.pdf", @"arrow_down.pdf", @"arrow_left_alt1.pdf", @"arrow_left_alt2.pdf", @"arrow_left.pdf", @"arrow_right_alt1.pdf", @"arrow_right_alt2.pdf", @"arrow_right.pdf", @"arrow_up_alt1.pdf", @"arrow_up_alt2.pdf", @"arrow_up.pdf", @"article.pdf", @"at.pdf", @"award_fill.pdf", @"award_stroke.pdf", @"bars_alt.pdf", @"bars.pdf", @"battery_charging.pdf", @"battery_empty.pdf", @"battery_full.pdf", @"battery_half.pdf", @"beaker_alt.pdf", @"beaker.pdf", @"bolt.pdf", @"book_alt.pdf", @"book_alt2.pdf", @"book.pdf", @"box.pdf", @"brush_alt.pdf", @"brush.pdf", @"calendar_alt_fill.pdf", @"calendar_alt_stroke.pdf", @"calendar.pdf", @"camera.pdf", @"cd.pdf", @"chart_alt.pdf", @"chart.pdf", @"chat_alt_fill.pdf", @"chat_alt_stroke.pdf", @"chat.pdf", @"check_alt.pdf", @"check.pdf", @"clock.pdf", @"cloud_download.pdf", @"cloud_upload.pdf", @"cloud.pdf", @"cog_alt.pdf", @"cog.pdf", @"comment_alt1_fill.pdf", @"comment_alt1_stroke.pdf", @"comment_alt2_fill.pdf", @"comment_alt2_stroke.pdf", @"comment_alt3_fill.pdf", @"comment_alt3_stroke.pdf", @"comment_fill.svg.pdf", @"comment_stroke.svg.pdf", @"compass.svg.pdf", @"cursor.svg.pdf", @"curved_arrow.svg.pdf", @"denied_alt.svg.pdf", @"denied.svg.pdf", @"dial.svg.pdf", @"document_alt_fill.svg.pdf", @"document_alt_stroke.svg.pdf", @"document_fill.svg.pdf", @"document_stroke.svg.pdf", @"download.svg.pdf", @"eject.svg.pdf", @"equalizer.svg.pdf", @"eye.svg.pdf", @"eyedropper.svg.pdf", @"first.svg.pdf", @"folder_fill.svg.pdf", @"folder_stroke.svg.pdf", @"fork.svg.pdf", @"fullscreen_alt.svg.pdf", @"fullscreen_exit_alt.svg.pdf", @"fullscreen_exit.svg.pdf", @"fullscreen.svg.pdf", @"hash.svg.pdf", @"headphones.svg.pdf", @"heart_fill.svg.pdf", @"heart_stroke.svg.pdf", @"home.svg.pdf", @"image.svg.pdf", @"info.svg.pdf", @"iphone.svg.pdf", @"key_fill.svg.pdf", @"key_stroke.svg.pdf", @"last.svg.pdf", @"layers_alt.svg.pdf", @"layers.svg.pdf", @"left_quote_alt.svg.pdf", @"left_quote.svg.pdf", @"lightbulb.svg.pdf", @"link.svg.pdf", @"list.svg.pdf", @"lock_fill.svg.pdf", @"lock_stroke.svg.pdf", @"loop_alt1.svg.pdf", @"loop_alt2.svg.pdf", @"loop_alt3.svg.pdf", @"loop_alt4.svg.pdf", @"loop.svg.pdf", @"magnifying_glass_alt.svg.pdf", @"magnifying_glass.svg.pdf", @"mail_alt.svg.pdf", @"mail.svg.pdf", @"map_pin_alt.svg.pdf", @"map_pin_fill.svg.pdf", @"map_pin_stroke.svg.pdf", @"mic.svg.pdf", @"minus_alt.svg.pdf", @"minus.svg.pdf", @"moon_fill.svg.pdf", @"moon_stroke.svg.pdf", @"move_alt1.svg.pdf", @"move_alt2.svg.pdf", @"move_horizontal_alt1.svg.pdf", @"move_horizontal_alt2.svg.pdf", @"move_horizontal.svg.pdf", @"move_vertical_alt1.svg.pdf", @"move_vertical_alt2.svg.pdf", @"move_vertical.svg.pdf", @"move.svg.pdf", @"movie.svg.pdf", @"new_window.svg.pdf", @"pause.svg.pdf", @"pen_alt_fill.svg.pdf", @"pen_alt_stroke.svg.pdf", @"pen_alt2.svg.pdf", @"pen.svg.pdf", @"pilcrow.svg.pdf", @"pin.svg.pdf", @"play_alt.svg.pdf", @"play.svg.pdf", @"plus_alt.svg.pdf", @"plus.svg.pdf", @"question_mark.svg.pdf", @"rain.svg.pdf", @"read_more.svg.pdf", @"reload_alt.svg.pdf", @"reload.svg.pdf", @"right_quote_alt.svg.pdf", @"right_quote.svg.pdf", @"rss_alt.svg.pdf", @"rss.svg.pdf", @"share.svg.pdf", @"spin_alt.svg.pdf", @"spin.svg.pdf", @"star.svg.pdf", @"steering_wheel.svg.pdf", @"stop.svg.pdf", @"sun_alt_fill.svg.pdf", @"sun_alt_stroke.svg.pdf", @"sun.svg.pdf", @"tag_fill.svg.pdf", @"tag_stroke.svg.pdf", @"target.pdf", @"transfer.pdf", @"trash_fill.pdf", @"trash_stroke.pdf", @"umbrella.pdf", @"undo.pdf", @"unlock_fill.pdf", @"unlock_stroke.pdf", @"upload.pdf", @"user.pdf", @"volume_mute.pdf", @"volume.pdf", @"wrench.pdf", @"x_alt.pdf", @"x.pdf"];	*/

