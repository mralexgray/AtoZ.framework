#import "AZCLITests.h"
#import "AtoZ.h"

typedef 	void (^runBlock)();
#define	CurrentIMP 	__CurrentIMP 					(__PRETTY_FUNCTION__,      _cmd)
NS_INLINE 		 IMP 	__CurrentIMP 					(const char *info,     SEL _cmd)	{ // static 	inline

	__block IMP imp = NULL;
  	return    info[0]	!= '-' 		 || 
				 info[0] != '+' ? imp : ^{		NSS *tmp, *clsName;  Class thisCls;
		
		tmp 		= $UTF8(info+2);
		clsName 	= [tmp substringToIndex:[tmp rangeOfString:@" "].location];
		thisCls 	= NSClassFromString ( clsName );
		
		if (thisCls   != nil) {		Method m 	= NULL;
			m 		= info[0] == '+' 	? class_getClassMethod(thisCls, _cmd) 	: class_getInstanceMethod(thisCls, _cmd);
			imp 	= m != NULL 		? method_getImplementation(m) 			: imp;
		}
		return imp;	//	NSLog(@"IMP%@", (__bridge void**)imp);
	}();
}
NS_INLINE 		void 	AZCLogFormatWithArguments 	(const char *fmt,  va_list args)	{	vfprintf(stderr,fmt,args); fflush(stderr); }
NS_INLINE 		void 	AZCLogFormat					(const char *fmt,				 ...) { va_list args; va_start(args,fmt);	AZCLogFormatWithArguments(fmt,args); va_end(args);	}
#define	   AZCLISI 	AZCLI.sharedInstance
#define     AZSTDIN	NSFileHandle.fileHandleWithStandardInput
#define	AZQUITMENU 	[NSMI.alloc initWithTitle:[@"Quit "withString:AZPROCNAME]\
												    action:@selector(terminate:) keyEquivalent:@"q"]
@interface AZCLI : BaseModel <NSLogConsoleDelegate, NSWindowDelegate>

@property (			 ASS) IBO NSTV *terminal;
@property (NATOM,STRNG) 	 NSA	*palette;
@property (		  STRNG) 	 NSS 	*lastCommand;
@property (NATOM,STRNG) 	 NSMD	*selectionDecoder;
@property (NATOM		 )		 BOOL  finished, inTTY, inXcode;
								-  (void) mainMenu;
@end

//void AZCLogFormatWithArguments (const char *format,va_list arguments);
//void AZCLogFormat					 (const char *fmt,...);
//+ (id) blockEval:(id(^)(id blockArgs, ...))block;
//@property (		  RONLY) 	 NSS	*frameworkMenu, *methodMenu;
//@interface AZCLIMenu : 	BaseModel	@property (STRNG)   	NSA 	*items;	@property (RONLY)    NSS 	*outputString;	@property (ASS)  		NSRNG  range;	@end
//@property (		  STRNG)     NSFH *logConsoleHandle;
//+ (NSFH*) stdinHandle;
//#import "NSLogConsole.h"
