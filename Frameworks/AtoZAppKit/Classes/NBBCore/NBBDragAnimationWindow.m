/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <QuartzCore/QuartzCore.h>
#import "NBBDragAnimationWindow.h"

@implementation NBBDragAnimationWindow

// singleton pattern
#pragma mark - Singleton

+ (NBBDragAnimationWindow*)sharedAnimationWindow
{
	static NBBDragAnimationWindow* sharedAnimationWindow = nil;
    if (sharedAnimationWindow == nil) {
        sharedAnimationWindow = [[super allocWithZone:NULL] init];
    }
    return sharedAnimationWindow;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedAnimationWindow];// retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//- (id)retain
//{
//    return self;
//}
//
//- (NSUInteger)retainCount
//{
//    return NSUIntegerMax;  //denotes an object that cannot be released
//}
//
//- (oneway void)release
//{
//    //do nothing
//}
//
//- (id)autorelease
//{
//    return self;
//}

// end singleton pattern

- (id)init
{
    self = [super initWithContentRect:NSZeroRect
							styleMask:NSBorderlessWindowMask
							  backing:NSBackingStoreBuffered
								defer:NO];

    if (self) {
		NSLog(@"initializing NBB drag animation window.");

		[self setBackgroundColor:[NSColor clearColor]];
		[self setLevel:(NSFloatingWindowLevel + 3000)];
		[self setOpaque:NO];
		[[self contentView] setWantsLayer:YES];
		self.collectionBehavior = NSWindowCollectionBehaviorFullScreenAuxiliary;

		CABasicAnimation *positionAnim = [self animationForKey:@"frame"];
		positionAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		positionAnim.delegate = self;
		positionAnim.repeatDuration = 0.5;
		positionAnim.repeatCount = 1.0;
		// Yes, setting this is necissary even though it seems like our changes should apply without
		[self setAnimations:@{@"frame" : positionAnim}];
		_representedView = nil;
    }
    return self;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)windowStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)deferCreation screen:(NSScreen *)screen
{
	return [self init];
}

- (void)setupDragAnimationWith:(NSView*)view usingDragImage:(NSImage*)image;
{
	_representedView = view; // no need to retain
	[_representedView setHidden:YES];
	[(NSView*)self.contentView layer].contents = image;
	[self setFrame:[_representedView.window convertRectToScreen:_representedView.frame] display:NO];
}

- (void)animateToFrame:(NSRect)frame
{
	[self orderFront:nil];
	[[self animator] setFrame:frame display:YES];
}

#pragma mark Animation Delegation
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	// when the animation is done the window must disapear and reveal the view it was representing
	[_representedView setHidden:NO];
	[self orderOut:nil];
}

- (BOOL) canBecomeKeyWindow
{
	return NO;
}

@end
