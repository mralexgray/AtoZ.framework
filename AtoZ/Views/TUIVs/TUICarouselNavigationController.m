//
//  TUICarouselNavigationController.m
//  TwUI
//
//  Created by Serhey Tkachenko on 3/24/13.
//
//
#import "TUICarouselNavigationController.h"
#import "TUIView.h"
@interface TUICarouselNavigationController ()
@property (unsafe_unretained, nonatomic, readwrite) TUIViewController *currentController;
@property (nonatomic) NSMutableArray *controllers;
@end
static CGFloat const TUINavigationControllerAnimationDuration = 0.25f;
@implementation TUICarouselNavigationController
- (id)initWithViewControllers:(NSArray *)viewControllers {
	return [self initWithViewControllers:viewControllers initialController:viewControllers[0]];
}
- (id)initWithViewControllers:(NSArray *)viewControllers initialController:(id)initialController {
	self = [super init];
	if (self) {
		 NSAssert([viewControllers count] > 0, @"Can't create carousel navigation controller with empty controllers list");
		 _controllers = [viewControllers mutableCopy];
		 [_controllers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		    [obj setNavigationController:(TUINavigationController *)self];
		}];
		 NSAssert([viewControllers indexOfObject:initialController] != NSNotFound, @"Initial controller must be present in controllers list");
		 self.currentController = initialController;
		 self.view.clipsToBounds = YES;
	 }
	return self;
}
- (void)loadView {
	self.view = [[TUIView alloc] initWithFrame:CGRectZero];
	self.view.backgroundColor = [NSColor lightGrayColor];
	self.view.viewDelegate = (id<TUIViewDelegate>)self;
	TUIViewController *visible = [self currentController];
	[visible viewWillAppear:NO];
	if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)])
		[self.delegate navigationController:self willShowViewController:visible animated:NO];
	[self.view addSubview:visible.view];
	visible.view.frame = self.view.bounds;
	visible.view.autoresizingMask = TUIViewAutoresizingFlexibleSize;
	[visible viewDidAppear:YES];
	if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)])
		[self.delegate navigationController:self didShowViewController:visible animated:NO];
}
#pragma mark - Properties
- (NSArray *)viewControllers {
	return [NSArray arrayWithArray:_controllers];
}
- (TUIViewController *)nextViewController {
	NSInteger nextControllerIndex = [_controllers indexOfObject:self.currentController] + 1;
	if (nextControllerIndex < [_controllers count])
		return _controllers[nextControllerIndex];
	else
		return nil;
}
- (TUIViewController *)prevViewController {
	NSInteger nextControllerIndex = [_controllers indexOfObject:self.currentController] - 1;
	if (nextControllerIndex >= 0)
		return _controllers[nextControllerIndex];
	else
		return nil;
}
#pragma mark - Methods
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
	[self setViewControllers:viewControllers animated:animated completion:nil];
}
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	CGFloat duration = (animated ? TUINavigationControllerAnimationDuration : 0);
	TUIViewController *viewController = viewControllers[0];
	BOOL containedAlready = ([_controllers containsObject:viewController]);
	[CATransaction begin];
	//Push if it's not in the stack, pop back if it is
	[self.view addSubview:viewController.view];
	viewController.view.frame = (containedAlready ? TUINavigationOffscreenLeftFrame(self.view.bounds) : TUINavigationOffscreenRightFrame(self.view.bounds));
	[CATransaction flush];
	[CATransaction commit];
	TUIViewController *last = [self currentController];
//	for (TUIViewController *controller in _controllers) {
//		controller.navigationController = nil;
//	}
	[_controllers removeAllObjects];
	[_controllers addObjectsFromArray:viewControllers];
//	for (TUIViewController *controller in viewControllers) {
//		controller.navigationController = self;
//	}
	[TUIView animateWithDuration:duration animations:^{
	    last.view.frame = (containedAlready ? TUINavigationOffscreenRightFrame(self.view.bounds) : TUINavigationOffscreenLeftFrame(self.view.bounds));
	    viewController.view.frame = self.view.bounds;
	} completion:^(BOOL finished) {
	    [last.view removeFromSuperview];
	    [viewController viewDidAppear:animated];
	    if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)])
			[self.delegate navigationController:self didShowViewController:viewController animated:animated];
	    [last viewDidDisappear:animated];
	    self.currentController = viewController;
	    if (completion)
			completion(finished);
	}];
}
- (void)slideToNextViewControllerAnimated:(BOOL)animated {
	[self slideToNextViewControllerAnimated:animated completion:nil];
}
- (void)slideToNextViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	[self slideToViewController:self.nextViewController animated:animated completion:completion];
}
- (void)slideToPrevViewControllerAnimated:(BOOL)animated {
	[self slideToViewController:self.prevViewController animated:animated completion:nil];
}
- (void)slideToPrevViewControllerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	[self slideToViewController:self.prevViewController animated:animated completion:completion];
}
- (void)slideToViewController:(TUIViewController *)newController animated:(BOOL)animated {
	[self slideToViewController:newController animated:animated completion:nil];
}
- (void)slideToViewController:(TUIViewController *)newController animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
	if (![_controllers containsObject:newController]) {
		 NSLog(@"View controller %@ is not in arrat", newController);
		 return;
	 }
	TUIViewController *currentController = self.currentController;
	NSInteger indexOfCurrentVC = [_controllers indexOfObject:currentController];
	NSInteger indexOfNewVC = [_controllers indexOfObject:newController];
	BOOL isSlideToTheRight = indexOfNewVC < indexOfCurrentVC;
	[self.view addSubview:newController.view];
	newController.view.frame = isSlideToTheRight ? TUINavigationOffscreenLeftFrame(self.view.bounds) : TUINavigationOffscreenRightFrame(self.view.bounds);
	[currentController viewWillDisappear:animated];
	[newController viewWillAppear:animated];
	if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)])
		[self.delegate navigationController:self willShowViewController:newController animated:animated];
	CGFloat duration = (animated ? TUINavigationControllerAnimationDuration : 0);
	[TUIView animateWithDuration:duration animations:^{
	    currentController.view.frame = isSlideToTheRight ? TUINavigationOffscreenRightFrame(self.view.bounds) : TUINavigationOffscreenLeftFrame(self.view.bounds);
	    newController.view.frame = self.view.bounds;
	    if (_needsBlurWhenSlide) {
//            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints: 0:1 : 1:1]];
	        TUIApplyBlurForLayer(newController.view.layer);
	        TUIApplyBlurForLayer(currentController.view.layer);
		}
	} completion:^(BOOL finished) {
	    [currentController.view removeFromSuperview];
	    currentController.view.layer.filters = nil;
	    newController.view.layer.filters = nil;
	    [newController viewDidAppear:animated];
	    if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)])
			[self.delegate navigationController:self didShowViewController:newController animated:animated];
	    [currentController viewDidDisappear:animated];
	    self.currentController = newController;
	    if (completion)
			completion(finished);
	}];
}
#pragma mark - Events
- (void)view:(TUIView *)v scrollWheel:(NSEvent *)theEvent;
{
	CGFloat treshold = 10;
	if (!_couldUseSlideEvent || ![v eventInside:theEvent] ||
	    [theEvent type] != NSScrollWheel || ![NSEvent isSwipeTrackingFromScrollEventsEnabled] ||
	    [theEvent phase] == NSEventPhaseNone ||
	    ABS([theEvent scrollingDeltaY]) >= ABS([theEvent scrollingDeltaX]) ||
	    ABS([theEvent scrollingDeltaX]) < treshold) {
		 // Not posible to start tracking
		 return;
	 }
	BOOL isSlideToTheLeft = [theEvent scrollingDeltaX] < 0;
	BOOL animated = YES;
	TUIViewController *currentController = self.currentController;
	TUIViewController *newController = isSlideToTheLeft ? self.nextViewController : self.prevViewController;
	if (!newController)
//        NSLog(@"There is no viewController to slide");
		return;
	// Prepare to animations
	CGFloat duration = (animated ? TUINavigationControllerAnimationDuration : 0);
	__block BOOL animationCancelled = NO;
	[theEvent trackSwipeEventWithOptions:NSEventSwipeTrackingLockDirection | NSEventSwipeTrackingClampGestureAmount
	            dampenAmountThresholdMin:-1 max:1
	                        usingHandler:^(CGFloat gestureAmount, NSEventPhase phase, BOOL isComplete, BOOL *stop) {
	    if (animationCancelled) {
	        *stop = YES;
	        void (^ compleationBlock)(BOOL) = ^(BOOL finished) {
	            if ([self.delegate respondsToSelector:@selector(navigationController:cancelShowViewController:animated:)])
					[self.delegate navigationController:self cancelShowViewController:newController animated:animated];
	            [newController.view removeFromSuperview];
//                                        if (isSlideToTheRight) {
//                                            [_controllers removeObject:newController];
//                                            newController.navigationController = nil;
//                                        }
	            [newController viewDidDisappear:animated];
	            [currentController viewDidAppear:animated];
			};
	        CGRect lastRect = self.view.bounds;
	        CGRect nextRect = isSlideToTheLeft ? TUINavigationOffscreenRightFrame(self.view.bounds) : TUINavigationOffscreenLeftFrame(self.view.bounds);
	        if (!CGRectEqualToRect(currentController.view.frame, lastRect) && !CGRectEqualToRect(newController.view.frame, nextRect)) {
	            [TUIView animateWithDuration:duration animations:^{
	                    currentController.view.frame = lastRect;
	                    newController.view.frame = nextRect;
					} completion:compleationBlock];
			} else compleationBlock(YES);
	        return;
		}
	    if (phase == NSEventPhaseBegan) {
	        // Setup animation overlay layers
	        // All swipes should be looks like basic animaiton than we have used like status bar setup
	        if ([self.delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)])
				[self.delegate navigationController:self willShowViewController:newController animated:animated];
	        [currentController viewWillDisappear:animated];
	        [newController viewWillAppear:animated];
	        [self.view addSubview:newController.view];
	        //Make sure the app draws the frame offscreen instead of just 'popping' it in
	        [CATransaction begin];
	        newController.view.frame = isSlideToTheLeft ? TUINavigationOffscreenRightFrame(self.view.bounds) : TUINavigationOffscreenLeftFrame(self.view.bounds);
	        [CATransaction flush];
	        [CATransaction commit];
		}
	    // Update animation overlay to match gestureAmount
	    if (phase == NSEventPhaseEnded) {
	        // The user has completed the gesture successfully.
	        // This handler will continue to get called with updated gestureAmount
	        // to animate to completion, but just in case we need
	        // to cancel the animation (due to user swiping again) setup the
	        // controller / view to point to the new content / index / whatever
	        return;
		} else if (phase == NSEventPhaseCancelled) {
	        // The user has completed the gesture un-successfully.
	        // This handler will continue to get called with updated gestureAmount
	        // But we don't need to change the underlying controller / view settings.
	        animationCancelled = YES;
		}
	    if (isComplete) {
	        // Animation has completed and gestureAmount is either -1, 0, or 1.
	        // This handler block will be released upon return from this iteration.
	        // Note: we already updated our view to use the new (or same) content
	        // above. So no need to do that here. Just...
	        // Tear down animation overlay here
	        [newController viewDidAppear:animated];
	        if ([self.delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)])
				[self.delegate navigationController:self didShowViewController:newController animated:animated];
	        [currentController.view removeFromSuperview];
	        [currentController viewDidDisappear:animated];
	        self.currentController = newController;
//                                    if (!isSlideToTheRight) {
//                                        currentController.navigationController = nil;
//                                        [_controllers removeObject:currentController];
//                                    }
		} else {
	        gestureAmount = ([theEvent isDirectionInvertedFromDevice] ? 1 : -1) * gestureAmount;
	        CGRect lastRect = self.view.bounds;
	        CGRect nextRect = self.view.bounds;
	        lastRect.origin.x = gestureAmount * CGRectGetWidth(self.view.bounds);
	        if (isSlideToTheLeft)
				nextRect.origin.x = (1 - ABS(gestureAmount)) * CGRectGetWidth(self.view.bounds);
	        else
				nextRect.origin.x = (-1 + ABS(gestureAmount)) * CGRectGetWidth(self.view.bounds);
	        nextRect = CGRectIntegral(nextRect);
	        lastRect = CGRectIntegral(lastRect);
	        if (!CGRectEqualToRect(newController.view.frame, nextRect) && !CGRectEqualToRect(lastRect, currentController.view.frame)) {
	            [CATransaction begin];
	            [CATransaction setDisableActions:YES];
	            newController.view.frame = nextRect;
	            currentController.view.frame = lastRect;
	            [CATransaction flush];
	            [CATransaction commit];
			}
		}
	}];
}
#pragma mark - Private
static inline CGRect TUINavigationOffscreenLeftFrame(CGRect bounds) {
	CGRect offscreenLeft = bounds;
	offscreenLeft.origin.x -= bounds.size.width;
	return offscreenLeft;
}
static inline CGRect TUINavigationOffscreenRightFrame(CGRect bounds) {
	CGRect offscreenRight = bounds;
	offscreenRight.origin.x += bounds.size.width;
	return offscreenRight;
}
NS_INLINE void TUIApplyBlurForLayer(CALayer *layer) {
	CIFilter *motionBlur = [CIFilter filterWithName:@"CIMotionBlur" keysAndValues:kCIInputRadiusKey, @(0.0), nil];
	[motionBlur setName:@"motionBlur"];
	CABasicAnimation *motionBlurAnimation = [CABasicAnimation animation];
	motionBlurAnimation.keyPath = @"filters.motionBlur.inputRadius";
	motionBlurAnimation.fromValue = @(7.0);
	motionBlurAnimation.toValue = @(0.0);
	motionBlurAnimation.fillMode = kCAFillModeForwards;
	motionBlurAnimation.removedOnCompletion = YES;
	layer.filters = @[motionBlur];
	[layer addAnimation:motionBlurAnimation forKey:@"motionBlurAnimation"];
}
@end
