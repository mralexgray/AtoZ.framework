
#import "AZQuadLayer.h"

@interface  AZQuadLayerView ()
@property (nonatomic, retain) CALayer *root;
@property (nonatomic, retain) CALayer *selectionLayer;
@property (nonatomic, retain) CALayer *lasstSelectedLayer;
@end

@implementation AZQuadLayerView
{
	BOOL		draggedDuringThisClick;
	CGPoint		dragStart;
	float		angleX, angleY, deltaX, deltaY;
}

-(void) awakeFromNib {

		//	CALayer* rootLayer = [CALayer layer];
	self.contentLayer = [CALayer layer];
	_contentLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		//	root.name = @"root";
//	CAGradientLayer *back = [self greyGradient];
//	[back setValue:[NSNumber numberWithBool:YES] forKey:@"locked"];
//	back.frame = self.bounds;
//	back.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
//	[_contentLayer addSublayer:back];
//	[con addSublayer:contentLayer];
	[self setLayer:_contentLayer];
	[self setWantsLayer:YES];
	[_contentLayer setDelegate:self];
	[_contentLayer setNeedsDisplay];

		//	[contentLayer setDelegate:self];
		//	[self setLayer:root];
		//	[self setWantsLayer:YES];

		//	root = [CALayer layer];
		//	contentLayer.position = CGPointZero;// [self center];

	/*	contentLayer.constraints = @[
	 AZConst( kCAConstraintWidth,@"superlayer"),
	 AZConst( kCAConstraintHeight,@"superlayer"),
	 AZConst( kCAConstraintMidX,@"superlayer"),
	 AZConst( kCAConstraintMidY,@"superlayer") ];
	 */

		//	layoutManager = MessedUpLayoutManager.new;
		//	[contentLayer setLayoutManager : layoutManager];
}
	//- (id)initWithFrame:(NSRect)frame
	//{
	//	self = [super initWithFrame:frame];
	//	if (self) {
	//
	//		}
	//
	//	return self;
	//}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{

	NSLog(@"delegate called");
	[_contentLayer.sublayers az_each:^(CALayer *obj, NSUInteger index, BOOL *stop) {
		NSLog(@"sublayer:%ld:  %@", index, obj.propertiesPlease);
			//	obj.frame = [[s.rects objectAtNormalizedIndex:index]rectValue];
			//			obj.layoutManager = [CAConstraintLayoutManager layoutManager];
			//			if (index == 0 )	{
			//				obj.name = @"R0C0";
			//				[obj addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
			//																	 relativeTo:@"root"
			//																	  attribute:kCAConstraintMinX]];
			//	[contentLayer  addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY
			//												  relativeTo:@"superlayer"
			//												   attribute:kCAConstraintMinY]];
	}];

}

-(CALayer*) selectionLayerForLayer:(CALayer*)layer {

	CALayer *aselectionLayer = [CALayer layer];
		//		selectionLayer.bounds = CGRectMake (0.0,0.0,width,height);
	aselectionLayer.borderWidth = 4.0;
	aselectionLayer.cornerRadius = layer.cornerRadius;
	aselectionLayer.borderColor= cgWHITE;

	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
	[filter setDefaults];
	[filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputRadius"];
	[filter setName:@"pulseFilter"];
	[aselectionLayer setFilters:[NSArray arrayWithObject:filter]];

		// The selectionLayer shows a subtle pulse as it is displayed. This section of the code create the pulse animation setting the filters.pulsefilter.inputintensity to range from 0 to 2. This will happen every second, autoreverse, and repeat forever
	CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
	pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
	pulseAnimation.fromValue = [NSNumber numberWithFloat: 0.0f];
	pulseAnimation.toValue = [NSNumber numberWithFloat: 2.0f];
	pulseAnimation.duration = 1.0;
	pulseAnimation.repeatCount = HUGE_VALF;
	pulseAnimation.autoreverses = YES;
	pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:
									 kCAMediaTimingFunctionEaseInEaseOut];
	[aselectionLayer addAnimation:pulseAnimation forKey:@"pulseAnimation"];
	NSArray *constraints = @[ 	AZConstRelSuper( kCAConstraintWidth),
								AZConstRelSuper( kCAConstraintHeight),
								AZConstRelSuper( kCAConstraintMidX),
								AZConstRelSuper( kCAConstraintMidY)];
	aselectionLayer.constraints = constraints;

		//		// set the first item as selected
		//		[self changeSelectedIndex:0];
		//
		//		// finally, the selection layer is added to the root layer
		//		[rootLayer addSublayer:self.selectionLayer];
	return aselectionLayer;
}

- (CAShapeLayer*) lassoLayerForLayer:(CALayer*)layer {

	NSLog(@"Clicked: %@", [[layer valueForKey:@"azfile"] propertiesPlease] );
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
	[shapeLayer setValue:layer forKey:@"mommy"];
		//	float total = 	( (2*contentLayer.bounds.size.width) + (2*contentLayer.bounds.size.height) - (( 8 - ((2 * pi) * contentLayer.cornerRadius))));
	CGRect shapeRect = layer.bounds;

	[shapeLayer setBounds:shapeRect];
		//	[shapeLayer setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
	NSArray *constraints = @[
							AZConstScaleOff( kCAConstraintMinX,@"superlayer", 1,2),
							AZConstScaleOff( kCAConstraintMaxX,@"superlayer", 1,2),
							AZConstScaleOff( kCAConstraintMinY,@"superlayer", 1,2),
							AZConstScaleOff( kCAConstraintMaxY,@"superlayer", 1,2),
							AZConstScaleOff( kCAConstraintWidth,@"superlayer", 1,-4),
							AZConstScaleOff( kCAConstraintHeight,@"superlayer", 1, -4),
							AZConstRelSuper( kCAConstraintMidX),
							AZConstRelSuper(kCAConstraintMidY)];
	shapeLayer.constraints = constraints;
		//	[shapeLayer setPosition:CGPointMake(.5,.5)];
	[shapeLayer setFillColor:cgCLEARCOLOR];
	[shapeLayer setStrokeColor: [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
	[shapeLayer setLineWidth:4];
	[shapeLayer setLineJoin:kCALineJoinRound];
	[shapeLayer setLineDashPattern:@[ @(10), @(5)]];
		//	 [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
		//	  [NSNumber numberWithInt:5],
		//	  nil]];
		// Setup the path
	shapeRect.size.width -= 4;
	shapeRect.size.height -= 4;
	NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:NSRectFromCGRect(shapeRect) cornerRadius:layer.cornerRadius];

		//	CGMutablePathRef path = CGPathCreateMutable();
		//	CGPathAddRect(path, NULL, shapeRect);
		//	[shapeLayer setPath:path];
		//	CGPathRelease(path);
	[shapeLayer setPath:[p quartzPath]];
	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
	[dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
	[dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
	[dashAnimation setDuration:0.75f];
	[dashAnimation setRepeatCount:10000];

	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];

		//	float total = (((2* NSMaxX(contentLayer.frame)) + (2 * NSMaxY(box.frame)))/16);
		//	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
		//	dashAnimation.fromValue 	= $float(0.0f);	dashAnimation.toValue 	= $float
		//	(total);
		//
		//	dashAnimation.duration	= 3;				dashAnimation.repeatCount = 10000;
		//	//	dashAnimation.beginTime = CACurrentMediaTime();// + 2;
		//	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
		//	shapeLayer.fillColor 		= cgRED;
		//	shapeLayer.strokeColor		= cgBLACK;
		//	shapeLayer.lineJoin			= kCALineJoinMiter;
		//	shapeLayer.lineDashPattern 	= $array( $int(total/8), $int(total/8));
		//
		//	//			srelectedBox.shapeLayer.lineDashPattern 	= $array( $int(15), $int(45));
		//	shapeLayer.lineWidth = 5;
		//	[shapeLayer setPath:[[NSBezierPath bezierPathWithRoundedRect:contentLayer.bounds cornerRadius:contentLayer.cornerRadius ] quartzPath]];
 	return shapeLayer;
}

- (void) redrawPath {
	CALayer *selected = [_lassoLayer valueForKey:@"mommy"];
	CGRect shapeRect = selected.bounds;
	shapeRect.size.width -= 4;
	shapeRect.size.height -= 4;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathAddRect(path, NULL, shapeRect);
	[_lassoLayer setPath:path];
	CGPathRelease(path);
	[_contentLayer setNeedsDisplay];

}
- (void)drawRect:(NSRect)dirtyRect
{
	if (_lassoLayer) {
		[_lassoLayer removeFromSuperlayer];
		self.lassoLayer = [self lassoLayerForLayer:_clickedLayer];
		[self.clickedLayer addSublayer:_lassoLayer];
	}
	[_contentLayer setNeedsDisplay];
}

- (CALayer*) hitTestPoint: (NSPoint)locationInWindow offset: (CGPoint*)outOffset
{ // I copied this from other sources, I didn't create them
	CGPoint where = NSPointToCGPoint([self convertPoint: locationInWindow fromView: nil]);
	where = [self.layer convertPoint: where fromLayer: self.layer];
	CALayer *layer = [self.layer hitTest: where];
	if ( layer != self.layer ){
		CGPoint bitPos = [self.layer convertPoint: layer.position
										fromLayer: layer.superlayer];
		if( outOffset )
			*outOffset = CGPointMake( bitPos.x-where.x, bitPos.y-where.y);
		return layer;
	}
	else
		return nil;
}

	//CGRect SKTRectFromPoints(NSPoint point1, CGPoint point2) { // I copied this from other sources, I didn't create them
	//	return NSRectToCGRect(NSMakeRect(((point1.x <= point2.x) ? point1.x : point2.x),
	//									 ((point1.y <= point2.y) ? point1.y : point2.y),
	//									 ((point1.x <= point2.x) ? point2.x - point1.x : point1.x - point2.x),
	//									 ((point1.y <= point2.y) ? point2.y - point1.y : point1.y - point2.y)));
	//}

/*
 - (void)orientWithX:(float)x andY:(float)y {
 CATransform3D transform = CATransform3DMakeRotation(x, 0, 1, 0);
 transform = CATransform3DRotate(transform, y, 0, 1, 0);
 //	transform = CATransform3DMakeTranslation(x, 0, x);// (transform, 0, 1, 0);
 //	float zDistance = -500;
 //	transform.m34 = 1.0 / -zDistance;
 contentLayer.sublayerTransform = transform;
 //	contentLayer.sublayerTransform = CATransform3DMakePerspective(x/100, 0);//0.002
 }
 - (void)mouseDragged:(NSEvent *)theEvent {
 // Get view coordinates
 CGPoint point = NSPointToCGPoint([self convertPoint:theEvent.locationInWindow fromView:nil]);
 draggedDuringThisClick = true;

 deltaX = (point.x - dragStart.x)/200;
 deltaY = -(point.y - dragStart.y)/200;
 [self orientWithX:(angleX+deltaX) andY:(angleY+deltaY)];
 }	*/
- (void)mouseDown:(NSEvent *)theEvent{
		// Getting clicked point.
	NSPoint mousePointInView = [self convertPoint:theEvent.locationInWindow fromView:nil];
	mousePointInView = [self.layer convertPoint:mousePointInView toLayer:self.layer];
	mouseDownPoint = mousePointInView;
		// Checking if a tab was clicked.
	self.clickedLayer = [self.layer hitTest:mousePointInView];

		//	//		previouslyDraggedLayer = draggingLayer;
		//	CALayer *draggingLayer = [self.layer hitTestPoint: dragStartPos offset:nil];// &dragOffset]; // this tells me what i'm clicking on, if anything
		//	NSLog(@"Hit %@", draggingLayer);
	if ( [_clickedLayer superlayer] == self.layer) self.clickedLayer = [[_clickedLayer sublayers]objectAtIndex:0];
	if ( [[_clickedLayer superlayer] valueForKey:@"isTile"]) self.clickedLayer = [_clickedLayer superlayer];
	_lasstSelectedLayer.zPosition = 0;
	self.lasstSelectedLayer = _clickedLayer;
	_clickedLayer.zPosition = 1000;
	[_selectionLayer removeFromSuperlayer];
	self.selectionLayer = [self selectionLayerForLayer:_clickedLayer];
	[self.clickedLayer addSublayer:_selectionLayer];
	[self.lassoLayer removeFromSuperlayer];
	self.lassoLayer = [self lassoLayerForLayer: _clickedLayer];
	[_clickedLayer addSublayer: _lassoLayer];

	NSLog(@"dragging frame:%@  selection frame: %@", NSStringFromRect(_clickedLayer.frame), NSStringFromRect(_selectionLayer.frame));
		// we use an additional layer, selectionLayer
		// to indicate that the current item is selected

	draggedDuringThisClick = false;
		// Get view coordinates
	dragStart = NSPointToCGPoint([self convertPoint:theEvent.locationInWindow fromView:nil]);

		//	if ( draggingLayer ){ // make the layer highlight in some way. I put a border around it
		//		draggingLayer.zPosition = 100;
		//		draggingLayer.shadowOffset = CGSizeMake(3, -3);
		//		draggingLayer.shadowOpacity = 0.7;
		//		draggingLayer.borderWidth = 2.0;
		//		draggingLayer.borderColor = CGColorCreateGenericRGB(0,0,1,1);
		//	} else { // I have hit nothing, let's make a selection rectangle
		//		CGPoint curPoint;
		//		dragStartPos = [self convertPoint:dragStartPos fromView:nil];
		//
		//		if ( !dragRectangle ){ // I tried to set this up in initWithFrame but half the time it didn't show up. This is more "lazy" anyway, setting it up
		//							   // when you need it makes the app launch a litle faster anyway
		//			dragRectangle = CALayer.new;
		//			[dragRectangle retain]; // with garbage collection, I probably don't need this, but better to have it
		//			[self.layer addSublayer:dragRectangle];
		//		}
		//		previouslyDraggedLayer.borderWidth = 0;
		//
		//		[CATransaction flush]; // standard "don't animate what I'm about to do stuff
		//		[CATransaction begin];
		//		[CATransaction setValue:(id)kCFBooleanTrue
		//						 forKey:kCATransactionDisableActions];
		//
		//		dragRectangle.backgroundColor = CGColorCreateGenericRGB(.7,.8,.9,.5); // as close as I can come to Apple's colors
		//		dragRectangle.borderWidth = 1;
		//		dragRectangle.borderColor = CGColorCreateGenericRGB(.1,.2,1,.5);
		//		dragRectangle.zPosition = 100;
		//		dragRectangle.position = NSPointToCGPoint(dragStartPos);
		//		dragRectangle.hidden = NO;
		//		dragRectangle.frame = CGRectMake(0,0,1,1); // make a tiny thing to start
		//		[CATransaction commit];
		//
		//		while ([ev type] != NSLeftMouseUp) { // and then do it until I release the mouse.
		//											 //NSLog (@"trying to drag");
		//			ev = [[self window] nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		//			curPoint = NSPointToCGPoint([self convertPoint:[ev locationInWindow] fromView:nil]); // I'm in a scroll view, so get where I really am
		//			[CATransaction flush];
		//			[CATransaction begin];
		//			[CATransaction setValue:(id)kCFBooleanTrue
		//							 forKey:kCATransactionDisableActions];
		//			dragRectangle.frame = SKTRectFromPoints(dragStartPos, curPoint); // and finally make the rectangle
		//			[CATransaction commit];
		//
		//			// here's where you'll put your code to see if you actually hit something
		//		}
		//		dragRectangle.hidden = YES; // the mouse has been released, hide the rectangle
		//	}

}

-(void) viewDidEndLiveResize {
	[self redrawPath];
}
-(void) viewWillDraw
{
	[self redrawPath];
}

	//Metallic grey gradient background
- (CAGradientLayer*) greyGradient {
	NSArray *colors =  $array(
							  (id)[[NSColor colorWithDeviceWhite:0.15f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.19f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.20f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.25f alpha:1.0f] CGColor]);
	NSArray *locations = $array($float(0),$float(.5), $float(.5), $float(1));
	CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	return headerLayer;
	
}

@end
