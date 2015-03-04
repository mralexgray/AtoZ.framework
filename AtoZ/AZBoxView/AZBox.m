#import "AZBox.h"
#import <AtoZ/AtoZ.h>
@interface AZBox ()
@prop_RO float dynamicStroke;
@end

@implementation AZBox
{
	NSTrackingArea *tArea;		NSBezierPath *standard;
 	float mPhase;  				float all;
	NSTextView *tv;			NSTimer *timer;
	NSButton *close;
	NSImage *image;
	NSColor *color;
}
@synthesize cellIdentifier, dynamicStroke, index;
@synthesize inset = inset_,
			radius = radius_,
			hovered = hovered_,
//			selected = selected_,
			representedObject = representedObject_;

- (id)initWithFrame:(NSRect)frame representing:(id)object atIndex:(NSUInteger)anIndex {
	if ((self = [super initWithFrame:frame] )) {
		[self defaults];
		close = [[NSButton alloc]initWithFrame:NSMakeRect(0,0,10,10)];
		[close setButtonType:NSRegularSquareBezelStyle];
		[close setAction:@selector(removeFromSuperview)];
		[close setTarget:self];
		[self addSubview:close];
		self.representedObject = object;
		self.index = anIndex;
	}
	return self;
}
- (void) defaults {
	self.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
	self.hovered = NO;
	self.selected = NO;
//	self.representedObject = nil;
//	gradient = nil;
	all = 0;
	color = PURPLE;
	mPhase = 0;
	[self dynamicStuff];
}

-(void) dynamicStuff {

	self.inset = self.dynamicStroke;
	self.radius = self.dynamicStroke;
	if (tArea) { [self removeTrackingArea:tArea]; tArea = nil; }
	tArea = [[NSTrackingArea alloc]initWithRect:self.bounds options:NSTrackingMouseMoved | NSTrackingActiveAlways 	 owner:self userInfo:nil];
	[self addTrackingArea:tArea];
}

- (id)initWithReuseIdentifier:(NSString *)anIdentifier {
	if((self = [super initWithFrame:NSZeroRect]))	 {
		[self defaults];
		cellIdentifier = anIdentifier;
	}
	return self;
}

- (void) setRepresentedObject:(id)representedObject {
	representedObject_ = representedObject;
	if ( [representedObject_ isKindOfClass:[AZFile class]] ){
		AZFile *c = representedObject_;
//		gradient = [NSGradient.alloc initWithStartingColor:c.color.brighter.brighter endingColor:c.color.darker.darker];
		color = c.color;
		image = [ c.image coloredWithColor:c.color.contrastingForegroundColor];
//		NSImage *ci =  (selected_ ? [ c.image tintedWithColor:c.color] : c.image);
		[image setScalesWhenResized: YES];
	}
	if ( [representedObject_ isKindOfClass:[NSIMG class]] ){
		color = RANDOMCOLOR;
		image = representedObject_;
		[image setScalesWhenResized: YES];
	}

	//		self.color = [representedObject_ valueForKey:@"color"];
	//	} else { NSColor *r = RANDOMCOLOR;
	//		while ( (![r isRedish]) || ([r isBoring]) ) r = RANDOMCOLOR;
	//		self.color = r;
	//	}
	//	if ([representedObject_ isKindOfClass:[NSImage class]]) self.image = representedObject_;
	//	if ([representedObject_ valueForKeyPath:@"dictionary.color"] )
	//		self.color = [representedObject_ valueForKeyPath:@"dictionary.color"];
	//	tv = self.tv;//	[self makeTv];
	//	[self addSubview:tv];
}
- (void) andleAntAnimationTimer:(NSTimer*)timer {
	mPhase = (mPhase < [self halfwayWithInset] ? mPhase + [self halfwayWithInset]/128 : 0);
	[self setNeedsDisplayInRect:NSInsetRect(self.bounds, self.inset, self.inset)];
}
- (float) dynamicStroke {
//	NSBezierPath *bez = [self pathWithInset:self.inset];
//	if (bez.bounds) {
//		NSLog(@"BEZ: %@", NSStringFromRect( bez.bounds));
//		return (.1 * MIN((int)bez.bounds.size.width, (int)bez.bounds.size.height) );
//	} else
	return 5;
}
- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		tArea = [NSTrackingArea.alloc initWithRect:[self frame]
			options:[self trackoptions] owner:self userInfo:nil];
		[self addTrackingArea:tArea];
	}
	return self;
}

- (NSTrackingAreaOptions) trackoptions {
	return (
			NSTrackingInVisibleRect | NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow  | NSTrackingActiveAlways | NSTrackingMouseMoved);
}
- (void) updateTrackingAreas{

	[super updateTrackingAreas];
	if (tArea)
	[self removeTrackingArea:tArea];
	tArea = [NSTrackingArea.alloc initWithRect:NSZeroRect options:[self trackoptions] owner:self userInfo:nil];
	[self addTrackingArea:tArea];

}

- (float) halfwayWithInset {
	NSRect dim = NSInsetRect(self.bounds, self.inset, self.inset);
	return ( (2*dim.size.width) + (2*dim.size.height) - (( 8 - ((2 * pi) * self.radius))));
}

- (NSBezierPath*) pathWithInset:(float)anInset {

//	if (MIN(self.bounds.size.width, self.bounds.size.height) < anInset * 2) return nil; else
	return [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds, anInset, anInset) xRadius:self.radius yRadius:self.radius];
}

- (NSTextView*) tv {
	NSColor *theColor = [self.representedObject valueForKey:@"color"];
	if (theColor == nil) return nil;
	float hue = [theColor hueComponent];
	float sat = [theColor saturationComponent];
	float lum = [theColor luminance];
	NSMutableAttributedString *string = [NSMutableAttributedString.alloc initWithString: $(@"H:%0.1f\nS:%0.1f\nL:%0.1f", hue,sat,lum) attributes:$map(
			[NSFont fontWithName:@"Ubuntu Mono Bold" size:15],
			NSFontAttributeName, BLACK, NSForegroundColorAttributeName)];
	NSMutableParagraphStyle *theStyle =NSMutableParagraphStyle.new;
	[theStyle setLineSpacing:12];
	NSTextView *atv = [[NSTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
	[atv setDefaultParagraphStyle:theStyle];
	[atv setBackgroundColor:CLEAR];
	[[atv textStorage] setForegroundColor:BLACK];
	[[atv textStorage] setAttributedString:string];
	return atv;
}

- (void) drawRect:(NSRect)dirtyRect
{
//	[NSGraphicsContext saveGraphicsState];
	//		NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:_radius yRadius:_radius];
	//		[outerClip setClip];
	//		NSGradient *outerGradient = [NSGradient.alloc initWithColorsAndLocations: [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.0f,  [NSColor colorWithDeviceWhite:0.21f alpha:1.0f], 1.0f,  nil];
	//		[outerGradient drawInRect:[outerClip bounds] angle:90.0f]; }
	standard = [self pathWithInset:self.inset];
//	if ( standard ) {
//	[standard setLineWidth:0];
//	if (gradient) {
//		[CLEAR set];
/**		[NSShadow setShadowWithOffset:NSMakeSize(3,-3) blurRadius:self.inset color:BLACK];
		[standard stroke];
		[NSShadow clearShadow];
*/
//		NSRectFill(NSInsetRect(self.bounds,inset_, inset_));
//		[gradient drawInBezierPath:standard angle:270];
//	}
	if ( [representedObject_ isKindOfClass:[AZFile class]] ){
		AZFile *c = representedObject_;

		if (c.colors) {
			__block int totes = c.colors.count;
			__block float boxWide = (self.bounds.size.width - 4*inset_) / totes ;
			[[c.colors valueForKeyPath:@"color"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
				NSColor *x = obj;
				[x set];
				NSRectFillUsingOperation( NSMakeRect(
					( 2 * inset_)+ (idx*boxWide), self.bounds.size.height - boxWide - (3 * inset_), boxWide, boxWide) , NSCompositeSourceOver);
			}];

		}

		float halfW = self.bounds.size.width/2;
		float halfH = self.bounds.size.height/2;
		float smallest = MIN(halfH,halfW);
		[image setSize: NSMakeSize(smallest, smallest)];
		[image compositeToPoint:AZCenterOfRect([self bounds]) operation:NSCompositeSourceOver]; //  NSMakePoint(halfW/2+self.inset,halfH/2+self.inset)
	}
	//		[[NSColor colorWithDeviceWhite:0.12f alpha:1.0f] setStroke];
//		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect([self bounds], 1.5f, 1.5f) xRadius:self.radius yRadius:self.radius] stroke];
//		[[NSColor colorWithDeviceWhite:1.0f alpha:0.1f] setStroke];
//		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect([self bounds], 2.5f, 2.5f) xRadius:self.radius yRadius:self.radius] stroke];
	if(hovered_) {
//		[standard setClip];
		[[WHITE colorWithAlphaComponent:.3] set];
		NSRectFillUsingOperation([self bounds], NSCompositePlusLighter);
		}
//		[standard fillGradientFrom: RANDOMCOLOR to:RANDOMCOLOR angle:270];
//		NSRectFillUsingOperation([self bounds], NSCompositeSourceOver);
	else if(self.selected) // && drawSelection)
	{
		[standard setLineWidth:self.dynamicStroke/2];
//		[standard setLineJoinStyle:NSBevelLineJoinStyle];
		[standard setLineCapStyle:NSButtLineCapStyle];//NSSquareLineCapStyle];//NSRoundLineCapStyle];//
		[WHITE set];
		[standard strokeInside];
		// strokeInsideWithinRect:NSInsetRect([self bounds], inset_*2, inset_*2)];
		float slice = ([self halfwayWithInset]/32);
		CGFloat dashArray[2] = { slice, slice};
		[standard setLineDash:dashArray count:2 phase:mPhase];
		[BLACK set];
		[standard strokeInside];
		//WithinRect:NSInsetRect([self bounds], inset_*2, inset_*2)];

		DrawLabelAtCenterPoint([representedObject_ valueForKey:@"name"], NSMakePoint(NSMidX(self.bounds),NSMidY(self.bounds)));
	}
	else {
	if (!color) color = RANDOMCOLOR;
		[color set];
		[standard setClip];
		NSRectFill(NSZeroRect);
	}
//	[NSGraphicsContext restoreGraphicsState];
	//	if (!tv) tv = self.tv; 	[self addSubview:tv]; }
}
- (void) setSelected:(BOOL)state {
	if (!state) [timer invalidate];
//	else { mPhase = 0; timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handleAntAnimationTimer:) userInfo:nil repeats:YES];
//	}
	[super setSelected:state];
	[self setNeedsDisplay:YES];
}
- (void) setInset:(CGFloat)inset {
	inset_ = inset;
	[self setNeedsDisplay:YES];
}
- (void) setHovered:(BOOL)hovered	{
//	NSLog(@"im that actual box..  my objectrep is:%@", representedObject_);
	hovered_ = hovered;
	[self setNeedsDisplay:YES];
}

-(void) mouseEntered:(NSEvent *)theEvent
{
	NSLog(@"entered the box. frame: %@", NSStringFromRect(self.frame));
	self.hovered = YES;
	[[[[self window]contentView]allSubviews]az_each:^(id obj, NSUInteger index, BOOL *stop) {
		if ( ([obj isKindOfClass:[AZBox class]]) && ([obj isNotEqualTo:self]) )
			[(AZBox*)obj setHovered:NO];
	}];
//	[self setNeedsDisplay:YES];
}
//-(void) mouseExited:(NSEvent *)theEvent {
//	self.hovered = NO;

//}

-(void) mouseDown:(NSEvent *)theEvent {
	self.selected = YES;
	[[[self superview]subviews]az_each:^(id obj, NSUInteger index, BOOL *stop) {
		if ( ([obj isKindOfClass:[AZBox class]]) && ([obj isNotEqualTo:self]) )
			[(AZBox*)obj setSelected:NO];
	}];
}

- (void) repareForReuse {
	self.selected = NO;
//	self.drawSelection = YES;
//	hovered_ = NO;
//	_image = nil;
}

//-(void) viewDidEndLiveResize {
//	if ((self.bounds.size.width <= .05) ||  (self.bounds.size.height <= .05) ) {
//		[self setNeedsDisplay:NO];
//	}// else [self dynamicStuff];
//}

//		[self addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
//		[self addObserver:self forKeyPath:@"radius" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
//		[self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
//		[[self superview] addObserver:self forKeyPath:@"desiredNumberOfColumns" options:NSKeyValueObservingOptionOld context:nil];
//		[self addObserver:self forKeyPath:@"multiplier" options:NSKeyValueObservingOptionOld context:nil];
//	}
//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//	if (context == DotViewUndoAndRedisplay) {
//		NSUndoManager *undoManager = [[self window] undoManager];
//		if ([keyPath isEqual:@"center"]) [[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];
//		else if ([keyPath isEqual:@"radius"]) [[undoManager prepareWithInvocationTarget:self] setRadius:[[change objectForKey:NSKeyValueChangeOldKey] doubleValue]];
//		else if ([keyPath isEqual:@"color"]) [undoManager registerUndoWithTarget:self selector:@selector(setColor:) object:[change objectForKey:NSKeyValueChangeOldKey]];
//	if ([keyPath isEqual:@"multiplier"]) {
//	if ([keyPath isEqual:@"desiredNumberOfColumns"]) {
//	[[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];
//-(void) setMultiplier:(float)amultiplier {
// 	multiplier = amultiplier;
//	NSRect r = AZScaleRect([self frame], multiplier);
//	[self setFrame:r];
//	[self setNeedsDisplay:YES];
//}
@end

