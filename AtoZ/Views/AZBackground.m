
//  AZBackground.m
//  AtoZ

//  Created by Alex Gray on 8/17/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZBackground.h"

@implementation AZBackground
- (id)initWithFrame:(NSRect)frame {
	if (self = [super initWithFrame:frame]) {
	}
	return self;
}

- (void)drawRect:(NSRect)rect {

	NSRect bounds = self.bounds;

	// Draw background gradient
	NSGradient *gradient = [[NSGradient alloc] initWithColorsAndLocations:
							[NSColor colorWithDeviceWhite:0.15f alpha:1.0f], 0.0f,
							[NSColor colorWithDeviceWhite:0.19f alpha:1.0f], 0.5f,
							[NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.5f,
							[NSColor colorWithDeviceWhite:0.25f alpha:1.0f], 1.0f,
							nil];

	[gradient drawInRect:bounds angle:90.0f];
	//	[gradient release];

	// Stroke bounds
	[[NSColor blackColor] setStroke];
	[NSBezierPath strokeRect:bounds];
}

@end
