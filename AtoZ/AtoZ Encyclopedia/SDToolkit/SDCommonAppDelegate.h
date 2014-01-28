//
//  SDCommonAppDelegate.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/4/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AtoZ/AtoZ.h>

#import "SDInstructionsWindowController.h"
#import "SDPreferencesController.h"

@class SDOpenAtLoginController;

@interface SDCommonAppDelegate : NSObject <SDInstructionsDelegate, SDPreferencesDelegate> {
	SDOpenAtLoginController *openAtLoginController;
	SDPreferencesController *preferencesController;
	SDInstructionsWindowController *instructionWindowController;
}

- (IBAction) showInstructionsWindow:(id)sender;

- (IBAction) showPreferencesPanel:(id)sender;

- (IBAction) showAboutPanel:(id)sender;
- (IBAction) toggleOpensAtLogin:(id)sender;

// useful methods

- (void) setOpensAtLogin:(BOOL)opens;

// menu validation (so you know to call super)

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem;

// must implement in subclass!

- (NSA*) instructionImageNames;

- (BOOL) showsPreferencesToolbar;
- (NSA*) preferencePaneControllerClasses;

@end
