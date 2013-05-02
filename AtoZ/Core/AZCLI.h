

#define AZSTDIN NSFileHandle.fileHandleWithStandardInput
void AZCLogFormatWithArguments (const char *format,va_list arguments);
void AZCLogFormat					 (const char *fmt,...);

@protocol NSLogConsoleDelegate;
@class StickyNote;
@interface AZCLI : BaseModel <NSLogConsoleDelegate>

@property (			 ASS) IBO NSTV *terminal;
//@property (		  STRNG)     NSFH *logConsoleHandle;
@property (NATOM,STRNG) 	 NSA	*palette;
@property (		  STRNG) 	 NSS 	*lastCommand;
@property (		  RONLY) 	 NSS	*frameworkMenu, *methodMenu;
@property (NATOM,STRNG) 	 NSMD	*selectionDecoder;
@property (NATOM		 )		 BOOL  finished, inTTY, inXcode;

//+ (NSFH*) stdinHandle;
-  (void) mainMenu;

@end

//+ (id) blockEval:(id(^)(id blockArgs, ...))block;

//@interface AZCLIMenu : 	BaseModel	@property (STRNG)   	NSA 	*items;	@property (RONLY)    NSS 	*outputString;	@property (ASS)  		NSRNG  range;	@end
