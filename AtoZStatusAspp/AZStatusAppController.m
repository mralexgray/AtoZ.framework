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
#import <AtoZ/AZBox.h>

@implementation AZStatusAppController
- (void)awakeFromNib {
    // Create an NSStatusItem.
    float width = 300.0;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:width];
    [statusItem setView:[[AZStatusItemView alloc] initWithFrame:viewFrame controller:self]];
	NSRect barFrame = AGMakeRectMaxXUnderMenuBarY(100);
	[rootView setFrame:barFrame];
	NSRect viewf = rootView.frame;
	float w = viewf.size.width / 10;
	for (int i =0; i <10; i++) {
		NSRect r = NSMakeRect( i*w, 0, w, viewf.size.height*.9);
		NSLog(@"%@", NSStringFromRect(r));
		AZBox *n = [[AZBox alloc]initWithFrame:r];
		n.tag = i;
		[rootView addSubview:n];
	}

}




- (void)toggleAttachedWindowAtPoint:(NSPoint)pt
{
	[NSApp activateIgnoringOtherApps:YES];
	
    if (!attachedWindow) {
        attachedWindow = [[AZAttachedWindow alloc] initWithView:rootView 
                                                attachedToPoint:pt 
                                                       inWindow:nil 
                                                         onSide:AZPositionBottom 
                                                     atDistance:5.0];
//        [textField setTextColor:[attachedWindow borderColor]];
//        [textField setStringValue:@"Your text goes here..."];
		menuWindowIsShowing = NO;
	
			//	[attachedWindow makeKeyAndOrderFront:self];
    }
//	if (![attachedWindow isAnimating]) {
	(menuWindowIsShowing ? [attachedWindow slideUp] : [attachedWindow slideDown]);
	menuWindowIsShowing =! menuWindowIsShowing;
}
//        [attachedWindow orderOut:self];
//        attachedWindow = nil;

//}

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
