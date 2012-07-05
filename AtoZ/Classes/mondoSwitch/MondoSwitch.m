//
//  MondoSwitch.m
//  CocoaMondoKit
//
//  Created by Matthieu Cormier on 12/7/09.
//  Copyright 2009 Preen and Prune Software and Design. All rights reserved.
//

#import "MondoSwitch.h"
#import "MondoSwitchButtonCALayer.h"
#import "AtoZ.h"


@interface MondoSwitch (PrivateMethods)
-(void)setupLayers;
-(CGPoint) pointForEvent:(NSEvent *) event;
-(void)coreAnimationDrawRect:(NSRect)dirtyRect;
-(BOOL)isRunningInIB;

-(NSGradient*)gradient;
-(void)setGradient:(NSGradient*)gradient;

@end

@implementation MondoSwitch

@synthesize on, target, action;


#pragma mark -
#pragma mark init methods

// Coder methods are necessary so that everything draws nicely
// in interface builder.
- (id)initWithCoder:(NSCoder *)decoder {
	if (self = [super initWithCoder:decoder] ) {
		[self setGradient:[decoder decodeObjectForKey:@"bgGradient"]];

	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[super encodeWithCoder:coder];
	[coder encodeObject:[self gradient] forKey:@"bgGradient"];
}

- (void)awakeFromNib {
	[self setupLayers];
}

-(NSGradient*)gradient {
	if( !_bgGradient) {
		// Create a basic gradient for the background
		NSColor* gradientBottom = [NSColor colorWithCalibratedWhite:0.72 alpha:1.0];
		NSColor* gradientTop    = [NSColor colorWithCalibratedWhite:0.46 alpha:1.0];

		_bgGradient = [[NSGradient alloc] initWithStartingColor:gradientBottom
													endingColor:gradientTop];
	}
	return _bgGradient;
}

-(void)setGradient:(NSGradient*)gradient {
	if (_bgGradient == gradient)
		return;
	AZAssign(_bgGradient, gradient);
}


-(void)setupLayers {

	// create a layer and match its frame to the view's frame
	self.wantsLayer = YES;

	mainLayer = self.layer;
	//  [mainLayer retain];
	mainLayer.name = @"mainLayer";

	CGRect viewFrame = NSRectToCGRect( self.frame );
	viewFrame.origin.y = 0;
	viewFrame.origin.x = 0;
	mainLayer.frame = viewFrame;

	mainLayer.delegate = self;

	// causes the layer content to be drawn in -drawRect:
	[mainLayer setNeedsDisplay];
	self.layer = mainLayer;

	CGFloat midX = CGRectGetMidX( mainLayer.frame );
	CGFloat midY = CGRectGetMidY( mainLayer.frame );


	// create a "container" layer for all content layers.
	// same frame as the view's master layer, automatically
	// resizes as necessary.
	CALayer *contentContainer = [CALayer layer];
	contentContainer.name = @"contentContainer";
	contentContainer.bounds           = mainLayer.bounds;
	contentContainer.delegate         = self;
	contentContainer.anchorPoint      = CGPointMake(0.5,0.5);
	contentContainer.position         = CGPointMake( midX, midY );
	contentContainer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	[contentContainer setLayoutManager:[CAConstraintLayoutManager layoutManager]];
	[self.layer addSublayer:contentContainer];

	buttonLayer = [MondoSwitchButtonCALayer layer];
	buttonLayer.name = @"switchLayer";
	//  [buttonLayer retain];

	[contentContainer addSublayer:buttonLayer];

	[contentContainer layoutSublayers];
	[contentContainer layoutIfNeeded];

	[self bind:@"on" toObject:buttonLayer withKeyPath:@"on" options:nil];
}



- (void)drawRect:(NSRect)dirtyRect {
	// The logic is pushed to another operation so that
	// this logic can still be overridden in Interface Builder
	// but still used in the Cocoa Simulator.
	// See MondoSwitchIntegration.m
	[self coreAnimationDrawRect:dirtyRect];
}

-(void)coreAnimationDrawRect:(NSRect)dirtyRect {
	
	// There is probably a better way to do this, but it works.
	// When adding the switch to a tabbed preference pane, and
	// it's parent view is removed, something sets the mainLayer
	// to null.  This guarantees that the initially setup mainLayer
	// is always in use.
	if (self.layer != mainLayer) {
		self.layer = mainLayer;
	}
	
	// Everything else is handled by core animation
	CGFloat radius = 5.0;
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:dirtyRect
														 xRadius:radius
														 yRadius:radius];
	[[self gradient] drawInBezierPath:path angle:90.0];
	
	NSColor* borderColor = [NSColor colorWithCalibratedWhite:0.27 alpha:1.0];
	[borderColor set];
	[path stroke];
}



#pragma mark -
#pragma mark propertyMethods

-(void)setOn:(BOOL)newState {
	[self setOn:newState animated:YES];
}

-(void)setOn:(BOOL)newState animated:(BOOL)animated {
	if (on == newState) { return; }
	on = newState;
	[target performSelector:action];
	[buttonLayer setOn:newState animated:animated];
}

#pragma mark -
#pragma mark mouse methods

- (void) mouseDown: (NSEvent *) event {

	// ignore double clicks
	if ([event clickCount] > 1 ) { return; }

	CGPoint location = [self pointForEvent:event];
	[buttonLayer mouseDown:location];
}

- (void)mouseUp:(NSEvent *)event {
	// ignore double clicks
	if ([event clickCount] > 1 ) { return; }

	CGPoint location = [self pointForEvent:event];
	[buttonLayer mouseUp:location];
}

- (void)mouseDragged:(NSEvent *)event {
	CGPoint location = [self pointForEvent:event];
	[buttonLayer mouseDragged:location];
}

- (CGPoint) pointForEvent:(NSEvent *) event {
	NSPoint location = [self convertPoint:[event locationInWindow] fromView:nil];
	return NSPointToCGPoint(location);
}

//- (void) dealloc {
//	AZRelease(mainLayer);
//	AZRelease(buttonLayer);
//	AZRelease(_bgGradient);
//	AZRelease(target);
//	//  [super dealloc];
//}


@end
