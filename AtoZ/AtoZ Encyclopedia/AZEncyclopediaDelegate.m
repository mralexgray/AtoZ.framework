	//
	//  AppDelegate.m
	//  AtoZ Encyclopedia
	//
	//  Created by Alex Gray on 8/2/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import "AZEncyclopediaDelegate.h"

#import "SDToolkit.h"
#import "SDNoteWindowController.h"
#import "SDGeneralPrefPane.h"

@interface AZEncyclopediaDelegate (Private)

- (void) createNoteWithDictionary:(NSDictionary*)dictionary;
- (void) loadNotes;
- (void) saveNotes;

@end

@implementation AZEncyclopediaDelegate
{
	BOOL cancelled;
	NSSplitView *splitView;
}
@synthesize sortToggle;
@synthesize window = _window, controlWindow, pIndi;

- (id) init {
	if (self = [super init]) {
		noteControllers = [NSMutableArray array];
	}
	return self;
}

- (void) applicationDidResignActive:(NSNotification *)notification {
		//	[controlWindow slideUp];
		// orderOut:self];
		//	[self slideWindows:@[controlWindow] upYesDownNo:NO];
		//	[@[controlWindow] each:^(id obj, NSUInteger index, BOOL *stop) {
		//		[obj fadeInYesOrOutNo:NO andResizeTo:[[obj valueForKeyPath:@"dictionary.hiddenRect"]rectValue]];
		//	}];
}
- (void) applicationDidBecomeActive:(NSNotification *)notification{
		//	[controlWindow slideDown];
		//	[NSApp activateIgnoringOtherApps:YES];
		//	[@[controlWindow] each:^(id obj, NSUInteger index, BOOL *stop) {
		//		[obj fadeInYesOrOutNo:YES andResizeTo:[[obj valueForKeyPath:@"dictionary.visibleRect"]rectValue]];
		//		}];
		//	} upYesDownNo:YES];
		//	if (!menuWindowIsShowing) {
}
	//-(void) slideWindows:(NSA*)windies upYesDownNo:(BOOL)direction {
	//	if (direction)
	//		 [windies each:^(id obj, NSUInteger index, BOOL *stop) {
	//			[[]
	//			 [obj orderOut:obj];
	//			 [obj setValue:@YES forKeyPath:@"dictionary.isHidden"];
	//		 }];
	//	else [windies each:^(id obj, NSUInteger index, BOOL *stop) {
	//			[obj orderFront:obj];
	//			[obj setValue:@NO forKeyPath:@"dictionary.isHidden"];
	//			[obj slideDown];
	//			[obj makeKeyAndOrderFront:obj];
	//		 }];
	//}


- (NSA*)questionsForToggleView:(AZToggleArrayView *) view{
	return 	@[@"Sort Alphabetically?", @"Sort By Color?" , @"Sort like Dock", @"Sort by \"Category\"?", @"Show extra app info?" ];

}
- (void)toggleStateDidChangeTo:(BOOL)state InToggleViewArray:(AZToggleArrayView *) view WithName:(NSString *)name{

	NSLog(@"Toggle notifies delegtae:  %@, %@", name, (state ? @"YES"  :@"NO"));

}

- (void)statusView:(AZStatusItemView *)statusItem isActive:(BOOL)active{

		//		[NSApp activateIgnoringOtherApps:YES];
		//		if (active) {
		//		[self slideWindows:@[controlWindow] upYesDownNo: ![controlWindow valueForKeyPath:@"dictionary.isHidden"]];
		//			 [controlWindow slideDown];
		//		 } else [controlWindow slideUp];
}
	// this is the handler the above snippet refers to
- (void) mainSplitViewWillResizeSubviewsHandler:(id)object {
		//	lastSplitViewSubViewLeftWidth = [splitViewSubViewLeft frame].size.width;
	NSLog(@"splitview did sp,etjoing");
}
	//
	//	// wire this to the UI control you wish to use to toggle the
	//	// expanded/collapsed state of splitViewSubViewLeft
	//- (IBAction) toggleLeftSubView:(id)sender
	//{
	//	[splitView adjustSubviews];
	//	if ([splitView isSubviewCollapsed:splitViewSubViewLeft])
	//		[splitView
	//		 setPosition:lastSplitViewSubViewLeftWidth
	//		 ofDividerAtIndex:0
	//		 ];
	//	else
	//		[splitView
	//		 setPosition:[splitView minPossiblePositionOfDividerAtIndex:0]
	//		 ofDividerAtIndex:0
	//		 ];
	//}

- (void)awakeFromNib {

	splitView = [[[_window contentView]allSubviews]filterOne:^BOOL(id object) {
		return ([object isKindOfClass:[NSSplitView class]] ? YES : NO );
	}];
		// subscribe to splitView's notification of subviews resizing
		// (I do this in -(void)awakeFromNib)
	[[NSNotificationCenter defaultCenter]addObserver:self
											selector:@selector(mainSplitViewWillResizeSubviewsHandler:)
												name:NSSplitViewWillResizeSubviewsNotification
											  object:splitView];

		//	self.controlWindow.level = NSScreenSaverWindowLevel;
		//		NSRect underbar = AZMakeRectMaxXUnderMenuBarY(50);
		//		SDN* offscreenWindow = [[NSWindow alloc]
		//									  initWithContentRect:offscreenRect
		//									  styleMask:NSBorderlessWindowMask
		//									  backing:NSBackingStoreRetained
		//									  defer:NO];
		//
		//
		//
		//		[self.controlWindow setValue:[NSValue valueWithRect: underbar] forKeyPath:@"dictionary.visibleRect"];
		//		NSRect zerobar = underbar;
		//		zerobar.size.height = 0;
		//		zerobar.origin.y += underbar.size.height;
		//		[self.controlWindow setValue:[NSValue valueWithRect: zerobar] forKeyPath:@"dictionary.hiddenRect"];
		//
		//		[self.controlWindow setContentSize:underbar.size display:YES animate:NO];
		//		[self.controlWindow setAlphaValue:0];

	[pIndi setUsesThreadedAnimation:YES];
	[pIndi startAnimation:pIndi];
		//	[scaleSlider setAction:@selector(switchViewScale:)];
		//	[orientButton setAction:@selector(swapOrient:)];
	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:statusView
														   selector:@selector(activeAppDidChange:)
															   name:NSWorkspaceDidActivateApplicationNotification object:nil];

		// Create an NSStatusItem.
	NSRect menuFrame = NSMakeRect(0, 0, 30, [[NSStatusBar systemStatusBar] thickness]);
	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:menuFrame.size.width];
	statusView = [[AZStatusItemView alloc] initWithFrame:menuFrame];

	[statusView setDelegate: self];
	[statusItem setView:statusView];//// controller:self]];
	[statusItem setMenu:statusMenu];

	[self makeBadges];
	cancelled = NO;
		//	[_carousel reloadData];
		//	self.infinityView.infiniteObjects = [AtoZ dock];
		//	[self.sortToggle]
		//	NSLog(@"Dock:  %@", dock);

}
	// app delegate methods

	//	menu = [NSMenu new];
	//	[[AtoZ runningApps] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	//		NSMenuItem *i = [NSMenuItem new];
	//		__block NSImage *ii = [obj valueForKey:@"image"];
	//		[ii setSize:NSMakeSize(25,25)];
	//		__block AZSimpleView *av = [AZSimpleView new];
	//		av.gradient = YES;
	//		av.frame = AZMakeRectFromSize(NSMakeSize(30,30));
	//		av.backgroundColor = [obj valueForKey:@"color"];
	//		[av addSubview: [AZBlockView viewWithFrame:AZCenteredRect(NSMakeSize(140,26),AZMakeRectFromSize(NSMakeSize(150,30))) opaque:NO drawnUsingBlock:
	//						 ^(AZBlockView *view, NSRect dirtyRect) {
	//								 //[[blockSelf roundedRectFillColor] set]; [[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:5 yRadius:5] fill]; }]]; }
	//								 //			 view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
	//							 [ii drawAtPoint:NSMakePoint(2.5,2.5) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
	//								 //			NSString *name = [obj valueForKey:@"name"];
	//								 //			[name drawAtPoint:NSMakePoint(26,0) withAttributes:
	//								 //			[name drawAtPoint:NSMakePoint(26,0) withAttributes:@{/*[av.backgroundColor contrastingForegroundColor]*/ WHITE:NSBackgroundColorAttributeName}];//:[view bounds] withFont:@"Helvetica"];
	//								 //			 [[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:20 yRadius:20] fill];
	//						 }]];
	//			//positioned:NSWindowBelow relativeTo:infiniteBlocks];
	//		i.view = av;
	//			//		i.title = [obj valueForKey:@"name"];
	//		[menu addItem:i];
	//	}];
	//	[statusItem setMenu:menu];
	//
	//
	//	[attachedWindow setStyleMask:NSBorderlessWindowMask];
	//	[attachedWindow setFrame:AZMakeRectMaxXUnderMenuBarY(visiSliver) display:NO];
	//	[attachedWindow slideUp];

	//	attachedWindow = [[NSWindow alloc]initWithContentRect:barFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	//	bar = [[AZToggleView alloc]initWithFrame:barFrame];
	//	[attachedWindow setContentView:bar];
	//	[attachedWindow setFrame:barFrame display:NO];
	//	[attachedWindow setBackgroundColor:CLEAR];


	//	- (void)statusView:(AZStatusItemView *)statusItem isActive:(BOOL)active{
	//
	//		shroud = [[NSWindow alloc]initWithContentRect:[[NSScreen mainScreen]visibleFrame]  styleMask: NSBorderlessWindowMask backing: NSBackingStoreRetained defer: NO];
	//
	//		[shroud setBackgroundColor:CLEAR];
	//		[shroud setLevel:NSScreenSaverWindowLevel + 1];
	//		[shroud setHasShadow:NO];
	//		[shroud setAlphaValue:0.0];
	//		[shroud orderFront:self];
	//		[shroud setContentView:[[NSView alloc] initWithFrame:[[NSScreen mainScreen]visibleFrame]]];
	//			//	[[shroud contentView] lockFocus];
	//
	//			//	[shroud setFrame:[[NSScreen mainScreen]visibleFrame] display:YES];
	//		shroudShot = [NSImage imageBelowWindow:shroud];
	//		shroudShotView = [[NSImageView alloc]initWithFrame:[[shroud contentView]frame]];
	//		[shroudShotView setImage:shroudShot];
	//		[[shroud contentView]addSubview:shroudShotView];
	//			//	NSLog(@"image:%@",s);
	//			//	[s saveAs:@"/Users/localadmin/Desktop/poop.png"];
	//		/**	[[shroud contentView]addSubview:
	//		 [AZBlockView viewWithFrame:[[shroud contentView]frame]  opaque:NO drawnUsingBlock:
	//		 ^(AZBlockView *view, NSRect dirtyRect) {
	//		 //[[blockSelf roundedRectFillColor] set]; [[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:5 yRadius:5] fill]; }]]; }
	//		 //															   view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
	//		 [s compositeToPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy];														   }] positioned:NSWindowBelow relativeTo:infiniteBlocks];
	//		 */
	//		[attachedWindow makeKeyAndOrderFront:self];
	//		[NSApp activateIgnoringOtherApps:YES];
	//
	//			//this pops the running apps window.
	//		[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(showMenu) userInfo:nil repeats:NO];
	//
	//		(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
	//		menuWindowIsShowing =! menuWindowIsShowing;
	//			//	[statusView.menu  [self menu]];
	//
	//	}
	//	- (void) showMenu {
	//			// This will show the menu at the current mouse position
	//		[statusItem.menu popUpMenuPositioningItem:[[statusItem menu] itemAtIndex:0] atLocation:[NSEvent mouseLocation] inView:nil];
	//	}

	//- (void)toggleAttachedWindowAtPoint:(NSPoint)pt {
	//	[NSApp activateIgnoringOtherApps:YES];
	//	if (!attachedWindow) {
	//		attachedWindow = [[AZAttachedWindow alloc] initWithView:rootView
	//												attachedToPoint:pt
	//													   inWindow:nil
	//														 onSide:AZPositionBottom
	//													 atDistance:5.0];
	////		[textField setTextColor:[attachedWindow borderColor]];
	////		[textField setStringValue:@"Your text goes here..."];
	//		menuWindowIsShowing = NO;
	//			//	[attachedWindow makeKeyAndOrderFront:self];
	//	}
	////	if (![attachedWindow isAnimating]) {
	//	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
	//	menuWindowIsShowing =! menuWindowIsShowing;
	//}
	//		[attachedWindow orderOut:self];
	//		attachedWindow = nil;

	//	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	//	[statusItem setImage:[NSImage systemImages].randomElement];
	//		// [NSImage imageNamed:@"atoz"]];//statusimage"]];
	//	[statusItem setAlternateImage:[NSImage systemImages].randomElement];
	//		//[NSImage imageNamed:@"statusimage_pressed"]];
	//	[statusItem setHighlightMode:YES];
	//	[statusItem setMenu:statusMenu];
	//	[NSEvent addGlobalMonitorForEventsMatchingMask: NSMouseMoved
	//										   handler:^(NSEvent *event){
	//											   [self pointOnScreenDidChangeTo:event];
	//		if([event modifierFlags] == 1835305 && [[event charactersIgnoringModifiers] compare:@"t"] == 0) {

	//													   [NSApp activateIgnoringOtherApps:YES];
	//												   }
	//										   }];
- (void) applicationDidFinishLaunching:(NSNotification*)notification {
	[self.vc.carousel reloadData];
	[self loadNotes];

		//		[NSThread performBlockInBackground:^{
		//			arrayOfBlocks = [[AtoZ dockSorted] arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
		//				AZFile *block = obj;
		//				AZInfiniteCell *e = [AZInfiniteCell new];
		//					//			AZSimpleView *e = [AZSimpleView new];
		//					//			[e setCanDrawConcurrently:YES];
		//					//			e.representedObject = block;
		//				e.file = block;
		//				e.backgroundColor = block.color;
		//				return e;
		//			}].mutableCopy;
		//			[[NSThread mainThread] performBlock:^{
		//				[infiniteBlocks setInfiniteViews:arrayOfBlocks];
		//				[pIndi stopAnimation:pIndi];
		//			}];
		//
		//		}];
		//
}

- (void)applicationWillTerminate:(NSNotification *)notification {
	[self saveNotes];
}

	// persistance

- (void) loadNotes {
	NSArray *notes = [SDDefaults arrayForKey:@"notes"];

	if ([notes count] == 0) {
		[self showInstructionsWindow:self];
			//		[self setOpensAtLogin:YES];
		return;
	}

	for (NSDictionary *dict in notes){
		[self createNoteWithDictionary:dict];
			//		NSLog(@"dict %@", dict.description);
	}

	[self createNoteWithDictionary:@{@"title":@"wasa", @"frame": [NSValue valueWithRect:NSMakeRect( 200, 669,404, 77)] }];
}
- (void) saveNotes {
	NSMutableArray *array = [NSMutableArray array];

	for (SDNoteWindowController *controller in noteControllers)
		[array addObject:[controller dictionaryRepresentation]];

	[SDDefaults setObject:array forKey:@"notes"];
}

	// validate menu items

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(addNote:))
		return YES;
	if ([menuItem action] == @selector(removeAllNotes:))
		return ([noteControllers count] > 0);
	else
		return [super validateMenuItem:menuItem];
}

	// adding and creating notes

- (void) createNoteWithDictionary:(NSDictionary*)dictionary {
	SDNoteWindowController *controller = [[SDNoteWindowController alloc] initWithDictionary:dictionary];// autorelease];
	[noteControllers addObject:controller];
}

- (void) removeNoteFromCollection:(SDNoteWindowController*)controller {
	[noteControllers removeObject:controller];
}

- (IBAction) addNote:(id)sender {
	[self createNoteWithDictionary:nil];
}

- (IBAction) removeAllNotes:(id)sender {
	NSAlert *alert = [[[NSAlert alloc] init] autorelease];

	[alert setMessageText:@"Remove all desktop labels?"];
	[alert setInformativeText:@"This operation cannot be undone. Seriously."];

	[alert addButtonWithTitle:@"OK"];
	[alert addButtonWithTitle:@"Cancel"];

	if ([alert runModal] == NSAlertFirstButtonReturn)
		[noteControllers removeAllObjects];
}
	// specifics

- (void) appRegisteredSuccessfully {
	[self loadNotes];
}

- (NSA*) instructionImageNames {
	return @[@"1.pdf", @"2.pdf", @"3.pdf"];
}

- (BOOL) showsPreferencesToolbar {
	return YES;
}

- (NSA*) preferencePaneControllerClasses {
	return @[[SDGeneralPrefPane class]];
}

-(void) makeBadges {
	[AZStopwatch start:@"makingbadges"];
		//	[NSThread performBlockInBackground:^{

	SourceListItem *appsListItem = [SourceListItem itemWithTitle:@"APPS" identifier:@"apps"];
		//		[appsListItem setBadgeValue:[[AtoZ dock]count]];
	[appsListItem setIcon:[NSImage imageNamed:NSImageNameAddTemplate]];
	[appsListItem setChildren:[[AtoZ sharedInstance].dockSorted arrayUsingBlock:^id(AZFile* obj) {
		SourceListItem *app = [SourceListItem itemWithTitle:obj.name identifier:obj.uniqueID icon:obj.image];
			//			AZFile* sorted =[[AtoZ dockSorted] filterOne:^BOOL(AZFile* sortObj) {
			//				return ([sortObj.uniqueID isEqualToString:obj.uniqueID] ? YES : NO);
			//			}];
		NSLog(@"%@, spot: %ld, match ", obj.name, obj.spot);//, oc.name, sorted.spotNew);
															//			app.badgeValue = sorted.spotNew;
		app.color = obj.color;
		app.objectRep = obj;
		[app setChildren:[[[obj propertiesPlease] allKeys] arrayUsingBlock:^id(NSString* key) {
			if ( [key isEqualToAnyOf:@[@"name",@"image", @"color", @"colors"]]) return  nil;
			else return [SourceListItem itemWithTitle:$(@"%@: %@",key,[obj valueForKey:key]) identifier:nil];
		}]];
			//
		return app;
	}]];
		//		[[NSThread mainThread] performBlock:^{
	sourceListItems = @[appsListItem];
	[AZStopwatch stop:@"makingbadges"];
	[sourceList reloadData];
}
- (IBAction)reload:(id)sender {

	[sourceList reloadData];
}
	//		} waitUntilDone:YES];
	// 	}];

	//	NSArray *g = @[[AZFile instanceWithPath:@"/Applications/Safari.app"]];

/*
 //LAYER
 self.root = [CALayer layer];
 root.name = @"root";
 root.backgroundColor = cgORANGE;
 root.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
 NSImage *image = [NSImage imageWithFileName:@"1.pdf" inBundleForClass:[AtoZ class]];
 NSLog(@"image:%@", image);
 [image setSize:[_window.contentView bounds].size];
 [root setContents:image];
 [rootView setLayer:root];
 [rootView setWantsLayer:YES];
 contentLayer = [CALayer layer];
 [root addSublayer:contentLayer];
 //	NSRect r =  [AZSizer structForQuantity:[[AtoZ dockSorted]count] inRect:tiny];
 AZSizer *cc = [AZSizer forQuantity:[AtoZ dockSorted].count inRect:[root frame]];
 [cc.rects eachConcurrentlyWithBlock:^(NSInteger index, id obj, BOOL *stop) {
 CALayer *rrr = [CALayer layer];
 rrr.frame = [obj rectValue];
 rrr.backgroundColor = [[[NSColor yellowColor]colorWithAlphaComponent:RAND_FLOAT_VAL(0,1)] CGColor];
 [contentLayer addSublayer:rrr];
 }];
 [rootView setPostsBoundsChangedNotifications:YES];
 [[NSNotificationCenter defaultCenter] addObserver:self forKeyPath:NSViewBoundsDidChangeNotification];*/
-(IBAction) cancel:(id) sender {
	cancelled = YES;

}
-(IBAction) moveThemAll:(id) sender {
	NSLog(@"Move them all called");
		//	AZWindowExtend *screen = [AZWindowExtend alloc]init

	for (AZFile *file in [AtoZ dock]) {
		if (cancelled == NO){
				//			[[NSThread mainThread]performBlock:^{
			NSLog(@"%@ spot:%ld to %ld", file.name, file.spot, file.spotNew);

			CGPoint now = [[AZDockQuery instance]locationNowForAppWithPath:file.path];
			[_point1x setStringValue:$(@"%f",now.x)];
			[_point1y setStringValue:$(@"%f",now.y)];
			AZTalker *j =[[AZTalker alloc]init];
			[j say:file.name];
			[[AZMouser sharedInstance]dragFrom:now to:file.dockPointNew];
				//			} waitUntilDone:YES];
		} else NSLog(@"cancelled is YES");
	}
}
-(void) pointOnScreenDidChangeTo:(NSEvent*)event {

		//	NSPoint i = aPoint;÷
		//	[[ud ]] mouseLoc(); ÷//[[AZMouser sharedInstance] mouseLocation];
	NSLog(@"delegate.. %ix%i", (int)[NSEvent mouseLocation].x, (int)[NSEvent mouseLocation].y);
		//	NSLog(@"delegate rec's point note: %@", NSStringFromPoint([point pointValue]));

}
- (IBAction) goMouseTest:(id)sender {

	NSUInteger tagis = [_mouseAction.selectedCell tag];
	NSLog(@"go called, tagis: %ld", tagis);

	switch (tagis) {
		case 0: {
			CGPoint move = CGPointMake(_point1x.floatValue, _point1y.floatValue);
				//			[[AZMouser sharedInstance]moveTo:move];
				//			AZMouser *h = [AZMouser instance];
			[[AZMouser sharedInstance] moveTo:move];
			break;
		}
		case 1:
			break;
		case 2: {
			CGPoint p1 = CGPointMake(_point1x.floatValue, _point1y.floatValue);
			CGPoint p2 = CGPointMake(_point2x.floatValue, _point2y.floatValue);
			[[AZMouser sharedInstance]dragFrom:p1 to:p2];
			break;
		}
		default:
			break;
	}
}

-(void) didChangeValueForKey:(NSString *)key {

	NSLog(@"ooh, %@", key);

		//	if ( key == NSViewBoundsDidChangeNotification)
		//		[self rezhuzh];
		//
		//}
		//
		//-(void) rezhuzh {
	NSLog(@"rezhzuhing");
		//	[[[AZSizer forQuantity:[AtoZ dockSorted].count inRect:[_window frame]]rects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		//		[(CALayer*)[contentLayer.sublayers objectAtIndex:idx] setFrame:[obj rectValue]];

		//	}];

}
/*-(IBAction)isoTest:(id)sender{

 __block id ii = [isoView superview];
 NSLog(@"[self props]");// self.propertiesPlease);

 [[NSThread mainThread]performBlock:^{
 [rootView fadeOut];
 [isoView setHidden:YES];

 [rootView addSubview:ii];
 } waitUntilDone:YES];
 [ii fadeIn];
 }

 -(IBAction)toggleShake:(id)sender {

 [root flipOver];
 id la = [root superlayer];
 [root removeFromSuperlayer];
 [la setHidden:YES];
 [la addSublayer:root];
 [la popInAnimated];
 NSLog(@"Must log");
 }
 //	self.contentLayer = [CALayer layer];

 //	self.contentLayer.position =  AZCenterOfRect([[_window contentView]frame]);

 //	[self quadImage];
 //	NSRect r =

 AZSizer *cc = [AZSizer forQuantity:[AtoZ dockSorted].count inRect:[[_window contentView] frame]];
 NSLog(@"rects: %@", cc.rects);

 [[AtoZ dockSorted] each:^(AZFile *file, NSUInteger index, BOOL *stop) {

 //		NSRect f = AZMakeRect(
 //					randomPointInRect([[_window contentView]bounds]),
 //					NSMakeSize(60,50)  );
 AZBlockView *i = [AZBlockView viewWithFrame:[cc.rects[index]rectValue] opaque:YES drawnUsingBlock:^(NSView *view, NSRect dirtyRect) {
 NSColor*d = [view valueForKeyPath:@"dictionary.file.color"];
 [d set];
 NSRectFill(view.bounds);
 }];
 [i setValue:file forKeyPath:@"dictionary.file"];
 //		[[AtoZ sharedInstance] handleMouseEvent:NSMouseEntered inView:i withBlock:^{

 [i handleMouseEvent:NSMouseExitedMask | NSMouseEnteredMask withBlock:^{
 AZTalker *n = [AZTalker new];
 [n say:[[i valueForKeyPath:@"dictionary.file"]valueForKey:@"name"]];
 [i setNeedsDisplay:YES];
 //			[i fadeOut];
 }];
 [i setNeedsDisplay:NO];
 [[_window contentView]addSubview:i];
 NSLog(@"madea v: %@", i.propertiesPlease);
 }];

 //		fileLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
 //		fileLayer.backgroundColor = [file.color CGColor];
 //		fileLayer.contents = file.image;
 //		fileLayer.frame = AZMakeRect(NSMakePoint(
 //												 s.width * columnindex,
 //												 root.frame.size.height - ((rowindex + 1) * s.height)), s);
 //		[root addSublayer:fileLayer];
 //
 //
 //	[self doLayout];
 */

	//	[self cells];
/**

 -(void) cells {

 //	NSRect f = _window.contentView.frame;
 //	AZSizer *sizer = [AZSizer forQuantity:[AtoZ dockSorted] inRect:f];

 NSRect tiny = NSInsetRect(_window.frame,200, 199);
 NSRect r =  [[AZSizer structForQuantity:[[AtoZ dockSorted]count] inRect:tiny];

 self.matrix = [[NSMatrix alloc] initWithFrame:tiny mode:NSTrackModeMatrix cellClass:[NSImageCell class] numberOfRows:r.origin.x numberOfColumns:r.origin.y];
 [matrix setCellSize:r.size];//NSMakeSize(100, 100)];
 [matrix sizeToCells];
 //	[matrix setAutoresizingMask: NSViewHeightSizable | NSViewWidthSizable];
 [matrix setBackgroundColor:RANDOMCOLOR];
 [matrix setDrawsBackground:YES];

 [[AtoZ dockSorted] eachConcurrentlyWithBlock:^(NSInteger index, id obj, BOOL *stop) {
 NSImageCell *cell = [[NSImageCell alloc]init];
 cell.tag = index;
 //		[matrix setCe]
 //		[matrix cellWithTag:index];

 //cellAtRow:0 column:0];

 //		[cell setValue:obj forKeyPath:@"dictionary.file"];
 //		[cell setImage:[NSImage systemImages].randomElement];//[cell valueForKeyPath:@"dictionary.file.image"]];
 NSLog(@"making cell: %@", cell.description);
 [matrix setCellBackgroundColor:RANDOMCOLOR];
 [matrix setCell:cell];
 //		return cell;
 }];
 [[_window contentView] addSubview:matrix];
 NSLog(@"matrix:%@", matrix);
 [matrix setNeedsDisplay:YES];
 [matrix fadeIn];
 AZSimpleView *kk = [AZSimpleView new];
 kk.backgroundColor = RANDOMCOLOR;
 kk.frame = AZLowerEdge(_window.frame, 200);
 [_window.contentView addSubview:(NSView *)kk];
 //	Since the NSMatrix is a container for NSCell you need to fill them with something. In the example you posted you can do this by fetching the cell corresponding to your only row and column and setting the image.
 }
 - (void) doLayout {

 NSRect r 	= [AZSizer structForQuantity:[AtoZ dockSorted		].count inRect:[[_window contentView] frame]];
 //				   contentLayer.sublayers.count inRect:[[_window contentView] frame]];
 NSLog(@"Sizer rect: %@", NSStringFromRect(r));
 int columns = r.origin.y;
 int rows 	= r.origin.x;
 NSSize s 	= NSMakeSize(r.size.width, r.size.height);
 NSUInteger rowindex,  columnindex;
 rowindex = columnindex = 0;
 for (AZFile *file in [AtoZ dock]) {

 CALayer *fileLayer = [CALayer layer];
 fileLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
 fileLayer.backgroundColor = [file.color CGColor];
 fileLayer.contents = file.image;
 fileLayer.frame = AZMakeRect(NSMakePoint(
 s.width * columnindex,
 root.frame.size.height - ((rowindex + 1) * s.height)), s);
 [root addSublayer:fileLayer];
 columnindex++;
 if ( ! ((columnindex + 1) <= columns) ) { columnindex = 0; rowindex++; }

 //		CATransform3D rot = [[_window contentView] makeTransformForAngle:270];
 //	  imageLayer.transform = rot;
 //		box.identifier = $(@"%ldx%ld", rowindex, columnindex);
 }
 }
 [[_window contentView] setWantsLayer:YES];
 root = [CALayer layer];
 [[[_window contentView] layer] addSublayer: root ];
 [root setBackgroundColor:cgRANDOMCOLOR];
 //	root.layoutManager =
 int i = 4;
 while (i != 0) {
 AZBoxLayer *layer = [[AZBoxLayer alloc] initWithImage:[[NSImage systemImages]randomElement] title:$(@"vageen.%i",i)];
 [layer setFrame:CGRectMake(kMargin, 0.0, kIconWidth, kCompositeIconHeight)];
 [root insertSublayer:layer atIndex:i];
 i--;
 }
 //		:iconPath1 title:@"Desktop"] retain];
 //		[layer1 setFrame:CGRectMake(kMargin, 0.0, kIconWidth, kCompositeIconHeight)];
 //	}
 //
 //	layer1 = [[[IconLayer alloc] initWithImagePath:iconPath1 title:@"Desktop"] retain];
 //	[layer1 setFrame:CGRectMake(kMargin, 0.0, kIconWidth, kCompositeIconHeight)];
 //
 //	layer2 = [[[IconLayer alloc] initWithImagePath:iconPath2 title:@"Firewire Drive"] retain];
 //	[layer2 setFrame:CGRectMake(kMargin, kIconWidth + kMargin, kIconWidth, kCompositeIconHeight)];
 //
 //	layer3 = [[[IconLayer alloc] initWithImagePath:iconPath3 title:@"Pictures"] retain];
 //	[layer3 setFrame:CGRectMake(kCompositeIconHeight + kMargin, 0.0, 128, kCompositeIconHeight)];
 //
 //	layer4 = [[[IconLayer alloc] initWithImagePath:iconPath4 title:@"Computer"] retain];
 //	[layer4 setFrame:CGRectMake(kCompositeIconHeight + kMargin, kIconWidth + kMargin, kIconWidth, kCompositeIconHeight)];
 //
 //	[root insertSublayer:layer1 atIndex:0];
 //	[root insertSublayer:layer2 atIndex:0];
 //	[root insertSublayer:layer3 atIndex:0];
 //	[root insertSublayer:layer4 atIndex:0];

 }

 -(IBAction)toggleShake:(id)sender;
 {
 for (AZBoxLayer *obj in [root sublayers] )
 [obj toggleShake];

 //	[layer1 toggleShake];
 //	[layer2 toggleShake];
 //	[layer3 toggleShake];
 //	[layer4 toggleShake];
 }
 @end


 @implementation MineField

 @synthesize numMines;
 @synthesize numExposedCells;
 @synthesize kablooey;

 -(id)initWithWidth:(int)w Height:(int)h Mines:(int)m {
 self = [super init];
 if (self != nil) {
 int r, c;
 cells = [[NSMutableArray alloc] initWithCapacity: h];
 for (r = 0; r < h; r++) {
 NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity: w];
 [cells addObject: row];
 for (c = 0; c < w; c++) {
 [row addObject: [[Cell alloc] init]];
 }
 }
 numMines = m;
 [self reset]; // place random mines and unexpose all cells
 }
 return self;
 }

 -(int)width {
 return [[cells objectAtIndex: 0] count];
 }

 -(int)height {
 return [cells count];
 }

 -(Cell*)cellAtRow:(int)r Col:(int)c {
 return [[cells objectAtIndex: r] objectAtIndex: c];
 }

 -(void)reset {
 int w = [self width], h = [self height];
 int n = w*h;  // total cells left
 int m = numMines; // total mines left to place
 int r,c;

 numExposedCells = 0;
 kablooey = NO;

 for (r = 0; r < h; r++) { // reset all cells
 for (c = 0; c < w; c++) {
 Cell *cell = [self cellAtRow: r Col: c];
 cell.exposed = cell.marked = cell.hasMine = NO;
 double p = (double) m / (double) n; // probability of placing mine here
 double g = drand48();  // generate random number 0 <= g < 1
 if (g < p) {
 cell.hasMine = YES;
 m--;
 }
 n--;
 }
 }
 numMines -= m;  // just to be anal, m should be zero at this point

 for (r = 0; r < h; r++) { // compute surrounding mine counts
 for (c = 0; c < w; c++) {
 int i,j, count = 0;
 Cell *cell = [self cellAtRow: r Col: c];
 for (j = -1; j <= +1; j++) {
 for (i = -1; i <= +1; i++) {
 if (i == 0 && j == 0) continue;
 int rr = r+j, cc = c+i;
 if (rr < 0 || rr >= h || cc < 0 || cc >= w) continue;
 Cell *neighbor = [self cellAtRow: rr Col: cc];
 if (neighbor.hasMine)
 count++;
 }
 }
 cell.numSurroundingMines = count;
 }
 }
 }

 -(int)unexposedCells {
 int w = [self width], h = [self height];
 return w*h - numMines - numExposedCells;
 }

 //
 // return value
 //  -2 => no change (cell already exposed, controller shouldn't allow this)
 //  -1 => "BOOM" (new exposed cell contained mine).
 //  0 to 8 => cell safely exposed, number of neighboring mines returned
 //  When 0 returned, its neighbors are (recursively) exposed
 //		controller should rescan grid for exposed cells
 //
 -(int)exposeCellAtRow:(int)r Col:(int)c {
 if (kablooey) return -2;
 Cell *cell = [self cellAtRow: r Col: c];
 if (cell.exposed) return -2;
 cell.exposed = YES;
 numExposedCells++;
 if (cell.hasMine) {  // BOOM!
 kablooey = YES;
 return -1;
 }
 int n = cell.numSurroundingMines;
 if (n == 0) {
 int w = [self width], h = [self height];
 BOOL changed;
 do {
 int rr, cc;
 changed = NO;
 for (rr = 0; rr < h; rr++)
 for (cc = 0; cc < w; cc++)
 if ([self autoExposeCellAtRow:rr Col:cc])
 changed = YES;
 } while (changed);
 }
 return n;
 }

 -(BOOL)autoExposeCellAtRow:(int)r Col:(int)c {
 Cell *cell = [self cellAtRow: r Col: c];
 if (!cell.exposed && !cell.hasMine) {
 int w = [self width], h = [self height];
 int i,j;
 for (j = -1; j <= +1; j++) {
 for (i = -1; i <= +1; i++) {
 if (i == 0 && j == 0) continue;
 int rr = r+j, cc = c+i;
 if (rr < 0 || rr >= h || cc < 0 || cc >= w) continue;
 Cell *neighbor = [self cellAtRow:rr Col:cc];
 if (neighbor.exposed && neighbor.numSurroundingMines == 0) {
 cell.exposed = YES;
 numExposedCells++;
 return YES;
 }
 }
 }
 }
 return NO;
 }

 @end

 @implementation Cell

 @synthesize hasMine;
 @synthesize exposed;
 @synthesize marked;
 @synthesize numSurroundingMines;

 -(id)init {
 self = [super init];
 if (self != nil) {
 hasMine = exposed = NO;
 marked = numSurroundingMines = 0;
 }
 return self;
 }

 @end
 */
#pragma mark - Source List Data Source Methods

- (NSUInteger)sourceList:(AZSourceList*)sourceList numberOfChildrenOfItem:(id)item
{
	SourceListItem *i = item;

	NSLog(@"Object:%@", i.objectRep);// [item propertiesPlease]);
									 //Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return [sourceListItems count];
	}
	else {
		return [[item children] count];
	}
}

	//- (BOOL)sourceList:(AZSourceList*)aSourceList isItemExpandable:(id)item {
	//
- (id)sourceList:(AZSourceList*)aSourceList child:(NSUInteger)index ofItem:(id)item
{
		//Works the same way as the NSOutlineView data source: `nil` means a parent item
	if(item==nil) {
		return sourceListItems[index];
	}
	else {
		return [item children][index];
	}
}
- (id)sourceList:(AZSourceList*)aSourceList objectValueForItem:(id)item
{
	return [item title];

		//	return [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
		//		return ( [object.uniqueID isEqualTo:[item identifier]] ? YES : NO);
		//	}];
}
- (void)sourceList:(AZSourceList*)aSourceList setObjectValue:(id)object forItem:(id)item
{

	[item setObjectValue:[[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
		return ([object.uniqueID isEqualToString:[item identifier]] ? YES : NO);
	}]];

	[item setTitle:[[item object]valueForKey:@"name"]];
}

- (BOOL)sourceList:(AZSourceList*)aSourceList isItemExpandable:(id)item
{
	return [item hasChildren];
}
- (BOOL)sourceList:(AZSourceList*)aSourceList itemHasBadge:(id)item
{
	if ([[item valueForKey:@"objectRep"] isKindOfClass:[AZFile class]])
		return YES;
	else return NO;   // [item hasBadge];
}

- (NSColor*)sourceList:(AZSourceList*)aSourceList badgeBackgroundColorForItem:(id)item {

	AZFile *first = [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
		return ( [object.uniqueID isEqualTo:[item identifier]] ? YES : NO);
	}];
	return first.color;

}
- (NSInteger)sourceList:(AZSourceList*)aSourceList badgeValueForItem:(id)item
{
	AZFile *first  = aSourceList.objectRep;
	return first.spotNew;
		//	AZFile *first = [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
		//		return ( [object.uniqueID isEqualTo:[item identifier]] ? YES : NO);
		//	}];

		//	return first.spotNew;
		//	return [item badgeValue];
}
- (BOOL)sourceList:(AZSourceList*)aSourceList itemHasIcon:(id)item
{
	return [item hasIcon];
}
- (NSImage*)sourceList:(AZSourceList*)aSourceList iconForItem:(id)item
{
	return [item icon];
}

- (NSMenu*)sourceList:(AZSourceList*)aSourceList menuForEvent:(NSEvent*)theEvent item:(id)item
{
	if ([theEvent type] == NSRightMouseDown || ([theEvent type] == NSLeftMouseDown && ([theEvent modifierFlags] & NSControlKeyMask) == NSControlKeyMask)) {
		NSMenu * m = [[NSMenu alloc] init];
		if (item != nil) {
			[m addItemWithTitle:[item title] action:nil keyEquivalent:@""];
		} else {
			[m addItemWithTitle:@"clicked outside" action:nil keyEquivalent:@""];
		}
		return m;
	}
	return nil;
}

#pragma mark - Source List Delegate Methods

- (BOOL)sourceList:(AZSourceList*)aSourceList isGroupAlwaysExpanded:(id)group
{
	if([[group identifier] isEqualToString:@"apps"])
		return YES;

	return NO;
}
- (void)sourceListSelectionDidChange:(NSNotification *)notification
{
	NSIndexSet *selectedIndexes = [sourceList selectedRowIndexes];

	if([selectedIndexes count]==1)
	{
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		AZFile *first = [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
			return ( [object.uniqueID isEqualTo:identifier] ? YES : NO);
		}];
		CGPoint now = [[AZDockQuery instance]locationNowForAppWithPath:first.path];
		[_point1x setStringValue:$(@"%f",now.x)];
		[_point1y setStringValue:$(@"%f",now.y)];
		[_point2x setStringValue:$(@"%f",first.dockPointNew.x)];
		[_point2y setStringValue:$(@"%f",first.dockPointNew.y)];

	}
	if([selectedIndexes count]==2)
	{
		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes lastIndex]] identifier];
		AZFile *first = [[AtoZ dockSorted] filterOne:^BOOL(AZFile* object) {
			return ( [object.uniqueID isEqualTo:identifier] ? YES : NO);
		}];
		[_point2x setStringValue:$(@"%f",first.dockPoint.x)];
		[_point2y setStringValue:$(@"%f",first.dockPoint.y)];
	}

		//Set the label text to represent the new selection
		//	if([selectedIndexes count]>1)
		//		[selectedItemLabel setStringValue:@"(multiple)"];
		//
		//	else if([selectedIndexes count]==1) {
		//		NSString *identifier = [[sourceList itemAtRow:[selectedIndexes firstIndex]] identifier];
		//
		//		[selectedItemLabel setStringValue:identifier];
		//	}
		//	else {
		//		[selectedItemLabel setStringValue:@"(none)"];
		//	}
}
- (void)sourceListDeleteKeyPressedOnRows:(NSNotification *)notification
{
	NSIndexSet *rows = [notification userInfo][@"rows"];

	NSLog(@"Delete key pressed on rows %@", rows);

		//Do something here
}
+ (void) initialize {

		//	AZTalker *welcome = [AZTalker new];
		//	[welcome say:@"welcome"];
		//	[NSLogConsole sharedConsole];

}

-(void) dunno {

		//	NSUInteger index = [(NSPopUpButton *)sender selectedTag];
	NSLog(@"Selecting stylesheet %ld",index);

	if (index > 1 ) {
		[[_window contentView] performSelectorOnMainThread:@selector(fadeOut) withObject:nil waitUntilDone:YES];
			//		[self selectStyleSheetAtIndex:index];
			//		[ibackgroundView fadeIn];
	} else {
			//		[ibackgroundView performSelectorOnMainThread:@selector(fadeOut) withObject:nil waitUntilDone:YES];
			//		[self selectStyleSheetAtIndex:index];
			//		[backgroundView fadeIn];
	}
}

//-(void) quadImage {
		//	NSString* path = [NSString stringWithFormat:@"%@/Frameworks/AtoZ.framework/Resources/1.pdf", [[NSBundle mainBundle] bundlePath]];
		//	[image saveAs:@"/Users/localadmin/Desktop/mystery.png"];
		//	CALayer *layer = [CALayer layer];
		//	[root setLayer:myLayer];
		//	[view setFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
		//	root.transform = [contentLayer rectToQuad:[contentLayer bounds] quadTLX:0 quadTLY:0 quadTRX:image.size.width quadTRY:20 quadBLX:0 quadBLY:image.size.height quadBRX:image.size.width quadBRY:image.size.height + 90];
		//[1]: http://codingincircles.com/2010/07/major-misunderstanding/
}

@end
