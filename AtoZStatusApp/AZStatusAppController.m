//
//  AppController.m
//  NSStatusItemTest

#import "AZStatusAppController.h"

@implementation AZStatusAppController {
	BOOL menuWindowIsShowing;
	NSMutableArray *datasource;
	NSUInteger fakeDataSourceCount;
	NSMutableArray *arrayOfBlocks;
	NSWindow *shroud;
	NSImage *shroudShot;
	NSImageView *shroudShotView;
	float visiSliver;
}

@synthesize attachedWindow;//, //scroller, grid, activeViews;
@synthesize pIndi, controls, infiniteBlocks, orientButton, scaleSlider;



- (void)awakeFromNib {

	visiSliver = 50;
	controls.level = NSScreenSaverWindowLevel;
	[controls setFrame:
	 AZMakeRect( NSMakePoint([[NSScreen mainScreen]frame].size.width - [controls frame].size.width,
							 [[NSScreen mainScreen]frame].size.height -22 - [controls frame].size.height),[controls frame].size) display:YES];
	[pIndi setUsesThreadedAnimation:YES];
	[pIndi startAnimation:pIndi];
	[scaleSlider setAction:@selector(switchViewScale:)];
	[orientButton setAction:@selector(swapOrient:)];


	[[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:statusView
			selector:@selector(activeAppDidChange:)
			name:NSWorkspaceDidActivateApplicationNotification object:nil];

    // Create an NSStatusItem.
    NSRect menuFrame = NSMakeRect(0, 0, 30, [[NSStatusBar systemStatusBar] thickness]);
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:menuFrame.size.width];
	statusView = [[AZStatusItemView alloc] initWithFrame:menuFrame];
	
	[statusView setDelegate: self];
    [statusItem setView:statusView];//// controller:self]];
	menu = [NSMenu new];
	[[AtoZ runningApps] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSMenuItem *i = [NSMenuItem new];
		__block NSImage *ii = [obj valueForKey:@"image"];
		[ii setSize:NSMakeSize(25,25)];
		__block AZSimpleView *av = [AZSimpleView new];
		av.gradient = YES;
		av.frame = AZMakeRectFromSize(NSMakeSize(30,30));
		av.backgroundColor = [obj valueForKey:@"color"];
		[av addSubview: [AZBlockView viewWithFrame:AZCenteredRect(NSMakeSize(140,26),AZMakeRectFromSize(NSMakeSize(150,30))) opaque:NO drawnUsingBlock:
		 ^(AZBlockView *view, NSRect dirtyRect) {
			 //[[blockSelf roundedRectFillColor] set]; [[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:5 yRadius:5] fill]; }]]; }
//			 view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
			[ii drawAtPoint:NSMakePoint(2.5,2.5) fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
//			NSString *name = [obj valueForKey:@"name"];
//			[name drawAtPoint:NSMakePoint(26,0) withAttributes:
//			[name drawAtPoint:NSMakePoint(26,0) withAttributes:@{/*[av.backgroundColor contrastingForegroundColor]*/ WHITE:NSBackgroundColorAttributeName}];//:[view bounds] withFont:@"Helvetica"];
//			 [[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:20 yRadius:20] fill];
		 }]];
		 //positioned:NSWindowBelow relativeTo:infiniteBlocks];
		i.view = av;
//		i.title = [obj valueForKey:@"name"];
		[menu addItem:i];
	}];
	[statusItem setMenu:menu];


	[attachedWindow setStyleMask:NSBorderlessWindowMask];
	[attachedWindow setFrame:AZMakeRectMaxXUnderMenuBarY(visiSliver) display:NO];
	[attachedWindow slideUp];

//	attachedWindow = [[NSWindow alloc]initWithContentRect:barFrame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
//	bar = [[AZToggleView alloc]initWithFrame:barFrame];
//	[attachedWindow setContentView:bar];	
//	[attachedWindow setFrame:barFrame display:NO];
//	[attachedWindow setBackgroundColor:CLEAR];
}
- (IBAction)switchViewScale:(id)sender {
 	switch  ([sender intValue])		{
		case 1:	[infiniteBlocks setScale : AZInfiteScale1X]; 	break;
		case 2:	[infiniteBlocks setScale : AZInfiteScale2X]; 	break;
		case 3:	[infiniteBlocks setScale : AZInfiteScale3X]; 	break;
		case 4:	[infiniteBlocks setScale : AZInfiteScale10X]; 	break;
	}
}
- (IBAction)swapOrient:(id)sender {
//	if 	(infiniteBlocks.orientation == AZOrientLeft){
//		[[infiniteBlocks window] setFrame:AZMakeRectMaxXUnderMenuBarY(visiSliver) display:YES animate:YES];
//		[infiniteBlocks setOrientation: AZOrientTop ];
//		(infiniteBlocks.orientation == AZOrientRight ); {
//	} else {
//		[[infiniteBlocks window] setFrame:NSMakeRect(0,0, 50, [[NSScreen mainScreen]frame].size.height-22)  display:YES animate:YES];
//		[infiniteBlocks setOrientation : AZOrientLeft];
//	}
}







- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

	[NSThread performBlockInBackground:^{
		arrayOfBlocks = [[AtoZ dockSorted] arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
			AZFile *block = obj;
			AZInfiniteCell *e = [AZInfiniteCell new];
			//			AZSimpleView *e = [AZSimpleView new];
			//			[e setCanDrawConcurrently:YES];
			//			e.representedObject = block;
			e.file = block;
			e.backgroundColor = block.color;
			return e;
		}].mutableCopy;
		[[NSThread mainThread] performBlock:^{
			[infiniteBlocks setInfiniteVi arrayOfBlocks];
			[pIndi stopAnimation:pIndi];
		}];
		
	}];

}


- (void)statusView:(AZStatusItemView *)statusItem isActive:(BOOL)active{

	shroud = [[NSWindow alloc]initWithContentRect:[[NSScreen mainScreen]visibleFrame]  styleMask: NSBorderlessWindowMask backing: NSBackingStoreRetained defer: NO];

	[shroud setBackgroundColor:CLEAR];
	[shroud setLevel:NSScreenSaverWindowLevel + 1];
	[shroud setHasShadow:NO];
	[shroud setAlphaValue:0.0];
	[shroud orderFront:self];
	[shroud setContentView:[[NSView alloc] initWithFrame:[[NSScreen mainScreen]visibleFrame]]];
//	[[shroud contentView] lockFocus];

//	[shroud setFrame:[[NSScreen mainScreen]visibleFrame] display:YES];
	shroudShot = [NSImage imageBelowWindow:shroud];
	shroudShotView = [[NSImageView alloc]initWithFrame:[[shroud contentView]frame]];
	[shroudShotView setImage:shroudShot];
	[[shroud contentView]addSubview:shroudShotView];
//	NSLog(@"image:%@",s);
//	[s saveAs:@"/Users/localadmin/Desktop/poop.png"];
/**	[[shroud contentView]addSubview:
		[AZBlockView viewWithFrame:[[shroud contentView]frame]  opaque:NO drawnUsingBlock:
		^(AZBlockView *view, NSRect dirtyRect) {
															   //[[blockSelf roundedRectFillColor] set]; [[NSBezierPath bezierPathWithRoundedRect:[view bounds] xRadius:5 yRadius:5] fill]; }]]; }
//															   view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
	[s compositeToPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeCopy];														   }] positioned:NSWindowBelow relativeTo:infiniteBlocks];
*/
	[attachedWindow makeKeyAndOrderFront:self];
	[NSApp activateIgnoringOtherApps:YES];

	//this pops the running apps window.
	[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(showMenu) userInfo:nil repeats:NO];

	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
	menuWindowIsShowing =! menuWindowIsShowing;
//	[statusView.menu  [self menu]];

}


- (void) showMenu {
    // This will show the menu at the current mouse position
    [statusItem.menu popUpMenuPositioningItem:[[statusItem menu] itemAtIndex:0] atLocation:[NSEvent mouseLocation] inView:nil];
}

//- (void)toggleAttachedWindowAtPoint:(NSPoint)pt {
//	[NSApp activateIgnoringOtherApps:YES];
//    if (!attachedWindow) {
//        attachedWindow = [[AZAttachedWindow alloc] initWithView:rootView 
//                                                attachedToPoint:pt 
//                                                       inWindow:nil 
//                                                         onSide:AZPositionBottom 
//                                                     atDistance:5.0];
////        [textField setTextColor:[attachedWindow borderColor]];
////        [textField setStringValue:@"Your text goes here..."];
//		menuWindowIsShowing = NO;	
//			//	[attachedWindow makeKeyAndOrderFront:self];
//    }
////	if (![attachedWindow isAnimating]) {
//	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
//	menuWindowIsShowing =! menuWindowIsShowing;
//}
//        [attachedWindow orderOut:self];
//        attachedWindow = nil;
- (void) applicationDidResignActive:(NSNotification *)notification {
	[attachedWindow slideUp];// orderOut:self];
}
- (void) applicationDidBecomeActive:(NSNotification *)notification{
	[NSApp activateIgnoringOtherApps:YES];
	if (!menuWindowIsShowing) {

		[attachedWindow slideDown];
		[attachedWindow makeKeyAndOrderFront:attachedWindow];
		}
}

- (void)dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}
@end
