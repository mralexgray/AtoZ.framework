//
//  WindyController.m
//  AZLayerGrid
//
//  Created by Alex Gray on 8/22/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import "WindyController.h"

@interface WindyController ()
@property (assign, nonatomic) NSPoint initialLocation;
@end

@implementation WindyController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
		

			[[self window] setStyleMask: NSResizableWindowMask];
			[[self window] setLevel: NSStatusWindowLevel];//NSScreenSaverWindowLevel];//
			[[self window] setBackgroundColor: [NSColor clearColor]];
			[[self window] setAlphaValue:1.0];
			[[self window] setOpaque:NO];
			[[self window] setHasShadow:NO];
			[[self window] setMovable:YES];
			return self;
		}

		return nil;
	}


- (void)windowDidLoad
{
    [super windowDidLoad];

    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}



- (BOOL) canBecomeKeyWindow
{
	return YES;
}


- (void)mouseDragged:(NSEvent *)theEvent
{
	NSPoint currentLocation;
	NSPoint newOrigin;
	NSRect  screenFrame = [[NSScreen mainScreen] frame];
	NSRect  windowFrame = [[self window] frame];

	currentLocation = [[self window] convertBaseToScreen:[[self window] mouseLocationOutsideOfEventStream]];
	newOrigin.x = currentLocation.x - _initialLocation.x;
	newOrigin.y = currentLocation.y - _initialLocation.y;

	if( (newOrigin.y + windowFrame.size.height) > (NSMaxY(screenFrame) - 22) ){
			//	[NSMenu menuBarHeight]) ){
			// Prevent dragging into the menu bar area
			//	newOrigin.y = NSMaxY(screenFrame) - windowFrame.size.height - 22;
			//	 [NSMenuView menuBarHeight];
	}

	if (newOrigin.y < NSMinY(screenFrame)) {
			// Prevent dragging off bottom of screen
		newOrigin.y = NSMinY(screenFrame);
	}
	if (newOrigin.x < NSMinX(screenFrame)) {
			// Prevent dragging off left of screen
		newOrigin.x = NSMinX(screenFrame);
	}
	if (newOrigin.x > NSMaxX(screenFrame) - windowFrame.size.width) {
			// Prevent dragging off right of screen
		newOrigin.x = NSMaxX(screenFrame) - windowFrame.size.width;
	}


	[[self window] setFrameOrigin:newOrigin];
}


- (void)mouseDown:(NSEvent *)theEvent
{
	NSRect windowFrame = [[self window] frame];
	// Get mouse location in global coordinates
	_initialLocation = [[self window] convertBaseToScreen:[theEvent locationInWindow]];
	_initialLocation.x -= windowFrame.origin.x;
	_initialLocation.y -= windowFrame.origin.y;
}



@end
