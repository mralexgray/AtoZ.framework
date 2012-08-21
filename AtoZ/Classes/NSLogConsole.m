//
//  NSLogConsole.m
//  NSLogConsole
//
//  Created by Patrick Geiller on 16/08/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "NSLogConsole.h"
#import <ScriptingBridge/ScriptingBridge.h>
#import "AtoZ.h"

BOOL inited = NO;


void	NSLogPostLog(char* file, int line)
{
	if (!inited)	return;
	[[NSLogConsole sharedConsole] updateLogWithFile:file lineNumber:line];
}



@implementation NSLogConsole

@synthesize autoOpens, windowTitle, messageQueue, window = _window, original_stderr  = _original_stderr;


+ (id)sharedConsole
{
	return [NSLogConsole sharedInstance];
//	static id singleton = NULL;
//	@synchronized(self)
//	{
//		if (!singleton)
//		{
//			singleton = [[self class] new];// alloc];
////			[singleton init];
//		}
//	}
//	return singleton;
}

//
// Init : should only be called once by sharedConsole
//
- (id)init
{

	/* Initialize webInspector. */
	[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
	[[NSUserDefaults standardUserDefaults] synchronize];


	id o		= [super init];
	autoOpens	= YES;
	_logPath		= NULL;
	inited		= YES;

	// Save stderr
	self.original_stderr = dup(STDERR_FILENO);

//	self.logPath = [NSString stringWithFormat:@"%@%@.log.txt", NSTemporaryDirectory(), [[NSBundle bundleForClass:[self class]bundleIdentifier]]];
	NSLog(@"path: %@", _logPath);
//	[logPath retain];

	// Create the file — NSFileHandle doesn't do it !
	[@"" writeToFile:_logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:_logPath];
	if (!_fileHandle)	NSLog(@"Opening log at %@ failed", _logPath);

//	[fileHandle retain];
	id fd = [NSFileHandle fileHandleWithStandardError];// fileDescriptor];
//
	// Redirect stderr
//	int err = dup2( [NSFi ]fd, STDERR_FILENO);
//	if (!err)	NSLog(@"Couldn't redirect stderr");

	_fileOffset = 0;

//	[NSFileHandle readInBackgroundAndNotify];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleReadCompletionNotification object: _fileHandle];
	return	o;
}

// NSLog will generate an event posted in the next run loop run
- (void)dataAvailable:(NSNotification *)aNotification
{
//	NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
	[[NSLogConsole sharedConsole] updateLogWithFile:"" lineNumber:0];
}


- (void)open
{
	if (!_window)
	{
		if (![NSBundle loadNibNamed:@"NSLogConsole" owner:self])
		{
			NSLog(@"NSLogConsole.nib not loaded");
			return;
		}
		if ([_window respondsToSelector:@selector(setBottomCornerRounded:)])
			[_window setBottomCornerRounded:NO];
		if ([_window respondsToSelector:@selector(setLevel:)])
			[_window setLevel:NSScreenSaverWindowLevel];
	}
//	NSRunningApplication *activeAppDict =//[[NSWorkspace sharedWorkspace] cur];
	NSString *activeApplicationPath =  [[NSRunningApplication currentApplication] valueForKey:@"localizedName"];
	//activeApplicationPath [activeAppDict valueForKey:@"NSApplicationPath"];
//	NSImage *activeAppImage = [[NSWorkspace sharedWorkspace] iconForFile:activeApplicationPath];

//	if (windowTitle)
	[_window setTitle:activeApplicationPath];//[[NSApplication sharedApplication] stringFromClass]];// windowTitle];
	[_window orderFront:self];
}
- (void)close
{
	[_window orderOut:self];
}
- (BOOL)isOpen
{
	return	[_window isVisible];
}

- (IBAction)clear:(id)sender
{
	[self.webView clear];
}
- (IBAction)searchChanged:(id)sender
{
	[self.webView search:[sender stringValue]];
}
- (IBAction)poChanged:(id)sender
{
	NSLog(@"%@",[sender stringValue]);
}

//
// Read log data from handle
//
- (void)updateLogWithFile:(char*)file lineNumber:(int)line
{
	// Open a new handle to read new data
	id f = [NSFileHandle fileHandleForReadingAtPath:self.logPath];
	if (!f)	NSLog(@"Opening log at %@ failed", self.logPath);

	// Get file length
	[f seekToEndOfFile];
	unsigned long long length = [f offsetInFile];
	if (length == 0)	return;

	// Open console if it's hidden
	if (![_window isVisible] && autoOpens)	[self open];

	// Read data
	[f seekToFileOffset:self.fileOffset];
	NSData* data = [f readDataToEndOfFile];
	[self logData:data file:file lineNumber:line];
	
	// We'll read from that offset next time
	self.fileOffset = length;
}

//
// Log data to webview and original stderr 
//
- (void)logData:(NSData*)data file:(char*)file lineNumber:(int)line
{
	if (![_window isVisible] && autoOpens)	[self open];

	id str = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
//	[[NSAlert alertWithMessageText:@"hello" defaultButton:@"Furthe" alternateButton:nil otherButton:nil informativeTextWithFormat:str] runModal];
	// Write back to original stderr
	write(_original_stderr, [data bytes], [data length]);
	// Clear search
//	[searchField setStringValue:@""];
	[_webView search:@""];
	// Log string
	[_webView logString:str file:file lineNumber:line];

//	[str release];
}



@end











@implementation NSLogConsoleView

//
//- (void)dealloc
//{
//	[messageQueue release];
//	[super dealloc];
//}
//
- (BOOL)drawsBackground
{
	return	NO;
}

- (void)awakeFromNib
{
	_messageQueue	= [NSMutableArray array];
	webViewLoaded	= NO;

	// Frame load
	[self setFrameLoadDelegate:self];


	NSBundle *aBundle = [NSBundle bundleForClass: [AtoZ class]];
	id path = [aBundle pathForResource:@"NSLogConsole" ofType:@"html"];

	// Load html page

//	id path = [[NSBundle mainBundle] pathForResource:@"NSLogConsole" ofType:@"html"];
	[[self mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];

	// Navigation notification
	[self setPolicyDelegate:self];
}

//
//	Javascript is available
//		Register our custom javascript object in the hosted page
//
- (void)webView:(WebView *)view windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject
{
	[windowScriptObject setValue:self forKey:@"NSLogConsoleView"];
}

//
// WebView has finished loading
//
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	webViewLoaded	= YES;

	// Flush message queue
	for (id o in _messageQueue)
		[self logString:[o valueForKey:@"string"] file:(char*)[[o valueForKey:@"file"] UTF8String] lineNumber:[[o valueForKey:@"line"] intValue]];
//	[messageQueue release];
}

//
// Notify WebView of new message
//
- (void)logString:(NSString*)string file:(char*)file lineNumber:(int)line
{
	// Queue message if WebView has not finished loading
	if (!webViewLoaded)
	{
		id o = @{@"string": [NSString stringWithString:string],
															@"file": @(file),
															@"line": @(line)};
		[_messageQueue addObject:o];
		return;
	}
	[[self windowScriptObject] callWebScriptMethod:@"log" withArguments:@[string, 
																			@(file), 
																			@(line)]];
}

//
// Open source file in XCode at correct line number
//
- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation
                                                           request:(NSURLRequest *)request
                                                             frame:(WebFrame *)frame
                                                  decisionListener:(id<WebPolicyDecisionListener>)listener
{
	// Get path, formed by AbsolutePathOnDisk(space)LineNumber
	NSString* pathAndLineNumber = [[request URL] path];
	
	// From end of string, skip to space before number
	char* s = (char*)[pathAndLineNumber UTF8String];
	char* s2 = s+strlen(s)-1;
	while (*s2 && *s2 != ' ' && s2 > s) s2--;
	if (*s2 != ' ')	return	NSLog(@"Did not find line number in %@", pathAndLineNumber);
	
	// Patch a zero to recover path
	*s2 = 0;
	
	// Get line number
	int line;
	BOOL foundLine = [[NSScanner scannerWithString:@(s2+1)] scanInt:&line];
	if (!foundLine)	return	NSLog(@"Did not parse line number in %@", pathAndLineNumber);

	// Get path
	NSString* path = @(s);
//	NSLog(@"opening line %d of _%@_", line, path);

	// Open in XCode
	id source = [NSString stringWithFormat:@"tell application \"Xcode\"									\n\
												set doc to open \"%@\"									\n\
												set selection to paragraph (%d) of contents of doc		\n\
											end tell", path, line];
	id script = [[NSAppleScript alloc] initWithSource:source];
	[script performSelectorOnMainThread:@selector(executeAndReturnError:) withObject:nil waitUntilDone:YES];
	// executeAndReturnError:nil];
	script = nil;
//	[script release];
}


- (void)clear
{
	[[self windowScriptObject] callWebScriptMethod:@"clear" withArguments:nil];
}

- (void)search:(NSString*)string
{
	[[self windowScriptObject] callWebScriptMethod:@"search" withArguments:@[string]];
}


@end

