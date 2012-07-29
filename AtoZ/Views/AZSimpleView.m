//
//  AZSimpleView.m
//  AtoZ
//
//  Created by Alex Gray on 7/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZSimpleView.h"

@implementation AZSimpleView

- (id)initWithFrame:(NSRect)frame
{
 	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[NSColor blueColor]];
	}
	return self;
}

-(void)	setFrameSizePinnedToTopLeft: (NSSize)siz
{
	NSRect		theBox = [self frame];
	NSPoint		topLeft = theBox.origin;
	topLeft.y += theBox.size.height;

	[[self superview] setNeedsDisplayInRect: theBox];	// Inval old box.

	theBox.size = siz;
	topLeft.y -= siz.height;
	theBox.origin = topLeft;
	[self setFrame: theBox];
	[self setNeedsDisplay: YES];
}


- (void)drawRect:(NSRect)rect {
    [[self backgroundColor] set];
    NSRectFill(rect);
}


@end
