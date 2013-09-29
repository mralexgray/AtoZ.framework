#import "NSTerminal.h"
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
@property (NATOM,STR)   	 NSW * window;
@property (NATOM,STR) 	BLKVIEW * contentView;
@property (NATOM,STR)    	 NSA * palette;
+ (void) mainMenu;
@end
@interface 		   AZCLIMenuItem : NSObject
//@property (CP)			 VoidBlock   actionBlock;
@property (ASS) 	   		 NSI   index;
@property (STR)   			 NSS * display;
@property (STR)     	 		 NSC * color;
+ (instancetype)    cliMenuItem : (NSS*)display
							     index : (NSI)index
							     color : (NSC*)c;
@end
@interface 				 AZCLIMenu : BaseModel
+ (instancetype)	   addMenuFor : (NSA*) mItems
							  starting : (NSUI) indexB 
						      palette : (NSA*) pallette;
//							     input : (TINP) inptBlk;
+ (NSS*) menu;
+ (void) resetPrinter;
+ (void) hardReset;
+ (NSS*) valueForIndex:(NSI)index;
@end

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
//#import "NSLogConsole.h"
