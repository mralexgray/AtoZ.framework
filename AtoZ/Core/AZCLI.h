
#import "AtoZUmbrella.h"
#import "AZLogConsole.h"

/* Adapted from QA1133:http://developer.apple.com/mac/library/qa/qa2001/qa1133.html */

FOUNDATION_EXPORT NSString * AZCurrentUser();
FOUNDATION_EXPORT     NSUI   AZCurrentUserID();

#define	    AZCLISI AZCLI.sharedInstance
#define     AZSTDIN	NSFileHandle.fileHandleWithStandardInput
#define    AZSTDOUT	NSFileHandle.fileHandleWithStandardOutput
#define  AZQUITMENU [NSMI.alloc initWithTitle:[@"Quit " withString:AZPROCNAME] action:NSSelectorFromString(@"terminate:") keyEquivalent:@"q"]


@interface AZCLI : NSO <AZLogConsoleDelegate,NSWIND,NSAPPD>

@property (NATOM)   	 NSW * window;
@property (NATOM) 	BLKVIEW * contentView;
+ (void) mainMenu;
@end

@interface 		   AZCLIMenuItem : AZObject

@property   		 NSI   index;
@property 			 NSS * display;
@property  	 		 NSC * color;
+ (INST) cliMenuItem : (NSS*)x
				 	     index : (NSI)idx
					     color : (NSC*)c;
@end
@interface 				 AZCLIMenu : BaseModel
+ (INST)  addMenuFor : (NSA*)mItems
				    starting : (NSUI)idxB 
					   palette : (NSA*)pal;
+ (NSS*) menu;
+ (void) resetPrinter;
+ (void) hardReset;
+ (NSS*) valueForIndex:(NSI)index;
@end
//@property MenuAppController * menu;  DefinitionController * dCTL;	
//@property (CP)			 VoidBlock   actionBlock;

//							     input : (TINP) inptBlk;
//@property (NATOM,STR)    NSFH * stdinHandle;
//+        (NSIS*) indexesOfMenus ;
//@property (NATOM,RONLY)   NSRNG	 range;
//@property (NATOM,STRNG)	     id   identifier;
//@property (NATOM,STRNG)      id   palette;

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
//#import "AZLogConsole.h"
