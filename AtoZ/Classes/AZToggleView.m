//
//  ContentsView.m
//  CoreAnimationToggleLayer
//
//  Created by Tomaz Kragelj on 8.12.09.
//  Copyright (C) 2009 Gentle Bytes. All rights reserved.
//

//#import "GBToggleLayer.h"
#import "AZToggleView.h"



// Change to YES to enable colored frames - useful for debugging layers layout
#define kGBEnableLayerDebugging YES
#define kGBDebugLayerBorderColor kGBEnableLayerDebugging ? CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 0.2f) : nil
#define kGBDebugLayerBorderWidth kGBEnableLayerDebugging ? 1.0f : 0.0f

@interface AZToggleView (UserInteraction)
- (GBToggleLayer*) 	toggleLayerForEvent:	(NSEvent*)event;
- (CGPoint) 		layerLocationForEvent:	(NSEvent*)event;
@end
@interface AZToggleView (CoreAnimation)

- (GBToggleLayer*) toggleLayerWithOnText:(NSString*)onText 
								 offText:(NSString*)offText 
							initialState:(BOOL)state;

- (CATextLayer*) 	itemTextLayerWithName:	(NSString*)name;
- (CALayer*) 		itemLayerWithName:		(NSString*)name relativeTo:(NSString*)relative index:(NSUInteger)index;

- (CALayer*) itemLayerWithName:	(NSString*)name 
					relativeTo:	(NSString*)relative 
						onText:	(NSString*)onText 
					   offText:	(NSString*)offText 
						 state:	(BOOL)state
						 index:	(NSUInteger)index;

@property (readonly) CALayer* containerLayer;
@property (readonly) CALayer* rootLayer;

@end

#pragma mark -

@implementation AZToggleView

#pragma mark Initialization & disposal

- (void) awakeFromNib	{
	self.layer = self.rootLayer;
	self.wantsLayer = YES;
}

#pragma mark NSView overrides
- (void) setFrame:(NSRect)frameRect	{
	[CATransaction begin];	// Disable animations whie resizing view; this makes the behavior more consistent.
	[CATransaction setValue:	 (id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	[super setFrame:frameRect];
	[CATransaction commit];
}

- (void) mouseDown:(NSEvent*)event	{
	GBToggleLayer* hit = [self toggleLayerForEvent:event];
	if (hit) [hit reverseToggleState];
}

@end
#pragma mark -
@implementation AZToggleView (UserInteraction)

- (GBToggleLayer*) toggleLayerForEvent:(NSEvent*)event	{
	CALayer* hitLayer = [self.containerLayer hitTest:[self layerLocationForEvent:event]];
	while (hitLayer)	{	// Returns the first toggle layer for the given event.
		if ([hitLayer isMemberOfClass:[GBToggleLayer class]])
			return (GBToggleLayer*)hitLayer;
		hitLayer = hitLayer.superlayer;
	}
	return nil;
}

- (CGPoint) layerLocationForEvent:(NSEvent*)event	{
	// Returns the mouse location of the given event. This is where flipped view coordinates should be considered for example, so instead of simply returning the CGPoint, the result should be converted like this:
	//   NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
	//   point.y = self.bounds.size.height - point.y;
	//   return NSPointToCGPoint(point);
	return NSPointToCGPoint([self convertPoint:[event locationInWindow] fromView:nil]);
}

@end
#pragma mark -
@implementation AZToggleView (CoreAnimation)

- (GBToggleLayer*) toggleLayerWithOnText:(NSString*)onText 
								 offText:(NSString*)offText 
							initialState:(BOOL)state
{ return [ self toggleLayerWithOnText:onText offText:offText initialState:state relativeTo:nil]; }

- (GBToggleLayer*) toggleLayerWithOnText:(NSString*)onText 
								 offText:(NSString*)offText 
							initialState:(BOOL)state
							  relativeTo:(NSString*)relative
	{

	GBToggleLayer* result = [GBToggleLayer layer];
	result.name = @"toggle";
	result.toggleState = state;
	if (relative)
	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
													 relativeTo:relative
													  attribute:kCAConstraintMaxX
														 offset:5.0f]];
	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
													 relativeTo:@"superlayer"
													  attribute:kCAConstraintMidY]];
	if (onText) result.onStateText = onText;
	if (offText) result.offStateText = offText;
								
	CGFloat onwide = [onText sizeWithAttributes:$map( [NSFont fontWithName:@"Ubuntu Mono Bold" size:20], NSFontAttributeName)].width;
	CGFloat offwide = [offText sizeWithAttributes:$map( [NSFont fontWithName:@"Ubuntu Mono Bold" size:20], NSFontAttributeName)].width;
	CGFloat longwide = (onwide > offwide ? onwide :offwide );
//	offTextLayer.fontSize = 20;  // [NSFont smallSystemFontSize];
//					   offTextLayer.font =(__bridge CFStringRef) ;

	[result setValue:[NSNumber numberWithFloat:longwide/*70.0f*/] forKeyPath:@"frame.size.width"];
	[result setValue:[NSNumber numberWithFloat:25.0f] forKeyPath:@"frame.size.height"];
	return result;
}

- (CATextLayer*) itemTextLayerWithName:(NSString*)name
{
	CATextLayer* result = [CATextLayer layer];
	
	result.name = @"text";
	result.string = name;
	//	result.foregroundColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
	result.fontSize = 22;//[NSFont systemFontSize];
	result.foregroundColor = cgWHITE;
	//	result.font = [NSFont s*ystemFontOfSize:result.fontSize];
	result.font =(__bridge CFStringRef) @"Ubuntu Mono Bold";
	CGSize onwide = [name sizeWithAttributes:$map( [NSFont fontWithName:@"Ubuntu Mono Bold" size:22], NSFontAttributeName)];
	result.bounds = AZMakeRectFromSize(onwide);
	result.alignmentMode = kCAAlignmentLeft;
	result.truncationMode = kCATruncationEnd;
	result.borderColor = kGBDebugLayerBorderColor;
	result.borderWidth = kGBDebugLayerBorderWidth;
	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinX
													 relativeTo:@"superlayer"
													  attribute:kCAConstraintMinX
														 offset:5.0f]];
//	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxX
//													 relativeTo:@"toggle"
//													  attribute:kCAConstraintMinX
//														 offset:onwide.width]];//-5.0f]];
	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
													 relativeTo:@"superlayer"
													  attribute:kCAConstraintMidY]];
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
	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
													 relativeTo:@"superlayer"
													  attribute:kCAConstraintMidX]];
	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth
													 relativeTo:@"superlayer"
													  attribute:kCAConstraintWidth
														 offset:-10.0f]];
	[result addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY
													 relativeTo:relative
													  attribute:(index == 0) ? kCAConstraintMaxY : kCAConstraintMinY
														 offset:(index == 0) ? -2.0f : -1.0f]];
	[result setValue:[NSNumber numberWithFloat:40.0f] forKeyPath:@"frame.size.height"];
	[result addSublayer:[self itemTextLayerWithName:name]];
	[result addSublayer:[self toggleLayerWithOnText:onText offText:offText initialState:state relativeTo:name]];
	return result;
}

- (CALayer*) containerLayer
{
	if (containerLayer) return containerLayer;
	containerLayer = [CALayer layer];
	containerLayer.backgroundColor = [[[[GREY darker] darker]darker] CGColor];
	containerLayer.name = @"container";
	containerLayer.borderColor = kGBDebugLayerBorderColor;
	containerLayer.borderWidth = kGBDebugLayerBorderWidth;
	containerLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	[containerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
															 relativeTo:@"superlayer"
															  attribute:kCAConstraintMidX]];
	[containerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
															 relativeTo:@"superlayer"
															  attribute:kCAConstraintMidY]];
	//percent width in window
	[containerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth
															 relativeTo:@"superlayer"
															  attribute:kCAConstraintWidth
																  scale:1 offset:0]];
	[containerLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight
															 relativeTo:@"superlayer"
															  attribute:kCAConstraintHeight
																 offset:0]];
	
	// This is a bit of fast hacking; it would be better to use array of item names or similar.
	// Or in a real-world situation, the layers would be added by binding to a data source
	// and responding to changes.
	[containerLayer addSublayer:[self itemLayerWithName:@"Settings" relativeTo:@"superlayer" index:0]];
	[containerLayer addSublayer:[self itemLayerWithName:@"Colors" relativeTo:@"superlayer" onText:@"HORIZONTAL" offText:@"POOP" state:NO index:1]];
	[containerLayer addSublayer:[self itemLayerWithName:@"Hanky" relativeTo:@"Colors" onText:@"VAGEEN" offText:@"VILLAREAL" state:NO index:2]];
	//	[containerLayer addSublayer:[self itemLayerWithName:@"Click these 'buttons' to change state ->" 
	//											 relativeTo:@"Item 2" 
	//												 onText:@"HORIZONTAL" 
	//												offText:@"VERTICAL" 
	//												  state:YES
	//												  index:1]];
	return containerLayer;
}

- (CALayer*) rootLayer
{
	if (rootLayer) return rootLayer;
	rootLayer = [CALayer layer];
	rootLayer.name = @"root";
	rootLayer.layoutManager = [CAConstraintLayoutManager layoutManager];
	[rootLayer addSublayer:self.containerLayer];
	return rootLayer;
}

@end



