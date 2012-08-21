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
	[self defineRects];
	[_leveler orderFrontRegardless];
	[_leveler setFrame:NSMakeRect(0, (ScreenHighness()-1),1,1) display:YES animate:NO];


	[_leveler setLevel: 0];

	[_shroud setLevel : 14 ];
	[[_shroud contentView]setPostsBoundsChangedNotifications:YES];
	[[_window contentView]setPostsFrameChangedNotifications:YES];

	[_shroud setIgnoresMouseEvents:YES];
	[_window setLevel:14];


	NSNotificationCenter *dCenter = [NSNotificationCenter defaultCenter];

	[dCenter	addObserver:self	selector:@selector(applicationDidBecomeActive:)
	 name:NSApplicationDidBecomeActiveNotification		object:NSApp];

	[dCenter	 addObserver:self	 selector:@selector(applicationDidResignActive:)
	 name:NSApplicationDidResignActiveNotification	 object:NSApp];

	[dCenter	 addObserver:self selector:@selector(applicationWillBecomeActive:)
	 name:NSApplicationWillBecomeActiveNotification	 object:NSApp];

	[dCenter	 addObserver:self	 selector:@selector(applicationWillResignActive:)
		 name:NSApplicationWillResignActiveNotification	 object:NSApp];
}

- (void) capture {

	[self defineRects];
		//	visiNow.size.height -= offset;
		//	visiNow.origin.y +=offset;
		//		visible.size.height -= window.frame.size.height;
	[_view setImage : [NSImage imageFromCGImageRef:
											CGWindowListCreateImage(
																	flippedSnapRect,
																	kCGWindowListOptionOnScreenBelowWindow,
																	[_leveler windowNumber],
																	kCGWindowImageDefault ) ]];
	if ([[NSApplication sharedApplication]isActive]) {
		[_view setNeedsDisplay : YES];
		[_shroud setFrame:pushedScreenRect display:YES];
		[_shroud setFrame:pushedScreenRect display:YES];
	}
}


- (void) applicationWillResignActive:(NSNotification *)notification {

 	[refreshWhileActiveTimer invalidate];
	[NSAnimationContext beginGrouping];
	[[_window animator]setFrame:barFrameUp display:YES animate:YES];
	[[_shroud animator]setFrame:unPushedScreenRect display:YES animate:YES];
	[NSAnimationContext endGrouping];
	refreshWhileActiveTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(capture) userInfo:nil repeats:YES];

}
- (void) applicationDidResignActive:(NSNotification *)notification{

	[@[_window, _shroud] each:^(id obj, NSUInteger index, BOOL *stop) {
		if ([obj isVisible]) [obj fadeOutWithDuration:.001];
	}];
	[_shroud setFrame:unPushedScreenRect  display:NO animate:NO];
}

- (void)defineRects{

	flippedSnapRect = AZScreenFrame();

	float offset = ([[NSApplication sharedApplication]isActive] ?
					22 : (22 + 46) );
	flippedSnapRect.size.height -= offset;
	flippedSnapRect.origin.y += offset;

	unPushedScreenRect = AZMakeRect((NSPoint){0,  ScreenHighness() - ( 22 + 46)},(NSSize){ ScreenWidess(), 0 });
	pushedScreenRect  = AZMakeRect(NSZeroPoint, (NSSize){ ScreenWidess(),ScreenHighness() - ( 22 + 46)});
	barFrame = AZMakeRectMaxXUnderMenuBarY(46);
	barFrameUp = barFrame;
	barFrameUp.origin.y += 46;//tabView.frame.size.height;
	barFrameUp.size.height = 0;
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

	if (refreshWhileActiveTimer) 	[refreshWhileActiveTimer invalidate];
	[_window setFrame:barFrameUp display:YES];
	[_shroud setFrame:unPushedScreenRect display:YES];
}
- (void) applicationDidBecomeActive:(NSNotification *)notification {
		//	[_shroud setAlphaValue:1];
		//	[self performSelectorOnMainThread:@selector(capture) withObject:nil waitUntilDone:YES];
	[NSThread performBlockInBackground:^{
		[self capture];
		[[NSThread mainThread] performBlock:^{
			[_shroud orderFrontRegardless];
			[_window orderFrontRegardless];
			[NSAnimationContext beginGrouping];
			[[_window animator]setFrame:barFrame display:YES animate:YES];
			[[_shroud animator]setFrame:pushedScreenRect display:YES animate:YES];
			[NSAnimationContext endGrouping];
		} waitUntilDone:YES];
	}];

	refreshWhileActiveTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(capture) userInfo:nil repeats:YES];
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
