//
//  AZMenuBarAppController.h
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>



#import <Cocoa/Cocoa.h>
//#import <AGFoundation/AGFoundation.h>
#import <QuartzCore/QuartzCore.h>
//#import "ACTGradientEditor.h"
//#import "ACTGradientView.h"
//#import "AGMenuItemView.h"
#import <AppKit/AppKit.h>


//@class DBXGridView;
@interface AZMenuBarAppController : NSObject		<NSApplicationDelegate, NSWindowDelegate> {

	// APPLICATION
	BOOL						trusted, retracted;
	NSRect						visibleWindowFrame;
	NSRect 						retractedWindowFrame;
	NSRect 						screen;
	NSUserDefaults *			uDefs;

	// MENU
	id							activeView;
	
	// STARTUP ROUTINE
	IBOutlet NSTextField 		*startupStatusText;
	IBOutlet NSImageView		*startup1;
	IBOutlet NSImageView		*startup2;
	IBOutlet NSImageView		*startupOK;
	int 						counter;
	NSTimer 					*startupTimer, *progressTimer;
	NSDictionary *				startupSteps;
}
//	DBXObject *dbx;
//	NSArray *					localApps;

- (void)toggleAttachedWindowAtPoint:(NSPoint)pt withView:(NSView*)aView;
- (void)toggleAttachedWindowAtPoint:(NSPoint)pt;
- (void)toggleWindow;

@property ( nonatomic) IBOutlet NSView *startupView;
@property ( nonatomic) IBOutlet AGProgressIndicator *startupIndicator;
@property ( nonatomic) IBOutlet NSTextView *statusText;
@property ( nonatomic) NSArray *mLabelArray;


@property (nonatomic) NSStatusItem 				*statusItem;
@property (nonatomic) NSMenu 					*menu;


@property (nonatomic) AGMenuItemView *menuItemView;
//@property (nonatomic) MAAttachedWindow *pieWindow;
//@property (nonatomic) MAAttachedWindow *appList;
@property (assign) IBOutlet NSButton *advanceCounter;
@property (nonatomic) DBXWindow *attachedWindow;

-(IBAction) advanceCounter:(id)sender;

//@property (readonly, retain) DBXObject 		*dbx;
//@property (nonatomic, retain) DBXGridView 	*dbxGrid;

//@property (nonatomic, retain) IBOutlet AGBoxView *bv;


//@property (weak, nonatomic) ACTGradientEditor *gEditor;
//@property (weak, nonatomic) ACTGradientView *gView;




@end
