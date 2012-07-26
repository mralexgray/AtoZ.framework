//
//  CALayer+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/13/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "CALayer+AtoZ.h"
#import "AtoZ.h"





@implementation CALayer (AtoZ)

+ (CALayer*)closeBoxLayer
{
	CALayer *layer = [CALayer closeBoxLayerForLayer:nil];
	return layer;
}

+ (CALayer*)closeBoxLayerForLayer:(CALayer*)parentLayer;
{
    CALayer *layer = [CALayer layer];
    [layer setFrame:CGRectMake(0.0, 0, 
                               30.0, 30.0)];
	
    [layer setBackgroundColor:cgBLACK];
    [layer setShadowColor:cgBLACK];
    [layer setShadowOpacity:1.0];
    [layer setShadowRadius:5.0];
    [layer setBorderColor:cgWHITE];
    [layer setBorderWidth:3];
    [layer setCornerRadius:15];
	if (parentLayer) [layer setDelegate:parentLayer];
	return layer;
}


- (void)flipLayer:(CALayer*)top withLayer:(CALayer*)bottom
{
	#define ANIMATION_DURATION_IN_SECONDS (1.0)
    // Hold the shift key to flip the window in slo-mo. It's really cool!
    CGFloat flipDuration = ANIMATION_DURATION_IN_SECONDS;// * (self.isDebugging || window.currentEvent.modifierFlags & NSShiftKeyMask ? 10.0 : 1.0);
	
    // The hidden layer is "in the back" and will be rotating forward. The visible layer is "in the front" and will be rotating backward
    CALayer *hiddenLayer = bottom; //[frontView.isHidden ? frontView : backView layer];
    CALayer *visibleLayer = top;// [frontView.isHidden ? backView : frontView layer];
    
    // Before we can "rotate" the window, we need to make the hidden view look like it's facing backward by rotating it pi radians (180 degrees). We make this its own transaction and supress animation, because this is already the assumed state
    [CATransaction begin]; {
        [CATransaction setValue:[NSNumber numberWithBool:YES] forKey:kCATransactionDisableActions];
        [hiddenLayer setValue:[NSNumber numberWithDouble:M_PI] forKeyPath:@"transform.rotation.y"];
//        if (self.isDebugging) // Shadows screw up corner finding
//            [self _hideShadow:YES];
    } [CATransaction commit];
    
    // There's no way to know when we are halfway through the animation, so we have to use a timer. On a sufficiently fast machine (like a Mac) this is close enough. On something like an iPhone, this can cause minor drawing glitches
//    [self performSelector:@selector(_swapViews) withObject:nil afterDelay:flipDuration / 2.0];
    
    // For debugging, sample every half-second
//    if (self.isDebugging) {
//        [debugger reset];
        
//        NSUInteger frameIndex;
//        for (frameIndex = 0; frameIndex < flipDuration; frameIndex++)
//            [debugger performSelector:@selector(sample) withObject:nil afterDelay:(CGFloat)frameIndex / 2.0];
		
        // We want a sample right before the center frame, when the panel is still barely visible
//        [debugger performSelector:@selector(sample) withObject:nil afterDelay:(CGFloat)flipDuration / 2.0 - 0.05];
//    }
    
    // Both layers animate the same way, but in opposite directions (front to back versus back to front)
    [CATransaction begin]; {
        [hiddenLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:NO] forKey:@"flipGroup"];
        [visibleLayer addAnimation:[self _flipAnimationWithDuration:flipDuration isFront:YES] forKey:@"flipGroup"];
    } [CATransaction commit];
}


- (CAAnimationGroup *)_flipAnimationWithDuration:(CGFloat)duration isFront:(BOOL)isFront;
{
    // Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
	
    // The hidden view rotates from negative to make it look like it's in the back
#define LEFT_TO_RIGHT (isFront ? -M_PI : M_PI)
//#define RIGHT_TO_LEFT (isFront ? M_PI : -M_PI)
//    flipAnimation.toValue = [NSNumber numberWithDouble:[backView isHidden] ? LEFT_TO_RIGHT : RIGHT_TO_LEFT];
    
    // Shrinking the view makes it seem to move away from us, for a more natural effect
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	
//    shrinkAnimation.toValue = [NSNumber numberWithDouble:self.scale];
	
    // We only have to animate the shrink in one direction, then use autoreverse to "grow"
    shrinkAnimation.duration = duration / 2.0;
    shrinkAnimation.autoreverses = YES;
    
    // Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];
	
    // As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
    // Set ourselves as the delegate so we can clean up when the animation is finished
    animationGroup.delegate = self;
    animationGroup.duration = duration;
	
    // Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
	
    return animationGroup;
}


//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
	NSArray *colors =  $array(
							  (id)[[NSColor colorWithDeviceWhite:0.15f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.19f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.20f alpha:1.0f]CGColor],
							  [[NSColor colorWithDeviceWhite:0.25f alpha:1.0f] CGColor]);
	NSArray *locations = $array($float(0),$float(.5), $float(.5), $float(1));
	CAGradientLayer *headerLayer = [CAGradientLayer layer];
	headerLayer.colors = colors;
	headerLayer.locations = locations;
	return headerLayer;
	
}

@end
