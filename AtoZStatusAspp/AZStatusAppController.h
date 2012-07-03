//
//  AppController.h
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AZAttachedWindow;
@interface AZStatusAppController : NSObject <NSApplicationDelegate, NSWindowDelegate> {
    NSStatusItem *statusItem;
    AZAttachedWindow *attachedWindow;
    BOOL menuWindowIsShowing;
    IBOutlet NSView *rootView;
    IBOutlet NSTextField *textField;
}

- (void)toggleAttachedWindowAtPoint:(NSPoint)pt;

@end
