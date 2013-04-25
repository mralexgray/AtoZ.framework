//  Created by Patrick Geiller on 16/08/08.

#import "NSLogConsole.h"
#import <ScriptingBridge/ScriptingBridge.h>

BOOL 	inited = NO;
void	NSLogPostLog(char* file, int line){ if(!inited)return; [NSLogConsole.sharedConsole updateLogWithFile:file lineNumber:line];}

@implementation NSLogConsole
@synthesize autoOpens, windowTitle, original_stderr, logPath, fileHandle, fileOffset, webView, window, searchField;

- 	    (void) setTerminal:(NSMutableAttributedString *)terminal
{
	_terminal = terminal;
	if ([_delegate respondsToSelector:@selector(textWasEntered:)]) [_delegate textWasEntered:terminal.string];
}
+       (id)sharedConsole														{

		static id singleton = NULL;
		@synchronized(self){
			if (!singleton){
				singleton = self.alloc;
				[singleton init];
			}
		}
	return singleton;
}
-       (id)init																	{
	id o		= [super init];
	autoOpens	= YES;
	logPath		= NULL;
	inited		= YES;
	_tokensForCompletion = NSMA.new;
	// Save stderr
	original_stderr = dup(STDERR_FILENO);

	logPath = [NSString stringWithFormat:@"%@%@.log.txt", NSTemporaryDirectory(), [AZBUNDLE bundleIdentifier]];

	// Create the file — NSFileHandle doesn't do it !
	[@"" writeToFile:logPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
	fileHandle = [NSFileHandle fileHandleForWritingAtPath:logPath];
	if (!fileHandle)	NSLog(@"Opening log at %@ failed", logPath);

	int fd = [fileHandle fileDescriptor];

	// Redirect stderr
	int err = dup2(fd, STDERR_FILENO);
	if (!err)	NSLog(@"Couldn't redirect stderr");

	fileOffset = 0;
	
	[fileHandle readInBackgroundAndNotify];
//	[AZNOTCENTER addObserver:self selector:@selector(setFakeStdin:) name:@"NSLogConsoleFakeStdin" object:nil ];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataAvailable:) name:NSFileHandleReadCompletionNotification object: fileHandle];


	return	o;
}	// Init : should only be called once by sharedConsole


-     (void) dataAvailable:(NSNotification *)aNotification			{
	NSData *data = [[aNotification userInfo] objectForKey:NSFileHandleNotificationDataItem];
	NSLog(@"data: %@", data);
	[[NSLogConsole sharedConsole] updateLogWithFile:"" lineNumber:0];
	printf("%snslog logged,babay!", _fakeStdin.UTF8String);
}	// NSLog will generate an event posted in the next run loop run
-     (void) open																	{
	if (!window)
	{
		if (![NSBundle loadNibNamed:@"NSLogConsole" owner:self])
		{
			NSLog(@"NSLogConsole.nib not loaded");
			return;
		}
		if ([window respondsToSelector:@selector(setBottomCornerRounded:)])
			[window setBottomCornerRounded:NO];
	}
	if (windowTitle)	[window setTitle:windowTitle];
	[window orderFront:self];
}
-     (void) close																{	[window orderOut:self];	}
-     (BOOL) isOpen																{	return	[window isVisible];	}
- (IBAction) clear:(id)sender													{
	[webView clear];
}
- (IBAction) searchChanged:(id)sender										{
	[webView search:[sender stringValue]];
} // Read log data from handle
-     (void) updateLogWithFile:(char*)fl lineNumber:(int)ln 		{
	// Open a new handle to read new data
	id f = [NSFileHandle fileHandleForReadingAtPath:logPath];
	printf("readinglogfileat:%s", logPath.UTF8String);
	if (!f)	NSLog(@"Opening log at %@ failed", logPath);
	// Get file length
	[f seekToEndOfFile];
	unsigned long long length = [f offsetInFile];
	if (length == 0)	return;
	// Open console if it's hidden
	if (![window isVisible] && autoOpens)	[self open];
	// Read data
	[f seekToFileOffset:fileOffset];
	NSData* data = [f readDataToEndOfFile];
	[self logData:data file:fl lineNumber:ln];
	// We'll read from that offset next time
	fileOffset = length;
}// Log data to webview and original stderr
-     (void) logData:(NSData*)d file:(char*)fl lineNumber:(int)ln	{
	if (![window isVisible] && autoOpens)	[self open];

	id str = [[NSString alloc] initWithBytes:[d bytes] length:[d length] encoding:NSUTF8StringEncoding];
//	[[NSAlert alertWithMessageText:@"hello" defaultButton:@"Furthe" alternateButton:nil otherButton:nil informativeTextWithFormat:str] runModal];
	// Write back to original stderr
	write(original_stderr, [d bytes], [d length]);
	// Clear search
	[searchField setStringValue:@""];
	[webView search:@""];
	// Log string
	[webView logString:str file:fl lineNumber:ln];
}
- (void) setFakeStdin:(NSString *)fakeStdin {  printf("%s", fakeStdin.UTF8String); }
- (void) tableViewSelectionDidChange:(NSNotification *)notification {

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

- (NSA*)tokenField:(MTTokenField*)tokenField completionsForSubstring:(NSS*)substring	{

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

- (void)action:(id)sender{	NSLog(@"You selected Menu Item: %@",sender);	}

- (NSMenu*)tokenField:(MTTokenField*)tokenField menuForToken:(NSS*)string atIndex:(NSUI) index	{
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

@end
@implementation NSLogConsoleView
- (BOOL)drawsBackground	{
	return	NO;
}
- (void)awakeFromNib		{
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
//	Javascript is available	Register our custom javascript object in the hosted page
- (void)webView:(WebView *)view windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject	{

	[windowScriptObject setValue:self forKey:@"NSLogConsoleView"];
}
- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame	{
	webViewLoaded	= YES;
	// Flush message queue
	for (id o in messageQueue)
		[self logString:[o valueForKey:@"string"] file:(char*)[[o valueForKey:@"file"] UTF8String] lineNumber:[[o valueForKey:@"line"] intValue]];
} // WebView has finished loading

- (void)logString:(NSString*)string file:(char*)file lineNumber:(int)line	{
	// Queue message if WebView has not finished loading
	if (!webViewLoaded)	{
		id o = @{@"string": [NSString stringWithString:string],
															@"file": @(file),
															@"line": @(line)};
		[messageQueue addObject:o];
		return;
	}
	[self.windowScriptObject callWebScriptMethod:@"log" withArguments:@[string,
																			@(file), 
																			@(line)]];
} // Notify WebView of new message

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
	[script executeAndReturnError:nil];
}  // Open source file in XCode at correct line number
- (void)clear
{
	[[self windowScriptObject] callWebScriptMethod:@"clear" withArguments:nil];
}
- (void)search:(NSString*)string
{	[[self windowScriptObject] callWebScriptMethod:@"search" withArguments:@[string]];
}
@end

