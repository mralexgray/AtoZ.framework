	//
	//  ShroudWindow.m
	//  AtoZ
	//
	//  Created by Alex Gray on 8/20/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

//#define PRINTMETHODS 0

#import "AZVeil.h"
#import "AtoZ.h"
@interface AZSplitView : NSSplitView
@property (nonatomic, retain) NSColor* dividerColor;
@end

@implementation AZSplitView
- (NSColor*) dividerColor {	return RANDOMCOLOR;  }
- (CGFloat)dividerThickness { return 12; }

- (void)drawDividerInRect:(NSRect)aRect { // Create a canvas
										  //	NSImage *canvas = [NSImage.alloc initWithSize:aRect.size];
										  //	// Draw bar and grip onto the canvas
										  //	NSRect canvasRect = NSMakeRect(0, 0, [canvas size].width, [canvas size].height);
										  //	NSRect gripRect = canvasRect;
										  //	gripRect.origin.x = NSMidX(aRect) - ([gripre size].width/2);
										  //	[canvas lockFocus];
										  //	[bar setSize:aRect.size];
										  //	[bar drawInRect:canvasRect fromRect:canvasRect operation:NSCompositeSourceOver fraction:1.0];
										  //	[grip drawInRect:gripRect fromRect:canvasRect operation:NSCompositeSourceOver fraction:1.0];
	[RED set];
	NSRectFill(aRect);
		//	[canvas unlockFocus];

		// Draw canvas to divider bar
		//	[self lockFocus];
		//	[canvas drawInRect:aRect fromRect:canvasRect operation:NSCompositeSourceOver fraction:1.0];
		//	[self unlockFocus];
}

	//	bar and grip are NSImag
@end

@interface AZVeil ()
@property (nonatomic, assign) ShroudIs shroudState;

@property (NATOM, ASS) CGFloat defaultSize;
@property (ASS) IBOutlet id closeButton;
@property (ASS) IBOutlet id quad1;
@property (ASS) IBOutlet id quad2;
@property (ASS) IBOutlet id quad3;
@property (ASS) IBOutlet id quad4;
@property (ASS) IBOutlet id subBar;

@property (ASS) IBOutlet NSWindow *leveler;
@property (ASS) IBOutlet TransparentWindow *shroud;
@property (ASS) IBOutlet TransparentWindow *window;
@property (ASS) IBOutlet NSImageView* view;

@property (ASS) IBOutlet AZSplitView *horizonSplit;

@property (nonatomic, assign) NSRect barFrame;
@property (nonatomic, assign) NSRect barFrameUp;
@end

@implementation AZVeil	{

	NSTrackingArea *closeTracker, *windowTracker;
	BOOL mouseHoveringOverBox, mouseHoveringOverButton, shouldShowCloseButton;
	NSTrackingArea *boxTrackingArea, *buttonTrackingArea;
}

	// The hiding confirmation is requested three times before any other event and once between min and max constrains
- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex
{
	NSLog(@"Divider hiding requested for divider at index %ld", (long)dividerIndex);
	return NO;
}

	// This method is called continuously when the split view frame is set and for each mouse up event on the divider
- (NSRect)splitView:(NSSplitView *)splitView additionalEffectiveRectOfDividerAtIndex:(NSInteger)dividerIndex
{
	NSLog(@"Additional area for divider requested \n\t Frame for divider at index %ld: %@\n   with tag %ld",
		  (long)dividerIndex,
		  NSStringFromRect([[splitView subviews][dividerIndex] frame]),
		  [splitView tag]);
	return NSZeroRect;
}

	// The constraining methods are called based on the divider, always taking into consideration the minimum and maximum sizes of the subviews that come before it. Example: for the first divider, the constraining methods are called for the first subview only (at index 0); for the second divider, the constrianing methods are called for the second subview only (at index 1); and so... The methods are called once the split view frame is set and for each mouse down and mouse up event on the divider
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)min ofSubviewAt:(NSInteger)index
{
	NSLog(@"Constrains asked for minimum coordinate %.2f on subview at index %ld", min, (long)index);
		//	NSLog(@"\tFrame for subview at index %ld: %@\n", (long)index, NSStringFromRect([[[splitView subviews] objectAtIndex:index] frame]));
	return 100.0;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)max ofSubviewAt:(NSInteger)index
{
	NSLog(@"Constrains asked for maximum coordinate %.2f on subview at index %ld", max, (long)index);
	NSLog(@"\tFrame for subview at index %ld: %@\n  with tag %ld", (long)index, NSStringFromRect([[splitView subviews][index] frame]), [splitView tag]);
	return max;
}

	// This method is called for each subview on every mouse down and mouse up events on the divider and once the split view frame is set
- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview
{
	NSLog(@"Should collapse subview requested");
	NSLog(@"\tFrame for subview: %@\n", NSStringFromRect(subview.frame));
	return YES;
}

	// This one is called on the second mouse down event, just after the method splitView:canCollapseSubview: method above. It's called for each subview
- (BOOL)splitView:(NSSplitView *)splitView shouldCollapseSubview:(NSView *)subview forDoubleClickOnDividerAtIndex:(NSInteger)dividerIndex;
{
	NSLog(@"Should collapse subview for double-click on divider at index %ld requested", (long)dividerIndex);
	NSLog(@"Double-clicked!");
	NSLog(@"\tFrame for subview: %@\n", NSStringFromRect(subview.frame));
	return NO;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)index
{
	NSLog(@"Constrains asked for the divider position %.2f on subview at index %ld", proposedPosition, (long)index);
	NSLog(@"\tThe divider (split) position has changed!");
	NSLog(@"\tFrame for subview at index %ld: %@\n", (long)index, NSStringFromRect([[splitView subviews][index] frame]));
	return proposedPosition;
}

- (IBAction)toggleLeftView:(id)sender 	{
	NSLog(@"Toggling left view");
		//	if ([_horizonSplit isSubviewCollapsed:self.leftView])

}

- (void) awakeFromNib {
//	self.view.image = nil;
//	[_leveler setFrame:NSMakeRect(0, (AZScreenHeight()-1),1,1) display:YES animate:NO];
	[_shroud  setIgnoresMouseEvents:YES];
	[NotificationCenterSpy toggleSpyingAllNotifications];
	[ @[_leveler, _shroud, _window] az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[obj setMovable:NO];
		[obj setOpaque:YES];
//		[obj  setLevel:];
			//		[obj setDelegate:self];
			//		[[obj contentView] setPostsBoundsChangedNotifications:YES];
			//		[[obj contentView] setPostsFrameChangedNotifications:YES];
			//		CAAnimation *animation = [CABasicAnimation animation];
			//		[animation setDelegate:self];
			//		[obj setAnimations:@{ @"alphaValue":animation}];

	}];
	self.defaultSize 		= 300;
	_window.upFrame	 	= AZZeroHeightBelowMenu();
	_shroud.upFrame 	= AZMenulessScreenRect();
	[ [[_window contentView] allSubviews] az_each:^(id obj, NSUInteger index, BOOL *stop) {
		if ( [obj isKindOfClass:[NSSplitView class]] ) {
			[obj setDelegate:self];
			[obj setDividerStyle:NSSplitViewDividerStyleThick];
				//			[obj setTag:index];
				//				[self observeObject:obj forName:NSSplitViewWillResizeSubviewsNotification
				//					calling:@selector(horizonSplitWillResizeSubviewsHandler:)];
				//			[(NSSplitView*)obj  setFrameSize:NSZeroSize ];
		}

	}];

		//	[_subBar setFrame:AZMakeRectMaxXUnderMenuBarY(200) display:YES animate:YES];
		//	float sizer =100;
		//	float offset = ([[NSApplication sharedApplication]isActive] ?
		//					22 : (22 + sizer) );
		//	self.barFrameUp = AZMakeRectMaxXUnderMenuBarY(0);
		//	self.barFrame = AZMakeRectMaxXUnderMenuBarY(offset);

	[@{ NSApplicationWillBecomeActiveNotification	:	@"appWillActivate",
	 //		NSApplicationDidBecomeActiveNotification	:	@"applicationDidBecomeActive:",
	 //		NSAppl/Volumes/2T/ServiceData/AtoZ.framework/AtoZ/Views/AZVeil.micationWillResignActiveNotification	:	@"applicationWillResignActive:"}
	 NSApplicationDidResignActiveNotification 	:	@"appWillResign" 	}

	 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		 [self observeObject:NSApp forName:key calling:NSSelectorFromString(obj)];
	 }];

		// Add an observer that will respond to loginComplete
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(shroudOut)
												 name:@"okWindowFadeOutNow"
											   object:nil];

	//	int options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect);
		//	boxTrackingArea = [NSTrackingArea.alloc initWithRect:NSZeroRect
		//												   options:options
		//													 owner:self
		//												  userInfo:nil];
		//
		//	buttonTrackingArea = [boxTrackingArea copy];
		//
		//	[[_window contentView] addTrackingArea:boxTrackingArea];
		//	[_closeButton addTrackingArea:buttonTrackingArea];
}

	// MARK: -
	// MARK: Close Button

- (void) conditionallyShowCloseButton {
	shouldShowCloseButton = ((mouseHoveringOverBox || mouseHoveringOverButton) );
	[[_closeButton animator] setHidden:shouldShowCloseButton];
}

- (void) setHoveringOverNote:(NSNumber*)hovering {
	mouseHoveringOverBox = [hovering boolValue];
	[self conditionallyShowCloseButton];
}

- (void) futureSetHoveringOverNote:(BOOL)hovering {
	[self performSelector:@selector(setHoveringOverNote:) withObject:@(hovering) afterDelay:0.5];
}

- (void) futureCancelSetHoveringOverNote:(BOOL)hovering {
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(setHoveringOverNote:) object:@(hovering)];
}

- (void) mouseEntered:(NSEvent*)event {
	if ([event trackingArea] == boxTrackingArea) {
		[self futureCancelSetHoveringOverNote:NO];
		[self futureSetHoveringOverNote:YES];
	}
	else if ([event trackingArea] == buttonTrackingArea)
		mouseHoveringOverButton = YES;

	[self conditionallyShowCloseButton];
}

- (void) mouseExited:(NSEvent*)event {
	if ([event trackingArea] == boxTrackingArea) {
		[self futureCancelSetHoveringOverNote:YES];
		[self futureSetHoveringOverNote:NO];
	}
	else if ([event trackingArea] == buttonTrackingArea)
		mouseHoveringOverButton = NO;

	[self conditionallyShowCloseButton];
}
	//- (void) horizonSplitWillResizeSubviewsHandler:(NSNotification*) note {
	//
	//}

- (void) shroudOut {
//	if * ) [self performSelector:@selector(shroudOut) afterDelay:.3];
//	else
	[[_shroud animator]setAlphaValue:0];

}

- (void) capture {
		// Get the CGWindowID of supplied window
		//	CGWindowID windowID =

		// Get window's rect in flipped screen coordinates
		//	CGRect windowRect = AZFlipRectinRect(	self.window.upFrame, AZScreenFrame()) ;// NSRectToCGRect( [_shroud frame] );
		//	windowRect.origin.y = NSMaxY([[_shroud screen] frame]) - NSMaxY([_shroud frame]);

		// Get a composite image of all the windows beneath your window
		//	CGImageRef capturedImage =
		// The rest is as in the previous example...
		//	if(CGImageGetWidth(capturedImage) <= 1) {
		//		CGImageRelease(capturedImage);
		//		return nil;
		//	}

	NSLog(@"%@", NSStringFromRect(_shroud.upFrame));
	NSLog(@"lebvel: %ld", [_leveler windowNumber]);
		// Create a bitmap rep from the window and convert to NSImage...
		//	NSBitmapImageRep *bitmapRep = [NSBitmapImageRep.alloc initWithCGImage: capturedImage];
//	NSRect screenBoxRect = [_shroud convertRectToScreen:[mBox frame]];

//	NSRect frame = AZMenulessScreenRect();
//	rect.origin.x += frame.origin.x;
//	rect.origin.y += frame.origin.y;
//	return rect;

//	_view.image = [NSImage imageFromCGImageRef:
//		CGWindowListCreateImage(  AZFlipRectinRect(AZMenulessScreenRect(), (CGRect) { 0,22,AZScreenWidth(), AZScreenHeight()}),

////			AZFlipRectinRect( AZMenulessScreenRect(), AZScreenFrame()),
////			_shroud.frame,
//			[_window windowNumber],
//			kCGWindowListOptionOnScreenBelowWindow ,
//			kCGWindowImageDefault							)];

		//				AZFlipRectinRect( _shroud.frame, AZScreenFrame()),
		//AZMakeRectMaxXUnderMenuBarY( AZScreenHeight() - 22 ), AZScreenFrame()),


		//	[image addRepresentation: bitmapRep];
		//	CGImageRelease(capturedImage);

		//	= image;
//	NSImage 	*resultingImage = nil;	CGImageRef image;
//	CGWindowID  windowID = (CGWindowID);
//	resultingImage = [NSImage.alloc initWithCGImage:image size:NSZeroSize];
//	CGImageRelease(image);
	_view.image = [[NSImage imageFromCGImageRef:
				   CGWindowListCreateImage(	NSRectToCGRect(AZMenulessScreenRect()), kCGWindowListOptionOnScreenBelowWindow,
					   [_shroud windowNumber],
							kCGWindowImageNominalResolution |
							kCGWindowImageDefault)]
			  tintedWithColor:RANDOMCOLOR];
	_view.needsDisplay = YES;
}

+ (NSImage*) screenCacheImageForView:(NSView*)aView
{
	NSRect originRect = [aView convertRect:[aView bounds] toView:[[aView window] contentView]];

	NSRect rect = originRect;
	rect.origin.y = 0;
	rect.origin.x += [aView window].frame.origin.x;
	rect.origin.y += [[aView window] screen].frame.size.height - [aView window].frame.origin.y - [aView window].frame.size.height;
	rect.origin.y += [aView window].frame.size.height - originRect.origin.y - originRect.size.height;

	CGImageRef cgimg = CGWindowListCreateImage(rect,
											   kCGWindowListOptionIncludingWindow,
											   (CGWindowID)[[aView window] windowNumber],
											   kCGWindowImageDefault);
	return [NSImage.alloc initWithCGImage:cgimg size:[aView bounds].size];
}
	//	NSThread *e;
	//	[self performSelector:@selector(defineRects) onThread:e withObject:nil waitUntilDone:YES];
	//	visiNow.size.height -= offset;
	//	visiNow.origin.y +=offset;
	//		visible.size.height -= window.frame.size.height;
	//		[NSImage  imageBelowWindow:_leveler]]

	//	[self defineRects];

	//	if (! [[_shroud animator]isAnimating] ) {
	//		NSInteger windy =  [_leveler windowNumber];
	//	NSImage *image =[NSImage alloc]in

	//	const void* thisWindow = [_leveler windowNumber];
	//	NSInteger thisWindow = [_leveler windowNumber];
	//	CFArrayRef thisWindowAsArray = CFMakeCollectable(CFArrayCreate(kCFAllocatorDefault, thisWindow, 1, NULL));
	//	CGImageRef r = (CGImageRef) CFMakeCollectable(CGWindowListCreateImageFromArray(CGRectNull, thisWindowAsArray, kCGWindowImageDefault));

	//	return [NSImage imageFromCGImageRef:CGWindowListCreateImage( 	AZFlipRectinRect(AZMakeRectMaxXUnderMenuBarY( AZScreenHeight() - 22 ), AZScreenFrame()), thisWindow, kCGWindowListOptionOnScreenBelowWindow | kCGWindowImageNominalResolution)];

	//		AZFlipRectinRect(AZMakeRectMaxXUnderMenuBarY( AZScreenHeight() - 22 ), AZScreenFrame()),  thisWindow, kCGWindowListOptionOnScreenBelowWindow, kCGWindowImageNominalResolution)];
	//AZMenulessScreenRect(), [_leveler windowNumber],

	//		CGWindowListCreateImage( AZFlipRectinRect( AZMenulessScreenRect(), AZScreenFrame()), windy,

	//_shroud.frame.size.height + _shroud.frame.origin.y )
	//		image = [image tintedWithColor:PURPLE];
	//	NSLog(@"%Requested mage : %@ for windy#: %ld", image, windy);
	//	self.view.image = image;
	//	_view.needsDisplay = YES;
	///tintedWithColor:[BLACK colorWithAlphaComponent:.2]]];/*(kCGWindowImageShouldBeOpaque | kCGWindowImageBoundsIgnoreFraming*/
	//	if ([[NSApplication sharedApplication]isActive]) {
	//		[_shroud setFrame:_pushedScreenRect display:YES];

	//		[_shroud display];		[_window display];
	//	}

	//}
- (void) appWillResign { //:(NSNotification *)notification {

	[NSThread performBlockInBackground:^{
//		[self capture];
		[[NSThread mainThread] performBlock:^{
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext]setDuration:.5];
			[[NSAnimationContext currentContext]setTimingFunction:
			 [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseOut]];
			[[_window animator]setFrame:_window.upFrame display:YES animate:YES];
			
//			[[_view animator]setFrame:AZMenulessScreenRect() display:YES animate:YES];
			[NSAnimationContext endGrouping];

		} waitUntilDone:YES];
		[[NSThread mainThread]performBlock:^{// [[_shroud animator] setAlphaValue:0]; }afterDelay:.01];
			[[ NSNotificationCenter defaultCenter] postNotificationName:@"okWindowFadeOutNow" object:nil];
		}];
	}];
//	[_shroud orderOut:_shroud];

	[refreshWhileActiveTimer invalidate];
//	refreshWhileActiveTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(capture) userInfo:nil repeats:YES];
}
	//- (void) applicationDidResignActive:(NSNotification *)notification{

	//	[@[_leveler, _window, _shroud] each:^(id obj, NSUInteger index, BOOL *stop) {
	//		if ([obj isVisible]) [obj fadeOutWithDuration:];
	//	}];
	//	[[_shroud  animator]setFrame:_unPushedScreenRect  display: animate:NO];
	//}

	//- (void)defineRects{

	//	self.flippedSnapRect = AZScreenFrame();
	//	_flippedSnapRect.size.height -= offset;
	//	_flippedSnapRect.origin.y += offset;

	//	self.PushedScreenRect = self.unPushedScreenRect = AZMakeRectMaxXUnderMenuBarY(AZScreenHeight()- 22);//AZMakeRect(NS
	//	(NSPoint){0,  AZScreenHeight() - ( 22 + sizer)},(NSSize){ AZScreenWidth(), 0 });
	//	_pushedScreenRect.origin.y  -= offset;//  AZMakeRectMaxXUnderMenuBarY(AZScreenHeight()- 22 - 100);
	//	 AZMakeRect(NSZeroPoint, (NSSize){ AZScreenWidth(),AZScreenHeight() - ( 22 + sizer)});

	//	_barFrameUp.origin.y += sizer;//tabView.frame.size.height;
	//	_barFrameUp.size.height = 0;

	//}
	//- (void) setShroudState:(ShroudIs)shroudState{
	//	_shroudState = shroudState;
	//	if (_shroudState == ShroudIsDown) {
	//		[self applicationWillBecomeActive:nil];
	//			//		[sender setState:NSOnState];
	//	} else {
	//		[self applicationWillResignActive:nil];
	//			//[sender setState:NSOffState];
	//	}
	//}

- (void) appWillActivate {
	[self capture];
	_window.downFrame 	= AZMakeRectMaxXUnderMenuBarY(_defaultSize);
	_shroud.downFrame =  AZLowerEdge(AZScreenFrame(), 300 +22);
	[_shroud setAlphaValue : 1];
//	_shroud.downFrame	= AZLowerEdge(AZScreenHeight()-22 - _defaultSize)
//	   AZRectVerticallyOffsetBy(_shroud.upFrame,_defaultSize);
	[ @[_window, _shroud] az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[obj setFrame:[[obj valueForKey:@"upFrame"] rectValue] display:NO animate:NO];
		[obj orderFrontRegardless];
	}];
		//	[@[_leveler, _window, _shroud] each:^(id obj, NSUInteger index, BOOL *stop) {
		//		if (! [obj isVisible])
		//		[obj orderFrontRegardless];
		//	}];
		//	[ @[_shroud, _leveler, _window] each:^(NSWindow* obj, NSUInteger index, BOOL *stop) {
		//		[obj makeKeyAndOrderFront:obj];
		//	}];
		//	[_window contentView]setIs
		//}
		//- (void) applicationDidBecomeActive:(NSNotification *)notification {
		//	[NSThread performBlockInBackground:^{
		//	[self performSelectorOnMainThread:@selector(capture) withObject:nil waitUntilDone:YES];
		//			[[NSThread mainThread] performBlock:^{
		//			[_view setNeedsDisplay : YES];
		[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext]setDuration:.5];
	[[NSAnimationContext currentContext]setTimingFunction:
	 [CAMediaTimingFunction 	functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		//			[[_shroud animator]setAlphaValue:1];

	[[_window animator]setFrame:_window.downFrame display:YES animate:YES];
	NSRect r = _shroud.frame;
	r.origin.y -= _defaultSize;
	[[_view animator] setFrame:r];// display:YES animate:YES ];// :_shroud.downFrame display:YES animate:YES];

	[NSAnimationContext endGrouping];
		//		} waitUntilDone:YES];
		//		[_shroud orderOut:_shroud];
		//	2]	[_shroud fadeOut];
		//	}];
	refreshWhileActiveTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(capture) userInfo:nil repeats:YES];

}

//- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
		//	__block NSArray *thradedArray;
		//	[NSThread performBlockInBackground:^{
		//		thradedArray = [AtoZ dockSorted];
		//		[[NSThread mainThread] performBlock:^{
		//			[thradedArray each:^(AZFile * obj, NSUInteger index, BOOL *stop) {
		//				number++;
		//				[tabView addTabWithRepresentedObject: obj];//@{ @"name": obj.name }];
		//			}];
		//
		//		}waitUntilDone:YES];
		//	}];

		//	[_window setBackgroundColor:RED];
//}
@end
