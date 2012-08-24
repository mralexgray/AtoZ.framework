//
//  AppDelegate.h
//  DeskNotation
//
//  Created by Steven Degutis on 6/27/09.
//  Copyright 2009 8th Light. All rights reserved.
//
#import "MAAttachedWindow.h"
#import <AtoZ/AtoZ.h>
#import "SDToolkit.h"
#import "SDCommonAppDelegate.h"

@interface EncyclopediaDelegate : SDCommonAppDelegate  <NSApplicationDelegate> {
	IBOutlet NSMenu *statusMenu;
	NSStatusItem *statusItem;
	NSArray *trackers;
}
@property (retain, nonatomic) NSMutableArray *noteControllers;

@property (nonatomic, retain) AZBox *s;
@property (nonatomic, retain) AZAttachedWindow *at;

- (IBAction) addNote:(id)sender;
- (IBAction) removeAllNotes:(id)sender;
@property (nonatomic, retain) AZSimpleView *view;

@property (assign, nonatomic) NSUInteger side;

@property (nonatomic, retain) NSWindow *mainWindow;
@property (nonatomic, retain) MAAttachedWindow * attachedWindow;
@property (assign, nonatomic) NSPoint attachPoint;

@property (nonatomic, retain) AZTrackingWindow *left;
@property (nonatomic, retain) AZTrackingWindow *right;
@property (nonatomic, retain) AZTrackingWindow *top;
@end
