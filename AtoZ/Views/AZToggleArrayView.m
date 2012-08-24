//  ContentsView.m
//  CoreAnimationToggleLayer
//
//  Created by Tomaz Kragelj on 8.12.09.
//  Copyright (C) 2009 Gentle Bytes. All rights reserved.

#import <AtoZ/AtoZ.h>
//#import "AZToggleControlLayer.h"
#import "AZToggleArrayView.h"

// Change to YES to enable colored frames - useful for debugging layers layout
#define kGBEnableLayerDebugging NO
#define kGBDebugLayerBorderColor kGBEnableLayerDebugging ? CGColorCreateGenericRGB(1.0f, 0.0f, 1.0f, 0.3f) : nil
#define kGBDebugLayerBorderWidth kGBEnableLayerDebugging ? 3.0f : 0.0f

@interface AZToggleArrayView (UserInteraction)

- (AZToggleControlLayer*) toggleLayerForEvent:(NSEvent*)event;
- (CGPoint) layerLocationForEvent:(NSEvent*)event;

@end

//
//@implementation AZToggleArrayView
//
//- (id) layerForToggle:(AZToggle*)toggle {
//
//	[[toggle codableKeys]	CALayer *l = [CALayer layer];	return  itemW]
//}
//
//@end


#pragma mark -

@implementation AZToggleArrayView
@synthesize delegate = _delegate, rootLayer = _rootLayer, containerLayer = _containerLayer;

#pragma mark Initialization & disposal

- (void) awakeFromNib 	{
	self.layer = self.rootLayer;
	self.wantsLayer = YES;
}

#pragma mark NSView overrides

- (void) setFrame:(NSRect)frameRect	{

// Disable animations whie resizing view; this makes the behavior more consistent.
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	[super setFrame:frameRect];
	[CATransaction commit];
}

- (void) mouseDown:(NSEvent*)event
{
	AZToggleControlLayer* hit = [self toggleLayerForEvent:event];
	if (hit)  {
		BOOL stateNow =! hit.toggleState;
		if ([_delegate respondsToSelector:@selector(toggleStateDidChangeTo:InToggleViewArray:WithName:)])
			[_delegate toggleStateDidChangeTo:stateNow InToggleViewArray:self WithName:hit.name];

		[hit reverseToggleState];
	}
}

- (AZToggleControlLayer*) toggleLayerWithOnText:(NSString*)onText		offText:(NSString*)offText
								   initialState:(BOOL)state				  title: (NSString*)title	{

	AZToggleControlLayer* result = [AZToggleControlLayer layer];
	result.name = @"toggle"; //title
	result.toggleState = state;
	result.constraints = @[ 		AZConstRelSuperScaleOff(kCAConstraintMaxX,1,-5.0f),
								AZConstRelSuper(kCAConstraintMidY)	];

	if (onText) result.onStateText = onText;
	if (offText) result.offStateText = offText;
	[result setValue:@80.0f forKeyPath:@"frame.size.width"];
	[result setValue:@24.0f forKeyPath:@"frame.size.height"];
	return result;
}

- (CATextLayer*) itemTextLayerWithName:(NSString*)name  {

	CATextLayer* result = [CATextLayer layer];
	result.name = @"text";
	result.string = name;
	//	result.foregroundColor =  CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, .89f);
	//	result.fontSize = 18;//[NSFont systemFontSize];

	result.fontSize = ([_containerLayer respondsToSelector:@selector(fontSize)] ? (CGFloat)[[_containerLayer valueForKey:@"fontSize"]floatValue] : 18);
	// [NSFont smallSystemFontSize];
	result.font =(__bridge CFStringRef) @"Ubuntu Mono Bold";

	//	result.font = (__bridge CFTypeRef)[NSFont fontWithName:@"Ubuntu Mono Bold" size:18];
	// [NSFont systemFontOfSize:result.fontSize];(__bridge CFTypeRef)((id)
	result.alignmentMode = kCAAlignmentLeft;
	result.truncationMode = kCATruncationEnd;
	result.borderColor = kGBDebugLayerBorderColor;
	result.borderWidth = kGBDebugLayerBorderWidth;
	result.constraints = @[ //AZConstRelSuperScaleOff(kCAConstraintMinX, 1, 5),
							AZConstAttrRelNameAttrScaleOff(kCAConstraintMaxX,@"toggle", kCAConstraintMinX, 1, -5),
							AZConstRelSuper(kCAConstraintMidY)	];
							//	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX relativeTo:@"toggle" attribute:kCAConstraintMinX offset:-5.0f]];
	return result;
}

- (CALayer*) itemLayerWithName:(NSString*)name
					relativeTo:(NSString*)relative
						 index:(NSUInteger)index
{
	return [self itemLayerWithName:name relativeTo:relative onText:nil offText:nil state:NO index:index];
}

- (CALayer*) itemLayerWithName:(NSString*)name
					relativeTo:(NSString*)relative
						onText:(NSString*)onText
					   offText:(NSString*)offText
						 state:(BOOL)state
						 index:(NSUInteger)index
{
	CALayer* result = [CALayer layer];
	result.name = name;
	result.borderColor = kGBDebugLayerBorderColor;
	result.borderWidth = kGBDebugLayerBorderWidth;
	result.layoutManager = [CAConstraintLayoutManager layoutManager];
	result.constraints 	= @[ AZConstRelSuper(kCAConstraintMidX),
							AZConstRelSuperScaleOff( kCAConstraintWidth, 1, -10.0 ),
							AZConstAttrRelNameAttrScaleOff(kCAConstraintMaxY, relative,
							(index == 0) ? kCAConstraintMaxY : kCAConstraintMinY, 1,
							 (index == 0 ? -7.0f : -5.0f) ) ];
							 
	[result setValue:@30.0f forKeyPath:@"frame.size.height"];
	[result addSublayer:[self itemTextLayerWithName:name]];
	[result addSublayer:[self toggleLayerWithOnText:onText offText:offText initialState:state title:name]];
	return result;
}

- (CALayer*) containerLayer
{
	if (_containerLayer) return _containerLayer;
	_containerLayer = [CALayer layer];
	_containerLayer.name = @"container";
	_containerLayer.backgroundColor =  GRAY3.cgColor;//CGColorCreateGenericRGB(0.,0.,0.,1.);
	_containerLayer.borderColor   = kGBDebugLayerBorderColor;
	_containerLayer.borderWidth   = kGBDebugLayerBorderWidth;
	_containerLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	_containerLayer.constraints   = @[	AZConstRelSuper(kCAConstraintMidX),
										AZConstRelSuperScaleOff(kCAConstraintWidth, 1, 0), //-20f
										AZConstRelSuper(kCAConstraintMidY),
										AZConstRelSuperScaleOff(kCAConstraintHeight, 1, 0) ];//-20.0f

		// This is a bit of fast hacking; it would be better to use array of item names or similar.
		// Or in a real-world situation, the layers would be added by binding to a data source
		// and responding to changes.


	if ([_delegate respondsToSelector:@selector(itemsForToggleView:)]){
		NSArray *yesno = [_delegate itemsForToggleView:self];
		[yesno each:^(id obj, NSUInteger index, BOOL *stop) {

			NSString* rel = (index == 0 ? @"superlayer" : yesno[index-1]);
			[_containerLayer addSublayer:obj];
		}];
	} else {

		NSArray *yesno = [_delegate questionsForToggleView:self];

		[yesno each:^(id obj, NSUInteger index, BOOL *stop) {
			NSString* rel = (index == 0 ? @"superlayer" : yesno[index-1]);
			[_containerLayer addSublayer:[self itemLayerWithName:obj relativeTo:rel index:index]];
		}];
	}
		//	[containerLayer addSublayer:[self itemLayerWithName:@"Item 2" relativeTo:index:1]];
		//	[containerLayer addSublayer:[self itemLayerWithName:@"Click these 'buttons' to change state ->"
		//											 relativeTo:@"Item 2"
		//												 onText:@"1"
		//												offText:@"0"
		//												  state:YES
		//												  index:1]];

		//	[containerLayer addSublayer:[self itemLayerWithName:@"BIG first Initial?"
		//											 relativeTo:@"Click these 'buttons' to change state ->"
		//												 onText:@"YES!"
		//												offText:@"NO!"
		//												  state:YES
		//												  index:1]];
	return _containerLayer;
}

- (CALayer*) rootLayer
{
	if (_rootLayer) return _rootLayer;
	_rootLayer = [CALayer layer];
	_rootLayer.name = @"root";
	_rootLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	[_rootLayer addSublayer:self.containerLayer];
	return _rootLayer;
}


- (AZToggleControlLayer*) toggleLayerForEvent:(NSEvent*)event
{
		// Returns the first toggle layer for the given event.
	CALayer* hitLayer = [self.containerLayer hitTest:[self layerLocationForEvent:event]];
	while (hitLayer)
	{
		if ([hitLayer isMemberOfClass:[AZToggleControlLayer class]])
		{

			NSLog(@"toggled: %@", hitLayer.name);
			return (AZToggleControlLayer*)hitLayer;
		}
		hitLayer = hitLayer.superlayer;
	}
	return nil;
}

- (CGPoint) layerLocationForEvent:(NSEvent*)event
{
		// Returns the mouse location of the given event. This is where flipped view
		// coordinates should be considered for example, so instead of simply returning
		// the CGPoint, the result should be converted like this:
		//   NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
		//   point.y = self.bounds.size.height - point.y;
		//   return NSPointToCGPoint(point);
	return NSPointToCGPoint([self convertPoint:[event locationInWindow] fromView:nil]);
}

@end

#pragma mark -

//@implementation AZToggleArrayView (UserInteraction)
//
//
//@end

#pragma mark -


	//
	//  GBToggleLayer.m
	//  CoreAnimationToggleLayer
	//
	//  Created by Tomaz Kragelj on 9.12.09.
	//  Copyright (C) 2009 Gentle Bytes. All rights reserved.
	//
#import <AtoZ/AtoZ.h>
//#import "AZToggleControlLayer.h"

@interface AZToggleControlLayer (Visuals)

@property (readonly) CGFloat contentsHeight;
@property (readonly) NSGradient* onBackGradient;
@property (readonly) NSGradient* offBackGradient;

@end

#pragma mark -

@interface AZToggleControlLayer (CoreAnimation)

@property (readonly) CALayer* thumbLayer;
@property (readonly) CALayer* onBackLayer;
@property (readonly) CALayer* offBackLayer;
@property (readonly) CATextLayer* onTextLayer;
@property (readonly) CATextLayer* offTextLayer;

@end

#pragma mark -

@implementation AZToggleControlLayer

#pragma mark Initialization & disposal

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		self.masksToBounds = YES;
		self.cornerRadius = 3.0f;
		self.borderWidth = .30f;
		self.borderColor = GRAY9.cgColor;
			//CGColorCreateGenericRGB(0.45f, 0.45f, 0.45f, 0.9f);
		self.layoutManager = self;

		[self addSublayer:self.onBackLayer];
		[self addSublayer:self.thumbLayer];
		[self addSublayer:self.offBackLayer];

		[self.onBackLayer setNeedsDisplay];
		[self.offBackLayer setNeedsDisplay];
	}
	return self;
}

- (void) dealloc	{	onBackLayer = nil;	offBackLayer = nil;	}

#pragma mark Toggle state handling

- (void) reverseToggleState			{	self.toggleState = !self.toggleState;	}

- (BOOL) toggleState				{	return toggleState;						}

- (void) setToggleState:(BOOL)value	{

	if (value != toggleState)		{	toggleState = value;	[self setNeedsLayout];	}
}

- (NSString*) onStateText			{	return self.onTextLayer.string;				}

- (void) setOnStateText:(NSString*)value	{	self.onTextLayer.string = value;	}

- (NSString*) offStateText			{	return self.offTextLayer.string;		}

- (void) setOffStateText:(NSString*)value	{	self.offTextLayer.string = value;	}

#pragma mark CALayoutManager handling

- (void) layoutSublayersOfLayer:(CALayer*)layer
{
		// Prepare common values. Note that we want to extend the state background layers
		// below the thumb rounded corner; if not, the background would become visible.
	CGFloat contentsHeight = self.contentsHeight;
	CGFloat stateWidth = self.bounds.size.width - contentsHeight;
	CGFloat stateDrawExtra = self.thumbLayer.cornerRadius / 2.0f;

		// This is the actual part that toggles the state. It works because we mask to bounds.
		// Note that the coordinates are calculated regarding the anchor points specified when
		// the layers were created.
	CGFloat left = self.toggleState ? 0.0f : -stateWidth;
	CGFloat middle = self.bounds.size.height / 2.0f;

		// The positioning part is very simple once we determined the layout. Note that this
		// part also updates state background and thumb layer sizes when the parent layer
		// is resized (layout is automatically invoked in such case).
	self.onBackLayer.bounds = CGRectMake(0.0f, 0.0f, stateWidth + stateDrawExtra, contentsHeight);
	self.onBackLayer.position = CGPointMake(left, middle);
	left += stateWidth;
	self.thumbLayer.bounds = CGRectMake(0.0f, 0.0f, contentsHeight*1.3, contentsHeight);
	self.thumbLayer.position = CGPointMake(left, middle);
	left += contentsHeight - stateDrawExtra;
	self.offBackLayer.bounds = CGRectMake(0.0f, 0.0f, stateWidth + stateDrawExtra, contentsHeight);
	self.offBackLayer.position = CGPointMake(left, middle);
}

#pragma mark Drawing handling

- (void) drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
	[NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:context flipped:NO]];
	if (layer == self.onBackLayer)			[self.onBackGradient drawInRect:layer.bounds angle:270.0f];
	else if (layer == self.offBackLayer)	[self.offBackGradient drawInRect:layer.bounds angle:270.0f];
	[NSGraphicsContext restoreGraphicsState];
}

@end

#pragma mark -

@implementation AZToggleControlLayer (Visuals)

- (CGFloat) contentsHeight { 	return self.bounds.size.height - self.borderWidth * 2.0f;	}

- (NSGradient*) onBackGradient
{
	if (onBackGradient) return onBackGradient;
	NSColor* top = GREEN.darker;// [NSColor colorWithDeviceRed:0.14f green:0.25f blue:0.90f alpha:0.85f];
	NSColor* bottom = GREEN.brighter;//[NSColor colorWithDeviceRed:0.00f green:0.52f blue:0.89f alpha:0.85f];
	onBackGradient = [[NSGradient alloc] initWithColorsAndLocations:top, 0.0f, bottom, 0.6f, nil];
	return onBackGradient;
}

- (NSGradient*) offBackGradient	{
	if (offBackGradient) return offBackGradient;
	NSColor* top = [NSColor colorWithDeviceRed:0.65f green:0.65f blue:0.65f alpha:0.85f];
	NSColor* bottom = [NSColor colorWithDeviceRed:0.85f green:0.85f blue:0.85f alpha:0.85f];
	offBackGradient = [[NSGradient alloc] initWithColorsAndLocations:top, 0.0f, bottom, 0.6f, nil];
	return offBackGradient;
}

@end

#pragma mark -

@implementation AZToggleControlLayer (CoreAnimation)

- (CALayer*) thumbLayer
{
	if (thumbLayer) return thumbLayer;
	thumbLayer = [CALayer layer];
	thumbLayer.name = @"thumb";

	thumbLayer.cornerRadius = 5.0f;
	thumbLayer.borderWidth = 1.f;
	thumbLayer.borderColor = GRAY2.cgColor;
	thumbLayer.backgroundColor = GRAY9.cgColor;

	thumbLayer.anchorPoint = CGPointMake(0.0f, 0.5f);	// This makes layout easier.
	thumbLayer.zPosition = 50.0f;	// Make this layer top-most within the sublayers.
	return thumbLayer;
}

- (CALayer*) onBackLayer
{
	if (onBackLayer) return onBackLayer;
	onBackLayer = [CALayer layer];
	onBackLayer.name = @"onback";
	onBackLayer.delegate = self;
	onBackLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	onBackLayer.anchorPoint = CGPointMake(0.0f, 0.5f);	// This makes layout easier.
	[onBackLayer addSublayer:self.onTextLayer];
	return onBackLayer;
}

- (CALayer*) offBackLayer
{
	if (offBackLayer) return offBackLayer;
	offBackLayer = [CALayer layer];
	offBackLayer.delegate = self;
	offBackLayer.name = @"offback";
	offBackLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	offBackLayer.anchorPoint = CGPointMake(0.0f, 0.5f);	// This makes layout easier.
	[offBackLayer addSublayer:self.offTextLayer];
	return offBackLayer;
}

- (CATextLayer*) onTextLayer
{
	if (onTextLayer) return onTextLayer;
	onTextLayer = [CATextLayer layer];
	onTextLayer.name = @"text";
	onTextLayer.string = @"ON";
	onTextLayer.fontSize = 20;  // [NSFont smallSystemFontSize];
	onTextLayer.font =	(__bridge CFStringRef) @"Ubuntu Mono Bold";	onTextLayer.alignmentMode = kCAAlignmentCenter;
	onTextLayer.truncationMode 	= 	kCATruncationEnd;
	onTextLayer.foregroundColor = 	cgWHITE;
	onTextLayer.shadowColor 		= 	cgBLACK;
	onTextLayer.shadowOffset 	= 	(CGSize){0,0};
	onTextLayer.shadowRadius 	= 	1. ;
	onTextLayer.shadowOpacity 	= 	.8 ;
	onTextLayer.constraints		=   @[	AZConstRelSuper(kCAConstraintMidX),AZConstRelSuper(kCAConstraintMidY) ];
	return onTextLayer;
}

- (CATextLayer*) offTextLayer
{
	if (offTextLayer) return offTextLayer;
	offTextLayer = [CATextLayer layer];
	offTextLayer.name = @"text";
	offTextLayer.string = @"OFF";

	offTextLayer.fontSize = 19;//[NSFont smallSystemFontSize];
	offTextLayer.font = (__bridge CFStringRef) @"Ubuntu Mono Bold";
	offTextLayer.alignmentMode 		= kCAAlignmentCenter;
	offTextLayer.truncationMode 	= kCATruncationEnd;
	offTextLayer.foregroundColor 	= GRAY1.CGColor;// CGColorCreateGenericRGB(0.2f, 0.2f, 0.2f, 1.0f);
	offTextLayer.shadowColor 		= CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 1.0f);
	offTextLayer.shadowOffset 		= CGSizeMake(0.0f, 0.0f);
	offTextLayer.shadowRadius 		= 1.0f;
	offTextLayer.shadowOpacity 		= 0.9f;
	offTextLayer .constraints		=   @[	AZConstRelSuper(kCAConstraintMidX),AZConstRelSuper(kCAConstraintMidY) ];
	return offTextLayer;
}

@end
