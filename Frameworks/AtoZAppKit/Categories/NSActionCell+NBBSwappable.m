/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <objc/runtime.h>

#import "CALayer+NBBControlAnimations.h"
#import "NSActionCell+NBBSwappable.h"
#import "NSControl+NBBControlProxy.h"

#import "NBBDragAnimationWindow.h"
#import "NBBThemeEngine.h"


@implementation NBBKeyboardKeyCell
@end
@implementation NBBVirtualKeyboard
@end

static char const * const delegateTagKey = "_swapDelegate";
static char const * const swappingEnabledKey = "_swappingEnabled";
// we assume we can only have a single drag operation at any given time
NSPoint _dragImageOffset;

@implementation NSActionCell (NBBSwappable)
@dynamic swapDelegate;

- (void)setSwapDelegate:(id<NBBSwappableControlDelegate>)swapDelegate
{
	if ([self.controlView conformsToProtocol:@protocol(NBBSwappableControl)]) {
		// forward to control
		id <NBBSwappableControl> cv = (id <NBBSwappableControl>)self.controlView;
		cv.swapDelegate = swapDelegate;
		return;
	}
	objc_setAssociatedObject(self, delegateTagKey, swapDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id <NBBSwappableControlDelegate>)swapDelegate
{
	if ([self.controlView conformsToProtocol:@protocol(NBBSwappableControl)]) {
		// forward to control
		id <NBBSwappableControl> cv = (id <NBBSwappableControl>)self.controlView;
		return cv.swapDelegate;
	}
	return objc_getAssociatedObject(self, delegateTagKey);
}

- (void)setControlView:(NSView *)view
{
	// this is a bit of a hack, but the easiest way to make the control dragging work.
	// force the control to accept image drags.
	// the control will forward us the drag destination events via our NBBControlProxy category

	[view registerForDraggedTypes:[NSImage imagePasteboardTypes]];

	[super setControlView:view];
}

- (void)finalizeInit
{
	// subscribe to swap notifications
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(swapStateChanged:) name:@"NBBControlSwappingStateChanged" object:nil];
}

// NSCell docs say we have 3 designated initializers.
// be sure we add finalizeInit to all of them
#pragma mark - Inits

- (id)initImageCell:(NSImage *)anImage
{
	self = [super initImageCell:anImage];
    if (self) {
		[self finalizeInit];
    }
    return self;
}

- (id)initTextCell:(NSString *)aString
{
	self = [super initTextCell:aString];
    if (self) {
        [self finalizeInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self finalizeInit];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
//    [super dealloc];
}

- (void)setSwappingEnabled:(BOOL) enable
{
	if ([self.controlView conformsToProtocol:@protocol(NBBSwappableControl)]) {
		// forward to control
		id <NBBSwappableControl> cv = (id <NBBSwappableControl>)self.controlView;
		[cv setSwappingEnabled:enable];
		return;
	}
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	if (enable) {
		id <NBBSwappableControlDelegate> delegate = self.swapDelegate;
		if (delegate == nil || [delegate controlAllowedToSwap:self.controlView]) {
			// post a notification to enable swapping. either no delegate or its ok.
			[nc postNotificationName:@"NBBControlSwappingStateChanged"
							  object:self.controlView userInfo:@{ @"enabled" : @(YES) }];

		}
	} else {
		// post a notification to disable swapping. no need to ask delegate this is always allowed
		[nc postNotificationName:@"NBBControlSwappingStateChanged"
						  object:self.controlView userInfo:@{ @"enabled" : @(NO) }];
	}
}

- (BOOL)swappingEnabled
{
	if ([self.controlView conformsToProtocol:@protocol(NBBSwappableControl)]) {
		// forward to control
		id <NBBSwappableControl> cv = (id <NBBSwappableControl>)self.controlView;
		return [cv swappingEnabled];
	}
	return objc_getAssociatedObject(self, swappingEnabledKey);;
}

- (void)swapStateChanged:(NSNotification*) notification
{
	NSView* cv = self.controlView;
	if ([[notification object] isKindOfClass:[cv class]]) {
		id <NBBSwappableControlDelegate> delegate = self.swapDelegate;
		BOOL enable = [[notification userInfo][@"enabled"] boolValue];
		objc_setAssociatedObject(self, swappingEnabledKey, [NSNumber numberWithBool:enable], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		if (enable) {
			[cv.layer startJiggling];
		} else {
			[cv.layer stopJiggling];
		}
	}
}

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp
{
	BOOL result = NO;
	NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
	NSPoint currentPoint = theEvent.locationInWindow;
	BOOL done = NO;
	BOOL trackContinously = [self startTrackingAt:currentPoint inView:controlView];

	// Catch next mouse-dragged or mouse-up event until timeout (or drag while control is dragable)
	BOOL mouseIsUp = NO;
	NSEvent *event = nil;
	while (!done)
	{
		NSPoint lastPoint = currentPoint;
		
		event = [NSApp nextEventMatchingMask:(NSLeftMouseUpMask|NSLeftMouseDraggedMask)
								   untilDate:endDate
									  inMode:NSEventTrackingRunLoopMode
									 dequeue:YES];

		BOOL swap = [self swappingEnabled];
		if (event && !swap)
		{
			currentPoint = event.locationInWindow;

			// Send continueTracking.../stopTracking...
			if (trackContinously)
			{
				if (![self continueTracking:lastPoint at:currentPoint inView:controlView])
				{
					done = YES;
					[self stopTracking:lastPoint at:currentPoint inView:controlView mouseIsUp:mouseIsUp];
				}
				if (self.isContinuous)
				{
					[NSApp sendAction:self.action to:self.target from:controlView];
				}
			}

			mouseIsUp = (event.type == NSLeftMouseUp);
			done = done || mouseIsUp;

			if (untilMouseUp)
			{
				result = mouseIsUp;
			} else {
				// Check if the mouse left our cell rect
				result = NSPointInRect([controlView convertPoint:currentPoint fromView:nil], cellFrame);
				if (!result)
					done = YES;
			}

			if (done && result && ![self isContinuous])
				[NSApp sendAction:self.action to:self.target from:controlView];
			
		} else {
			done = YES;
			result = YES;

			if (!event) {
				// if there is no event then the timer expired and we should toggle swapping
				swap = !swap;
				[self setSwappingEnabled:swap];
			}

			if (swap) {
				// this bit-o-magic executes on either a drag event or immidiately following timer expiration
				// this initiates the control drag event using NSDragging protocols
				NSControl* cv = (NSControl*)self.controlView;
				NSDraggingSession* session = [cv beginDraggingSessionWithDraggingCell:self
																				event:theEvent];
				_dragImageOffset = [cv convertPoint:[theEvent locationInWindow] fromView:nil];
				// we must NOT let the session handle the cancel/fail animation
				// if we did we would have an ugly fade out and sudden appearance of the control
				// we will fake this animation ourselves. see +initialize and NSDraggingSource methods
				session.animatesToStartingPositionsOnCancelOrFail = NO;
			}
		}
	}
	return result;
}

#pragma mark - NSDraggingSource Methods
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
	switch(context) {
        case NSDraggingContextOutsideApplication:
            return NSDragOperationNone;
            break;

        case NSDraggingContextWithinApplication:
        default:
            return NSDragOperationPrivate;
            break;
    }
}

- (void)draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint
{
	NBBDragAnimationWindow* dw = [NBBDragAnimationWindow sharedAnimationWindow];
	NSControl* cv = (NSControl*)self.controlView;

	NSImage* image = [[NSImage alloc] initWithPasteboard:session.draggingPasteboard];
	[dw setupDragAnimationWith:cv usingDragImage:image];
	[image release];
	NSRect frame = [cv frameForCell:self];
	frame = [cv convertRect:frame toView:nil];
	[dw setFrame:[cv.window convertRectToScreen:frame] display:NO];
}

- (void)draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation
{
	if (operation == NSDragOperationNone) {
		NBBDragAnimationWindow* dw = [NBBDragAnimationWindow sharedAnimationWindow];
		NSRect frame = dw.frame;

		NSPoint start = screenPoint;
		start.y += _dragImageOffset.y;
		start.x -= _dragImageOffset.x;

		[dw setFrameTopLeftPoint:start];
		[dw animateToFrame:frame];
	}
	// now tell the control view the drag ended so it can do any cleanup it needs
	// this is somewhat hackish
	[self.controlView draggingEnded:nil];
}

- (BOOL)ignoreModifierKeysForDraggingSession:(NSDraggingSession *)session
{
	return YES;
}

#pragma mark - NSDraggingDestination Methods
- (BOOL)wantsPeriodicDraggingUpdates
{
	return NO;
}

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender
{
	if ([self swappingEnabled]) {
		[self setHighlighted:YES];
		return NSDragOperationPrivate;
	}
	return NSDragOperationNone;
}

- (void)draggingExited:(id < NSDraggingInfo >)sender
{
	[self setHighlighted:NO];
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender
{
	return YES;
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender
{
	return YES;
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender
{
	NSView* dest = self.controlView;
	NSView* source = [(NSActionCell*)[sender draggingSource] controlView];
	NSRect srcFrame = source.frame;
	NSRect dstFrame = dest.frame;

	NSAssert((dest && source && dest != source),
			 @"drag source %@ and drag dest %@ must not be null or equal.",
			 source, dest);

	[self setHighlighted:NO];

	// we need to obtain the coordinates for the drag image representing the source control
	NSRect startFrame = source.frame;
	startFrame.origin = [sender draggedImageLocation];
	[source setFrame:startFrame]; // move the control before making it visible (no animation)
	[source setHidden:NO];

	CAAnimation* anim = [dest animationForKey:@"frameOrigin"];
	anim.delegate = self;
	[anim setValue:source forKey:@"dragSource"];
	[anim setValue:dest forKey:@"dragDest"];

	// animate both controls to the others original frame
	[[dest animator] setFrame:srcFrame];
	[[source animator] setFrame:dstFrame];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if (flag) {
		id source = [theAnimation valueForKey:@"dragSource"];
		id dest = [theAnimation valueForKey:@"dragDest"];
		CAAnimation* anim = [dest animationForKey:@"frameOrigin"];
		// FIXME: this is a nasty hack. i don't know why this method gets called repeatedly
		// but im doing this test to avoid calling swapView more than once per swap.
		if (anim.delegate == self) {
			anim.delegate = nil;

			// even though we just set the frames we need to tell the ThemeEngine
			// otherwise "Auto Layout" will revert our change.
			// the ThemeEngine will take care of the layout constraints for us
			// the ThemeEngine will also persist our changes
			[[NBBThemeEngine sharedThemeEngine] swapView:source withView:dest persist:YES];
		}
	}
}

@end
