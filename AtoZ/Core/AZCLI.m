#import "AZCLI.h"
#import "AZGrid.h"

static NSApplication *sharedApp;		static NSMenuItem *appMenuItem;	static NSMenu *menubar,*appMenu;
static dispatch_once_t onceToken;	static AZCLIMenu *meths, *fws;	static NSMD	*selectionDecoder;
static BOOL ignoreNext = NO;

typedef id(^eval)(id blockArgs, ...);
@implementation AZCLI
-     (void) applicationDidFinishLaunching:(NSNOT*)n {  [NSApp activateIgnoringOtherApps:YES]; playTrumpet(); }

-    	   (id) init 						{	if (self != super.init ) return nil;

/*	[@[	@"AZBackground", 	@"AZGrid", @"AZPrismView", 
			@"AZBackground2", @"AZBackgroundProgressBar", 
			@"IsometricView"	]each:^(id o) {	[NSClassFromString(o) preview]; }];  // load up some text views... 	*/	

	       [menu = MenuAppController   .new loadStatusMenu];		// instanciate menu status bar property
	 		  dCTL = DefinitionController.new;							// instanciate definitio contorller that does some shit with a plist
//	_stdinHandle = AZSTDIN;		 											// read stdin
	dispatch_once(&onceToken, ^{		int policy  =  NSApplicationActivationPolicyRegular;
												[sharedApp 	= NSApplication.sharedApplication setActivationPolicy:  policy];
												[sharedApp 	  setMainMenu: menubar = NSMenu	    .new];	
												[menubar 	  addItem: appMenuItem = NSMenuItem  .new];
												appMenuItem . submenu    = appMenu = NSMenu      .new;
												[appMenu 	  							  addItem:AZQUITMENU];		          
												[NSApp 	 									 setDelegate:self];		}); 	
												[self.class  mainMenu];									return self;
}   /* All setup code fpr shared INstance */
+      (void) mainMenu 					{

	__block VoidBlock k = ^{ [NSTerminal readString]; };
	VoidBlock(^loopBack)(NSS*,const char*) = ^VoidBlock(NSS* inputs, const char *raw){ if (ignoreNext) { ignoreNext = NO; return nil; }
		LOGCOLORS(@"response rec'd from fws CLI menu ", inputs,ORANGE, nil);
//		[AZTalker say: NSS.randomDicksonism];
//		LOGCOLORS(@"you matched: ", [selectionDecoder.allKeys containsObject:inputs] ? selectionDecoder[inputs] : @"NOTHING!", RANDOMPAL, nil );
//		[$(@"%@",selectionDecoder.allKeys)log];
		id foundit = [AZCLIMenu valueForIndex:[inputs integerValue]];
		if (foundit) { [AZTalker say:foundit]; LOG_EXPR(foundit); }ignoreNext = YES;
		//[NSTerminal clearInputBlocks];
		return ^{ [NSTerminal printBuffer]; [NSTerminal readString];  }; //[NSTerminal addInputBlock:loopBack];  [NSTerminal readString]; return nil;
	};
//	k = ^{   [NSTerminal addInputBlock:loopBack];  	};
//	void(^rezhuzh)(void) = ^{ [NSTerminal printBuffer];	[NSTerminal readString]; };
	NSA* methods = @[	@"mainMenu",@"runAClassMethod",	@"envTest",	@"instanceMethodNames", @"frameworkMenu",	@"rainbowArrays",	@"variadicColorLogging",@"processInfo"];
	[AZCLIMenu addMenuFor:AZBUNDLE.frameworkIdentifiers starting:100 palette:RANDOMPAL];
//					    input:(TINP)blk { responder(blk); }];// (NSS*(^)(NSS*, const char*))inBlock { responder(inblock); }];  //^NSS*(NSS* inputs, const char * enc){    }];
	[NSTerminal printString:[[COLORIZE(@"Welcome to AtoZCLI!",				 RANDOMCOLOR, nil)[0] clr]withString:zNL]];
	[NSTerminal printString:[[COLORIZE(@"Please choose a test option:",	      PURPLE, nil)[0] clr]withString:zNL]];
	[NSTerminal printString:[[COLORIZE(@"Available Frameworks:",					YELLOW, nil)[0] clr]withString:zNL]];
	[NSTerminal printString:[AZCLIMenu.menu.clr  withString:zNL]];
	[AZCLIMenu resetPrinter];
	[AZCLIMenu addMenuFor:methods starting:0 palette:RANDOMPAL];// input:(NSS*(^)(NSS*, const char*))iBlk { responder(iBlk); }];
	[NSTerminal printString:[[COLORIZE(@"Available METHODS:\n",	GREEN, nil)[0] clr]withString:AZCLIMenu.menu.clr]];
	[NSTerminal addInputBlock:loopBack];
	[NSTerminal readString];

}
- 	    (NSW*) window 					{	return [_window = _window ?: ^{	int mask = NSBorderlessWindowMask|NSResizableWindowMask;

	 	_window 	= [NSW.alloc initWithContentRect:AZRectFromDim(200) styleMask:mask backing:NSBackingStoreBuffered defer:NO];
		
		[_window setContentView: self.contentView]; 
		[_window setBackgroundColor:        CLEAR]; [_window setOpaque:     NO]; 
		[_window setTitle:				 AZPROCNAME]; [_window setDelegate: self];
		
		return _window; }() makeKeyAndOrderFront: nil], _window;
}
-  (BLKVIEW*) contentView 				{ return _contentView = _contentView ?:

	[BLKVIEW viewWithFrame:self.window.contentRect opaque:NO drawnUsingBlock:^(BNRBlockView *v, NSRect r) {
		[[NSBP bezierPathWithRoundedRect:_window.contentRect cornerRadius:20 inCorners:OSBottomLeftCorner|OSBottomRightCorner] fillWithColor:RANDOMCOLOR];
	}];
}
-       (IBA) toggleConsole:(id)s	{	[NSLogConsole.sharedConsole performString:[NSLogConsole.sharedConsole isOpen] ? @"close" : @"open"]; } /* NSLOGCONSOLE - UNUSED */

-      (void) envTest						{	struct winsize w;	ioctl(0, TIOCGWINSZ, &w);

	LOGCOLORS($(@"TTYlines: %u.\n", w.ws_row),RED, $(@"TTYColumns:%u\n", w.ws_col), ORANGE, $(@"BUILD_DIR:%s\n", getenv("BUILD_DIR")), GREEN,nil);
}
-      (NSA*) palette						{ 	return  _palette ?: [NSC colorsInListNamed:@"flatui"]; }//FengShui"]; }
-      (NSC*) nextColor	      	  		{    static NSUI _p = 0; _p++; return [self.palette normal:_p];	}
-      (void) rainbowArrays 				{ LOGCOLORS(NSS.dicksonBible.words, NSC.randomPalette,nil); }
-      (void) variadicColorLogging	 	{
    LOGCOLORS(RED, @"red", ORANGE, @"orange", YELLOw, @"yellow", GREEN, @"green", BLUE, @"blue", PURPLE, GREY, "purple (but not in the right order", "Grey (also out of order)", nil);
}
-      (void) textWasEntered:(NSS*)s	{	[AZTalker say: s];				}
- (VoidBlock) stringFunctions				{

	return ^{	NSS*w =  NSS.randomBadWord;	[AZTalker say:w];
					AZCLogFormat("The sum of 50 + 25 is %s", [AZLOGSHARED colorizeString:w withColor:GREEN].colorLogString.UTF8String);
   };
}
@end


@implementation AZCLIMenuItem
+ (instancetype) cliMenuItem:(NSS*)display index:(NSI)index color:(NSC*)c {// action:(VoidBlock)blk {
	AZCLIMenuItem *m = [self.alloc init];  m.display = display; m .index = index; m.color = c; return m;} //m.actionBlock = blk;  return m; }
@end

@implementation AZCLIMenu static NSMA* menus = nil; NSMIS *toPrint;
+ (NSS*) menu										{

	return [[menus objectsAtIndexes:toPrint] reduce:@"" withBlock:^NSS*(NSS* outString, AZCLIMenu* m){  	// kist print "toPrint" indexes.
		  NSUI maxlen 		= ceil([[m.defaultCollection vFKP:@"display"] lengthOfLongestMemberString] * 1);		// deduce longest string
		  NSUI cols 		= floor(120.f/(float) maxlen);																		// accomodate appropriate number of cols.
__block NSUI i 			= ((AZCLIMenuItem*)((NSA*)[m defaultCollection])[0]).index - 1;											// ascertain first index.
	  	  NSUI maxIndex	= $(@"%lu: ", i + [[m defaultCollection] count]).length; 										// make sure numbers fit nice
		return outString 	= [[outString withString:zNL] withString:
								  [m.defaultCollection reduce:@"" withBlock:^id(id sum, AZCLIMenuItem* obj){ i++; NSS*outP; // Allow goruped indexes.
			return  ( outP = [[(i % cols) == 0 ? @"\n" : @"" withString: [$(@"%lu: ", i) paddedTo:maxIndex]]withString: // pad index
								  [AZLOGSHARED colorizeString:[obj.display paddedTo:maxlen] withColor:obj.color].clr] )
							   ? [sum withString:outP]
								: sum;
	}]]; }];
}
+ (void) hardReset 								{ menus = NSMA.new; toPrint = NSMIS.indexSet; } // resets all
+ (void) resetPrinter 							{ toPrint = NSMIS.indexSet; }	// just reset printer output, keep referenes.
+ (NSS*) valueForIndex:		  (NSI)index	{	id winner;

	return (winner = [[NSA arrayWithArrays:[menus vFKP:@"defaultCollection"]] filterOne:^BOOL(AZCLIMenuItem *o) {
   return o.index == index; }]) ?[winner vFK:@"display"] : nil;
}
+ (instancetype) addMenuFor:(NSA*)items
						 starting:(NSUI)idx
						  palette:(id)p 			{
//							 input:(TINP)blk 	{
							 AZCLIMenu *m = self.instance; 	if(!menus) [self hardReset];
	[(NSMA*)[m defaultCollection] addObjectsFromArray:[items nmap:^id(NSS* obj, NSUI  index) {
		return [AZCLIMenuItem cliMenuItem:obj index:idx + index color:[p normal:index]]; }]];  //action:(VoidBlock)blk];}];
//	[NSTerminal addInputBlock:blk];
		[menus addObject:m]; [toPrint addIndex:[menus indexOfObject:m]]; return m;

}
@end









//-       (IBA) log:(id)sender			{	NSLog(@"hello from button");	}

//- (VoidBlock) actionAtIndex 				{}
//+        (id) blockEval:(eval)block 	{	 return block(self);	 }
//- 		   (NSRNG) range						{ return  NSMakeRange(self.startIdx, [(NSA*)self.defaultCollection count]); }

//+ 			(NSIS*) indexesOfMenus 			{
//
//	NSMIS* is = NSMIS.new;	//	NSLog(@"Allinstances:%@", all);// [[@"a".classProxy vFK:AZCLSSTR] performSelectorWithoutWarnings:NSSelectorFromString(@"allInstancesAddOrReturn:") withObject:nil]);
//	for (AZCLIMenu *m in [self allInstances]) {	//		NSLog(@"%@ RANGE:%@", m, NSStringFromRange(m.range));
//				[is addIndexesInRange:m.range];
//	}
//	return is;
//}
//-         (void) addMenuItem:(AZCLIMenuItem*)i { [self.defaultCollection addObject:i]; NSLog(@"defaultcollectionct: %ld", [self.defaultCollection count]); }

/*
-    (id) identifier 	{ return _identifier = _identifier ?: self.uniqueID; }
 
//- (void) setUp { NSLog(@"Normal setup");  [self  performSelector:NSSelectorFromString(@"swizzleSetUp")]; }
//@property (NATOM,STRNG) NSMD	*selectionDecoder;

- (void) colorLogging 				{
//	COLORLOG(YELLOw, @"whatever %@", @3, nil);   
//	NSD *allColorInfo = NSC.colorLists ;
//	NSLog(@"Available named colors:\n%@",   [NSS stringFromArray:[allColorInfo.allKeys map:^id (id obj) {
//		return colorizeStringWithColor( [obj stringByPaddingToLength:22 withString:@" " startingAtIndex:0], allColorInfo[obj]);		}]]);
//	[self mainMenu];
}

*/

//	[_mainMenu each:^(AZCLIMenu* mensy) {  [NSTerminal printString:mensy.block(resp, @encode(typeof(NSString)))]; }];
	
//			[AZNOTCENTER addObserverForName:NSFileHandleReadCompletionNotification 
//																	 object:_stdinHandle queue:AZSOQ usingBlock:^(NSNOT *n) { 
//					[self setInsideEdge:99];  [AZNOTCENTER removeObserver:observer1];	}]),
//	_mainMenu = [AZNOTCENTER addObserverForName:NSFileHandleReadCompletionNotification object:_stdinHandle queue:AZSOQ usingBlock:^(NSNOT *note) {
//		NSS* input = [n stringForKey:NSFileHandleNotificationDataItem];
//		[input log];
//		if ( SameString(@":", input.firstLetter)) {
//			NSA* words = [input componentsSeparatedByString:@":"];
//			LOGCOLORS(@"rawWords:", words, NSC.randomPalette, nil);
//			[@"s".classProxy[words[0]] performSelectorWithoutWarnings:NSSelectorFromString(words[1])];
//		}
//		[_stdinHandle readInBackgroundAndNotify];
//	}]; return _mainMenu;
//	}();

//+ (void) handleInteractionWithPrompt: (NSS*)string block:(void(^)(NSString *output)) block {

//- (NSString*) termReadStringNowWhat:(NSString*)str ofType:(const char*)encoding {
	
//	NSS *outie; [NSTerminal printString:outie = NSTerminal.readString];	block(outie);
//}


/*

//		AZLOGCMD;
//	[_stdinHandle readInBackgroundAndNotify];
//	[AZNOTCENTER observeName:NSWindowDidUpdateNotification usingBlock:^(NSNOT*n) { [self.contentView setNeedsDisplay:YES]; }];


[self.windowPosString drawInRect:_window.contentRect withAttributes:@{NSFontNameAttribute:AtoZ.controlFont}];
//		[_window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
//[NSString stringWithData:rawD encoding:NSUTF8StringEncoding];
//	fprintf(stderr, "rawstring:%s", outie.UTF8String);
//	NSFH   *handle = self.stdinHandle;
//	NSData   *rawD = [NSData dataWithData:handle.readDataToEndOfFile];
		[self.windowPosString bind:NSValueBinding toObject:_window withKeyPath:@"insideEdge" transform:^id(id value) {
			return AZAlignToString([value unsignedIntegerValue]);
		}];

[AZNOTCENTER observeName:NSApplicationDidBecomeActiveNotification usingBlock:^(NSNOT*n) { [NSApp activateIgnoringOtherApps:YES];	[_window makeKeyAndOrderFront:self];		}];
appMenu.isDark = menubar.isDark = YES;
});
[self setupBareBonesApplication];
- (void) setupBareBonesApplication {
}
	[window az_overrideSelector:@selector(sendEvent:) withBlock:(__bridge void *)^(id _self, NSE* e)	{
		NSR f = AZScreenFrameUnderMenu();	
//		NSP o = [window convertBaseToScreen:[e locationInWindow]];
		AZPOS pos = AZOutsideEdgeOfRectInRect([_self frame], f);
		
		LOGCOLORS(AZString(f), RED, AZString([_self frame]),ORANGE,AZPositionToString(pos),PINK,nil);
AZOutsideEdgeOfRectInRect(window.frame, f);
		AZPositionOfRectPinnedToOutisdeOfRect(f,
		[AZWindowPositionToString(pos)  log];
		LOG_EXPR(AZPointDistanceToBorderOfRect([window.contentView localPoint], f));
	}];
		SEL sel = @selector(handleWindowEvent:); / * Call super: * /
		void (*superIMP)(id, SEL, NSE*) 	= [_self az_superForSelector:sel];
		superIMP (_self, sel, e);
 NSLog(@"filling rect: %@", AZStringFromRect(rect));
 NSRectFillWithColor(rect, RANDOMCOLOR);//NOISY(GRAY2));
 //colorWithPatternImage:[NSIMG imageNamed:@"perforated_white_leather_@2X"]]);
 //[NSIMG frameworkImageNamed:@"mrgray.logo.png"]]);


	[NSTimer timerWithTimeInterval:5 block:^(NSTimeInterval time) {
		AZProcess *mds = [AZProcess processForCommand:@"mds"];
		LOGCOLORS( [mds description], NSC.randomPalette, nil);
		[mds kill:9];
	} repeats:YES];
	
	[AZNOTCENTER addObserver:self selector:@selector(didReadStdin:) name:NSFileHandleReadCompletionNotification object: AZSTDIN];
		sticky = [StickyNote instanceWithFrame:AZRectFromDim(200)];
		[sticky.window makeKeyAndOrderFront:self];

//- (void) windowWillMove:(NSNotification *)notification { [notification log]; }
//- (void) didReadStdin:(NSNOT*)n		{
	
//		id obj = class ?: self;
//		NSLog(@"class:  %@, sel:%@", NSClassFromString(class), NSStringFromSelector(select));
//    	NSInvocation *invocation = [NSInvocation invocationWithTarget:obj block:^(id myObject){
//        [obj perf:42.0];	}];
//class != NULL ? [[class performSelector:select] log] : [[self performSelectorWithoutWarnings:select]log];
//		return;
//	}
//}

//	__block BOOL match = NO;
//	[[AZCLIMenu indexesOfMenus]log];
//	void (^readStdin)(void) = ^{
//		NSS *outie = [NSTerminal readString];
//		[NSTerminal printString:outie];
//	};
//	while (!match) [NSThread performBlockInBackground:^{ readStdin();	}];

//	[self.class handleInteractionWithPrompt:nil block:^(NSString *output) {	
//		fprintf(stderr, "stderrInBlk:%s", output.UTF8String);
//	}];
//	LOGCOLORS(RED, @"rquested:", _lastCommand,PURPLE, nil);	
//}
//	int winner = -1; 	NSIS *mIdxs = [AZCLIMenu  indexesOfMenus];
//	do {  int contender;
//		NSLog(@"%@", AZString( contender = [NSTerminal readInt])); //	int contender = MIN(200,(int) );	
//		NSLog(@"IDXSxt:%ld contend:%i win: %i",mIdxs.count, contender, winner);//, _selectionDecoder);
//	} while (winner == -1);
//	self.lastCommand = menuSelect;
//	SEL select = NSSelectorFromString(words[2]);		
//		Class class = NSClassFromString(words[1]);
//		if (class_getClassMethod(class, select) != nil)
//			[[class performSelector:select]log];
//		else
//			[[[NSStringFromClass(class) withString:@"class: %@ didnt respond to selector:" ] withString:NSStringFromSelector(select)]log];
//		if (class_getInstanceMethod([self class], select) != nil)
//			[self performSelector:select];
//		else
//			[[@"i didnt respond to selector:"withString:NSStringFromSelector(select)]log];
//		self.mainMenu;
//
//	AZCLITest test;
//	BOOL respondez = [self respondsToSelector:NSSelectorFromString(_lastCommand)];
//	NSLog(@"responds: %@", StringFromBOOL(respondez));
//	id what = [self valueForKey:_lastCommand];
//	NSLog(@"cfk: %@ equal to cliclass: %@... %@", NSStringFromClass([what class]), test, StringFromBOOL(areSame([what class], [test class])));	
//	}];
	//fflush(stdout); }];

- (void) runAClassMethod 					{
	static BOOL stop = NO;
	if (!classes) classes = NSMA.new;  if (!methods) methods = NSMA.new;
	NSMS *classlist = @"".mutableCopy; NSMS *methodlist = @"".mutableCopy;
	NSI historyIdx;
	LOGCOLORS(@"Enter class Name, ie. \"NSColor\"... or Select a class from history:", PINK, nil);
	[NSTerminal printString:[AZCLIMenu cliMenuFor:classes starting:0 palette:NSC.randomPalette].menu];
	NSString *inputString = [NSString stringWithData:[NSData dataWithData:[NSFileHandle.fileHandleWithStandardInput readDataToEndOfFile]] encoding:NSUTF8StringEncoding];
	if (inputString.isIntegerNumber) {
			historyIdx = inputString.integerValue;
			if (historyIdx < classes.count){ NSBeep(); inputString = [classes normal:historyIdx]; }
		}
		else [classes doesNotContainObject:inputString] && inputString ? [classes addObject:inputString] : nil;
	
	fprintf(stderr, "class method name: %s", methods.count ? [AZCLIMenu cliMenuFor:methods starting:0 palette:NSC.randomPalette].menu.UTF8String : "");
	NSString *inputMethod = [NSString stringWithData:[NSData dataWithData:[NSFileHandle.fileHandleWithStandardInput readDataToEndOfFile]] encoding:NSUTF8StringEncoding];
	if (inputMethod.isIntegerNumber) {
		historyIdx = inputMethod.integerValue;
		if (historyIdx < methods.count)  inputString = [methods normal:historyIdx];
	}
	else  ![methods containsObject:inputString] && inputString ? [methods addObject:inputString] : nil;
	NSLog(@"Signature: +[%@ %@];", inputString, inputMethod);
	id aRes  = [[self.classProxy vFK:inputString] performString:inputMethod]; 	
	NSLog(@"aRes: %@", aRes);
	if (!stop) [self runAClassMethod];
}
*/


@implementation AtoZ (CLIWindow)
+ (NSW*) popDrawWindow:(BNRBlockViewDrawer)blk {

	BOOL running = 		[[NSApplication sharedApplication]isRunning];
	if (!running) {
		[NSApplication sharedApplication];
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
		NSMenu* menubar, *appMenu; NSMenuItem *appMenuItem;
		menubar		=		NSMenu.new;
		appMenu 		=		NSMenu.new;
		[menubar  addItem:appMenuItem = NSMenuItem.new];
		[NSApp 	 setMainMenu:menubar];
		[appMenu  addItem:[NSMI.alloc initWithTitle:[@"Quit " withString:AZPROCNAME]
														 action:NSSelectorFromString(@"terminate:") keyEquivalent:@"q"]];
		[appMenuItem setSubmenu:appMenu];
		menubar.dark = YES;
		appMenu.dark = YES;
		NSW* window = [NSW.alloc initWithContentRect:AZRectFromDim(200) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
		[window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
		[window setTitle:AZPROCNAME]; window.backgroundColor = CLEAR;
		[window setOpaque:NO]; [window setMovable:YES];
		[window makeKeyAndOrderFront:nil];
		[NSApp activateIgnoringOtherApps:YES];
		
		StickyNote *sticky = [StickyNote instanceWithFrame:[[window contentView] bounds]];
	
		[NSApp run];

//		[NSLogConsole sharedConsole];
//		[NSLogConsole.sharedConsole setDelegate: self];
//		[[NSLogConsole sharedConsole] open];
		//	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
		
	}

}
@end

/*
	AIDockingWindow *attached;	
+ (instancetype) sharedInstance 	{
	if (![AZCLI hasSharedInstance]) [AZCLI setSharedInstance:AZCLI.instance];
	[AZNOTCENTER addObserver:self selector:@selector(didReadStdin:) name:NSFileHandleReadCompletionNotification object:_stdinFileHandle = AZSTDIN];
	NSArray *allPaths 		= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 	NSString *documentsDIR 	= [allPaths objectAtIndex:0];
	NSLogConsole.sharedConsole.delegate = term;	
	[NSLogConsole.sharedConsole open];
	_logConsoleHandle 	= [NSFileHandle fileHandleWithStandardOutput];
	freopen([_logConsoleHandle cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
	window.title 				= AZPROCNAME;
	window.opaque				= NO;
	window.movable				= YES;
	window.backgroundColor 	= CLEAR;
	[attached makeKeyAndOrderFront:self];
	[window makeKeyAndOrderFront:nil];
	[window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
}
	[methods eachWithIndex:^(id obj, NSI idx) {	[methodlist appendFormat:@"\n%ld: %@", idx, obj];	}];
	char methodName [40];
	scanf("%s",(char*)&methodName);
	NSString * methodput = $UTF8((char*)methodName);
	if (methodInt < methods.count){ 
		NSBeep(); 
		methodput = [methods normal:methodInt];
		[AZTalker say: $(@"matched a method: %@", methods[methodInt])];
	}
	else [methods doesNotContainObject:methodput] ? [methods addObject:methodput.copy]: nil;
	NSS* s = @"";
	__block NSI historyIdx =  NSNotFound;		__block NSS* class = nil,  *method = nil
	[@[classlist, methodlist] eachWithIndex:^(id obj, NSI idx) {		idx == 0 ?		}
		char input [99];		scanf("%s",(char*)&input);		NSString * stringIn = $UTF8((char*)input); dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), loop);


- (void) didReadStdin:(NSNOT*)n		{
	NSS* input = [n stringForKey:NSFileHandleNotificationDataItem];
	if ( SameString(@":", input.firstLetter)) {
		NSA* words = [input componentsSeparatedByString:@":"];
		LOGCOLORS(@"rawWords:", words, [[NSC randomPalette]withMinItems:words.count+1], nil);
	[self.class ]
	}
		id obj = class ?: self;
		NSLog(@"class:  %@, sel:%@", NSClassFromString(class), NSStringFromSelector(select));
    	NSInvocation *invocation = [NSInvocation invocationWithTarget:obj block:^(id myObject){
        [obj perf:42.0];	}];
class != NULL ? [[class performSelector:select] log] : [[self performSelectorWithoutWarnings:select]log];
		return;
	}
}
	BOOL hit =			   			 select < 					  self.instanceMethodNames.count
	||  (100 <= select && select < 100 + AZFWORKBUNDLE.frameworkIdentifiers.count);
	fprintf(stdout, "YOu selected %ld.  That matched:%s.\n", select, hit ? "SOMETHING!" : "NADA!");
	[self cuteFunctions]();	 [self mainMenu];
	if ([result respondsToSelector:@selector(UTF8String)])  fprintf(stdout, "%s\n", [result UTF8String]);   fprintf(stdout, "objj> ");    fflush(stdout);    [_stdinFileHandle readInBackgroundAndNotify];
- (VoidBlock) tests 				{   return _tests = [AZCLITests sharedInstance]; }
	[[@"a".classProxy vFK:o]performSelector:@selector(preview)]; // load via the hacky class proxy
+ (void) load {
	if (AZCLI.hasSharedInstance) return; 	
	ProcessSerialNumber psn;  OSStatus err=GetCurrentProcess(&psn);  
}
 */
