//
//  NSLogConsole.h
//  NSLogConsole
//
//  Created by Patrick Geiller on 16/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@protocol NSLogConsoleDelegate <NSObject>
- (void) textWasEntered:(NSS*)string;

@end

void			NSLogProlog (char* file, int line);
void			NSLogPostLog(char* file, int line);
@class		NSLogConsoleView;

@interface 	NSLogConsole : NSObject <MTTokenFieldDelegate>
@property (strong, nonatomic) NSMutableAttributedString *terminal;
@property (assign) id <NSLogConsoleDelegate> delegate;
@property (retain) 				NSMA* 			tokensForCompletion;
@property (assign) IBOutlet 	MTTokenField *tokenField;
@property (assign) IBOutlet id classTable;
@property (assign) BOOL		autoOpens;

@property (unsafe_unretained)	IBOutlet	id	window;
@property (weak)	IBOutlet	NSLogConsoleView*	webView;
@property (unsafe_unretained)	IBOutlet	id searchField;
	
@property (assign)	int			original_stderr;
@property (strong)	NSString*	logPath;
@property (strong)	NSFileHandle*	fileHandle;
@property (strong,nonatomic)	NSString	*fakeStdin;

@property (assign)	unsigned long long	fileOffset;

@property (RONLY) NSA *classes;

	// Window title
@property (strong)	NSString*	windowTitle;
+       (id) sharedConsole;
-     (void) open;
-     (void) close;
-     (BOOL) isOpen;
- (IBAction) clear:			(id)sender;
- (IBAction) searchChanged:(id)sender;
-     (void) logData:		(NSData*)data 			file:(char*)file lineNumber:(int)line;
-     (void) updateLogWithFile:(char*)file lineNumber:(int)line;
@end
@interface NSWindow(Goodies)
- (void) setBottomCornerRounded:(BOOL)a;
@end
@interface NSLogConsoleView : WebView {
// A message might trigger console opening, BUT the WebView will take time to load and won't be able to display messages yet.
// Queue them - they will be unqueued when WebView has loaded.
	id		messageQueue;
	BOOL	webViewLoaded;
}
- (void) logString:(NSString*)string file:(char*)file lineNumber:(int)line;
- (void) clear;
- (void) search:(NSString*)string;

@end

