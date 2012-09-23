//
//  BaseModel.m
//  Version 2.3.1

//  http://charcoaldesign.co.uk/source/cocoa#basemodel
//  https://github.com/nicklockwood/BaseModel


#import "AtoZ.h"
#import "AtoZFunctions.h"
#import "AtoZUmbrella.h"


@implementation AZDummy
@end

@implementation AtoZ
{
	BOOL fontsRegistered;
}




	// Place this in the .m file, inside the @implementation block
	// A method to convert an enum to string
+ (NSString*) stringForPosition:(AZWindowPosition)enumVal
{	NSArray *them = [[NSArray alloc]initWithObjects:AZWindowPositionTypeArray];

	return  [them objectAtIndex:enumVal];// isEqualToString: @"ZPositionLeft"] ? @"LEFT" :, @"ZPositionBottom", @"ZPositionRight", @"ZPositionTop",  <#(NSString *)#>;
}

	// A method to retrieve the int value from the NSArray of NSStrings
-(AZWindowPosition) imageTypeStringToEnum:(NSString*)strVal
{
//	NSLog(@"%@", AZWindowPositionTypeArray);
    NSArray *imageTypeArray = [[NSArray alloc]initWithObjects:AZWindowPositionTypeArray];

    return (AZWindowPosition)[ imageTypeArray indexOfObject:strVal];
//    if(n < 1) n = AZPositionLeft;
//
}

//@synthesize appFolder, appFolderSorted;//, console;
//@synthesize dock, dockSorted;

+ (NSString*) resources { return [[NSBundle bundleForClass: [self class]] resourcePath]; }

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

- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view
{
	NSScreen *currentScreen = [NSScreen currentScreenForMouseLocation];
	if(currentScreen)
		{
		NSPoint windowPoint = [view convertPoint:point toView:nil];
		NSPoint screenPoint = [[view window] convertBaseToScreen:windowPoint];
		NSPoint flippedScreenPoint = [currentScreen flipPoint:screenPoint];
		flippedScreenPoint.y += [currentScreen frame].origin.y;

		return flippedScreenPoint;
		}

	return NSZeroPoint;
}

- (void)moveMouseToScreenPoint:(NSPoint)point
{
	CGPoint cgPoint = NSPointToCGPoint(point);
	CGEventSourceSetLocalEventsSuppressionInterval(nil,0);
//	CGSetLocalEventsSuppressionInterval(0.0);
	CGWarpMouseCursorPosition(cgPoint);
	CGEventSourceSetLocalEventsSuppressionInterval(nil,.25);
//	CGSetLocalEventsSuppressionInterval(0.25);
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

+ (instancetype) instanceWithColor:(NSColor*)color {

}
+ (AZColor*) instanceWithObject: (NSDictionary *)dic {	if (!dic[@"color"])  return nil;
	AZColor *color = [[self class] instanceWithColor:dic[@"color"]];
	color.name 	  =  dic [@"name"]    ?  dic [@"name"]    			   : @"";
	color.count   =  dic [@"count"]   ? [dic [@"count"] intValue]      : 0;
	color.percent =	 dic [@"percent"] ? [dic [@"percent"] floatValue]  : 0;
	return color;
}
//-(CGFloat) saturation 	{	return [_color saturationComponent]; }
//-(CGFloat) hue 		  	{	return [_color hueComponent];		 }
//-(CGFloat) brightness 	{	return [_color brightnessComponent]; }
//-(CGFloat) hueComponent {	return [color_ hueComponent];		 		}


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


@implementation CAConstraint (brevity)
+(CAConstraint*)maxX {

	return AZConstraint(kCAConstraintMaxX,@"superlayer");
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


