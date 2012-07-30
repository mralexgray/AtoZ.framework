//
//  AtoZInfinity.m
//  AtoZ
//
//  Created by Alex Gray on 7/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZInfinity.h"

@implementation AtoZInfinity
{
	NSImage *snap;
	BOOL visible;
	BOOL hovered;
	float offset;
	BOOL scrollUp;
}
@synthesize 	infiniteViews = _infiniteViews, unit, scale, orientation;

- (void) awakeFromNib {
	offset = 0;
	orientation = AZOrientHorizontal;
	scale = AZInfiteScale1X;
	[self 				setPostsFrameChangedNotifications:	YES];
	[[self contentView] setPostsBoundsChangedNotifications:	YES];
	
	//	[[NSNotificationCenter defaultCenter] 	addObserver: self 			selector:@selector(scrollDown:) name:@"scrollRequested" 	object:nil];
	//	self.anApi = [[AJSiTunesAPI alloc] init];
	//	self.anApi.delegate = self;
}

- (void) setInfiniteViews:(NSArray *)infiniteViews {
	if (0) {
		_infiniteViews = infiniteViews.mutableCopy;
		NSLog(@"Views set.  number of views to use and reuse: %ld", _infiniteViews.count);
		for (id sv in _infiniteViews ) {
			[self.documentView addSubview: sv];	//	[self setNeedsDisplay:NO];
		}
		[self stack];
	} else {
		snap = [[NSImage alloc]initWithSize:AZScaleRect([[self contentView] frame], 3).size];
		__block NSRect localunit = self.unit;
		[snap lockFocus];
		[infiniteViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			NSRect pile = localunit;
			if (orientation == AZOrientHorizontal)
					pile.origin.x = idx * localunit.size.width;
			else	pile.origin.y = idx * localunit.size.height;
			NSLog(@"Snapping away");
//			[NSGraphicsContext saveGraphicsState];
//			[(NSColor*)[[obj valueForKey:@"file"] valueForKey:@"color"] set];
//			NSRectFill(pile);
			[[[NSImage systemImages]randomElement]drawAtPoint:NSZeroPoint fromRect:pile operation:NSCompositeSourceOver fraction:1];
//			[NSGraphicsContext restoreGraphicsState];
		}];
		[RANDOMCOLOR set];
		NSRectFill(NSZeroRect);
		[snap unlockFocus];
		[snap saveAs:@"/Users/localadmin/Desktop/whayeber.png"];
		NSLog(@"Saved %@", snap);

	}
}
- (void)setScale:(AZInfiteScale)aScale {
	scale = aScale;
	[self stack];
	
}

- (void)setOrientation:(AZOrient)anOrientation{
	orientation = anOrientation;
	[self stack];
}

- (NSRect) unit {
	NSSize 	cSize = [self frame].size;
	switch (orientation) {
		case AZOrientHorizontal:
			cSize.width = cSize.width / _infiniteViews.count ;
			cSize.width = cSize.width * scale;
			break;
		case AZOrientVertical:
			cSize.height = cSize.height / _infiniteViews.count;
			cSize.height = cSize.height * scale;
			
			break;
	}
	
	unit = AZMakeRect(NSZeroPoint, cSize);
	return unit;
}
-(BOOL)isOpaque { return YES; }

- (void) scrollWheel:(NSEvent *)event {
	//	if ([self inLiveResize]) return;
	//	if ( MAX(abs(event.deltaX), abs(event.deltaY)) < 10 ) return;
	//	else
	//	[self simulateScrollWithOffset:0 orEvent:event];
//	NSLog(@"offset: %f   raw event x:%f  y:%f", offset, event.deltaX, event.deltaY);
//	if (offset == 0) [self dealWith:event];
//}
//- (void) simulateScrollWithOffset:(float)f orEvent:(NSEvent*)event {
//	__block	float offset = 0;
//	offset = f;
//-(void) dealWith:(NSEvent*)event{
	//	NSLog(@"offset: %f   raw event x:%f  y:%f", offset, event.deltaX, event.deltaY);
	NSRect flexUnit = self.unit;
	if ( scrollUp ) {
		[_infiniteViews moveObjectAtIndex:_infiniteViews.count-1 toIndex:0];
		switch (orientation) {
			case AZOrientHorizontal:
				flexUnit.origin = NSZeroPoint;
				flexUnit.origin.x -= flexUnit.size.width;
				[[_infiniteViews objectAtIndex:0] setFrame:flexUnit];
				flexUnit.origin.x += flexUnit.size.width;
				[[_infiniteViews objectAtIndex:0] setFrame:flexUnit];
				break;
			case AZOrientVertical:
				flexUnit.origin = NSZeroPoint;
				flexUnit.origin.y -= flexUnit.size.height;
				[[_infiniteViews objectAtIndex:0] setFrame:flexUnit];
				flexUnit.origin.y += flexUnit.size.height;
				[[_infiniteViews objectAtIndex:0] setFrame:flexUnit];
				break;
		}
	} else  {

	id c = [_infiniteViews objectAtIndex:0];
	[_infiniteViews removeObjectAtIndex:0];
	
	switch (orientation) {
		case AZOrientHorizontal:
			flexUnit.origin = NSMakePoint(0, NSMaxX([self bounds]));
			[c setFrame:flexUnit];
			flexUnit.origin.x -= flexUnit.size.width;
			[c setFrame:flexUnit];
			[_infiniteViews addObject:c];
			break;
		case AZOrientVertical:
			flexUnit.origin = NSMakePoint(0, NSMaxY([self bounds]));
			[c setFrame:flexUnit];
			flexUnit.origin.y -= flexUnit.size.height;
			[c setFrame:flexUnit];
			[_infiniteViews addObject:c];
			break;
	}

/**	__block NSRect globalShift = self.unit;

	[_infiniteViews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (orientation == AZOrientHorizontal )
			globalShift.origin.x += offset; ( offset > 0 ? unit.size.width : - unit.size.width);
		else  globalShift.origin.y += ( event.deltaY > 0 ? unit.size.height : - unit.size.height);
		//				offset += event.deltaX;
		//globalShift.size.width;
		//				scrollUp = (event.deltaX > 0 ? NO : YES );
		//				NSLog(@"horizontal.. scrollup: %@", StringFromBOOL(scrollUp));
		
		//				globalShift.origin.x += ( scrollUp ? unit.size.width : - unit.size.width);
		//				break;
		//			case AZOrientVertical:
		//				offset = self.unit.size.height;
		//				scrollUp = (event.deltaY > 0 ? NO : YES );
		//				NSLog(@"vertical.. scrollup: %@", StringFromBOOL(scrollUp));
		//? offset : - offset);
		//				break;
		//		}
		//		[self setNeedsDisplay:NO];
		//		[obj setFrame:globalShift];
		[obj setNeedsDisplay:NO];
	}];
	
	//		moved.origin = NSMakePoint(0, NSMaxY([self frame]));
	//		[c setFrame:moved];
	//		moved.origin.y -= scooch;
	//		[c setFrame:moved];
	//		[_infiniteViews addObject:c];
*/
}
[self stack];
//offset = 0;
}

- (void) viewDidEndLiveResize {
	[self stack];
}
- (void) stack {
	//	if ([self inLiveResize]) return;
	__block NSRect localunit = self.unit;// = [[self contentView]frame];
	//	chopped.size.height = chopped.size.height / _infiniteViews.count;
	//	chopped.origin = NSZeroPoint;
	
	[_infiniteViews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		//		AZInfiniteCell *s = obj;
		NSRect pile = localunit;
		if (orientation == AZOrientHorizontal)
			pile.origin.x = idx * localunit.size.width;
		else
			pile.origin.y = idx * localunit.size.height;
		[obj setNeedsDisplay:NO];
		[obj setFrame: pile];
	}];

	[self addSubview: [AZBlockView viewWithFrame:[self bounds]  opaque:NO drawnUsingBlock: ^(AZBlockView *view, NSRect dirtyRect) {
		NSBezierPath *path = [NSBezierPath bezierPathWithRect:AZMakeRectFromSize(NSMakeSize(dirtyRect.size.width, dirtyRect.size.height *2))];

//		[RED set];
//		NSRectFill(dirtyRect);
//		innerShadow2 = [[NSShadow alloc] initWithColor:[NSColor colorWithCalibratedWhite:0.0 alpha:.52] offset:NSMakeSize(0.0, -2.0) blurRadius:8.0];
		[path fillWithInnerShadow:[[NSShadow alloc] initWithColor:[NSColor blackColor] offset:NSZeroSize blurRadius:15.0]];
//		[path fillWithInnerShadow:innerShadow2];

		}]];
//		positioned:NSWindowBelow relativeTo:infiniteBlocks];

//	recess:[self bounds] inView:[self contentView]];
	[self setNeedsDisplay:YES];
	
}


- (void)recess:(NSRect)frame inView:(id)controlView

//- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
	static NSGradient *pressedGradient = nil;
	static NSGradient *normalGradient = nil;
	static NSColor *strokeColor = nil;
	static NSShadow *dropShadow = nil;
	static NSShadow *innerShadow1 = nil;
	static NSShadow *innerShadow2 = nil;


	if (pressedGradient == nil) {
		pressedGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:.506 alpha:1.0]
														endingColor:[NSColor colorWithCalibratedWhite:.376 alpha:1.0]];
		normalGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:.67 alpha:1.0]
													   endingColor:[NSColor whiteColor]];

		dropShadow = [[NSShadow alloc] initWithColor:[NSColor colorWithCalibratedWhite:.863 alpha:.75]
											  offset:NSMakeSize(0, -1.0) blurRadius:1.0];
		innerShadow1 = [[NSShadow alloc] initWithColor:[NSColor blackColor] offset:NSZeroSize blurRadius:3.0];
		innerShadow2 = [[NSShadow alloc] initWithColor:[NSColor colorWithCalibratedWhite:0.0 alpha:.52]
												offset:NSMakeSize(0.0, -2.0) blurRadius:8.0];

		strokeColor = [NSColor colorWithCalibratedWhite:.26 alpha:1.0];
	}

	// adjust the drawing area by 1 point to account for the drop shadow
	NSRect rect = frame;
	rect.size.height -= 1;
	CGFloat radius = 3.5;

	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
/*
	// draw drop shadow
	[NSGraphicsContext saveGraphicsState];
	[dropShadow set];
	[path fill];
	[NSGraphicsContext restoreGraphicsState];

	// draw the gradient fill
//	NSGradient *gradient = /*self.isHighlighted ? pressedGradient;// : normalGradient;
	[gradient drawInBezierPath:path angle:-90];
*/
	// draw the inner stroke
	[strokeColor setStroke];
	[path strokeInside];

//	if (self.isHighlighted) {
		// pressed button gets two inner shadows for depth
		[path fillWithInnerShadow:innerShadow1];
		[path fillWithInnerShadow:innerShadow2];
//	}
}
@end
