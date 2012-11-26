#import "AZScrollerLayer.h"
#import "AtoZ.h"

#define BORDERWIDTH 0.0
#define ARROW_WIDTH 46.0

//#define ARROWCOLOR CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
//#define BORDERCOLOR CGColorCreateGenericRGB(1.0f,1.0f,1.0f,0.6f)
//#define SPACERCOLOR CGColorCreateGenericRGB(1.0f,1.0f,1.0f,0.235f)
#define ARROWCOLOR CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
#define BORDERCOLOR CGColorCreateGenericRGB(1.0f,1.0f,1.0f,0.6f)
#define SPACERCOLOR cgRED // CGColorCreateGenericRGB(1.0f,1.0f,1.0f,0.235f)

#define CORNER_RADIUS SCROLLER_HEIGHT// *1// 0.5

#define INNER_RADIUS 1//6

#define SLIDER_MIN_WIDTH INNER_RADIUS * 3

#define NS_BORDERCOLOR [RED set]; //;//[[NSColor colorWithCalibratedWhite:1.0 alpha:0.6] set];

@interface AZScrollerLayer (PrivateMethods)
- (void) createLeftArrow;
- (void) createRightArrow;
- (void) createScrollTray;
- (void) createSlider;

// Arrow Helper methods
- (void)setContentForArrowLayer:(CALayer*)arrowContent withArrow:(NSBezierPath*)arrowPath andBorder:(NSBezierPath*)borderPath;
- (NSBezierPath*) createArrowTriangleWithPt:(NSPoint)pt1 pt2:(NSPoint)pt2 pt3:(NSPoint)pt3;
- (NSBezierPath*) createArrowBorderPathWithPt:(NSPoint)pt1 pt2:(NSPoint)pt2 pt3:(NSPoint)pt3;
- (NSImage*)createArrowMaskImageForPt:(NSPoint)pt1 pt2:(NSPoint)pt2 pt3:(NSPoint)pt3 pt4:(NSPoint)pt4 pt5:(NSPoint)pt5;

// General Helper Methods
- (void)addMask:(NSImage*)maskImage toLayer:(CALayer*)layerToMask;
- (void)addContents:(NSImage*)contentsImage toLayer:(CALayer*)layer;
- (NSImage*)createGlassImageForSize:(NSSize)size;

// Slider Helper methods
- (void)setSliderWidth:(CGFloat)width;
- (void)setSliderPosition:(CGFloat)newX;
- (void)setSliderSideLayer:(CALayer*)layer contents:(NSImage*)image andPts:(NSPoint)pt1 pt2:(NSPoint)pt2 pt3:(NSPoint)pt3;

// Event handling
- (void)startMouseDownTimer;

@end

@implementation AZScrollerLayer

@synthesize scrollerContent=_scrollerContent;

- (id) init {
	if (!(self = [super init])) return nil;
	self.autoresizingMask = kCALayerWidthSizable;
	self.cornerRadius = CORNER_RADIUS;
	self.masksToBounds = YES;
//	self.borderWidth = BORDERWIDTH;
//	self.borderColor = BORDERCOLOR;
	self.frame = CGRectMake(0, 0, ARROW_WIDTH, SCROLLER_HEIGHT);
	[self setLayoutManager:[CAConstraintLayoutManager layoutManager]];

	[self addConstraints: @[AZConstRelSuper(kCAConstraintMidX), AZConstRelSuper(kCAConstraintWidth)]];

	[self createLeftArrow];
	[self createRightArrow];
	[self createScrollTray];
	self.sublayers = @[tray, leftArrow, rightArrow];
	return self;
}

- (void)layoutSublayers {
	[super layoutSublayers];
	[self scrollContentResized];
}

#pragma mark - Slider Methods
// Where newWidth is a number between 0.0 and 1.0 representing
// the percentage...
- (void)setSliderWidth:(CGFloat)widthPercentage {
	CGFloat trayWidth = tray.frame.size.width;
	CGFloat newWidth = trayWidth * widthPercentage;
	if ( newWidth < SLIDER_MIN_WIDTH ) {
		newWidth = SLIDER_MIN_WIDTH;
	}
	CGRect oldFrame = slider.frame;
	slider.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, newWidth, oldFrame.size.height);
}

- (void)setSliderPosition:(CGFloat)xPosition {
	CGRect frame = slider.frame;
	CGFloat newX = xPosition;

	if( newX < 0 ) {
		newX = 0;
	}

	if( newX + frame.size.width > tray.frame.size.width ) {
		newX = tray.frame.size.width - frame.size.width;
	}
	slider.frame = CGRectMake(newX, frame.origin.y, frame.size.width, frame.size.height);
}

- (void)moveSlider:(CGFloat)dx {
	CGFloat newX = slider.frame.origin.x + dx;
	// Slider tracking should be immediate
	[CATransaction begin]; {
		[CATransaction setValue:@0.0f forKey:@"animationDuration"];
		[self setSliderPosition:newX];
	}
	[CATransaction commit];
	[CATransaction setValue:@0.4f forKey:@"animationDuration"];
	[_scrollerContent scrollToPosition: newX / tray.frame.size.width];
}
- (void) createScrollTray {

	tray = [CALayer layer];
	tray.autoresizingMask = kCALayerHeightSizable;
	tray.backgroundColor = cgPURPLE;//SPACERCOLOR;
	tray.layoutManager = [CAConstraintLayoutManager layoutManager];

	NSUInteger columns = [AtoZ dock].count;
	for (int c = 0; c < columns ; c++) {
		CALayer *cell = [CALayer layer];
		cell.frame = self.bounds;
//		t.size.height = 50;
//		cell.anchorPoint = CGPointMake(0.0f,0.5f);
//		cell.zPosition = c*100;
//		[cell setBounds:CGRectMake(0,0,100,self.bounds.size.height)];
//		cell.borderColor =	CGColorCreateGenericGray(0.8, 0.8);
//		cell.borderWidth = 1;	cell.cornerRadius = 4;
		cell.backgroundColor = [[[[[AtoZ dock] sortedWithKey:@"hue" ascending:YES] objectAtNormalizedIndex:c]valueForKey:@"color"]CGColor];
//		cell.shadowOffset = CGSizeMake(5,5);
//		cell.shadowColor = cgBLACK;
//		cell.shadowRadius = 10;
//		cell.name = [NSString stringWithFormat:@"%u", c];
		cell.Constraints = @[ 	AZConstRelSuperScaleOff(kCAConstraintWidth,	1.0 / columns, 0),
								AZConstRelSuperScaleOff(kCAConstraintHeight, 1, 0),
							 	AZConstAttrRelNameAttrScaleOff(kCAConstraintMinX, @"superlayer", kCAConstraintMaxX, ( c / (float)columns), 0)];

		//$(@"%u", c+1)

	[tray addSublayer:cell];
}

	CGFloat trayOffset = ARROW_WIDTH - INNER_RADIUS;
	[tray addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY]];
	[tray addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY]];
	[tray addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"rightArrow" attribute:kCAConstraintMaxX offset:-trayOffset]];
	[tray addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"leftArrow" attribute:kCAConstraintMinX offset:trayOffset]];

	[self createSlider];

	[tray addSublayer:slider];

}

- (void) createSlider {

	CGFloat sliderHeight = SCROLLER_HEIGHT - BORDERWIDTH * 2;
	CGFloat initialWidth = SLIDER_MIN_WIDTH;

	slider = [CALayer layer];
	slider.frame = CGRectMake(0, 0, initialWidth, sliderHeight);
	[slider addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY offset:-BORDERWIDTH]];
	[slider addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY offset:BORDERWIDTH]];
	slider.layoutManager = [CAConstraintLayoutManager layoutManager];

//	CALayer* leftSide = [CALayer layer];
//	leftSide.frame = CGRectMake(0, 0, INNER_RADIUS, sliderHeight);
//	leftSide.name = @"leftSide";
//	[leftSide addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"superlayer" attribute:kCAConstraintMinX]];
//	[leftSide addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY]];

	CALayer* middle = [CALayer layer];
	middle.frame = CGRectMake(0, 0, INNER_RADIUS, sliderHeight);
	[middle addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"superlayer" attribute:kCAConstraintMinX offset:INNER_RADIUS-1]];
	[middle addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintMaxX offset:-INNER_RADIUS+1]];

//	CALayer* rightSide = [CALayer layer];
//	rightSide.frame = CGRectMake(0, 0, INNER_RADIUS, sliderHeight);
//	rightSide.name = @"rightSide";
//	[rightSide addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintMaxX]];
	NSImage* bgImage = [self createGlassImageForSize:NSMakeSize(initialWidth, sliderHeight)];
	// crop the image into 3 pieces
	//[ 0 -> INNER_RADIUS ][ INNER_RADIUS -> initialWidth - INNER_RADIUS * 2 ][ initialWidth - INNER_RADIUS -> initialWidth ]
//	NSImage* leftImage = [MiscUtils cropImage:bgImage withRect:NSMakeRect(0, 0, INNER_RADIUS, sliderHeight)];
	NSImage* centreImage = [AtoZ cropImage:bgImage
										 withRect:NSMakeRect(INNER_RADIUS, 0, initialWidth - INNER_RADIUS * 2, sliderHeight)];
//	NSImage* rightImage = [MiscUtils cropImage:bgImage withRect:NSMakeRect(initialWidth - INNER_RADIUS, 0, INNER_RADIUS, sliderHeight)];

	[self addContents:centreImage toLayer:middle];

//	[self setSliderSideLayer:leftSide contents:leftImage
//						andPts:NSMakePoint (INNER_RADIUS, sliderHeight)
//						 pt2:NSMakePoint (0, sliderHeight * 0.5)
//						 pt3:NSMakePoint (INNER_RADIUS, 0)];

//	[self setSliderSideLayer:rightSide contents:rightImage
//						andPts:NSMakePoint (0, sliderHeight)
//						 pt2:NSMakePoint (INNER_RADIUS, sliderHeight * 0.5)
//						 pt3:NSMakePoint (0, 0)];

//	[slider addSublayer:leftSide];
//	[slider addSublayer:rightSide];
	[slider addSublayer:middle];
		// create the filter and set its default values
	CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
//	CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
	[filter setDefaults];
	[filter setValue:@(5.0) forKey:@"inputRadius"];
		// name the filter so we can use the keypath to animate the inputIntensity attribute of the filter
	[filter setName:@"pulseFilter"];
		// set the filter to the selection layer's filters
	[slider setFilters:@[filter]];

//
//	CIImage *image = [CIImage imageWithCGImage:[[NSImage randomIcon] cgImageRef]];
//
//	CIFilter * colorFilter = [CIFilter filterWithName:@"CIColorControls"];
//	[colorFilter setDefaults];
//	[colorFilter setValue:image forKey:@"inputImage"];
//		// apply an affine transform to the iamge to scale it to one quarter of its size
//	CIFilter *scaleFilter = [CIFilter filterWithName:@"CIAffineTransform"];
//	NSAffineTransform *transform = [NSAffineTransform transform];
//	[transform scaleBy: 1.0 / 4];
//	[scaleFilter setValue:transform forKey:@"inputTransform"];
//	[scaleFilter setValue:[colorFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
//	CIFilter *lensFilter = [CIFilter filterWithName: @"LensFilter"];
//	[lensFilter setDefaults];
//	[lensFilter setValue:[scaleFilter valueForKey:@"outputImage"] forKey:@"inputImage"];
//	[lensFilter setValue:[CIVector vectorWithX:(slider.bounds.size.width * 0.5) Y:(slider.bounds.size.height * 0.5)] forKey:@"inputCenter"];
//	[lensFilter setValue:[NSNumber numberWithDouble:4] forKey:@"inputMagnification"];
//	[lensFilter setValue: [CIVector vectorWithX:[[scaleFilter valueForKey:@"outputImage"] extent].size.width * 0.5 Y:[[scaleFilter valueForKey:@"outputImage"] extent].size.height * 0.5] forKey: @"inputCenter"];
////	 = [[lensFilter valueForKey:@"outputImage"] extent];
//
//	slider.filters = @[colorFilter];
}
// Makes the left and right side of the slider rounded based on the points provided
// Creates a Mask and draws a rounded border on the provided image that is set to the contents
- (void)setSliderSideLayer:(CALayer*)layer contents:(NSImage*)image andPts:(NSPoint)pt1 pt2:(NSPoint)pt2 pt3:(NSPoint)pt3 {
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path moveToPoint:pt1];
	[path curveToPoint:pt2 controlPoint1:NSMakePoint(pt2.x, pt1.y) controlPoint2:pt2];
	[path curveToPoint:pt3 controlPoint1:NSMakePoint(pt2.x, pt3.y) controlPoint2:pt3];

	[image lockFocus];
	{
		NS_BORDERCOLOR
		[path stroke];
	}
	[image unlockFocus];

	// Close the path so that we can create the rounded mask
	[path lineToPoint:pt1];
	NSImage* maskImage = [[NSImage alloc] initWithSize:NSMakeSize([path bounds].size.width, [path bounds].size.height)];
	[maskImage lockFocus];
	{
		[[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] set];
		[path fill];
		[path stroke];
	}
	[maskImage unlockFocus];

	[self addContents:image toLayer:layer];
	[self addMask:maskImage toLayer:layer];

}
#pragma mark - Arrow Helper Methods
- (void) createLeftArrow {
	float minX = 0;
	float minY = 0;
	float maxX = ARROW_WIDTH;
	float maxY = SCROLLER_HEIGHT;
	NSPoint topLeft = NSMakePoint (minX, maxY);
	NSPoint topRight= NSMakePoint (maxX, maxY);
	NSPoint bottomRight = NSMakePoint (maxX, minY);
	NSPoint bottomLeft= NSMakePoint (minX, minY);
	NSPoint centerPoint = NSMakePoint(maxX - INNER_RADIUS, (maxY - minY) * 0.5);

	leftArrow = [CALayer layer];
	leftArrow.name = @"leftArrow";
	leftArrow.autoresizingMask = kCALayerHeightSizable;
	leftArrow.frame = CGRectMake(minX, minY, maxX, maxY);
	[leftArrow addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY]];
	[leftArrow addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY]];
	[leftArrow addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX relativeTo:@"superlayer" attribute:kCAConstraintMinX]];

	CALayer* arrowContent = [CALayer layer];
	arrowContent.frame = leftArrow.frame;
	[leftArrow addSublayer:arrowContent];
	// ----------Creating content -----------------

	NSPoint pt1 = NSMakePoint(CORNER_RADIUS , centerPoint.y);
	NSPoint pt2 = NSMakePoint(pt1.x + INNER_RADIUS, maxY - 4);
	NSPoint pt3 = NSMakePoint(pt2.x, minY + 4);
	NSBezierPath* arrowPath = [self createArrowTriangleWithPt:pt1 pt2:pt2 pt3:pt3];
	NSPoint borderPt1 = NSMakePoint(topRight.x, topRight.y - BORDERWIDTH);
	NSPoint borderPt2 = centerPoint;
	NSPoint borderPt3 = NSMakePoint(bottomRight.x, bottomRight.y + BORDERWIDTH);
	NSBezierPath* rightBorderPath =[self createArrowBorderPathWithPt:borderPt1 pt2:borderPt2 pt3:borderPt3];

	[self setContentForArrowLayer:arrowContent withArrow:arrowPath andBorder:rightBorderPath];

	leftArrowHighlight = [CALayer layer];
	leftArrowHighlight.frame = leftArrow.frame;
	leftArrowHighlight.backgroundColor = SPACERCOLOR;
	[leftArrowHighlight setHidden:YES];

	[arrowContent addSublayer:leftArrowHighlight];

	// Create Mask Image
	NSImage* maskImage =
	[self createArrowMaskImageForPt:topLeft pt2:topRight pt3:centerPoint pt4:bottomRight pt5:bottomLeft];
	[self addMask:maskImage toLayer:arrowContent];
}

- (void) createRightArrow {
	float minX = 0;
	float minY = 0;
	float maxX = ARROW_WIDTH;
	float maxY = SCROLLER_HEIGHT;

	NSPoint topLeft = NSMakePoint (minX, maxY);
	NSPoint topRight= NSMakePoint (maxX, maxY);
	NSPoint bottomRight = NSMakePoint (maxX, minY);
	NSPoint bottomLeft= NSMakePoint (minX, minY);
	NSPoint centerPoint = NSMakePoint(minX + INNER_RADIUS, (maxY - minY) * 0.5);

	rightArrow = [CALayer layer];
	rightArrow.name = @"rightArrow";
	rightArrow.autoresizingMask = kCALayerHeightSizable;
	rightArrow.frame = CGRectMake(minX, minY, maxX, maxY);
	[rightArrow addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY]];
	[rightArrow addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"superlayer" attribute:kCAConstraintMaxX]];
	[rightArrow addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY]];

	CALayer* arrowContent = [CALayer layer];
	arrowContent.frame = rightArrow.frame;
	[rightArrow addSublayer:arrowContent];

	NSPoint pt1 = NSMakePoint(maxX - CORNER_RADIUS , centerPoint.y);
	NSPoint pt2 = NSMakePoint(pt1.x - INNER_RADIUS, maxY - 4);
	NSPoint pt3 = NSMakePoint(pt2.x, minY + 4);
	NSBezierPath* arrowPath = [self createArrowTriangleWithPt:pt1 pt2:pt2 pt3:pt3];

	NSPoint borderPt1 = NSMakePoint(topLeft.x, topLeft.y - BORDERWIDTH);
	NSPoint borderPt2 = centerPoint;
	NSPoint borderPt3 = NSMakePoint(bottomLeft.x, bottomLeft.y + BORDERWIDTH);
	NSBezierPath* leftBorderPath = [self createArrowBorderPathWithPt:borderPt1 pt2:borderPt2 pt3:borderPt3];

	[self setContentForArrowLayer:arrowContent withArrow:arrowPath andBorder:leftBorderPath];

	rightArrowHighlight = [CALayer layer];
	rightArrowHighlight.frame = rightArrow.frame;
	rightArrowHighlight.backgroundColor = SPACERCOLOR;
	[rightArrowHighlight setHidden:YES];

	[arrowContent addSublayer:rightArrowHighlight];

	NSImage* maskImage = [self createArrowMaskImageForPt:topRight pt2:topLeft pt3:centerPoint pt4:bottomLeft pt5:bottomRight];
	[self addMask:maskImage toLayer:arrowContent];
}

- (void)setContentForArrowLayer:(CALayer*)arrowContent withArrow:(NSBezierPath*)arrowPath andBorder:(NSBezierPath*)borderPath {

	NSImage* bgImage = [self createGlassImageForSize:NSMakeSize(ARROW_WIDTH, SCROLLER_HEIGHT)];
	[bgImage lockFocus];
	{
		NS_BORDERCOLOR
		[arrowPath fill];
		[arrowPath stroke];

		[borderPath stroke];
	}
	[bgImage unlockFocus];

	[self addContents:bgImage toLayer:arrowContent];
}

- (NSBezierPath*) createArrowBorderPathWithPt:(NSPoint)pt1 pt2:(NSPoint)pt2 pt3:(NSPoint)pt3 {
	NSBezierPath* borderPath = [NSBezierPath bezierPath];

	[borderPath moveToPoint:pt1];
	[borderPath curveToPoint:pt2 controlPoint1:NSMakePoint(pt2.x, pt1.y) controlPoint2:pt2];
	[borderPath curveToPoint:pt3 controlPoint1:NSMakePoint(pt2.x, pt3.y) controlPoint2:pt3];
	[borderPath setLineWidth:1];

	return borderPath;
}
- (NSBezierPath*) createArrowTriangleWithPt:(NSPoint)pt1 pt2:(NSPoint)pt2 pt3:(NSPoint)pt3 {
	NSBezierPath* arrowPath = [NSBezierPath bezierPath];

	[arrowPath moveToPoint:pt1];
	[arrowPath lineToPoint:pt2 ];
	[arrowPath lineToPoint:pt3];
	[arrowPath lineToPoint:pt1 ];
	[arrowPath setLineWidth:1];

	return arrowPath;
}
// Five parameters. Tastes awful but it works.
- (NSImage*)createArrowMaskImageForPt:(NSPoint)pt1 pt2:(NSPoint)pt2 pt3:(NSPoint)pt3 pt4:(NSPoint)pt4 pt5:(NSPoint)pt5 {
	NSBezierPath* path = [NSBezierPath bezierPath];
	[path moveToPoint:pt1];
	[path lineToPoint:pt2];
	[path curveToPoint:pt3 controlPoint1:NSMakePoint(pt3.x, pt2.y)
		 controlPoint2:pt3];
	[path curveToPoint:pt4 controlPoint1:NSMakePoint(pt3.x, pt4.y)
		 controlPoint2:pt4];
	[path lineToPoint:pt5];

	NSImage* maskImage = [[NSImage alloc] initWithSize:NSMakeSize([path bounds].size.width, [path bounds].size.height)];
	[maskImage lockFocus];
	{
		[[NSColor colorWithCalibratedWhite:1.0 alpha:1.0] set];
		[path fill];
		[path stroke];
	}
	[maskImage unlockFocus];
	//[maskImage autorelease];
	return maskImage;
}
#pragma mark - General Helper Methods
- (NSImage*) createGlassImageForSize:(NSSize)size {
	NSBezierPath* glassEffect = [NSBezierPath bezierPath];
/*
	NSPoint glassPt1 = NSMakePoint(0, size.height);
	NSPoint glassPt2 = NSMakePoint(glassPt1.x + INNER_RADIUS, glassPt1.y - INNER_RADIUS);
	NSPoint glassPt2a = NSMakePoint(size.width - INNER_RADIUS, glassPt2.y);
	NSPoint glassPt4 = NSMakePoint(size.width, size.height);

	[glassEffect moveToPoint:glassPt1];
	[glassEffect curveToPoint:glassPt2 controlPoint1:NSMakePoint(glassPt1.x, glassPt2.y)
				controlPoint2:glassPt2];
	[glassEffect lineToPoint:glassPt2a];
	[glassEffect curveToPoint:glassPt4 controlPoint1:NSMakePoint(glassPt4.x, glassPt2a.y)
				controlPoint2:glassPt4];
	[glassEffect lineToPoint:glassPt1];

	NSColor* topGradientTop = [NSColor colorWithCalibratedWhite:1.0 alpha:0.27];
	NSColor* topGradientBottom= [NSColor colorWithCalibratedWhite:1.0 alpha:0.17];

	NSGradient* topGlassGradient = [[NSGradient alloc] initWithStartingColor:topGradientBottom
																 endingColor:topGradientTop];
	NSColor* botGradientTop = [NSColor colorWithCalibratedWhite:1.0 alpha:0.0];
	NSColor* botGradientBottom= [NSColor colorWithCalibratedWhite:1.0 alpha:0.129];

	NSGradient* botGlassGradient = [[NSGradient alloc] initWithStartingColor:botGradientBottom
																 endingColor:botGradientTop];
	NSRect bottomGlassRect = NSMakeRect(0, 1, size.width, INNER_RADIUS - 1);

*/
	NSImage* glassedImage = [[NSImage alloc] initWithSize:size];
	[glassedImage lockFocus];
	{
		[[NSColor colorWithCalibratedRed:0.986 green:0.801 blue:0.300 alpha:1.000] set];
		[NSBezierPath fillRect:NSMakeRect(0, 0, size.width, size.height)];

//		[glassEffect fillGradientFrom:WHITE to:RED angle:270];
//		[topGlassGradient drawInBezierPath:glassEffect angle:90.0];
//		[botGlassGradient drawInRect:bottomGlassRect angle:90.0];
	}
	[glassedImage unlockFocus];
	
	//[topGlassGradient release];
	//[botGlassGradient release];
	//[glassedImage autorelease];
	return glassedImage;
}

- (void) addMask:(NSImage*)maskImage toLayer:(CALayer*)layer {

	//CGImageSourceRef source = CGImageSourceCreateWithData()[maskImage TIFFRepresentation], NULL);
	//CGImageRef maskRef =CGImageSourceCreateImageAtIndex(source, 0, NULL);
	//CFRelease(source);
	//	CGImageRef maskRef = maskImage.cgImageRef;

	CALayer* maskLayer = [CALayer layer];
	maskLayer.frame = layer.frame;
	maskLayer.position = CGPointMake(0, 0);
	maskLayer.anchorPoint = CGPointMake(0,0);
	[self addContents:maskImage toLayer:layer];
	//	[maskLayer setContents:(id)CFBridgingRelease(maskRef)];

	[layer setMask:maskLayer];
	//	CGImageRelease(maskRef);
}

- (void) addContents:(NSImage*)contentsImage toLayer:(CALayer*)layer {
	[contentsImage setScalesWhenResized:YES];

	layer.contents = contentsImage;
	if (!layer.contentsGravity)
		layer.contentsGravity = kCAGravityCenter;

	//CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)[contentsImage TIFFRepresentation], NULL);
	//CGImageRef bgRef =CGImageSourceCreateImageAtIndex(source, 0, NULL);
	//CFRelease(source);
	//[layer setContents:(id)CFBridgingRelease(bgRef)];
	//CGImageRelease(bgRef);

}

#pragma mark - Event Methods

- (void)startMouseDownTimer {
	[mouseDownTimer invalidate];
	mouseDownTimer = nil;

	NSTimeInterval initialInterval = 0.5; // The initial interval is longer that the regular one
	[NSTimer scheduledTimerWithTimeInterval:initialInterval target:self
									 selector:@selector(periodicMouseDownEvent:)
									 userInfo:NULL repeats:NO];
}
// If the user holds down the mouse keep scrolling
- (void)periodicMouseDownEvent:(NSTimer *)timer {

	// Input stopped through a mouseUp event
	if ( _inputMode == SFNoInput ) {
		[timer invalidate];
		return;
	}

	if ( _mouseOverSelectedInput) {

		if (_inputMode == SFLeftArrowInput ) {
			[_scrollerContent moveScrollView:-[_scrollerContent stepSize]];
		}

		if (_inputMode == SFRightArrowInput ) {
			[_scrollerContent moveScrollView:[_scrollerContent stepSize]];
		}

		CGPoint trayPoint = [tray convertPoint:_mouseDownPointForCurrentEvent fromLayer:tray.superlayer];
		if (_inputMode == SFTrayInputLeft || _inputMode == SFTrayInputRight ) {

			if ( CGRectContainsPoint ( slider.frame, trayPoint ) ) {
				// Stop moving the tray when the slider hits the mouse
				_inputMode = SFNoInput;
			}

		}

		if (_inputMode == SFTrayInputLeft && trayPoint.x < slider.frame.origin.x) {
			[_scrollerContent moveScrollView:-[_scrollerContent visibleWidth]];
		}

		if (_inputMode == SFTrayInputRight && trayPoint.x > slider.frame.origin.x) {
			[_scrollerContent moveScrollView:[_scrollerContent visibleWidth]];
		}

	}
	if ( !mouseDownTimer ) {
		NSTimeInterval regularInterval = 0.1;
		mouseDownTimer = [NSTimer scheduledTimerWithTimeInterval:regularInterval target:self
														selector:@selector(periodicMouseDownEvent:)
														userInfo:NULL repeats:YES];
	}

}

- (BOOL)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint {
	[CATransaction setValue:@0.0f forKey:@"animationDuration"];
	CGPoint point = [self convertPoint:inputPoint fromLayer:self.superlayer];
	_mouseDownPointForCurrentEvent = point;
	_mouseOverSelectedInput = YES;
	_inputMode = SFNoInput;

	if ( CGRectContainsPoint ( tray.frame, point ) ) {
		// Check the slider.It's frame is relative to the
		// tray since it's inside the tray
		CGPoint trayPoint = [tray convertPoint:point fromLayer:tray.superlayer];

		if ( CGRectContainsPoint ( slider.frame, trayPoint ) ) {
			_inputMode = SFSliderInput;
			return YES;
		}

		if (trayPoint.x < slider.frame.origin.x ) {
			_inputMode = SFTrayInputLeft;
			[_scrollerContent moveScrollView:-[_scrollerContent visibleWidth]];
		} else {
			_inputMode = SFTrayInputRight;
			[_scrollerContent moveScrollView:[_scrollerContent visibleWidth]];
		}

		[self startMouseDownTimer];
		return YES;
	}

	if ( CGRectContainsPoint ( leftArrow.frame, point ) ) {
		leftArrowHighlight.hidden = NO;
		_inputMode = SFLeftArrowInput;
		[_scrollerContent moveScrollView:-[_scrollerContent stepSize]];
		[self startMouseDownTimer];
		return YES;
	}

	if ( CGRectContainsPoint ( rightArrow.frame, point ) ) {
		rightArrowHighlight.hidden = NO;
		_inputMode = SFRightArrowInput;
		[_scrollerContent moveScrollView:[_scrollerContent stepSize]];
		[self startMouseDownTimer];
		return YES;
	}
	return NO;
}
- (void)mouseDragged:(CGPoint)inputPoint {

	CGPoint point = [self convertPoint:inputPoint fromLayer:self.superlayer];

	if (_inputMode == SFTrayInputLeft ||_inputMode == SFTrayInputRight ) {
		_mouseOverSelectedInput = CGRectContainsPoint ( tray.frame, point ) ? YES : NO;
		_mouseDownPointForCurrentEvent = point;
		return;
	}

	if ( _inputMode == SFSliderInput ) {
		CGPoint startPoint = _mouseDownPointForCurrentEvent;
		CGPoint endPoint = point;
		CGFloat dx = endPoint.x - startPoint.x;
		[self moveSlider:dx];
		_mouseDownPointForCurrentEvent = endPoint;
		return;
	}

	[CATransaction setValue:@0.0f forKey:@"animationDuration"];
	if ( _inputMode == SFLeftArrowInput ) {
		leftArrowHighlight.hidden = CGRectContainsPoint ( leftArrow.frame, point ) ? NO : YES;
		_mouseOverSelectedInput = ! leftArrowHighlight.hidden;
	}

	if ( _inputMode == SFRightArrowInput ) {
		rightArrowHighlight.hidden = CGRectContainsPoint ( rightArrow.frame, point ) ? NO : YES;
		_mouseOverSelectedInput = ! rightArrowHighlight.hidden;
	}

}
- (void)mouseUp:(CGPoint)inputPoint {
	[CATransaction setValue:@0.0f forKey:@"animationDuration"];

	leftArrowHighlight.hidden = YES;
	rightArrowHighlight.hidden = YES;

	_inputMode = SFNoInput;
	_mouseOverSelectedInput = NO;
}

#pragma mark - SFScrollerContentController Methods
- (BOOL)isRepositioning {
	return _inputMode != SFNoInput;
}

- (void)scrollPositionChanged:(CGFloat)position {
	if (_inputMode == SFSliderInput ) {
		// The user is dragging the slider so ignore the message
		return;
	}
	
	CGFloat percentage = position / ([_scrollerContent contentWidth] - [_scrollerContent visibleWidth]);
	CGFloat newX = (tray.frame.size.width - slider.frame.size.width ) * percentage;
	[CATransaction begin];
	{
		[CATransaction setValue:@0.0f forKey:@"animationDuration"];
		[self setSliderPosition:newX];
	}
	[CATransaction commit];
}

- (void)scrollContentResized {
	[CATransaction setValue:@0.0f forKey:@"animationDuration"];
	if ( !_scrollerContent || [_scrollerContent visibleWidth] >= [_scrollerContent contentWidth] ) {
		self.hidden = YES;
	} else {
		self.hidden = NO;
		[self setSliderWidth: [_scrollerContent visibleWidth] / [_scrollerContent contentWidth] ];
	}
}

@end
