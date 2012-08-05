//
//  NSLogConsole.h
//  NSLogConsole
//
//  Created by Patrick Geiller on 16/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>



//[NSLogConsole sharedConsole];
//	[[NSLogConsole sharedConsole] open];

// Uncomment to test error messages coming from foreign code
//	[[NSView alloc] retain];

// Log some errors
//	[[NSView alloc] retain];
//	CGBitmapContextCreate(nil, 400, 400, 3, 324, nil, kCGBitmapByteOrder32Big);

/*
 - (IBAction)toggleConsole:(id)sender  {
 BOOL isOpen = [[NSLogConsole sharedConsole] isOpen];
 NSLog(@"Toggle console %d", isOpen);
 if (!isOpen)	[[NSLogConsole sharedConsole] open];
 else			[[NSLogConsole sharedConsole] close];
 } */

void	NSLogProlog(char* file, int line);
void	NSLogPostLog(char* file, int line);

@class	NSLogConsoleView;

@interface NSLogConsole : NSObject {


	// Window title
	NSString*	windowTitle;
}

@property (assign) 	IBOutlet	 id	window;


@property (assign) BOOL		autoOpens;

@property IBOutlet	NSLogConsoleView*	webView;
@property IBOutlet	id searchField;
@property  IBOutlet	id po;

@property int			original_stderr;
@property (strong) NSString*	logPath;
@property NSFileHandle*	fileHandle;

@property NSUInteger fileOffset;


+ (id)sharedConsole;

- (void)open;
- (void)close;
- (BOOL)isOpen;
- (IBAction)clear:(id)sender;

- (IBAction)searchChanged:(id)sender;
- (IBAction)poChanged:(id)sender;
- (id)window;

- (void)logData:(NSData*)data file:(char*)file lineNumber:(int)line;
- (void)updateLogWithFile:(char*)file lineNumber:(int)line;
@property (copy) NSString* windowTitle;
@property (retain, nonatomic) NSMutableArray *messageQueue;
@end


@interface NSWindow(Goodies)
- (void)setBottomCornerRounded:(BOOL)a;
@end



@interface NSLogConsoleView : WebView {

	// A message might trigger console opening, BUT the WebView will take time to load and won't be able to display messages yet.
	// Queue them - they will be unqueued when WebView has loaded.
	BOOL	webViewLoaded;
}
@property (strong, nonatomic)	id		messageQueue;
- (void)logString:(NSString*)string file:(char*)file lineNumber:(int)line;
- (void)clear;
- (void)search:(NSString*)string;

@end

