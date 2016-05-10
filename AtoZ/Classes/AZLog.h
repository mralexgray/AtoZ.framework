


@interface NSO (AtoZObjectLog)
- (void) log;
@end

#define XXX(x) [AtoZLumberLog logObject:x file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__]

//@interface DDTTYLogger (AtoZ)
//+ (BOOL) isaColorTTY;
//+ (BOOL) isaColor256TTY;
//+ (BOOL) isaXcodeColorTTY;
//@end



_EnumKind( LogEnv, LogEnvUnset        = 0,
                       LogEnvXcode        = 0x00000001,
                       LogEnvXcodeColors  = 0x00000011, 
                       LogEnvTTY          = 0x00000100,
                       LogEnvTTYColor     = 0x00001100,
                       LogEnvTTY256       = 0x00011100,
                       LogEnvASL          = 0x10000000,
                       LogEnvUnknown      = 0x01010101,
                       LogEnvError        = 0x11111111 )


#define 	AZLOGSHARED 	[AZLog sharedInstance]
#define           clr   colorLogString


@interface  NSLogMessage : NSObject

_RO		  id   JSONRepresentation;
_RO NSDate * date;
_RO   NSS * message, *severityString, * function, * file;
_RO NSData * data;
@property				     NSN * line, * severity;

+ (instancetype) messageWithLog:(id)data file:(char*)file func:(char*)func line:(int)line sev:(NSUInteger)sev;
@end

@interface 					   AZLog : BaseModel

_RO			LogEnv   logEnv;
+ (NSS*) log;

/*** Get a color from a string, a color, or an rgb tuple.
	@param color An NSString name of, or hex representation of a color, an NSColor, or and NSArray of RGB values.
	@return An sarray of r, g, b NSNumber floats representing the color ie. 0 - 255  (not 0-1);
*/
+ (NSA*) 		rgbColorValues	: (id)color;

+ (NSS*) 		colorizeString	: (NSS*)str
									withColor : (id)color;

+ (NSS*) 	   colorizeString : (NSS*)str
							        front : (id)front
						           back : (id)back;

- (void) logMessage:(NSLogMessage*)msg;

/*** @param colorsAndThings (VA_LIST) colors + objects, in any order, TRMINATED BY NIL
		 @return  wiull use those colors to log those objects! */
//- (NSA*) COLORIZE:(id) colorsAndThings, ...  {

+ (NSA*) 	colorizeAndReturn : (id)  colorsAndThings, ... NS_REQUIRES_NIL_TERMINATION;
- (void)         logInColor : (id)					  color
											 file : (const char*)filename
								       line : (int)					   line
											 func : (const char*)funcName
				             format : (id)					 format, ... NS_REQUIRES_NIL_TERMINATION;
- (void) 			     logThese : (const char*)  pretty    /* Pass a variadic list of Colors, and Objects, in any order! */
							       things : (id)  colorsAndThings,...	NS_REQUIRES_NIL_TERMINATION;
@end

@interface		     NSString  (AtoZColorLog)
_RO const char * cchar;
_RO 	     NSS * colorLogString;  // TTY formatted NSString with Associated Color Info included
- (void)    setLogBackground : (id)color;
- (void)    setLogForeground : (id)color;
@end

NSD* 	AZEnv										(char** envp);
void 	AZLogEnv								(char** envp);
  id 	LogStackAndReturn				(id toLog);		// USAGE: .... return (NSA*)logAndReturn( [NSArray arrayWithArrays:@[blah,blahb]] );
  id 	LogAndReturn						(id toLog); 	// = ^(id toLog) { AZLOG(toLog); return toLog; };
  id 	LogAndReturnWithCaller 	(id toLog, SEL caller);
void 	QuietLog								(NSS *format,...);



//[DDLog log:YES level:1 flag:0 context:0 file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ tag:0 format:fmt args:__VA_ARGS__]
//#define	       NSLog(fmt...)  [AZLOGSHARED logInColor:nil file:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ format:fmt,nil]

#define	       AZLOG(x) 			NSLog(@"%@", x)
#define     COLORIZE(x...)    [AZLog colorizeAndReturn:x]
#define  _AZColorLog(x)       [AZLOGSHARED logInColor:RANDOMCOLOR file:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ format:x];
#define      LOGWARN(fmt...) 	[AZLOGSHARED logInColor:RANDOMCOLOR file:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ format:fmt, nil];
#define    LOGCOLORS(X...)    [AZLOGSHARED logThese:__PRETTY_FUNCTION__ things:X]
#define	    COLORLOG(fmt...)	[AZLOGSHARED logThese:__PRETTY_FUNCTION__ things:fmt, nil]

//		IS_OBJECT(_X_) ? $(@"\n\nAttempting a \"blockDescription\":%@",[_X_ blockDescription]) : @"");	} while(0)
//	strcmp(_TYPE_CODE_,"@?") ? $(@"\n\nAttempting a \"blockDescription\":%@",[(id)(_X_) blockDescription]) : @"");	} while(0)

#pragma mark - STACKTRACE
// STACK MACRO: "UIKit 0x00540c89 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1163"
#define STACKARRAY [[NSThread.callStackSymbols[1] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"]]arrayByRemovingObject:@""]
#define STACKSTACK		STACKARRAY[0]
#define STACKFRAMEWORK 	STACKARRAY[1]
#define STACKADDRESS 	STACKARRAY[2]
#define STACKCLASS 		STACKARRAY[3]
#define STACKFUNCTION 	STACKARRAY[4]
#define STACKLINE	 		STACKARRAY[5]

#ifndef XCODE_COLORS_DEFS
#define XCODE_COLORS_DEFS
#pragma mark - COLOR LOGGING
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
#define 	CHAR_ESCAPE  "\033["
#define   CHAR_RESET  CHAR_ESCAPE ";"
#endif
#define 	XCODE_COLORS_RESET_FG  	XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define 	XCODE_COLORS_RESET_BG  	XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define 	XCODE_COLORS_RESET	 		XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define 	COLOR_RESET 					XCODE_COLORS_RESET
#define 	COLOR_ESC 					XCODE_COLORS_ESCAPE

#endif

#define AZLOGIN 	LOGCOLORS($UTF8(__PRETTY_FUNCTION__), @" started running!", nil)
#define AZLOGOUT  LOGCOLORS($UTF8(__PRETTY_FUNCTION__), @" finished running!", nil)
#define AZRETURNLOG  return AZLOGOUT
#define AZLOGANDRETURN(x)  return AZLOGOUT, x


CLANG_IGNORE(-Wunused-variable)
static NSString *dLog = nil;
CLANG_POP


@interface AZASLEntry : NSObject

@property (nonatomic) NSDate *timestamp;
@property (nonatomic) NSString *host, *sender, *facility, *message, *messageId, *session;
@property (nonatomic) int pid, uid, gid, level;

@end

@interface          AZASLLogger : NSObject <NSOutlineViewDataSource,NSOutlineViewDelegate>

@property (NA)           NSW * show;        // NSOutlineView in a window.
@property _Dict entry;
//NSTreeController      // Watch ASL logg without blocking!  Via "watchlog"
//- (void)                  watch ;

@end         // Starts it.





#define __VSTR(x) (__bridge const void*)x
#define LOG_CALLER_VERBOSE NO		// Rediculous logging of calling method
#define LOG_CALLER_INFO	YES		// Slighlty less annoying logging of calling method

//#ifndef NDEBUG
//extern void _NSSetLogCStringFunction(void (*)(const char *string, unsigned length, BOOL withSyslogBanner));
//static void PrintNSLogMessage(const char *string, unsigned length, BOOL withSyslogBanner) {	puts(string);	}
//static void HackNSLog(void) __attribute__((constructor));
//static void HackNSLog(void) {	_NSSetLogCStringFunction(PrintNSLogMessage);	}
//#endif
//#ifdef DEBUG#ifdef LGLVL#undef LGLVL#endif
#define LGLVL 7
//#else#define LGLVL 0#endif

#define DEBUGBUFFER(fmt...) 	^{ id x = (dLog && dLog.length) ? dLog : @""; dLog = [[x stringByAppendingString:[NSS stringWithFormat:fmt arguments:__VA_ARGS__]] stringByAppendingString:@" ... "]; }()

#define DEBUGLOG(fmt...) [AZSHAREDLOG logMessage:[NSLogMessage messageWithLog: \
			[NSS stringWithFormat:fmt arguments:__VA_ARGS__]  \
			file:__FILE__                                     \
			func:__PRETTY_FUNCTION__                          \
			line:__LINE__                                     \
			sev:3]]

//											{ NSString *toLog = @""; \
//													if (dLog != nil) toLog = [dLog copy]; if (toLog.length) dLog = nil; \
//												 printf("%s\n",[[toLog stringByAppendingFormat:__VA_ARGS__] UTF8String]); } return (id)nil;  }()


/*
#define	NSLog(fmt...) [AZLog_AZColorLog(nil,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
#define 	XCODE_COLORS 0
#define LOGWARN(fmt...) _AZColorLog(nil,__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
void _AZSimpleLog				( 				  const char *file, int line, const char *funcName, NSS *format, ... );
extern void _AZColorLog			( id color, const char *file, int line, const char *funcName, NSS *format, ... );
NSA *	COLORIZE						( id colorsAndThings, ... ); 
#define LOGCOLORS(X...) logNilTerminatedListOfColorsAndStrings(__PRETTY_FUNCTION__,X)
void 	logNilTerminatedListOfColorsAndStrings ( const char*pretty, id colorsAndThings,...)NS_REQUIRES_NIL_TERMINATION;

	NSColor, "name" (CSS, or named color) or @[@4, @44, @244] rgbIntegers
NSS * colorizeStringWithColor	( NSS* string, id color );
 same as colorizeStringWithColor but does the back, too.  same formatting.
NSS * colorizeStringWithColors	( NSS* string, id color, id back );
  pass in color, or hex string, get an array of r, g, b integers... [ 0 - 255 ] (i think)
NSA * rgbColorValues 				( id color );
#define	LogProps(a)      NSLog(@"%@", a.propertiesPlease)
#define	logprop (a)      NSLog(@"%@", [a propertiesPlease])
#define	desc    (a)      NSLog(@"%@", [a description])
#define logobj (a) id logit = a \		 NSLog(@"%@", a)
#define	vLOG(A)	[((AppDelegate*)[NSApp sharedApplication].delegate).textOutField appendToStdOutView:A] 
#define COLORLOG(fmt...) _AZColorLog(__FILE__,__LINE__,__PRETTY_FUNCTION__,fmt)
*/
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
 - (void) finalize			\
 {					\
 MEMDEBUG(@"%p", self);		\
 [super finalize];		\
 }
 #endif
 */




//((void)printf("%s %s\n",__PRETTY_FUNCTION__,[[NSString.alloc initWithFormat:fmt]UTF8String]))
//// __FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ format:fmt, nil]
//[AtoZLumberLog logFile:__FILE__ line:__LINE__ func:__PRETTY_FUNCTION__ format:fmt, nil]

//#ifndef AtoZFramework
//#define AtoZFramework
//#endif
