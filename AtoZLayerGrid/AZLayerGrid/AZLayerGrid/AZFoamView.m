//
//  AZFoamView.m
//  AZLayerGrid
//
//  Created by Alex Gray on 7/24/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import "AZFoamView.h"

static inline double radians (double degrees) { return degrees * M_PI/180; }

@implementation AZFoamView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)drawRect:(NSRect)frameRect {
		NSGradient *gradient;
		NSColor *startColor;
		NSColor *endColor;
		NSBezierPath *path;
		
		[NSGraphicsContext saveGraphicsState];
		
		CGFloat height = frameRect.size.height - 1.0f;
		CGFloat width = frameRect.size.width - 1.0f;
		CGFloat pcp = 10.0f;
		CGFloat sh = 10.0f;     /* shelf Height */
		
		path = [NSBezierPath bezierPath];
		[path setLineJoinStyle:NSRoundLineJoinStyle];
		[path moveToPoint:NSMakePoint(0.0f, sh)];
		[path lineToPoint:NSMakePoint(width, sh)];
		[path lineToPoint:NSMakePoint(width - pcp, height)];
		[path lineToPoint:NSMakePoint(pcp, height)];
		[path fill];
		
		startColor = BLACK;
//		 [NSColor colorWithCalibratedRed:0.85f	green:0.66f blue:0.45f alpha:1.0f];
		endColor = GREY;///[NSColor colorWithCalibratedRed:0.78f	green:0.61f blue:0.42f alpha:1.0f];
		gradient = [[NSGradient alloc] initWithStartingColor:startColor
												 endingColor:endColor];
		[gradient drawInBezierPath:path angle:90.0f];


		path = [NSBezierPath bezierPathWithRect:NSMakeRect(0.0f, 0.0f, width, sh)];
//		startColor =
		[WHITE set];
		[path stroke];
		
		 // [NSColor colorWithCalibratedRed:0.29f green:0.16f blue:0.04f alpha:1.0f];
//		endColor = [NSColor colorWithCalibratedRed:0.48f green:0.30f blue:0.16f alpha:1.0f];
		gradient = [[NSGradient alloc] initWithStartingColor:BLACK
												 endingColor:[BLACK brighter]];
		[gradient drawInBezierPath:path angle:90.0f];

		
		[NSGraphicsContext restoreGraphicsState];
	}

@end
