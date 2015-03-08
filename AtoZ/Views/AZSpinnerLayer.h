//
//  YRKSpinningProgressIndicatorLayer.h
//  SPILDemo
//
//  Copyright 2009 Kelan Champagne. All rights reserved.
//


@interface AZSpinnerLayer : CALayer
- (void)toggleProgressAnimation;
- (void)startProgressAnimation;
- (void)stopProgressAnimation;
- (void)toggle;

// Properties and Accessors
@prop_NA BOOL running;
@property NSColor *color;  // "copy" because we don't retain it -- we create a CGColor from it

@end

// Helper Functions
//CGColorRef CGColorCreateFromNSColor(NSColor *nscolor);
//NSColor *NSColorFromCGColorRef(CGColorRef cgcolor);
