#import "AZToggle.h"
#import "AtoZ.h"

//start toghgle private methods.
@interface GBToggleLayer (Visuals)

@property (readonly) CGFloat contentsHeight;
@property (readonly) NSGradient* onBackGradient;
@property (readonly) NSGradient* offBackGradient;

@end

#pragma mark -

@interface GBToggleLayer (CoreAnimation)

@property (readonly) CALayer* thumbLayer;
@property (readonly) CALayer* onBackLayer;
@property (readonly) CALayer* offBackLayer;
@property (readonly) CATextLayer* onTextLayer;
@property (readonly) CATextLayer* offTextLayer;

@end

#pragma mark -

@implementation GBToggleLayer

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

@implementation GBToggleLayer (Visuals)

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

@implementation GBToggleLayer (CoreAnimation)

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



