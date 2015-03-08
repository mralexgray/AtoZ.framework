
#import "AZLogConsole.h"

@interface NSArray (AtoZCLI)
- (NSS*) stringValueInColumnsCharWide:(NSUI)characters;
- (NSS*)      formatAsListWithPadding:(NSUI)characters;
@end

@interface NSO (AtoZCLI)
- (NSS*) instanceMethodsInColumns;
@end



/* Adapted from QA1133:http://developer.apple.com/mac/library/qa/qa2001/qa1133.html */

FOUNDATION_EXPORT NSString * AZCurrentUser();
FOUNDATION_EXPORT     NSUI   AZCurrentUserID();

/*
#define	   AZCLISI  AZCLI.sharedInstance
#define    AZFH_IN	NSFileHandle.fileHandleWithStandardInput
#define   AZFH_OUT	NSFileHandle.fileHandleWithStandardOutput
#define AZQUITMENU [NSMI.alloc initWithTitle:[@"Quit " withString:AZPROCNAME] action:NSSelectorFromString(@"terminate:") keyEquivalent:@"q"]


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
*/

//@property MenuAppController * menu;  DefinitionController * dCTL;

//@property (CP)			 VoidBlock   actionBlock;

//							     input : (TINP) inptBlk;
//@property (NATOM,STR)    NSFH * stdinHandle;
//+        (NSIS*) indexesOfMenus ;
//@property (NATOM,RO)   NSRNG	 range;
//@property (NATOM,STR)	     id   identifier;
//@property (NATOM,STR)      id   palette;

//@property (NATOM,STR)	    NSS * windowPosString; 
//+ (void) handleInteractionWithPrompt:(NSS*)string block:(void(^)(NSString *output))block;
//@property (			 ASS) IBO NSTV *terminal;
//@property (		  STR) 	 NSS 	*lastCommand;
//@property (NATOM		 )		 BOOL  finished, inTTY, inXcode;

//void AZCLogFormatWithArguments (const char *format,va_list arguments);
//void AZCLogFormat					 (const char *fmt,...);
//+ (id) blockEval:(id(^)(id blockArgs, ...))block;
//@property (		  RO) 	 NSS	*frameworkMenu, *methodMenu;
//@interface AZCLIMenu : 	BaseModel	@property (STR)   	NSA 	*items;	@prop_RO    NSS 	*outputString;	@property (ASS)  		NSRNG  range;	@end
//@property (		  STR)     NSFH *logConsoleHandle;
//+ (NSFH*) stdinHandle;
//#import "AZLogConsole.h"
