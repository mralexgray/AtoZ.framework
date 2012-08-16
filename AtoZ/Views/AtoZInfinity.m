//
//  AtoZInfinity.m
//  AtoZ
//
//  Created by Alex Gray on 7/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZInfinity.h"

@implementation InfiniteDocumentView
@end

@implementation NSClipView (InfinityAdditions)
//- (BOOL)isFlipped {
//	return ([[self documentView] isKindOfClass:[InfiniteDocumentView class]] ? YES : NO);
//}

@end

@implementation AtoZInfinity
{
	NSImage* bar;
	NSImage *snap;
	BOOL visible;
	BOOL hovered;
	float offset;
	BOOL scrollUp;
	NSIndexSet *screenSet;
//	NSTrackingArea *tArea;
}

@synthesize  unit =_unit, scale =_scale, orientation=_orientation, infiniteObjects = _infiniteViews, docV = _docV;

- (void) awakeFromNib {
	offset = 0;
	_orientation = AZOrientLeft;
	_scale = AZInfiteScale0X;
	[self 				setPostsFrameChangedNotifications:	YES];
	[[self contentView] setPostsBoundsChangedNotifications:	YES];
	[[self contentView] trackFullView];
	self.docV = [InfiniteDocumentView new];
	[self setDocumentView:self.docV];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter] ;
    [center addObserver: self
			   selector: @selector(boundsDidChangeNotification:)
				   name: NSViewBoundsDidChangeNotification
				 object: [self contentView]];
//	[[NSNotificationCenter defaultCenter] 	addObserver: self 			selector:@selector(scrollDown:) name:@"scrollRequested" 	object:nil];
	//	self.anApi = [[AJSiTunesAPI alloc] init];
	//	self.anApi.delegate = self;
}

- (void) setInfiniteObjects:(NSArray *)infiniteObjects
{
	_infiniteViews = infiniteObjects.reversed;
	[self setupInfiniBar];
}

-(void) viewDidEndLiveResize {
	[self setupInfiniBar];

}
-(void) setScale:(AZInfiteScale)scale
{
	_scale = scale;
	NSLog(@"scale=%i", scale);
	[self setupInfiniBar];
}

- (void) setupInfiniBar {
//	if (0) {
	if (_imageViewBar) {  [_imageViewBar fadeOut]; [_imageViewBar removeFromSuperview]; self.imageViewBar = nil; }
	[[self documentView]removeTrackingArea:_trackingArea];
	self.trackingArea = nil;
	NSLog(@"Views set.  number of views to use and reuse: %ld", _infiniteViews.count);

	if ((_orientation == AZOrientLeft) || (_orientation == AZOrientRight)) {
		switch (_scale) {
			case AZInfiteScale0X:
				self.barUnit = AZMakeRectFromSize(NSMakeSize(self.contentView.frame.size.width,
														self.contentView.frame.size.width));
				self.totalBar = NSMakeSize(	_barUnit.size.width,
										_barUnit.size.height * _infiniteViews.count);
				break;
			case AZInfiteScale1X:
				self.totalBar = self.contentView.frame.size;
				self.barUnit = AZMakeRectFromSize(NSMakeSize(_totalBar.width,
														_totalBar.height / _infiniteViews.count));
				break;
			case AZInfiteScale2X:
				self.totalBar = NSMakeSize(	self.contentView.frame.size.width,
										self.contentView.frame.size.height * 2);
				self.barUnit = AZMakeRectFromSize(NSMakeSize(_totalBar.width,
														_totalBar.height / _infiniteViews.count));
				break;
			case AZInfiteScale3X:
				self.totalBar = NSMakeSize(	self.contentView.frame.size.width,
										self.contentView.frame.size.height * 3);
				self.barUnit = AZMakeRectFromSize(NSMakeSize(_totalBar.width,
														_totalBar.height / _infiniteViews.count));
				break;
			default:
				self.totalBar = NSMakeSize(	self.contentView.frame.size.width, self.contentView.frame.size.height * 10);
				self.barUnit = AZMakeRectFromSize(NSMakeSize(_totalBar.width,
														_totalBar.height / _infiniteViews.count));
				break;
		}

	} else {
		self.barUnit = AZSquareFromLength(self.contentView.frame.size.height);
		self.totalBar = NSMakeSize(_barUnit.size.width * _infiniteViews.count,
						self.contentView.frame.size.height );
	}
	self.totalBarFrame = AZMakeRectFromSize(_totalBar);
	NSLog(@"taking opicture, it lasts longer!");
	bar = [[NSImage alloc]initWithSize:_totalBar];
	[bar lockFocus];
	[_infiniteViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSColor *color = [obj valueForKey:@"color"];
		if (!color) color = RANDOMCOLOR;
		[color set];  NSRect tempRect = _barUnit;
		if ((_orientation == AZOrientLeft) || (_orientation == AZOrientRight))
			tempRect.origin.y += idx * _barUnit.size.height;
		else tempRect.origin.x += idx * _barUnit.size.width;
		NSRectFill(tempRect);
	}];
	[bar unlockFocus];
	[bar saveAs:@"/Users/localadmin/Desktop/bar.png"];
	NSImageView* anImageViewBar = [[NSImageView alloc]initWithFrame:_totalBarFrame];
	anImageViewBar.image = bar;
	[[self documentView]setFrame:_totalBarFrame];
	self.imageViewBar = anImageViewBar;
	[[self documentView]addSubview:_imageViewBar];
	[_imageViewBar fadeIn];
	self.trackingArea = [_imageViewBar trackFullView];
	[[self documentView]addTrackingArea:_trackingArea];
}


-(void) mouseMoved:(NSEvent *)theEvent {


	[self evalMouse:[self.documentView convertPoint:theEvent.locationInWindow fromView:nil]];

//	NSPoint mouse = mouseLoc();
//	aRect.origin = [_documentView convertPoint:aPoint fromView:nil];
//	NSRect rect=[self documentVisibleRect];
//	CGFloat x=rect.origin.x;
//	CGFloat y=rect.origin.y;
}

- (void) boundsDidChangeNotification: (NSNotification *) notification
{
//	[self setNeedsDisplay: YES];
	// or whatever work you need to do
	NSPoint local = [[self window] convertScreenToBase:mouseLoc()];

	[self evalMouse:[self.documentView convertPoint:local	 fromView:nil]];
} // boundsDidChangeNotification

-(void) evalMouse:(NSPoint)thePoint {

	NSLog(@"entered infinity.. point in doc: %ld",  (NSUInteger)(thePoint.y / _barUnit.size.height));
}
//- (NSRect)adjustScroll:(NSRect)proposedVisibleRect{
//}
/** Overridden by subclasses to modify proposedVisibleRect,returning the altered rectangle. NSClipView invokes this method to allow its document view to adjust its position during scrolling. For example, a custom view object that displays a table of data can adjust the origin of proposedVisibleRect so rows or columns arentcut off by the edge of the enclosing N S ClipView. NSViews implementation simply returnsproposedVisibleRect.

NSClipView only invokes this method during automatic or user controlled scrolling. Its scrollToPoint: method~ doesnt invoke this method, so you can still force a scroll to an arbitrary point.*/

//		for (id sv in _infiniteViews ) {
//			[[self documentView] addSubview: sv];	//	[self setNeedsDisplay:NO];
//		}
//		[self stack];
//	} else {
	/*	snap = [[NSImage alloc]initWithSize:AZScaleRect([[self contentView] frame], 3).size];
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

	}*/

//- (void)setScale:(AZInfiteScale)aScale {	_scale = aScale;	[self stack]; 	}

//- (void)setOrientation:(AZOrient)anOrientation{		_orientation = anOrientation;	[self stack];	}
/**
- (NSRect) unit {
	NSSize 	cSize = [self frame].size;
	switch (_orientation) {
		case AZOrientTop:// | AZOrientBottom:
			cSize.width = cSize.width / _infiniteViews.count ;
			cSize.width = cSize.width * _scale;
			break;
		case AZOrientLeft:// | AZOrientRight:
			cSize.height = cSize.height / _infiniteViews.count;
			cSize.height = cSize.height * _scale;
			break;
	}
	_unit = AZMakeRect(NSZeroPoint, cSize);
	return _unit;
}
()*/
-(BOOL)isOpaque { return YES; }


//-(void) setScale:(AZInfiteScale)scale {
//
////	NSPoint oldCenter = NSPointFromCGPoint(CGPointMake(oldVisibleRect.origin.x +
//
//	NSSize totalBar;  NSRect barUnit;
//	if ((_orientation == AZOrientLeft) || (_orientation == AZOrientRight)) {
//		totalBar = NSMakeSize(self.contentView.frame.size.width, self.contentView.frame.size.width * _infiniteViews.count);
//		barUnit = AZSquareFromLength(self.contentView.frame.size.width);
//	} else {
//		totalBar = NSMakeSize(self.contentView.frame.size.height * _infiniteViews.count, self.contentView.frame.size.height);
//		barUnit = AZSquareFromLength(self.contentView.frame.size.height);
//	}
//	NSRect totalBarFrame = AZMakeRectFromSize(totalBar);
//
//	switch (scale) {
//		case AZInfiteScale0X:
//			[[self documentView]setFrame:totalBarFrame];
//			break;
//		case AZInfiteScale2X: {
//			NSRect xtwo =  [self documentVisibleRect];
//			if ((_orientation == AZOrientLeft) || (_orientation == AZOrientRight)) {
//				xtwo.size.height = xtwo.size.height *2;
//				[[self documentView]setFrame:totalBarFrame];
//			} else {
//				xtwo.size.width = xtwo.size.width *2;
//				[[self documentView]setFrame:totalBarFrame];
//			}
//		}
//		break;
//
//		default:
//			break;
//	}
//
//}
//- (void) scrollWheel:(NSEvent *)event {

////	NSRect frameNow = [self documentVisibleRect];
	// instead of this:
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
	/////NSRect flexUnit = self.unit;
/**	if ( scrollUp ) {
		[_infiniteViews moveObjectAtIndex:_infiniteViews.count-1 toIndex:0];
		switch (_orientation) {
			case AZOrientTop | AZOrientBottom:
				flexUnit.origin = NSZeroPoint;
				flexUnit.origin.x -= flexUnit.size.width;
				[[_infiniteViews objectAtIndex:0] setFrame:flexUnit];
				flexUnit.origin.x += flexUnit.size.width;
				[[_infiniteViews objectAtIndex:0] setFrame:flexUnit];
				break;
			case AZOrientLeft | AZOrientRight:
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
	
	switch (_orientation) {
		case AZOrientTop:
		case AZOrientBottom:
			flexUnit.origin = NSMakePoint(0, NSMaxX([self bounds]));
			[c setFrame:flexUnit];
			flexUnit.origin.x -= flexUnit.size.width;
			[c setFrame:flexUnit];
			[_infiniteViews addObject:c];
			break;
		case AZOrientLeft:
		case AZOrientRight:
			flexUnit.origin = NSMakePoint(0, NSMaxY([self bounds]));
			[c setFrame:flexUnit];
			flexUnit.origin.y -= flexUnit.size.height;
			[c setFrame:flexUnit];
			[_infiniteViews addObject:c];
			break;
		}
	}
	[self stack];
*/
//}

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
/*
- (void) stack {

	//	if ([self inLiveResize]) return;
	__block NSRect localunit = self.unit;// = [[self contentView]frame];
	//	chopped.size.height = chopped.size.height / _infiniteViews.count;
	//	chopped.origin = NSZeroPoint;
	[NSThread performBlockInBackground:^{

		[_infiniteViews enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(AZInfiniteCell* obj, NSUInteger idx, BOOL *stop) {

			NSRect pile = localunit;
			switch (_orientation) {
				case AZOrientTop:
				case AZOrientBottom:
					pile.origin.x = idx * localunit.size.width;
				break;
				default:
					pile.origin.y = idx * localunit.size.height;
				break;
			}
			[obj setFrame: pile];
			[obj setNeedsDisplay:NO];
		}];
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
*/
//	[self setNeedsDisplay:YES];

	
//}

/**
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

	// draw drop shadow
//	[NSGraphicsContext saveGraphicsState];
//	[dropShadow set];
//	[path fill];
//	[NSGraphicsContext restoreGraphicsState];

	// draw the gradient fill
//	NSGradient *gradient =  //self.isHighlighted ? pressedGradient;// : normalGradient;
//	[gradient drawInBezierPath:path angle:-90];

	// draw the inner stroke
	[strokeColor setStroke];
	[path strokeInside];

//	if (self.isHighlighted) {
		// pressed button gets two inner shadows for depth
		[path fillWithInnerShadow:innerShadow1];
		[path fillWithInnerShadow:innerShadow2];
//	}
}
*/

@end
