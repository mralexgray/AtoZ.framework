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
	//[Transpose Matrix][1]

- (CATransform3D)rectToQuad:(NSRect)rect quadTLX:(double)x1a quadTLY:(double)y1a quadTRX:(double)x2a quadTRY:(double)y2a quadBLX:(double)x3a quadBLY:(double)y3a quadBRX:(double)x4a quadBRY:(double)y4a
{
	double X = rect.origin.x;
	double Y = rect.origin.y;
	double W = rect.size.width;
	double H = rect.size.height;

	double y21 = y2a - y1a;
	double y32 = y3a - y2a;
	double y43 = y4a - y3a;
	double y14 = y1a - y4a;
	double y31 = y3a - y1a;
	double y42 = y4a - y2a;

	double a = -H*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42);
	double b = W*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);
	double c = H*X*(x2a*x3a*y14 + x2a*x4a*y31 - x1a*x4a*y32 + x1a*x3a*y42) - H*W*x1a*(x4a*y32 - x3a*y42 + x2a*y43) - W*Y*(x2a*x3a*y14 + x3a*x4a*y21 + x1a*x4a*y32 + x1a*x2a*y43);

	double d = H*(-x4a*y21*y3a + x2a*y1a*y43 - x1a*y2a*y43 - x3a*y1a*y4a + x3a*y2a*y4a);
	double e = W*(x4a*y2a*y31 - x3a*y1a*y42 - x2a*y31*y4a + x1a*y3a*y42);
	double f = -(W*(x4a*(Y*y2a*y31 + H*y1a*y32) - x3a*(H + Y)*y1a*y42 + H*x2a*y1a*y43 + x2a*Y*(y1a - y3a)*y4a + x1a*Y*y3a*(-y2a + y4a)) - H*X*(x4a*y21*y3a - x2a*y1a*y43 + x3a*(y1a - y2a)*y4a + x1a*y2a*(-y3a + y4a)));

	double g = H*(x3a*y21 - x4a*y21 + (-x1a + x2a)*y43);
	double h = W*(-x2a*y31 + x4a*y31 + (x1a - x3a)*y42);
	double i = W*Y*(x2a*y31 - x4a*y31 - x1a*y42 + x3a*y42) + H*(X*(-(x3a*y21) + x4a*y21 + x1a*y43 - x2a*y43) + W*(-(x3a*y2a) + x4a*y2a + x2a*y3a - x4a*y3a - x2a*y4a + x3a*y4a));

        //Transposed matrix
	CATransform3D transform;
	transform.m11 = a / i;
	transform.m12 = d / i;
	transform.m13 = 0;
	transform.m14 = g / i;
	transform.m21 = b / i;
	transform.m22 = e / i;
	transform.m23 = 0;
	transform.m24 = h / i;
	transform.m31 = 0;
	transform.m32 = 0;
	transform.m33 = 1;
	transform.m34 = 0;
	transform.m41 = c / i;
	transform.m42 = f / i;
	transform.m43 = 0;
	transform.m44 = i / i;
	return transform;
}


//NSImage *image = // load a image
//CALayer *layer = [CALayer layer];
//[layer setContents:image];
//[view setLayer:myLayer];
//[view setFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
//view.layer.transform = [self rectToQuad:view.frame quadTLX:0 quadTLY:0 quadTRX:image.size.width quadTRY:20 quadBLX:0 quadBLY:image.size.height quadBRX:image.size.width quadBRY:image.size.height + 90];
//
//[1]: http://codingincircles.com/2010/07/major-misunderstanding/


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