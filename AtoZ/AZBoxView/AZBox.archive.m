//  AZBox.m
#import "AZBox.h"
#import <AppKit/AppKit.h>
@interface AZBox ()
@property (readonly) float dynamicStroke;
@property (nonatomic, assign) NSInteger index;
//@property (assign) CGFloat mPhase;
//@property (readonly) float all;
@property (nonatomic, retain) NSTimer *timer;
@property (readonly) NSTextView *tv;
//@property (readonly) NSBezierPath *path;
//@property (strong) NSGradient *gradient;
@end
@implementation AZBox
{ float mPhase;  float all;  NSGradient *gradient;}
@synthesize index, 		cellIdentifier;
@synthesize hovered = hovered_, selected = selected_, 	tv;
@synthesize dynamicStroke;
@synthesize representedObject = representedObject_;
@synthesize radius = radius_;
@synthesize timer = timer_;

- (void)handleAntAnimationTimer:(NSTimer*)timer {
	float phase = mPhase;
	mPhase = (phase < all ? phase + (([self halfwayWithInset:2]/8)/4) : 0);
	[self setNeedsDisplay:YES];
}

- (float) dynamicStroke {
	return (.1 * MAX((int)[self pathWithInset:2].bounds.size.width, (int)[self pathWithInset:2].bounds.size.height) );
}
- (float) halfwayWithInset:(float)inset {
	return (   NSMaxY( NSInsetRect([self bounds], inset, inset) ) 
			 + NSMaxX( NSInsetRect([self bounds], inset, inset) ) 
			 - ( 2 * self.radius) 
			 + (.5 * (pi * ( 2 * self.radius))) );
}

- (NSBezierPath*) pathWithInset:(float)inset {
	return [NSBezierPath bezierPathWithRoundedRect:NSInsetRect([self bounds], inset, inset) xRadius:self.radius yRadius:self.radius];
}

//- (void) setColor:(NSColor *)color {
//	color_ = color;
//	[self setNeedsDisplay:YES]; 
//}

//- (NSGradient*) gradient {
//	return 
//}

- (NSTextView*) tv {
//	if ((!self.color) || (![self.representedObject valueForKey:@"color"])) return nil;
	NSColor *theColor = [self.representedObject valueForKey:@"color"];
	if (theColor == nil) return nil;
	float hue = [theColor hueComponent];
	float sat = [theColor saturationComponent];
	float lum = [theColor luminance];
	NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: $(@"H:%0.1f\nS:%0.1f\nL:%0.1f", hue,sat,lum) attributes:$map(
			[NSFont fontWithName:@"Ubuntu Mono Bold" size:15],
			NSFontAttributeName, BLACK, NSForegroundColorAttributeName)];
	NSMutableParagraphStyle *theStyle =[[NSMutableParagraphStyle alloc] init];
	[theStyle setLineSpacing:12];
	NSTextView *atv = [[NSTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
	[atv setDefaultParagraphStyle:theStyle];
	[atv setBackgroundColor:CLEAR];
	[[atv textStorage] setForegroundColor:BLACK];
	[[atv textStorage] setAttributedString:string];
	return atv;
	
}

- (void)drawRect:(NSRect)dirtyRect
{
	//	BOOL outer = NO;
//	BOOL background = YES;
//	BOOL stroke = NO;
//	BOOL innerStroke = NO;

//	NSRect frame = [self bounds];
	//	if(outer) {
	//		NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:_radius yRadius:_radius];
	//		[outerClip setClip];
	//		NSGradient *outerGradient = [[NSGradient alloc] initWithColorsAndLocations: [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.0f,  [NSColor colorWithDeviceWhite:0.21f alpha:1.0f], 1.0f,  nil];
	//		[outerGradient drawInRect:[outerClip bounds] angle:90.0f]; }
	NSBezierPath *standard = [self pathWithInset:2];
	[standard setLineWidth:self.dynamicStroke];
//	[NSGraphicsContext saveGraphicsState];
//	if(background) {
//		[[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] set];
//		[standard fill];
//		[NSShadow clearShadow];
//	}
	if (gradient)
		[NSShadow setShadowWithOffset:NSMakeSize(10,-8) blurRadius:10 color:BLACK];
		[gradient drawInBezierPath:standard angle:270];
		[NSShadow clearShadow];
//	if(stroke) {
//		[[NSColor colorWithDeviceWhite:0.12f alpha:1.0f] setStroke];
//		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect([self bounds], 1.5f, 1.5f) xRadius:self.radius yRadius:self.radius] stroke];
//	}
//	if(innerStroke) {
//		[[NSColor colorWithDeviceWhite:1.0f alpha:0.1f] setStroke];
//		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect([self bounds], 2.5f, 2.5f) xRadius:self.radius yRadius:self.radius] stroke];
//	}
	if(hovered_) {
///	[NSGraphicsContext saveGraphicsState];
//		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect([self frame], 2.0f, 2.0f) xRadius:radius yRadius:radius] 
//		[self.path setClip];
//		[[NSColor colorWithCalibratedWhite:0.0f alpha:0.35] set];
//		[standard fill];
		[standard fillGradientFrom:[BLACK colorWithAlphaComponent:.5] to:[BLACK colorWithAlphaComponent:.1] angle:90];
//		NSRectFillUsingOperation([self bounds], NSCompositeSourceOver);
//[NSGraphicsContext restoreGraphicsState];
	}
	
//	NSRect inRect = [self bounds];
//	NSRect srcRect = NSZeroRect;
//	srcRect.size = [_image size];
//	NSRect drawnRect = srcRect;
//	if(drawnRect.size.width > inRect.size.width)	{
//		drawnRect.size.height *= inRect.size.width/drawnRect.size.width;
//		drawnRect.size.width = inRect.size.width; }
//	if(drawnRect.size.height > inRect.size.height) {
//		drawnRect.size.width *= inRect.size.height/drawnRect.size.height;
//		drawnRect.size.height = inRect.size.height; }
//	drawnRect.origin = inRect.origin;
//	drawnRect.origin.x += (inRect.size.width - drawnRect.size.width)/2;
//	drawnRect.origin.y += (inRect.size.height - drawnRect.size.height)/2;
//	[_image drawInRect:drawnRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
	if(self.selected) // && drawSelection)
	{
		//		NSRect insidef = NSInsetRect(frame, 2.5f, 2.5f);
//		[selectionColor set];
//		NSRect insidef = [self bounds];//[self bounds];
									   //		NSBezierPath *path = [NSBezierPath bezierPathWithRect:insidef];
//		NSBezierPath *inside = [NSBezierPath bezierPathWithRoundedRect:insidef xRadius:radius yRadius:radius];
//		[inside setLineWidth:self.dynamicStroke];
		[standard setLineJoinStyle:NSBevelLineJoinStyle];
		[standard setLineCapStyle:NSSquareLineCapStyle];// NSRoundLineCapStyle];
		//			[(color.isDark ? color.brighter : color.darker) set];
		[WHITE set];
		[standard strokeInside];
		float bbox = [self halfwayWithInset:2];
		float slice = (bbox/8);
		CGFloat dashArray[4] = { slice, slice, slice, slice };
		[standard setLineDash:dashArray count:8 phase:mPhase];
		[BLACK set];
		[standard strokeInside];
		// strokeInsideWithinRect:insidef];
		
		//		[path setLineWidth:4.0];
		//		[path stroke];
		//		[NSGraphicsContext restoreGraphicsState];
	}
//	[NSGraphicsContext restoreGraphicsState];
	if (!tv) tv = self.tv;
	[self addSubview:tv];
	//	}
	//	[NSGraphicsContext restoreGraphicsState];
}


//- (void)setImage:(NSImage *)image {
//	_image = image;
//	[self setNeedsDisplay:YES];
//}

- (void)setSelected:(BOOL)state
{
	//	if (_hovered) {
	//		if (state)  { 
	//			[_timer invalidate];
	//			NSLog(@"%ld %s, was hit!  %@ Rep: %@", _tag,
	//				  _selected ? "SELECTED" : "NOT SELECTED",
	//				  NSStringFromRect(self.frame), _representedObject);			
	//			_all = 0;	
	//			selected = state; 
	//			[self setNeedsDisplay:YES];
	//		}
	//		else {
	if (!state) [self.timer invalidate]; 
	else { mPhase = 0; self.timer = [NSTimer scheduledTimerWithTimeInterval:.1
																   target:self 
																 selector:@selector(handleAntAnimationTimer:) 
																 userInfo:nil 
																  repeats:YES];
	}
	selected_ = state;
//	[self setNeedsDisplay:YES];
	//		}
	//	}		
	
	//	selected = state;	
	//	[self setNeedsDisplay:YES];
}

- (void)setHovered:(BOOL)hovered
{
	//	self.multiplier = (state ? 2 : .5 );
	hovered_ = hovered;
	[self setNeedsDisplay:YES];
}

- (void)prepareForReuse
{
//	_selected = NO;
//	self.drawSelection = YES;
	self.hovered = NO;
//	_image = nil;
}

//- (id)initWithFrame:(NSRect)frame {
//	if (self = [super initWithFrame:frame]) {
////		self.multiplier = 1; //AZCenterOfRect([self frame]);
//							 //		self.radius = 
//							 //		self.color = [NSColor redColor];
//							 //		[self addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
//							 //		[self addObserver:self forKeyPath:@"radius" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
//							 //		[self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
//		[[self superview] addObserver:self forKeyPath:@"desiredNumberOfColumns" options:NSKeyValueObservingOptionOld context:nil];
//		[self addObserver:self forKeyPath:@"multiplier" options:NSKeyValueObservingOptionOld context:nil];
//	}
//	return self;
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//	//	if (context == DotViewUndoAndRedisplay) {
//	//		NSUndoManager *undoManager = [[self window] undoManager];
//	//		if ([keyPath isEqual:@"center"]) [[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];
//	//		else if ([keyPath isEqual:@"radius"]) [[undoManager prepareWithInvocationTarget:self] setRadius:[[change objectForKey:NSKeyValueChangeOldKey] doubleValue]];
//	//		else if ([keyPath isEqual:@"color"]) [undoManager registerUndoWithTarget:self selector:@selector(setColor:) object:[change objectForKey:NSKeyValueChangeOldKey]];
//	//		[self setNeedsDisplay:YES];
//	//	}
////	if ([keyPath isEqual:@"multiplier"]) {
////		NSRect bounding = [self frame];
//		//		[[AtoZ sharedInstance] say: NSStringFromRect(bounding)];		
////	}
//	if ([keyPath isEqual:@"desiredNumberOfColumns"]) {
//		NSLog(@"desired cols updated!");
//	}
//	//	[[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];
//	
//	
//}

- (id)initWithReuseIdentifier:(NSString *)anIdentifier
{
	if((self = [super initWithFrame:NSZeroRect]))
	{
		cellIdentifier = anIdentifier;
//		selectionColor  = [NSColor whiteColor];
//		drawSelection   = YES;
//		color_ = RANDOMCOLOR;
		hovered_ = NO;
		selected_ = NO;
		representedObject_ = nil;
		gradient = nil;
		all = 0;
		mPhase = 0;
		radius_ = 5;
//		composite = NSCompositeSourceOver;
	}
	return self;
}

- (void)setRepresentedObject:(id)aRepresentedObject {
	representedObject_ = aRepresentedObject;
	if ( [representedObject_ isKindOfClass:[AZFile class]] ){
		AZFile *c = representedObject_;
		gradient = [[NSGradient alloc] initWithStartingColor:c.color.brighter.brighter endingColor:c.color.darker.darker];
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

//-(void) setMultiplier:(float)amultiplier {
// 	multiplier = amultiplier;
//	NSRect r = AZScaleRect([self frame], multiplier);
//	[self setFrame:r];
//	[self setNeedsDisplay:YES];
//}


@end

////
////  AZBox.m
////  AtoZ
//#import "AZBox.h"
//#import <AppKit/AppKit.h>



//@interface  AZLasso : NSView
//@property (assign, nonatomic) float radius;
//@property (assign, nonatomic) float mPhase;
//@property (retain, nonatomic) NSBezierPath *path;
//@end
//@implementation AZLasso
//{   NSTimer*timer;  	float _all; }
//@synthesize  radius, mPhase, path;
//	

//- (id)initWithFrame:(NSRect)frame andRadius:(CGFloat)rad {
// 	if (self = [super initWithFrame:frame]) {
//		radius = rad;
//		mPhase = 0;
//		timer = [NSTimer scheduledTimerWithTimeInterval:.05
//			target:self selector:@selector(handleAntAnimationTimer:) 
//		  userInfo:nil   repeats:YES];
//		path = self.path;

//	}
//	return self;
//}

//-(NSBezierPath *) path {
//	path = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:radius yRadius:radius];
//	[path setLineWidth:[(AZBox*)[self superview] dynamicStroke]];
//	[path setLineCapStyle:NSRoundLineCapStyle];	
//	return path;
//}

//- (void)handleAntAnimationTimer:(NSTimer*)timer {
//	self.mPhase = (mPhase < _all ? mPhase + ((_all/8)/4) : 0);
//	[self setNeedsDisplay:YES];
//}

//- (void) drawRect:(NSRect)dirtyRect {


//								//		NSBezierPath *path = [NSBezierPath bezierPathWithRect:insidef];
//	_all = ( NSMaxY([self bounds]) + NSMaxX([self bounds])  - (2* radius) + (.5* (pi *(2*radius))) );
//	//			[(color.isDark ? color.brighter : color.darker) set];
//	[BLACK set];
//	[path strokeInsideWithinRect:[self bounds]];
//	CGFloat dashArray[4] = { (_all/4), (_all/4), (_all/4), (_all/4) };
//	[path setLineDash:dashArray count:4 phase:mPhase];
//	[WHITE set];
//	[path strokeInsideWithinRect:[self bounds]];

//}
//@end

//@interface AZBox ()
//@property (nonatomic, assign) NSInteger index;
//@property (assign) CGFloat mPhase;
//@property (nonatomic, retain) NSTimer *timer;
//@property (nonatomic, retain) AZLasso *lasso;
//@end

//@implementation AZBox {

//}
//@synthesize index, 		cellIdentifier, 	imageCache;
//@synthesize selected, 	drawSelection, 		selectionColor;
//@synthesize hovering, 	dynamicStroke;
//@synthesize color, 		representedObject;
//@synthesize radius, 	composite;
//@synthesize gradient, 	path;
//@synthesize timer,		mPhase,				multiplier;
//@synthesize drawsIconMaskOnly, drawsAlphaSymbol;
//@synthesize lasso;


//- (float) dynamicStroke {
//	NSRect r = [self bounds];
//	int t = MAX((int)r.size.width, (int)r.size.height);
//	return (.1 * t);
////	return 14;
//}


//- (NSBezierPath*) path {
//	NSBezierPath *aP = [NSBezierPath bezierPathWithRoundedRect:[self bounds] cornerRadius:0];
////	[aP setLineWidth: self.dynamicStroke];
//	return  aP;
//}

//- (void) setColor:(NSColor *)aColor {
//		color = aColor;
//		gradient = self.gradient;
////		[self setNeedsDisplay:YES]; 
//}

//- (NSGradient*) gradient {

//	return [[NSGradient alloc] initWithStartingColor:color.brighter.brighter endingColor:color.darker.darker];
//}


//- (NSImage *) imageCache {
//	if(imageCache)   return  imageCache;
//	NSImage *cache = [[NSImage alloc]initWithSize:[self bounds].size];
//	[NSGraphicsContext saveGraphicsState];
//	[cache lockFocus];
////	BOOL outer = NO;
//	BOOL background = YES;
//	BOOL stroke = NO;
//	BOOL innerStroke = NO;
//	NSRect frame = [self bounds];
////	if(outer) {
////		NSBezierPath *outerClip = [NSBezierPath bezierPathWithRoundedRect:frame xRadius:_radius yRadius:_radius];
////		[outerClip setClip];
////		NSGradient *outerGradient = [[NSGradient alloc] initWithColorsAndLocations:
////									 [NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.0f, 
////									 [NSColor colorWithDeviceWhite:0.21f alpha:1.0f], 1.0f, nil];
////		[outerGradient drawInRect:[outerClip bounds] angle:90.0f];
////	}
//	if(background) {
//		NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) xRadius:radius yRadius:radius];
////		[NSShadow setShadowWithOffset:NSMakeSize(0, -8 * .5) blurRadius:12 * .5
////								color:[NSColor colorWithCalibratedWhite:0 alpha:0.75]];
////		[[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] set];
////		[backgroundPath fill];
////		[NSShadow clearShadow];
////		[backgroundPath setClip];	
//		[gradient drawInRect:[backgroundPath bounds] angle:270];
//	}
//	if(stroke) {
//		[[NSColor colorWithDeviceWhite:0.12f alpha:1.0f] setStroke];
//		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 1.5f, 1.5f) xRadius:radius yRadius:radius] stroke];
//	}
//	if(innerStroke) {
//		[[NSColor colorWithDeviceWhite:1.0f alpha:0.1f] setStroke];
//		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.5f, 2.5f) xRadius:radius yRadius:radius] stroke];
//	}
////	NSLog(@"representedObject: %@", [representedObject propertiesPlease] );
////	[CLEAR set];

////	[NSShadow setShadowWithOffset:NSMakeSize(0, -4) blurRadius:-6 color:[[representedObject valueForKey:@"color"]contrastingForegroundColor]];

////	NSImage *imagenow = [representedObject valueForKey:@"image"];
////	NSRect inset = NSInsetRect(frame, 2.0f, 2.0f);
////	[imagenow setSize:inset.size];
////	NSColor *c = [representedObject valueForKey:@"color"];
////	[imagenow drawCenteredinRect:inset operation:NSCompositeSourceOver fraction:1];
////	[NSShadow clearShadow];
//	[cache unlockFocus];
//	imageCache = cache;
//	[NSGraphicsContext restoreGraphicsState];
//	return imageCache;
//}

//- (void)drawRect:(NSRect)dirtyRect
//{

//	if (!imageCache) imageCache = self.imageCache;
//	NSRect frame = [self bounds];
//	[imageCache drawCenteredinRect:[self bounds] operation:NSCompositeCopy fraction:1];
//	if(hovering) {
//		[[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(frame, 2.0f, 2.0f) xRadius:radius yRadius:radius] setClip];
//		[[NSColor colorWithCalibratedWhite:0.0f alpha:0.35] setFill];
//		NSRectFillUsingOperation(frame, NSCompositeSourceAtop);
//	}
//		//		[NSGraphicsContext saveGraphicsState];
//		//		NSRect insidef = NSInsetRect(frame, 2.5f, 2.5f);
////		[selectionColor set];
//		//		[path setLineWidth:4.0];
//		//		[path stroke];
//		//		[NSGraphicsContext restoreGraphicsState];
////	}
//	//	}
//	//	[NSGraphicsContext restoreGraphicsState];
//}
//		
////	NSRect inRect = [self bounds];
////	NSRect srcRect = NSZeroRect;
////	srcRect.size = [image size];
////	
////	NSRect drawnRect = srcRect;
////	if(drawnRect.size.width > inRect.size.width)
////	{
////		drawnRect.size.height *= inRect.size.width/drawnRect.size.width;
////		drawnRect.size.width = inRect.size.width;
////	}
////	
////	if(drawnRect.size.height > inRect.size.height)
////	{
////		drawnRect.size.width *= inRect.size.height/drawnRect.size.height;
////		drawnRect.size.height = inRect.size.height;
////	}
////	
////	drawnRect.origin = inRect.origin;
////	drawnRect.origin.x += (inRect.size.width - drawnRect.size.width)/2;
////	drawnRect.origin.y += (inRect.size.height - drawnRect.size.height)/2;
////	NSImage *render = [[NSImage alloc]init];
////	if ([representedObject isKindOfClass:[AZFile class]] ) {
////		AZFile *f = representedObject;
////		if (drawsIconMaskOnly) {
//;
////	}
////	[[[self.representedObject valueForKey:@"image"] tintedWithColor:[representedObject valueForKey:@"color"]] drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
////	drawAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];

////	[render 
////			[render drawInRect:drawnRect fromRect:srcRect operation:NSCompositeSourceAtop fraction:1.0];
//		
////	}
//	


////- (void)setImage:(NSImage *)animage {
////	image = animage;
////	[self setNeedsDisplay:YES];
////}

//-(void) setRepresentedObject:(id)arepresentedObject {
//	representedObject = arepresentedObject;
//	[self setImageCache:nil];
//}

//- (void)setSelected:(BOOL)state
//{	

//	if (!state) if (lasso) { [lasso removeFromSuperview]; self.lasso = nil; }
//	else {
//		lasso = [[AZLasso alloc]initWithFrame:[self frame] andRadius:radius];
//		[self addSubview:lasso];
//	}
//	//	if (_hovered) {
//	//		if (state)  { 
//	//			[_timer invalidate];
//	//			NSLog(@"%ld %s, was hit!  %@ Rep: %@", _tag,
//	//				  _selected ? "SELECTED" : "NOT SELECTED",
//	//				  NSStringFromRect(self.frame), _representedObject);			
//	//			_all = 0;	
//	//			selected = state; 
//	//			[self setNeedsDisplay:YES];
//	//		}
//	//		else {
////		self.needsDisplay = YES;
//	//		}
//	//	}		
//	
//	//	selected = state;	
//	//	[self setNeedsDisplay:YES];
//}

//- (void)setHovering:(BOOL)state
//{
////	self.multiplier = (state ? 2 : .5 );
//	hovering = state;
////	[self setNeedsDisplay:YES];
//}

//- (void)prepareForReuse
//{
////	self.selected = NO;
////	self.drawSelection = YES;
////	self.hovering = NO;
////	self.image = nil;
//}

//- (id)initWithFrame:(NSRect)frame {
//	if (self = [super initWithFrame:frame]) {
//		self.multiplier = 1; //AZCenterOfRect([self frame]);
//		
//		self.drawsIconMaskOnly = YES;
//		[self addObserver:self forKeyPath:@"drawsIconMaskOnly" options:nil context:nil];
//		self.drawsAlphaSymbol = NO;
//		[self addObserver:self forKeyPath:@"drawsAlphaSymbol" options:nil context:nil];

////		self.radius = 
////		self.color = [NSColor redColor];
////		[self addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
////		[self addObserver:self forKeyPath:@"radius" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
////		[self addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionOld context:DotViewUndoAndRedisplay];
//		[[self superview] addObserver:self forKeyPath:@"desiredNumberOfColumns" options:NSKeyValueObservingOptionOld context:nil];
//		[self addObserver:self forKeyPath:@"multiplier" options:NSKeyValueObservingOptionOld context:nil];
//	}
//	return self;
//}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
////	if (context == DotViewUndoAndRedisplay) {
////		NSUndoManager *undoManager = [[self window] undoManager];
////		if ([keyPath isEqual:@"center"]) [[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];
////		else if ([keyPath isEqual:@"radius"]) [[undoManager prepareWithInvocationTarget:self] setRadius:[[change objectForKey:NSKeyValueChangeOldKey] doubleValue]];
////		else if ([keyPath isEqual:@"color"]) [undoManager registerUndoWithTarget:self selector:@selector(setColor:) object:[change objectForKey:NSKeyValueChangeOldKey]];
////		[self setNeedsDisplay:YES];
////	}
//	if ([keyPath isEqual:@"multiplier"]) {
//		NSRect bounding = [self frame];
////		[[AtoZ sharedInstance] say: NSStringFromRect(bounding)];		
//	}
//	if ([keyPath isEqual:@"desiredNumberOfColumns"]) {
//		NSLog(@"desired cols updated!");
//	}
////	[[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];


//}

//- (id)initWithReuseIdentifier:(NSString *)anIdentifier
//{
//	if((self = [super initWithFrame:NSZeroRect]))
//	{
//		cellIdentifier = anIdentifier;
//		selectionColor  = [NSColor whiteColor];
//		drawSelection   = YES;
//		mPhase = 0;
//		radius = 5;
//		composite = NSCompositeSourceOver;
//		
////		if ( [representedObject respondsToSelector:@selector(color)] ){
////			color = [representedObject valueForKey:@"color"];
////			NSLog(@"set color, via repped obj: %@", [representedObject propertiesPlease]);
////		} else { NSColor *r = RANDOMCOLOR;
////			while ( (![r isRedish]) || ([r isBoring]) ) r = RANDOMCOLOR;
////			color = r;
////		}
////		if ([representedObject isKindOfClass:[NSImage class]]) image = representedObject;
////		if ([representedObject valueForKeyPath:@"dictionary.color"] )
////			color = [representedObject valueForKeyPath:@"dictionary.color"];
//		

//	}
//	
//	return self;
//}



//-(void) setMultiplier:(float)amultiplier
//{
// 	multiplier = amultiplier;
//	NSRect r = AZScaleRect([self frame], multiplier);
//	[self setFrame:r];
////	[self setNeedsDisplay:YES];
//}


//@end
//	[NSGraphicsContext saveGraphicsState];

//	if (selected) {
//	}



//{
//	BOOL _wasAcceptingMouseEvents;
//	NSTrackingArea *_trackingArea;
//	NSBezierPath *_path;
//	NSGradient *_gradient;
//	NSShadow *_shadow;
//	NSTimer *_timer;
//	NSTimeInterval _interval;

//	float _mPhase;
//	float _all;
//}
//@synthesize pattern = _pattern, color = _color, tag = _tag, representedObject = _representedObject, string = _string, radius = _radius, selected = _selected, hovering = _hovered, cellIdentifier, image = _image, composite = _composite;

//- (id) initWithObject:(id)object {
//	_representedObject = object;
//	return [self initWithFrame:AGMakeSquare(NSZeroPoint,100)];

//}
//- (id)initWithReuseIdentifier:(NSString *)identifier {
//	cellIdentifier  = identifier;
//	return [self initWithFrame:AGMakeSquare(NSZeroPoint,100)];
//}


//- (id)initWithFrame:(NSRect)frame {
//	self = [super initWithFrame:frame];
//	if (self) {
//	
//		_composite = NSCompositeSourceOver;
//		_radius = 5;
//		_selected = NO;
//		_gradient = [self gradient];
//		_path = [self apath];
//		_mPhase = 0;
//		_interval = .05;
//	}
//	return self;
//}
//-(void) awakeFromNib {	[self updateTrackingAreas]; }

//-(void) updateTrackingAreas {
//	if (_trackingArea) _trackingArea = nil;
//	_trackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
//			options:NSTrackingMouseEnteredAndExited
// | NSTrackingActiveInActiveApp
////			| NSTrackingMouseMoved | NSTrackingActiveInActiveApp 
//			owner:self userInfo:nil];
//	[self addTrackingArea:_trackingArea];
//}

//- (NSColor*) pattern {
////	if (!_backgroundColor) {
////		NSString *imagePath = [[NSBundle bundleForClass:[AtoZ class]] pathForImageResource:@"linen.png"];
////		if ( imagePath != nil ) { NSLog(@"setting the linen"); 
////			_backgroundColor = 
//			
//			return [NSColor colorWithPatternImage: [[NSImage imageInFrameworkWithFileName:@"linen.png"] tintedWithColor:_color]];
//			
////			[[NSImage alloc] initWithContentsOfFile:imagePath]];
////		} 
////		if  (_backgroundColor == nil)
////			NSLog(@"Linen not found"); _backgroundColor = RANDOMCOLOR; 
////	
////	return _backgroundColor;	
//}

//- (void)drawRect:(NSRect)dirtyRect
//{

////	NSLog(@"Tag: %ld ALL: %f, mPhase: %f", self.tag, _all, _mPhase);
////	[NSGraphicsContext saveGraphicsState];
////	[AZGRAPHICSCTX setShouldAntialias:NO];
////	[NSShadow setShadowWithOffset:NSMakeSize(10,10) blurRadius:11 color:BLACK];
////	[[self backgroundColor] set];
//	NSGraphicsContext *ctx = AZGRAPHICSCTX;
//	
//	
//		
////		NSGradient *backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
////			[NSColor colorWithDeviceWhite:0.17f alpha:1.0f], 0.0f, 
////			[NSColor colorWithDeviceWhite:0.20f alpha:1.0f], 0.12f, 
////			[NSColor colorWithDeviceWhite:0.27f alpha:1.0f], 0.5f, 
////			[NSColor colorWithDeviceWhite:0.30f alpha:1.0f], 0.5f, 
////			[NSColor colorWithDeviceWhite:0.42f alpha:1.0f], 0.98f, 
////			[NSColor colorWithDeviceWhite:0.50f alpha:1.0f], 1.0f, 
////			nil];
//		

////	[[self path] fill];
////	[_gradient drawInBezierPath:_path angle:270];
////	NSShadow *sh = [[NSShadow alloc]init];
////	[sh setShadowColor:_color.brighter.brighter];
////	[sh setShadowOffset:NSMakeSize(4, -4)];
////	[sh setShadowBlurRadius:4];///3];
////	[_path fillWithInnerShadow:sh];
////	NSShadow *sh1 = [[NSShadow alloc]init];
////	[sh1 setShadowColor:_color.darker.darker];
////	[sh1 setShadowOffset:NSMakeSize(-4., 4)];
////	[sh1 setShadowBlurRadius:4];///3];
////	[_path fillWithInnerShadow:sh1];
////	if (_hovered) {
//////		NSLog(@"drawing %ld hovered", self.tag);
////		[[BLACK colorWithAlphaComponent:.5] set];
////		[_path fill];
////		
////	}
////	} //else { [[self color].darker set]; [[self path] stroke]; }
//}




//- (void)mouseEntered:(NSEvent *)theEvent {
////	wasAcceptingMouseEvents = [[self window] acceptsMouseMovedEvents];
////	[[self window] setAcceptsMouseMovedEvents:YES];
////	[[self window] makeFirstResponder:self];
////	NSPoint eyeCenter = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//	NSLog(@"mouse entered %@", NSStringFromRect([self frame]));
//	_hovered = YES;
//	[self setNeedsDisplay:YES];
//}
//-(void) mouseUp:(NSEvent *)theEvent
//{
////}
//- (void)mouseMoved:(NSEvent *)theEvent {
////	[self rotateByAngle:5];
////	NSPoint eyeCenter = [self convertPoint:[theEvent locationInWindow] fromView:nil];
////	eyeBox = NSMakeRect((eyeCenter.x-10.0), (eyeCenter.y-10.0), 20.0, 20.0);
////	[self setNeedsDisplayInRect:eyeBox];
////	[self setNeedsDisplay:YES];
////	NSLog(@"mouse moved in %ld", [self tag]);
//}

//- (void)mouseExited:(NSEvent *)theEvent {
//	NSLog(@"mouse exited %ld", [self tag]);

////	[[self window] setAcceptsMouseMovedEvents:wasAcceptingMouseEvents];
//	_hovered =	NO;
//	[self setNeedsDisplay:YES];
//}

//@end
