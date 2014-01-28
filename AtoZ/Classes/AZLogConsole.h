
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
@interface 	AZLogConsole : NSObject <MTTokenFieldDelegate>
@property (WK) IBO 	MTTokenField 	*tokenField;
@property (WK) IBO 	id 				classTable;
@property (WK)	IBO	id					window;
@property (WK)	IBO	AZLogConsoleView*	webView;
@property (WK)	IBO	id 				searchField;
@property (NATOM,STRNG)		NSS				*fakeStdin;
@property (NATOM,STRNG)		NSMAS				*terminal;
@property (WK) 		id <AZLogConsoleDelegate> delegate;
@property (STRNG) 				NSMA				*tokensForCompletion;
@property 				BOOL				autoOpens;
@property 				int				original_stderr;
@property (STRNG)		NSFileHandle	*fileHandle;

@property (assign)	unsigned long long	fileOffset;
@property (RONLY) 	NSA 				*classes;
@property (STRNG)		NSS				*windowTitle, *logPath;
+ (instancetype) sharedConsole;
- (void) open;
- (void) close;
- (BOOL) isOpen;
-  (IBA) clear:			(id)sender;
-  (IBA) searchChanged:(id)sender;
- (void) logData:		(NSData*)data 			file:(char*)file lineNumber:(int)line;
- (void) updateLogWithFile:(char*)file lineNumber:(int)line;
@end

@interface NSWindow(Goodies)
- (void) setBottomCornerRounded:(BOOL)a;
@end
