//
//  SDPreferencesController.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/6/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SDPreferencesDelegate

- (BOOL) showsPreferencesToolbar;
- (NSA*) preferencePaneControllerClasses;

@end

@protocol SDPreferencePane

- (NSString*) title;
- (NSImage*) image;
- (NSView*) view;
- (NSString*) tooltip;

@end

#import "SDWindowController.h"

@interface SDPreferencesController : SDWindowController {
	IBOutlet NSToolbar *toolbar;
	IBOutlet NSView *paneContainerView;
	
	NSSize initialSize;
	
	NSMutableArray *toolbarItems;
	NSMutableArray *preferencePaneControllers;
	
	id <SDPreferencesDelegate> delegate;
}

@property (assign) id <SDPreferencesDelegate> delegate;

- (NSA*) toolbarItemIdentifiers;

- (void) selectPreferencePaneWithIdentifier:(NSString*)identifier animate:(BOOL)animate;

@end
