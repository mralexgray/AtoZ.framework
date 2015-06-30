
//@import WebKit;
#import <WebKit/WebView.h>


@protocol AZLogConsoleDelegate <NSObject>
- (void) textWasEntered:(NSS*)string;
@end

void			NSLogProlog (char* file, int line);
void			NSLogPostLog(char* file, int line);

@interface AZLogConsoleView : WebView 
- (void) logString:(NSString*)string file:(char*)file lineNumber:(int)line;
- (void) clear;
- (void) search:(NSString*)string;
@end
@protocol MTTokenFieldDelegate;
@class MTTokenField;
@interface 	AZLogConsole : NSObject <MTTokenFieldDelegate>
@property (WK) IBO 	MTTokenField 	*tokenField;
@property (WK) IBO 	id 				classTable;
@property (WK)	IBO	id					window;
@property (WK)	IBO	AZLogConsoleView*	webView;
@property (WK)	IBO	id 				searchField;
@property (NA,STR)		NSS				*fakeStdin;
@property (NA,STR)		NSMAS				*terminal;
@property (WK) 		id <AZLogConsoleDelegate> delegate;
@property (STR) 				NSMA				*tokensForCompletion;
@property 				BOOL				autoOpens;
@property 				int				original_stderr;
@property (STR)		NSFileHandle	*fileHandle;

@property (assign)	unsigned long long	fileOffset;
_RO 	NSA 				*classes;
@property (STR)		NSS				*windowTitle, *logPath;
+ (instancetype) sharedConsole __attribute__((const));;
- (void) open ___
- (void) close ___
- (BOOL) isOpen ___
-  (IBA) clear _ x ___
-  (IBA) searchChanged _ x ___
- (void) logData:(NSData*)data 			file:(char*)file lineNumber:(int)line;
- (void) updateLogWithFile:(char*)file lineNumber:(int)line;
@end

@interface NSWindow(Goodies)
- (void) setBottomCornerRounded:(BOOL)a;
@end
