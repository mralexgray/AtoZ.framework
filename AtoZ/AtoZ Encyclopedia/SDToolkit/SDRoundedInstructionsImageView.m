//
//  SDRoundedInstructionsView.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDRoundedInstructionsImageView.h"


@implementation SDRoundedInstructionsImageView

- (void) drawRect:(NSRect)dirtyRect {
	float r = 7.0;
	float r2 = r - 0.9;
	
	NSRect bounds = [self bounds];
	NSRect imageClipBounds = NSInsetRect(bounds, 1.0, 1.0);
	
	NSBezierPath *borderFillPath = [NSBezierPath bezierPathWithRoundedRect:bounds xRadius:r yRadius:r];
	NSBezierPath *imageClipPath = [NSBezierPath bezierPathWithRoundedRect:imageClipBounds xRadius:r2 yRadius:r2];
	
	// draw background
//	[[NSColor windowBackgroundColor] setFill];
//	[NSBezierPath fillRect:bounds];
	
	// draw border
	[[NSColor colorWithCalibratedWhite:0.20 alpha:1.0] setFill];
	[borderFillPath fill];
	
	// clip
	[imageClipPath addClip];
	
	// draw image
	[super drawRect:dirtyRect];
}

@end
