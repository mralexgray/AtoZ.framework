//
//  YRKSpinningProgressIndicatorLayer.h
//  SPILDemo
//
//  Copyright 2009 Kelan Champagne. All rights reserved.
//

#import "AtoZUmbrella.h"

@interface AZSpinnerLayer : CALayer {
	BOOL _isRunning;
	NSTimer *_animationTimer;
	NSUInteger _position;

	CGColorRef _foreColor;
	CGFloat _fadeDownOpacity;

	NSUInteger _numFins;
	NSMutableArray *_finLayers;
}

- (void)toggleProgressAnimation;
- (void)startProgressAnimation;
- (void)stopProgressAnimation;

// Properties and Accessors
@property (RONLY) BOOL isRunning;
@property (readwrite, copy) NSColor *color;  // "copy" because we don't retain it -- we create a CGColor from it

@end

// Helper Functions
CGColorRef CGColorCreateFromNSColor(NSColor *nscolor);
NSColor *NSColorFromCGColorRef(CGColorRef cgcolor);
