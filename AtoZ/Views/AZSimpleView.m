
//  AZSimpleView.m
//  AtoZ

//  Created by Alex Gray on 7/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZSimpleView.h"
#import "AtoZ.h"

@implementation AZSimpleView

+(instancetype)withFrame:(NSRect)frame color:(NSC*)c;
{
	AZSimpleView *u;
	return u = [AZSimpleView.alloc initWithFrame:frame] ? u.backgroundColor = c, u : nil;
}
- (id)initWithFrame:(NSRect)frame
{
 	return self = [super initWithFrame:frame] ?
	_backgroundColor  = RANDOMGRAY, // [NSColor colorWithCalibratedRed:0.532 green:0.625 blue:0.550 alpha:1.000]],
	_glossy 	= NO,
	_checkerboard = NO,
	_clear = NO, self : nil;
}

-(void)	setFrameSizePinnedToTopLeft: (NSSize)siz	{

	NSR	theBox 	= self.frame;
	NSP	topLeft 	= theBox.origin;
	topLeft.y 	  += theBox.size.height;
	[self.superview setNeedsDisplayInRect: theBox];	// Inval old box.
	theBox.size 	= siz;
	topLeft.y 	  -= siz.height;
	theBox.origin 	= topLeft;
	[self setFrame:     theBox];
	[self setNeedsDisplay: YES];
}

- (void)drawRect:(NSRect)rect {

	if (_glossy) {
//		DrawGlossGradient([AZGRAPHICSCTXgraphicsPort],self.backgroundColor, [self bounds]);
		return;
	}
	else if (_gradient) {
		NSBezierPath *p =[NSBezierPath bezierPathWithRect: [self bounds]];// cornerRadius:0];
		[p fillGradientFrom:_backgroundColor.darker.darker.darker to:_backgroundColor.brighter.brighter angle:270];
		return;
	}
	else if (_checkerboard)	[[NSColor checkerboardWithFirstColor:_backgroundColor
												 secondColor:_backgroundColor.contrastingForegroundColor squareWidth:10]set];
	else [_clear ? CLEAR :  _backgroundColor ? _backgroundColor : RANDOMCOLOR set];
	NSRectFill( [self bounds] );

//		[[NSColor colorWithCalibratedRed:0.f green:0.5f blue:0.f alpha:0.5f] set];
//		[AZGRAPHICSCTX
//		 setCompositingOperation:NSCompositeClear];
//		[[NSBezierPath bezierPathWithRect:rect] fill];
//	}
//	else	{	[self.backgroundColor ? self.backgroundColor : [NSColor clearColor]   set];		NSRectFill(rect);	}

}
@end
@implementation AZSimpleGridView
@synthesize rows, columns, grid;

- (void)awakeFromNib {

	self.wantsLayer = YES;
	self.grid = self.layer;
	self.grid.backgroundColor = cgRANDOMCOLOR;
	self.grid.layoutManager = [CAConstraintLayoutManager layoutManager];

	[self setDimensions:(NSSize){8,8}];
}

-(void) setDimensions:(NSSize)dims {
	_dimensions = dims;
	rows = _dimensions.width; 	columns = _dimensions.height;

	for (int r = 0; r < rows; r++) {
		for (int c = 0; c < columns; c++) {
			CALayer *cell = [CALayer layer];
			cell.borderColor = cgGREY;
			cell.borderWidth = 1;
			cell.cornerRadius = 4;
			cell.name = [NSString stringWithFormat:@"%u@%u", c, r];
			cell.constraints = @[[CAConstraint constraintWithAttribute: kCAConstraintWidth
										relativeTo: @"superlayer"
										 attribute: kCAConstraintWidth
											 scale: 1.0 / columns  offset: 0],
			 [CAConstraint constraintWithAttribute: kCAConstraintHeight
										relativeTo: @"superlayer"
										 attribute: kCAConstraintHeight
											 scale: 1.0 / rows   offset: 0],
			 [CAConstraint constraintWithAttribute: kCAConstraintMinX
										relativeTo: @"superlayer"
										 attribute: kCAConstraintMaxX
											 scale: c / (float)columns   offset: 0],
			 [CAConstraint constraintWithAttribute: kCAConstraintMinY
										relativeTo: @"superlayer"
										 attribute: kCAConstraintMaxY
											 scale: r / (float)rows	offset: 0]];
			[grid addSublayer:cell];
		}
	}
}

@end
