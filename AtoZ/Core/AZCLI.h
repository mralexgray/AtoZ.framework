#import "NSTerminal.h"
#import "AZCLITests.h"
#import "AtoZUmbrella.h"
#import "AtoZ.h"


#define	   AZCLISI 	AZCLI.sharedInstance
#define     AZSTDIN	NSFileHandle.fileHandleWithStandardInput
#define	AZQUITMENU 	[NSMI.alloc initWithTitle:[@"Quit " withString:AZPROCNAME] action:NSSelectorFromString(@"terminate:") keyEquivalent:@"q"]

@interface 					  AZCLI : NSObject   <NSLogConsoleDelegate,NSWindowDelegate,NSApplicationDelegate>	 
{
		        MenuAppController * menu; 
		     DefinitionController * dCTL;	
}
@property (NATOM,STRNG)     NSW * window;  
@property (NATOM,STRNG) BLKVIEW * contentView;
@property (NATOM,STRNG)    NSFH * stdinHandle;
@property (NATOM,STRNG)     NSA * palette;
@property (NATOM,   WK)	     id   mainMenu;
@end


typedef NSString*(^termDidReadString)(NSString*, const char*);
#define TINP termDidReadString

@interface 				 AZCLIMenu : BaseModel

@property (      RONLY)		 NSS * menu;
@property (NATOM,STRNG)	   TINP   block;
@property (NATOM,RONLY)   NSRNG	 range;
@property (NATOM,STRNG)	     id   identifier;
@property (NATOM,STRNG)      id   palette;
@property (NATOM,  ASS)     NSI   startIdx;

+        (NSIS*) indexesOfMenus ;
+ (instancetype) 	   cliMenuFor : (NSA*) mItems 
							  starting : (NSUI) indexB 
						      palette : (id) pallette
							     input : (TINP)inptBlk;
@end

//@property (NATOM,STRNG)	    NSS * windowPosString; 
//+ (void) handleInteractionWithPrompt:(NSS*)string block:(void(^)(NSString *output))block;
//@property (			 ASS) IBO NSTV *terminal;
//@property (		  STRNG) 	 NSS 	*lastCommand;
//@property (NATOM		 )		 BOOL  finished, inTTY, inXcode;

//void AZCLogFormatWithArguments (const char *format,va_list arguments);
//void AZCLogFormat					 (const char *fmt,...);
//+ (id) blockEval:(id(^)(id blockArgs, ...))block;
//@property (		  RONLY) 	 NSS	*frameworkMenu, *methodMenu;
//@interface AZCLIMenu : 	BaseModel	@property (STRNG)   	NSA 	*items;	@property (RONLY)    NSS 	*outputString;	@property (ASS)  		NSRNG  range;	@end
//@property (		  STRNG)     NSFH *logConsoleHandle;
//+ (NSFH*) stdinHandle;
//#import "NSLogConsole.h"
