//
//  ShroudWindow.m
//  AtoZ
//
//  Created by Alex Gray on 8/20/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZVeil.h"

@implementation AZVeil

- (void) awakeFromNib {

	[_leveler setFrame:NSMakeRect(0, (ScreenHighness()-1),1,1) display:YES animate:NO];
	[_shroud  setIgnoresMouseEvents:YES];
	[ @[_shroud, _leveler, _window] each:^(id obj, NSUInteger index, BOOL *stop) {
		[obj setDelegate:self];
//		[[obj contentView] setPostsBoundsChangedNotifications:YES];
//		[[obj contentView] setPostsFrameChangedNotifications:YES];
		[obj  setLevel:0];
//		[obj setOpaque:YES];
		[obj makeKeyWindow];
		CAAnimation *animation = [CABasicAnimation animation];
		[animation setDelegate:self];
		[obj setAnimations:@{ @"alphaValue":animation}];

	}];
	float sizer =100;
	float offset = ([[NSApplication sharedApplication]isActive] ?
					22 : (22 + sizer) );
	self.barFrameUp = AZMakeRectMaxXUnderMenuBarY(0);
	self.barFrame = AZMakeRectMaxXUnderMenuBarY(offset);

	NSNotificationCenter *dCenter = [NSNotificationCenter defaultCenter];


	[@{ NSApplicationWillBecomeActiveNotification	:	@"applicationWillBecomeActive:",
		NSApplicationDidBecomeActiveNotification	:	@"applicationDidBecomeActive:",
		NSApplicationWillResignActiveNotification	:	@"applicationWillResignActive:",
		NSApplicationDidResignActiveNotification 	:	@"applicationDidResignActive:" 	}

		enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

			[dCenter addObserver:self selector:NSSelectorFromString(obj)
			name:key object:nil];//[NSApplication sharedApplication]];
	}];

}

- (void) capture {

//	NSThread *e;
//	[self performSelector:@selector(defineRects) onThread:e withObject:nil waitUntilDone:YES];
		//	visiNow.size.height -= offset;
		//	visiNow.origin.y +=offset;
		//		visible.size.height -= window.frame.size.height;
//		[NSImage  imageBelowWindow:_leveler]]

//	[self defineRects];

//	if ( [[_shroud animator]isAnimating] ) return;
	[_view setImage:[[NSImage imageFromCGImageRef: CGWindowListCreateImage(

		AZFlipRectinRect(
			AZMakeRectMaxXUnderMenuBarY(
				_shroud.frame.size.height + _shroud.frame.origin.y ),
					AZScreenFrame()),

		kCGWindowListOptionOnScreenBelowWindow,
		[_leveler windowNumber],kCGWindowImageNominalResolution) ]tintedWithColor:[BLACK colorWithAlphaComponent:.2]]];/*(kCGWindowImageShouldBeOpaque | kCGWindowImageBoundsIgnoreFraming*/
//	if ([[NSApplication sharedApplication]isActive]) {
//		[_shroud setFrame:_pushedScreenRect display:YES];
		[_view setNeedsDisplay : YES];
//		[_shroud display];
//		[_window display];

//	}
}


- (void) applicationWillResignActive:(NSNotification *)notification {
	[NSThread performBlockInBackground:^{
		[self capture];
		[[NSThread mainThread] performBlock:^{
				//			[_shroud orderFrontRegardless];
				//			[_window orderFrontRegardless];
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext]setDuration:2];
			[[NSAnimationContext currentContext]setTimingFunction:[CAMediaTimingFunction functionWithName:
																   kCAMediaTimingFunctionEaseInEaseOut]];

			[[_window animator]setFrame:_barFrameUp display:YES animate:YES];
			[[_shroud animator]setFrame:AZMenulessScreenRect() display:YES animate:YES];

			[NSAnimationContext endGrouping];
		} waitUntilDone:YES];
	}];
}
//	refreshWhileActiveTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(capture) userInfo:nil repeats:YES];
//	[refreshWhileActiveTimer invalidate];
//}
- (void) applicationDidResignActive:(NSNotification *)notification{

//	[@[_window, _shroud] each:^(id obj, NSUInteger index, BOOL *stop) {
//		if ([obj isVisible]) [obj fadeOutWithDuration:1];
//	}];
//	[_shroud setFrame:_unPushedScreenRect  display:NO animate:NO];
}

- (void)defineRects{

//	self.flippedSnapRect = AZScreenFrame();
//	_flippedSnapRect.size.height -= offset;
//	_flippedSnapRect.origin.y += offset;

//	self.PushedScreenRect = self.unPushedScreenRect = AZMakeRectMaxXUnderMenuBarY(ScreenHighness()- 22);//AZMakeRect(NS
//	(NSPoint){0,  ScreenHighness() - ( 22 + sizer)},(NSSize){ ScreenWidess(), 0 });
//	_pushedScreenRect.origin.y  -= offset;//  AZMakeRectMaxXUnderMenuBarY(ScreenHighness()- 22 - 100);
//	 AZMakeRect(NSZeroPoint, (NSSize){ ScreenWidess(),ScreenHighness() - ( 22 + sizer)});
	
//	_barFrameUp.origin.y += sizer;//tabView.frame.size.height;
//	_barFrameUp.size.height = 0;

}
- (void) setShroudState:(ShroudIs)shroudState{
	_shroudState = shroudState;
	if (_shroudState == ShroudIsDown) {
		[self applicationWillBecomeActive:nil];
			//		[sender setState:NSOnState];
	} else {
		[self applicationWillResignActive:nil];
			//[sender setState:NSOffState];
	}
}

- (void) applicationWillBecomeActive:(NSNotification *)notification{

	refreshWhileActiveTimer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(capture) userInfo:nil repeats:YES];


	[_window setFrame:_barFrameUp display:NO animate:NO];
	[_shroud setFrame:AZMenulessScreenRect() display:NO animate:NO];
	[ @[_shroud, _leveler, _window] each:^(NSWindow* obj, NSUInteger index, BOOL *stop) {
		[obj makeKeyAndOrderFront:obj];
	}];
//	[_window contentView]setIs
}
- (void) applicationDidBecomeActive:(NSNotification *)notification {
		//	[_shroud setAlphaValue:1];
		//	[self performSelectorOnMainThread:@selector(capture) withObject:nil waitUntilDone:YES];
	[NSThread performBlockInBackground:^{
		[self capture];
			[[NSThread mainThread] performBlock:^{
//			[_shroud orderFrontRegardless];
//			[_window orderFrontRegardless];
			[NSAnimationContext beginGrouping];
			[[NSAnimationContext currentContext]setDuration:2];
			[[NSAnimationContext currentContext]setTimingFunction:[CAMediaTimingFunction functionWithName:
			kCAMediaTimingFunctionEaseInEaseOut]];


			[[_window animator]setFrame:_barFrame display:YES animate:YES];
			[[_shroud animator]setFrame:AZRectVerticallyOffsetBy(AZMenulessScreenRect(),-_barFrame.size.height) display:YES animate:YES];
			[NSAnimationContext endGrouping];
		} waitUntilDone:YES];
	}];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
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

	[_window setBackgroundColor:RED];
}
@end
