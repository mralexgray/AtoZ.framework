//
//  NSView+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSView+AtoZ.h"
//#import "AGFoundation.h"
#import "AZGeometricFunctions.h"
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
//@dynamic center;

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

-(NSPoint) center {
	return AZCenterOfRect ([self frame]);
}

//-(void)setCenter:(NSPoint)center {
//    objc_setAssociatedObject(self, &ISANIMATED_KEY, NSPoiu numberWithBool:animated], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//-(NSPoint)center {
//   return [objc_getAssociatedObject(self, &ISANIMATED_KEY) boolValue];
//}



-(void)setupHostView {
    CALayer *layer = [CALayer layer]; 
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
//    CGFloat components[4] = {0.0f, 0.0f, 0.0f, 1.0f};
//    CGColorRef blackColor = CGColorCreate(colorSpace, components);
//    layer.backgroundColor = blackColor; 
    [self setLayer:layer]; 
    [self setWantsLayer:YES];
//    CGColorRelease(blackColor);
//    CGColorSpaceRelease(colorSpace);
}


- (NSView *)firstSubview
{
	if ([self.subviews count] == 0) {
		return nil;
	}
	
	return (NSView *)[self.subviews objectAtIndex:0];
}

- (NSView *)lastSubview {
	if (self.subviews.count == 0) {
		return nil;
	}
	
	return (NSView *)[self.subviews objectAtIndex:self.subviews.count - 1];
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
	[animationDetails setObject:self forKey:NSViewAnimationTargetKey];
	return [NSArray arrayWithObject:animationDetails];
}

- (void)playAnimationWithParameters:(NSDictionary *)params
{
	NSViewAnimation *animation = [[NSViewAnimation alloc]
								  initWithViewAnimations:[self animationArrayForParameters:params]];
	[animation setAnimationBlockingMode:AZDefaultAnimationBlockingMode];
	[animation setDuration:AZDefaultAnimationDuration];
	[animation setAnimationCurve:AZDefaultAnimationCurve];
	[animation setDelegate:self];
	[animation startAnimation];
}


- (void)fadeWithEffect:effect
{
	[self playAnimationWithParameters:[NSDictionary
									   dictionaryWithObject:effect forKey:NSViewAnimationEffectKey]];
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
	[self playAnimationWithParameters:[NSDictionary dictionaryWithObject:
									   [NSValue valueWithRect:newFrame] forKey:NSViewAnimationEndFrameKey]];
}

- (void)fadeToFrame:(NSRect)newFrame
{
	[self playAnimationWithParameters:[NSDictionary
									   dictionaryWithObjectsAndKeys:[NSValue valueWithRect:newFrame],
									   NSViewAnimationEndFrameKey, [self isHidden] ?
									   NSViewAnimationFadeInEffect : NSViewAnimationFadeOutEffect,
									   NSViewAnimationEffectKey, nil]];
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

- (NSImage *) snapshot { return [self snapshotFromRect:[self bounds]]; }
//  This method creates a new image from a portion of the receiveing view. 
- (NSImage *) snapshotFromRect:(NSRect) sourceRect; {
	NSImage *snapshot = [[NSImage alloc] initWithSize:sourceRect.size];
	NSBitmapImageRep *rep;
	[self lockFocus];
	rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:sourceRect];
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

//@end
//
//@implementation NSView

+ (void)runEndBlock:(void (^)(void))completionBlock
{
  completionBlock();
}

//[i convertPoint: [[i window] convertScreenToBase:[NSEvent mouseLocation]] fromView: nil ]
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

//
//#import "NSView+Layout.h"
//#import "NS(Attributed)String+Geometrics.h"

void SSMoveView(NSView* view, float dX, float dY) {
	NSRect frame = [view frame] ;
	frame.origin.x += dX ;
	frame.origin.y += dY ;
	[view setFrame:frame] ;
}

void SSResizeView(NSView* view, float dX, float dY) {
	NSRect frame = [view frame] ;
	frame.size.width += dX ;
	frame.size.height += dY ;
	[view setFrame:frame] ;
}

void SSResizeViewMovingSubviews(NSView* view, float dXLeft, float dXRight, float dYTop, float dYBottom) {
	SSResizeView(view, dXLeft + dXRight, dYTop + dYBottom) ;

	NSArray* subviews = [view subviews] ;
	NSEnumerator* e ;
	NSView* subview ;

	// If we wanted to change the "left", move all existing subviews to the right
	if (dXLeft != 0.0) {
		e = [subviews objectEnumerator] ;
		while ((subview = [e nextObject])) {
			SSMoveView(subview, dXLeft, 0.0) ;
		}
	}

	// If we wanted to change the "bottom", move all existing subviews up
	if (dYBottom != 0.0) {
		e = [subviews objectEnumerator] ;
		while ((subview = [e nextObject])) {
			SSMoveView(subview, 0.0, dYBottom) ;
		}
	}
	[view display] ;
}

NSView* SSResizeWindowAndContent(NSWindow* window, float dXLeft, float dXRight, float dYTop, float dYBottom, BOOL moveSubviews) {
	NSView* view = [window contentView] ;
	if (moveSubviews) {
		SSResizeViewMovingSubviews(view, dXLeft, dXRight, dYTop, dYBottom) ;
	}
	else {
		SSResizeView(view, dXLeft + dXRight, dYTop + dYBottom) ;
	}
	NSRect frame = [window frame] ;
	frame.size.width += (dXLeft + dXRight) ;
	frame.size.height += (dYTop + dYBottom) ;
	// Since window origin is at the bottom, and we want
	// the bottom to move instead of the top, we also
	// adjust the origin.y
	frame.origin.y -= (dYTop + dYBottom) ;
	// since screen y is measured from the top, we have to
	// subtract instead of add
	[window setFrame:frame display:YES] ;

	return view ;  // because often this is handy
}

@implementation NSView (Layout)

- (float)leftEdge {
	return [self frame].origin.x ;
}

- (float)rightEdge {
	return [self frame].origin.x + [self width] ;
}

- (float)centerX {
	return ([self frame].origin.x + [self width]/2) ;
}

- (void)setLeftEdge:(float)t {
	NSRect frame = [self frame] ;
	frame.origin.x = t ;
	[self setFrame:frame] ;
}

- (void)setRightEdge:(float)t {
	NSRect frame = [self frame] ;
	frame.origin.x = t - [self width] ;
	[self setFrame:frame] ;
}

- (void)setCenterX:(float)t {
	float center = [self centerX] ;
	float adjustment = t - center ;

	NSRect frame = [self frame] ;
	frame.origin.x += adjustment ;
	[self setFrame:frame] ;
}

- (float)bottom {
	return [self frame].origin.y ;
}

- (float)top {
	return [self frame].origin.y + [self height] ;
}

- (float)centerY {
	return ([self frame].origin.y + [self height]/2) ;
}

- (void)setBottom:(float)t {
	NSRect frame = [self frame] ;
	frame.origin.y = t ;
	[self setFrame:frame] ;
}

- (void)setTop:(float)t {
	NSRect frame = [self frame] ;
	frame.origin.y = t - [self height] ;
	[self setFrame:frame] ;
}

- (void)setCenterY:(float)t {
	float center = [self centerY] ;
	float adjustment = t - center ;

	NSRect frame = [self frame] ;
	frame.origin.y += adjustment ;
	[self setFrame:frame] ;
}

- (float)width {
	return [self frame].size.width ;
}

- (float)height {
	return [self frame].size.height ;
}

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
			// According to Douglas Davidson, http://www.cocoabuilder.com/archive/message/cocoa/2002/2/13/66379,
			// "The default font for text that has no font attribute set is 12-pt Helvetica."
			// So, we make that interpretation...
			if (font == nil) {
				font = [NSFont fontWithName:@"Helvetica"
									   size:12] ;
			}

			height = [[(NSTextView*)self string] heightForWidth:width
														   font:font] ;
		}
		NSRect frame = [self frame] ;
		frame.size.height = allowShrinking ? height : MAX(height, oldHeight) ;
		[self setFrame:frame] ;
	}
	else if ([self isKindOfClass:[NSTextField class]]) {
		gNSStringGeometricsTypesetterBehavior = NSTypesetterBehavior_10_2_WithCompatibility ;
		height = [[(NSTextField*)self stringValue] heightForWidth:width
															 font:[(NSTextView*)self font]] ;
		NSRect frame = [self frame] ;
		frame.size.height = allowShrinking ? height : MAX(height, oldHeight) ;
		[self setFrame:frame] ;
	}
	else {
		// Subclass should have set height to fit
	}

	// Clip if taller than screen
	float screenHeight = [[NSScreen mainScreen] frame].size.height ;
	if ([self height] > screenHeight) {
		NSRect frame = [self frame] ;
		frame.size.height = screenHeight ;
		[self setFrame:frame] ;
	}
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