//
//  AZLog.h
//  AtoZ
//
//  Created by Alex Gray on 5/2/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZUmbrella.h"
#import "BaseModel.h"
#import "BaseModel+AtoZ.h"

#pragma mark - COLOR LOGGING
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

/*	Foreground color: 	Insert the ESCAPE_SEQ into your string, followed by "fg124,12,255;" where r=124, g=12, b=255.
 	Background color:	 	Insert the ESCAPE_SEQ into your string, followed by "bg12,24,36;" where r=12, g=24, b=36.
 	Reset the foreground color (to default value):	Insert the ESCAPE_SEQ into your string, followed by "fg;"
	Reset the background color (to default value):	Insert the ESCAPE_SEQ into your string, followed by "bg;"
	Reset the fground and bground color (to default values) in 1 operation: Insert the ESCAPE_SEQ into your string, followed by ";"
*/
#if TARGET_OS_IPHONE
#define 	XCODE_COLORS_ESCAPE  @"\xC2\xA0["
#else
#define 	XCODE_COLORS_ESCAPE  @"\033["
#endif
#define 	XCODE_COLORS_RESET_FG  	XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define 	XCODE_COLORS_RESET_BG  	XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define 	XCODE_COLORS_RESET	 		XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define 	COLOR_RESET 					XCODE_COLORS_RESET
#define 	COLOR_ESC 					XCODE_COLORS_ESCAPE
#define 	XCODE_COLORS 0

#define 	AZLOGSHARED AZLog.sharedInstance
#define	AZLOG(x) NSLog(@"%@", x)
#define	NSLog(fmt...) [AZLOGSHARED logInColor:RANDOMCOLOR file:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ format:fmt]
//#define	NSLog(fmt...) [AZLog_AZColorLog(nil,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)

@interface AZLog : BaseModel


- (NSA*) rgbColorValues:(id)color;
- (NSS*) colorizeString:(NSS*)string withColor:(id)color;
- (NSS*) colorizeString:(NSS*)string front:(id)front back:(id)back;
#define COLORIZE(x...) [AZLOGSHARED colorizeAndReturn:x]
- (NSA*) colorizeAndReturn:(id) colorsAndThings, ...;

#define _AZColorLog(x) [AZLOGSHARED logInColor:RANDOMCOLOR file:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ format:x];
#define LOGWARN(fmt...) [AZLOGSHARED logInColor:RANDOMCOLOR file:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ format:fmt];
//#define LOGWARN(fmt...) _AZColorLog(nil,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
- (void) logInColor:(id)color file:(const char*)filename line:(int)line func:( const char *)funcName format:(id) format, ...; 



/* Pass a variadic list of Colors, and Ovjects, in any order, TRMINATED BY NIL, abd it wiull use those colors to log those objects! */
#define LOGCOLORS(X...) [AZLOGSHARED logNilTerminatedListOfColorsAndStrings:__PRETTY_FUNCTION__ things:X]
#define COLORLOG(fmt...) [AZLOGSHARED logNilTerminatedListOfColorsAndStrings:__PRETTY_FUNCTION__ things:fmt]
-(void) logNilTerminatedListOfColorsAndStrings:(const char*)pretty things:(id) colorsAndThings,... ;
@end

//void _AZSimpleLog				( 				  const char *file, int line, const char *funcName, NSS *format, ... );
//extern void _AZColorLog			( id color, const char *file, int line, const char *funcName, NSS *format, ... );
//NSA *	COLORIZE						( id colorsAndThings, ... ); 

//#define LOGCOLORS(X...) logNilTerminatedListOfColorsAndStrings(__PRETTY_FUNCTION__,X)
//void 	logNilTerminatedListOfColorsAndStrings ( const char*pretty, id colorsAndThings,...)NS_REQUIRES_NIL_TERMINATION;
/*	NSColor, "name" (CSS, or named color) or @[@4, @44, @244] rgbIntegers 		*/
//NSS * colorizeStringWithColor	( NSS* string, id color );
/* same as colorizeStringWithColor but does the back, too.  same formatting. 	*/
//NSS * colorizeStringWithColors	( NSS* string, id color, id back );
/*  pass in color, or hex string, get an array of r, g, b integers... [ 0 - 255 ] (i think) */
//NSA * rgbColorValues 				( id color );
//
#define	AZLOG(x) NSLog(@"%@", x)
//#define	LogProps(a)      NSLog(@"%@", a.propertiesPlease)
//#define	logprop (a)      NSLog(@"%@", [a propertiesPlease])
//#define	desc    (a)      NSLog(@"%@", [a description])
//#define logobj (a) id logit = a \		 NSLog(@"%@", a)


//#define	vLOG(A)	[((AppDelegate*)[NSApp sharedApplication].delegate).textOutField appendToStdOutView:A] 


//#define COLORLOG(fmt...) _AZColorLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
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
 


