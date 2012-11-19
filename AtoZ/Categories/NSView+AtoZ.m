
//  NSView+AtoZ.m
//  AtoZ

//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "NSView+AtoZ.h"
//#import "AGFoundation.h"
#import "AtoZGeometry.h"
#import "AtoZ.h"
#import <QuartzCore/QuartzCore.h>

//@interface NSView ()
//+ (void)runEndBlock:(void (^)(void))completionBlock;
//@end


NSTimeInterval AZDefaultAnimationDuration = -1; // -1 makes the system provide a default duration
NSAnimationBlockingMode AZDefaultAnimationBlockingMode = NSAnimationNonblocking;
NSAnimationCurve AZDefaultAnimationCurve = NSAnimationEaseInOut;

#import <objc/runtime.h>

//static char const * const ObjectTagKey = "ObjectTag";
static char const * const ObjectRepKey = "ObjectRep";

@implementation NSView (ObjectRep)
@dynamic objectRep;

- (id)objectRep {
    return objc_getAssociatedObject(self, ObjectRepKey);
}

- (void)setObjectRep:(id)newObjectRep {
    objc_setAssociatedObject(self, ObjectRepKey, newObjectRep, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSImage*) captureFrame
{

    NSRect originRect = [[self window] convertRectToScreen:[self bounds]]; // toView:[[self window] contentView]];

    NSRect rect = originRect;
    rect.origin.y = 0;
    rect.origin.x += [self window].frame.origin.x;
    rect.origin.y += [[self window] screen].frame.size.height - [self window].frame.origin.y - [self window].frame.size.height;
    rect.origin.y += [self window].frame.size.height - originRect.origin.y - originRect.size.height;

    CGImageRef cgimg = CGWindowListCreateImage(rect,
											   kCGWindowListOptionIncludingWindow,
											   (CGWindowID)[[self window] windowNumber],
											   kCGWindowImageDefault);
    return [[NSImage alloc] initWithCGImage:cgimg size:[self bounds].size];
}
- (NSView *)viewWithObjectRep:(id)object {
    // Raise an exception if object is nil
    if (object == nil) {
        [NSException raise:NSInternalInconsistencyException format:@"Argument to -viewWithObjectTag: must not be nil"];
    }
	
    // Recursively search the view hierarchy for the specified objectTag
    if ([self.objectRep isEqual:object]) {
        return self;
    }
    for (NSView *subview in self.subviews) {
        NSView *resultView = [subview viewWithObjectRep:object];
        if (resultView != nil) {
            return resultView;
        }
    }
    return nil;
}

@end

static NSString *ANIMATION_IDENTIFER = @"animation";
static char const * const ISANIMATED_KEY = "ObjectRep";

@implementation NSView (AtoZ)
// setup 3d transform
- (void) setZDistance: (NSUInteger) zDistance
{
	CATransform3D aTransform = CATransform3DIdentity;
	aTransform.m34 = -1.0 / zDistance;
	if (!self.layer) [self setupHostView];
	self.layer.sublayerTransform = aTransform;
}

- (CGP)layerPoint:(NSEvent*)event;
{
	return [self convertPointToLayer:[self convertPoint:event.locationInWindow fromView:nil]];
}
- (CGP)layerPoint:(NSEvent*)event toLayer:(CAL*)layer;
{
	return [self.layer convertPoint:[self layerPoint:event] toLayer:layer];
}

- (void) observeFrameChangeUsingBlock:(void(^)(void))block
{
	self.postsBoundsChangedNotifications = YES;
	[self observeName:NSViewFrameDidChangeNotification usingBlock:^(NSNotification *n) {
		block();
	}];
}
- (BOOL)isSubviewOfView:(NSView*) theView
{
    __block BOOL isSubView = NO;
    [[theView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([self isEqualTo:(NSView*) obj]) {
            isSubView = YES;
            *stop = YES;
        }
    }];
    return isSubView;
}
- (BOOL)containsSubView:(NSView*) subview
{
    __block BOOL containsSubView = NO;
    [[self subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([subview isEqualTo:(NSView*) obj]) {
            containsSubView = YES;
            *stop = YES;
        }
    }];
    return containsSubView;
}


- (void)setCenter:(NSPoint)center
{
    [self setFrameOrigin:NSMakePoint(floorf(center.x - (NSWidth([self bounds])) / 2),
                                     floorf(center.y - (NSHeight([self bounds])) / 2))];
}
- (NSPoint)getCenter
{
    return NSMakePoint(floorf(self.bounds.origin.x + (self.bounds.size.width / 2)),
                       floorf(self.bounds.origin.y + (self.bounds.size.height / 2)));
}
- (NSPoint)getCenterOnFrame
{
    return NSMakePoint(floorf(self.frame.origin.x + (self.frame.size.width / 2)),
                       floorf(self.frame.origin.y + (self.frame.size.height / 2)));
}

- (void) maximize{
	NSRect r = [self.window.contentView bounds];
	self.autoresizesSubviews = YES;
	self.autoresizingMask = NSSIZEABLE;
	[self setFrame:r];
	[self setNeedsDisplay:YES];

}
//@dynamic center;
- (NSRect) centerRect:(NSRect) aRect onPoint:(NSPoint) aPoint
{
	float
    height = NSHeight(aRect),
    width = NSWidth(aRect);

	return NSMakeRect(aPoint.x-(width/2.0), aPoint.y - (height/2.0), width, height);
}

- (void) centerOriginInBounds { [self centerOriginInRect:[self bounds]];  }
- (void) centerOriginInFrame { [self centerOriginInRect:[self convertRect:[self frame] fromView:[self superview]]];  }
- (void) centerOriginInRect:(NSRect) aRect  { [self translateOriginToPoint:NSMakePoint(NSMidX(aRect), NSMidY(aRect))]; }
-(void) slideDown {
	NSRect newViewFrame;
	if ([self valueForKeyPath:@"dictionary.visibleRect"] ) {
		newViewFrame = 	[[self valueForKeyPath:@"dictionary.visibleRect"]rectValue];
	} else {
/*		id aView = [ @[ self, [ self superview], [self window]] filterOne:^BOOL(id object) {
			return  [object respondsToSelector:@selector(orientation)] ? YES : NO ;
		}];
		if  (aView) { 	AZOrient b = (AZOrient)[aView valueForKey:@"orientation"];
//		NSLog(@"computed orentation  %ld", b);
			NSLog(@"computed orentation %@", AZOrientName[b]);
		}
*/		newViewFrame = AZMakeRectFromSize([[self superview]frame].size);
//		AZRectVerticallyOffsetBy( [self frame], -[self frame].size.height);
	}
	
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"frame"];
	[animation setFromValue:[NSValue valueWithRect:[self frame]]];
	[animation setToValue:	[NSValue valueWithRect:newViewFrame]];

//	CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
//	[fader setFromValue:@0.f];
//	[fader setToValue:@1.f];
	[self setAnimations:	@{ @"frame" : animation}];

	[[self animator] setFrame:newViewFrame];
}

-(void) slideUp {

	if (! [self valueForKeyPath:@"dictionary.visibleRect"] ) {
		NSLog(@"avaing cvisirect: %@", NSStringFromRect([self frame]));
		[self setValue:[NSValue valueWithRect:[self frame]] forKeyPath:@"dictionary.visibleRect"];
	}
		NSRect newViewFrame = [self frame];
		AZWindowPosition r = AZPositionOfRectInRect([[self window]frame], AZScreenFrameUnderMenu());
		NSSize getOut = AZDirectionsOffScreenWithPosition(newViewFrame,r);
		newViewFrame.size.width  += getOut.width;
		newViewFrame.size.height += getOut.height;
		CABasicAnimation *framer = [CABasicAnimation animationWithKeyPath:@"frame"];
		[framer setFromValue:[NSValue valueWithRect:[self frame]]];
		[framer setToValue:	[NSValue valueWithRect:newViewFrame]];
		[self setAnimations:	@{ @"frame" : framer}];
		[[self animator] setFrame:newViewFrame];
}

- (NSArray *)allSubviews {
    NSMutableArray *allSubviews = [NSMutableArray arrayWithObject:self];
    NSArray *subviews = [self subviews];
    for (NSView *view in subviews) {
        [allSubviews addObjectsFromArray:[view allSubviews]];
    }
    return [allSubviews copy];
}
-(void)setAnimationIdentifer:(NSString *)newAnimationIdentifer{
    objc_setAssociatedObject(self, &ANIMATION_IDENTIFER, newAnimationIdentifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSString*)animationIdentifer{
 return objc_getAssociatedObject(self, &ANIMATION_IDENTIFER);
}

-(void) replaceSubviewWithRandomTransition:(NSView *)oldView with:(NSView *)newView
{
	BOOL hasLayer = (self.layer == nil);
	if (!hasLayer) [self setWantsLayer:YES];
	[self setAnimations:@{@"subviews":[CATransition randomTransition]}];
	[self replaceSubview:oldView with:newView];
	if (!hasLayer) [self setWantsLayer:NO];
}

- (void) swapSubs:(NSView*)view;
{
	NSS* firstID = [[self firstSubview]identifier];
	[[self firstSubview]fadeOut];
	[self removeAllSubviews];

	[view setHidden:YES];
	[self addSubview:view];
	[view setFrame:self.bounds];
	[view fadeIn];
	NSLog(@"Swapped subview: %@ for %@", firstID, view);
}

-(NSPoint) center {
	return AZCenterOfRect ([self frame]);
}

//-(void)setCenter:(NSPoint)center {
//    objc_setAssociatedObject(self, &ISANIMATED_KEY, NSPoiu numberWithBool:animated], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//-(NSPoint)center {
//   return [objc_getAssociatedObject(self, &ISANIMATED_KEY) boolValue];
//}

/*** A "layer backed NSView"
 1. can have subviews.  it is a normal view after all
 2. it uses a layer as "pixel backing storage", instead of the kind of storage views otherwise use.
 3. the backing layer of a NSView cannot have sublayers (there is no support for "layer hierarchies").

 NSView *layerBacked = [NSView new];
 [layerBacked setWantsLayer:YES];

 A "layer hosting" view
 1. cannot have subviews
 2. its sole purpose is to "host a layer"
 3. the layer it hosts can have sublayers and a very complex layer-tree-hierarchy.

 NSView *layerHosting = [NSView new];
 CALayer *layer = [CALayer new];
 [layerHosting setLayer:layer];
 [layerHosting setWantsLayer:YES];
*/

-(CALayer*) setupHostViewNamed:(NSS*)name {
	CAL *i = [self setupHostView];
	i.name = name;
	return i;
}

-(CALayer*) setupHostView {
    CALayer *layer = [CALayer layerNamed:@"root"];
//	layer.frame = [self bounds];
//	layer.position = [self center];
//	layer.bounds = [self bounds];
//	layer.needsDisplayOnBoundsChange = YES;
//	layer.backgroundColor = cgRANDOMCOLOR;
//	layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	[self setLayer:layer];
    [self setWantsLayer:YES];
	NSLog(@"setup hosting layer:%@ in view: %@.  do not addsubviews to this view.  go crazy with layers.", layer.debugDescription, self);
	return layer;
}
- (NSView *)firstSubview
{
	return [self.subviews count] == 0 ? nil: self.subviews[0];
}

- (NSView *)lastSubview {
	return self.subviews.count == 0 ? nil : [self.subviews lastObject];
}

- (void)setLastSubview:(NSView *)view {
	[self addSubview:view];
}

//Remove all the subviews from a view
- (void)removeAllSubviews;
{
    NSEnumerator* enumerator = [[self subviews] reverseObjectEnumerator];
    NSView* view;
    
    while (view = [enumerator nextObject])
        [view removeFromSuperviewWithoutNeedingDisplay];
}

//NSArray 	*subviews;  int		loop;
//subviews = [[self subviews] copy];
//for (loop = 0;loop < [subviews count]; loop++) {
//	[[subviews objectAtIndex:loop] removeFromSuperview];
//}
-(NSTrackingArea *)trackFullView {
	NSTrackingAreaOptions options =
	NSTrackingMouseEnteredAndExited
    | NSTrackingMouseMoved
    | NSTrackingActiveInKeyWindow
    | NSTrackingInVisibleRect ;
	NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:NSMakeRect(0, 0, 0, 0)
			   options:options
				 owner:self
			  userInfo:nil];
	[self addTrackingArea:area];
	return area;
}

-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect {
	return [self trackAreaWithRect:rect userInfo:nil];
}

-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect
                            userInfo:(NSDictionary *)context
{
	NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited
    | NSTrackingMouseMoved
    | NSTrackingActiveInKeyWindow;
	NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:rect
			   options:options
				 owner:self
			  userInfo:context];
	[self addTrackingArea:area];
	return area;
}

-(BOOL)requestFocus {
	return [[self window] makeFirstResponder:self];
}

-(void)animate:(AZViewAnimationType)type {
	
	CALayer *touchedLayer;
	if  (self.layer) touchedLayer = self.layer;
	else { touchedLayer = [CALayer layer]; [self setLayer: touchedLayer]; [self setWantsLayer:YES];}
	touchedLayer.masksToBounds = NO;
	//	touchedLayer.anchorPoint = CGPointMake(.5,.5);
	// here is an example wiggle
	CABasicAnimation *wiggle = [CABasicAnimation animationWithKeyPath:@"transform"];
	wiggle.duration = 3;
	wiggle.timeOffset = RAND_FLOAT_VAL(0, 1);
	wiggle.repeatCount = HUGE_VALF;
	wiggle.autoreverses = YES;
	//	Rotate 't' by 'angle' radians about the vector '(x, y, z)' and return the result. If the vector has zero length the behavior is undefined: t' = rotation(angle, x, y, z) * t.
	//  Original signature is 'CATransform3D CATransform3DRotate (CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z)'
	switch (type) {
		case AZViewAnimationTypeJiggle:
			wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(touchedLayer.transform,0.1, 0.0 ,1.0 ,2.0)];
			break;
		case AZViewAnimationTypeFlipHorizontally:
			wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(touchedLayer.transform,DEG2RAD(180), 1,0,0)];
		default:
			break;
	}
	// doing the wiggle
	[touchedLayer addAnimation:wiggle forKey:@"jiggle"];
	
	// setting a timer to remove the layer
	//	NSTimer *wiggleTimer = [NSTimer scheduledTimerWithTimeInterval:(2) target:self selector:@selector(endWiggle:) userInfo:touchedLayer repeats:NO];
	
}

-(void)stopAnimating{
	//:(NSTimer*)timer {
	// stopping the wiggle now
	[self.layer removeAllAnimations];
}
- (void)resizeFrameBy:(int)value {
	NSRect frame = [self frame];
	[[self animator]setFrame:CGRectMake(frame.origin.x,
										frame.origin.x,
										frame.size.width + value,
										frame.size.height + value
										)];
}


- (NSArray *)animationArrayForParameters:(NSDictionary *)params
{
	NSMutableDictionary *animationDetails = [NSMutableDictionary
											 dictionaryWithDictionary:params];
	animationDetails[NSViewAnimationTargetKey] = self;
	return @[animationDetails];
}

- (void)playAnimationWithParameters:(NSDictionary *)params
{
	NSViewAnimation *animation = [[NSViewAnimation alloc]
								  initWithViewAnimations:[self animationArrayForParameters:params]];
	[animation setAnimationBlockingMode:AZDefaultAnimationBlockingMode];
	[animation setDuration:AZDefaultAnimationDuration];
	[animation setAnimationCurve:AZDefaultAnimationCurve];
	[animation setDelegate:(id)self];
	[animation startAnimation];
}
- (void)fadeWithEffect:effect
{
	[self playAnimationWithParameters:@{NSViewAnimationEffectKey: effect}];
}

- (void)fadeOut 
{
	[self fadeWithEffect:NSViewAnimationFadeOutEffect];
}

- (void)fadeIn
{
	[self fadeWithEffect:NSViewAnimationFadeInEffect];
}

- (void)animateToFrame:(NSRect)newFrame
{
	[self playAnimationWithParameters:@{NSViewAnimationEndFrameKey: [NSValue valueWithRect:newFrame]}];
}

- (void)fadeToFrame:(NSRect)newFrame
{
	[self playAnimationWithParameters:@{NSViewAnimationEndFrameKey: [NSValue valueWithRect:newFrame], NSViewAnimationEffectKey: [self isHidden] ?
									   NSViewAnimationFadeInEffect : NSViewAnimationFadeOutEffect}];
}

+ (void)setDefaultDuration:(NSTimeInterval)duration
{
	AZDefaultAnimationDuration = duration;
}

+ (void)setDefaultBlockingMode:(NSAnimationBlockingMode)mode
{
	AZDefaultAnimationBlockingMode = mode;
}

+ (void)setDefaultAnimationCurve:(NSAnimationCurve)curve
{
	AZDefaultAnimationCurve = curve;
}

- (NSImage *) snapshot { return [self snapshotFromRect:[self frame]]; }

//  This method creates a new image from a portion of the receiveing view.
- (NSImage *) snapshotFromRect:(NSRect) sourceRect; {
	NSImage *snapshot = [[NSImage alloc] initWithSize:sourceRect.size];
	[self lockFocus];
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:sourceRect];
	[self unlockFocus];
	[snapshot addRepresentation:rep];
	return snapshot;
}

+ (void)animateWithDuration:(NSTimeInterval)duration 
                  animation:(void (^)(void))animationBlock
{
  [self animateWithDuration:duration animation:animationBlock completion:nil];
}
+ (void)animateWithDuration:(NSTimeInterval)duration 
                  animation:(void (^)(void))animationBlock
                 completion:(void (^)(void))completionBlock
{
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:duration];
  animationBlock();
  [NSAnimationContext endGrouping];

  if(completionBlock)
  {
    id completionBlockCopy = [completionBlock copy];
    [self performSelector:@selector(runEndBlock:) withObject:completionBlockCopy afterDelay:duration];
  }
}
+ (void)runEndBlock:(void (^)(void))completionBlock
{
  completionBlock();
}

/////[i convertPoint: [[i window] convertScreenToBase:[NSEvent mouseLocation]] fromView: nil ]

- (NSPoint) localPoint;
{
	return [self convertPoint: [[self window] convertScreenToBase:NSPointFromCGPoint( mouseLoc())] fromView:nil];
//								[NSEvent mouseLocation]] fromView: nil ]
}

- (void) handleMouseEvent:(NSEventMask)mask withBlock:(void (^)())block  {
		[NSEvent addLocalMonitorForEventsMatchingMask:mask handler:^NSEvent *(NSEvent *event) {
			NSPoint localP = self.localPoint;
			[self setNeedsDisplay:YES];
			NSLog(@"oh my god.. point %@", NSStringFromPoint(localP));
			if ([event type] == mask ) {

//			if ( NSPointInRect(localP, view.frame) ){
				NSLog(@"oh my god.. point is local to view: %@! Localpoint: %@...  about to run block !!". self.description, [self localPoint]);
				[[NSThread mainThread] performBlock:block waitUntilDone:YES];
					//			[NSThread performBlockInBackground:block];
			}
			return event;
		}];
	return;
}

@end

void AZMoveView(NSView* view, float dX, float dY) {
	NSRect frame = [view frame] ;
	frame.origin.x += dX ;
	frame.origin.y += dY ;
	[view setFrame:frame] ;
}

void AZResizeView(NSView* view, float dX, float dY) {
	NSRect frame = [view frame] ;
	frame.size.width += dX ;
	frame.size.height += dY ;
	[view setFrame:frame] ;
}

void AZResizeViewMovingSubviews(NSView* view, float dXLeft, float dXRight, float dYTop, float dYBottom) {
	AZResizeView(view, dXLeft + dXRight, dYTop + dYBottom) ;

	NSArray* subviews = [view subviews] ;
	NSEnumerator* e ;
	NSView* subview ;

	// If we wanted to change the "left", move all existing subviews to the right
	if (dXLeft != 0.0) {
		e = [subviews objectEnumerator] ;
		while ((subview = [e nextObject])) {
			AZMoveView(subview, dXLeft, 0.0) ;
		}
	}

	// If we wanted to change the "bottom", move all existing subviews up
	if (dYBottom != 0.0) {
		e = [subviews objectEnumerator] ;
		while ((subview = [e nextObject])) {
			AZMoveView(subview, 0.0, dYBottom) ;
		}
	}
	[view display] ;
}

NSView* AZResizeWindowAndContent(NSWindow* window, float dXLeft, float dXRight, float dYTop, float dYBottom, BOOL moveSubviews) {
	NSView* view = [window contentView] ;
	if (moveSubviews)
		AZResizeViewMovingSubviews(view, dXLeft, dXRight, dYTop, dYBottom) ;
	else
		AZResizeView(view, dXLeft + dXRight, dYTop + dYBottom) ;
	NSRect frame = [window frame] ;
	frame.size.width += (dXLeft + dXRight) ;
	frame.size.height += (dYTop + dYBottom) ;
	// Since window origin is at the bottom, and we want  the bottom to move instead of the top, we also adjust the origin.y
	frame.origin.y -= (dYTop + dYBottom) ;
	// since screen y is measured from the top, we have to	subtract instead of add
	[window setFrame:frame display:YES] ;
	return view ;  // because often this is handy
}

@implementation NSView (Layout)

- (float)leftEdge {	return [self frame].origin.x ;	}

- (float)rightEdge {	return [self frame].origin.x + [self width] ;	}

- (float)centerX {	return ([self frame].origin.x + [self width]/2) ;	}

- (void)setLeftEdge:(float)t {	NSRect frame = [self frame] ;	frame.origin.x = t ;	[self setFrame:frame] ;	}

- (void)setRightEdge:(float)t {	NSRect frame = [self frame] ;	frame.origin.x = t - [self width] ;	[self setFrame:frame];	}

- (void)setCenterX:(float)t {	float center = [self centerX] ;	float adjustment = t - center ;
	NSRect frame = [self frame] ;	frame.origin.x += adjustment ;	[self setFrame:frame];
}

- (float)bottom {	return [self frame].origin.y ;	}

- (float)top {		return [self frame].origin.y + [self height] ;	}

- (float)centerY {	return ([self frame].origin.y + [self height]/2) ;}

- (void)setBottom:(float)t {	NSRect frame = [self frame] ;	frame.origin.y = t ;	[self setFrame:frame] ;	}

- (void)setTop:(float)t {	NSRect frame = [self frame] ;	frame.origin.y = t - [self height] ;	[self setFrame:frame] ;	}

- (void)setCenterY:(float)t {		float center = [self centerY] ;		float adjustment = t - center ;
	NSRect frame = [self frame] ;	frame.origin.y += adjustment ;		[self setFrame:frame] ;
}

- (float)width {	return [self frame].size.width ;		}

- (float)height {	return [self frame].size.height ;	}

- (void)setWidth:(float)t {
	NSRect frame = [self frame] ;
	frame.size.width = t ;
	[self setFrame:frame] ;
}

- (void)setHeight:(float)t {
	NSRect frame = [self frame] ;
	frame.size.height = t ;
	[self setFrame:frame] ;
}

- (void)setSize:(NSSize)size {
	NSRect frame = [self frame] ;
	frame.size.width = size.width ;
	frame.size.height = size.height ;
	[self setFrame:frame] ;
}

- (void)deltaX:(float)dX
		deltaW:(float)dW {
	NSRect frame = [self frame] ;
	frame.origin.x += dX ;
	frame.size.width += dW ;
	[self setFrame:frame] ;
}

- (void)deltaY:(float)dY
		deltaH:(float)dH {
	NSRect frame = [self frame] ;
	frame.origin.y += dY ;
	frame.size.height += dH ;
	[self setFrame:frame] ;
}

- (void)deltaX:(float)dX {
	[self deltaX:dX
		  deltaW:0.0] ;
}

- (void)deltaY:(float)dY {
	[self deltaY:dY
		  deltaH:0.0] ;
}

- (void)deltaW:(float)dW {
	[self deltaX:0.0
		  deltaW:dW] ;
}

- (void)deltaH:(float)dH {
	[self deltaY:0.0
		  deltaH:dH] ;
}
- (void)sizeHeightToFitAllowShrinking:(BOOL)allowShrinking {
	float oldHeight = [self height] ;
	float width = [self width] ;
	float height ;
	if ([self isKindOfClass:[NSTextView class]]) {
		NSAttributedString* attributedString = [(NSTextView*)self textStorage] ;
		if (attributedString != nil) {
			height = [attributedString heightForWidth:width] ;
		}
		else {
			NSFont* font = [(NSTextView*)self font] ;
			/* According to Douglas Davidson, http://www.cocoabuilder.com/archive/message/cocoa/2002/2/13/66379,
			"The default font for text that has no font attribute set is 12-pt Helvetica."
			So, we make that interpretation... */
			if (font == nil)				font = [NSFont fontWithName:@"Helvetica" size:12] ;
			height = [[(NSTextView*)self string] heightForWidth:width	font:font] ;
		}
		NSRect frame = [self frame] ;
		frame.size.height = allowShrinking ? height : MAX(height, oldHeight) ;
		[self setFrame:frame] ;
	}
	else if ([self isKindOfClass:[NSTextField class]]) {
		gNSStringGeometricsTypesetterBehavior = NSTypesetterBehavior_10_2_WithCompatibility ;
		height = [[(NSTextField*)self stringValue] heightForWidth:width	font:[(NSTextView*)self font]] ;
		NSRect frame = [self frame] ;
		frame.size.height = allowShrinking ? height : MAX(height, oldHeight) ;
		[self setFrame:frame] ;
	}
	else {
		// Subclass should have set height to fit
	}
	// Clip if taller than screen
	float screenHeight = [[NSScreen mainScreen] frame].size.height ;
	if ([self height] > screenHeight) {	NSRect frame = [self frame] ;	frame.size.height = screenHeight ;	[self setFrame:frame] ;	}
}

- (NSComparisonResult)compareLeftEdges:(NSView*)otherView {
	float myLeftEdge = [self leftEdge] ;
	float otherLeftEdge = [otherView leftEdge] ;
	if (myLeftEdge < otherLeftEdge) {
		return NSOrderedAscending ;
	}
	else if (myLeftEdge > otherLeftEdge) {
		return NSOrderedDescending ;
	}

	return NSOrderedSame ;
}

// The normal margin of "whitespace" that one leaves at the bottom of a window

#define BOTTOM_MARGIN 20.0

- (void)sizeHeightToFit {
	CGFloat minY = 0.0 ;
	for (NSView* subview in [self subviews]) {
		minY = MIN([subview frame].origin.y - BOTTOM_MARGIN, minY) ;
	}

	// Set height so that minHeight is the normal window edge margin of 20
	CGFloat deltaH = -minY ;
	NSRect frame = [self frame] ;
	frame.size.height += deltaH ;
	[self setFrame:frame] ;

	// Todo: Set width similarly
}

@end

@implementation NSTableView (Scrolling)

- (void)scrollRowToTop:(NSInteger)row {
	if ((row != NSNotFound) && (row >=0)) {
		CGFloat rowPitch = [self rowHeight] + [self intercellSpacing].height ;
		CGFloat y = row * rowPitch ;
		[self scrollPoint:NSMakePoint(0, y)] ;
	}
}

@end


@implementation NSView (findSubview)

- (NSArray *)findSubviewsOfKind:(Class)kind withTag:(NSInteger)tag inView:(NSView*)v {
    NSMutableArray *array = [NSMutableArray array];

    if(kind==nil || [v isKindOfClass:kind]) {
        if(tag==NSNotFound || v.tag==tag) {
            [array addObject:v];
        }
    }

    for (id subview in v.subviews) {
        NSArray *vChild = [self findSubviewsOfKind:kind withTag:tag inView:subview];
        [array addObjectsFromArray:vChild];
    }

    return array;
}

#pragma mark -

- (NSArray *)subviewsOfKind:(Class)kind withTag:(NSInteger)tag {
    return [self findSubviewsOfKind:kind withTag:tag inView:self];
}

- (NSArray *)subviewsOfKind:(Class)kind {
    return [self findSubviewsOfKind:kind withTag:NSNotFound inView:self];
}

- (NSView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag {
    return [self findSubviewsOfKind:kind withTag:tag inView:self][0];
}

- (NSView *)firstSubviewOfKind:(Class)kind {
    return [self firstSubviewOfKind:kind withTag:NSNotFound];
}
@end
