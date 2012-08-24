//
//  AppDelegate.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/27/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "EncyclopediaDelegate.h"
#import "SDNoteWindowController.h"
#import "SDGeneralPrefPane.h"

@interface EncyclopediaDelegate (Private)

- (void) createNoteWithDictionary:(NSDictionary*)dictionary;
- (void) loadNotes;
- (void) saveNotes;
@end

@implementation EncyclopediaDelegate
@synthesize noteControllers;

- (id) init {
	if (self = [super init]) {
		self.noteControllers = [NSMutableArray array];// retain];
//		self.s = [[AZSimpleView alloc]initWithFrame:AZScaleRect(AZScreenFrame(), .23)];
//		self.at = [[AZAttachedWindow alloc]initWithView:self.s attachedToPoint:AZCenterOfRect(AZMenuBarFrame()) atDistance: 11];
	}
	return self;
}

- (void) awakeFromNib {
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	[statusItem setImage:[NSImage systemImages].randomElement];
	// [NSImage imageNamed:@"atoz"]];//statusimage"]];
	[statusItem setAlternateImage:[NSImage systemImages].randomElement];
//[NSImage imageNamed:@"statusimage_pressed"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];


		// Get the shielding window level
		//		NSInteger windowLevel =
		//		CGShieldingWindowLevel();
		// Get the screen rect of our main display
	NSRect screenRect = [[NSScreen mainScreen] frame];

		// Put up a new window
//	self.mainWindow = [[NSWindow alloc] initWithContentRect:screenRect
//												  styleMask:NSBorderlessWindowMask
//													backing:NSBackingStoreBuffered
//													  defer:NO screen:[NSScreen mainScreen]];


	trackers = @[

		self.left 	= [AZTrackingWindow initWithRect:AZLeftEdge(screenRect, 50) andID:@"left"],
		self.top 	= [AZTrackingWindow initWithRect:AZMakeRectMaxXUnderMenuBarY(50) andID:@"top"],
		self.right	= [AZTrackingWindow initWithRect:AZRightEdge(screenRect,50) andID:@"right"]
	];
	[trackers each:^(id obj, NSUInteger index, BOOL *stop) {

		[obj setDelegate:self];
		[obj makeKeyAndOrderFront:obj];
	}];

//	[@[_left, _top, _right] each:^(id obj, NSUInteger index, BOOL *stop) {
//		[obj makeKeyAndOrderFront:obj];
//	}];

//	[_mainWindow setLevel:NSStatusWindowLevel];
//	[_mainWindow setMovable:NO];
//	[_mainWindow setBackgroundColor:CLEAR];
//	[_mainWindow setAlphaValue:.2];

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

// app delegate methods

- (void) applicationDidFinishLaunching:(NSNotification*)notification {
	[_mainWindow makeKeyAndOrderFront:nil];
//	[self toggleWindow:_attachPoint];
}

- (void) applicationDidResignActive:(NSNotification *)notification {
//	[[NSApplication sharedApplication]hide:self];
}
- (void)applicationWillTerminate:(NSNotification *)notification {
	[self saveNotes];
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


- (void) saveNotes {
	NSMutableArray *array = [NSMutableArray array];
	
	for (SDNoteWindowController *controller in self.noteControllers)
		[array addObject:[controller dictionaryRepresentation]];
	
	[SDDefaults setObject:array forKey:@"notes"];
}

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

- (IBAction) removeAllNotes:(id)sender {
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
	
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

- (NSArray*) instructionImageNames {
	return @[ @"1.pdf", @"2.pdf", @"3.pdf" ];
}

- (BOOL) showsPreferencesToolbar {
	return YES;
}

- (NSArray*) preferencePaneControllerClasses {
	return @[[SDGeneralPrefPane class]];
}


- (void)toggleWindowInWindow:(id)window atPoint:(NSPoint) buttonPoint
{

	// Attach/detach window
    if (!_attachedWindow) {
		self.attachedWindow = [[MAAttachedWindow alloc] initWithView:_view
													 attachedToPoint:_attachPoint
															inWindow:nil
															  onSide:_side
														  atDistance:0];
		[_attachedWindow setHidesOnDeactivate:NO];
		//[_attachedWindow setBorderColor:BLACK];
//        [textField setTextColor:WHITE];
//        [_attachedWindow setBackgroundColor:RED];
//        [attachedWindow setViewMargin:[viewMarginSlider floatValue]];
//        [attachedWindow setBorderWidth:[borderWidthSlider floatValue]];
//        [attachedWindow setCornerRadius:[cornerRadiusSlider floatValue]];
//        [attachedWindow setHasArrow:([hasArrowCheckbox state] == NSOnState)];
//        [attachedWindow setDrawsRoundCornerBesideArrow:
//		 ([drawRoundCornerBesideArrowCheckbox state] == NSOnState)];
//        [attachedWindow setArrowBaseWidth:[arrowBaseWidthSlider floatValue]];
//        [attachedWindow setArrowHeight:[arrowHeightSlider

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
        [_attachedWindow release];
        _attachedWindow = nil;
    }
}


//-(void)trackerDidReceiveEvent:(NSEvent*)event inRect:(NSRect)theRect {
//
//	NSLog(@"did receive track event: %@ in rect %@", event, NSStringFromRect(theRect));
//	
//}
//
//-(void)ignoreMouseDown:(BOOL*)event {
//	[[_mainWindow nextResponder] mouseDown:event];
//}

@end
