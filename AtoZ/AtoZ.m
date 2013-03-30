//
//  BaseModel.m
//  Version 2.3.1

//  http://charcoaldesign.co.uk/source/cocoa#basemodel
//  https://github.com/nicklockwood/BaseModel
#import "AtoZ.h"
#import "AtoZFunctions.h"
#import "AtoZUmbrella.h"
#import "AtoZModels.h"
#import <objc/runtime.h>
#import "OperationsRunner.h"



@implementation NSObject (AZFunctional)
-(id)processByPerformingFilterBlocks:(NSArray *)filterBlocks
{
	__block id blockSelf = self;
	[filterBlocks enumerateObjectsUsingBlock:^( id (^block)(id,NSUInteger idx, BOOL*) , NSUInteger idx, BOOL *stop) {
		blockSelf = block(blockSelf, idx, stop);
	}];

	return blockSelf;
}
@end



/* A shared operation que that is used to generate thumbnails in the background. */
NSOperationQueue *AZSharedOperationQueue()
{
	return AZDummy.sharedInstance.sharedQ;

//    static NSOperationQueue *_AZGeneralOperationQueue = nil;
//    return _AZGeneralOperationQueue ?: ^{
//        _AZGeneralOperationQueue = NSOperationQueue.new;
//		_AZGeneralOperationQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
//		return _AZGeneralOperationQueue;
//	}();
}


/* A shared operation que that is used to generate thumbnails in the background. */
NSOperationQueue *AZSharedSingleOperationQueue()
{
	return AZDummy.sharedInstance.sharedSQ;
//    static NSOperationQueue *_AZSingleOperationQueue = nil;
//    return _AZSingleOperationQueue  ?: ^{
//        _AZSingleOperationQueue = NSOperationQueue.new;
//		_AZSingleOperationQueue.maxConcurrentOperationCount = 1;
//		return _AZSingleOperationQueue;
//	}();
}

//
//@interface AZDummy () <OperationsRunnerProtocol>
//@end

@implementation AZDummy

- (id)init
{
	self = [super init];
	if (self) {
			_sharedQ= NSOQ.new; _sharedQ.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;  _sharedSQ = NSOQ.new; _sharedSQ.maxConcurrentOperationCount = 1; } return self; }

+ (AZDummy*)sharedInstance	{ static AZDummy *sharedInstance = nil;    static dispatch_once_t isDispatched; dispatch_once(&isDispatched, ^	{  sharedInstance = AZDummy.new;	}); return sharedInstance; }

//// 4) Add this method to the implementation file
//- (id)forwardingTargetForSelector:(SEL)sel
//{
//	if(
//		sel == @selector(runOperation:withMsg:)	|| sel == @selector(operationsSet)			||
//		sel == @selector(operationsCount)		|| sel == @selector(cancelOperations)		||
//		sel == @selector(enumerateOperations:)
//	) {
//		if(!operationsRunner) {	// Object only created if needed
//			operationsRunner = [[OperationsRunner alloc] initWithDelegate:self];
//		}	return operationsRunner;
//	} else {	return [super forwardingTargetForSelector:sel];
//	}
//}

@end

static char CONVERTTOXML_KEY;


@implementation BaseModel (AtoZ)
@dynamic convertToXML;
@dynamic uniqueID;


- (NSString *)uniqueID
{
	NSS* u =  [self associatedValueForKey:@"uniqueid"];
	if (!u) {
		u = [self.class newUniqueIdentifier];
		[self setUniqueID:u];
	}
	return u;
}
-(void)setUniqueID:(NSString *)uniqueID
{
	[self setAssociatedValue:uniqueID forKey:@"uniqueid" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

-(void)setConvertToXML:(BOOL)convertToXML
{
	objc_setAssociatedObject(self, &CONVERTTOXML_KEY, @(convertToXML), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL) convertToXML
{
	if ([self respondsToSelector:@selector(convertToXML)]) return self.convertToXML;
	return	[self hasAssociatedValueForKey:[NSString stringWithUTF8String:&CONVERTTOXML_KEY]]
			? [objc_getAssociatedObject(self, &CONVERTTOXML_KEY) boolValue] : NO;
}
+ (void) load {	[$ swizzleMethod:@selector(save) with:@selector(swizzleSave) in:[BaseModel class]]; }

- (void)swizzleSave
{
	NSLog(@"swizzlin!");
	[self swizzleSave];
	if (self.convertToXML) {
		NSS* saveP = [self.class saveFilePath];
		NSLog(@"converting to XML: %@", saveP);
		if ([AZFILEMANAGER fileExistsAtPath:saveP])
			[AtoZ plistToXML:saveP];
	}
}

+ (NSS*)saveFilePath {
	return [NSB.applicationSupportFolder withPath:self.saveFile];
}
@end


@interface AtoZ ()
@property (nonatomic, assign) BOOL fontsRegistered;
@end

@interface AToZFuntion	: BaseModel
@property (strong, NATOM) NSS* name;
@property (strong, NATOM) NSIMG* icon;
@end

@implementation AtoZ
@synthesize fonts, fontsRegistered, basicFunctions;





- (NSA*) basicFunctions
{
	return @[@"Maps", @"Browser", @"Contacts", @"Mail", @"Gists", @"Settings"];
}

+ (NSS*) tempFilePathWithExtension:(NSS*)extension
{
	return $(@"/tmp/atoztempfile.%@.%@", NSS.newUniqueIdentifier, extension);

}

#import "AtoZUmbrella.h"

//@synthesize sManager;
//- (id)init {
//	self = [super init];
//	if (self) {
//
//	static NSA* cachedI = nil;

//	AZLOG($(	@"AZImage! Name: %@.. SEL:%@", name, NSStringFromSelector(_cmd)));
//	NSIMG *i;  // =  [NSIMG  new];//imageNamed:name];
//	if (!i) dispatch_once:^{
//		[[NSIMG alloc]initWithContentsOfFile: [AZFWORKBUNDLE pathForImageResource:name]];
//		i =  [NSIMG imageNamed:name];
//		i.name 	= i.name ?: name;
//	 }();
//	i = [NSIMG imageNamed:name];
//	return i;

//	return [NSIMG imageNamed:name];
//			?: [[NSIMG alloc]initWithContentsOfFile: [AZFWORKBUNDLE pathForImageResource:name]];
//	i.name 	= i.name ?: name;
//	return/ i;
//}

+(void) testSizzle {
	AZLOG(@"The original, non -siizled");
	AZLOG(NSStringFromSelector(_cmd));
}
+(void) testSizzleReplacement {
	AZLOG(@"Totally swizzed OUT ***************************");
	[self testSizzleReplacement];
	AZLOG(NSStringFromSelector(_cmd));
}
//	[[AtoZ class] testSizzle];
//	[$ swizzleClassMethod:@selector(testSizzle) in:[AtoZ class] with:@selector(testSizzleReplacement) in:[AtoZ class]];
//	[[AtoZ class] testSizzle];



- (void) setUp
{
	[AZStopwatch named:@"Welcome to AtoZ.framework." block:^{
	// Standard lumberjack initialization
	[DDLog addLogger:SHAREDLOG];
	// And then enable colors
	SHAREDLOG.colorsEnabled = YES;
//	[@[@"Error", @"Warn", @"Info"]]
//	[@[@"DDLogError", @"DDLogWarn", @"DDLogInfo", @"DDLogVerose"] each:^(id obj) {
//		[NSS.randomDicksonism respondsToStringThenDo:obj];
//	}];
		
	NSLog(XCODE_COLORS_ESCAPE @"bg89,96,105;" @"Grey background" XCODE_COLORS_RESET);
	NSLog(XCODE_COLORS_ESCAPE @"fg0,0,255;"
			XCODE_COLORS_ESCAPE @"bg220,0,0;"
			@"Blue text on red background"
			XCODE_COLORS_RESET);
	
	NSLog(XCODE_COLORS_ESCAPE @"fg209,57,168;" @"You can supply your own RGB values!" XCODE_COLORS_RESET);

	DDLogError  (@"Paper jam"										);                              // Red
	DDLogWarn   (@"Toner is low"									);                            // Orange
	DDLogInfo   (@"Warming up printer (pre-customization)");  // Default (black)
	DDLogVerbose(@"Intializing protcol x26"						);              // Default (black)
	
	// Now let's do some customization:
	// Info  : Pink
	
#if TARGET_OS_IPHONE
	UIColor *pink = [UIColor colorWithRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
#else
	NSColor *pink = [NSColor colorWithCalibratedRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
#endif
	[SHAREDLOG setForegroundColor:pink backgroundColor:nil forFlag:LOG_FLAG_INFO];
	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
		
//		[AZFWORKBUNDLE cacheNamedImages];
//		_cachedImages = cachedI;
		fonts = self.fonts;
//		Sound *rando = [Sound randomSound];
//		[[SoundManager sharedManager] prepareToPlayWithSound:rando];
//		[[SoundManager sharedManager] playSound:rando];
//		[self registerHotKeys];
	}];
}
- (NSColor*) logColor {  return _logColor = _logColor ?: RANDOMCOLOR; }

- (void) appendToStdOutView:(NSString*)text
{
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

+ (NSFont*) font:(NSS*)family size:(CGF)size
{

	NSS * font = [AtoZ.sharedInstance.fonts filterOne:^BOOL(NSS* object) {	return [object.lowercaseString contains:family.lowercaseString]; }];
	return font ? [NSFont fontWithName:font size:size] : nil;
}
+ (NSS*) randomFontName; {	return AtoZ.sharedInstance.fonts.randomElement;	}

+ (NSFont*) controlFont {
	return [self font:@"UbuntuTitling" size:18];
}

- (void)registerHotKeys
{
	EventHotKeyRef 	hotKeyRef; 		EventTypeSpec 	eventType;		EventHotKeyID 	hotKeyID;
	eventType.eventClass  = kEventClassKeyboard;
	eventType.eventKind   = kEventHotKeyPressed;
	hotKeyID.signature 	  = 'htk1';
	hotKeyID.id			  = 1;
	InstallApplicationEventHandler(&HotKeyHandler, 1, &eventType, NULL, NULL);
	// Cmd+Ctrl+Space to toggle visibility.
	RegisterEventHotKey(49, cmdKey+controlKey, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
}

//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification  { [self registerHotKeys]; }

+ (void) playRandomSound {	[[SoundManager sharedManager] playSound:[Sound randomSound] looping:NO]; }

+ (void)playSound:(id)number   //[ playSound:@1];
{
	NSA *sounds = @[@"welcome.wav", @"bling"];
	NSS *select = number ? [sounds filterOne:^BOOL(id object) { return [(NSString*)object contains:number] ? YES : NO; }] : sounds[0];
	NSS *song   = select ? select : sounds[0];						   NSLog(@"Playing song: %@", song);
	[[SoundManager sharedManager]  playSound:song looping:NO];
}

+ (void)setSoundVolume:(NSUInteger)outtaHundred { [SoundManager sharedManager].soundVolume = outtaHundred / 100.0; }

// Place inside the @implementation block - A method to convert an enum to string
+ (NSS*) stringForPosition:(AZPOS)enumVal	{
	static NSArray *enumVals = nil;  if (!enumVals) enumVals = [[NSA alloc]initWithObjects:AZWindowPositionTypeArray];
	return enumVals.count >= enumVal ? enumVals[enumVal] : @"outside of range for Positions";
}

// A method to retrieve the int value from the NSArray of NSStrings
+ (AZPOS) positionForString:(NSS*)strVal;	{	return (AZPOS) [[[NSA alloc]initWithObjects:AZWindowPositionTypeArray] indexOfObject:strVal]; }

+ (NSString*)stringForType:(id)type
{
	Class i = [type class];	NSLog(@"String: %@   Class:%@", NSStringFromClass(i), i);		//	[type autoDescribe:type];
	NSString *key = [NSString stringWithFormat:@"AZOrient_%@", NSStringFromClass([type class])];
	return NSLocalizedString(key, nil);
}
//+(void)initialize {
//	AZLOG(@"Initialize AtoZ");
//	AtoZ *u = [[self class] sharedInstance];
//	NSLog(@"Initialized AtoZ.sharedinstance as: %@", u.propertiesPlease);
//}
//- (void) setUp {
//	AZLOG(@"setup AtoZ");
////	char *xcode_colors = getenv(XCODE_COLORS);
////	xcode_colors && (strcmp(xcode_colors, "YES") == 0) ? ^{/* XcodeColors=installed+enabled! */}() : nil;
//		//	[DDLog addLogger:[DDTTYLogger sharedInstance]];
//		//	DDLogVerbose(@"Verbose"); DDLogInfo(@"Info"); DDLogWarn(@"Warn"); DDLogError(@"Error");
//		//	[self registerFonts:(CGFloat)]
//		//	self.sortOrder = AZDockSortNatural;
//	[[[AZSoundEffect alloc]initWithSoundNamed:@"welcome.wav"]play];
//}

+ (NSString *) version;
{
	NSString *myVersion	= [AZFWORKBUNDLE infoDictionary][@"CFBundleShortVersionString"];
	NSString *buildNum 	= [AZFWORKBUNDLE infoDictionary][(NSString*)kCFBundleVersionKey];
	return LogAndReturn( myVersion ? buildNum ? [NSString stringWithFormat:@"Version: %@ (%@)", myVersion, buildNum]
				 : [NSString stringWithFormat:@"Version: %@", myVersion]
				 : buildNum  ? [NSString stringWithFormat:@"Version: %@", buildNum]
				 : nil);
	//	AZLOG(versText); return versText;
}
+ (NSBundle*) bundle {	return [NSBundle bundleForClass:[self class]]; }

+ (NSString*) resources { return [[NSBundle bundleForClass: [self class]] resourcePath]; }
+ (NSA*) dock {
	return (NSA*)[AZDock sharedInstance];
}
//+ (NSA*) currentScope { 	return [AZFolder sharedInstance].items; }
+ (NSA*) dockSorted { 	return [AZFolder samplerWithCount:20];} // sharedInstance].dockSorted; }
//+ (NSA*) appCategories {	return [AZAppFolder sharedInstance].appCategories; }

+ (NSA*) appCategories {		static NSArray *cats;  return cats = cats ? cats :
	@[	@"Games", @"Education", @"Entertainment", @"Books", @"Lifestyle", @"Utilities", @"Business", @"Travel", @"Music", @"Reference", @"Sports", @"Productivity", @"News", @"Healthcare & Fitness", @"Photography", @"Finance", @"Medical", @"Social Networking", @"Navigation", @"Weather", @"Catalogs", @"Food & Drink", @"Newsstand" ];
}
+ (NSA*) macPortsCategories {		static NSArray *mPortsCats;  return mPortsCats = mPortsCats ? mPortsCats :
	@[@"amusements", @"aqua", @"archivers", @"audio", @"benchmarks", @"biology", @"blinkenlights", @"cad", @"chat", @"chinese", @"comms", @"compression", @"cross", @"crypt", @"crypto", @"database", @"databases", @"devel", @"editor", @"editors", @"education", @"electronics", @"emacs", @"emulators", @"erlang", @"fonts", @"framework", @"fuse", @"games", @"genealogy", @"gis", @"gnome", @"gnustep", @"graphics", @"groovy", @"gtk", @"haskell", @"html", @"ipv6", @"irc", @"japanese", @"java", @"kde", @"kde3", @"kde4", @"lang", @"lua", @"macports", @"mail", @"mercurial", @"ml", @"mono", @"multimedia", @"mww", @"net", @"network", @"news", @"ocaml", @"office", @"palm", @"parallel", @"pdf", @"perl", @"php", @"pim", @"print", @"python", @"rox", @"ruby", @"russian", @"scheme", @"science", @"security", @"shells", @"shibboleth", @"spelling", @"squeak", @"sysutils", @"tcl", @"tex", @"text", @"textproc", @"tk", @"unicode", @"vnc", @"win32", @"wsn", @"www", @"x11", @"x11-font", @"x11-wm", @"xfce", @"xml", @"yorick", @"zope"];
}


- (NSS*) description {
	return [[[self propertiesPlease] valueForKey:@"description"] componentsJoinedByString:@""];
}

+ (void) plistToXML: (NSS*) path
{

	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/plutil" arguments:@[@"-convert", @"xml1", path]];
}

//{//	__weak AZSimpleView *e;
//}
//	console = [NSLogConsole sharedConsole]; [console open];

//#define GROWL_ENABLED 1
#ifdef GROWL_ENABLED
- (BOOL) registerGrowl {

	NSBundle *growlBundle = [NSBundle bundleWithPath:[[[[self class]bundle] sharedFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"]];
	NSLog(@"growl props: %@ ", [growlBundle propertiesPlease]);
	if (growlBundle && [growlBundle load]) 	{	NSLog(@"Succeefully Loaded Growl.framework!");
		[GrowlApplicationBridge registrationDictionaryFromBundle:self.bundle];

		// 		Register ourselves as a Growl delegate
		//		[GrowlApplicationBridge setGrowlDelegate:self];

		//		[GrowlApplicationBridge notifyWithTitle:@"Welcome To AtoZ" description:@"Sexy."		notificationName:@"Log" iconData:nil priority:1 isSticky:NO clickContext:nil];
		return YES;
	}	else {		NSLog(@"Could not load Growl.framework"); return NO; }

}
-(void)growlNotificationWasClicked:(id)clickContext {

	NSLog(@"got clickback from growl... ");
	NSLog(@"clickback: ", clickContext);

}
#endif

+ (void) trackIt {
	[NSThread performBlockInBackground:^{		trackMouse();		}];
}

//+ (NSFont*) fontWithSize:(CGFloat)fontSize {
//	return 	[AtoZ  registerFonts:fontSize];
//}

+ (void) initialize {
}
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

+ (NSArray *)fonts { return AtoZ.sharedInstance.fonts; }
- (NSArray *)fonts
{
	return fonts = fonts ?:
	[[[[AZFILEMANAGER pathsOfContentsOfDirectory:[AZFWRESOURCES withPath:@"/Fonts"]]URLsForPaths] filter: ^BOOL(NSURL* obj) {
		return obj ? ^{
			FSRef fsRef;	  CFURLGetFSRef( (CFURLRef)obj, &fsRef );  NSError *err;
			OSStatus status = ATSFontActivateFromFileReference(&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified, NULL, kATSOptionFlagsDefault, NULL);
			return  status != noErr  ? ^ {
				NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
				AZLOG($(@"Error: %@\nFailed to acivate font at %@!", error, obj));
				return  NO;
			}() : YES;
		}() 	: NO;
	}] map:^id(NSURL *obj) {
		CFArrayRef desc = CTFontManagerCreateFontDescriptorsFromURL((__bridge CFURLRef)obj);
		return [((NSA*)CFBridgingRelease(desc))[0] objectForKey:@"NSFontNameAttribute"] ?: @"N/A";
	}];

}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

//#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
//- (NSFont*) registerFonts:(CGFloat)size {
//	if (!_fontsRegistered) {
//		NSBundle *aBundle = [NSBundle bundleForClass: [AtoZ class]];
//		NSURL *fontsURL = [NSURL fileURLWithPath:$(@"%@/Fonts",[aBundle resourcePath])];
//		if(fontsURL != nil)	{
//			OSStatus status;		FSRef fsRef;
//			NSError *err;
//			CFURLGetFSRef((CFURLRef)fontsURL, &fsRef);
//			status = ATSFontActivateFromFileReference(&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified, NULL, kATSOptionFlagsDefault, NULL);
//			if (status != noErr)		{
////				err = @"Failed to acivate fonts!";  goto err;
//			} else  { _fontsRegistered = 1; NSLog(@"Fonts registered!"); }
//		} else NSLog(@"couldnt register fonts!");
//	}
//	return  [NSFont fontWithName:@"UbuntuTitling-Bold" size:size];
//}
//#pragma GCC diagnostic warning "-Wdeprecated-declarations"
+ (NSJSONSerialization*) jsonReuest:(NSString*)url {
	AtoZ *me = [[self class] sharedInstance];
	return  [me jsonRequest:url];
}

+ (NSUserDefaults *)defs {
	return [NSUserDefaults standardUserDefaults];
}
-(void) mouseSelector {

	NSLog(@"selectot triggered!  by notificixation, even!");
}
+ (NSJSONSerialization*) jsonRequest: (NSString*) url { return [self.sharedInstance jsonRequest:url]; }

- (NSJSONSerialization*) jsonRequest:(NSString*)url {
	NSError *err;
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
												cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&err];
	if (!responseData) NSLog(@"Connection Error: %@", [err localizedDescription]);
	//	NSError *error;
	return  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
	//	if (err) {
	//		NSAlert *alert = [NSAlert alertWithMessageText:@"Error parsing JSON" defaultButton:@"Damn that sucks" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Check your JSON"];
	//		[alert beginSheetModalForWindow:[[NSApplication sharedApplication]mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
	//		return;
	//	}
	//	return value;
}

//	self.sortOrder = AZDockSortNatural;
//	if (!_dock)
//		[[NSThread mainThread] performBlock:^{
//			_dock
//	return self.dock;
/*			if (!dock)
 self.dock =   [self.dockOutline arrayUsingIndexedBlock:^id(AZFile *obj, NSUInteger idx) {
 AZFile *app = [AZFile instanceWithPath:[obj valueForKey:@"path"]];
 app.spot = [[obj valueForKey:@"spot"]unsignedIntegerValue ];
 app.dockPoint = [[obj valueForKey:@"dockPoint"]pointValue];
 NSLog(@"Created file: %@... idx:%ld", app.name, idx);
 return app;
 }];
 return dock;
 //		}waitUntilDone:YES];
 //	return _dock;	*/
//}/

//- (NSA*) dockSorted {

//	self.sortOrder = AZDockSortColor;
////	[NSThread performBlockInBackground:^{
////	if (!_dockSorted)
////		[[NSThread mainThread] performBlock:^{
////	if (!dockSorted)
//			return  [[[dock sortedWithKey:@"hue" ascending:YES] reversed] arrayUsingIndexedBlock:^id(AZFile* obj, NSUInteger idx) {
////				if ([obj.name isEqualToString:@"Finder"]) {
////					obj.spotNew = 999;
////					obj.dockPointNew = obj.dockPoint;
////				} else {
//					obj.spotNew = idx;
//					obj.dockPointNew = [[dock[idx]valueForKey:@"dockPoint"]pointValue];
////				}

//				return obj;
//			}];
////	return dockSorted;
////		}waitUntilDone:YES];
////	return _dockSorted;
////		[[NSThread mainThread] performBlock:^{
////			 _dockSorted = adock.mutableCopy;
////		} waitUntilDone:YES];
////	}];
////	return _dockSorted;

//}

/*- (id)objectForKeyedSubscript:(NSString *)key {
 return [self objectForKey:key];
 }
 - (void)setObject:(id)newValue forKeyedSubscription:(NSString *)key {
 [self setObject:newValue forKey:key];
 }	*/

//- (void)performBlock:(void (^)())block {
//	if ([[NSThread currentThread] isEqual:[self curr])
//		block();
//	else
//		[self performBlock:block waitUntilDone:NO];
//}
//- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait {
//	NSThread *newThread = [NSThread new];
//	[NSThread performSelector:@selector(az_runBlock:)
//					 onThread:newThread
//				   withObject:[block copy]
//				waitUntilDone:wait];
//}
//+ (void)az_runBlock:(void (^)())block { block(); }
//+ (void)performBlockInBackground:(void (^)())block {
//	[NSThread performSelectorInBackground:@selector(az_runBlock:) withObject:[block copy]];
//	//}
//+ (NSA*) appFolderSorted {
//	return [AZAppFolder sharedInstance].sorted;
//		//		[AZFiles sharedInstance].appFolderSorted = [AZFiles.sharedInstance.appFolder sortedWithKey:@"hue" ascending:YES].reversed.mutableCopy;
//		//	return  [AZFiles sharedInstance].appFolderSorted;
//}
//
//
//
//+ (NSA*) appFolder {
//
//		//	[AZStopwatch start:@"appFolder"];
//		//	if (! [AtoZ sharedInstance].appFolder ) {
//		//		NSMutableArray *applications = [NSMutableArray array];
//		//		ApplicationsInDirectory(@"/Applications", applications);
//		//		[AtoZ sharedInstance].appFolder = [NSMutableArray array];
//		//	}
//		//	[AZStopwatch stop:@"appFolder"];
//		//	[[AtoZ sharedInstance] useHRCoderIfAvailable];
//		//	NSLog(@"%@", [[AtoZ sharedInstance] codableKeys]);
//		//	[[AtoZ sharedInstance] writeToFile:@"/Users/localadmin/Desktop/poop.plist" atomically:NO];
//
//	return (NSA*)[AZAppFolder sharedInstance];
//}

//+ (NSA*) appFolderSamplerWith:(NSUInteger)apps {
//
//	[AZStopwatch start:@"appFolderSampler"];
//	return (NSA*)[AZFolder appFolderSamplerWith:apps andMax:apps];
//	[AZStopwatch stop:@"appFolderSampler"];
//}

- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view
{
	NSScreen *currentScreen = [NSScreen currentScreenForMouseLocation];
	return currentScreen ? (NSPoint) ^{	NSPoint windowPoint, screenPoint, flippedScreenPoint;
		windowPoint = [view convertPoint:point toView:nil];
		screenPoint = [[view window] convertBaseToScreen: windowPoint];
		return AZPointOffsetY([currentScreen flipPoint: screenPoint], [currentScreen frame].origin.y);
	}() : NSZeroPoint;
}

- (void)moveMouseToScreenPoint:(NSPoint)point {	CGSUPRESSINTERVAL(0); CGWarpMouseCursorPosition(point); CGSUPRESSINTERVAL(.25);}

- (void) handleMouseEvent:(NSEventMask)event inView:(NSView*)view withBlock:(void (^)())block {
	if (self != [AtoZ new]) NSLog(@"uh oh, not a shared I"); // __typeof__(self) *aToZ = [AtoZ sharedInstance];
	[NSEvent addLocalMonitorForEventsMatchingMask:event handler:^NSEvent *(NSEvent *ee) {
		//	if ([event type] == NSMouseMovedMask ) {
		NSLog(@"Mouse handler checking point for evet:%@.", ee);
		NSPointInRect(view.localPoint, view.frame) ? ^{
			NSLog(@"oh my god.. point is local to view! Runnnng block");
			block();
			//			[[NSThread mainThread] performBlock:block waitUntilDone:YES]; // [NSThread performBlockInBackground:block];
		}() : nil;
		return ee;
	}];
}

//- (NSArray *)uncodableKeys
//{
//	return [[AtoZ sharedInstance] uncodableKeys];
//	//[NSArray arrayWithObject:@"uncodableProperty"];
//}

//- (void)setWithCoder:(NSCoder *)coder
//{
//	[super setWithCoder:coder];
////	self. = DECODE_VALUE([coder decodeObjectForKey:@"uncodableProperty"];
//}

//- (void)encodeWithCoder:(NSCoder *)coder	{
//	[super encodeWithCoder:coder];
//	[coder encodeObject:@"uncodable" forKey:@"uncodableProperty"];
//}
//+ (NSA*) fengshui {
//	return [[self class] fengShui];
//}
//+ (NSA*) fengShui {
//	return [[NSColor fengshui].reversed arrayUsingBlock:^id(id obj) {
//		AZFile *t = [AZFile instance];
//		t.color = obj;
//		return t;
//	}];
//		//		dummy];		t.color = (NSColor*)obj; t.spot = 22;	return t;	}];
//}
//NSArray *AllApplications(NSArray *searchPaths) {
//	NSMutableArray *applications = [NSMutableArray array];
//	NSEnumerator *searchPathEnum = [searchPaths objectEnumerator]; NSString *path;
//	while (path = [searchPathEnum nextObject]) ApplicationsInDirectory(path, applications);
//	return ([applications count]) ? applications : nil;
//}
+ (NSA*) runningApps {

	return [[[self class] runningAppsAsStrings] arrayUsingBlock:^id(id obj) {
		return [AZFile instanceWithPath:obj];
	}];
}

+ (NSA*) runningAppsAsStrings {

	return [[[[[[[NSWorkspace sharedWorkspace] runningApplications] filter:^BOOL(NSRunningApplication *obj) {
		return 	obj.activationPolicy == NSApplicationActivationPolicyProhibited ? 	NO : YES;
		//				obj.activationPolicy == NSApplicationActivationPolicyAccessory ?	NO : YES;
	}] valueForKeyPath:@"bundleURL"] filter:^BOOL(id object) {
		return  [object isKindOfClass:[NSURL class]] ? YES : NO;
	}] arrayUsingBlock:^id(id obj) {
		return [obj path];
	}] filter:^BOOL(id obj) {
		return 	[[obj lastPathComponent]contains:@"Google Chrome Helper.app"] 	? NO :
		[[obj lastPathComponent]contains:@"Google Chrome Worker.app"] 	? NO :
		[[obj lastPathComponent]contains:@"Google Chrome Renderer.app"] ? NO : YES;
	}];
}
static void soundCompleted(SystemSoundID soundFileObject, void *clientData) {
	if (soundFileObject != kSystemSoundID_UserPreferredAlert)	 // Clean up.
		AudioServicesDisposeSystemSoundID(soundFileObject);
}

- (void)playNotificationSound:(NSDictionary *)apsDictionary
{
	// App could implement its own preferences so the user could specify if they want sounds or alerts.
	// if (userEnabledSounds)
	NSString *soundName = (NSString *)[apsDictionary valueForKey:(id)@"sound"];
	if (soundName != nil) {
		SystemSoundID soundFileObject   = kSystemSoundID_UserPreferredAlert;
		CFURLRef soundFileURLRef		= NULL;
		if ([soundName compare:@"default"] != NSOrderedSame) {
			// Get the main bundle for the app.
			CFBundleRef mainBundle = CFBundleGetMainBundle();
			// Get the URL to the sound file to play. The sound property's value is the full filename including the extension.
			soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (__bridge CFStringRef)soundName,NULL,NULL);
			// Create a system sound object representing the sound file.
			AudioServicesCreateSystemSoundID(soundFileURLRef, &soundFileObject);
			CFRelease(soundFileURLRef);
		}
		// Register a function to be called when the sound is done playing.
		AudioServicesAddSystemSoundCompletion(soundFileObject, NULL, NULL, soundCompleted, NULL);
		// Play the sound.
		AudioServicesPlaySystemSound(soundFileObject);
	}
}
- (void)badgeApplicationIcon:(NSString*)string
{
	NSDockTile *dockTile = [[NSApplication sharedApplication] dockTile];
	if (string != nil)  [dockTile setBadgeLabel:string];
	else				[dockTile setBadgeLabel:nil];

}

@end
@implementation AtoZ (MiscFunctions)

+(void) say:(NSString *)thing {
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


+ (CGFloat)clamp:(CGFloat)value from:(CGFloat)minimum to:(CGFloat)maximum {
	return value = value < minimum 	 ? minimum : value > maximum ? value = maximum : value;
}

+ (CGFloat)scaleForSize:(CGSize)size inRect:(CGRect)rect {
	CGFloat hScale = rect.size.width / size.width;
	CGFloat vScale = rect.size.height / size.height;
	return  MIN(hScale, vScale);
}

+ (CGRect)centerSize:(CGSize)size inRect:(CGRect)rect {
	CGFloat scale = [[self class] scaleForSize:size inRect:rect];
	return AZMakeRect(	CGPointMake ( rect.origin.x + 0.5 * (rect.size.width  - size.width),
									 rect.origin.y + 0.5 * (rect.size.height - size.height) ),
					  CGSizeMake(size.width * scale, size.height * scale) );
}

+ (CGPoint)centerOfRect:(CGRect)rect { return AZCenterOfRect(rect); }
//	CGFloat midx = CGRectGetMidX(rect);CGFloat midy = CGRectGetMidY(rect);return CGPointMake(midx, midy);
+ (NSImage*)cropImage:(NSImage*)sourceImage withRect:(NSRect)sourceRect {

	NSImage* cropImage = [[NSImage alloc] initWithSize:NSMakeSize(sourceRect.size.width, sourceRect.size.height)];
	[cropImage lockFocus];
	[sourceImage drawInRect:(NSRect){ 0, 0, sourceRect.size.width, sourceRect.size.height}
				   fromRect:sourceRect		operation:NSCompositeSourceOver fraction:1.0];
	[cropImage unlockFocus];
	return cropImage;
}

+ (NSRect) rectFromPointA:(NSPoint)pointA andPointB:(NSPoint)pointB {

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

+ (void)printCGRect:(CGRect)cgRect {	[AtoZ printRect:cgRect];	}

+ (void) printRect:(NSRect)toPrint {
	NSLog(@"Rect is x: %i y: %i width: %i height: %i ", (int)toPrint.origin.x, (int)toPrint.origin.y,
		  (int)toPrint.size.width, (int)toPrint.size.height);
}

+ (void) printCGPoint:(CGPoint)cgPoint {	[AtoZ printPoint:cgPoint];	}

+ (void) printPoint:(NSPoint)toPrint {		NSLog(@"Point is x: %f y: %f", toPrint.x, toPrint.y);	}

+ (void) printTransform:(CGAffineTransform)t {
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.a, t.b);
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.c, t.d);
	NSLog(@"[ %1.1f %1.1f 1.0 ]", t.tx, t.ty);
}

@end

@implementation  NSObject (debugandreturn)

- (id) debugReturn:(id) val{
	if ([self valueForKeyPath:@"dictionary.debug"])
		NSLog(@"Debug Return Value: %@  Info:%@", val, [(NSObject*) val propertiesPlease]);
	return val;
}
@end
//@implementation CAConstraint (brevity)
//+(CAConstraint*)maxX {
//
//	return AZConstraint(kCAConstraintMaxX,@"superlayer");
//}
//
//@end

@implementation Box
@synthesize color, save, selected, shapeLayer;
- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		shapeLayer = [CAShapeLayer layer];
		[self setLayer:shapeLayer];
		[self setWantsLayer:YES];
	}
	return self;
}
-(void) drawRect:(NSRect)dirtyRect {
	//	cotn ext
	[color set];	NSRectFill(dirtyRect);
	selected = NO;
	//	if (selected) [self lasso];
}

- (void) mouseUp:(NSEvent *)theEvent {

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
//	selected = YES;
-(void) flash:(NSColor*)savedColor {
	//	NSLog(@"FLASHING %@", savedColor);
	color = savedColor;
	[self setNeedsDisplay:YES];
	//	if (selected) {  [self drawLasso]; }
}
@end


//@implementation AGFoundation
//@synthesize speaker;

//+ (AGFoundation *)sharedInstance	{	return [super sharedInstance]; }

//- (void)setUp {

//	//	appArray = NSMA.new;
//	//	NSArray *ws =	 [[[NSWorkspace sharedWorkspace] launchedApplications] valueForKeyPath:@"NSApplicationPath"];
//	//	int k = 0;
//	//	for (NSString *path in ws) 	{
//	//		DBXApp *app = [DBXApp instanceWithPath:path];
//	//		[app setIndex:k];  k++;
//	//		[appArray addObject:app];
//	//	}
//}

//@end
//- (void)enumerateProtocolMethods:(Protocol*)p {
//// Custom block, used only in this method
//	void (^enumerate)(BOOL, BOOL) = ^(BOOL isRequired, BOOL isInstance) {
//		unsigned int descriptionCount;
//		struct objc_method_description* methodDescriptions =  protocol_copyMethodDescriptionList(p, isRequired, isInstance, &descriptionCount);
//		for (int i=0; i<descriptionCount; i++) {
//			struct objc_method_description d = methodDescriptions[i];
//			NSLog(@"Protocol method %@ isRequired=%d isInstance=%d",  NSStringFromSelector(d.name), isRequired, isInstance);
//		}
//		if (methodDescriptions)	free(methodDescriptions);
//	};
//	// Call our block multiple times with different arguments
//	// to enumerate all class, instance, required and non-required methods
//	enumerate(YES, YES);
//	enumerate(YES, NO);
//	enumerate(NO, YES);
//	enumerate(NO, NO);
//}aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa


@implementation CAAnimation (NSViewFlipper)

+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGFloat)scaleFactor {
	// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
	CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	CGFloat startValue = beginsOnTop ? 0.0f : M_PI;
	CGFloat endValue = beginsOnTop ? -M_PI : 0.0f;
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
@implementation NSView (AGAdditions)

-(CALayer *)layerFromContents
{
	CALayer *newLayer = [CALayer layer];
	newLayer.bounds = NSRectToCGRect(self.bounds);
	NSBitmapImageRep *bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
	[self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
	newLayer.contents = (id)bitmapRep.CGImage;
	return newLayer;
}

@end

@implementation NSViewFlipperController
@synthesize isFlipped;
@synthesize duration;

-(id)initWithHostView:(NSView *)newHostView frontView:(NSView *)newFrontView backView:(NSView *)newBackView
{
	if ( self = [super init] ) {
		hostView = newHostView;
		frontView = newFrontView;
		backView = newBackView;
		duration = 0.75;
	}
	return self;
}

-(void)flip {
	if ( isFlipped ) { topView = backView; bottomView = frontView; }
	else {topView = frontView; bottomView = backView; }
	CAAnimation *topAnimation = [CAAnimation flipAnimationWithDuration:duration forLayerBeginningOnTop:YES scaleFactor:1.3f];
	CAAnimation *bottomAnimation = [CAAnimation flipAnimationWithDuration:duration forLayerBeginningOnTop:NO scaleFactor:1.3f];
	bottomView.frame = topView.frame; topLayer = [topView layerFromContents]; bottomLayer = [bottomView layerFromContents];
	CGFloat zDistance = 1500.0f; CATransform3D perspective = CATransform3DIdentity;
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

-(void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag;
{
	isFlipped = !isFlipped;
	[CATransaction begin];
	[CATransaction setValue:@YES forKey:kCATransactionDisableActions];
	[hostView addSubview:bottomView];
	[topLayer removeFromSuperlayer];
	[bottomLayer removeFromSuperlayer];
	topLayer = nil; bottomLayer = nil;
	[CATransaction commit];
}

-(NSView *)visibleView
{	return (isFlipped ? backView : frontView);
}
@end


//- (id)objectForKeyedSubscript:(NSString *)key {
// return [_children objectForKey:key];
// }
//
//- (void)setObject:(id)newValue forKeyedSubscription:(NSString *)key {
//	 [_children setObject:newValue forKey:key];
//}
//

//Subclassible thread-safe ARC singleton  Copyright Kevin Lawler. Released under ISC.
@implementation AZSingleton
static NSMD* _children;
+(void) initialize { //thread-safe
	_children = !_children ? [NSMD dictionary] : _children;
	_children [NSStringFromClass([self class])] = [[self alloc] init];
}
+(id) alloc { id c; return (c = [self instance]) ? c : [self allocWithZone:nil];  }
-(id) init  { id c; if((c = _children[NSStringFromClass([self class])])) return c;  //sic, unfactored
	return  self = [super init];
}
+(id) instance {		return _children [NSStringFromClass([self class])];  }
+(id) sharedInstance { 	return [self instance];  }  //alias for instance
+(id) singleton {  		return [self instance];	}  //alias for instance
+(id) new {				return [self instance]; }	//stop other creative stuff
+(id)copyWithZone:(NSZone *)zone {			return [self instance]; }
+(id)mutableCopyWithZone:(NSZone *)zone {	return [self instance]; }

@end
