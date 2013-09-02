//

#import "AtoZ.h"
#import "AtoZFunctions.h"
#import "AtoZUmbrella.h"
#import "AtoZModels.h"
#import <objc/runtime.h>
#import "OperationsRunner.h"


NSS 	* AZGridShouldDrawKey 	= @"AZGridShouldDraw",
		* AZGridUnitWidthKey 	= @"AZGridUnitWidth",
		* AZGridUnitHeightKey 	= @"AZGridUnitHeight",
		* AZGridColorDataKey 	= @"AZGridColorData";


@implementation NSObject (AZFunctional)
- (id) processByPerformingFilterBlocks:(NSA*)filterBlocks	{	__block id blockSelf = self;
	[filterBlocks enumerateObjectsUsingBlock:^( id (^block)(id,NSUInteger idx, BOOL*) , NSUInteger idx, BOOL *stop) {
		blockSelf = block(blockSelf, idx, stop);
	}];
	return blockSelf;
}
@end

/* A shared operation que that is used to generate thumbnails in the background. *//**
	static NSOperationQueue *_AZGeneralOperationQueue = nil;
	return _AZGeneralOperationQueue ?: ^{		_AZGeneralOperationQueue = NSOperationQueue.new;
		_AZGeneralOperationQueue.maxConcurrentOperationCount = AZOQMAX;
		return _AZGeneralOperationQueue;
	}();																									*/
NSOQ *AZSharedOperationStack() 			{	return AZDummy.sharedInstance.sharedStack; }
NSOQ *AZSharedOperationQueue() 			{	return AZDummy.sharedInstance.sharedQ; }
NSOQ *AZSharedSingleOperationQueue()	{	return AZDummy.sharedInstance.sharedSQ; }

/**	static NSOperationQueue *_AZSingleOperationQueue = nil;
	return _AZSingleOperationQueue  ?: ^{
		_AZSingleOperationQueue = NSOperationQueue.new;
		_AZSingleOperationQueue.maxConcurrentOperationCount = 1;
		return _AZSingleOperationQueue;
	}();					

																					*/

// NSLog(@"%@", [[RED.classProxy valueForKey:@"NSColor"] redColor]);  --> NSCalibratedRGBColorSpace 1 0 0 1

@implementation AZClassProxy
- (id)valueForUndefinedKey:(NSS*)key {	NSLog(@"%@..%@", AZSELSTR, key); return NSClassFromString(key);	}
@end
@implementation NSObject (AZClassProxy)

+ (id)performSelector:(SEL)sel { return objc_msgSend(self.class, sel); }

//	NSObject* anInstance = self.new;
//	return [[anInstance.classProxy valueForKey:NSStringFromClass([self class])] performSelector:sel];

- (id) classProxy {	static AZClassProxy *proxy = nil; return proxy = proxy ?: AZClassProxy.new; }
@end

@implementation AZDummy
- (id)init							{	 if (self != super.init ) return nil;

   _sharedStack = NSOperationStack.new;
	 	 _sharedQ = NSOQ.new;
	   _sharedSQ = NSOQ.new;
	_sharedStack .maxConcurrentOperationCount = AZOQMAX;
		 _sharedQ .maxConcurrentOperationCount = AZOQMAX;
		_sharedSQ .maxConcurrentOperationCount = 1;	return self;
}
+ (AZDummy*) sharedInstance	{ 	static AZDummy *sharedInstance = nil;	static dispatch_once_t isDispatched;
	dispatch_once(&isDispatched, ^{  sharedInstance = AZDummy.new;	}); 	return sharedInstance;
}
@end

@interface AToZFuntion	: BaseModel
@property (STR,NATOM) NSS* name;
@property (STR,NATOM) NSIMG* icon;
@end

/*
// 4) Add this method to the implementation file
//- (id)forwardingTargetForSelector:(SEL)sel	{		if(		sel == @selector(runOperation:withMsg:)	|| sel == @selector(operationsSet)			||		sel == @selector(operationsCount)		|| sel == @selector(cancelOperations)		||		sel == @selector(enumerateOperations:)		) {		if(!operationsRunner) {	// Object only created if needed			operationsRunner = [[OperationsRunner alloc] initWithDelegate:self];		}	return operationsRunner;	} else {	return [super forwardingTargetForSelector:sel];	}	}
*/


@interface AtoZ ()
@property (nonatomic, assign) BOOL fontsRegistered;
@end

//@synthesize sManager; - (id)init {	self = [super init];	if (self) {	static NSA* cachedI = nil;
//	AZLOG($(	@"AZImage! Name: %@.. SEL:%@", name, NSStringFromSelector(_cmd)));	NSIMG *i;  // =  [NSIMG  new];//imageNamed:name];
//	if (!i) dispatch_once:^{		[[NSIMG alloc]initWithContentsOfFile: [AZFWORKBUNDLE pathForImageResource:name]];
//		i =  [NSIMG imageNamed:name];	i.name 	= i.name ?: name;	 }();	i = [NSIMG imageNamed:name];	return i;
//	return [NSIMG imageNamed:name];	?: [[NSIMG alloc]initWithContentsOfFile: [AZFWORKBUNDLE pathForImageResource:name]];
//	i.name 	= i.name ?: name;	return/ i;	}

@implementation AtoZ

+ (void) processInfo							{										

	LOGCOLORS( RED, ORANGE, YELLOW, GREEN,
	$(@"\n\tEXE:\t%@",  															 AZPROCINFO.processName),
	$(@"\n\tCWD:\t%@\n", [AZFILEMANAGER.currentDirectoryPath truncateInMiddleForWidth:500]),
	$(@"argv[0]:\t%@\t\t[NSPROC]",  [AZPROCINFO.arguments[0] truncateInMiddleForWidth:500]), nil);
//					$(@"\nargv[0]:\t%@\t[MAIN]",             [$UTF8(argv[0]) truncateInMiddleForWidth:500])

	NSProcessInfo *pi = [NSProcessInfo processInfo];
	LOGCOLORS([[[pi environment]allKeys] map:^(id o){ return $(@"%@ : %@\n",o, [[pi environment]objectForKey:o]); }], RANDOMPAL, nil); 
	NSLog(@"environment SHELL: %@", [[pi environment] objectForKey:@"SHELL"]);
	NSLog(@"globallyUniqueString: %@", [pi globallyUniqueString]);
	NSLog(@"hostName: %@", [pi hostName]);
	NSLog(@"processIdentifier: %d", [pi processIdentifier]);
	NSLog(@"processName: %@", [pi processName]);
	[pi setProcessName:@"MyProcessNewName"];
	NSLog(@"processName: %@", [pi processName]);
	NSLog(@"operatingSystem: %d", [pi operatingSystem]);
	NSLog(@"operatingSystemName: %@", [pi operatingSystemName]);
	NSLog(@"operatingSystemVersionString: %@", [pi operatingSystemVersionString]);
	NSLog(@"processorCount: %d", [pi processorCount]);
	NSLog(@"activeProcessorCount: %d", [pi activeProcessorCount]);
	NSLog(@"physicalMemory: %qu", [pi physicalMemory]);
	NSLog(@"args: %@", [pi arguments]);

}


+ (void) load							{  int res;	const char*XCenv = NULL;

				  XCenv = getenv("__XCODE_BUILT_PRODUCTS_DIR_PATHS");
	if (XCenv != NULL) setenv("XCODE_COLORS", "YES", &res);
}
//globalRandoPalette = NSC.randomPalette.shuffeled; }
//+ (void) initialize 					{//												[@"AtoZ.framework Version:%@ Initialized!" log:[self version], nil];
//}
- (void) setUp 						{
	[AZStopwatch named:@"AtoZ.framework Instanciate!" block:^{
		[NSB loadAZFrameworks];
		NSC* c = RANDOMCOLOR;
		NSProcessInfo* infoD = AZPROCINFO;
		NSS*initial = @"A";
//		NSS *procName = [infoD processName];
//		initial = procName ? procName.firstLetter : @"A";

//		[NSApp setApplicationIconImage:[NSIMG badgeForRect:AZRectFromDim(256) withColor:c stroked:c.contrastingForegroundColor withString:initial]];
		// imageNamed:@"logo.png"]];
		_fonts = self.fonts;
		[DDLog addLogger:AZSHAREDLOG]; 		// Standard lumberjack initialization
		AZSHAREDLOG.colorsEnabled = YES;		// And then enable colors
		AZSHAREDLOG.logFormatter = self;
		//		[AZSHAREDLOG setForegroundColor:PINK backgroundColor:GRAY2.deviceRGBColor forFlag:LOG_FLAG_INFO];
		//		[@[@"DDLogError", @"DDLogWarn", @"DDLogInfo", @"DDLogVerose"] each:^(id obj) {
		//		[NSS.randomDicksonism respondsToStringThenDo:obj];
	}];
}
/*

		[self.class playRandomSound];
		[[NSIMG imageFromLockedFocusSize:AZSizeFromDimension(256) lock:^NSImage *(NSImage *s) {
			[NSGraphicsContext state:^{
				NSIMG* i = [NSIMG imageNamed:@"logo.png"];
				NSBP *bp = [NSBP bezierPathRoundedRectOfSize:AZSizeFromDimension(256)];
				[bp addClip];
				[i drawInRect:AZRectFromSize(s.size) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
			}];
			return s;
		}]openInPreview];

	[NSAppleEventManager.sharedAppleEventManager setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];

		[AZFWORKBUNDLE cacheNamedImages];
		_cachedImages = cachedI;
		Sound *rando = [Sound randomSound];
		[[SoundManager sharedManager] prepareToPlayWithSound:rando];
		[[SoundManager sharedManager] playSound:rando];
		[self registerHotKeys];
*/

- (void)handleURLEvent:(NSAppleEventDescriptor*)theEvent withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
	
	NSString* path = [[theEvent paramDescriptorForKeyword:keyDirectObject] stringValue];
	NSLog(@"apple url event: %@", path);
	[[NSAlert alertWithMessageText:@"URL Request" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", path] runModal];
}
- (BOOL) inTTY							{   return [@(isatty(STDERR_FILENO))boolValue]; }
+ (void) testSizzle 					{
//
//	AZLOG(@"The original, non -siizled");
//	AZLOG(NSStringFromSelector(_cmd));
}
+ (void) testSizzleReplacement	{

//	AZLOG(@"Totally swizzed OUT ***************************");
//	[self testSizzleReplacement];
//	AZLOG(NSStringFromSelector(_cmd));
//	[[AtoZ class] testSizzle];	[$ swizzleClassMethod:@selector(testSizzle) in:[AtoZ class] with:@selector(testSizzleReplacement) in:[AtoZ class]];	[[AtoZ class] testSizzle];
}
+ (NSS*) version						{
	NSString *myVersion	= [AZFWORKBUNDLE infoDictionary][@"CFBundleShortVersionString"];
	NSString *buildNum 	= [AZFWORKBUNDLE infoDictionary][(NSString*)kCFBundleVersionKey];
	return $(@"%@ [ %@ ]", myVersion ?: @"N/A", buildNum ?: @"N/A");
	//	AZLOG(versText); return versText;
}
+ (NSS*) wrapper		  				{ return $(@"%s", getenv("WRAPPER_NAME")); }
+ (NSS*) installPath  				{ return $(@"%s", getenv("BUILT_PRODUCTS_DIR")); }
+ (NSB*) bundle 						{	return [NSBundle bundleForClass:self.class]; }
+ (NSS*) resources 					{ return self.bundle.resourcePath; }
+ (NSUserDefaults*) defs			{	return [NSUserDefaults standardUserDefaults];	}
- (NSS*) description 				{	return [[self.propertiesPlease valueForKey:@"description"] componentsJoinedByString:@""];	}
+ (void) logError:(NSS*)log 	{ DDLogError(@"%@",log); }
+ (void) logInfo: (NSS*)log 	{ DDLogError(@"%@",log); }
+ (void) logWarn: (NSS*)log 	{ DDLogWarn (@"%@",log); }
- (NSC*) logColor 		{  return _logColor = _logColor ?: RANDOMCOLOR; }
- (NSA*) basicFunctions	{

	return @[@"Maps", @"Browser", @"Contacts", @"Mail", @"Gists", @"Settings"];
}
+ (NSS*) tempFilePathWithExtension:(NSS*)extension	{return $(@"/tmp/atoztempfile.%@.%@", NSS.newUniqueIdentifier, extension); }
- (void) appendToStdOutView:(NSS*)text		{
	NSAttributedString *string = [text attributedWithFont:AtoZ.controlFont andColor:self.logColor];
	// Get the length of the textview contents
	NSRange theEnd				= NSMakeRange([_stdOutView.string length], 0);
	theEnd.location	   			+= text.length;
	// Smart Scrolling
	if (NSMaxY(_stdOutView.visibleRect) == NSMaxY(_stdOutView.bounds)) {
		// Append string to textview and scroll to bottom
		[[_stdOutView textStorage] appendAttributedString:string];
		[_stdOutView scrollRangeToVisible:theEnd];
	} else	// Append string to textview
		[[_stdOutView textStorage] appendAttributedString:string];
}
+ (NSF*) font: (NSS*)family size:(CGF)size	{

	NSS * font = [AtoZ.sharedInstance.fonts filterOne:^BOOL(NSS* object) {	return [object.lowercaseString contains:family.lowercaseString]; }];
	return font ? [NSFont fontWithName:font size:size] : nil;
}
+ (NSS*) randomFontName {	return AtoZ.sharedInstance.fonts.randomElement;	}
+ (NSF*) controlFont 	{	return [self font:@"UbuntuMono-Bold" size:14];	}
- (void)registerHotKeys	{
	EventHotKeyRef 	hotKeyRef; 		EventTypeSpec 	eventType;		EventHotKeyID 	hotKeyID;
	eventType.eventClass  = kEventClassKeyboard;
	eventType.eventKind   = kEventHotKeyPressed;
	hotKeyID.signature 	  = 'htk1';
	hotKeyID.id			  = 1;
	InstallApplicationEventHandler(&HotKeyHandler, 1, &eventType, NULL, NULL);
	// Cmd+Ctrl+Space to toggle visibility.
	RegisterEventHotKey(49, cmdKey+controlKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);

//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification  { [self registerHotKeys]; }

}
+ (void) playRandomSound 			{	[SoundManager.sharedManager playSound:Sound.randomSound looping:NO]; }
+ (void) playSound: (id)number	{   //[ playSound:@1];

	NSA *sounds = @[@"welcome.wav", @"bling"];
	NSS *select = number ? [sounds filterOne:^BOOL(id object) { return [object contains:number]; }] : sounds[0];
	NSS *song   = select ? select : sounds[0];						   
	NSLog(@"Playing song: %@", song);
	[SoundManager.sharedManager  playSound:song looping:NO];
}
+ (void) setSoundVolume:(NSUI)outtaHundred { SoundManager.sharedManager.soundVolume = outtaHundred / 100.0; }

// Place inside the @implementation block - A method to convert an enum to string
// A method to retrieve the int value from the NSArray of NSStrings
+  (NSS*) stringForType:(id)type		{

	Class i = [type class];	NSLog(@"String: %@   Class:%@", NSStringFromClass(i), i);		//	[type autoDescribe:type];
	NSString *key = [NSString stringWithFormat:@"AZOrient_%@", NSStringFromClass([type class])];
	return NSLocalizedString(key, nil);
}
+ (NSA*) appCategories 					{		static NSArray *cats;  return cats = cats ? cats :
	@[	@"Games", @"Education", @"Entertainment", @"Books", @"Lifestyle", @"Utilities", @"Business", @"Travel", @"Music", @"Reference", @"Sports", @"Productivity", @"News", @"Healthcare & Fitness", @"Photography", @"Finance", @"Medical", @"Social Networking", @"Navigation", @"Weather", @"Catalogs", @"Food & Drink", @"Newsstand" ];
//+ (NSA*) appCategories {	return [AZAppFolder sharedInstance].appCategories; }
}
+ (NSA*) macPortsCategories			{		static NSArray *mPortsCats;  return mPortsCats = mPortsCats ? mPortsCats :
	@[@"amusements", @"aqua", @"archivers", @"audio", @"benchmarks", @"biology", @"blinkenlights", @"cad", @"chat", @"chinese", @"comms", @"compression", @"cross", @"crypt", @"crypto", @"database", @"databases", @"devel", @"editor", @"editors", @"education", @"electronics", @"emacs", @"emulators", @"erlang", @"fonts", @"framework", @"fuse", @"games", @"genealogy", @"gis", @"gnome", @"gnustep", @"graphics", @"groovy", @"gtk", @"haskell", @"html", @"ipv6", @"irc", @"japanese", @"java", @"kde", @"kde3", @"kde4", @"lang", @"lua", @"macports", @"mail", @"mercurial", @"ml", @"mono", @"multimedia", @"mww", @"net", @"network", @"news", @"ocaml", @"office", @"palm", @"parallel", @"pdf", @"perl", @"php", @"pim", @"print", @"python", @"rox", @"ruby", @"russian", @"scheme", @"science", @"security", @"shells", @"shibboleth", @"spelling", @"squeak", @"sysutils", @"tcl", @"tex", @"text", @"textproc", @"tk", @"unicode", @"vnc", @"win32", @"wsn", @"www", @"x11", @"x11-font", @"x11-wm", @"xfce", @"xml", @"yorick", @"zope"];
}
+ (NSA*) dock 								{	return (NSA*)[AZDock sharedInstance];
}
+ (NSA*) dockSorted 						{ 	return [AZFolder samplerWithCount:20];} // sharedInstance].dockSorted; }
+ (void) plistToXML: (NSS*) path		{

	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/plutil" arguments:@[@"-convert", @"xml1", path]];
}
+ (void) trackIt							{	[NSThread performBlockInBackground:^{		trackMouse();		}];	}
- (void) mouseSelector 					{	NSLog(@"selectot triggered!  by notificixation, even!");	}
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+ (NSA*) fonts 							{ return AtoZ.sharedInstance.fonts;

//+ (NSFont*) fontWithSize:(CGF)fontSize {	return 	[AtoZ  registerFonts:fontSize]; }
}
- (NSA*) fonts								{	return _fonts = _fonts ?:

	[[[AZFILEMANAGER pathsOfContentsOfDirectory:[AZFWRESOURCES withPath:@"/Fonts"]]URLsForPaths] cw_mapArray:^id(NSURL* obj) { 
		if (!obj) return nil; NSError *err; FSRef fsRef; OSStatus status;
		CFURLGetFSRef((CFURLRef)obj, &fsRef);
		if (status = ATSFontActivateFromFileReference(	&fsRef, 	kATSFontContextLocal,
																					kATSFontFormatUnspecified, NULL, 
																					kATSOptionFlagsDefault, 	NULL) != noErr)
			AZLOG($(@"Error: %@\nFailed to acivate font at %@!", [NSERR errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil], obj));
		CFArrayRef desc = CTFontManagerCreateFontDescriptorsFromURL((__bridge CFURLRef)obj);
		return [((NSA*)CFBridgingRelease(desc))[0] objectForKey:@"NSFontNameAttribute"] ?: (id)nil;
	}];


//#pragma GCC diagnostic ignored "-Wdeprecated-declarations"	- (NSFont*) registerFonts:(CGF)size {		if (!_fontsRegistered) {		NSBundle *aBundle = [NSBundle bundleForClass: [AtoZ class]]	NSURL *fontsURL = [NSURL fileURLWithPath:$(@"%@/Fonts",[aBundle resourcePath])]; if(fontsURL != nil)	{	OSStatus status;		FSRef fsRef;			NSError *err;				CFURLGetFSRef((CFURLRef)fontsURL, &fsRef);			status = ATSFontActivateFromFileReference(&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified, NULL, kATSOptionFlagsDefault, NULL);			if (status != noErr)		{				err = @"Failed to acivate fonts!";  goto err;			} else  { _fontsRegistered = 1; NSLog(@"Fonts registered!"); }	} else NSLog(@"couldnt register fonts!");	}	return  [NSFont fontWithName:@"UbuntuTitling-Bold" size:size]; } #pragma GCC diagnostic warning "-Wdeprecated-declarations"

}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
+ (NSJS*) jsonRequest:(NSS*)url 		{ return [self.sharedInstance jsonRequest:url]; }
- (NSJS*) jsonRequest:(NSS*)url 		{

	NSError *err;
	NSData *responseData = [NSURLC sendSynchronousRequest: [NSURLREQ requestWithURL:$URL(url) cachePolicy:AZNOCACHE timeoutInterval:10.0]  returningResponse:nil error:&err];
	if (!responseData || err) {			NSLog(@"Connection Error: %@", err.localizedDescription); return; 	}
	else	return  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
	
//	if (err) { NSAlert *alert = [NSAlert alertWithMessageText:@"Error parsing JSON" defaultButton:@"Damn that sucks" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Check your JSON"];	[alert beginSheetModalForWindow:[[NSApplication sharedApplication]mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];		return; }
}
-  (void) performBlock: (VoidBlock)block waitUntilDone:(BOOL)wait 						{

	NSThread *newThread = [NSThread new];
	[NSThread performSelector:@selector(az_runBlock:) onThread:newThread withObject:[block copy] waitUntilDone:wait];
}
+  (void) az_runBlock:(VoidBlock)block 															{ block(); }
+  (void) performBlockInBackground:(VoidBlock)block 											{

	[NSThread performSelectorInBackground:@selector(az_runBlock:) withObject:[block copy]];
}
-   (NSP) convertToScreenFromLocalPoint:(NSP)point relativeToView:(NSV*)view			{
	NSScreen *currentScreen = NSScreen.currentScreenForMouseLocation;
	return currentScreen ? (NSP) ^{	NSP windowPoint = [view convertPoint:point toView:nil];
												NSP screenPoint = [[view window] convertBaseToScreen: windowPoint];
												return AZPointOffsetY([currentScreen flipPoint: screenPoint], [currentScreen frame].origin.y);
						  }() : NSZeroPoint;
}
-  (void) moveMouseToScreenPoint:			(NSP)point 											{	CGSUPRESSINTERVAL(0); CGWarpMouseCursorPosition(point); CGSUPRESSINTERVAL(.25); }
-  (void) handleMouseEvent:(NSEM)event inView:(NSV*)view withBlock:(VoidBlock)block	{

	if (self != AtoZ.sharedInstance) NSLog(@"uh oh, not a shared I"); // __typeof__(self) *aToZ = [AtoZ sharedInstance];
	[NSEVENTLOCALMASK:event handler:^NSE *(NSE *ee) {
		//	if ([event type] == NSMouseMovedMask ) {
		NSLog(@"Mouse handler checking point for evet:%@.", ee);
		BOOL doit = 	NSPointInRect(view.localPoint, view.frame);
		if (doit) {	NSLog(@"oh my god.. point is local to view! Runnnng block");
						block();	//	[NSThread.mainThread performBlock:block waitUntilDone:YES]; [NSThread performBlockInBackground:block];
		}
		return ee;
	}];
}
+  (NSA*) runningApps 																					{	return [self.class.runningAppsAsStrings arrayUsingBlock:^id(id obj) { return [AZFile instanceWithPath:obj];	}]; }
+  (NSA*) runningAppsAsStrings	 																	{

	return [[[[[AZWORKSPACE.runningApplications filter:^BOOL(NSRunningApplication *obj) {
		return 	obj.activationPolicy == NSApplicationActivationPolicyProhibited ? 	NO : YES;
		//				obj.activationPolicy == NSApplicationActivationPolicyAccessory ?	NO : YES;
		}] valueForKeyPath:@"bundleURL"] filter:^BOOL(id object) {
			return  [object isKindOfClass:NSURL.class];
		}] arrayUsingBlock:^id(id obj) {
			return [obj path];
		}] filter:^BOOL(id obj) {
			return 	![[obj lastPathComponent] containsAnyOf:@[	@"Google Chrome Helper.app", 
																					@"Google Chrome Worker.app", 
																					@"Google Chrome Renderer.app"]];
		}];
}
static void soundCompleted(SystemSoundID soundFileObject, void *clientData)			{ // Clean up.

	if (soundFileObject != kSystemSoundID_UserPreferredAlert) AudioServicesDisposeSystemSoundID(soundFileObject);
}
+  (void) playNotificationSound:(NSD*)apsDictionary											{
	// App could implement its own preferences so the user could specify if they want sounds or alerts.
	// if (userEnabledSounds)
	NSS 					 *soundName = [apsDictionary stringForKey:@"sound"];	if (!soundName) return;
	SystemSoundID soundFileObject = kSystemSoundID_UserPreferredAlert;
	CFURLRef	  soundFileURLRef	= NULL;
	if ([soundName compare:@"default"] != NSOrderedSame) {
		CFBundleRef mainBundle = CFBundleGetMainBundle();	// Get the main bundle for the app.
		// Get the URL to the sound file to play. The sound property's value is the full filename including the extension.
		soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)soundName,NULL,NULL);
		AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject); // Create a system sound object representing the sound file.
		CFRelease(soundFileURLRef);
	}
	AudioServicesAddSystemSoundCompletion(soundFileObject, NULL, NULL, soundCompleted, NULL); 	// Register function 2b called when done.
	AudioServicesPlaySystemSound(soundFileObject);	// Play the sound.
}
+  (void) badgeApplicationIcon:(NSS*)string														{

	NSDockTile *dockTile = [[NSApplication sharedApplication] dockTile];
	if (string != nil)  [dockTile setBadgeLabel:string];
	else				[dockTile setBadgeLabel:nil];

}
+  (void) testVarargs:(NSA*)args 																	{		[args eachWithIndex:^(id obj, NSInteger idx) {  printf("%d:  %s", (int)idx, [obj stringValue].UTF8String); }]; }
+  (void) varargBlock:(AZVA_ARRAYB)block withVarargs:(id)varargs, ... 				{
	__block NSMA *stuffToPass = NSMA.new;
	AZVA_Block theBlk = ^(id thing) { [thing isKindOfClass:NSO.class] ? [stuffToPass addObject:thing] : nil; };
	azva_iterate_list(varargs, theBlk);
	block(stuffToPass);
}
+  (void) sendArrayTo:(SEL)method inClass:(Class)class withVarargs:(id)varargs, ... {
	__block NSMA *stuffToPass = NSMA.new;
	AZVA_Block theBlk = ^(id thing) { [thing isKindOfClass:NSO.class] ? [stuffToPass addObject:thing] : [stuffToPass addObject:AZString(thing)]; };

	azva_iterate_list(varargs, theBlk);
	id theShared = [class sharedInstance];
	[[class class] performSelectorWithoutWarnings:method withObject:stuffToPass];
}
int  DDLEVEL2INT			  (DDLogMessage*m)	{
	int dd = m->logFlag; return dd == LOG_FLAG_ERROR ? 0 : dd == LOG_FLAG_WARN ? 1 : dd == LOG_FLAG_INFO ? 2 : 3;
}
NSS* DDLEVEL2STRING		  (DDLogMessage*m) 	{
	int dd = m->logFlag; return dd == LOG_FLAG_ERROR ? @"ERR" : dd == LOG_FLAG_WARN ? @"WARN" : dd == LOG_FLAG_INFO ? @"INFO" : @"VERBOSE";
}
- (NSS*) formatLogMessage:(DDLogMessage*)lM	{

	/*	lM->logMsg 		lM->file		lm->lineNumber	lM->function	lM.fileName	DDLEVEL2STRING(lm) DDLEVEL2INT(lM) */
	NSS* file = $(@"[%@]", [$UTF8(lM->file).lastPathComponent stringByDeletingPathExtension]);
	file = [[file truncateInMiddleToCharacters:12]paddedTo:12];
	file = [AZLOGSHARED colorizeString:file withColor:GREEN];
	printf("%s", file.UTF8String);
	return $(@"%@:%i%@", file , lM->lineNumber, lM->logMsg);
}

/*
 //	NSLog(COLOR_ESC @"bg89,96,105;" @"Grey background" XCODE_COLORS_RESET);
 //	NSLog(COLOR_ESC @"fg0,0,255;" COLOR_ESC @"bg220,0,0;"	 @"Blue text on red background" XCODE_COLORS_RESET);
 //	NSLog(XCODE_COLORS_ESCAPE @"fg209,57,168;" @"You can supply your own RGB values!" XCODE_COLORS_RESET);
 //	DDLogError  (@"Paper jam"										);							  // Red
 //	DDLogWarn   (@"Toner is low"									);							// Orange
 //	DDLogInfo   (@"Warming up printer (pre-customization)");  // Default (black)
 //	DDLogVerbose(@"Intializing protcol x26"						);			  // Default (black)
 //	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
 //LogStackAndReturn(self.bundle);} // ; }
 //#define LOGWARN(fmt, ...) NSLog((@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" fmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

 self.dock =   [self.dockOutline arrayUsingIndexedBlock:^id(AZFile *obj, NSUInteger idx) {
 AZFile *app = [AZFile instanceWithPath:[obj valueForKey:@"path"]];
 app.spot = [[obj valueForKey:@"spot"]unsignedIntegerValue ];
 app.dockPoint = [[obj valueForKey:@"dockPoint"]pointValue];
 NSLog(@"Created file: %@... idx:%ld", app.name, idx);
 return app; }]; return dock;  //		}waitUntilDone:YES];	return _dock;	}

- (NSA*) dockSorted {	self.sortOrder = AZDockSortColor;	//	[NSThread performBlockInBackground:^{
	if (!_dockSorted)
		[[NSThread mainThread] performBlock:^{
	if (!dockSorted)
return  [[[dock sortedWithKey:@"hue" ascending:YES] reversed] arrayUsingIndexedBlock:^id(AZFile* obj, NSUInteger idx) {
				if ([obj.name isEqualToString:@"Finder"]) {
					obj.spotNew = 999;
					obj.dockPointNew = obj.dockPoint;	} else { obj.spotNew = idx;
 obj.dockPointNew = [[dock[idx]valueForKey:@"dockPoint"]pointValue];	} return obj;
 }];	return dockSorted;			}waitUntilDone:YES];	return _dockSorted;		[[NSThread mainThread] performBlock:^{			 _dockSorted = adock.mutableCopy;		} waitUntilDone:YES];	}];/	return _dockSorted;	}


+ (NSA*) appFolderSorted {	return [AZAppFolder sharedInstance].sorted;	[AZFiles sharedInstance].appFolderSorted = [AZFiles.sharedInstance.appFolder sortedWithKey:@"hue" ascending:YES].reversed.mutableCopy;		//	return  [AZFiles sharedInstance].appFolderSorted; }
+ (NSA*) appFolder {
	[AZStopwatch start:@"appFolder"];
	if (! [AtoZ sharedInstance].appFolder ) {
		NSMutableArray *applications = [NSMutableArray array];
		ApplicationsInDirectory(@"/Applications", applications);
		[AtoZ sharedInstance].appFolder = [NSMutableArray array];
	}
	[AZStopwatch stop:@"appFolder"];
	[[AtoZ sharedInstance] useHRCoderIfAvailable];
	NSLog(@"%@", [[AtoZ sharedInstance] codableKeys]);
		[[AtoZ sharedInstance] writeToFile:@"/Users/localadmin/Desktop/poop.plist" atomically:NO];
	return (NSA*)[AZAppFolder sharedInstance];
}
+ (NSA*) appFolderSamplerWith:(NSUInteger)apps {	[AZStopwatch start:@"appFolderSampler"];	return (NSA*)[AZFolder appFolderSamplerWith:apps andMax:apps];	[AZStopwatch stop:@"appFolderSampler"];	}
- (NSArray *)uncodableKeys	{	return [self.class.sharedInstance uncodableKeys]; //[NSArray arrayWithObject:@"uncodableProperty"]; }
- (void)setWithCoder:(NSCoder *)coder { [super setWithCoder:coder];	self. = DECODE_VALUE([coder decodeObjectForKey: @"uncodableProperty"];}
- (void)encodeWithCoder:(NSCoder *)coder	{	[super encodeWithCoder:coder];	[coder encodeObject:@"uncodable" forKey:@"uncodableProperty"];	}
+ (NSA*) fengshui {	return [[self class] fengShui]; }
+ (NSA*) fengShui {	return [NSC.fengshui.reversed map:^id(id obj) {	AZFile *t = [AZFile instance]; t.color = obj; return t; }]; }
NSArray *AllApplications(NSArray *searchPaths) { NSMA *applications = NSMA.new; NSEnumerator *searchPathEnum = [searchPaths objectEnumerator]; NSString *path;	while (path = [searchPathEnum nextObject]) ApplicationsInDirectory(path, applications);	return ([applications count]) ? applications : nil; }
 */

#define GROWL_ENABLED 0
#ifdef GROWL_ENABLED
- (BOOL) registerGrowl 											{

	NSBundle *growlBundle = [NSBundle bundleWithPath:[[AZFWORKBUNDLE privateFrameworksPath] withPath: @"Growl.framework"]];
	//	NSLog(@"growl props: %@ ", [growlBundle propertiesPlease]);
	if (growlBundle && [growlBundle load]) 	{
		NSLog(@"Succeefully Loaded Growl.framework!");
		//		[GrowlApplicationBridge registrationDictionaryFromBundle:AZFWORKBUNDLE];
		//		[GrowlApplicationBridge setGrowlDelegate:self];  bundle];	//	Register ourselves as a Growl delegate
		//		[GrowlApplicationBridge notifyWithTitle:@"Welcome To AtoZ" description:@"Sexy."		notificationName:@"Log" iconData:nil priority:1 isSticky:NO clickContext:nil];
		return YES;
	} else {		NSLog(@"Could not load Growl.framework"); return NO; }

}
-(void) growlNotificationWasClicked:(id)clickContext 	{

	NSLog(@"got clickback from growl... ");
	NSLog(@"clickback: %@", clickContext);
	
}
#endif

@end
@implementation AtoZ (MiscFunctions)

+  (void) say:				(NSS*)thing 													{
 	// for (NSString *voice in
// 	NSArray *voices = [NSSpeechSynthesizer availableVoices];
// 	NSUInteger randomIndex = arc4random() % [voices count];
// 	NSString *voice = [voices objectAtIndex:randomIndex];
		AZTalker *u = AZTalker.new;  [u say:thing];
// 	[u setVoice: voice ];
// 	[u startSpeakingString: thing];
// 	printf("Speaking as %s\n", [voice UTF8String]);
// 	while ([speaker isSpeaking]) { usleep(40); }
}
+	 (CGP) centerOfRect:	(CGR)rect 														{ return AZCenterOfRect(rect);

//	CGF midx = CGRectGetMidX(rect);CGF midy = CGRectGetMidY(rect);return CGPointMake(midx, midy);
}
+  (void) printCGRect:	(CGR)cgRect 													{	[AtoZ printRect:cgRect];	}
+  (void) printRect:		(NSR)toPrint													{
	NSLog(@"Rect is x: %i y: %i width: %i height: %i ", (int)toPrint.origin.x, (int)toPrint.origin.y,
		  (int)toPrint.size.width, (int)toPrint.size.height);
}
+  (void) printCGPoint:	(CGP)cgPoint 													{	[AtoZ printPoint:cgPoint];	}
+  (void) printPoint:	(NSP)toPrint 													{		NSLog(@"Point is x: %f y: %f", toPrint.x, toPrint.y);	}
+  (void) printTransform:(CGAffineTransform)t 										{
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.a, t.b);
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.c, t.d);
	NSLog(@"[ %1.1f %1.1f 1.0 ]", t.tx, t.ty);
}
+	 (CGF) clamp:			(CGF)v      from:(CGF)minimum  to:(CGF)maximum 		{
	return v = v < minimum 	 ? minimum : v > maximum ? v= maximum : v;
}
+	 (CGF) scaleForSize:	(CGS)size inRect:(CGR)rect									{
	CGF hScale = rect.size.width / size.width;
	CGF vScale = rect.size.height / size.height;
	return  MIN(hScale, vScale);
}
+ 	 (CGR) centerSize:	(CGS)size inRect:(CGR)rect 								{
	CGF scale = [[self class] scaleForSize:size inRect:rect];
	return AZMakeRect(	CGPointMake ( rect.origin.x + 0.5 * (rect.size.width  - size.width),
									 rect.origin.y + 0.5 * (rect.size.height - size.height) ),
					  CGSizeMake(size.width * scale, size.height * scale) );
}
+   (NSR) rectFromPointA:(NSP)pointA 			   andPointB:(NSP)pointB 		{

	// 	get the current distance from the original mouse down point
	float xDistance = pointB.x - pointA.x;		float yDistance = pointB.y - pointA.y;
	//	 we need to create the selection rect, but the calculation is	different depending on whether the mouse has been dragged up and/or to the left (lower coordinate values) or down and to the right (higher coordinate values).
	NSRect returnRect;
	if   ( pointB.x < pointA.x )	{	returnRect.origin.x= pointA.x + xDistance;	returnRect.size.width= fabs(xDistance);		}
	else {								returnRect.origin.x= pointA.x;				returnRect.size.width= xDistance;		 	}
	if   ( pointB.y < pointA.y )	{	returnRect.origin.y= pointA.y + yDistance;	returnRect.size.height = fabs(yDistance);	}
	else {								returnRect.origin.y= pointA.y;				returnRect.size.height = yDistance;			}
	return returnRect;
}
+(NSIMG*) cropImage:		(NSIMG*)sourceImage      withRect:(NSR)sourceRect	{

	NSImage* cropImage = [[NSImage alloc] initWithSize:NSMakeSize(sourceRect.size.width, sourceRect.size.height)];
	[cropImage lockFocus];
	[sourceImage drawInRect:(NSRect){ 0, 0, sourceRect.size.width, sourceRect.size.height}
				   fromRect:sourceRect		operation:NSCompositeSourceOver fraction:1.0];
	[cropImage unlockFocus];
	return cropImage;
}

@end

@implementation  NSObject (debugandreturn)
- (id) debugReturn:(id) val{
	if ([self valueForKeyPath:@"dictionary.debug"])
		NSLog(@"Debug Return Value: %@  Info:%@", val, [(NSObject*) val propertiesPlease]);
	return val;
}
@end

@implementation Box
@synthesize color, save, selected, shapeLayer;
-   (id) initWithFrame: (NSR)frame			{
	self = [super initWithFrame:frame];
	if (self) {
		shapeLayer = [CAShapeLayer layer];
		[self setLayer:shapeLayer];
		[self setWantsLayer:YES];
	}
	return self;
}
- (void)	  drawRect: (NSR)dirtyRect 	{
	//	cotn ext
	[color set];	NSRectFill(dirtyRect);
	selected = NO;
	//	if (selected) [self lasso];
}
- (void)	   mouseUp: (NSE*)theEvent 	{

	//	NSPoint location = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	//	NSLog(@"BOX HIT AT POINT: %@", NSStringFromPoint(location));
	selected = YES;
	save = color.copy;
	//	NSLog(@"Saved %@", self.save);
	color = [NSColor whiteColor];
	float f  = 0;
	while ( f < .6 ) {
		color = ( color == [NSColor blackColor] ? [NSColor whiteColor] : [NSColor blackColor]);
		[self performSelector:@selector(flash:) withObject:color.copy afterDelay:f];
		f = f+.1;
	}
	[self performSelector:@selector(flash:) withObject:save afterDelay:.6];
}
- (void)		 flash: (NSC*)savedColor 	{
	//	NSLog(@"FLASHING %@", savedColor);
	color = savedColor;
	[self setNeedsDisplay:YES];
	//	if (selected) {  [self drawLasso]; }
}
@end


@implementation CAAnimation (NSViewFlipper)
+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGF)scaleFactor {
	// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
	CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	CGF startValue = beginsOnTop ? 0.0f : M_PI;
	CGF endValue = beginsOnTop ? -M_PI : 0.0f;
	flipAnimation.fromValue = @(startValue);
	flipAnimation.toValue = @(endValue);

	// Shrinking t/Applicationshe view makes it seem to move away from us, for a more natural effect
	// Can also grow the view to make it move out of the screen
	CABasicAnimation *shrinkAnimation = nil;
	if ( scaleFactor != 1.0f ) {
		shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];

		// We only have to animate the shrink in one direction, then use autoreverse to "grow"
		shrinkAnimation.duration = aDuration * 0.5;
		shrinkAnimation.autoreverses = YES;
	}

	// Combine the flipping and shrinking into one smooth animation
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.animations = @[flipAnimation, shrinkAnimation];

	// As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
	animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	animationGroup.duration = aDuration;

	// Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
	animationGroup.fillMode = kCAFillModeForwards;
	animationGroup.removedOnCompletion = NO;

	return animationGroup;
}
@end

@implementation NSViewFlipperController
@synthesize isFlipped;
@synthesize duration;
-(id)initWithHostView:(NSView *)newHostView frontView:(NSView *)newFrontView backView:(NSView *)newBackView	{
	if ( self = [super init] ) {
		hostView = newHostView;
		frontView = newFrontView;
		backView = newBackView;
		duration = 0.75;
	}
	return self;
}
-(void)flip 	{

	if ( isFlipped ) { topView = backView; bottomView = frontView; }
	else {topView = frontView; bottomView = backView; }
	CAAnimation *topAnimation = [CAAnimation flipAnimationWithDuration:duration forLayerBeginningOnTop:YES scaleFactor:1.3f];
	CAAnimation *bottomAnimation = [CAAnimation flipAnimationWithDuration:duration forLayerBeginningOnTop:NO scaleFactor:1.3f];
	bottomView.frame = topView.frame; topLayer = [topView layerFromContents]; bottomLayer = [bottomView layerFromContents];
	CGF zDistance = 1500.0f; CATransform3D perspective = CATransform3DIdentity;
	perspective.m34 = -1. / zDistance; topLayer.transform = perspective; bottomLayer.transform = perspective;
	bottomLayer.frame = NSRectToCGRect(topView.frame); // topView.frame;
	bottomLayer.doubleSided = NO;
	[hostView.layer addSublayer:bottomLayer];

	topLayer.doubleSided = NO;
	topLayer.frame = NSRectToCGRect(topView.frame);//topView.frame;
	[hostView.layer addSublayer:topLayer];

	[CATransaction begin];
	[CATransaction setValue:@YES forKey:kCATransactionDisableActions];
	[topView removeFromSuperview];
	[CATransaction commit];

	topAnimation.delegate = self;
	[CATransaction begin];
	[topLayer addAnimation:topAnimation forKey:@"flip"];
	[bottomLayer addAnimation:bottomAnimation forKey:@"flip"];
	[CATransaction commit];
}
-(void) animationDidStop:(CAA*)animation finished:(BOOL)flag	{
	isFlipped = !isFlipped;
	[CATransaction begin];
	[CATransaction setValue:@YES forKey:kCATransactionDisableActions];
	[hostView addSubview:bottomView];
	[topLayer removeFromSuperlayer];
	[bottomLayer removeFromSuperlayer];
	topLayer = nil; bottomLayer = nil;
	[CATransaction commit];
}
-(NSV*) visibleView														   {	return (isFlipped ? backView : frontView);
}
@end


//- (id)objectForKeyedSubscript:(NSString *)key { return [_children objectForKey:key];  }
//- (void)setObject:(id)newValue forKeyedSubscription:(NSString *)key { [_children setObject:newValue forKey:key]; }

/**
@implementation AGFoundation
@synthesize speaker;
+ (AGFoundation *)sharedInstance	{	return [super sharedInstance]; }
- (void)setUp {
	appArray = NSMA.new;
	NSArray *ws =	 [[[NSWorkspace sharedWorkspace] launchedApplications] valueForKeyPath:@"NSApplicationPath"];
	int k = 0;
	for (NSString *path in ws) 	{
		DBXApp *app = [DBXApp instanceWithPath:path];
		[app setIndex:k];  k++;
		[appArray addObject:app];
	}
}
@end
- (void)enumerateProtocolMethods:(Protocol*)p {
// Custom block, used only in this method
	void (^enumerate)(BOOL, BOOL) = ^(BOOL isRequired, BOOL isInstance) {
		unsigned int descriptionCount;
		struct objc_method_description* methodDescriptions =  protocol_copyMethodDescriptionList(p, isRequired, isInstance, &descriptionCount);
		for (int i=0; i<descriptionCount; i++) {
			struct objc_method_description d = methodDescriptions[i];
			NSLog(@"Protocol method %@ isRequired=%d isInstance=%d",  NSStringFromSelector(d.name), isRequired, isInstance);
		}
		if (methodDescriptions)	free(methodDescriptions);
	};
	// Call our block multiple times with different arguments
	// to enumerate all class, instance, required and non-required methods
	enumerate(YES, YES);
	enumerate(YES, NO);
	enumerate(NO, YES);
	enumerate(NO, NO);
}*/
