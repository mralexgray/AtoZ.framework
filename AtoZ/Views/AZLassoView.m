
//  AZSoftButton.m
//  AtoZ

//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZLassoView.h"

@implementation AZLassoView
{
	float mPhase;  				float all;			NSTimer *timer;
}
@synthesize dynamicStroke;
@synthesize inset = _inset,
			radius = _radius,
			hovered = _hovered,
			selected = _selected,
						nooseMode = _nooseMode,
			representedObject = _representedObject;
@synthesize uniqueID;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.uniqueID = [NSString newUniqueIdentifier];

		_hovered = NO;
		_selected = NO;
		_radius = 0;
		_inset = 0;
		_nooseMode = NO;
//		[self updateTrackingAreas];
    }
    return self;
}
- (void)handleAntAnimationTimer:(NSTimer*)timer {
	mPhase = (mPhase < [self halfwayWithInset] ? mPhase + [self halfwayWithInset]/128 : 0);
	[self setNeedsDisplayInRect:NSInsetRect(self.bounds, self.inset, self.inset)];
}
- (float) dynamicStroke {
	//	NSBezierPath *bez = [self pathWithInset:self.inset];
	//	if (bez.bounds) {
	//		NSLog(@"BEZ: %@", NSStringFromRect( bez.bounds));
	//		return (.1 * MIN((int)bez.bounds.size.width, (int)bez.bounds.size.height) );
	//	} else
	return (AZMaxDim([self bounds].size) * .1);
}
//- (void)updateTrackingAreas
//{
////	[super updateTrackingAreas];
//	if (trackingArea)
//		[self removeTrackingArea:trackingArea];

//	NSTrackingAreaOptions options = 
//		NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow;
//	trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect options:options owner:self userInfo:nil];
//	[self addTrackingArea:trackingArea];
//}
- (void)drawRect:(NSRect)dirtyRect
{
	NSBezierPath	*standard = [NSBezierPath bezierPathWithRoundedRect:
		NSInsetRect(self.bounds, self.inset, self.inset) xRadius:self.radius yRadius:self.radius];
	if(self.hovered) {
		[[WHITE colorWithAlphaComponent:.3] set];
		NSRectFillUsingOperation([self bounds], NSCompositePlusLighter);

		[standard fillGradientFrom:[WHITE colorWithAlphaComponent:.3]  to:[GRAY7 colorWithAlphaComponent:.2] angle:270];
	//		NSRectFillUsingOperation([self bounds], NSCompositeSourceOver);
	}
	if (self.selected)	{
		[standard setLineWidth:self.dynamicStroke/2];
		//		[standard setLineJoinStyle:NSBevelLineJoinStyle];
		[standard setLineCapStyle:NSButtLineCapStyle];//NSSquareLineCapStyle];//NSRoundLineCapStyle];//
		[WHITE set];
		[standard strokeInside];
		// strokeInsideWithinRect:NSInsetRect([self bounds], inset_*2, inset_*2)];
		// strokeInsideWithinRect:NSInsetRect([self bounds], inset_*2, inset_*2)];
		float slice = ([self halfwayWithInset]/32);

		CGFloat dashArray[2] = { slice, slice};
		[standard setLineDash:dashArray count:2 phase:mPhase];
		[BLACK set];
		[standard strokeInside];
		//WithinRect:NSInsetRect([self bounds], inset_*2, inset_*2)];

//		DrawLabelAtCenterPoint([representedObject_ valueForKey:@"name"], NSMakePoint(NSMidX(self.bounds),NSMidY(self.bounds)));
	}
//	else {
//		if (!color) color = RANDOMCOLOR;
//		[color set];
//		[standard setClip];
//		NSRectFill(NSZeroRect);
}

- (float) halfwayWithInset {
	NSRect dim = NSInsetRect(self.bounds, self.inset, self.inset);
	return ( (2*dim.size.width) + (2*dim.size.height) - (( 8 - ((2 * pi) * self.radius))));
}

- (void)setSelected:(BOOL)state {
	if (!state) [timer invalidate];
	else { mPhase = 0; timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handleAntAnimationTimer:) userInfo:nil repeats:YES];
	}
	_selected = state;
	[self setNeedsDisplay:YES];
}

- (void)setHovered:(BOOL)hovered {
	_hovered = hovered;
	[self setNeedsDisplay:YES];
}

//- (void)setInset:(float)inset {
//	inset_ = inset;
//	[self setNeedsDisplay:YES];
//}

//-(void) mouseEntered:(NSEvent *)theEvent {
//	NSBeep();
//	NSLog(@"Entered Lasso: %@ frame: %@", self.uniqueID, NSStringFromRect(self.frame));
//	self.hovered = YES;
////	[[[[self window]contentView]allSubviews]each:^(id obj, NSUInteger index, BOOL *stop) {
////		if ( ([obj isKindOfClass:[AZLassoView class]]) && ([obj isNotEqualTo:self]) )
////			[(AZLassoView*)obj setHovered:NO];
////	}];
//	[self setNeedsDisplay:YES];
//}

//- (void)mouseExited:(NSEvent *)event
//{
//	self.hovered = NO;
//}
//-(void) mouseDown:(NSEvent *)theEvent {
//	self.selected = YES;
//	[[[self superview]allSubviews]each:^(id obj, NSUInteger index, BOOL *stop) {
//		if ( ([obj isKindOfClass:[AZLassoView class]]) && ([[obj valueForKey:@"uniqueID" ] isNotEqualTo:self.uniqueID]) )
//			[(AZLassoView*)obj setSelected:NO];
//	}];
//}

@end
