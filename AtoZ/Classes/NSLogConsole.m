//  Created by Patrick Geiller on 16/08/08.

#import "NSLogConsole.h"
#import <ScriptingBridge/ScriptingBridge.h>

BOOL 	inited = NO;
void	NSLogPostLog(char* file, int line){ if(!inited)return; [NSLogConsole.sharedConsole updateLogWithFile:file lineNumber:line];}

@implementation NSLogConsole
- (void) setTerminal:(NSMAS*)terminal									{
	_terminal = terminal;	if ([_delegate respondsToSelector:@selector(textWasEntered:)]) [_delegate textWasEntered:terminal.string];
}
- 	 (id) init																	{	id o		= [super init];

	_autoOpens	= YES;		_logPath		= NULL;
	inited		= YES;		_tokensForCompletion = NSMA.new;
	// Save stderr
	_original_stderr = dup(STDERR_FILENO);
	_logPath = [NSString stringWithFormat:@"%@%@.log.txt", NSTemporaryDirectory(), [AZBUNDLE bundleIdentifier]];
	// Create the file — NSFileHandle doesn't do it !
	[@"" writeToFile:_logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	_fileHandle = [NSFileHandle fileHandleForWritingAtPath:_logPath];
	if (!_fileHandle)	NSLog(@"Opening log at %@ failed", _logPath);
	int fd = [_fileHandle fileDescriptor];
	// Redirect stderr
	int err = dup2(fd, STDERR_FILENO);
	if (!err)	NSLog(@"Couldn't redirect stderr");
	_fileOffset = 0;
	[_fileHandle readInBackgroundAndNotify];
//	[AZNOTCENTER addObserver:self selector:@selector(setFakeStdin:) name:@"NSLogConsoleFakeStdin" object:nil ];
	[AZNOTCENTER addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleReadCompletionNotification object: _fileHandle];
	return	o;
}	// Init : should only be called once by sharedConsole
- (void) dataAvailable:(NSNOT*)aNotification							{
	NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
	NSLog(@"data: %@", data);
	[[NSLogConsole sharedConsole] updateLogWithFile:"" lineNumber:0];
	printf("%snslog logged,babay!", _fakeStdin.UTF8String);
}	// NSLog will generate an event posted in the next run loop run
- (void) open																	{
	if (!_window)
	{
		if (![NSBundle loadNibNamed:@"NSLogConsole" owner:self])
		{
			NSLog(@"NSLogConsole.nib not loaded");
			return;
		}
		if ([_window respondsToSelector:@selector(setBottomCornerRounded:)])
			[_window setBottomCornerRounded:NO];
	}
	if (_windowTitle)	[_window setTitle:_windowTitle];
	[_window orderFront:self];
}
- (void) close																	{	[_window orderOut:self];	}
- (BOOL) isOpen																{	return	[_window isVisible];	}
-  (IBA) clear:			(id)sender										{
	[_webView clear];
}
-  (IBA) searchChanged:	(id)sender										{	[_webView search:[sender stringValue]];	} 	// Read log data from handle
- (void) updateLogWithFile:(char*)fl lineNumber:(int)ln 			{
	// Open a new handle to read new data
	id f = [NSFileHandle fileHandleForReadingAtPath:_logPath];
	printf("readinglogfileat:%s", _logPath.UTF8String);
	if (!f)	NSLog(@"Opening log at %@ failed", _logPath);
	// Get file length
	[f seekToEndOfFile];
	unsigned long long length = [f offsetInFile];
	if (length == 0)	return;
	// Open console if it's hidden
	if (![_window isVisible] && _autoOpens)	[self open];
	// Read data
	[f seekToFileOffset:_fileOffset];
	NSData* data = [f readDataToEndOfFile];
	[self logData:data file:fl lineNumber:ln];
	// We'll read from that offset next time
	_fileOffset = length;
}	// Log data to webview and original stderr
- (void) logData:(NSData*)d file:(char*)fl lineNumber:(int)ln	{
	if (![_window isVisible] && _autoOpens)	[self open];

	id str = [NSString stringWithData:d encoding:NSUTF8StringEncoding];
	// initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
//	[[NSAlert alertWithMessageText:@"hello" defaultButton:@"Furthe" alternateButton:nil otherButton:nil informativeTextWithFormat:str] runModal];
	// Write back to original stderr
	write(_original_stderr, [d bytes], [d length]);
	// Clear search
	[_searchField setStringValue:@""];
	[_webView search:@""];
	// Log string
	[_webView logString:str file:fl lineNumber:ln];
}
- (void) setFakeStdin:(NSS*)fakeStdin 									{  printf("%s", fakeStdin.UTF8String); }
- (void) tableViewSelectionDidChange:(NSNOT*)notification 		{

	NSUI row = [(NSTV*)notification.object selectedRow];
	NSS* className = self.classes[row][@"names"];
	NSA* methods = [RuntimeReporter methodNamesForClassNamed:className];
	NSLog(@"%@selected%@", className, methods);
}
- (NSA*) classes {
//	NSMA* names = NSMA.new;
//	NSLog(@"%@",
//	[[AtoZ classMethods]each:^(id obj) {
	return	[[AZFWORKBUNDLE definedClasses] map:^id(id obj) {
					return @{@"names":obj};
				}];

//	[self.myTokenField setTokenArray:[NSArray arrayWithObject:@"test"]];
//	NSLog(@"%@", names);
//	return names;
}

- (NSA*) tokenField:(MTTokenField*)tokenField completionsForSubstring:(NSS*)substring				{

		return [self.tokensForCompletion filter:^BOOL(id object) {
					return [(NSS*)object contains:substring];
					}];
/*			//	if (self.option==0){
		// matching substring to anyportion of the candidat		else{
		// matching substring to leading characters of candidate ignoring any non AlphaNumeric characters in candidate
		// eg
		// if substring is "ac",   matches will include "@action" and "account" but not "fact"

		NSRange alphaNumericRange = [substring rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]];
		NSString * alphaSubstring = @"";
		BOOL searchFullString = NO;
		if (alphaNumericRange.location!=NSNotFound)
			alphaSubstring = [substring substringFromIndex:alphaNumericRange.location];
		else{			alphaSubstring = substring;
						searchFullString = YES;
		}
		NSMutableArray * matches = [[[NSMutableArray alloc] init] autorelease];;
		for (NSString *candidate in testArray){
			// remove any candidate already in use
			if ([tokenField respondsToSelector:@selector(tokenArray)]){
				if([[tokenField tokenArray] containsObject:candidate]) continue;
			}
			else				if([[tokenField objectValue] containsObject:candidate]) continue;
			NSRange alphaNumericRange = [candidate rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet]];
			if (alphaNumericRange.location!=NSNotFound){
				NSString * alphaKeyword = searchFullString?candidate:[candidate substringFromIndex:alphaNumericRange.location];
				NSRange substringRange = [alphaKeyword rangeOfString:alphaSubstring options:NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch];
				if (substringRange.location == 0){
					[matches addObject:candidate];
				}
			}
		}
		return matches;
	}
*/
}
- (void) action:(id)sender{	NSLog(@"You selected Menu Item: %@",sender);	}
- (NSMenu*) tokenField:(MTTokenField*)tokenField menuForToken:(NSS*)string atIndex:(NSUI) index	{
	NSMenu * test = [[[NSMenu alloc] init] autorelease];
	NSArray * itemNames = [NSArray arrayWithObjects:@"Cut",@"Copy",@"Paste",@"-", [NSString stringWithFormat:@"Add %@ to preferences",string], nil];
	for (NSString *aName in itemNames){
		if ([aName isEqualToString:@"-"]){
			[test addItem:[NSMenuItem separatorItem]];
		}
		else{
			NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:aName action:@selector(action:) keyEquivalent:@""];
			[item setTarget:self];
			[test addItem:item];
			[item release];


		}
	}
	return test;
}
+ (instancetype) sharedConsole														{

		static id singleton = NULL; @synchronized(self){ if (!singleton){ singleton = self.alloc;  [singleton init]; }	} return singleton;
}
@end
@implementation NSLogConsoleView	{
// A message might trigger console opening, BUT the WebView will take time to load and won't be able to display messages yet. Queue them - they will be unqueued when WebView has loaded.
	id		messageQueue;	BOOL	webViewLoaded;
}
- (BOOL) drawsBackground			{
	return	NO;
}
- (void) awakeFromNib				{
	messageQueue	= [[NSMutableArray alloc] init];
	webViewLoaded	= NO;

	// Frame load
	[self setFrameLoadDelegate:self];

	// Load html page
	id path = [AZBUNDLE pathForResource:@"NSLogConsole" ofType:@"html"];
	[[self mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];

	// Navigation notification
	[self setPolicyDelegate:self];
}
- (void) webView:(WV*)view windowScriptObjectAvailable:(WebScriptObject*)wso	{	[wso setValue:self forKey:@"NSLogConsoleView"];
} //	JS avail. Reg. our custom js object in hosted page
- (void) webView:(WV*)sender 		didFinishLoadForFrame:(WebFrame*)frame			{		webViewLoaded	= YES;

	[messageQueue each:^(id o){	// Flush message queue
		[self logString:[o vFK:@"string"] file:(char*)[[o vFK:@"file"]UTF8String] lineNumber:[o intForKey:@"line"]]; }];
} // WebView has finished loading
- (void) logString:(NSS*)string file:(char*)file lineNumber:(int)line			{

	// Queue message if WebView has not finished loading
	if (!webViewLoaded)	[messageQueue addObject:@{@"string": string.copy, @"file": @(file), @"line": @(line)}];
	else 	[self.windowScriptObject callWebScriptMethod:@"log" withArguments:@[string, @(file),  @(line)]];
} // Notify WebView of new message

- (void) webView:(WV*)wv decidePolicyForNavigationAction:(NSD*)a request:(NSURLREQ*)r
			  frame:(WebFrame*)f 			 decisionListener:(IDWPDL)l	{
	NSString* pathAndLineNumber = r.URL.path;				// Get path, formed by AbsolutePathOnDisk(space)LineNumber
	char* s = (char*)[pathAndLineNumber UTF8String];		// From end of string, skip to space before number
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
	NSString* path = @(s);	//	NSLog(@"opening line %d of _%@_", line, path);
	// Open in XCode
	id source = $(@"tell application \"Xcode\"\n set doc to open \"%@\"\n set selection to paragraph (%d) of contents of doc \n end tell", path, line);
	id script = [NSAppleScript.alloc initWithSource:source];
	[script executeAndReturnError:nil];
}  // Open source file in XCode at correct line number
- (void) clear							{
	[[self windowScriptObject] callWebScriptMethod:@"clear" withArguments:nil];
}
- (void) search:(NSS*)string		{	[[self windowScriptObject] callWebScriptMethod:@"search" withArguments:@[string]];
}
@end

