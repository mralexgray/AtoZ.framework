#import "AZToggle.h"
#import "AtoZ.h"



// Change to YES to enable colored frames - useful for debugging layers layout
#define kGBEnableLayerDebugging YES
#define kGBDebugLayerBorderColor kGBEnableLayerDebugging ? CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 0.2f) : nil
#define kGBDebugLayerBorderWidth kGBEnableLayerDebugging ? 1.0f : 0.0f

@interface AZToggleView (UserInteraction)
- (AZToggleLayer*) 	toggleLayerForEvent:	(NSEvent*)event;
- (CGPoint) 		layerLocationForEvent:	(NSEvent*)event;
@end
@interface AZToggleView (CoreAnimation)

- (AZToggleLayer*) toggleLayerWithOnText:(NSString*)onText
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
	AZToggleLayer* hit = [self toggleLayerForEvent:event];
	if (hit) [hit reverseToggleState];
}

@end
#pragma mark -
@implementation AZToggleView (UserInteraction)

- (AZToggleLayer*) toggleLayerForEvent:(NSEvent*)event	{
	CALayer* hitLayer = [self.containerLayer hitTest:[self layerLocationForEvent:event]];
	while (hitLayer)	{	// Returns the first toggle layer for the given event.
		if ([hitLayer isMemberOfClass:[AZToggleLayer class]])
			return (AZToggleLayer*)hitLayer;
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

- (AZToggleLayer*) toggleLayerWithOnText:(NSString*)onText
								 offText:(NSString*)offText
							initialState:(BOOL)state
{ return [ self toggleLayerWithOnText:onText offText:offText initialState:state relativeTo:nil]; }

- (AZToggleLayer*) toggleLayerWithOnText:(NSString*)onText
								 offText:(NSString*)offText
							initialState:(BOOL)state
							  relativeTo:(NSString*)relative
{

	AZToggleLayer* result = [AZToggleLayer layer];
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





//start toghgle private methods.
@interface AZToggleLayer (Visuals)

@property (readonly) CGFloat contentsHeight;
@property (readonly) NSGradient* onBackGradient;
@property (readonly) NSGradient* offBackGradient;

@end

#pragma mark -

@interface AZToggleLayer (CoreAnimation)

@property (readonly) CALayer* thumbLayer;
@property (readonly) CALayer* onBackLayer;
@property (readonly) CALayer* offBackLayer;
@property (readonly) CATextLayer* onTextLayer;
@property (readonly) CATextLayer* offTextLayer;

@end

#pragma mark -

@implementation AZToggleLayer

#pragma mark Initialization & disposal

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		self.masksToBounds = YES;
		self.cornerRadius = 3.0f;
		self.borderWidth = 1.0f;
		self.borderColor = CGColorCreateGenericRGB(0.45f, 0.45f, 0.45f, 0.9f);
		self.layoutManager = self;
		
		[self addSublayer:self.onBackLayer];
		[self addSublayer:self.thumbLayer];
		[self addSublayer:self.offBackLayer];
		
		[self.onBackLayer setNeedsDisplay];
		[self.offBackLayer setNeedsDisplay];
	}
	return self;
}

- (void) dealloc
{
	onBackLayer = nil;
	offBackLayer = nil;
}

#pragma mark Toggle state handling

- (void) reverseToggleState
{
	self.toggleState = !self.toggleState;
}

- (BOOL) toggleState
{
	return toggleState;
}
- (void) setToggleState:(BOOL)value
{
	if (value != toggleState)
	{
		toggleState = value;
		[self setNeedsLayout];
	}
}

- (NSString*) onStateText
{
	return self.onTextLayer.string;
}
- (void) setOnStateText:(NSString*)value
{
	self.onTextLayer.string = value;
}

- (NSString*) offStateText
{
	return self.offTextLayer.string;
}
- (void) setOffStateText:(NSString*)value
{
	self.offTextLayer.string = value;
}

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
	self.thumbLayer.bounds = CGRectMake(0.0f, 0.0f, contentsHeight, contentsHeight);
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
	if (layer == self.onBackLayer)
	{
		[self.onBackGradient drawInRect:layer.bounds angle:270.0f];
	}
	else if (layer == self.offBackLayer)
	{
		[self.offBackGradient drawInRect:layer.bounds angle:270.0f];
	}
	[NSGraphicsContext restoreGraphicsState];
}

@end

#pragma mark -

@implementation AZToggleLayer (Visuals)

- (CGFloat) contentsHeight
{
	return self.bounds.size.height - self.borderWidth * 2.0f;
}

- (NSGradient*) onBackGradient
{
	if (onBackGradient) return onBackGradient;
	NSColor *rcolor = RANDOMCOLOR;
	NSColor* top = rcolor;
	NSColor* bottom = [rcolor darker];
	//	colorWithDeviceRed:0.14f green:0.25f blue:0.90f alpha:0.85f];
	//	NSColor* bottom = [NSColor colorWithDeviceRed:0.00f green:0.52f blue:0.89f alpha:0.85f];
	onBackGradient = [[NSGradient alloc] initWithColorsAndLocations:top, 0.0f, bottom, 0.6f, nil];
	return onBackGradient;
}

- (NSGradient*) offBackGradient
{
	if (offBackGradient) return offBackGradient;
	NSColor* top = [NSColor colorWithDeviceRed:0.65f green:0.65f blue:0.65f alpha:0.85f];
	NSColor* bottom = [NSColor colorWithDeviceRed:0.85f green:0.85f blue:0.85f alpha:0.85f];
	offBackGradient = [[NSGradient alloc] initWithColorsAndLocations:top, 0.0f, bottom, 0.6f, nil];
	return offBackGradient;
}

@end

#pragma mark -

@implementation AZToggleLayer (CoreAnimation)

- (CALayer*) thumbLayer
{
	if (thumbLayer) return thumbLayer;
	thumbLayer = [CALayer layer];
	thumbLayer.name = @"thumb";
	
	thumbLayer.cornerRadius = 4.0f;
	thumbLayer.borderWidth = 0.5f;
	thumbLayer.borderColor = CGColorCreateGenericRGB(0.f, 0.f, 0.f, 1.0f);
	thumbLayer.backgroundColor = CGColorCreateGenericRGB(0.9f, 0.9f, 0.9f, 1.0f);
	
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
	onTextLayer.fontSize = 20;//[NSFont smallSystemFontSize];
	onTextLayer.font = (__bridge CFStringRef) @"Ubuntu Mono Bold";
	// @"Lucida Grande";
	//	[NSFont boldSystemFontOfSize:onTextLayer.fontSize];
	onTextLayer.alignmentMode = kCAAlignmentCenter;
	onTextLayer.truncationMode = kCATruncationEnd;
	onTextLayer.foregroundColor = CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 1.0f);
	onTextLayer.shadowColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
	onTextLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	onTextLayer.shadowRadius = 1.0f;
	onTextLayer.shadowOpacity = 0.5f;
	[onTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
														  relativeTo:@"superlayer"
														   attribute:kCAConstraintMidX]];
	[onTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
														  relativeTo:@"superlayer"
														   attribute:kCAConstraintMidY]];
	return onTextLayer;
}

- (CATextLayer*) offTextLayer
{
	if (offTextLayer) return offTextLayer;
	offTextLayer = [CATextLayer layer];
	offTextLayer.name = @"text";
	offTextLayer.string = @"OFF";
	offTextLayer.fontSize = 20;  // [NSFont smallSystemFontSize];
	offTextLayer.font =(__bridge CFStringRef) @"Ubuntu Mono Bold";
	// @"Lucida Grande";//[NSFont boldSystemFontOfSize:onTextLayer.fontSize];
	offTextLayer.alignmentMode = kCAAlignmentCenter;
	offTextLayer.truncationMode = kCATruncationEnd;
	offTextLayer.foregroundColor = CGColorCreateGenericRGB(0.2f, 0.2f, 0.2f, 1.0f);
	offTextLayer.shadowColor = CGColorCreateGenericRGB(1.0f, 1.0f, 1.0f, 1.0f);
	offTextLayer.shadowOffset = CGSizeMake(0.0f, 0.0f);
	offTextLayer.shadowRadius = 1.0f;
	offTextLayer.shadowOpacity = 0.5f;
	[offTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidX
														   relativeTo:@"superlayer"
															attribute:kCAConstraintMidX]];
	[offTextLayer addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMidY
														   relativeTo:@"superlayer"
															attribute:kCAConstraintMidY]];
	return offTextLayer;
}

@end



