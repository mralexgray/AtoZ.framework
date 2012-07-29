//
//  ControlBar.m
//  AtoZStatusApp
//
//  Created by Alex Gray on 7/3/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "ControlBar.h"
#import <AtoZ/AtoZ.h>


@implementation ControlBar

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	[[self window] setBackgroundColor:ORANGE];
	MondoSwitch *a = [[MondoSwitch alloc]initWithFrame:NSMakeRect(10,10, 30,60)];
	[a setOn:NO];
	[self addSubview: a];
	 
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[CLEAR set];
	NSRectFill(dirtyRect);
	NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:20 inCorners:OSBottomLeftCorner | OSBottomRightCorner];
	[p setClip];
	[NSGraphicsContext saveGraphicsState];
	NSGradient *gradient = [[NSGradient alloc]initWithStartingColor:[NSColor colorWithCalibratedWhite:0.506 alpha: 1.0] endingColor:[NSColor colorWithCalibratedWhite:0.376 alpha:1.0]];
	[gradient drawInBezierPath:p angle:90];
	[NSGraphicsContext restoreGraphicsState];
}

@end
