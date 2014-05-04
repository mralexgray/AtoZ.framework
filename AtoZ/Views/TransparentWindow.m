
//  TransparentWindow.m
//  RoundedFloatingPanel

//  Created by Matt Gemmell on Thu Jan 08 2004.
//  <http://iratescotsman.com/>

#import "TransparentWindow.h"
#import "AtoZ.h"

@interface   TransparentWindow ()

- (NSWindow *) windowForAnimation:(NSRect)aFrame;
- (CALayer *) layerFromView :(NSView*)view;
NSRect RectToScreen(NSRect aRect, NSView *aView);
NSRect RectFromScreen(NSRect aRect, NSView *aView);
NSRect RectFromViewToView(NSRect aRect, NSView *fromView, NSView *toView);
- (CAAnimation *) animationWithDuration:(CGFloat)time flip:(BOOL)bFlip right:(BOOL)rightFlip;
@end
@implementation TransparentWindow

- (id) initWithContentRect:(NSRect)contentRect	   	  styleMask:(NSUInteger)aStyle
				  backing:(NSBackingStoreType)	bufferingType defer:(BOOL)flag {
		if (self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask
				  backing:NSBackingStoreBuffered 			  defer:NO]) {

		[self setStyleMask: NSResizableWindowMask];
//		[self setLevel: NSStatusWindowLevel];//NSScreenSaverWindowLevel];//
//		[self setBackgroundColor: [NSColor clearColor]];
//		[self setAlphaValue:1.0];
//		[self setOpaque:YES];
		[self setHasShadow:NO];
		[self setMovable:YES];
		duration = 2.0;
		flipRight = YES;

		return self;
	}
	
	return nil;
}
- (BOOL) canBecomeKeyWindow
{
	return YES;
}

@synthesize flipRight;
@synthesize duration;

	 // метод создает окно в котором будет производиться анимация
	 // с изображением окна
- (NSWindow *) windowForAnimation:(NSRect)aFrame {

	 NSWindow *wnd =  [NSWindow.alloc initWithContentRect:aFrame
												  styleMask:NSBorderlessWindowMask
													backing:NSBackingStoreBuffered
													  defer:NO];
	 [wnd setOpaque:NO];
	 [wnd setHasShadow:NO];
	 [wnd setBackgroundColor:[NSColor clearColor]];
	 [wnd.contentView setWantsLayer:YES];

	 return wnd;
}

	 // создает слой для анимации с изображением вида
- (CALayer *) layerFromView :(NSView*)view {

	 NSBitmapImageRep *image = [view bitmapImageRepForCachingDisplayInRect:view.bounds];
	 [view cacheDisplayInRect:view.bounds toBitmapImageRep:image];

	 CALayer *layer = [CALayer layer];
	 layer.contents = (id)image.CGImage;
	 layer.doubleSided = NO;

		  // Тень окна, используемого в Mac OS X 10.6
	 [layer setShadowOpacity:0.5f];
	 [layer setShadowOffset:CGSizeMake(0,-10)];
	 [layer setShadowRadius:15.0f];
	 return layer;
}

	 // Следующие три функции преобразования координат

NSRect RectToScreen(NSRect aRect, NSView *aView) {
	 aRect = [aView convertRect:aRect toView:nil];
	 aRect.origin = [aView.window convertBaseToScreen:aRect.origin];
	 return aRect;
}

NSRect RectFromScreen(NSRect aRect, NSView *aView) {
	 aRect.origin = [aView.window convertScreenToBase:aRect.origin];
	 aRect = [aView convertRect:aRect fromView:nil];
	 return aRect;
}

NSRect RectFromViewToView(NSRect aRect, NSView *fromView, NSView *toView) {

	 aRect = RectToScreen(aRect, fromView);
	 aRect = RectFromScreen(aRect, toView);

	 return aRect;
}

	 // Создание Core Animation отдаляющей и разворачивающей окно
- (CAAnimation *) animationWithDuration:(CGFloat)time flip:(BOOL)bFlip right:(BOOL)rightFlip{

	 CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];

	 CGFloat startValue, endValue;

	 if ( rightFlip ) {
		  startValue = bFlip ? 0.0f : -M_PI;
		  endValue = bFlip ? M_PI : 0.0f;
	 } else {
		  startValue = bFlip ? 0.0f : M_PI;
		  endValue = bFlip ? -M_PI : 0.0f;
	 }

	 flipAnimation.fromValue = @(startValue);
	 flipAnimation.toValue = @(endValue);

	 CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	 scaleAnimation.toValue = @1.3f;
	 scaleAnimation.duration = time * 0.5;
	 scaleAnimation.autoreverses = YES;

	 CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	 animationGroup.animations = @[flipAnimation, scaleAnimation];
	 animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	 animationGroup.duration = time;
	 animationGroup.fillMode = kCAFillModeForwards;
	 animationGroup.removedOnCompletion = NO;

	 return animationGroup;
}

	 // метод, вызываемый после окончания анимации

- (void) animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {

	 if (flag) {
		  [mTargetWindow makeKeyAndOrderFront:nil];
		  [mAnimationWindow orderOut:nil];

		  mTargetWindow = nil; // освобождаем память
		  mAnimationWindow = nil;
	 }
}

	 //------------------------

	 // Собственно сама функция, разворачивающая окно

- (void) flip:(NSWindow *)activeWindow to:(NSWindow *)targetWindow {

	 CGFloat durat = duration * (activeWindow.currentEvent.modifierFlags & NSShiftKeyMask ? 10.0 : 1.0);
	 CGFloat zDistance = 1500.0f;

	 NSView *activeView = [activeWindow.contentView superview];
	 NSView *targetView = [targetWindow.contentView superview];

		  // Создаем окно для анимации
	 CGFloat maxWidth  = MAX(NSWidth(activeWindow.frame), NSWidth(targetWindow.frame)) + 500;
	 CGFloat maxHeight = MAX(NSHeight(activeWindow.frame), NSHeight(targetWindow.frame)) + 500;

	 CGRect animationFrame = CGRectMake(NSMidX(activeWindow.frame) - (maxWidth / 2),
										NSMidY(activeWindow.frame) - (maxHeight / 2),
										maxWidth,
										maxHeight);

	 mAnimationWindow = [self windowForAnimation:NSRectFromCGRect(animationFrame)];

		  // Добавляем перспективу
	 CATransform3D transform = CATransform3DIdentity;
	 transform.m34 = -1.0 / zDistance;
	 [mAnimationWindow.contentView layer].sublayerTransform = transform;

		  // Перемещение target window к active window
	 CGRect targetFrame = CGRectMake(NSMidX(activeWindow.frame) - (NSWidth(targetWindow.frame) / 2 ),
									 NSMaxY(activeWindow.frame) - NSHeight(targetWindow.frame),
									 NSWidth(targetWindow.frame),
									 NSHeight(targetWindow.frame));

	 [targetWindow setFrame:NSRectFromCGRect(targetFrame) display:NO];

	 mTargetWindow = targetWindow;

		  // New Active/Target Layers
	 [CATransaction begin];
	 CALayer *activeWindowLayer = [self layerFromView: activeView];
	 CALayer *targetWindowLayer = [self layerFromView:targetView];
	 [CATransaction commit];

	 activeWindowLayer.frame = NSRectToCGRect(RectFromViewToView(activeView.frame, activeView, [mAnimationWindow contentView]));
	 targetWindowLayer.frame = NSRectToCGRect(RectFromViewToView(targetView.frame, targetView, [mAnimationWindow contentView]));

	 [CATransaction begin];
	 [[mAnimationWindow.contentView layer] addSublayer:activeWindowLayer];
	 [CATransaction commit];

	 [mAnimationWindow orderFront:nil];

	 [CATransaction begin];
	 [[mAnimationWindow.contentView layer] addSublayer:targetWindowLayer];
	 [CATransaction commit];

		  // Animate our new layers
	 [CATransaction begin];
	 CAAnimation *activeAnim = [self animationWithDuration:(durat * 0.5) flip:YES right:flipRight];
	 CAAnimation *targetAnim = [self animationWithDuration:(durat * 0.5) flip:NO  right:flipRight];
	 [CATransaction commit];

	 targetAnim.delegate = self;
	 [activeWindow orderOut:nil];

	 [CATransaction begin];
	 [activeWindowLayer addAnimation:activeAnim forKey:@"flipWnd"];
	 [targetWindowLayer addAnimation:targetAnim forKey:@"flipWnd"];
	 [CATransaction commit];
}


/*- (void) mouseDragged:(NSEvent *)theEvent
{
	NSPoint currentLocation;
	NSPoint newOrigin;
	NSRect  screenFrame = [[NSScreen mainScreen] frame];
	NSRect  windowFrame = [self frame];
	
	currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
	newOrigin.x = currentLocation.x - initialLocation.x;
	newOrigin.y = currentLocation.y - initialLocation.y;
	
	if( (newOrigin.y + windowFrame.size.height) > (NSMaxY(screenFrame) - 22) ){
//	[NSMenu menuBarHeight]) ){
		// Prevent dragging into the menu bar area
//	newOrigin.y = NSMaxY(screenFrame) - windowFrame.size.height - 22;
//	 [NSMenuView menuBarHeight];
	}

	if (newOrigin.y < NSMinY(screenFrame)) {
		// Prevent dragging off bottom of screen
		newOrigin.y = NSMinY(screenFrame);
	}
	if (newOrigin.x < NSMinX(screenFrame)) {
		// Prevent dragging off left of screen
		newOrigin.x = NSMinX(screenFrame);
	}
	if (newOrigin.x > NSMaxX(screenFrame) - windowFrame.size.width) {
		// Prevent dragging off right of screen
		newOrigin.x = NSMaxX(screenFrame) - windowFrame.size.width;
	}
	
	
	[self setFrameOrigin:newOrigin];
}
- (void) mouseDown:(NSEvent *)theEvent
{	
	NSRect windowFrame = [self frame];
	
	// Get mouse location in global coordinates
	initialLocation = [self convertBaseToScreen:[theEvent locationInWindow]];
	initialLocation.x -= windowFrame.origin.x;
	initialLocation.y -= windowFrame.origin.y;
}
*/

@end
