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


- (void)awakeFromNib
{
    // Create an NSStatusItem.
    float width = 30.0;
    float height = [[NSStatusBar systemStatusBar] thickness];
    NSRect viewFrame = NSMakeRect(0, 0, width, height);
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:width];
    [statusItem setView:[[AZStatusItemView alloc] initWithFrame:viewFrame controller:self]];
}


- (void)dealloc
{
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}


- (void)toggleAttachedWindowAtPoint:(NSPoint)pt
{
	[NSApp activateIgnoringOtherApps:YES];
    // Attach/detach window.
    if (!attachedWindow) {
        attachedWindow = [[AZAttachedWindow alloc] initWithView:view 
                                                attachedToPoint:pt 
                                                       inWindow:nil 
                                                         onSide:AZPositionBottom 
                                                     atDistance:5.0];
        [textField setTextColor:[attachedWindow borderColor]];
        [textField setStringValue:@"Your text goes here..."];
        [attachedWindow makeKeyAndOrderFront:self];
    } else {
        [attachedWindow orderOut:self];
        attachedWindow = nil;
    }    
}

- (void) applicationDidResignActive:(NSNotification *)notification 

{

	[attachedWindow orderOut:self];
}


@end
