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

//Subclassible thread-safe ARC singleton  Copyright Kevin Lawler. Released under ISC.
@implementation AZSingleton
static NSMD* _children;
+ (void) initialize 		{
	//thread-safe
	_children = !_children ? NSMD.new : _children;
	_children [NSStringFromClass(self.class)] = [self.alloc init];
}
+ (id) alloc 				{ id c; return (c = self.instance) ? c : [self allocWithZone:nil];  }
- (id) init  				{ 
	
	id c; 
	if((c = _children[NSStringFromClass([self class])])) return c;  //sic, unfactored
	return  self = [super init];
}
+ (id) instance 			{	return _children [NSStringFromClass(self.class)];  }
+ (id) sharedInstance 	{ 	return self.instance;  	}	//	alias for instance
+ (id) singleton 			{	return self.instance;	} 	//	alias for instance
+ (id) new 					{	return self.instance; 	}	//	stop other creative stuff
+ (id) copyWithZone:			(NSZone *)zone {	return [self instance]; }
+ (id) mutableCopyWithZone:(NSZone *)zone {	return [self instance]; }
@end

@implementation NSObject (AZFunctional)
-(id)processByPerformingFilterBlocks:(NSA*)filterBlocks	{
	__block id blockSelf = self;
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
	}();																									*/

@implementation AZDummy
- (id)init							{	 if (self != super.init ) return nil;

   _sharedStack 									  = NSOperationStack.new;
	 	 _sharedQ 									  = NSOQ.new; 
	   _sharedSQ							 = NSOQ.new; 
	_sharedStack.maxConcurrentOperationCount = AZOQMAX;
		_sharedQ.maxConcurrentOperationCount = AZOQMAX;  
	   _sharedSQ.maxConcurrentOperationCount = 1;
	return self;
}
+ (AZDummy*) sharedInstance	{ 

	static AZDummy *sharedInstance = nil;	
	static dispatch_once_t isDispatched; 
	dispatch_once(&isDispatched, ^{  sharedInstance = AZDummy.new;	}); 
	return sharedInstance; 
}
@end

/*
// 4) Add this method to the implementation file
//- (id)forwardingTargetForSelector:(SEL)sel	{		if(		sel == @selector(runOperation:withMsg:)	|| sel == @selector(operationsSet)			||		sel == @selector(operationsCount)		|| sel == @selector(cancelOperations)		||		sel == @selector(enumerateOperations:)		) {		if(!operationsRunner) {	// Object only created if needed			operationsRunner = [[OperationsRunner alloc] initWithDelegate:self];		}	return operationsRunner;	} else {	return [super forwardingTargetForSelector:sel];	}	}
*/

static char CONVERTTOXML_KEY;

NSString *const BaseModelDidAddNewInstance = @"BaseModelDidAddNewInstanceNotification";
//static NSString *const BaseModelSharedInstanceKey = @"sharedInstance";
//static NSString *const BaseModelLoadingFromResourceFileKey = @"loadingFromResourceFile";


@interface BaseModel ()
@property (copy) KVOLastChangedBlock lastChangedBlock;
- (void) setLastChangedBlock:(KVOLastChangedBlock)lastChangedBlock;
- (KVOLastChangedBlock) lastChangedBlock;

@property (copy) KVONewInstanceBlock onInitBlock;
- (void) setOnInitBlock:(KVONewInstanceBlock)onInitBlock;
- (KVONewInstanceBlock) onInitBlock;

@end

@implementation BaseModel (AtoZ)
static NSUI 	 instanceNumber 			= 0;
static id		 lastModifiedInstance 	= nil;
static NSS		*lastModifiedKey 			= nil;			// class methods for last modified key and instance - these are held as static data
static NSPointerArray *pointers			= nil;

+ (void) load							{		 /* 	Instantiate pointerarray, swizzle methods	  */

	pointers = NSPointerArray.new;
	[@[@"init", @"save"] each:^(NSS* obj) {  		/*	[$ swizzleClassMethod:in:self.class with:in:self.class]; */
		[$ swizzleMethod:NSSelectorFromString(obj) with:NSSelectorFromString($(@"swizzle%@",obj.uppercaseString)) in:self.class];	}];

//	[AZNOTCENTER addObserverForName:BaseModelDidAddNewInstance object:nil block:^(NSNOT *n) {
//			[self.sharedInstance willChangeValueForKey:@"instances"];
//			[self.sharedInstance  didChangeValueForKey:@"instances"];
//	}];
}

- (id)  	swizzleInit					{ 	/* Post NewInstance Notification, addself to PointerArray, Associate instance number. */

		instanceNumber++;
		 	if (self != [self swizzleInit] ) return nil;
	[self setAssociatedValue:@(instanceNumber) forKey:@"instanceNumber" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	[pointers addPointer:(void*)self];   [AZNOTCENTER postNotificationName:BaseModelDidAddNewInstance object:self];

	[self.class.sharedInstance setValue:self forKey:@"keyChanged"];
	if (self == self.class.sharedInstance)	[self.class setLastModifiedKey:@"newSharedInstance" forInstance:self];
		// Class method - set last modified
	else [self.class setLastModifiedKey:@"newInstance" forInstance:self];
	// Instance method - dummy setValue to dispatch notifications
	[self.class.sharedInstance willChangeValueForKey:@"instances"];
	[self.class.sharedInstance setValue:@"newInstance" forKey:@"keyChanged"];
	[self.class.sharedInstance didChangeValueForKey:@"instances"];
	return self;
}

+ (INST) objectAtIndex:(NSUI)idx 				{		VoidBlock logNull = ^{ [@"Pointer array empty return NSNUll" log]; };

	if (idx > pointers.count) {   logNull(); return (id)AZNULL; }

	void *thePtf = [pointers pointerAtIndex:idx];

	if ( thePtf != NULL) return (__bridge id)thePtf;  else {  logNull();  return  (id)AZNULL; 	}
}		/*																				*/
+ (NSUI) instances									{ return  instanceNumber; } 		/*		Number of class instamces TOTAL.  Living and dead.		*/
- (NSUI) instanceNumber 							{  id theNumber = [self associatedValueForKey:@"instanceNumber"];
									return theNumber ? [theNumber unsignedIntegerValue] : NSNotFound;
} 		/* 	EAch object knows its "place" in the birthcycle.		*/


- (void) setValue: (id)value forKey:(NSS*)key				{

	if (![self canSetValueForKey:key]) {  NSLog(@"Asked to, but canot set val for: %@", key); return; }
	//	overload to dispatch change notification to our shared instance
	[super setValue:value forKey:key];
	// If this is the shared instance, don't go any further
	if (self == self.class.sharedInstance)	return;
	// Class method - set last modified
	[self.class setLastModifiedKey:key forInstance:self];
	// Instance method - dummy setValue to dispatch notifications
	[self.class.sharedInstance setValue:self forKey:@"keyChanged"];
/** KVO  class-level block! *//*

	[SampleObject setLastChangedBlock:^(NSS *whatKeyChanged, id whichInstance, id newVal) {

		_result = $(@"Object: %@'s valueForProp:\"%@\" changed to: %@\n",	[(BaseModel*)whichInstance uniqueID], whatKeyChanged, newVal);
	}];																																								
	
*/
	KVOLastChangedBlock b = ((BaseModel*)self.class.sharedInstance).lastChangedBlock;
	b ? b(key, self, value) : nil;
}
+ (void) setLastModifiedKey:(NSS*)k forInstance:(id)obj	{

	lastModifiedKey			= k;	lastModifiedInstance		= obj;
}
+ (instancetype) lastModifiedInstance							{	return lastModifiedInstance;	}
+ (NSS*) 		  lastModifiedKey									{	return lastModifiedKey;			}

- (instancetype) keyChanged										{  return self.class.sharedInstance; }
/** keyChanged -	dummy key set by setValue:forKey: on sharedInstance, used 2 dispatch KVO notes. */
- (void)setKeyChanged: (id) dummy								{		}

+ (void) setLastChangedBlock:(KVOLastChangedBlock)lastChangedBlock 	{

	[self.sharedInstance setLastChangedBlock:lastChangedBlock];
}
- (void) setLastChangedBlock:(KVOLastChangedBlock)lastChangedBlock	{

	[self setAssociatedValue:[lastChangedBlock copy] forKey:@"lastChangedBlockStorage" policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}
- (KVOLastChangedBlock) lastChangedBlock 										{

	return [self associatedValueForKey:@"lastChangedBlockStorage"] ?: nil;
}

+ (void) setOnInitBlock:(KVONewInstanceBlock)onInitBlock 				{	[self.sharedInstance setOnInitBlock:onInitBlock];	}
- (void) setOnInitBlock:(KVONewInstanceBlock)onInitBlock					{

	[self setAssociatedValue:[onInitBlock copy] forKey:@"onInitBlockStorage" policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}
- (KVONewInstanceBlock) onInitBlock		 										{

	return	 [self associatedValueForKey:@"onInitBlockStorage"] ?: nil;
}



- (void) swizzleSave									{

	NSLog(@"swizzlin!");
	[self swizzleSave];
	if (self.convertToXML) {
		NSS* saveP = [self.class saveFilePath];
		NSLog(@"converting to XML: %@", saveP);
		if ([AZFILEMANAGER fileExistsAtPath:saveP])
			[AtoZ plistToXML:saveP];
	}
}
+ (NSS*) saveFilePath 								{	return [NSB.applicationSupportFolder withPath:self.saveFile];	}
- (BOOL) convertToXML								{

	if ([self respondsToSelector:@selector(convertToXML)]) return self.convertToXML;
	return	[self hasAssociatedValueForKey: $UTF8(&CONVERTTOXML_KEY)]? [objc_getAssociatedObject(self, &CONVERTTOXML_KEY) boolValue] : NO;
}
- (void) setConvertToXML:(BOOL)convertToXML	{

	objc_setAssociatedObject(self, &CONVERTTOXML_KEY, @(convertToXML), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSA*) superProperties 							{ return  [BaseModel propertyNames]; }
- (NSS*) uniqueID										{

	NSS* u 	=	[self associatedValueForKey:@"uniqueid"];
	if (!u)		[self setAssociatedValue: self.class.newUniqueIdentifier
			  								forKey: @"uniqueid" policy: OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	return u ?: [self associatedValueForKey:@"uniqueid"];
}

-   (id) objectAtIndexedSubscript:(NSUI)idx	 						{

	return [self respondsToSelector:@selector(objectAtIndex:)] ? [(NSA*)self objectAtIndex:idx] : AZNULL;
}
- (void) setObject:(id)o atIndexedSubscript:(NSUI)idx  			{

	if ([self respondsToSelector:@selector(setObject:atIndex:)])
		 [(NSMutableOrderedSet*)self setObject:o atIndex:idx];
}
- (void) setObject:(id)o forKeyedSubscript:(id<NSCopying>)key	{

	if ([self canSetValueForKey:[(id)key stringValue]]) [self setValue:o forKey:[(id)key stringValue]];
	else  [self setAssociatedValue:o forKey:[(id)key stringValue] policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}
-   (id) objectForKeyedSubscript:(id)key 								{

	return 	[self hasPropertyForKVCKey:key] ? [self valueForKey:key] :
				[self valueForKeyPath:[(id)key stringValue]] ?: [self associatedValueForKey:[(id)key stringValue]] ?: AZNULL;
}
-   (id) valueForUndefinedKey:(NSS*)key 								{			NSS *class = NSStringFromClass([self class]);

	return  [self associatedValueForKey:key]
											?: ^{		LOGCOLORS(RANDOMCOLOR, NSStringFromClass(self.class), GRAY3, @"%@ instance could not find a value for undefined key:", YELLOW, key);
						return NO; }() ? AZNULL : nil;
}

@end
/*- (void) swizzleSetUp 								{ 		 instanceNumber++;  COLORLOG(RED, @"swizzled setup... instance#: %ld", instanceNumber);
								 [self setAssociatedValue:@(instanceNumber) forKey:@"instanceNumber" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
								 [self swizzleSetUp];
}
+ (instancetype) swizzleInstance 				{   return [self swizzleInstance]; }
+ (instancetype) swizzleInstanceWithObject:(id)obj {	NSLog(@"swizzlin!");	[self swizzleInstanceWithObject:obj];	id theInstance = self.instance;	//	if ( [[theInstance methodNames] filterOne:^BOOL(NSS* o){	return [o contains:@"setWithDictionary"]; }] )	if ([theInstance respondsToSelector:@selector(setWithDictionary:)] && [obj isKindOfClass:NSD.class])		[theInstance setWithDictionary:obj];	else if (	[obj isKindOfClass:NSD.class])		[theInstance setPropertiesWithDictionary:obj];	else	theInstance = [self instanceWithObject:obj];	return theInstance;		} */

@interface AtoZ ()
@property (nonatomic, assign) BOOL fontsRegistered;
@end

@interface AToZFuntion	: BaseModel
@property (strong, NATOM) NSS* name;
@property (strong, NATOM) NSIMG* icon;
@end

#import "AtoZUmbrella.h"

//@synthesize sManager; - (id)init {	self = [super init];	if (self) {	static NSA* cachedI = nil;

//	AZLOG($(	@"AZImage! Name: %@.. SEL:%@", name, NSStringFromSelector(_cmd)));	NSIMG *i;  // =  [NSIMG  new];//imageNamed:name];
//	if (!i) dispatch_once:^{		[[NSIMG alloc]initWithContentsOfFile: [AZFWORKBUNDLE pathForImageResource:name]];
//		i =  [NSIMG imageNamed:name];	i.name 	= i.name ?: name;	 }();	i = [NSIMG imageNamed:name];	return i;

//	return [NSIMG imageNamed:name];	?: [[NSIMG alloc]initWithContentsOfFile: [AZFWORKBUNDLE pathForImageResource:name]];
//	i.name 	= i.name ?: name;	return/ i;	}

@implementation AtoZ
@synthesize fonts, fontsRegistered, basicFunctions;

- (void) setUp 						{
	[AZStopwatch named:@"AtoZ.framework Setup Time" block:^{
//		[NSApp setApplicationIconImage:[NSIMG imageNamed:@"logo.png"]];

//		[DDLog addLogger:SHAREDLOG]; 		// Standard lumberjack initialization
//		SHAREDLOG.colorsEnabled = YES;	// And then enable colors
//		[@[@"Error", @"Warn", @"Info"]]
//		[@[@"DDLogError", @"DDLogWarn", @"DDLogInfo", @"DDLogVerose"] each:^(id obj) {
	//		[NSS.randomDicksonism respondsToStringThenDo:obj];
	//	}];
	//	NSLog(COLOR_ESC @"bg89,96,105;" @"Grey background" XCODE_COLORS_RESET);
	//	NSLog(COLOR_ESC @"fg0,0,255;" COLOR_ESC @"bg220,0,0;"	 @"Blue text on red background" XCODE_COLORS_RESET);
	//	NSLog(XCODE_COLORS_ESCAPE @"fg209,57,168;" @"You can supply your own RGB values!" XCODE_COLORS_RESET);

	//	DDLogError  (@"Paper jam"										);							  // Red
	//	DDLogWarn   (@"Toner is low"									);							// Orange
	//	DDLogInfo   (@"Warming up printer (pre-customization)");  // Default (black)
	//	DDLogVerbose(@"Intializing protcol x26"						);			  // Default (black)
		
		// Now let's do some customization:
		// Info  : Pink
		
	#if TARGET_OS_IPHONE
		UIColor *pink = [UIColor colorWithRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
	#else
		NSColor *pink = [NSColor colorWithCalibratedRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
	#endif
//		[SHAREDLOG setForegroundColor:pink backgroundColor:nil forFlag:LOG_FLAG_INFO];
	//	DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
			
	//		[AZFWORKBUNDLE cacheNamedImages];
	//		_cachedImages = cachedI;
			fonts = self.fonts;
	//		Sound *rando = [Sound randomSound];
	//		[[SoundManager sharedManager] prepareToPlayWithSound:rando];
	//		[[SoundManager sharedManager] playSound:rando];
	//		[self registerHotKeys];
	}];
}

+ (void) testSizzle 					{

	AZLOG(@"The original, non -siizled");
	AZLOG(NSStringFromSelector(_cmd));
}
+ (void) testSizzleReplacement	{

	AZLOG(@"Totally swizzed OUT ***************************");
	[self testSizzleReplacement];
	AZLOG(NSStringFromSelector(_cmd));
//	[[AtoZ class] testSizzle];
//	[$ swizzleClassMethod:@selector(testSizzle) in:[AtoZ class] with:@selector(testSizzleReplacement) in:[AtoZ class]];
//	[[AtoZ class] testSizzle];
}
+ (void) initialize 					{ 	LogStackAndReturn(self.bundle);} // @"AtoZ.framework Initialized!"); }
+ (NSS*) version						{
	NSString *myVersion	= [AZFWORKBUNDLE infoDictionary][@"CFBundleShortVersionString"];
	NSString *buildNum 	= [AZFWORKBUNDLE infoDictionary][(NSString*)kCFBundleVersionKey];
	return LogAndReturn( $(@"Version: %@ (%@)", myVersion ?: @"N/A", buildNum ?: @"N/A"));
	//	AZLOG(versText); return versText;
}
+ (NSB*) bundle 						{	return [NSBundle bundleForClass:self.class]; }
+ (NSS*) resources 					{ return self.bundle.resourcePath; }
+ (NSUserDefaults*) defs			{	return [NSUserDefaults standardUserDefaults];	}
- (NSS*) description 				{	return [[self.propertiesPlease valueForKey:@"description"] componentsJoinedByString:@""];	}

//#define LOGWARN(fmt, ...) NSLog((@"%s [Line %d] " XCODE_COLORS_ESCAPE @"fg218,147,0;" fmt XCODE_COLORS_RESET), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

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

+ (void) playRandomSound 			{	[[SoundManager sharedManager] playSound:[Sound randomSound] looping:NO]; }
+ (void) playSound: (id)number	{   //[ playSound:@1];

	NSA *sounds = @[@"welcome.wav", @"bling"];
	NSS *select = number ? [sounds filterOne:^BOOL(id object) { 
		return [(NSS*)object contains:number] ? YES : NO; }] : sounds[0];
	NSS *song   = select ? select : sounds[0];						   
	NSLog(@"Playing song: %@", song);
	[SoundManager.sharedManager  playSound:song looping:NO];
	
}
+ (void) setSoundVolume:(NSUI)outtaHundred { SoundManager.sharedManager.soundVolume = outtaHundred / 100.0; }

// Place inside the @implementation block - A method to convert an enum to string
+ (NSS*) stringForPosition: (AZPOS)enumVal	{

	static NSArray *enumVals = nil;  if (!enumVals) enumVals = [[NSA alloc]initWithObjects:AZWindowPositionTypeArray];
	return enumVals.count >= enumVal ? enumVals[enumVal] : @"outside of range for Positions";
}
// A method to retrieve the int value from the NSArray of NSStrings
+ (AZPOS) positionForString:	(NSS*)strVal	{	return (AZPOS) [[[NSA alloc]initWithObjects:AZWindowPositionTypeArray] indexOfObject:strVal]; }
+ (NSS*) stringForType:	 (id)type			{

	Class i = [type class];	NSLog(@"String: %@   Class:%@", NSStringFromClass(i), i);		//	[type autoDescribe:type];
	NSString *key = [NSString stringWithFormat:@"AZOrient_%@", NSStringFromClass([type class])];
	return NSLocalizedString(key, nil);
}

//- (void) setUp {
//	char *xcode_colors = getenv(XCODE_COLORS);
//	xcode_colors && (strcmp(xcode_colors, "YES") == 0) ? ^{/* XcodeColors=installed+enabled! */}() : nil;
//	[DDLog addLogger:[DDTTYLogger sharedInstance]];
//	DDLogVerbose(@"Verbose"); DDLogInfo(@"Info"); DDLogWarn(@"Warn"); DDLogError(@"Error");
//	[self registerFonts:(CGF)]
//	self.sortOrder = AZDockSortNatural;
//	[[[AZSoundEffect alloc]initWithSoundNamed:@"welcome.wav"]play];
//}


+ (NSA*) appCategories 		{		static NSArray *cats;  return cats = cats ? cats :
	@[	@"Games", @"Education", @"Entertainment", @"Books", @"Lifestyle", @"Utilities", @"Business", @"Travel", @"Music", @"Reference", @"Sports", @"Productivity", @"News", @"Healthcare & Fitness", @"Photography", @"Finance", @"Medical", @"Social Networking", @"Navigation", @"Weather", @"Catalogs", @"Food & Drink", @"Newsstand" ];
//+ (NSA*) appCategories {	return [AZAppFolder sharedInstance].appCategories; }
}
+ (NSA*) macPortsCategories{		static NSArray *mPortsCats;  return mPortsCats = mPortsCats ? mPortsCats :
	@[@"amusements", @"aqua", @"archivers", @"audio", @"benchmarks", @"biology", @"blinkenlights", @"cad", @"chat", @"chinese", @"comms", @"compression", @"cross", @"crypt", @"crypto", @"database", @"databases", @"devel", @"editor", @"editors", @"education", @"electronics", @"emacs", @"emulators", @"erlang", @"fonts", @"framework", @"fuse", @"games", @"genealogy", @"gis", @"gnome", @"gnustep", @"graphics", @"groovy", @"gtk", @"haskell", @"html", @"ipv6", @"irc", @"japanese", @"java", @"kde", @"kde3", @"kde4", @"lang", @"lua", @"macports", @"mail", @"mercurial", @"ml", @"mono", @"multimedia", @"mww", @"net", @"network", @"news", @"ocaml", @"office", @"palm", @"parallel", @"pdf", @"perl", @"php", @"pim", @"print", @"python", @"rox", @"ruby", @"russian", @"scheme", @"science", @"security", @"shells", @"shibboleth", @"spelling", @"squeak", @"sysutils", @"tcl", @"tex", @"text", @"textproc", @"tk", @"unicode", @"vnc", @"win32", @"wsn", @"www", @"x11", @"x11-font", @"x11-wm", @"xfce", @"xml", @"yorick", @"zope"];
}
+ (NSA*) dock 					{	return (NSA*)[AZDock sharedInstance];
}
+ (NSA*) dockSorted 			{ 	return [AZFolder samplerWithCount:20];} // sharedInstance].dockSorted; }

+ (void) plistToXML: (NSS*) path	{

	[NSTask launchedTaskWithLaunchPath:@"/usr/bin/plutil" arguments:@[@"-convert", @"xml1", path]];
}


#define GROWL_ENABLED 0
#ifdef GROWL_ENABLED
- (BOOL) registerGrowl 	{

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
-(void) growlNotificationWasClicked:(id)clickContext {

	NSLog(@"got clickback from growl... ");
	NSLog(@"clickback: ", clickContext);

}
#endif

+ (void) trackIt {	[NSThread performBlockInBackground:^{		trackMouse();		}];	}
- (void) mouseSelector {	NSLog(@"selectot triggered!  by notificixation, even!");	}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+ (NSA*) fonts 	{ return AtoZ.sharedInstance.fonts; 

//+ (NSFont*) fontWithSize:(CGF)fontSize {	return 	[AtoZ  registerFonts:fontSize]; }
}
- (NSA*) fonts		{
	return fonts = fonts ?:	
	[[[[AZFILEMANAGER pathsOfContentsOfDirectory:[AZFWRESOURCES withPath:@"/Fonts"]]URLsForPaths] filter: ^BOOL(NSURL* obj) { return obj == nil ?: ^{
			FSRef fsRef;	  
			CFURLGetFSRef( (CFURLRef)obj, &fsRef );  
			NSError *err;
			OSStatus status = ATSFontActivateFromFileReference(	&fsRef, 	kATSFontContextLocal, 
																								kATSFontFormatUnspecified, NULL, 
																								kATSOptionFlagsDefault, 	NULL);
			return  status == noErr  ?: ^ {
				NSERR *error = [NSERR errorWithDomain:NSOSStatusErrorDomain code:status userInfo:nil];
				AZLOG($(@"Error: %@\nFailed to acivate font at %@!", error, obj));
				return  NO;  }();
		}();
	}] map:^id(NSURL *obj) {
		CFArrayRef desc = CTFontManagerCreateFontDescriptorsFromURL((__bridge CFURLRef)obj);
		return [((NSA*)CFBridgingRelease(desc))[0] objectForKey:@"NSFontNameAttribute"] ?: @"N/A";
	}];


//#pragma GCC diagnostic ignored "-Wdeprecated-declarations"	- (NSFont*) registerFonts:(CGF)size {		if (!_fontsRegistered) {		NSBundle *aBundle = [NSBundle bundleForClass: [AtoZ class]]	NSURL *fontsURL = [NSURL fileURLWithPath:$(@"%@/Fonts",[aBundle resourcePath])]; if(fontsURL != nil)	{	OSStatus status;		FSRef fsRef;			NSError *err;				CFURLGetFSRef((CFURLRef)fontsURL, &fsRef);			status = ATSFontActivateFromFileReference(&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified, NULL, kATSOptionFlagsDefault, NULL);			if (status != noErr)		{				err = @"Failed to acivate fonts!";  goto err;			} else  { _fontsRegistered = 1; NSLog(@"Fonts registered!"); }	} else NSLog(@"couldnt register fonts!");	}	return  [NSFont fontWithName:@"UbuntuTitling-Bold" size:size]; } #pragma GCC diagnostic warning "-Wdeprecated-declarations"

}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

#define AZNOCACHE NSURLRequestReloadIgnoringLocalCacheData

+ (NSJSONSerialization*) jsonRequest:(NSS*)url { return [self.sharedInstance jsonRequest:url]; }
- (NSJSONSerialization*) jsonRequest:(NSS*)url {

	NSError *err;
	NSData *responseData = [NSURLC sendSynchronousRequest: [NSURLREQ requestWithURL:$URL(url) cachePolicy:AZNOCACHE timeoutInterval:10.0] 										   returningResponse:nil error:&err];
	if (!responseData || err) {			NSLog(@"Connection Error: %@", err.localizedDescription); return; 	}
	else	return  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&err];
	
//	if (err) { NSAlert *alert = [NSAlert alertWithMessageText:@"Error parsing JSON" defaultButton:@"Damn that sucks" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Check your JSON"];	[alert beginSheetModalForWindow:[[NSApplication sharedApplication]mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];		return; }
}

/* self.dock =   [self.dockOutline arrayUsingIndexedBlock:^id(AZFile *obj, NSUInteger idx) {
 AZFile *app = [AZFile instanceWithPath:[obj valueForKey:@"path"]];
 app.spot = [[obj valueForKey:@"spot"]unsignedIntegerValue ];
 app.dockPoint = [[obj valueForKey:@"dockPoint"]pointValue];
 NSLog(@"Created file: %@... idx:%ld", app.name, idx);
 return app; }]; return dock;  //		}waitUntilDone:YES];	return _dock;	}

//- (NSA*) dockSorted {	self.sortOrder = AZDockSortColor;	//	[NSThread performBlockInBackground:^{
//	if (!_dockSorted)
//		[[NSThread mainThread] performBlock:^{
//	if (!dockSorted)
			return  [[[dock sortedWithKey:@"hue" ascending:YES] reversed] arrayUsingIndexedBlock:^id(AZFile* obj, NSUInteger idx) {
//				if ([obj.name isEqualToString:@"Finder"]) {
//					obj.spotNew = 999;
//					obj.dockPointNew = obj.dockPoint;
//				} else {
					obj.spotNew = idx;
					obj.dockPointNew = [[dock[idx]valueForKey:@"dockPoint"]pointValue];
//				}
				return obj;
			}];
//	return dockSorted;
//		}waitUntilDone:YES];
//	return _dockSorted;
//		[[NSThread mainThread] performBlock:^{
//			 _dockSorted = adock.mutableCopy;
//		} waitUntilDone:YES];
//	}];
//	return _dockSorted;
}
*/

- (void)performBlock: (VoidBlock)block waitUntilDone:(BOOL)wait 	{

	NSThread *newThread = [NSThread new];
	[NSThread performSelector:@selector(az_runBlock:) onThread:newThread withObject:[block copy] waitUntilDone:wait];
}
+ (void)az_runBlock:(VoidBlock)block 										{ block(); }
+ (void)performBlockInBackground:(VoidBlock)block 						{

	[NSThread performSelectorInBackground:@selector(az_runBlock:) withObject:[block copy]];
}

/*+ (NSA*) appFolderSorted {
	return [AZAppFolder sharedInstance].sorted;
		[AZFiles sharedInstance].appFolderSorted = [AZFiles.sharedInstance.appFolder sortedWithKey:@"hue" ascending:YES].reversed.mutableCopy;
		//	return  [AZFiles sharedInstance].appFolderSorted;
}
+ (NSA*) appFolder {
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
	return (NSA*)[AZAppFolder sharedInstance];
}

+ (NSA*) appFolderSamplerWith:(NSUInteger)apps {

	[AZStopwatch start:@"appFolderSampler"];
	return (NSA*)[AZFolder appFolderSamplerWith:apps andMax:apps];
	[AZStopwatch stop:@"appFolderSampler"];
}
- (NSArray *)uncodableKeys	{	return [self.class.sharedInstance uncodableKeys]; //[NSArray arrayWithObject:@"uncodableProperty"]; }
- (void)setWithCoder:(NSCoder *)coder { [super setWithCoder:coder];	self. = DECODE_VALUE([coder decodeObjectForKey: @"uncodableProperty"];}

- (void)encodeWithCoder:(NSCoder *)coder	{
	[super encodeWithCoder:coder];
	[coder encodeObject:@"uncodable" forKey:@"uncodableProperty"];
}

*/

-  (NSP) convertToScreenFromLocalPoint:(NSP)point relativeToView:(NSV*)view	{
	NSScreen *currentScreen = NSScreen.currentScreenForMouseLocation;
	return currentScreen ? (NSP) ^{	NSP windowPoint = [view convertPoint:point toView:nil];
												NSP screenPoint = [[view window] convertBaseToScreen: windowPoint];
												return AZPointOffsetY([currentScreen flipPoint: screenPoint], [currentScreen frame].origin.y);
						  }() : NSZeroPoint;
}
- (void) moveMouseToScreenPoint:			(NSP)point {	CGSUPRESSINTERVAL(0); CGWarpMouseCursorPosition(point); CGSUPRESSINTERVAL(.25); }
- (void) handleMouseEvent:(NSEventMask)event inView:(NSV*)view withBlock:(VoidBlock)block 	{

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

//+ (NSA*) fengshui {	return [[self class] fengShui]; }
//+ (NSA*) fengShui {	return [NSC.fengshui.reversed map:^id(id obj) {	AZFile *t = [AZFile instance]; t.color = obj; return t; }]; }

//NSArray *AllApplications(NSArray *searchPaths) { NSMA *applications = NSMA.new; NSEnumerator *searchPathEnum = [searchPaths objectEnumerator]; NSString *path;	while (path = [searchPathEnum nextObject]) ApplicationsInDirectory(path, applications);	return ([applications count]) ? applications : nil; }

+ (NSA*) runningApps 			{	return [self.class.runningAppsAsStrings arrayUsingBlock:^id(id obj) { return [AZFile instanceWithPath:obj];	}]; }
+ (NSA*) runningAppsAsStrings {

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

static void soundCompleted(SystemSoundID soundFileObject, void *clientData) { // Clean up.

	if (soundFileObject != kSystemSoundID_UserPreferredAlert) AudioServicesDisposeSystemSoundID(soundFileObject);
}
+ (void) playNotificationSound:(NSD*)apsDictionary		{
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

+ (void) badgeApplicationIcon:(NSS*)string				{

	NSDockTile *dockTile = [[NSApplication sharedApplication] dockTile];
	if (string != nil)  [dockTile setBadgeLabel:string];
	else				[dockTile setBadgeLabel:nil];

}

@end
@implementation AtoZ (MiscFunctions)

+ (void) say:(NSString *)thing {
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


+	(CGP) centerOfRect:	 (CGR)rect 												{ return AZCenterOfRect(rect); 

//	CGF midx = CGRectGetMidX(rect);CGF midy = CGRectGetMidY(rect);return CGPointMake(midx, midy);
}
+   (void)printCGRect:	   (CGR)cgRect 												{	[AtoZ printRect:cgRect];	}
+   (void) printRect:		(NSR)toPrint												{	
	NSLog(@"Rect is x: %i y: %i width: %i height: %i ", (int)toPrint.origin.x, (int)toPrint.origin.y,
		  (int)toPrint.size.width, (int)toPrint.size.height);
}
+   (void) printCGPoint:	 (CGP)cgPoint 											{	[AtoZ printPoint:cgPoint];	}
+   (void) printPoint:		 (NSP)toPrint 											{		NSLog(@"Point is x: %f y: %f", toPrint.x, toPrint.y);	}
+   (void) printTransform:   (CGAffineTransform)t 									{
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.a, t.b);
	NSLog(@"[ %1.1f %1.1f 0.0 ]", t.c, t.d);
	NSLog(@"[ %1.1f %1.1f 1.0 ]", t.tx, t.ty);
}
+	(CGF) clamp:(CGF)v from:(CGF)minimum  to:(CGF)maximum 						{
	return v = v < minimum 	 ? minimum : v > maximum ? v= maximum : v;
}
+	(CGF) scaleForSize:	 (CGS)size inRect:(CGR)rect							{
	CGF hScale = rect.size.width / size.width;
	CGF vScale = rect.size.height / size.height;
	return  MIN(hScale, vScale);
}
+	(CGR) centerSize:		 (CGS)size inRect:(CGR)rect 							{
	CGF scale = [[self class] scaleForSize:size inRect:rect];
	return AZMakeRect(	CGPointMake ( rect.origin.x + 0.5 * (rect.size.width  - size.width),
									 rect.origin.y + 0.5 * (rect.size.height - size.height) ),
					  CGSizeMake(size.width * scale, size.height * scale) );
}
+	(NSR) rectFromPointA:   (NSP)pointA 			andPointB:(NSP)pointB 		{

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
+ (NSIMG*) cropImage:		(NSIMG*)sourceImage withRect:(NSR)sourceRect 	{

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

//@implementation CAConstraint (brevity)
//+(CAConstraint*)maxX {	return AZConstraint(kCAConstraintMaxX,@"superlayer");	}
//@end

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
