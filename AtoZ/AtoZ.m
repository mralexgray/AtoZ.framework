
//  BaseModel.m
//  Version 2.3.1

//  http://charcoaldesign.co.uk/source/cocoa#basemodel
//  https://github.com/nicklockwood/BaseModel

#import "AtoZ.h"
#import <objc/message.h>
#import <sys/time.h>


//void WithAutoreleasePool(BasicBlock block) {
////	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	@autoreleasepool {

//		block();
//	}
////	[pool release];
//}
////USAGE
//for(id obj in array) WithAutoreleasePool(^{  	[self createLotsOfTemporaryObjectsWith:obj];  });

NSString *const AZMouseNotification = @"okWindowFadeOutNow";

BOOL isPathAccessible(NSString *path, SandBox mode) {
	return access([path UTF8String], mode) == 0;
}

static CGEventRef myEventTapCallback (	CGEventTapProxy proxy,	CGEventType type,	CGEventRef event,	void * refcon ) {

	// If we would get different kind of events, we can distinguish them by the variable "type", but we know we only get mouse moved events
    CGPoint mouseLocation = CGEventGetLocation(event);
    printf(	"Mouse is at x/y: %u/%u\n",(unsigned int)mouseLocation.x,  (unsigned int)mouseLocation.y );
	[[ NSNotificationCenter defaultCenter] postNotificationName:@"mouseMoved" object:nil];

	// Pass on the event, we must not modify it anyway, we are a listener
    return event;
}



void trackMouse() {

	CGEventMask emask;
	CFMachPortRef myEventTap;
	CFRunLoopSourceRef eventTapRLSrc;

	// We only want one kind of event at the moment: The mouse has moved
	emask = CGEventMaskBit(kCGEventMouseMoved);			// Create the Tap
	myEventTap = CGEventTapCreate (		kCGSessionEventTap, // Catch all events for current user session
								   		kCGTailAppendEventTap, // Append to end of EventTap list
								   		kCGEventTapOptionListenOnly, // We only listen, we don't modify
								   		emask,	&myEventTapCallback, NULL // We need no extra data in the callback
	);																		// Create a RunLoop Source for it
	eventTapRLSrc = CFMachPortCreateRunLoopSource(		kCFAllocatorDefault,	myEventTap,   0		);
	// Add the source to the current RunLoop
	CFRunLoopAddSource(		CFRunLoopGetCurrent(),		eventTapRLSrc, 		kCFRunLoopDefaultMode   );
	// Keep the RunLoop running forever
	CFRunLoopRun();
}


	// In a source file
NSString *const FormatTypeName[FormatTypeCount] = {
	[JSON] = @"JSON",
	[XML] = @"XML",
	[Atom] = @"Atom",
	[RSS] = @"RSS",
};

NSString *const AZOrientName[AZOrientCount] = {
	[AZOrientTop] = @"Top",
	[AZOrientLeft] = @"Left",
	[AZOrientBottom] = @"Bottom",
	[AZOrientRight] = @"Right",
	[AZOrientFiesta] = @"Fiesta",
//	[AZOrientCount] = @"Count",
};

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;


@implementation AtoZ
{
	BOOL fontsRegistered;
}
//@synthesize appFolder, appFolderSorted;//, console;
//@synthesize dock, dockSorted;

+ (NSString*)stringForType:(id)type
{

	Class i = [type class];
	NSLog(@"String: %@   Class:%@", NSStringFromClass(i), i);
//	[type autoDescribe:type];
	NSString *key = [NSString stringWithFormat:@"AZOrient_%@", NSStringFromClass([type class])];
	return NSLocalizedString(key, nil);
}


//{//	__weak AZSimpleView *e;
//}
//	console = [NSLogConsole sharedConsole]; [console open];

#define kMaxFontSize    10000

+ (CGFloat)fontSizeForAreaSize:(NSSize)areaSize withString:(NSString *)stringToSize usingFont:(NSString *)fontName;
{
    NSFont * displayFont = nil;
    NSSize stringSize = NSZeroSize;
    NSMutableDictionary * fontAttributes = [[NSMutableDictionary alloc] init];

    if (areaSize.width == 0.0 && areaSize.height == 0.0)
        return 0.0;

    NSUInteger fontLoop = 0;
    for (fontLoop = 1; fontLoop <= kMaxFontSize; fontLoop++) {
        displayFont = [[NSFontManager sharedFontManager] convertWeight:YES ofFont:[NSFont fontWithName:fontName size:fontLoop]];
        [fontAttributes setObject:displayFont forKey:NSFontAttributeName];
        stringSize = [stringToSize sizeWithAttributes:fontAttributes];

        if (stringSize.width > areaSize.width)
            break;
        if (stringSize.height > areaSize.height)
            break;
    }

    [fontAttributes release], fontAttributes = nil;

    return (CGFloat)fontLoop - 1.0;
}


- (void) setUp {

	char *xcode_colors = getenv(XCODE_COLORS);

	if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
	{
			// XcodeColors is installed and enabled!
	}


	[DDLog addLogger:[DDTTYLogger sharedInstance]];

//	DDLogVerbose(@"Verbose");
//	DDLogInfo(@"Info");
//	DDLogWarn(@"Warn");
//	DDLogError(@"Error");

//	[self registerFonts:<#(CGFloat)#>]
//	self.dockOutline = dock.copy;
//	self.sortOrder = AZDockSortNatural;
}

- (NSBundle*) bundle {
	return [NSBundle bundleForClass:[self class]];
}
#ifdef GROWL_ENABLED
- (BOOL) registerGrowl {
//	AtoZ *u = [[self class] sharedInstance];


	NSString *growlPath = [[self.bundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
	NSLog(@"growl path: %@ ", growlPath);
	NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];
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

+(NSFont*) fontWithSize:(CGFloat)fontSize {
	return 	[[AtoZ sharedInstance] registerFonts:fontSize];
}
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (NSFont*) registerFonts:(CGFloat)size {
	if (!fontsRegistered) {
		NSBundle *aBundle = [NSBundle bundleForClass: [AtoZ class]];
		NSURL *fontsURL = [NSURL fileURLWithPath:$(@"%@/Fonts",[aBundle resourcePath])];
		if(fontsURL != nil)	{
			OSStatus status;		FSRef fsRef;
			CFURLGetFSRef((CFURLRef)fontsURL, &fsRef);
			status = ATSFontActivateFromFileReference(&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified, NULL, kATSOptionFlagsDefault, NULL);
			if (status != noErr)		{
//				theError = @"Failed to acivate fonts!";  goto error;
			} else  { fontsRegistered = 1; NSLog(@"Fonts registered!"); }
		} else NSLog(@"couldnt register fonts!");
	}
	return  [NSFont fontWithName:@"UbuntuTitling-Bold" size:size];
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"





 -(NSArray*)dockSorted {

[[[!_dock ? self.dock : _dock sortedWithKey:@"hue" ascending:YES] reversed] arrayUsingIndexedBlock:^id(AZFile* obj, NSUInteger idx) {
			//		if ([obj.name isEqualToString:@"Finder"]) {
			//		obj.spotNew = 999;
			//		obj.dockPointNew = obj.dockPoint;
			//		} else {
		obj.spotNew = idx;
		obj.dockPointNew = [[[_dock objectAtIndex:idx]valueForKey:@"dockPoint"]pointValue];
		return obj;
	}];
	// arrayUsingIndexedBlock:^id(AZFile* obj, NSUInteger idx) {
	//			NSLog(@"dockquery item: %@", [obj allKeys]);

}

//+ (NSArray*) dockOutline {
//	return [super sharedInstance].dockOutline;
//}
//- (NSArray*)dockOutline {
//	return _dockOutline;// ? _dockOutline : [AZDockQuery dock]);
//}

+ (NSArray*) dock {
	return [AtoZ sharedInstance].dock ;
}
- (NSArray*) dock {

	if (!_dock)
		self.dock = [AZDockQuery dock];
	return _dock;
//NSLog(@"dock got:  %@", _dock); 
}

+ (NSArray*) currentScope {
	return [AtoZ sharedInstance].dockSorted;
}
+ (NSArray*) dockSorted {

	return [AtoZ sharedInstance].dockSorted;
}
+ (NSArray*) appCategories {

	return [AtoZ sharedInstance].appCategories;
}




- (NSArray*) appCategories {
//	static NSArray *cats;
//    if (cats == nil) {
			return  @[ 	@"Games",		@"Education",		@"Entertainment",	@"Books",	@"Lifestyle",
		@"Utilities",	@"Business", 		@"Travel",			@"Music", 	@"Reference",
		@"Sports",		@"Productivity",	@"News", 			@"Healthcare & Fitness",
		@"Photography", @"Finance", 		@"Medical", 			@"Social Networking",
		@"Navigation",	@"Weather",			@"Catalogs", 		@"Food & Drink",
		@"Newsstand" ];
//[NSArray alloc] initWithObjects:kCategoryNames count:23];
//    }
//    return cats;
}
+ (NSJSONSerialization*) jsonReuest:(NSString*)url {
	AtoZ *me = [[self class] sharedInstance];
	return  [me jsonReuest:url];
}

+ (NSUserDefaults *)defs {
	return [NSUserDefaults standardUserDefaults];
}

/*- (id)objectForKeyedSubscript:(NSString *)key {
	return [self objectForKey:key];
}
- (void)setObject:(id)newValue forKeyedSubscription:(NSString *)key {
	[self setObject:newValue forKey:key];
}
*/

-(void) mouseSelector {

	NSLog(@"selectot triggered!  by notificixation, even!");
}

- (NSJSONSerialization*) jsonReuest:(NSString*)url {
	NSError *err;
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
				 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
	NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:&err];
	if (!responseData) NSLog(@"Connection Error: %@", [err localizedDescription]);

//    NSError *error;
	
	return  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];

//    if (err) {
//        NSAlert *alert = [NSAlert alertWithMessageText:@"Error parsing JSON" defaultButton:@"Damn that sucks" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Check your JSON"];
//        [alert beginSheetModalForWindow:[[NSApplication sharedApplication]mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
//        return;
//    }
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
//	return _dock;
*/
//}/

//- (NSArray*) dockSorted {

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

+ (NSArray*) selectedDock{
	AtoZ *shared =  [super sharedInstance];
	AZDockSort sortorder = shared.sortOrder;
	switch (sortorder) {
		case AZDockSortNatural:
			return shared.dock;
			break;
		case AZDockSortColor:
			return shared.dockSorted;
		default:
			return shared.dock;
			break;
			//			return NSArray *a = @[$int(66) to:$int(66)];// arrayUsingBlock:^id(id obj) {
			//
			//			}];

			//		[[NSThread mainThread] performBlock:^{
			//		} waitUntilDone:YES];
			//		performBlockInBackground:^{
			//		}];			break;
	}
}

//+ (NSMutableArray*) dockSorted {
// [AZStopwa /tch start:@"dockSorted"];

//	if (! [AtoZ sharedInstance].dockSorted ){
// NSLog(@"sorted noexista!.  does docko? : %@");
//		[AtoZ sharedInstance]_dockSorted = [[[AtoZ dock] sortedWithKey:@"hue" ascending:YES] reversed].mutableCopy;
//	}
//	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:AtoZDockSortedUpdated object:[AtoZ sharedInstance].dockSorted];
// NSLog(@"was it made?  dsorted:%@", [AtoZ sharedInstance]._dockSorted);
// [AZStopwatch stop:@"dockSorted"];
//	[NSThread performAZBlockOnMainThread:^{
//		[[NSApp delegate] setValue:
//			[[AtoZ sharedInstance]. dockSorted arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
//				AZFile *block = obj;
//				AZInfiniteCell * ee = [AZInfiniteCell new];
//				ee.file = block;
//				ee.backgroundColor = block.color;
//				return ee;
//			}] forKeyPath:@"infiniteBlocks.infiniteViews"];
//	}];
// return  [AtoZ sharedInstance].dockSorted;
//}

//	if ([AtoZ sharedInstance].dockSorted) {
//		NSLog(@"preexisting sort! ");
//		return [AtoZ sharedInstance].dockSorted;
//	}
//	[AtoZ sharedInstance].dockSorted = [[[[AtoZ dock] sortedWithKey:@"hue" ascending:YES] reversed] arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
//		AZFile* app = obj;
//		app.spotNew = idx;
//		app.dockPointNew = [[[self.dock objectAtIndex:app.spotNew] valueForKey:@"dockPoint"]pointValue];
//		return app;
//	}];
// where you would call a delegate method (e.g. [self.delegate doSomething])
// object:nil userInfo:nil]; /* dictionary containing variables to pass to the delegate */
//	return [AtoZ sharedInstance ].dockSorted;
//}

//- (void)performBlock:(void (^)())block {
//	if ([[NSThread currentThread] isEqual:[self curr])
//		block();
//	else
//		[self performBlock:block waitUntilDone:NO];
//}
//- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait {
//	NSThread *newThread = [NSThread new];
//    [NSThread performSelector:@selector(az_runBlock:)
//                     onThread:newThread
//                   withObject:[block copy]
//                waitUntilDone:wait];
//}
//+ (void)az_runBlock:(void (^)())block { block(); }
//+ (void)performBlockInBackground:(void (^)())block {
//	[NSThread performSelectorInBackground:@selector(az_runBlock:) withObject:[block copy]];
//}
+ (NSArray*) appFolderSorted {
	if (! [AtoZ sharedInstance].appFolderSorted )
		[AtoZ sharedInstance].appFolderSorted = [[[AtoZ appFolder] sortedWithKey:@"hue" ascending:YES] reversed].mutableCopy;
	return  [AtoZ sharedInstance].appFolderSorted;
}


- (NSArray *) appFolderStrings {
	if (!_appFolderStrings) {
		[AZStopwatch start:@"appFolderStrings"];
		NSMutableArray *applications = [NSMutableArray array];
		ApplicationsInDirectory(@"/Applications", applications);
		_appFolderStrings = applications.copy;
		[AZStopwatch stop:@"appFolderStrings"];
	}
	return  _appFolderStrings;
}

- (NSArray*) appFolder {
	if (!_appFolder) {
		[AZStopwatch start:@"appFolder"];
		_appFolder = [_appFolderStrings ? self.appFolderStrings : _appFolderStrings  arrayUsingBlock:^id(id obj) {
		return	[AZFile instanceWithPath:obj];
		}];
		[AZStopwatch stop:@"appFolder"];
	}
	return _appFolder;
}

+ (NSArray*) appFolder {

//	[AZStopwatch start:@"appFolder"];
//	if (! [AtoZ sharedInstance].appFolder ) {
//		NSMutableArray *applications = [NSMutableArray array];
//		ApplicationsInDirectory(@"/Applications", applications);
//		[AtoZ sharedInstance].appFolder = [NSMutableArray array];
//	}
//	[AZStopwatch stop:@"appFolder"];
	//	[[AtoZ sharedInstance] useHRCoderIfAvailable];
	//	NSLog(@"%@", [[AtoZ sharedInstance] codableKeys]);
	//	[[AtoZ sharedInstance] writeToFile:@"/Users/localadmin/Desktop/poop.plist" atomically:NO];

	return [AtoZ sharedInstance].appFolder;
}

+ (NSArray*) appFolderSamplerWith:(NSUInteger)apps {

	[AZStopwatch start:@"appFolderSampler"];
	return [[[AtoZ sharedInstance].appFolderStrings randomSubarrayWithSize:apps] arrayUsingBlock:^id(id obj) {
				return [AZFile instanceWithPath:obj];
	}];

	[AZStopwatch stop:@"appFolderSampler"];
}



- (void) handleMouseEvent:(NSEventMask)event inView:(NSView*)view withBlock:(void (^)())block {
	if (self != [AtoZ sharedInstance]) {
		NSLog(@"uh oh, not a shared I");
		//		__typeof__(self) *aToZ = [AtoZ sharedInstance];
		//		__typeof__(self) *aToZ = [AtoZ sharedInstance];

	}
	[NSEvent addLocalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^NSEvent *(NSEvent *event) {
		//		if ([event type] == NSMouseMovedMask ) {
		NSLog(@"Mouse handler checking point for evet:%@.", event);
		NSPoint localP = view.localPoint;
		if ( NSPointInRect(localP, view.frame) ){
			NSLog(@"oh my god.. point is local to view! Runnnng block");
			[[NSThread mainThread] performBlock:block waitUntilDone:YES];
			//			[NSThread performBlockInBackground:block];
		}
		return event;
	}];
	return;
}

//- (NSArray *)uncodableKeys
//{
//    return [[AtoZ sharedInstance] uncodableKeys];
//	//[NSArray arrayWithObject:@"uncodableProperty"];
//}

//- (void)setWithCoder:(NSCoder *)coder
//{
//    [super setWithCoder:coder];
////    self. = DECODE_VALUE([coder decodeObjectForKey:@"uncodableProperty"];
//}

//- (void)encodeWithCoder:(NSCoder *)coder	{
//    [super encodeWithCoder:coder];
//    [coder encodeObject:@"uncodable" forKey:@"uncodableProperty"];
//}
//+ (NSArray*) fengshui {
//	return [[self class] fengShui];
//}
+ (NSArray*) fengShui {
	return [[NSColor fengshui].reversed arrayUsingBlock:^id(id obj) {
		 AZFile *t = [AZFile instance];
		 t.color = obj;
		 return t;
	}];
//		dummy];		t.color = (NSColor*)obj; t.spot = 22;	return t;	}];
}

void ApplicationsInDirectory(NSString *searchPath, NSMutableArray *applications) {
    BOOL isDir;
    NSFileManager *manager = [NSFileManager defaultManager];
//    NSArray *files = [manager directoryContentsAtPath:searchPath];
    NSArray *files = [manager contentsOfDirectoryAtPath:searchPath error:nil];
    NSEnumerator *fileEnum = [files objectEnumerator]; NSString *file;
    while (file = [fileEnum nextObject]) {
        [manager changeCurrentDirectoryPath:searchPath];
        if ([manager fileExistsAtPath:file isDirectory:&isDir] && isDir) {
            NSString *fullpath = [searchPath stringByAppendingPathComponent:file];
            if ([[file pathExtension] isEqualToString:@"app"]) [applications addObject:fullpath];
            else ApplicationsInDirectory(fullpath, applications);
        }
    }
}

//NSArray *AllApplications(NSArray *searchPaths) {
//    NSMutableArray *applications = [NSMutableArray array];
//    NSEnumerator *searchPathEnum = [searchPaths objectEnumerator]; NSString *path;
//    while (path = [searchPathEnum nextObject]) ApplicationsInDirectory(path, applications);
//    return ([applications count]) ? applications : nil;
//}


+ (NSArray*) runningApps {

	return [[[[NSWorkspace sharedWorkspace] runningApplications] valueForKeyPath:@"bundleURL"] arrayUsingBlock:^id(id obj) {
		if ([obj isKindOfClass:[NSURL class]])
			return [AZFile instanceWithPath:[obj path]];
		else return nil;
	}];
}

+ (NSArray*) runningAppsAsStrings {

	return [[[[NSWorkspace sharedWorkspace] runningApplications] valueForKeyPath:@"bundleURL"] arrayUsingBlock:^id(id obj) {
		if ([obj isKindOfClass:[NSURL class]])
			return [obj path];
		else return nil;
	}];
}


static void soundCompleted(SystemSoundID soundFileObject, void *clientData) {
    if (soundFileObject != kSystemSoundID_UserPreferredAlert)     // Clean up.
        AudioServicesDisposeSystemSoundID(soundFileObject);
}

- (void)playNotificationSound:(NSDictionary *)apsDictionary
{
    // App could implement its own preferences so the user could specify if they want sounds or alerts.
    // if (userEnabledSounds)
    NSString *soundName = (NSString *)[apsDictionary valueForKey:(id)@"sound"];
    if (soundName != nil) {
        SystemSoundID soundFileObject   = kSystemSoundID_UserPreferredAlert;
        CFURLRef soundFileURLRef        = NULL;
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
@implementation AZColor
@synthesize 	brightness, 	saturation,		hue;
@synthesize 	percent, 		count;
@synthesize  	name, 			color;
@synthesize 	hueComponent;
+ (AZColor*) instanceWithObject: (NSDictionary *)dic {
	AZColor *color = [self instance];
	if (dic[@"color"]) color.color   = dic[@"color"]; else return nil;
	color.name 	  = ( dic[@"name"]   ? [dic valueForKey:@"name"]    : nil );
	color.count   = ( [dic valueForKey:@"count"]   ? [[dic valueForKey:@"count"]intValue]     : 0);
	color.percent =	( [dic valueForKey:@"percent"] ? [[dic valueForKey:@"percent"]floatValue] : 0);
	return color;
}
-(CGFloat) saturation {	return [self.color saturationComponent]; }
-(CGFloat) hue 		  {	return [self.color hueComponent];		 }
-(CGFloat) brightness {	return [self.color brightnessComponent]; }
-(CGFloat) hueComponent  {	return [self.color hueComponent];		 }

@end


NSString *const AZFileUpdated = @"AZFileUpdated";

@implementation AZFile
@synthesize path, name, color, customColor, labelColor, icon, image;
@synthesize dockPoint, dockPointNew, spot, spotNew;
@synthesize hue, isRunning, hasLabel, needsToMove, labelNumber;
//@synthesize itunesInfo, itunesDescription;


+ (AZFile*) forAppNamed:(NSString*)appName  {

	return [[[AtoZ dock] valueForKeyPath:@"name"]  filterOne:^BOOL(id object) {
		return ([object isEqualTo:appName] ? YES : NO);
	}];
}


- (NSString *) calulatedBundleID {
    NSWorkspace * workspace = [NSWorkspace sharedWorkspace];
	NSBundle * appBundle = [NSBundle bundleWithPath:self.path];
	return [appBundle bundleIdentifier];
}

//- (NSString*) itunesDescription {
//	return self.itunesInfo.itemDescription;
//}

//- (AJSiTunesResult *) itunesInfo {

//	return  [AtoZiTunes resultsForName:self.name];
//}


+ (AZFile*) dummy {
	return [AZFile instanceWithPath:@"/System/Library/CoreServices/Dock.app/Contents/Resources/notloaded.icns"];
}

+ (id) instanceWithColor: (NSColor*)color {
	AZFile*d = [AZFile instance];
	d.color = color;
	return d;
}

+ (id)instanceWithPath:(NSString *)path {

	AZFile *dd = [AZFile instance];//WithObject:path];
	dd.path = path;
	dd.name = [[path lastPathComponent] stringByDeletingPathExtension];
	NSWorkspace *ws =	[NSWorkspace sharedWorkspace];
	NSImage *u = [[ws iconForFile:path]scaleToFillSize:AZSizeFromDimension(512)];
	dd.image = (u ? u : [NSImage imageInFrameworkWithFileName:@"missing.png"]);
	NSBundle * appBundle = [NSBundle bundleWithPath:path];
	dd.calulatedBundleID = appBundle ? [appBundle bundleIdentifier] : @"unknown";
	dd.color = dd.colors ? [(AZColor*)[dd.colors objectAtNormalizedIndex:0] color] : RED;
//	labelColor = [self labelColor];
//	if (labelColor) labelNumber = [self labelNumber];
//	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:AZFileUpdated object:[AtoZ sharedInstance].dockSorted];



	//	[[NSThread mainThread]performBlock:^{
	return dd;
}

//- (void) setUp {
	//	[NSThread performBlockInBackground:^{
	//}];// waitUntilDone:YES];


//}
-(NSArray*) colors {

	if (_colors) return  _colors;
	else {
	@autoreleasepool {

		NSArray *rawArray = [self.image quantize];
		// put all colors in a bag
		NSBag *allBag = [NSBag bag];
		for (id thing in rawArray ) [allBag add:thing];
		NSBag *rawBag = [NSBag bag];
		int total = 0;
		for ( NSColor *aColor in rawArray ) {
			//get rid of any colors that account for less than 10% of total
			if ( ( [allBag occurrencesOf:aColor] > ( .0005 * [rawArray count]) )) {
				// test for borigness
				if ( [aColor isBoring] == NO ) {
					NSColor *close = [aColor closestNamedColor];
					total++;
					[rawBag add:close];
				}
			}
		}
		NSArray *exciting = 	[[rawBag objects] filter:^BOOL(id object) {
			NSColor *idColor = object;
			return ([idColor isBoring] ? FALSE : TRUE);
		}];

		//uh oh, too few colors
		if ( ([[rawBag objects]count] < 2) || (exciting.count < 2 )) {
			for ( NSColor *salvageColor in rawArray ) {
				NSColor *close = [salvageColor closestNamedColor];
				total++;
				[rawBag add:close];
			}
		}
		NSMutableArray *colorsUnsorted = [NSMutableArray array];

		for (NSColor *idColor in [rawBag objects] ) {

			AZColor *acolor = [AZColor instance];
			acolor.color = idColor;
			acolor.count = [rawBag occurrencesOf:idColor];
			acolor.percent = ( [rawBag occurrencesOf:idColor] / (float)total );
			[colorsUnsorted addObject:acolor];
		}
		rawBag = nil; allBag = nil;
		return [colorsUnsorted sortedWithKey:@"count" ascending:NO];
	}
	}
}
//- (NSColor*) color {
//	NSLog(@"color for %@:  %@", self.name, (color ? color : [[self.colors objectAtNormalizedIndex:0] valueForKey:@"color"]));
//	return (color ? color : [[self.colors objectAtNormalizedIndex:0] valueForKey:@"color"]);
//}

- (CGFloat) hue { return self.color.hueComponent; }



- (BOOL) isRunning {

	return  ([[[[NSWorkspace sharedWorkspace] runningApplications] valueForKeyPath:@"localizedName"]containsObject:self.name] ? YES : NO);
}

- (NSColor*) labelColor {
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	NSDictionary *d = [fileURL resourceValuesForKeys:$array(NSURLLabelColorKey) error:nil];
	return ( [d valueForKey:NSURLLabelColorKey]  ? (NSColor*) [d valueForKey:NSURLLabelColorKey] : nil);
}


- (NSNumber*) labelNumber {
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	NSDictionary *d = [fileURL resourceValuesForKeys:$array(NSURLLabelNumberKey) error:nil];
	return ( [d valueForKey:NSURLLabelNumberKey] ? [d valueForKey:NSURLLabelNumberKey] : nil);
	//	You can use both the NSURLLabelNumberKey to get the number of the Finder's assigned label or the NSURLLabelColorKey to get the actual color.

}
- (void)setLabelColor:(NSColor *)aLabelColor {
	NSError *error = nil;
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	[fileURL setResourceValue:(id)aLabelColor forKey:NSURLLabelColorKey error:&error];
	if (error) NSLog(@"Problem setting label for %@", self.name);
}
- (void)setLabelNumber:(NSNumber*)aLabelNumber {
	NSError *error = nil;
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	[fileURL setResourceValue:aLabelNumber forKey:NSURLLabelNumberKey error:&error];
	if (error) NSLog(@"Problem setting label (#) for %@", self.name);
    return;
}

@end

void _AZSimpleLog(const char *file, int lineNumber, const char *funcName, NSString *format,...){
	va_list argList;
	va_start (argList, format);
	NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
//	fprintf (stderr, "%s \n", [message UTF8String]);
	va_end  (argList);
//	const char *threadName = [[[NSThread currentThread] name] UTF8String];
}

void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...) {
	va_list arglist;

	va_start (arglist, format);
	if (![format hasSuffix: @"\n"]) {
		format = [format stringByAppendingString: @"\n"];
	}
	NSString *body =  [[NSString alloc] initWithFormat: format arguments: arglist];
	va_end (arglist);
	const char *threadName = [[[NSThread currentThread] name] UTF8String];
	NSString *fileName=[[NSString stringWithUTF8String:file] lastPathComponent];
//	if (threadName) {
//		fprintf(stderr,"%s/%s (%s:%d) %s",threadName,funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
//	} else {
//		fprintf(stderr,"%p/%s (%s:%d) %s",[NSThread currentThread],funcName,[fileName UTF8String],lineNumber,[body UTF8String]);
//	}
#ifdef PRINTMETHODS
	fprintf(stderr,"%s:%d [%s] %s",[fileName UTF8String],lineNumber,funcName, [body UTF8String]);
#else
	fprintf(stderr,"line:%d %s",lineNumber, [body UTF8String]);
#endif
		//
	[body release];
}

void _AZLog(const char *file, int lineNumber, const char *funcName, NSString *format,...);

void QuietLog (const char *file, int lineNumber, const char *funcName, NSString *format, ...) {
    if (format == nil) {
        printf("nil\n");
        return;
    }
		// Get a reference to the arguments that follow the format parameter
    va_list argList;
    va_start(argList, format);
		// Perform format string argument substitution, reinstate %% escapes, then print
    NSString *s = [[NSString alloc] initWithFormat:format arguments:argList];
    printf("%s\n", [[s stringByReplacingOccurrencesOfString:@"%%" withString:@"%%%%"] UTF8String]);
    [s release];
    va_end(argList);
}

//void NSLog (NSString *format, ...) {	va_list argList;	va_start (argList, format);
//	NSString *message = [[NSString alloc] initWithFormat:format arguments:argList];
//	fprintf (stderr, "*** %s ***\n", [message UTF8String]); 	va_end  (argList);
//} // QuietLog


@implementation  NSObject (debugandreturn)

- (id) debugReturn:(id) val{
	if ([self valueForKeyPath:@"dictionary.debug"])
		NSLog(@"Debug Return Value: %@  Info:%@", val, [(NSObject*) val propertiesPlease]);
	return val;
}
@end



int max(int x, int y)
{
    return x > y ? x : y;
}


@implementation  NSNumber (Incrementer)
- (NSNumber *)increment {
	return @([self intValue]+1);
}
@end


@implementation CAConstraint (brevity)
+(CAConstraint*)maxX {

	return AZConstraint(kCAConstraintMaxX,@"superlayer");
}

@end

@implementation CALayer (AGFlip)
- (void) flipOver {
	[CATransaction setValue:@3.0f
					 forKey:kCATransactionAnimationDuration];
	self.position = CGPointMake(.5,.5);
	self.transform = CATransform3DMakeRotation(DEG2RAD(180), 0.0f, 1.0f, 0.0f);
}
@end


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




//@interface  NSArray (SubscriptsAdd)
//- (id)objectAtIndexedSubscript:(NSUInteger)index;
//@end

//@interface NSMutableArray (SubscriptsAdd)
//- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;
//@end
//@interface  NSDictionary (SubscriptsAdd)
//- (id)objectForKeyedSubscript:(id)key;
//@end
//@interface  NSMutableDictionary (SubscriptsAdd)
//- (void)setObject:(id)object forKeyedSubscript:(id)key;
//@end


#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
#include <Availability.h>
#endif //  TARGET_OS_IPHONE

// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
#define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
#define MAC_OS_X_VERSION_10_6 1060
#endif
#ifndef MAC_OS_X_VERSION_10_7
#define MAC_OS_X_VERSION_10_7 1070
#endif

// Not all __IPHONE_X macros defined in past SDKs
#ifndef __IPHONE_3_0
#define __IPHONE_3_0 30000
#endif
#ifndef __IPHONE_3_1
#define __IPHONE_3_1 30100
#endif
#ifndef __IPHONE_3_2
#define __IPHONE_3_2 30200
#endif
#ifndef __IPHONE_4_0
#define __IPHONE_4_0 40000
#endif
#ifndef __IPHONE_4_3
#define __IPHONE_4_3 40300
#endif
#ifndef __IPHONE_5_0
#define __IPHONE_5_0 50000
#endif

// ----------------------------------------------------------------------------
// CPP symbols that can be overridden in a prefix to control how the toolbox
// is compiled.
// ----------------------------------------------------------------------------


// By setting the _CONTAINERS_VALIDATION_FAILED_LOG and
// GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
// when a validation fails. If you implement your own validators, you may want
// to control their internals using the same macros for consistency.
#ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
#define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
#endif

// Give ourselves a consistent way to do inlines.  Apple's macros even use
// a few different actual definitions, so we're based off of the foundation
// one.
#if !defined(GTM_INLINE)
#if (defined (__GNUC__) && (__GNUC__ == 4)) || defined (__clang__)
#define GTM_INLINE static __inline__ __attribute__((always_inline))
#else
#define GTM_INLINE static __inline__
#endif
#endif

// Give ourselves a consistent way of doing externs that links up nicely
// when mixing objc and objc++
#if !defined (GTM_EXTERN)
#if defined __cplusplus
#define GTM_EXTERN extern "C"
#define GTM_EXTERN_C_BEGIN extern "C" {
#define GTM_EXTERN_C_END }
#else
#define GTM_EXTERN extern
#define GTM_EXTERN_C_BEGIN
#define GTM_EXTERN_C_END
#endif
#endif

// Give ourselves a consistent way of exporting things if we have visibility
// set to hidden.
#if !defined (GTM_EXPORT)
#define GTM_EXPORT __attribute__((visibility("default")))
#endif

// Give ourselves a consistent way of declaring something as unused. This
// doesn't use __unused because that is only supported in gcc 4.2 and greater.
#if !defined (GTM_UNUSED)
#define GTM_UNUSED(x) ((void)(x))
#endif

// _GTMDevLog & _GTMDevAssert

// _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
// developer level errors.  This implementation simply macros to NSLog/NSAssert.
// It is not intended to be a general logging/reporting system.

// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
// for a little more background on the usage of these macros.

//    _GTMDevLog           log some error/problem in debug builds
//    _GTMDevAssert        assert if conditon isn't met w/in a method/function
//                           in all builds.

// To replace this system, just provide different macro definitions in your
// prefix header.  Remember, any implementation you provide *must* be thread
// safe since this could be called by anything in what ever situtation it has
// been placed in.


// We only define the simple macros if nothing else has defined this.
#ifndef _GTMDevLog

#ifdef DEBUG
#define _GTMDevLog(...) NSLog(__VA_ARGS__)
#else
#define _GTMDevLog(...) do { } while (0)
#endif

#endif // _GTMDevLog

#ifndef _GTMDevAssert
// we directly invoke the NSAssert handler so we can pass on the varargs
// (NSAssert doesn't have a macro we can use that takes varargs)
#if !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _GTMDevAssert

// _GTMCompileAssert
// _GTMCompileAssert is an assert that is meant to fire at compile time if you
// want to check things at compile instead of runtime. For example if you
// want to check that a wchar is 4 bytes instead of 2 you would use
// _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
// Note that the second "arg" is not in quotes, and must be a valid processor
// symbol in it's own right (no spaces, punctuation etc).

// Wrapping this in an #ifndef allows external groups to define their own
// compile time assert scheme.
#ifndef _GTMCompileAssert
// We got this technique from here:
// http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

#define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
#define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
#define _GTMCompileAssert(test, msg) \
typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _GTMCompileAssert

// ----------------------------------------------------------------------------
// CPP symbols defined based on the project settings so the GTM code has
// simple things to test against w/o scattering the knowledge of project
// setting through all the code.
// ----------------------------------------------------------------------------

// Provide a single constant CPP symbol that all of GTM uses for ifdefing
// iPhone code.
#if TARGET_OS_IPHONE // iPhone SDK
// For iPhone specific stuff
#define GTM_IPHONE_SDK 1
#if TARGET_IPHONE_SIMULATOR
#define GTM_IPHONE_SIMULATOR 1
#else
#define GTM_IPHONE_DEVICE 1
#endif  // TARGET_IPHONE_SIMULATOR
// By default, GTM has provided it's own unittesting support, define this
// to use the support provided by Xcode, especially for the Xcode4 support
// for unittesting.
#ifndef GTM_IPHONE_USE_SENTEST
#define GTM_IPHONE_USE_SENTEST 0
#endif
#else
// For MacOS specific stuff
#define GTM_MACOS_SDK 1
#endif

// Some of our own availability macros
#if GTM_MACOS_SDK
#define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
#define GTM_AVAILABLE_ONLY_ON_MACOS
#else
#define GTM_AVAILABLE_ONLY_ON_IPHONE
#define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
#endif

// Provide a symbol to include/exclude extra code for GC support.  (This mainly
// just controls the inclusion of finalize methods).
#ifndef GTM_SUPPORT_GC
#if GTM_IPHONE_SDK
// iPhone never needs GC
#define GTM_SUPPORT_GC 0
#else
// We can't find a symbol to tell if GC is supported/required, so best we
// do on Mac targets is include it if we're on 10.5 or later.
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#define GTM_SUPPORT_GC 0
#else
#define GTM_SUPPORT_GC 1
#endif
#endif
#endif

// To simplify support for 64bit (and Leopard in general), we provide the type
// defines for non Leopard SDKs
#if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
// NSInteger/NSUInteger and Max/Mins
#ifndef NSINTEGER_DEFINED
#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif
#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX
#define NSINTEGER_DEFINED 1
#endif  // NSINTEGER_DEFINED
// CGFloat
#ifndef CGFLOAT_DEFINED
#if defined(__LP64__) && __LP64__
// This really is an untested path (64bit on Tiger?)
typedef double CGFloat;
#define CGFLOAT_MIN DBL_MIN
#define CGFLOAT_MAX DBL_MAX
#define CGFLOAT_IS_DOUBLE 1
#else /* !defined(__LP64__) || !__LP64__ */
typedef float CGFloat;
#define CGFLOAT_MIN FLT_MIN
#define CGFLOAT_MAX FLT_MAX
#define CGFLOAT_IS_DOUBLE 0
#endif /* !defined(__LP64__) || !__LP64__ */
#define CGFLOAT_DEFINED 1
#endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

// Some support for advanced clang static analysis functionality
// See http://clang-analyzer.llvm.org/annotations.html
#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

#ifndef CF_RETURNS_NOT_RETAINED
#if __has_feature(attribute_cf_returns_not_retained)
#define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
#else
#define CF_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef NS_CONSUMED
#if __has_feature(attribute_ns_consumed)
#define NS_CONSUMED __attribute__((ns_consumed))
#else
#define NS_CONSUMED
#endif
#endif

#ifndef CF_CONSUMED
#if __has_feature(attribute_cf_consumed)
#define CF_CONSUMED __attribute__((cf_consumed))
#else
#define CF_CONSUMED
#endif
#endif

#ifndef NS_CONSUMES_SELF
#if __has_feature(attribute_ns_consumes_self)
#define NS_CONSUMES_SELF __attribute__((ns_consumes_self))
#else
#define NS_CONSUMES_SELF
#endif
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_ARGUMENT
#define NS_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_FUNCTION
#define NS_FORMAT_FUNCTION(F,A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_ARGUMENT
#define CF_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_FUNCTION
#define CF_FORMAT_FUNCTION(F,A)
#endif

#ifndef GTM_NONNULL
#define GTM_NONNULL(x) __attribute__((nonnull(x)))
#endif

#ifdef __OBJC__

// Declared here so that it can easily be used for logging tracking if
// necessary. See GTMUnitTestDevLog.h for details.
@class NSString;
GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);

// Macro to allow you to create NSStrings out of other macros.
// #define FOO foo
// NSString *fooString = GTM_NSSTRINGIFY(FOO);
#if !defined (GTM_NSSTRINGIFY)
#define GTM_NSSTRINGIFY_INNER(x) @#x
#define GTM_NSSTRINGIFY(x) GTM_NSSTRINGIFY_INNER(x)
#endif

// Macro to allow fast enumeration when building for 10.5 or later, and
// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
// does keys, so pick the right thing, nothing is done on the FastEnumeration
// side to be sure you're getting what you wanted.
#ifndef GTM_FOREACH_OBJECT
#if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (element in enumeration)
#define GTM_FOREACH_OBJECT(element, collection) \
for (element in collection)
#define GTM_FOREACH_KEY(element, collection) \
for (element in collection)
#else
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (NSEnumerator *_ ## element ## _enum = enumeration; \
(element = [_ ## element ## _enum nextObject]) != nil; )
#define GTM_FOREACH_OBJECT(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
#define GTM_FOREACH_KEY(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
#endif
#endif

// ============================================================================

// To simplify support for both Leopard and Snow Leopard we declare
// the Snow Leopard protocols that we need here.
#if !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)
#define GTM_10_6_PROTOCOLS_DEFINED 1
@protocol NSConnectionDelegate
@end
@protocol NSAnimationDelegate
@end
@protocol NSImageDelegate
@end
@protocol NSTabViewDelegate
@end
#endif  // !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)

// GTM_SEL_STRING is for specifying selector (usually property) names to KVC
// or KVO methods.
// In debug it will generate warnings for undeclared selectors if
// -Wunknown-selector is turned on.
// In release it will have no runtime overhead.
#ifndef GTM_SEL_STRING
#ifdef DEBUG
#define GTM_SEL_STRING(selName) NSStringFromSelector(@selector(selName))
#else
#define GTM_SEL_STRING(selName) @#selName
#endif  // DEBUG
#endif  // GTM_SEL_STRING

#endif // __OBJC__
#include <AvailabilityMacros.h>
#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
#include <Availability.h>
#endif //  TARGET_OS_IPHONE

// Not all MAC_OS_X_VERSION_10_X macros defined in past SDKs
#ifndef MAC_OS_X_VERSION_10_5
#define MAC_OS_X_VERSION_10_5 1050
#endif
#ifndef MAC_OS_X_VERSION_10_6
#define MAC_OS_X_VERSION_10_6 1060
#endif
#ifndef MAC_OS_X_VERSION_10_7
#define MAC_OS_X_VERSION_10_7 1070
#endif

// Not all __IPHONE_X macros defined in past SDKs
#ifndef __IPHONE_3_0
#define __IPHONE_3_0 30000
#endif
#ifndef __IPHONE_3_1
#define __IPHONE_3_1 30100
#endif
#ifndef __IPHONE_3_2
#define __IPHONE_3_2 30200
#endif
#ifndef __IPHONE_4_0
#define __IPHONE_4_0 40000
#endif
#ifndef __IPHONE_4_3
#define __IPHONE_4_3 40300
#endif
#ifndef __IPHONE_5_0
#define __IPHONE_5_0 50000
#endif

// ----------------------------------------------------------------------------
// CPP symbols that can be overridden in a prefix to control how the toolbox
// is compiled.
// ----------------------------------------------------------------------------


// By setting the GTM_CONTAINERS_VALIDATION_FAILED_LOG and
// GTM_CONTAINERS_VALIDATION_FAILED_ASSERT macros you can control what happens
// when a validation fails. If you implement your own validators, you may want
// to control their internals using the same macros for consistency.
#ifndef GTM_CONTAINERS_VALIDATION_FAILED_ASSERT
#define GTM_CONTAINERS_VALIDATION_FAILED_ASSERT 0
#endif

// Give ourselves a consistent way to do inlines.  Apple's macros even use
// a few different actual definitions, so we're based off of the foundation
// one.
#if !defined(GTM_INLINE)
#if (defined (__GNUC__) && (__GNUC__ == 4)) || defined (__clang__)
#define GTM_INLINE static __inline__ __attribute__((always_inline))
#else
#define GTM_INLINE static __inline__
#endif
#endif

// Give ourselves a consistent way of doing externs that links up nicely
// when mixing objc and objc++
#if !defined (GTM_EXTERN)
#if defined __cplusplus
#define GTM_EXTERN extern "C"
#define GTM_EXTERN_C_BEGIN extern "C" {
#define GTM_EXTERN_C_END }
#else
#define GTM_EXTERN extern
#define GTM_EXTERN_C_BEGIN
#define GTM_EXTERN_C_END
#endif
#endif

// Give ourselves a consistent way of exporting things if we have visibility
// set to hidden.
#if !defined (GTM_EXPORT)
#define GTM_EXPORT __attribute__((visibility("default")))
#endif

// Give ourselves a consistent way of declaring something as unused. This
// doesn't use __unused because that is only supported in gcc 4.2 and greater.
#if !defined (GTM_UNUSED)
#define GTM_UNUSED(x) ((void)(x))
#endif

// _GTMDevLog & _GTMDevAssert

// _GTMDevLog & _GTMDevAssert are meant to be a very lightweight shell for
// developer level errors.  This implementation simply macros to NSLog/NSAssert.
// It is not intended to be a general logging/reporting system.

// Please see http://code.google.com/p/google-toolbox-for-mac/wiki/DevLogNAssert
// for a little more background on the usage of these macros.

//    _GTMDevLog           log some error/problem in debug builds
//    _GTMDevAssert        assert if conditon isn't met w/in a method/function
//                           in all builds.

// To replace this system, just provide different macro definitions in your
// prefix header.  Remember, any implementation you provide *must* be thread
// safe since this could be called by anything in what ever situtation it has
// been placed in.


// We only define the simple macros if nothing else has defined this.
#ifndef _GTMDevLog

#ifdef DEBUG
#define _GTMDevLog(...) NSLog(__VA_ARGS__)
#else
#define _GTMDevLog(...) do { } while (0)
#endif

#endif // _GTMDevLog

#ifndef _GTMDevAssert
// we directly invoke the NSAssert handler so we can pass on the varargs
// (NSAssert doesn't have a macro we can use that takes varargs)
#if !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...)                                       \
do {                                                                      \
if (!(condition)) {                                                     \
[[NSAssertionHandler currentHandler]                                  \
handleFailureInFunction:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
file:[NSString stringWithUTF8String:__FILE__]  \
lineNumber:__LINE__                                  \
description:__VA_ARGS__];                             \
}                                                                       \
} while(0)
#else // !defined(NS_BLOCK_ASSERTIONS)
#define _GTMDevAssert(condition, ...) do { } while (0)
#endif // !defined(NS_BLOCK_ASSERTIONS)

#endif // _GTMDevAssert

// _GTMCompileAssert
// _GTMCompileAssert is an assert that is meant to fire at compile time if you
// want to check things at compile instead of runtime. For example if you
// want to check that a wchar is 4 bytes instead of 2 you would use
// _GTMCompileAssert(sizeof(wchar_t) == 4, wchar_t_is_4_bytes_on_OS_X)
// Note that the second "arg" is not in quotes, and must be a valid processor
// symbol in it's own right (no spaces, punctuation etc).

// Wrapping this in an #ifndef allows external groups to define their own
// compile time assert scheme.
#ifndef _GTMCompileAssert
// We got this technique from here:
// http://unixjunkie.blogspot.com/2007/10/better-compile-time-asserts_29.html

#define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
#define _GTMCompileAssertSymbol(line, msg) _GTMCompileAssertSymbolInner(line, msg)
#define _GTMCompileAssert(test, msg) \
typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif // _GTMCompileAssert

// ----------------------------------------------------------------------------
// CPP symbols defined based on the project settings so the GTM code has
// simple things to test against w/o scattering the knowledge of project
// setting through all the code.
// ----------------------------------------------------------------------------

// Provide a single constant CPP symbol that all of GTM uses for ifdefing
// iPhone code.
#if TARGET_OS_IPHONE // iPhone SDK
// For iPhone specific stuff
#define GTM_IPHONE_SDK 1
#if TARGET_IPHONE_SIMULATOR
#define GTM_IPHONE_SIMULATOR 1
#else
#define GTM_IPHONE_DEVICE 1
#endif  // TARGET_IPHONE_SIMULATOR
// By default, GTM has provided it's own unittesting support, define this
// to use the support provided by Xcode, especially for the Xcode4 support
// for unittesting.
#ifndef GTM_IPHONE_USE_SENTEST
#define GTM_IPHONE_USE_SENTEST 0
#endif
#else
// For MacOS specific stuff
#define GTM_MACOS_SDK 1
#endif

// Some of our own availability macros
#if GTM_MACOS_SDK
#define GTM_AVAILABLE_ONLY_ON_IPHONE UNAVAILABLE_ATTRIBUTE
#define GTM_AVAILABLE_ONLY_ON_MACOS
#else
#define GTM_AVAILABLE_ONLY_ON_IPHONE
#define GTM_AVAILABLE_ONLY_ON_MACOS UNAVAILABLE_ATTRIBUTE
#endif

// Provide a symbol to include/exclude extra code for GC support.  (This mainly
// just controls the inclusion of finalize methods).
#ifndef GTM_SUPPORT_GC
#if GTM_IPHONE_SDK
// iPhone never needs GC
#define GTM_SUPPORT_GC 0
#else
// We can't find a symbol to tell if GC is supported/required, so best we
// do on Mac targets is include it if we're on 10.5 or later.
#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#define GTM_SUPPORT_GC 0
#else
#define GTM_SUPPORT_GC 1
#endif
#endif
#endif

// To simplify support for 64bit (and Leopard in general), we provide the type
// defines for non Leopard SDKs
#if !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_5)
// NSInteger/NSUInteger and Max/Mins
#ifndef NSINTEGER_DEFINED
#if __LP64__ || NS_BUILD_32_LIKE_64
typedef long NSInteger;
typedef unsigned long NSUInteger;
#else
typedef int NSInteger;
typedef unsigned int NSUInteger;
#endif
#define NSIntegerMax    LONG_MAX
#define NSIntegerMin    LONG_MIN
#define NSUIntegerMax   ULONG_MAX
#define NSINTEGER_DEFINED 1
#endif  // NSINTEGER_DEFINED
// CGFloat
#ifndef CGFLOAT_DEFINED
#if defined(__LP64__) && __LP64__
// This really is an untested path (64bit on Tiger?)
typedef double CGFloat;
#define CGFLOAT_MIN DBL_MIN
#define CGFLOAT_MAX DBL_MAX
#define CGFLOAT_IS_DOUBLE 1
#else /* !defined(__LP64__) || !__LP64__ */
typedef float CGFloat;
#define CGFLOAT_MIN FLT_MIN
#define CGFLOAT_MAX FLT_MAX
#define CGFLOAT_IS_DOUBLE 0
#endif /* !defined(__LP64__) || !__LP64__ */
#define CGFLOAT_DEFINED 1
#endif // CGFLOAT_DEFINED
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

// Some support for advanced clang static analysis functionality
// See http://clang-analyzer.llvm.org/annotations.html
#ifndef __has_feature      // Optional.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif

#ifndef NS_RETURNS_RETAINED
#if __has_feature(attribute_ns_returns_retained)
#define NS_RETURNS_RETAINED __attribute__((ns_returns_retained))
#else
#define NS_RETURNS_RETAINED
#endif
#endif

#ifndef NS_RETURNS_NOT_RETAINED
#if __has_feature(attribute_ns_returns_not_retained)
#define NS_RETURNS_NOT_RETAINED __attribute__((ns_returns_not_retained))
#else
#define NS_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef CF_RETURNS_RETAINED
#if __has_feature(attribute_cf_returns_retained)
#define CF_RETURNS_RETAINED __attribute__((cf_returns_retained))
#else
#define CF_RETURNS_RETAINED
#endif
#endif

#ifndef CF_RETURNS_NOT_RETAINED
#if __has_feature(attribute_cf_returns_not_retained)
#define CF_RETURNS_NOT_RETAINED __attribute__((cf_returns_not_retained))
#else
#define CF_RETURNS_NOT_RETAINED
#endif
#endif

#ifndef NS_CONSUMED
#if __has_feature(attribute_ns_consumed)
#define NS_CONSUMED __attribute__((ns_consumed))
#else
#define NS_CONSUMED
#endif
#endif

#ifndef CF_CONSUMED
#if __has_feature(attribute_cf_consumed)
#define CF_CONSUMED __attribute__((cf_consumed))
#else
#define CF_CONSUMED
#endif
#endif

#ifndef NS_CONSUMES_SELF
#if __has_feature(attribute_ns_consumes_self)
#define NS_CONSUMES_SELF __attribute__((ns_consumes_self))
#else
#define NS_CONSUMES_SELF
#endif
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_ARGUMENT
#define NS_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef NS_FORMAT_FUNCTION
#define NS_FORMAT_FUNCTION(F,A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_ARGUMENT
#define CF_FORMAT_ARGUMENT(A)
#endif

// Defined on 10.6 and above.
#ifndef CF_FORMAT_FUNCTION
#define CF_FORMAT_FUNCTION(F,A)
#endif

#ifndef GTM_NONNULL
#define GTM_NONNULL(x) __attribute__((nonnull(x)))
#endif

#ifdef __OBJC__

// Declared here so that it can easily be used for logging tracking if
// necessary. See GTMUnitTestDevLog.h for details.
@class NSString;
GTM_EXTERN void _GTMUnitTestDevLog(NSString *format, ...);



// Macro to allow you to create NSStrings out of other macros.
// #define FOO foo
// NSString *fooString = GTM_NSSTRINGIFY(FOO);
#if !defined (GTM_NSSTRINGIFY)
#define GTM_NSSTRINGIFY_INNER(x) @#x
#define GTM_NSSTRINGIFY(x) GTM_NSSTRINGIFY_INNER(x)
#endif

// Macro to allow fast enumeration when building for 10.5 or later, and
// reliance on NSEnumerator for 10.4.  Remember, NSDictionary w/ FastEnumeration
// does keys, so pick the right thing, nothing is done on the FastEnumeration
// side to be sure you're getting what you wanted.
#ifndef GTM_FOREACH_OBJECT
#if TARGET_OS_IPHONE || !(MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5)
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (element in enumeration)
#define GTM_FOREACH_OBJECT(element, collection) \
for (element in collection)
#define GTM_FOREACH_KEY(element, collection) \
for (element in collection)
#else
#define GTM_FOREACH_ENUMEREE(element, enumeration) \
for (NSEnumerator *_ ## element ## _enum = enumeration; \
(element = [_ ## element ## _enum nextObject]) != nil; )
#define GTM_FOREACH_OBJECT(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection objectEnumerator])
#define GTM_FOREACH_KEY(element, collection) \
GTM_FOREACH_ENUMEREE(element, [collection keyEnumerator])
#endif
#endif

// ============================================================================

// To simplify support for both Leopard and Snow Leopard we declare
// the Snow Leopard protocols that we need here.
#if !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)
#define GTM_10_6_PROTOCOLS_DEFINED 1
@protocol NSConnectionDelegate
@end
@protocol NSAnimationDelegate
@end
@protocol NSImageDelegate
@end
@protocol NSTabViewDelegate
@end
#endif  // !defined(GTM_10_6_PROTOCOLS_DEFINED) && !(MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_6)

// GTM_SEL_STRING is for specifying selector (usually property) names to KVC
// or KVO methods.
// In debug it will generate warnings for undeclared selectors if
// -Wunknown-selector is turned on.
// In release it will have no runtime overhead.
#ifndef GTM_SEL_STRING
#ifdef DEBUG
#define GTM_SEL_STRING(selName) NSStringFromSelector(@selector(selName))
#else
#define GTM_SEL_STRING(selName) @#selName
#endif  // DEBUG
#endif  // GTM_SEL_STRING

#endif // __OBJC__


//GTMDefines

#import <objc/objc-api.h>
#import <objc/objc-auto.h>


// These functions exist for code that we want to compile on both the < 10.5
// sdks and on the >= 10.5 sdks without warnings. It basically reimplements
// certain parts of the objc2 runtime in terms of the objc1 runtime. It is not
// a complete implementation as I've only implemented the routines I know we
// use. Feel free to add more as necessary.
// These functions are not documented because they conform to the documentation
// for the ObjC2 Runtime.

#if OBJC_API_VERSION >= 2  // Only have optional and req'd keywords in ObjC2.
#define AT_OPTIONAL @optional
#define AT_REQUIRED @required
#else
#define AT_OPTIONAL
#define AT_REQUIRED
#endif

// The file objc-runtime.h was moved to runtime.h and in Leopard, objc-runtime.h
// was just a wrapper around runtime.h. For the iPhone SDK, this objc-runtime.h
// is removed in the iPhoneOS2.0 SDK.

// The |Object| class was removed in the iPhone2.0 SDK too.
#if GTM_IPHONE_SDK
#import <objc/message.h>
#import <objc/runtime.h>
#else
#import <objc/objc-runtime.h>
#import <objc/Object.h>
#endif

#import <libkern/OSAtomic.h>

#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#import "objc/Protocol.h"

OBJC_EXPORT Class object_getClass(id obj);
OBJC_EXPORT const char *class_getName(Class cls);
OBJC_EXPORT BOOL class_conformsToProtocol(Class cls, Protocol *protocol);
OBJC_EXPORT BOOL class_respondsToSelector(Class cls, SEL sel);
OBJC_EXPORT Class class_getSuperclass(Class cls);
OBJC_EXPORT Method *class_copyMethodList(Class cls, unsigned int *outCount);
OBJC_EXPORT SEL method_getName(Method m);
OBJC_EXPORT void method_exchangeImplementations(Method m1, Method m2);
OBJC_EXPORT IMP method_getImplementation(Method method);
OBJC_EXPORT IMP method_setImplementation(Method method, IMP imp);
OBJC_EXPORT struct objc_method_description protocol_getMethodDescription(Protocol *p,
                                                                         SEL aSel,
                                                                         BOOL isRequiredMethod,
                                                                         BOOL isInstanceMethod);
OBJC_EXPORT BOOL sel_isEqual(SEL lhs, SEL rhs);

// If building for 10.4 but using the 10.5 SDK, don't include these.
#if MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_5
// atomics
// On Leopard these are GC aware
// Intentionally did not include the non-barrier versions, because I couldn't
// come up with a case personally where you wouldn't want to use the
// barrier versions.
GTM_INLINE bool OSAtomicCompareAndSwapPtrBarrier(void *predicate,
                                                 void *replacement,
                                                 void * volatile *theValue) {
#if defined(__LP64__) && __LP64__
	return OSAtomicCompareAndSwap64Barrier((int64_t)predicate,
										   (int64_t)replacement,
										   (int64_t *)theValue);
#else  // defined(__LP64__) && __LP64__
	return OSAtomicCompareAndSwap32Barrier((int32_t)predicate,
										   (int32_t)replacement,
										   (int32_t *)theValue);
#endif  // defined(__LP64__) && __LP64__
}

#endif  // MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_5
#endif  // MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5

#if MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_5

GTM_INLINE BOOL objc_atomicCompareAndSwapGlobalBarrier(id predicate,
                                                       id replacement,
                                                       volatile id *objectLocation) {
	return OSAtomicCompareAndSwapPtrBarrier(predicate,
											replacement,
											(void * volatile *)objectLocation);
}
GTM_INLINE BOOL objc_atomicCompareAndSwapInstanceVariableBarrier(id predicate,
                                                                 id replacement,
                                                                 volatile id *objectLocation) {
	return OSAtomicCompareAndSwapPtrBarrier(predicate,
											replacement,
											(void * volatile *)objectLocation);
}
#endif  // MAC_OS_X_VERSION_MAX_ALLOWED < MAC_OS_X_VERSION_10_5




//  AGFoundation.m
//  AGFoundation

//  Created by Alex Gray on 4/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.




//@implementation AGFoundation
//@synthesize speaker;

//+ (AGFoundation *)sharedInstance	{	return [super sharedInstance]; }

//- (void)setUp {

//	//	appArray = [[NSMutableArray alloc] init];
//	//	NSArray *ws =	 [[[NSWorkspace sharedWorkspace] launchedApplications] valueForKeyPath:@"NSApplicationPath"];
//	//	int k = 0;
//	//	for (NSString *path in ws) 	{
//	//		DBXApp *app = [DBXApp instanceWithPath:path];
//	//		[app setIndex:k];  k++;
//	//		[appArray addObject:app];
//	//	}
//}


//-(void) say:(NSString *)thing {
// 	// for (NSString *voice in
// 	NSArray *voices = [NSSpeechSynthesizer availableVoices];
// 	NSUInteger randomIndex = arc4random() % [voices count];
// 	NSString *voice = [voices objectAtIndex:randomIndex];
// 	[speaker setVoice: voice ];
// 	[speaker startSpeakingString: thing];
// 	printf("Speaking as %s\n", [voice UTF8String]);
// 	while ([speaker isSpeaking]) { usleep(40); }
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
{
    return (isFlipped ? backView : frontView);
}
@end

// Released by Drew McCormack into the pubic domain (2010).


@implementation NSWindow (Borderless)

+ (NSWindow*) borderlessWindowWithContentRect: (NSRect)aRect  {
	NSWindow *new = [[NSWindow alloc] initWithContentRect:aRect styleMask: NSBorderlessWindowMask
												  backing: NSBackingStoreBuffered	 defer: NO];
	[new setBackgroundColor: [NSColor clearColor]];							[new setOpaque:NO];
    return new;
}
@end


#if MAC_OS_X_VERSION_MIN_REQUIRED < MAC_OS_X_VERSION_10_5
#import <stdlib.h>
#import <string.h>

Class object_getClass(id obj) {
	if (!obj) return NULL;
	return obj->isa;
}

const char *class_getName(Class cls) {
	if (!cls) return "nil";
	return cls->name;
}

BOOL class_conformsToProtocol(Class cls, Protocol *protocol) {
	// We intentionally don't check cls as it crashes on Leopard so we want
	// to crash on Tiger as well.
	// I logged
	// Radar 5572978 class_conformsToProtocol crashes when arg1 is passed as nil
	// because it seems odd that this API won't accept nil for cls considering
	// all the other apis will accept nil args.
	// If this does get fixed, remember to enable the unit tests.
	if (!protocol) return NO;

	struct objc_protocol_list *protos;
	for (protos = cls->protocols; protos != NULL; protos = protos->next) {
		for (long i = 0; i < protos->count; i++) {
			if ([protos->list[i] conformsTo:protocol]) {
				return YES;
			}
		}
	}
	return NO;
}

Class class_getSuperclass(Class cls) {
	if (!cls) return NULL;
	return cls->super_class;
}

BOOL class_respondsToSelector(Class cls, SEL sel) {
	return class_getInstanceMethod(cls, sel) != nil;
}

Method *class_copyMethodList(Class cls, unsigned int *outCount) {
	if (!cls) return NULL;

	unsigned int count = 0;
	void *iterator = NULL;
	struct objc_method_list *mlist;
	Method *methods = NULL;
	if (outCount) *outCount = 0;

	while ( (mlist = class_nextMethodList(cls, &iterator)) ) {
		if (mlist->method_count == 0) continue;
		methods = (Method *)realloc(methods,
									sizeof(Method) * (count + mlist->method_count + 1));
		if (!methods) {
			//Memory alloc failed, so what can we do?
			return NULL;  // COV_NF_LINE
		}
		for (int i = 0; i < mlist->method_count; i++) {
			methods[i + count] = &mlist->method_list[i];
		}
		count += mlist->method_count;
	}

	// List must be NULL terminated
	if (methods) {
		methods[count] = NULL;
	}
	if (outCount) *outCount = count;
	return methods;
}

SEL method_getName(Method method) {
	if (!method) return NULL;
	return method->method_name;
}

IMP method_getImplementation(Method method) {
	if (!method) return NULL;
	return method->method_imp;
}

IMP method_setImplementation(Method method, IMP imp) {
	// We intentionally don't test method for nil.
	// Leopard fails here, so should we.
	// I logged this as Radar:
	// 5572981 method_setImplementation crashes if you pass nil for the
	// method arg (arg 1)
	// because it seems odd that this API won't accept nil for method considering
	// all the other apis will accept nil args.
	// If this does get fixed, remember to enable the unit tests.
	// This method works differently on SnowLeopard than
	// on Leopard. If you pass in a nil for IMP on SnowLeopard
	// it doesn't change anything. On Leopard it will. Since
	// attempting to change a sel to nil is probably an error
	// we follow the SnowLeopard way of doing things.
	IMP oldImp = NULL;
	if (imp) {
		oldImp = method->method_imp;
		method->method_imp = imp;
	}
	return oldImp;
}

void method_exchangeImplementations(Method m1, Method m2) {
	if (m1 == m2) return;
	if (!m1 || !m2) return;
	IMP imp2 = method_getImplementation(m2);
	IMP imp1 = method_setImplementation(m1, imp2);
	method_setImplementation(m2, imp1);
}

struct objc_method_description protocol_getMethodDescription(Protocol *p,
                                                             SEL aSel,
                                                             BOOL isRequiredMethod,
                                                             BOOL isInstanceMethod) {
	struct objc_method_description *descPtr = NULL;
	// No such thing as required in ObjC1.
	if (isInstanceMethod) {
		descPtr = [p descriptionForInstanceMethod:aSel];
	} else {
		descPtr = [p descriptionForClassMethod:aSel];
	}

	struct objc_method_description desc;
	if (descPtr) {
		desc = *descPtr;
	} else {
		bzero(&desc, sizeof(desc));
	}
	return desc;
}

BOOL sel_isEqual(SEL lhs, SEL rhs) {
	// Apple (informally) promises this will work in the future:
	// http://twitter.com/#!/gparker/status/2400099786
	return (lhs == rhs) ? YES : NO;
}

#endif




@implementation NSBag
- (id) init { 	if (!(self = [super init])) return self;
	dict = [[NSMutableDictionary alloc] init]; 	return self;
}

+ (NSBag *) bag { 	return [[NSBag alloc] init]; }

- (void) add: (id) anObject {
	int count = 0;	NSNumber *num = dict[anObject];
	if (num) count = [num intValue];
	NSNumber *newnum = @(count + 1);
	if ( (anObject) && (newnum) )	dict[anObject] = newnum;
}

+ (NSBag *) bagWithObjects:(id)item,... {
	NSBag *bag = [NSBag bag];	if (!item) return bag;
	[bag add:item];
	va_list objects;	va_start(objects, item);	id obj = va_arg(objects, id);
	while (obj)	{
		[bag add:obj];		obj = va_arg(objects, id);	}
	va_end(objects);	return bag;
}

- (void) addObjects:(id)item,...{
	if (!item) return;
	[self add:item];

	va_list objects;
	va_start(objects, item);
	id obj = va_arg(objects, id);
	while (obj)
	{
		[self add:obj];
		obj = va_arg(objects, id);
	}
	va_end(objects);
}

- (void) remove: (id) anObject
{
	NSNumber *num = dict[anObject];
	if (!num) return;
	if ([num intValue] == 1)
	{
		[dict removeObjectForKey:anObject];
		return;
	}
	NSNumber *newnum = @([num intValue] - 1);
	dict[anObject] = newnum;
}

- (NSInteger) occurrencesOf: (id) anObject
{
	NSNumber *num = dict[anObject];
	return [num intValue];
}

- (NSArray *) objects
{
	return [dict allKeys];
}

- (NSString *) description
{
	return [dict description];
}


@end


void perceptualCausticColorForColor(CGFloat *inputComponents, CGFloat *outputComponents) {
    const CGFloat CAUSTIC_FRACTION = 0.60;
    const CGFloat COSINE_ANGLE_SCALE = 1.4;
    const CGFloat MIN_RED_THRESHOLD = 0.95;
    const CGFloat MAX_BLUE_THRESHOLD = 0.7;
    const CGFloat GRAYSCALE_CAUSTIC_SATURATION = 0.2;

    NSColor *source = [NSColor colorWithCalibratedRed:inputComponents[0] green:inputComponents[1] blue:inputComponents[2]	 alpha:inputComponents[3]];

    CGFloat hue_, saturation_, brightness_, alpha_, targetHue, targetSaturation, targetBrightness;
    [source getHue:&hue_ saturation:&saturation_ brightness:&brightness_ alpha:&alpha_];
    [[NSColor yellowColor] getHue:&targetHue saturation:&targetSaturation brightness:&targetBrightness alpha:&alpha_];
    if (saturation_ < 1e-3) {        hue_ = targetHue;        saturation_ = GRAYSCALE_CAUSTIC_SATURATION;	}
    if (hue_ > MIN_RED_THRESHOLD)        hue_ -= 1.0;
    else if (hue_ > MAX_BLUE_THRESHOLD)
        [[NSColor magentaColor] getHue:&targetHue saturation:&targetSaturation brightness:&targetBrightness alpha:&alpha_];
    float scaledCaustic = CAUSTIC_FRACTION * 0.5 * (1.0 + cos(COSINE_ANGLE_SCALE * M_PI * (hue_ - targetHue)));
    NSColor *targetColor =
	[NSColor	 colorWithCalibratedHue:hue_ * (1.0 - scaledCaustic) + targetHue * scaledCaustic saturation:saturation_
						  brightness:brightness_ * (1.0 - scaledCaustic) + targetBrightness * scaledCaustic	 alpha:inputComponents[3]];
    [targetColor getComponents:outputComponents];
}

typedef struct {
    CGFloat color[4];    CGFloat caustic[4];    CGFloat expCoefficient;    CGFloat expScale;    CGFloat expOffset;    CGFloat initialWhite;    CGFloat finalWhite;
} GlossParameters;

static void glossInterpolation(void *info, const CGFloat *input, CGFloat *output) {
    GlossParameters *params = (GlossParameters *)info;
    CGFloat progress = *input;
    if (progress < 0.5)	{
        progress = progress * 2.0;
        progress =
		1.0 - params->expScale * (expf(progress * -params->expCoefficient) - params->expOffset);
        CGFloat currentWhite = progress * (params->finalWhite - params->initialWhite) + params->initialWhite;
        output[0] = params->color[0] * (1.0 - currentWhite) + currentWhite;
        output[1] = params->color[1] * (1.0 - currentWhite) + currentWhite;
        output[2] = params->color[2] * (1.0 - currentWhite) + currentWhite;
        output[3] = params->color[3] * (1.0 - currentWhite) + currentWhite;
	} else {
        progress = (progress - 0.5) * 2.0;
        progress = params->expScale *
		(expf((1.0 - progress) * -params->expCoefficient) - params->expOffset);
        output[0] = params->color[0] * (1.0 - progress) + params->caustic[0] * progress;
        output[1] = params->color[1] * (1.0 - progress) + params->caustic[1] * progress;
        output[2] = params->color[2] * (1.0 - progress) + params->caustic[2] * progress;
        output[3] = params->color[3] * (1.0 - progress) + params->caustic[3] * progress;
	}
}

CGFloat perceptualGlossFractionForColor(CGFloat *inputComponents)
{
    const CGFloat REFLECTION_SCALE_NUMBER = 0.2;
    const CGFloat NTSC_RED_FRACTION = 0.299;
    const CGFloat NTSC_GREEN_FRACTION = 0.587;
    const CGFloat NTSC_BLUE_FRACTION = 0.114;

    CGFloat glossScale =
	NTSC_RED_FRACTION * inputComponents[0] +
	NTSC_GREEN_FRACTION * inputComponents[1] +
	NTSC_BLUE_FRACTION * inputComponents[2];
    glossScale = pow(glossScale, REFLECTION_SCALE_NUMBER);
    return glossScale;
}
void DrawGlossGradient(CGContextRef context, NSColor *color, NSRect inRect) {
    const CGFloat EXP_COEFFICIENT = 1.2;
    const CGFloat REFLECTION_MAX = 0.60;
    const CGFloat REFLECTION_MIN = 0.20;
    GlossParameters params;
    params.expCoefficient = EXP_COEFFICIENT;
    params.expOffset = expf(-params.expCoefficient);
    params.expScale = 1.0 / (1.0 - params.expOffset);

    NSColor *source =	[color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    [source getComponents:params.color];
    if ([source numberOfComponents] == 3)
        params.color[3] = 1.0;
    perceptualCausticColorForColor(params.color, params.caustic);
    CGFloat glossScale = perceptualGlossFractionForColor(params.color);
    params.initialWhite = glossScale * REFLECTION_MAX;
    params.finalWhite = glossScale * REFLECTION_MIN;
    static const CGFloat input_value_range[2] = {0, 1};
    static const CGFloat output_value_ranges[8] = {0, 1, 0, 1, 0, 1, 0, 1};
    CGFunctionCallbacks callbacks = {0, glossInterpolation, NULL};
    CGFunctionRef gradientFunction = CGFunctionCreate(
													  (void *)&params,
													  1, // number of input values to the callback
													  input_value_range,
													  4, // number of components (r, g, b, a)
													  output_value_ranges,
													  &callbacks);

    CGPoint startPoint = CGPointMake(NSMinX(inRect), NSMaxY(inRect));
    CGPoint endPoint = CGPointMake(NSMinX(inRect), NSMinY(inRect));

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateAxial(colorspace, startPoint,
												endPoint, gradientFunction, FALSE, FALSE);

    CGContextSaveGState(context);
    CGContextClipToRect(context, NSRectToCGRect(inRect));
    CGContextDrawShading(context, shading);
    CGContextRestoreGState(context);

    CGShadingRelease(shading);
    CGColorSpaceRelease(colorspace);
    CGFunctionRelease(gradientFunction);
}

extern void DrawLabelAtCenterPoint(NSString* string, NSPoint center) {
	//    NSString *labelString = [NSString stringWithFormat:@"%ld", (long)dimension];
    NSDictionary *attributes = $map([NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSRegularControlSize]], NSFontAttributeName, BLACK, NSForegroundColorAttributeName, WHITE, NSBackgroundColorAttributeName);
    NSSize labelSize = [string sizeWithAttributes:attributes];
    NSRect labelRect = NSMakeRect(center.x - 0.5 * labelSize.width, center.y - 0.5 * labelSize.height, labelSize.width, labelSize.height);
    [string drawInRect:labelRect withAttributes:attributes];
}




static double frandom(double start, double end)
{
	double r = random();
	r /= RAND_MAX;
	r = start + r*(end-start);

	return r;
}


NSString *const AtoZSharedInstanceUpdated = @"AtoZSharedInstanceUpdated";
NSString *const AtoZDockSortedUpdated = @"AtoZDockSortedUpdated";
NSString *const AtoZSuperLayer = @"superlayer";


CGFloat ScreenWidess(){
	return  [[NSScreen mainScreen]frame].size.width;
}
CGFloat ScreenHighness 	(){
	return	[[NSScreen mainScreen]frame].size.height;
}

//  usage  		profile("Long Task", ^{ performLongTask() } );
void profile (const char *name, void (^work) (void)) {
    struct timeval start, end;
    gettimeofday (&start, NULL);
    work();
    gettimeofday (&end, NULL);

    double fstart = (start.tv_sec * 1000000.0 + start.tv_usec) / 1000000.0;
    double fend = (end.tv_sec * 1000000.0 + end.tv_usec) / 1000000.0;

    printf("%s took %f seconds", name, fend - fstart);
}

CGFloat DegreesToRadians(CGFloat degrees) {
    return degrees * M_PI / 180;
}
NSNumber* DegreesToNumber(CGFloat degrees) {
    return [NSNumber numberWithFloat:
            DegreesToRadians(degrees)];
}

@implementation CALayerNoHit
- (BOOL)containsPoint:(CGPoint)p {	return FALSE; }
@end
@implementation CAShapeLayerNoHit
- (BOOL)containsPoint:(CGPoint)p {	return FALSE; }
@end
@implementation CATextLayerNoHit
- (BOOL)containsPoint:(CGPoint)p {	return FALSE; }
@end


static int 	numberOfShakes = 3;
static float durationOfShake = .4;
static float vigourOfShake = 0.2f;

@class AZTrackingWindow;
@implementation AtoZ (Animations)

+ (CAAnimation *) animationForOpacity {
	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[fadeAnimation setAutoreverses:YES];
	[fadeAnimation setToValue:[NSNumber numberWithFloat:0.0]];

	return fadeAnimation;
}

+ (CAAnimation *) animateionForScale {
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	[scaleAnimation setAutoreverses:YES];
	[scaleAnimation setToValue:[NSNumber numberWithFloat:0.0]];

	return scaleAnimation;
}

+ (CAAnimation *) animationForRotation {
	CATransform3D transform = CATransform3DMakeRotation(M_PI, 0.0f, 1.0f, 0.0f);
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	[rotateAnimation setToValue:[NSValue valueWithCATransform3D:transform]];

	return rotateAnimation;
}


+(CAAnimation *)flipDown:(NSTimeInterval)aDuration scaleFactor:(CGFloat)scaleFactor {

		// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CGFloat startValue =  /*beginsOnTop ? 0.0f :*/ M_PI;
    CGFloat endValue =  /*beginsOnTop-M_PI :*/ 0.0f;
    flipAnimation.fromValue = [NSNumber numberWithDouble:startValue];
    flipAnimation.toValue = [NSNumber numberWithDouble:endValue];

		// Shrinking the view makes it seem to move away from us, for a more natural effect
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
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];

		// As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = aDuration;

		// Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;

    return animationGroup;
	
}

+ (CAKeyframeAnimation *)shakeAnimation:(NSRect)frame	{
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	for (int index = 0; index < numberOfShakes; ++index)		{
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
	}
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    return shakeAnimation;
}

-(void) anmateOnPath:(id)something {
	NSTimeInterval timeForAnimation = 1;
	CAKeyframeAnimation *bounceAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.duration=timeForAnimation;
	CGMutablePathRef thePath=CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, 160, 514);
	CGPathAddLineToPoint(thePath, NULL, 160, 350);
	CGPathAddLineToPoint(thePath, NULL, 160, 406);
	bounceAnimation.path=thePath;
	CGPathRelease(thePath);
	CABasicAnimation *mainAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
	mainAnimation.removedOnCompletion=YES;
	mainAnimation.duration=timeForAnimation;
	mainAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];

	CAAnimationGroup *theGroup=[CAAnimationGroup animation];
	theGroup.delegate=self;
	theGroup.duration=timeForAnimation;
	theGroup.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	theGroup.animations=[NSArray arrayWithObjects:bounceAnimation,mainAnimation,nil];

	CALayer *target = ([something isKindOfClass:[NSWindow class]]) ? [[something contentView]layer] : [(NSView*)something layer];

	[target addAnimation:theGroup forKey:@"sagar"];
	[something setFrame:AZCenterRectOnPoint([something frame], (NSPoint){160, 406})];//)]imgV.center=CGPointMake(160, 406);
	[target setTransform: CATransform3DIdentity];//CGAffineTransformIdentity];

}

+ (void)flipDown:(id)window
{
//	[window setClass:[AZTrackingWindow class]];
	if ([(id)window respondsToSelector:@selector(setAnimations:)]) {
		[window setAnimations:@{ @"frame":  [AtoZ flipDown:2 scaleFactor:.8]} ];// shakeAnimation:[window frame]] }];
//		[[window animator] setFrame: (window.slideState == AZOut ? window.visibleFrame : window.outFrame ) display:YES animate:YES];
	}
}

+ (void)shakeWindow:(NSWindow*)window
{
	[window setAnimations:[NSDictionary dictionaryWithObject:[AtoZ shakeAnimation:[window frame]] forKey:@"frameOrigin"]];
	[[window animator] setFrameOrigin:[window frame].origin];
}

@end
