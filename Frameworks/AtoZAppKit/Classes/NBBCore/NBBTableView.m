/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import "NBBTableView.h"
#import "NBBTheme.h"

// WARNING:
// NBBScrollAnimation must be used with GCD. removing the GCD calls results in wonky behavior
// when you interrupt the animation (and dispatch_sync() will deadlock).
// when you interact with the animation wrap your code in a block and pass to dispatch_async()

@interface NBBScrollAnimation : NSAnimation

@property (retain) NSClipView* clipView;
@property NSPoint originPoint;
@property NSPoint targetPoint;

+ (NBBScrollAnimation*)scrollAnimationWithClipView:(NSClipView *)clipView;

@end

@implementation NBBScrollAnimation

@synthesize clipView;
@synthesize originPoint;
@synthesize targetPoint;

+ (NBBScrollAnimation*)scrollAnimationWithClipView:(NSClipView *)clipView
{
	NBBScrollAnimation *animation = [[NBBScrollAnimation alloc] initWithDuration:0.6 animationCurve:NSAnimationEaseOut];
	
	animation.clipView = clipView;
	animation.originPoint = clipView.documentVisibleRect.origin;
	animation.targetPoint = animation.originPoint;

	return animation;// autorelease];
}

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
	typedef float (^MyAnimationCurveBlock)(float, float, float);
	MyAnimationCurveBlock cubicEaseOut = ^ float (float t, float start, float end) {
		t--;
		return end*(t * t * t + 1) + start;
	};

	dispatch_sync(dispatch_get_main_queue(), ^{
		NSPoint progressPoint = self.originPoint;
		progressPoint.x += cubicEaseOut(progress, 0, self.targetPoint.x - self.originPoint.x);
		progressPoint.y += cubicEaseOut(progress, 0, self.targetPoint.y - self.originPoint.y);

		NSPoint constraint = [self.clipView constrainScrollPoint:progressPoint];
		if (!NSEqualPoints(constraint, progressPoint)) {
			// constraining the point and reassigning to target gives us the "rubber band" effect
			self.targetPoint = constraint;
		}

		[self.clipView scrollToPoint:progressPoint];
		[self.clipView.enclosingScrollView reflectScrolledClipView:self.clipView];
	});
}

@end


@implementation NBBTableView
@dynamic theme;
//
//- (void)dealloc
//{
//    [_scrollAnimation release];
//    [super dealloc];
//}
//
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		NSClipView* cv = (NSClipView*)[self superview];
		_scrollAnimation = [NBBScrollAnimation scrollAnimationWithClipView:cv];//retain];
		self.enclosingScrollView.wantsLayer = YES;
	}

    return self;
}

# pragma mark - NBBThemable
- (id)initWithTheme:(NBBTheme*) theme
{
	CGRect frame = {}; // TODO: implement a way to get frame from theme
	self = [self initWithFrame:frame]; // initWithFrame is the designated initializer for NSControl
	if (self) {
		// special theme initialization will go here
		// could just call applyTheme
	}
	return self;
}

- (BOOL)applyTheme:(NBBTheme*) theme
{
	self.gridColor = [theme borderColorForObject:self];
	return YES;
}

- (void)awakeFromNib
{
	NSClipView* cv = (NSClipView*)[self superview];
	_scrollAnimation = [NBBScrollAnimation scrollAnimationWithClipView:cv];//retain];
	self.enclosingScrollView.wantsLayer = YES;
}

- (void)mouseDown:(NSEvent *)theEvent
{
	_scrollDelta = 0.0;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		if (_scrollAnimation && _scrollAnimation.isAnimating) {
			[_scrollAnimation stopAnimation];
		}
	});
}

- (void)mouseUp:(NSEvent *)theEvent
{
	if (_scrollDelta) {
		[super mouseUp:theEvent];
		// reset the scroll animation
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
			NSClipView* cv = (NSClipView*)[self superview];
			NSPoint newPoint = NSMakePoint(0.0, ([cv documentVisibleRect].origin.y - _scrollDelta));
			NBBScrollAnimation* anim = (NBBScrollAnimation*)_scrollAnimation;
			[anim setCurrentProgress:0.0];
			anim.targetPoint = newPoint;

			[anim startAnimation];
		});
	} else {
		[super mouseDown:theEvent];
	}
}

- (void)mouseDragged:(NSEvent *)theEvent
{
	NSClipView* clipView=(NSClipView*)[self superview];
	NSPoint newPoint = NSMakePoint(0.0, ([clipView documentVisibleRect].origin.y - [theEvent deltaY]));
	// do NOT constrain the point here. we want to "rubber band"
	[clipView scrollToPoint:newPoint];
	[[self enclosingScrollView] reflectScrolledClipView:clipView];

	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		NBBScrollAnimation* anim = (NBBScrollAnimation*)_scrollAnimation;
		anim.originPoint = newPoint;
	});

	// because we have to animate asyncronously, we must save the target value to use later
	// instead of setting it in the animation here
	_scrollDelta = [theEvent deltaY] * 3;
}

- (BOOL)autoscroll:(NSEvent *)theEvent
{
	return NO;
}

@end
