
#import "AZCLI.h"

static inline IMP __CurrentIMP(const char *info, SEL _cmd) {

	IMP imp = NULL;
  	if (info[0] == '-' || info[0] == '+') {
		NSS *tmp = $UTF8(info+2);
		NSRange r = [tmp rangeOfString:@" "];
		NSString *className = [tmp substringToIndex:r.location];
		Class thisClass = NSClassFromString(className);
		if (thisClass != nil) {
			Method m = NULL;
			m = info[0] == '+' ? class_getClassMethod(thisClass, _cmd) : class_getInstanceMethod(thisClass, _cmd);
			if (m != NULL)	imp = method_getImplementation(m);
		}
	}
//	NSLog(@"IMP%@", (__bridge void**)imp);
  return imp;
}

#define CurrentIMP __CurrentIMP(__PRETTY_FUNCTION__, _cmd)

#define AZQUITMENU [NSMI.alloc initWithTitle:[@"Quit "withString:AZPROCNAME]action:@selector(terminate:) keyEquivalent:@"q"]
void AZCLogFormatWithArguments (const char *format,va_list arguments){	vfprintf(stderr,format,arguments); fflush(stderr); }
void AZCLogFormat					 (const char *fmt,...){ va_list args; va_start(args,fmt);	AZCLogFormatWithArguments(fmt,args); va_end(args);	}
@implementation AZCLI					{
 	id menubar, appMenu, appMenuItem;  NSFileHandle *_stdinFileHandle;
	AZAttachedWindow *attached;		NSW* window; NSA*palette;  StickyNoteView *sticky;
}
- (void) setUp 							{


	AtoZ.sharedInstance;	NSApplication.sharedApplication;	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
	[NSApp 	 setMainMenu:menubar   	=     NSMenu.new];	[menubar  addItem:appMenuItem   	= NSMenuItem.new];
	[appMenuItem setSubmenu:appMenu 	=     NSMenu.new];	[appMenu  						   addItem:AZQUITMENU];
	window 	= [NSW.alloc initWithContentRect:AZRectFromDim(200) styleMask:NSBWM backing:NSBSB defer:NO];
	attached = [AZAttachedWindow.alloc initWithView:[AZSimpleView withFrame:AZRectFromDim(300) color:RANDOMCOLOR]
											  attachedToPoint:AZRandomPointInRect(AZScreenFrameUnderMenu())];
	sticky 	= [StickyNoteView.alloc initWithFrame:[window.contentView bounds]];
	[AZNOTCENTER addObserver:self selector:@selector(didReadStdin:) name:NSFileHandleReadCompletionNotification
																					  object:_stdinFileHandle = AZSTDIN];

	NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 	NSString *documentsDIR = [allPaths objectAtIndex:0];
	_logConsoleHandle = [NSFileHandle fileHandleWithStandardOutput];
//	freopen([_logConsoleHandle cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
	NSLogConsole.sharedConsole.delegate = self;	[NSLogConsole.sharedConsole open];
	window.title 				= AZPROCNAME;
	window.opaque				= NO;
	window.movable				= YES;
	window.backgroundColor 	= CLEAR;
	[attached makeKeyAndOrderFront:self];
	[window makeKeyAndOrderFront:nil];
	[window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
	[self mainMenu];
	[NSApp activateIgnoringOtherApps:YES];
	[_stdinFileHandle readInBackgroundAndNotify];

	[NSApp run];		//	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
}
- (void) textWasEntered:(NSS*)s		{	[AZTalker say: s];	}
-  (IBA) log:(id)sender					{
	NSLog(@"hello from button");
}
-  (IBA) toggleConsole:(id)s			{
	BOOL isOpen = [[NSLogConsole sharedConsole] isOpen];
	NSLog(@"Toggle console %d", isOpen);
	if (!isOpen)	[[NSLogConsole sharedConsole] open];
	else			[[NSLogConsole sharedConsole] close];
}
- (void) mainMenu 						{

	CurrentIMP;
	_selectionDecoder = NSMD.new;
	NSA *z = COLORIZE(@"AtoZCLI!",RANDOMCOLOR,@" - Please choose a test option:\n",PURPLE, @"Available Frameworks:\n",YELLOW,ORANGE,@"Available Mehod Tests:\n", nil);
//	NSLog(@"%@", $UTF8(getenv("PRODUCT")?: "NO product info"));
	NSA *menus = @[[self cliMenuFor:AZBUNDLE.frameworkIdentifiers starting:100 palette:self.palette ],
						[self cliMenuFor:self.instanceMethodNames starting:0 palette:self.palette]];
	NSA *print =  @[[z[0]clr], [z[1]clr], [z[2]clr], menus[0], [z[3]clr], menus[1]];
	fprintf( stdout, "%s", [[print reduce:@"\n" withBlock:^id(id sum, id obj){ return $(@"%@%@\n",sum, obj); }]UTF8String]);
	//fflush(stdout); }];
}
- (void) didReadStdin:(NSNOT*)n		{

	self.lastCommand = _selectionDecoder [@([n stringForKey:NSFileHandleNotificationDataItem].integerValue)];
	LOGCOLORS(RED, $(@"rquested:\"%@\"", _lastCommand), nil);
	AZCLITest test;
	BOOL respondez = [self respondsToSelector:NSSelectorFromString(_lastCommand)];
	NSLog(@"responds: %@", StringFromBOOL(respondez));
	id what = [self valueForKey:_lastCommand];
	NSLog(@"cfk: %@ equal to cliclass: %@... %@", NSStringFromClass([what class]), test, StringFromBOOL(areSame([what class], [test class])));
//	test = [self valueForKey:_lastCommand] isKindOfClass:AZCLI.class]) {
//			NSLog(@"running test block: %@: %@", _lastCommand, test);
//				test();
//		}
//	}
	[_stdinFileHandle readInBackgroundAndNotify];
}
//	BOOL hit =			   			 select < 					  self.instanceMethodNames.count
//	||  (100 <= select && select < 100 + AZFWORKBUNDLE.frameworkIdentifiers.count);
//	fprintf(stdout, "YOu selected %ld.  That matched:%s.\n", select, hit ? "SOMETHING!" : "NADA!");
//	[self cuteFunctions]();	 [self mainMenu];
//	if ([result respondsToSelector:@selector(UTF8String)])  fprintf(stdout, "%s\n", [result UTF8String]);   fprintf(stdout, "objj> ");    fflush(stdout);    [_stdinFileHandle readInBackgroundAndNotify];

- (AZCLITest) cuteFunctions 		{ return ^{		LOGCOLORS(RED, @"WANIP(); ->  \n\n", WANIP(), WHITE, nil);   };   }
- (AZCLITest) stringFunctions		{

	return ^{	NSS*w =  NSS.randomBadWord;	[AZTalker say:w];
					AZCLogFormat("The sum of 50 + 25 is %s", colorizeStringWithColor(w, GREEN).colorLogString.UTF8String);
   };
}

- (AZCLITests*) tests 				{   return _tests = [AZCLITests sharedInstance]; }
- (void) envTest						{

	struct winsize w;
	ioctl(0, TIOCGWINSZ, &w);
	printf("lines %d\n", w.ws_row);
	printf("columns %d\n", w.ws_col);
	printf("BUILD %s\n", getenv("BUILD_DIR"));
}
- (NSA*) palette						{ 	return  palette ?: [NSC colorsInListNamed:@"FengShui"]; }
- (NSC*) nextColor	            {    static NSUI _p = 0; _p++; return [self.palette normal:_p];	}
- (NSS*) frameworkMenu  			{    return [NSS stringFromArray:[AZFWORKBUNDLE.frameworkIdentifiers nmap:^id (id obj, NSUI i) {
            return $(@"%ld:%@", 100 + i, [colorizeStringWithColor(obj, self.nextColor) paddedTo:60].colorLogString);
        }]];
}
- (void) rainbowArrays 				{ LOGCOLORS(NSS.dicksonBible.words, NSC.randomPalette,nil); }
- (void) variadicColorLogging	 	{
    LOGCOLORS(RED, @"red", ORANGE, @"orange", YELLOw, @"yellow", GREEN, @"green", BLUE, @"blue", PURPLE, GREY, "purple (but not in the right order", "Grey (also out of order)", nil);
}
- (void) processInfo					{										LOGCOLORS( RED, ORANGE, YELLOW, GREEN,

					$(@"\n\tEXE:\t%@",  															 AZPROCINFO.processName),
					$(@"\n\tCWD:\t%@\n", [AZFILEMANAGER.currentDirectoryPath truncateInMiddleForWidth:500]),
					$(@"argv[0]:\t%@\t\t[NSPROC]",  [AZPROCINFO.arguments[0] truncateInMiddleForWidth:500]), nil);
//					$(@"\nargv[0]:\t%@\t[MAIN]",             [$UTF8(argv[0]) truncateInMiddleForWidth:500])
}
@end
/*
- (void) colorLogging 				{
    COLORLOG(YELLOw, @"whatever %@", @3);   NSD *allColorInfo = NSC.colorsAndNames;
    NSLog(@"Available named colors:\n%@",   [NSS stringFromArray:[allColorInfo.allKeys map:^id (id obj) {
                return colorizeStringWithColor(
                    [obj stringByPaddingToLength:22 withString:@" " startingAtIndex:0],
                    allColorInfo[obj]);
            }]]);
    [self mainMenu];
}

- (VoidBlock) actionAtIndex {}
+ (void) load 							{ AtoZ.sharedInstance; }
+ (id) blockEval:(id(^)(id blockArgs, ...))block {	 return block(self);	 }
*/

@implementation AtoZ (CLIWindow)


+ (NSW*) popDrawWindow:(BNRBlockViewDrawer)blk {

	BOOL running = 		[[NSApplication sharedApplication]isRunning];
	if (!running) {
		[NSApplication sharedApplication];
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
		id menubar, appMenu, appMenuItem;
		menubar 								=		NSMenu.new;
		appMenu 								=		NSMenu.new;
		[menubar  addItem:appMenuItem = NSMenuItem.new];
		[NSApp 	 setMainMenu:menubar];
		[appMenu  addItem:[NSMI.alloc initWithTitle:[@"Quit " withString:AZPROCNAME]
														 action:@selector(terminate:) keyEquivalent:@"q"]];
		[appMenuItem setSubmenu:appMenu];
		NSW* window = [NSW.alloc initWithContentRect:AZRectFromDim(200) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		[window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
		[window setTitle:AZPROCNAME]; window.backgroundColor = CLEAR;
		[window setOpaque:NO]; [window setMovable:YES];
		[window makeKeyAndOrderFront:nil];
		[NSApp activateIgnoringOtherApps:YES];
		
		StickyNoteView *sticky = [StickyNoteView.alloc initWithFrame:[[window contentView] bounds]];
	
		[NSApp run];

//		[NSLogConsole sharedConsole];
//		[NSLogConsole.sharedConsole setDelegate: self];
//		[[NSLogConsole sharedConsole] open];
		//	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
		
	}

}

@end