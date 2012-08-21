//
//  SDPreferencesController.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/6/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDPreferencesController.h"

#import "NSWindow+Geometry.h"

@interface SDPreferencesController (Private)


@end


@implementation SDPreferencesController

@synthesize delegate;

- (id) init {
	if (self = [super initWithWindowNibName:@"PreferencesWindow"]) {
		[self setWindowFrameAutosaveName:@"preferencesWindow"];
		
		preferencePaneControllers = [[NSMutableArray array] retain];
		toolbarItems = [[NSMutableArray array] retain];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationWillTerminate:)
													 name:NSApplicationWillTerminateNotification
												   object:NSApp];
	}
	return self;
}

- (void) dealloc {
	[toolbarItems release];
	[preferencePaneControllers release];
	[super dealloc];
}

- (void) windowDidLoad {
	initialSize = [[[self window] contentView] frame].size;
	
	//[paneContainerView setWantsLayer:YES];
	[toolbar setVisible:[self.delegate showsPreferencesToolbar]];
	
	if ([[self toolbarItemIdentifiers] count] > 0)
		[self selectPreferencePaneWithIdentifier:[self toolbarItemIdentifiers][0] animate:YES];
}

- (void) applicationWillTerminate:(NSNotification*)notification {
	[[self window] setAlphaValue:0.0];
	if ([[self toolbarItemIdentifiers] count] > 0)
		[[self window] setContentViewSize:initialSize display:NO animate:NO];
}

- (void) setDelegate:(id<SDPreferencesDelegate>)newDelegate {
	delegate = newDelegate;
	
	[toolbarItems removeAllObjects];
	[preferencePaneControllers removeAllObjects];
	
	NSArray *classes = [self.delegate preferencePaneControllerClasses];
	
	for (Class PrefPaneClass in classes) {
		// throw exception if it doesnt fit the protocol
		if ([PrefPaneClass conformsToProtocol:@protocol(SDPreferencePane)] == NO)
			@throw [NSException exceptionWithName:@"Illegal Preference Pane"
										   reason:@"Returned Preference pane does not conform to protocol"
										 userInfo:nil];
		
		id <SDPreferencePane> pane = [[[PrefPaneClass alloc] init] autorelease];
		[preferencePaneControllers addObject:pane];
		
		NSString *identifier = NSStringFromClass(PrefPaneClass);
		NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:identifier] autorelease];
		[toolbarItems addObject:item];
		
		[item setImage:[pane image]];
		[item setLabel:[pane title]];
		[item setTarget:self];
		[item setAction:@selector(preferencesToolbarItemClicked:)];
	}
}

- (NSArray*) toolbarItemIdentifiers {
	return [toolbarItems valueForKey:@"itemIdentifier"];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)someToolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
	NSUInteger index = [[self toolbarItemIdentifiers] indexOfObject:itemIdentifier];
	return toolbarItems[index];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)someToolbar {
	return [self toolbarItemIdentifiers];
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)someToolbar {
	return [self toolbarItemIdentifiers];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)someToolbar {
	return [self toolbarItemIdentifiers];
}

- (void) selectPreferencePaneWithIdentifier:(NSString*)identifier animate:(BOOL)animate {
	[toolbar setSelectedItemIdentifier:identifier];
	
	NSUInteger index = [[self toolbarItemIdentifiers] indexOfObject:identifier];
	id <SDPreferencePane> paneToSelect = preferencePaneControllers[index];
	
	NSView *oldSubview = [[paneContainerView subviews] lastObject];
	NSView *newSubview = [paneToSelect view];
	
	// remove old pane
	if (animate)
		[[oldSubview animator] removeFromSuperview];
	
	// animate window
	[[self window] setContentViewSize:[newSubview frame].size display:YES animate:animate];
	
	// add new pane
	[newSubview setFrameOrigin:NSZeroPoint];
	[(animate ? [paneContainerView animator] : paneContainerView) addSubview:newSubview];
	
	// setting window title (if toolbar is shown)
	if ([self.delegate showsPreferencesToolbar])
		[[self window] setTitle:[paneToSelect title]];
}

- (IBAction) preferencesToolbarItemClicked:(id)sender {
	[self selectPreferencePaneWithIdentifier:[sender itemIdentifier] animate:YES];
}

@end
