//
//  SDInsetDividerView.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/7/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDInsetDividerView.h"


@implementation SDInsetDividerView

- (void) drawRect:(NSRect)dirtyRect {
	NSRect topLine, bottomLine;
	NSDivideRect([self bounds], &topLine, &bottomLine, 1.0, NSMaxYEdge);
	
	[[NSColor lightGrayColor] setFill];
	[NSBezierPath fillRect:topLine];
	
	[[NSColor whiteColor] setFill];
	[NSBezierPath fillRect:bottomLine];
}

@end
