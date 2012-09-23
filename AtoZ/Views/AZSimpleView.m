
//  AZSimpleView.m
//  AtoZ

//  Created by Alex Gray on 7/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "AZSimpleView.h"
#import "AtoZ.h"

@implementation AZSimpleView
@synthesize glossy, backgroundColor, checkerboard, gradient;


//- (BOOL)isOpaque
//{
//	return NO;
//}

- (id)initWithFrame:(NSRect)frame
{
 	if (self = [super initWithFrame:frame]) {
		[self setBackgroundColor:[NSColor colorWithCalibratedRed:0.532 green:0.625 blue:0.550 alpha:1.000]];
		glossy = NO;
		checkerboard = NO;
		self.clear = NO;
		
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

	if (glossy) {
		DrawGlossGradient([[NSGraphicsContext currentContext]graphicsPort],self.backgroundColor, [self bounds]);
		return;
	}
	else if (gradient) {
		NSBezierPath *p =[NSBezierPath bezierPathWithRect: [self bounds]];// cornerRadius:0];
		[p fillGradientFrom:backgroundColor.darker.darker.darker to:backgroundColor.brighter.brighter angle:270];
		return;
	}
	else if (checkerboard)	[[NSColor checkerboardWithFirstColor:backgroundColor
												 secondColor:backgroundColor.contrastingForegroundColor squareWidth:10]set];
	else [_clear ? CLEAR :  backgroundColor ? backgroundColor : RANDOMCOLOR set];
	NSRectFill( [self bounds] );

//		[[NSColor colorWithCalibratedRed:0.f green:0.5f blue:0.f alpha:0.5f] set];
//		[[NSGraphicsContext currentContext]
//		 setCompositingOperation:NSCompositeClear];
//		[[NSBezierPath bezierPathWithRect:rect] fill];
//	}
//	else	{	[self.backgroundColor ? self.backgroundColor : [NSColor clearColor]   set];		NSRectFill(rect);	}

}


@end
