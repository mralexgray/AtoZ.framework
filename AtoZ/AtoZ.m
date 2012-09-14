//
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

//NSString *const AZOrientName[AZOrientCount] = {
//	[AZOrientTop] = @"Top",
//	[AZOrientLeft] = @"Left",
//	[AZOrientBottom] = @"Bottom",
//	[AZOrientRight] = @"Right",
//	[AZOrientFiesta] = @"Fiesta",
////	[AZOrientCount] = @"Count",
//};

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

@implementation AZDummy
@end

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

+ (NSArray*) dock {
	return [AZFiles sharedInstance].dock ;
}

+ (NSArray*) currentScope {
	return [AZFiles sharedInstance].dockSorted;
}
+ (NSArray*) dockSorted {

	return [AZFiles sharedInstance].dockSorted;
}
+ (NSArray*) appCategories {

	return [AZFiles sharedInstance].appCategories;
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


//	[DDLog addLogger:[DDTTYLogger sharedInstance]];

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

+ (NSFont*) fontWithSize:(CGFloat)fontSize {
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
	AZFiles *shared =  [AZFiles sharedInstance];
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
	if (! [AZFiles sharedInstance].appFolderSorted )
		[AZFiles sharedInstance].appFolderSorted = [AZFiles.sharedInstance.appFolder sortedWithKey:@"hue" ascending:YES].reversed.mutableCopy;
	return  [AZFiles sharedInstance].appFolderSorted;
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

	return [AZFiles sharedInstance].appFolder;
}

+ (NSArray*) appFolderSamplerWith:(NSUInteger)apps {

	[AZStopwatch start:@"appFolderSampler"];
	return [[[AZFiles sharedInstance].appFolderStrings randomSubarrayWithSize:apps] arrayUsingBlock:^id(id obj) {
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

	return [[[self class] runningAppsAsStrings] arrayUsingBlock:^id(id obj) {
		return [AZFile instanceWithPath:obj];
	}];
}

+ (NSArray*) runningAppsAsStrings {

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


-(NSArray*) colorsForImage:(NSImage*)image {

	@autoreleasepool {

		NSArray *rawArray = [image quantize];
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


@end


@implementation AtoZ (MiscFunctions)

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

+ (void)printCGRect:(CGRect)cgRect {	[AtoZ printRect: convertToNSRect(cgRect)];	}

+ (void) printRect:(NSRect)toPrint {
	NSLog(@"Rect is x: %i y: %i width: %i height: %i ", (int)toPrint.origin.x, (int)toPrint.origin.y,
		  (int)toPrint.size.width, (int)toPrint.size.height);
}

+ (void) printCGPoint:(CGPoint)cgPoint {	[AtoZ printPoint:convertToNSPoint(cgPoint)];	}

+ (void) printPoint:(NSPoint)toPrint {		NSLog(@"Point is x: %f y: %f", toPrint.x, toPrint.y);	}

+ (void) printTransform:(CGAffineTransform)t {
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.a, t.b);
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.c, t.d);
	NSLog(@"[ %1.1f %1.1f 1.0 ]", t.tx, t.ty);
}

@end



NSString *const AZFileUpdated = @"AZFileUpdated";

@implementation AZFile
@synthesize path, name, color, /*customColor labelColor,*/ icon, image;
@synthesize dockPoint, dockPointNew, spot, spotNew;
@synthesize hue, isRunning, hasLabel, needsToMove; //labelNumber;
//@synthesize itunesInfo, itunesDescription;

- (void) setUp {
	self.customColor 	= WHITE;
	self.labelColor 	= WHITE;
	self.labelNumber	= @(99);
	self.position		= AZPositionAutomatic;
}

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

+ (instancetype)instanceWithPath:(NSString *)path {

	AZFile *dd = [AZFile instance];//WithObject:path];
	dd.path = path;
	dd.name = [[path lastPathComponent] stringByDeletingPathExtension];
	NSWorkspace *ws =	[NSWorkspace sharedWorkspace];
	NSImage *u = [ws iconForFile:path];
	if (u) {
		u.scalesWhenResized = YES;
		u.size = AZSizeFromDimension(512);
	}
	dd.image = (u ? u : [NSImage imageInFrameworkWithFileName:@"missing.png"]);
	NSBundle * appBundle = [NSBundle bundleWithPath:path];
	dd.calulatedBundleID = appBundle ? [appBundle bundleIdentifier] : @"unknown";
	//dd.colors ?
	dd.color = [(AZColor*)[dd.colors objectAtNormalizedIndex:0] color];// : RED;
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
- (void)setActualLabelColor:(NSColor *)aLabelColor {
	NSError *error = nil;
	NSURL* fileURL = [NSURL fileURLWithPath:self.path];
	[fileURL setResourceValue:(id)aLabelColor forKey:NSURLLabelColorKey error:&error];
	if (error) NSLog(@"Problem setting label for %@", self.name);
}
- (void)setActualLabelNumber:(NSNumber*)aLabelNumber {
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


