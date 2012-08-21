//
//  AppController.h
//  NSStatusItemTest
//
//  Created by Matt Gemmell on 04/03/2008.
//  Copyright 2008 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>
#import "AZStatusItemView.h"
#define EXCLUDE_STUB_PROTOTYPES 1
#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>
#import "ControlBar.h"

#import <ApplicationServices/ApplicationServices.h>
#import <Carbon/Carbon.h>

@interface AZStatusAppController : NSObject 
<	NSApplicationDelegate,	NSWindowDelegate, 
	AZStatusItemDelegate	>
{
    NSStatusItem *statusItem;
	NSMenu *menu;
	AZStatusItemView *statusView;
}

@property (unsafe_unretained) 	IBOutlet NSProgressIndicator *pIndi;
@property (weak) 				IBOutlet TransparentWindow *controls;
@property (strong) 				IBOutlet AtoZInfinity *infiniteBlocks;
@property (weak) 				IBOutlet NSButton *orientButton;
@property (weak) 				IBOutlet NSSlider *scaleSlider;

@property (nonatomic, retain)  IBOutlet NSWindow *attachedWindow;
//- (void)statusView:(AZStatusItemView *)statusItem isActive:(BOOL)active;
//- (void)toggleAttachedWindowAtPoint:(NSPoint)pt;

//@property (readonly) NSString *activeViews;

@end
