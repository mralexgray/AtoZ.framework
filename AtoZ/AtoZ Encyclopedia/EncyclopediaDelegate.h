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

@interface EncyclopediaDelegate : SDCommonAppDelegate  <NSApplicationDelegate>

@property (nonatomic, assign) IBOutlet NSMenu *statusMenu;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSArray *trackers;

@property (nonatomic, strong) NSMutableArray *noteControllers;

@property (nonatomic, retain) AZBox *s;
@property (nonatomic, retain) AZAttachedWindow *at;

@property (nonatomic, retain) AZSimpleView *view;

@property (NATOM, ASS) NSUInteger side;

@property (nonatomic, retain) NSWindow *mainWindow;
@property (nonatomic, retain) AZAttachedWindow * attachedWindow;
@property (NATOM, ASS) NSPoint attachPoint;

@property (nonatomic, retain) AZTrackingWindow *left;
@property (nonatomic, retain) AZTrackingWindow *right;
@property (nonatomic, retain) AZTrackingWindow *top;
@property (nonatomic, retain) AZTrackingWindow *bottom;

- (IBAction) addNote:(id)sender;
- (IBAction) removeAllNotes:(id)sender;

@end
