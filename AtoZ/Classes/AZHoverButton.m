//
//  AZSoftButton.m
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZHoverButton.h"

@implementation AZHoverButton

- (void)updateTrackingAreas
{
	[super updateTrackingAreas];
	if (trackingArea)
		[self removeTrackingArea:trackingArea];

	NSTrackingAreaOptions options = 
		NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event
{
	//	[self setImage:[NSImage imageNamed:nil]];
	NSBeep();
	[self setImage:[NSImage imageNamed:@"2"]];
}

- (void)mouseExited:(NSEvent *)event
{
	[self setImage:[NSImage imageNamed:@"1"]];
}

@end
