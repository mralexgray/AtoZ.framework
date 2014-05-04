
//  MondoSwitchButtonCALayer.m
//  CocoaMondoKit

//  Created by Matthieu Cormier on 12/8/09.
//  Copyright 2009 Preen and Prune Software and Design. All rights reserved.
#import "MondoSwitchButtonCALayer.h"
#import "AtoZ.h"
@implementation MondoSwitchButtonCALayer

// The grayscale values for the button colors.
static const CGF
  notClickedTopColor = 0.9921,
  notClickedBotColor = 0.9019,
  clickedTopColor = 0.8745,
  clickedBotColor = 0.9568,
  cornerRadius = 5.0;

@synthesize notClickedImgRef, clickedImgRef, theSwitch;

#pragma mark - init methods

- (id) init {
	if (self != super.init) return nil; //  self = CALayer.new;//[CALayer layer];
  self.autoresizingMask = kCALayerWidthSizable;
  self.cornerRadius = cornerRadius;
  self.borderWidth = 0;
  self.bounds       = AZRectFromDim(20);
  
  [self addConstraint:AZCACMinY];
  [self addConstraint:AZCACMinX];
  [self addConstraint:AZCACWide];
  [self addConstraint:AZCACHigh];
  [self setLayoutManager:AZLAYOUTMGR];
  [self createtheSwitch];
  _currentEventState = PPNoEvent;
  
  return self;
}

- (void) dealloc {
  CGImageRelease(notClickedImgRef);
  CGImageRelease(clickedImgRef);
//  [super dealloc];
}

#pragma mark - mouse events

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

#pragma mark - propertyMethods
-(void)setOn:(BOOL)on {
  if (_on == on ) return;
  _on = on;
  [self switchSide];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated {
	[CATransaction immediately:^{
    [self setOn:on];
  }];
}

@end

#pragma mark -
@implementation MondoSwitchButtonCALayer (PrivateMethods)

- (void) createtheSwitch {
  self.theSwitch = [CALayer layer];
  //  [theSwitch retain];
  theSwitch.cornerRadius = cornerRadius;
  theSwitch.borderWidth = 0.5;
  
  // Sizing -- The Time Machine Switch on 10.6.2 has a sizing of 93px wide and 27px height. the internal switch is 40px wide or
  theSwitch.frame = AZRectBy(self.frame.size.height * (1 + 40/27), self.frame.size.height);
  
  [theSwitch addConstraint:AZCACMinY];
  [theSwitch addConstraint:AZCACHigh];
  [self addSublayer:theSwitch];
  
  NSBezierPath* path = [NSBezierPath bezierPathWithRoundedRect:NSRectFromCGRect(theSwitch.frame) 
													   xRadius:cornerRadius yRadius:cornerRadius];
  
  notClickedImgRef = [self switchImageForPath:path topColor:notClickedTopColor bottomColor:notClickedBotColor];
  clickedImgRef = [self switchImageForPath:path topColor:clickedTopColor bottomColor:clickedBotColor];
  
  [theSwitch setContents:(__bridge_transfer id)notClickedImgRef];
  
}

- (void) switchSide {
  CGRect newFrame = theSwitch.frame;
  CGFloat superWidth = self.width;
	
//  self.on = _currentEventState == PPdragOccurred ?
//     /* buttonCentre */ theSwitch.mid.x + theSwitch.center.x > self.center.x /*centre */
//     : theSwitch.x == 0;

  newFrame.origin.x = _on ? superWidth - CGRectGetWidth(newFrame) : 0;
  
  theSwitch.frame = newFrame;	
  _currentEventState = PPNoEvent;  
}

- (BOOL)shouldDrag:(CGFloat)dx {
  
  // if delta negative and already to far left exit...
  return dx < 0 && theSwitch.x <= 0  ||
  // if delta positive and already to far right exit...
        dx > 0 && theSwitch.x >= self.width - theSwitch.width
        ? NO : YES;
}

- (void)moveSwitch:(CGPoint)point {
  // ignore the request if we are hidden
  if (self.hidden ) return;
  
  CGFloat dx = point.x - _mouseDownPointForCurrentEvent.x;
  
  if (![self shouldDrag:dx] ) { return; }
  
  
  CGRect newFrame = theSwitch.frame;
  CGFloat newX = theSwitch.frame.origin.x + dx;
  CGFloat maxX = CGRectGetWidth(self.frame) - CGRectGetWidth(theSwitch.frame);
  
	newX = newX < 0 ? 0 : newX > maxX ? maxX : maxX;
  newFrame.origin.x = newX;
  
  // Slider tracking should be immediate
  [CATransaction immediately:^{
    theSwitch.frame = newFrame;
  }];
  _mouseDownPointForCurrentEvent = point;
}

- (CGImageRef)switchImageForPath:(NSBezierPath*)path topColor:(CGFloat)topColor  bottomColor:(CGFloat)bottomColor {  
  

  NSGradient *bgGradient = [NSG gradientFrom:[NSColor white:bottomColor a:1.0] to:[NSC white:topColor a:1.0]];

  NSImage* buttonImage = [NSIMG imageWithSize:path.bounds.size drawnUsingBlock:^{

     [bgGradient drawInBezierPath:path angle:90.0];
  }];
  
  return [buttonImage CGImage];
}
@end
