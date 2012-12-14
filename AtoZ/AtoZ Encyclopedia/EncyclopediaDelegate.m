
//  AppDelegate.m
//  DeskNotation
//  Created by Steven Degutis on 6/27/09.
#import "EncyclopediaDelegate.h"
//#import "SDNoteWindowController.h"
#import "SDGeneralPrefPane.h"
#import <AtoZ/AtoZ.h>

@interface EncyclopediaDelegate (Private)
- (void) createNoteWithDictionary:(NSDictionary*)dictionary;
- (void) loadNotes;
- (void) saveNotes;
@end

@implementation EncyclopediaDelegate
@synthesize noteControllers, statusItem, statusMenu;

- (id) init {
	if (self = [super init]) {
		self.noteControllers = [NSMutableArray array];// retain];
		self.at = [[AZAttachedWindow alloc]initWithView:self.s attachedToPoint:AZCenterOfRect(AZMenuBarFrame()) atDistance: 11];
	}
	return self;
}

- (void) awakeFromNib {
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	statusItem.image  = [[NSImage az_imageNamed:@"atoz.icns"]scaledToMax:22];
//   // [NSImage icons][0];//
//statusimage
//	statusItem.alternateImage	= [NSImage icons][11];//.randomElement; //[NSImage imageNamed:@"statusimage_pressed"]];
	statusItem.highlightMode = YES;
	statusItem.menu			= statusMenu;
		// Get the shielding window level
		//		NSInteger windowLevel = CGShieldingWindowLevel();
		// Get the screen rect of our main display
	NSRect screenRect = [[NSScreen mainScreen] frame];
		// Put up a new window
	self.mainWindow = [[NSWindow alloc] initWithContentRect:screenRect
												  styleMask:NSBorderlessWindowMask
													backing:NSBackingStoreBuffered
													  defer:NO screen:[NSScreen mainScreen]];

	[_mainWindow setLevel:NSStatusWindowLevel];
//	[_mainWindow setMovable:YES;
	[_mainWindow setOpaque : NO];
	[_mainWindow setBackgroundColor:CLEAR];
	[_mainWindow setAlphaValue:0];
	[_mainWindow orderFrontRegardless];
	self.view = [[AZSimpleView alloc]initWithFrame: NSInsetRect(screenRect, 200, 200) ];
//	AZScaleRect(AZScreenFrame(), .23)];
//	[_view setBackgroundColor:RANDOMCOLOR];

//	[_mainWindow setContentView:_view];
//	AZSimpleView *aview = [[AZSimpleView alloc]initWithFrame: NSInsetRect(_view.frame, 200, 200) ];
//	aview.backgroundColor = ORANGE;
//	[[_mainWindow contentView] addSubview:_view];
//	[_view setNeedsDisplay:YES];
//	[_mainWindow setIgnoresMouseEvents:YES];
//	NSWindow *d = [[NSWindow alloc] initWithContentRect: NSInsetRect(screenRect, 200, 100)
//												  styleMask:NSBorderlessWindowMask
//													backing:NSBackingStoreBuffered
//													  defer:NO ];
//	d.backgroundColor = CLEAR;

//	[_mainWindow addChildWindow:d ordered:NSWindowAbove];
//	[self fiesta];
//	CGFloat intrusion = 60;
//	trackers = @[
//		self.left 	= [AZTrackingWindow oriented:AZOrientLeft intruding:intrusion],
//		self.top 	= [AZTrackingWindow oriented:AZOrientTop intruding:intrusion],
//		self.left 	= [AZTrackingWindow oriented:AZOrientRight intruding:intrusion],
//		self.bottom 	= [AZTrackingWindow oriented:AZOrientBottom intruding:intrusion]
//	];
//	[trackers each:^(id obj, NSUInteger index, BOOL *stop) {
//		[obj setDelegate:self];
//		[obj makeKeyAndOrderFront:obj];
//	}];

//	[@[_left, _top, _right] each:^(id obj, NSUInteger index, BOOL *stop) {
//		[obj makeKeyAndOrderFront:obj];
//	}];

//	self.side = 12;
//	self.view = [[AZSimpleView alloc] initWithFrame:AZMakeRect(NSZeroPoint,(NSSize){200,200})];
//	self.view.backgroundColor = RED;
//	self.attachPoint = AZCenterOfRect(AZMenuBarFrame());

//	[@[_mainWindow, _attachedWindow] each:^(id obj, NSUInteger index, BOOL *stop) {
//	}];
//	[_mainWindow addChildWindow:_attachedWindow ordered:NSWindowAbove];

//	[_at setBackgroundColor:[NSColor colorWithPatternImage:[NSImage prettyGradientImage]]];
//	[_at makeKeyAndOrderFront:_at];

}
- (void) mouseMoved { NSLog(@"mousse mpves:  app deleahe"); }

// app delegate methods
- (void) applicationDidFinishLaunching:(NSNotification*)notification {
//	NSArray *s = [AtoZ dock];
	NSArray *s = [AZFolder appFolder];
	[s eachWithIndex:^(id obj, NSInteger idx) { NSLog(@"%@", [obj propertiesPlease]); }];
	
	NSRect r = [[_mainWindow contentView] frame];
//	AZFileGridView *g = [[AZFileGridView alloc]initWithFrame:r andFiles:s];
//	[[_mainWindow contentView] addSubview:g];

//	[_mainWindow makeKeyAndOrderFront:nil];
//	trackMouse();
//	[self toggleWindow:_attachPoint];
//	NSLog(@"%@ ",  [AtoZ dockSorted]);// valueForKeyPath:@"name"]);

//	AZItemsViewFormat e;
//	NSArray *a = $array(@"/Applications" ) ;
//	id u = AllApplications( a);
//	NSLog(@"%@", u); //;//  [AZLaunchServices allApplicationsFormattedAs:AZItemsAsBundleIDs] );
// 	NSLog(@"%@",[AtoZ appFolder]);
//	BOOL y = [[AtoZ sharedInstance] registerGrowl];

//#ifdef ATOZITUNES_ENABLED
//	[AtoZiTunes searchFor:@"iTunes"];
//#endif
}

- (void) applicationDidResignActive:(NSNotification *)notification {
//	[[NSApplication sharedApplication]hide:self];
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[self saveNotes];
}

- (void)fiesta {
	CGFloat f = AZPerimeter(  AZScreenFrame());
	int unit = floor([AtoZ dockSorted].count / f);

//	[[AtoZ dockSorted]
	 [[AZFolder appFolder] eachWithIndex:^(id obj, NSInteger i){
		NSImageView *k = [[NSImageView alloc]initWithFrame:(NSRect) { i * unit, 0, unit, unit} ];
		k.image = [obj valueForKey:@"image"];
		[_view addSubview: k];
		[k setNeedsDisplay:YES];
		NSLog(@"added image with view,%@, %@", obj, k);
	}];
}
// persistance

- (void) loadNotes {
	NSArray *notes = [SDDefaults arrayForKey:@"notes"];

	if ([notes count] == 0) {
		[self showInstructionsWindow:self];
		[self setOpensAtLogin:YES];
		return;
	}

//	NSArray *start = @[ @{ 	@"frame": NSStringFromRect(<#NSRect aRect#>)

	for (NSDictionary *dict in notes){
		[self createNoteWithDictionary:dict];
//		NSLog(@"dict %@", dict.description);
	}

//	[self createNoteWithDictionary:@{@"title":@"welcome to your app", @"frame": NSStringFromRect( NSMakeRect(1347, 669,404, 77))}];
}
/*
- (void) saveNotes {
	NSMutableArray *array = [NSMutableArray array];

	for (SDNoteWindowController *controller in self.noteControllers)
		[array addObject:[controller dictionaryRepresentation]];

	[SDDefaults setObject:array forKey:@"notes"];
}
*/
// validate menu items

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(addNote:))
		return YES;
	if ([menuItem action] == @selector(removeAllNotes:))
		return ([self.noteControllers count] > 0);
	else
		return [super validateMenuItem:menuItem];
}

// adding and creating notes
/*
- (void) createNoteWithDictionary:(NSDictionary*)dictionary {
	SDNoteWindowController *controller = [[SDNoteWindowController alloc] initWithDictionary:dictionary];// autorelease];
	[self.noteControllers addObject:controller];
}

- (void) removeNoteFromCollection:(SDNoteWindowController*)controller {
	[self.noteControllers removeObject:controller];
}

- (IBAction) addNote:(id)sender {
	[self createNoteWithDictionary:nil];
}
- (IBAction) loadEm:(id)sender {
	[self loadNotes];
}

- (IBAction) removeAllNotes:(id)sender
{
	NSAlert *alert = [NSAlert.alloc init];

	[alert setMessageText:@"Remove all desktop labels?"];
	[alert setInformativeText:@"This operation cannot be undone. Seriously."];

	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];

	if ([alert runModal] == NSAlertFirstButtonReturn)
		[self.noteControllers removeAllObjects];
}
// specifics

- (void) appRegisteredSuccessfully {
	[self loadNotes];
}

- (NSA*) instructionImageNames {
	return [NSImage frameworkImages];//@[ @"mrgray.logo.png", @"1.pdf", @"2.pdf", @"3.pdf" ];
}
*/
- (BOOL) showsPreferencesToolbar {
	return YES;
}

- (NSA*) preferencePaneControllerClasses {
	return @[[SDGeneralPrefPane class]];
}
- (void)toggleWindowInWindow:(id)window atPoint:(NSPoint) buttonPoint
{

	// Attach/detach window
	if (!_attachedWindow) {
		self.attachedWindow = [[AZAttachedWindow alloc] initWithView:_view
													 attachedToPoint:_attachPoint
															inWindow:nil
															  onSide:_side
														  atDistance:0];
		[_attachedWindow setHidesOnDeactivate:NO];
		//[_attachedWindow setBorderColor:BLACK];
//		[textField setTextColor:WHITE];
//		[_attachedWindow setBackgroundColor:RED];
//		[attachedWindow setViewMargin:[viewMarginSlider floatValue]];
//		[attachedWindow setBorderWidth:[borderWidthSlider floatValue]];
//		[attachedWindow setCornerRadius:[cornerRadiusSlider floatValue]];
//		[attachedWindow setHasArrow:([hasArrowCheckbox state] == NSOnState)];
//		[attachedWindow setDrawsRoundCornerBesideArrow:
//		 ([drawRoundCornerBesideArrowCheckbox state] == NSOnState)];
//		[attachedWindow setArrowBaseWidth:[arrowBaseWidthSlider floatValue]];
//		[attachedWindow setArrowHeight:[arrowHeightSlider

//		[_mainWindow addChildWindow:_attachedWindow ordered:NSWindowAbove];
		[_attachedWindow setAlphaValue:0.0];
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:0.5];
		[_attachedWindow makeKeyAndOrderFront:_attachedWindow];
		[[_attachedWindow animator] setAlphaValue:1.0];
		[NSAnimationContext endGrouping];

	} else {
		[_mainWindow removeChildWindow:_attachedWindow];
		[_attachedWindow orderOut:self];
//		[_attachedWindow release];
		_attachedWindow = nil;
	}
}
//-(void)trackerDidReceiveEvent:(NSEvent*)event inRect:(NSRect)theRect {

//	NSLog(@"did receive track event: %@ in rect %@", event, NSStringFromRect(theRect));

//}

//-(void)ignoreMouseDown:(BOOL*)event {
//	[[_mainWindow nextResponder] mouseDown:event];
//}

@end
