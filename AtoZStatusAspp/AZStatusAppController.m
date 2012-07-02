//
//  AppController.m
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import "AZStatusAppController.h"
#import "AZStatusItemView.h"
#import <AtoZ/AZAttachedWindow.h>

@implementation AZStatusAppController
- (void)awakeFromNib {
    // Create an NSStatusItem.
    float width = 30.0;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:width];
    [statusItem setView:[[AZStatusItemView alloc] initWithFrame:viewFrame controller:self]];
}




- (void)toggleAttachedWindowAtPoint:(NSPoint)pt
{
	[NSApp activateIgnoringOtherApps:YES];
    if (!attachedWindow) {
        attachedWindow = [[AZAttachedWindow alloc] initWithView:view 
                                                attachedToPoint:pt 
                                                       inWindow:nil 
                                                         onSide:AZPositionBottom 
                                                     atDistance:5.0];
        [textField setTextColor:[attachedWindow borderColor]];
        [textField setStringValue:@"Your text goes here..."];
		menuWindowIsShowing = NO;
		//	[attachedWindow makeKeyAndOrderFront:self];
    }
	if (![attachedWindow isAnimating]) {
	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
	menuWindowIsShowing =! menuWindowIsShowing;}
//        [attachedWindow orderOut:self];
//        attachedWindow = nil;

}

- (void) applicationDidResignActive:(NSNotification *)notification {
	[attachedWindow slideUp];// orderOut:self];
}
- (void) applicationDidBecomeActive:(NSNotification *)notification{
	if (!menuWindowIsShowing) [attachedWindow slideDown];
	
}

- (void)dealloc {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

@end
