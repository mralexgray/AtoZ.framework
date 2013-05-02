
#ifdef __OBJC__

#import "AZCLI.h"
#import "AtoZ.h"
#import "NSTerminal.h"
#import "AZCLITests.h"
#import "NSLogConsole.h"


static inline IMP 	__CurrentIMP(const char *info, SEL _cmd) {

	__block IMP imp = NULL;
  	return    info[0]	!= '-' 		 || 
				 info[0] != '+' ? imp : ^{		NSS *tmp, *clsName;  Class thisCls;
		
		tmp 		= $UTF8(info+2);
		clsName 	= [tmp substringToIndex:[tmp rangeOfString:@" "].location];
		thisCls 	= NSClassFromString ( clsName );
		
		if (thisCls   != nil) {		Method m 	= NULL;
			m 		= info[0] == '+' 	? class_getClassMethod(thisCls, _cmd) 	: class_getInstanceMethod(thisCls, _cmd);
			imp 	= m != NULL 		? method_getImplementation(m) 			: imp;
		}
		return imp;	//	NSLog(@"IMP%@", (__bridge void**)imp);
	}();
}
#define CurrentIMP 	__CurrentIMP(__PRETTY_FUNCTION__, _cmd)
#define AZQUITMENU 	[NSMI.alloc initWithTitle:[@"Quit "withString:AZPROCNAME]action:@selector(terminate:) keyEquivalent:@"q"]
#define AZCLISI 		AZCLI.sharedInstance
void AZCLogFormatWithArguments (const char *format,va_list arguments){	vfprintf(stderr,format,arguments); fflush(stderr); }
void AZCLogFormat					 (const char *fmt,...){ va_list args; va_start(args,fmt);	AZCLogFormatWithArguments(fmt,args); va_end(args);	}

typedef void (^runBlock)();
static id 				menubar, 	appMenu, 	appMenuItem;  
static NSMA				*methods, 	*classes;
static StickyNote 	*sticky;
static NSW				*window;  

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
	AZTestNode *testNode = AZTestNode.sharedInstance;
	[testNode.class.subclasses map:^(id obj) {	return  [obj instanceMethodNames]; }].log;
      fprintf(stdout, "objj> ");
      fflush(stdout);

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
		SEL select = NSSelectorFromString(words[2]);		
		Class class = NSClassFromString(words[1]);
		if (class_getClassMethod(class, select) != nil)
			[[class performSelector:select]log];
		else
			[[[NSStringFromClass(class) withString:@"class: %@ didnt respond to selector:" ] withString:NSStringFromSelector(select)]log];
		if (class_getInstanceMethod([self class], select) != nil)
			[self performSelector:select];
		else
			[[@"i didnt respond to selector:"withString:NSStringFromSelector(select)]log];
		self.mainMenu;
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

@implementation AZCLI				
- (void) setUp 								{

	if (![AZCLI hasSharedInstance]) {
		AZCLISI = self;
		[NSApplication.sharedApplication setActivationPolicy:    NSApplicationActivationPolicyRegular];
		[NSApp 	   setMainMenu:menubar = NSMenu.new];	[menubar addItem:appMenuItem = NSMenuItem.new];
		[appMenuItem setSubmenu:appMenu = NSMenu.new];	[appMenu  					   addItem:AZQUITMENU];
		sticky 	= [StickyNote instanceWithFrame:AZRectFromDim(200)];
		[NSApp activateIgnoringOtherApps:YES];
		[AZCLISI mainMenu];
		[NSApp 	  	  run];		//	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !return term;
	}
}
-  (IBA) log:(id)sender						{	NSLog(@"hello from button");	}
-  (IBA) toggleConsole:(id)s				{[NSLogConsole.sharedConsole performString:[NSLogConsole.sharedConsole isOpen] ? @"close" : @"open"]; }
- (void) mainMenu 							{

	CurrentIMP;	_selectionDecoder = NSMD.new;
	NSA *z 		= COLORIZE(@"AtoZCLI!",RANDOMCOLOR,@" - Please choose a test option:\n",PURPLE, @"Available Frameworks:\n",YELLOW,ORANGE,@"Available Mehod Tests:\n", nil);
	NSA *menus 	= @[[self.class cliMenuFor:AZBUNDLE.frameworkIdentifiers starting:100 palette:_palette ],
						 [self.class cliMenuFor:@[@"mainMenu",@"runAClassMethod", @"envTest", @"instanceMethodNames", @"frameworkMenu", @"rainbowArrays",@"variadicColorLogging", @"processInfo"] starting:0 palette:self.palette]];
	NSA *print 	= @[[z[0]clr], [z[1]clr], [z[2]clr], menus[0], [z[3]clr], menus[1]];
	[NSTerminal printString:[print reduce:@"\n" withBlock:^id(id sum, id obj){ return $(@"%@%@\n",sum, obj); }]];
	
	__block void (^loop) (); __block BOOL *stop = NO;
	loop = ^{
		NSString *menuSelect = [NSTerminal readString];
		*stop = [menuSelect containsAnyOf:@[@"menu",  @"m"]];
	//	[self.class handleInteractionWithPrompt:nil block:^(NSString *output) {	fprintf(stderr, "stderrInBlk:%s", output.UTF8String);
		self.lastCommand = _selectionDecoder [menuSelect];
		LOGCOLORS(RED, $(@"rquested:\"%@\"", _lastCommand), nil);
		AZCLITest test;
		BOOL respondez = [self respondsToSelector:NSSelectorFromString(_lastCommand)];
		NSLog(@"responds: %@", StringFromBOOL(respondez));
		id what = [self valueForKey:_lastCommand];
		NSLog(@"cfk: %@ equal to cliclass: %@... %@", NSStringFromClass([what class]), test, StringFromBOOL(areSame([what class], [test class])));	
	};
		while (!stop) loop();
//	}];
	//fflush(stdout); }];
}
- (void) runAClassMethod 					{

	static BOOL stop = NO;
	if (!classes) classes = NSMA.new;  if (!methods) methods = NSMA.new;
	NSMS *classlist = @"".mutableCopy; NSMS *methodlist = @"".mutableCopy;
	NSI historyIdx;
	LOGCOLORS(@"Enter class Name, ie. \"NSColor\"... or Select a class from history:", PINK, nil);
	fprintf(stderr, "%s", [self.class cliMenuFor:classes starting:0 palette:NSC.randomPalette].UTF8String);
	NSString *inputString = [NSString stringWithData:[NSData dataWithData:[NSFileHandle.fileHandleWithStandardInput readDataToEndOfFile]] encoding:NSUTF8StringEncoding];
	if (inputString.isIntegerNumber) {
			historyIdx = inputString.integerValue;
			if (historyIdx < classes.count){ NSBeep(); inputString = [classes normal:historyIdx]; }
		}
		else [classes doesNotContainObject:inputString] && inputString ? [classes addObject:inputString] : nil;
	
	fprintf(stderr, "class method name: %s", methods.count ? [self.class cliMenuFor:methods starting:0 palette:NSC.randomPalette].UTF8String : "");
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
- (void) addMethodFromString:(NSS*)s 	{

	IMP myIMP = imp_implementationWithBlock(^(id _self, NSString *string) {		NSLog(@"Hello %@", string);
	});
	class_addMethod([self class], NSSelectorFromString(s), myIMP, "v@:@");
}
- (void) envTest								{

	struct winsize w;
	ioctl(0, TIOCGWINSZ, &w);
	LOGCOLORS($(@"TTYlines: %u.\n", w.ws_row),RED, $(@"TTYColumns:%u\n", w.ws_col), ORANGE, $(@"BUILD_DIR:%s\n", getenv("BUILD_DIR")), GREEN,nil);
}
- (NSA*) palette								{ 	return  _palette ?: [NSC colorsInListNamed:@"FengShui"]; }
- (NSC*) nextColor	      	  		   {    static NSUI _p = 0; _p++; return [self.palette normal:_p];	}
- (NSS*) frameworkMenu  					{    return [NSS stringFromArray:[AZFWORKBUNDLE.frameworkIdentifiers nmap:^id (id obj, NSUI i) {
            return $(@"%ld:%@", 100 + i, [colorizeStringWithColor(obj, self.nextColor) paddedTo:60].colorLogString);
        }]];
}
- (void) rainbowArrays 						{ LOGCOLORS(NSS.dicksonBible.words, NSC.randomPalette,nil); }
- (void) variadicColorLogging	 			{
    LOGCOLORS(RED, @"red", ORANGE, @"orange", YELLOw, @"yellow", GREEN, @"green", BLUE, @"blue", PURPLE, GREY, "purple (but not in the right order", "Grey (also out of order)", nil);
}
- (void) processInfo							{										LOGCOLORS( RED, ORANGE, YELLOW, GREEN,

					$(@"\n\tEXE:\t%@",  															 AZPROCINFO.processName),
					$(@"\n\tCWD:\t%@\n", [AZFILEMANAGER.currentDirectoryPath truncateInMiddleForWidth:500]),
					$(@"argv[0]:\t%@\t\t[NSPROC]",  [AZPROCINFO.arguments[0] truncateInMiddleForWidth:500]), nil);
//					$(@"\nargv[0]:\t%@\t[MAIN]",             [$UTF8(argv[0]) truncateInMiddleForWidth:500])
}
- (void) textWasEntered:(NSS*)s			{	[AZTalker say: s];				}
- (VoidBlock) stringFunctions				{

	return ^{	NSS*w =  NSS.randomBadWord;	[AZTalker say:w];
					AZCLogFormat("The sum of 50 + 25 is %s", colorizeStringWithColor(w, GREEN).colorLogString.UTF8String);
   };
}
+ (NSFH*) stdinHandle						{ return AZSTDIN; }
@end
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
		
		StickyNote *sticky = [StickyNote instanceWithFrame:[[window contentView] bounds]];
	
		[NSApp run];

//		[NSLogConsole sharedConsole];
//		[NSLogConsole.sharedConsole setDelegate: self];
//		[[NSLogConsole sharedConsole] open];
		//	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
		
	}

}
@end

#endif
