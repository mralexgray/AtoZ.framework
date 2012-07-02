//
//  AppController.h
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AZAttachedWindow;
@interface AZStatusAppController : NSObject <NSApplicationDelegate> {
    NSStatusItem *statusItem;
    AZAttachedWindow *attachedWindow;
    
    IBOutlet NSView *view;
    IBOutlet NSTextField *textField;
}

- (void)toggleAttachedWindowAtPoint:(NSPoint)pt;

@end
