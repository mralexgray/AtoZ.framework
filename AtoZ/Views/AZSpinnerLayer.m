
//  YRKSpinningProgressIndicatorLayer.m
//  SPILDemo
//  Copyright 2009 Kelan Champagne. All rights reserved.

#import "AtoZ.h"
#import "AZSpinnerLayer.h"

@implementation AZSpinnerLayer
 {
	BOOL _isRunning;
	NSUInteger _position, _numFins;
	CGColorRef _foreColor;
	CGF _fadeDownOpacity;
	NSTimer *_animationTimer;///	NSMutableArray *_finLayers;
}
@synthesize  running = _isRunning; @dynamic color;

- (id)init { SUPERINIT;

  _numFins = 12;
  _fadeDownOpacity = _position = _isRunning = NO;
  _foreColor = cgBLACK;
  self.bounds = AZRectFromDim(10);
  [self createFinLayers];
  [NSEVENTLOCALMASK:NSLeftMouseUpMask handler:^NSE*(NSE*E){
    E.clickCount > 1 ? [self toggle] :nil; return E;
  }];
	return self;
}

#pragma mark - Overrides

- (void)setBounds:(CGRect)newBounds
{
	[super setBounds:newBounds];

	// Resize the fins
	CGR finBounds = self.finBoundsForCurrentBounds;
	CGP finAnchorPoint = self.finAnchorPointForCurrentBounds;
	CGP finPosition = AZCenterOfRect(self.bounds);//self.centerPt;
	CGF finCornerRadius = finBounds.size.width/2;

	// do the resizing all at once, immediately
	[CATRANNY immediately:^{
    [self.sublayers do:^(CALayer *fin){
      fin.bounds        = finBounds;
      fin.anchorPoint   = finAnchorPoint;
      fin.position      = finPosition;
      fin.cornerRadius  = finCornerRadius;
    }];
  }];
}
//------------------------------------------------------------------------------
#pragma mark - Animation
//------------------------------------------------------------------------------

- (void)advancePosition
{
	_position++;
	_position = _position >= _numFins ? 0 : _position;

	CALayer *fin = self.sublayers[_position];

	// Set the next fin to full opacity, but do it immediately, without any animation
	[CATRANNY immediately:^{
    fin.opacity = 1.0;
  }];
	// Tell that fin to animate its opacity to transparent.
	fin.opacity = _fadeDownOpacity;
	[self setNeedsDisplay];
}

- (void)setupAnimTimer
{
	// Just to be safe kill any existing timer.
	[self disposeAnimTimer];

	// Why animate if not visible?  viewDidMoveToWindow will re-call this method when needed.
	_animationTimer = [NSTimer timerWithTimeInterval:(NSTimeInterval)0.05
											   target:self
											 selector:@selector(advancePosition)
											 userInfo:nil
											  repeats:YES];

	_animationTimer.fireDate = NSDate.date;
  [@[NSRunLoopCommonModes, NSDefaultRunLoopMode,NSEventTrackingRunLoopMode]do:^(id obj) {
    [AZRUNLOOP addTimer:_animationTimer forMode:obj];
  }];
}

- (void)disposeAnimTimer
{
	[_animationTimer invalidate];
//	[_animationTimer release];
	_animationTimer = nil;
}

- (void)startProgressAnimation
{
	self.hidden = NO;
	_isRunning = YES;
	_position = _numFins - 1;
	
	[self setNeedsDisplay];
	[self setupAnimTimer];
}

- (void)stopProgressAnimation
{
	_isRunning = NO;
	[self disposeAnimTimer];
	[self setNeedsDisplay];
}

- (void) setRunning:(BOOL)running
{
  objc_msgSend(self, running ? @selector(startProgressAnimation) : @selector(stopProgressAnimation));
}
//------------------------------------------------------------------------------
#pragma mark - Properties and Accessors
//------------------------------------------------------------------------------

//@synthesize isRunning = _isRunning;

// Can't use @synthesize because we need to convert NSColor <-> CGColor
- (NSColor *)color
{
	// Need to convert from CGColor to NSColor
	return  [NSC colorWithCGColor:_foreColor];
}
- (void)setColor:(NSColor *)newColor
{
	// Need to convert from NSColor to CGColor
//	CGColorRef cgColor = CGColorCreateFromNSColor(newColor);

//	if (nil != _foreColor) {
//		CGColorRelease(_foreColor);
//	}
	_foreColor = [newColor CGColor];

	// Update do all of the fins to this new color, at once, immediately
	[CATransaction immediately:^{
    [self.sublayers setValue:(__bridge id)_foreColor forKey:@"backgroundColor"];
    ////fin.backgroundColor = _foreColor;
  }];
}

- (void)toggle{ [self toggleProgressAnimation]; }
- (void)toggleProgressAnimation {	self.running = !_isRunning; }

#pragma mark - Helper Methods

- (void)createFinLayers {

	[self removeSublayers];

	CGR finBounds       = self.finBoundsForCurrentBounds;
	CGP finAnchorPoint  = self.finAnchorPointForCurrentBounds;
	CGP finPosition     = AZCenterOfRect(self.bounds);
	CGF finCornerRadius = finBounds.size.width/2;

	self.sublayers = [@(_numFins) mapTimes:^id(NSNumber *num) { 	// Create new fin layers

		AZNewVal(newFin, CAL.new);
		newFin.bounds           = finBounds;
		newFin.anchorPoint      = finAnchorPoint;
		newFin.position         = finPosition;
		newFin.transform        = CATransform3DMakeRotation(num.iV * (-6.282185/_numFins), 0, 0, 1);
		newFin.cornerRadius     = finCornerRadius;
		newFin.backgroundColor  = _foreColor;

		// Set the fin's initial opacity
    [newFin setValueImmediately:@(_fadeDownOpacity) forKey:@"opacity"];
		// set the fin's fade-out time (for when it's animating)
		[newFin setActions:@{@"opacity": [CABasicAnimation.animation wVsfKs:@.7,@"duration",nil]}];

		[self addSublayer: newFin];
		return newFin;
	}];
}
//
//- (void)removeFinLayers {
//	for (CALayer *finLayer in _finLayers) {
//		[finLayer removeFromSuperlayer];
//	}
////	[_finLayers release];
//}

- (CGRect)finBoundsForCurrentBounds
{
	CGSize size = [self bounds].size;
	CGFloat minSide = size.width > size.height ? size.height : size.width;
	CGFloat width = minSide * 0.095f;
	CGFloat height = minSide * 0.30f;
	return CGRectMake(0,0,width,height);
}

- (CGPoint)finAnchorPointForCurrentBounds
{
	CGSize size = [self bounds].size;
	CGFloat minSide = size.width > size.height ? size.height : size.width;
	CGFloat height = minSide * 0.30f;
	return CGPointMake(0.5, -0.9*(minSide-height)/minSide);
}

@end
/*
//------------------------------------------------------------------------------
#pragma mark - Helper Functions
//------------------------------------------------------------------------------

/// Note: This returns a CGColorRef that the caller needs to release.
CGColorRef CGColorCreateFromNSColor(NSColor *nscolor)
{
// make this work with both 10.5 and 10.6 SDKs, based on a trick used
// by Cairo, and recommened to me by Eloy Duran (via email)
// http://lists.cairographics.org/archives/cairo-bugs/2009-December/003385.html
#ifdef CGFLOAT_DEFINED
#define yrkspil_float_t CGFloat
#else
#define yrkspil_float_t float
#endif
	yrkspil_float_t components[4];
	NSColor *deviceColor = [nscolor colorUsingColorSpaceName: NSDeviceRGBColorSpace];
	[deviceColor getRed: &components[0] green: &components[1] blue: &components[2] alpha: &components[3]];

	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef cgcolor = CGColorCreate(colorSpace, components);
	CGColorSpaceRelease(colorSpace);

	return cgcolor;
#undef yrkspil_float_t
}
NSColor *NSColorFromCGColorRef(CGColorRef cgcolor)
{
	NSColorSpace *colorSpace = [NSColorSpace deviceRGBColorSpace];
	return [NSColor colorWithColorSpace:colorSpace
							 components:CGColorGetComponents(cgcolor)
								  count:CGColorGetNumberOfComponents(cgcolor)];
}
*/
//@interface AZSpinnerLayer ()

// Animation
//- (void)advancePosition;
//
//// Helper Methods
//- (void)removeFinLayers;
//- (void)createFinLayers;
//
//- (CGRect)finBoundsForCurrentBounds;
//- (CGPoint)finAnchorPointForCurrentBounds;
//
//- (void)setupAnimTimer;
//- (void)disposeAnimTimer;

//@end