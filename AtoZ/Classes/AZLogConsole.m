//	[AZNOTCENTER addObserver:self selector:@selector(setFakeStdin:)
//	name:@"AZLogConsoleFakeStdin" object:nil ];
//  Created by Patrick Geiller on 16/08/08.

#import <ScriptingBridge/ScriptingBridge.h>
#import <WebKit/WebKit.h>
#import "AtoZ.h"
#import "AZLogConsole.h"

BOOL 	inited = NO;
void	NSLogPostLog(char* file, int line){ if(!inited)return; [AZLogConsole.sharedConsole updateLogWithFile:file lineNumber:line];}

@implementation AZLogConsole
- (void) setTerminal:(NSMAS*)term	{
	_terminal = term;
	if ([_delegate respondsToSelector:@selector(textWasEntered:)]) [_delegate textWasEntered:term.string];
}

- 	 (id) init								{	if (self != [super init]) return nil;

	_autoOpens	= YES;		_logPath		= NULL;
	inited		= YES;		_tokensForCompletion = NSMA.new;

	_original_stderr 	= dup(STDERR_FILENO); 	// Save stderr
	_logPath 			= $(@"%@%@.log.txt", NSTemporaryDirectory(),AZBUNDLE.bundleIdentifier);

	// Create the file — NSFileHandle doesn't do it !
	[@"" writeToFile:_logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

	_fileHandle != [NSFileHandle fileHandleForWritingAtPath:_logPath] ?
		NSLog(@"Opening log at %@ failed", _logPath) : nil;

	NSAssert(dup2((int)_fileHandle.fileDescriptor, STDERR_FILENO), @"ERROR Couldn't redirect stderr");

	_fileOffset = 0;	[_fileHandle readInBackgroundAndNotify];
	[AZNOTCENTER addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleReadCompletionNotification object: _fileHandle];
	return self;
}	// Init : should only be called once by sharedConsole

- (void) dataAvailable:(NSNOT*)note	{
	NSData *data = note.userInfo[NSFileHandleNotificationDataItem];
	NSLog(@"data: %@", data);
	[AZLogConsole.sharedConsole updateLogWithFile:"" lineNumber:0];
	printf("%snslog logged,babay!", _fakeStdin.UTF8String);
}	// NSLog will generate an event posted in the next run loop run

- (void) open								{
	if (!_window && ![NSBundle loadNibNamed:@"AZLogConsole" owner:self])
		return NSLog(@"AZLogConsole.nib not loaded");
	[_window responds:@"setBottomCornerRounded:" do:^{ [_window setBottomCornerRounded:NO]; }];
	_windowTitle ?	[_window setTitle:_windowTitle] : nil;
	[_window orderFront:self];
}

- (void) close								{	[_window orderOut:self];	}

- (BOOL) isOpen							{	return [_window isVisible];	}

-  (IBA) clear:			(id)x			{
	[_webView clear];
}

-  (IBA) searchChanged:	(id)x			{	[_webView search:[x stringValue]];	} 	// Read log data from handle

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
	return	[AZFWBNDL.definedClasses   map:^id(id obj) { //AZFWORKBUNDLE
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
		NSMutableArray * matches = [NSMutableArray.new autorelease];;
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
	NSMenu * test = [[NSMenu.alloc init] autorelease];
	NSArray * itemNames = [NSArray arrayWithObjects:@"Cut",@"Copy",@"Paste",@"-", [NSString stringWithFormat:@"Add %@ to preferences",string], nil];
	for (NSString *aName in itemNames){
		if ([aName isEqualToString:@"-"]){
			[test addItem:[NSMenuItem separatorItem]];
		}
		else{
			NSMenuItem * item = [NSMenuItem.alloc initWithTitle:aName action:@selector(action:) keyEquivalent:@""];
			[item setTarget:self];
			[test addItem:item];
//			[item release];


		}
	}
	return test;
}
+ (instancetype) sharedConsole	{

		static id singleton = NULL; @synchronized(self){ if (!singleton){ singleton = [self.alloc init]; }	} return singleton;
}
@end
@implementation AZLogConsoleView	{
// A message might trigger console opening, BUT the WebView will take time to load and won't be able to display messages yet. Queue them - they will be unqueued when WebView has loaded.
	id		messageQueue;	BOOL	webViewLoaded;
}
- (BOOL) drawsBackground			{
	return	NO;
}
- (void) awakeFromNib				{
	messageQueue	= NSMutableArray.new;
	webViewLoaded	= NO;

	// Frame load
	[self setFrameLoadDelegate:self];

	// Load html page
	id path = [AZBUNDLE pathForResource:@"AZLogConsole" ofType:@"html"];
	[[self mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];

	// Navigation notification
	[self setPolicyDelegate:self];
}
- (void) webView:(WV*)view windowScriptObjectAvailable:(WebScriptObject*)wso	{	[wso setValue:self forKey:@"AZLogConsoleView"];
} //	JS avail. Reg. our custom js object in hosted page
- (void) webView:(WV*)x didFinishLoadForFrame:(WebFrame*)f			{		webViewLoaded	= YES;

	[messageQueue each:^(id o){							// Flush message queue
		[self logString:[o vFK:@"string"]
					  file:(char*)[[o vFK:@"file"]UTF8String]
			  lineNumber:[o intForKey:@"line"]]; 						}];

} // WebView has finished loading
- (void) logString:(NSS*)st file:(char*)f lineNumber:(int)ln	{

	NSNumber *file; if (f != NULL) file =  @((int)f); else file = @0;
	NSD* theD = @{	@"string": st.copy, @"file": file, @"line": @(ln)};
	// Queue message if WebView has not finished loading
	if (!webViewLoaded)	[(NSMA*)messageQueue addObject:theD];
	else 	[self.windowScriptObject callWebScriptMethod:@"log" withArguments:theD.allKeys];
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

