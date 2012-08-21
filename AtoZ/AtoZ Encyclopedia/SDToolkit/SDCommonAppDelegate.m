//
//  SDCommonAppDelegate.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/4/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDCommonAppDelegate.h"
#import "NSApplication+AppInfo.h"
#import "SDOpenAtLoginController.h"

@implementation SDCommonAppDelegate

- (id) init {
	if (self = [super init]) {
	}
	return self;
}

// MARK: -
// MARK: About Panel

- (IBAction) showAboutPanel:(id)sender {
	[NSApp orderFrontStandardAboutPanel:sender];
}

// MARK: -
// MARK: Opens At Login

- (SDOpenAtLoginController*) openAtLoginController {
	if (openAtLoginController == nil)
		openAtLoginController = [[SDOpenAtLoginController alloc] init];
	
	return openAtLoginController;
}

- (void) setOpensAtLogin:(BOOL)opens {
	[self openAtLoginController].opensAtLogin = opens;
}

- (IBAction) toggleOpensAtLogin:(id)sender {
	NSInteger changingToState = ![sender integerValue];
	[self openAtLoginController].opensAtLogin = changingToState;
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem {
	if ([menuItem action] == @selector(toggleOpensAtLogin:)) {
		NSInteger state = ([self openAtLoginController].opensAtLogin ? NSOnState : NSOffState);
		[menuItem setState:state];
	}
	return YES;
}

// MARK: -
// MARK: Instructions Window

- (IBAction) showInstructionsWindow:(id)sender {
	if ([[self instructionImageNames] count] == 0) {
		NSAlert *alert = [[[NSAlert alloc] init] autorelease];
		[alert setMessageText:@"Help"];
		[alert setInformativeText:$(@"Help isn't available for %@", [[NSApplication sharedApplication] appName])];
		[alert runModal];
		return;
	}
	
	if (instructionWindowController == nil) {
		instructionWindowController = [[SDInstructionsWindowController alloc] init];
		instructionWindowController.delegate = self;
	}
	
	[NSApp activateIgnoringOtherApps:YES];
	[[instructionWindowController window] center];
	[instructionWindowController showWindow:self];
}

- (NSArray*) instructionImageNames {
	return nil;
}

// MARK: -
// MARK: Preferences Panel

- (IBAction) showPreferencesPanel:(id)sender {
	if (preferencesController == nil) {
		preferencesController = [[SDPreferencesController alloc] init];
		preferencesController.delegate = self;
	}
	
	[NSApp activateIgnoringOtherApps:YES];
	[preferencesController showWindow:self];
}

- (BOOL) showsPreferencesToolbar {
	return NO;
}

- (NSArray*) preferencePaneControllerClasses {
	return nil;
}

@end
