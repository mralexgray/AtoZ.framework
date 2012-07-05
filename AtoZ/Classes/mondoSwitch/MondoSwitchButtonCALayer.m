//
//  MondoSwitchButtonCALayer.m
//  CocoaMondoKit
//
//  Created by Matthieu Cormier on 12/8/09.
//  Copyright 2009 Preen and Prune Software and Design. All rights reserved.
//

#import "MondoSwitchButtonCALayer.h"
#import "AtoZ.h"


@implementation MondoSwitchButtonCALayer

// The grayscale values for the button colors.
static const CGFloat notClickedTopColor = 0.9921;
static const CGFloat notClickedBotColor = 0.9019;

static const CGFloat clickedTopColor = 0.8745;
static const CGFloat clickedBotColor = 0.9568;

static const CGFloat cornerRadius = 5.0;

@synthesize on=_on;

#pragma mark -
#pragma mark init methods

- (id) init {
	self =  [super init];
//  self = [[CALayer alloc] init];//[CALayer layer];
  self.autoresizingMask = kCALayerWidthSizable;
  self.cornerRadius = cornerRadius;
  self.borderWidth = 0;
  self.bounds = CGRectMake(00, 00, 20, 20);
  
  [self addConstraint:AZConstraint(kCAConstraintMinY, @"superlayer")];
  [self addConstraint:AZConstraint(kCAConstraintMinX, @"superlayer")];    
  [self addConstraint:AZConstraint(kCAConstraintWidth, @"superlayer")];
  [self addConstraint:AZConstraint(kCAConstraintHeight, @"superlayer")];    

  [self setLayoutManager:[CAConstraintLayoutManager layoutManager]];
  
  [self createtheSwitch];
  _currentEventState = PPNoEvent;
  
  return self;
}

- (void) dealloc {
  CGImageRelease(notClickedImgRef);
  CGImageRelease(clickedImgRef);
//  [super dealloc];
}



#pragma mark -
#pragma mark mouse events

-(void)mouseDown:(CGPoint)point {
  _currentEventState = CGRectContainsPoint ( theSwitch.frame, point )  
                       ? PPcanDragSwitch : PPstandardMouseDown;

  if (_currentEventState == PPcanDragSwitch) {
    [theSwitch setContents:(__bridge_transfer id)clickedImgRef];
  }
  
  _mouseDownPointForCurrentEvent = point;
}

-(void)mouseUp:(CGPoint)point {
    [self switchSide];
    [theSwitch setContents:(__bridge_transfer id)notClickedImgRef];
}


-(void)mouseDragged:(CGPoint)point {
  
  if (_currentEventState == PPdragOccurred ||  _currentEventState == PPcanDragSwitch) {
    _currentEventState = PPdragOccurred;
    [self moveSwitch:point];    
  }
  
}

#pragma mark -
#pragma mark propertyMethods
-(void)setOn:(BOOL)on {
  if (_on == on ) { return; }
  _on = on;
  [self switchSide];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
  if (!animated) {
    [CATransaction begin];
    [CATransaction setValue:[NSNumber numberWithFloat:0] forKey:kCATransactionAnimationDuration];
  }
  [self setOn:on];    
  if (!animated) {
    [CATransaction commit];
  }  
}

@end

#pragma mark -
@implementation MondoSwitchButtonCALayer (PrivateMethods)

- (void) createtheSwitch {
  theSwitch = [CALayer layer];
//  [theSwitch retain];
  
  theSwitch.cornerRadius = cornerRadius;
  theSwitch.borderWidth = 0.5;


  
  // Sizing --
  // The Time Machine Switch on 10.6.2 has a sizing of 93px wide and 27px height.
  //                                   the internal switch is 40px wide or 
  theSwitch.frame = CGRectMake(0, 0, self.frame.size.height * (1 + 40/27), self.frame.size.height);
  
  [theSwitch addConstraint:AZConstraint(kCAConstraintMinY, @"superlayer")];
  [theSwitch addConstraint:AZConstraint(kCAConstraintHeight, @"superlayer")];    

  
  
  [self addSublayer:theSwitch];
  
  NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:NSRectFromCGRect(theSwitch.frame) 
                                                       xRadius:cornerRadius yRadius:cornerRadius];
  
  notClickedImgRef = [self switchImageForPath:path topColor:notClickedTopColor bottomColor:notClickedBotColor];
  clickedImgRef = [self switchImageForPath:path topColor:clickedTopColor bottomColor:clickedBotColor];
  
  [theSwitch setContents:(__bridge_transfer id)notClickedImgRef];
  
}

- (void) switchSide {
  CGRect newFrame = theSwitch.frame;
  CGFloat superWidth = CGRectGetWidth(self.frame);
    
  if (_currentEventState == PPdragOccurred) {
    CGFloat centre = CGRectGetWidth(self.frame) / 2;
    CGFloat buttonCentre = CGRectGetWidth(theSwitch.frame) / 2 + theSwitch.frame.origin.x;
    self.on = buttonCentre > centre ? YES : NO;
  } else {
    self.on = theSwitch.frame.origin.x == 0;
  }
    
  newFrame.origin.x = self.on ? superWidth - CGRectGetWidth(newFrame) : 0;
  
  theSwitch.frame = newFrame;    
  _currentEventState = PPNoEvent;  
}

- (BOOL)shouldDrag:(CGFloat)dx {
  
  // if delta negative and already to far left exit...
  if(dx < 0 && theSwitch.frame.origin.x <= 0 ) {
    return NO;
  }
  
  // if delta positive and already to far right exit...
  if (dx > 0 && theSwitch.frame.origin.x >= CGRectGetWidth(self.frame) - CGRectGetWidth(theSwitch.frame)) {
    return NO;
  }

  return YES;
}

- (void)moveSwitch:(CGPoint)point {
  // ignore the request if we are hidden
  if (self.hidden ) return;
  
  CGFloat dx = point.x - _mouseDownPointForCurrentEvent.x;
  
  if (![self shouldDrag:dx] ) { return; }
  
  
  CGRect newFrame = theSwitch.frame;
  CGFloat newX = theSwitch.frame.origin.x + dx;
  CGFloat maxX = CGRectGetWidth(self.frame) - CGRectGetWidth(theSwitch.frame);
  
  if (newX < 0) {
    newX = 0;
  } 
  if (newX > maxX) {
    newX = maxX;
  }
  
  newFrame.origin.x = newX;
  
  // Slider tracking should be immediate
  [CATransaction begin];
  {
    [CATransaction setValue:[NSNumber numberWithFloat:0] forKey:kCATransactionAnimationDuration];
    theSwitch.frame = newFrame;  
  }
  [CATransaction commit];
  
  _mouseDownPointForCurrentEvent = point;
}

- (CGImageRef)switchImageForPath:(NSBezierPath*)path topColor:(CGFloat)topColor  bottomColor:(CGFloat)bottomColor {  
  
  NSColor* gradientTop    = [NSColor colorWithCalibratedWhite:topColor alpha:1.0];
  NSColor* gradientBottom = [NSColor colorWithCalibratedWhite:bottomColor alpha:1.0];
  NSGradient *bgGradient = [[NSGradient alloc] initWithStartingColor:gradientBottom
                                                         endingColor:gradientTop];

  NSImage* buttonImage = [[NSImage alloc] initWithSize:[path bounds].size];
  [buttonImage lockFocus];
  {
    [bgGradient drawInBezierPath:path angle:90.0];
  }
  [buttonImage unlockFocus];
  
  CGImageRef imgRef = [buttonImage cgImageRef];//  [PPImageUtils createCGRefFromNSImage:];
//  [buttonImage release];
//  [bgGradient release];
  
  return imgRef;  
}


@end
