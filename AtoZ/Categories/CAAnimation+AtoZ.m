//
//  CAAnimation+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/13/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "CAAnimation+AtoZ.h"
#import "AtoZ.h"

//CGFloat DegreesToRadians(CGFloat degrees)
//{
//    return degrees * M_PI / 180;
//}

//NSNumber* DegreesToNumber(CGFloat degrees)
//{
//    return [NSNumber numberWithFloat:
//            DegreesToRadians(degrees)];
//}



@implementation CAAnimation (AtoZ)

+ (CAAnimation*)shakeAnimation;

{
	CAKeyframeAnimation * animation;
	animation = [CAKeyframeAnimation 
                 animationWithKeyPath:@"transform.rotation.z"];
    [animation setDuration:0.3];
    [animation setRepeatCount:10000];
    
    // Try to get the animation to begin to start with a small offset
    // that will make it shake out of sync with other layers.
    srand([[NSDate date] timeIntervalSince1970]);
    float rand = (float)random();
    [animation setBeginTime:
	 CACurrentMediaTime() + rand * .0000000001];
	
	NSMutableArray *values = [NSMutableArray array];
    // Turn right
    [values addObject:DegreesToNumber(-2)];
    // Turn left
    [values addObject:DegreesToNumber(2)];
    // Turn right
    [values addObject:DegreesToNumber(-2)];    
	// Set the values for the animation
	[animation setValues:values];
    
	return animation;
}


+ (CAAnimation*)colorAnimationForLayer:(CALayer *)theLayer 
	withStartingColor:(NSColor*)color1 endColor:(NSColor*)color2{
	
	CAAnimation * animation = [[CAAnimation animation]
	  animationWithKeyPath:@"backgroundColor"];
	NSDictionary *dic = $map(	(id)[color1 CGColor], 	@"fromValue",
							 	(id)[color2 CGColor], 	@"toValue", 
							 	$float(2.0), 			@"duration",
							 	YES,						@"removedOnCompletion", 
								kCAFillModeForwards, 	@"fillMode");
	[animation setValuesForKeysWithDictionary:dic];
	[theLayer addAnimation:animation forKey:@"color"];    
	return animation;
}

+ (CAAnimation*)rotateAnimationForLayer:(CALayer *)theLayer start:(CGFloat)starting end:(CGFloat)ending {
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	[animation setFromValue:DegreesToNumber(starting)];
	[animation setToValue:DegreesToNumber(ending)];
	
	[animation setRemovedOnCompletion:NO];
	[animation setFillMode:kCAFillModeForwards];
	
//	previousValue = [slider floatValue];
	
	return animation;
}

//- (CAAnimation *)rotateAnimationFrom:(NSNumber*)startDegree to:(NSNumber*)endDegrees
//{
//	CABasicAnimation * animation;
//	animation = [CABasicAnimation 
//                 animationWithKeyPath:@"transform.rotation.z"];
//    
//    [animation setFromValue:NSValue DegreesToNumber(startDegree.floatValue)];// previousValue)];
//    [animation setToValue:DegreesToNumber(endDegrees.floatValue)];
//    
//    [animation setRemovedOnCompletion:NO];
//    [animation setFillMode:kCAFillModeForwards];
//    
//    previousValue = [slider floatValue];
//    
//	return animation;
//}


+ (CAKeyframeAnimation*)popInAnimation {
	CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
	
	animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
						[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)],
						[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
	
	animation.duration = 0.3f;
	return animation;
}

@end

@implementation NSView (CAAnimationEGOHelper)

- (void)popInAnimated {
	if ([self wantsLayer]) 
		[[self layer] popInAnimated];
}

@end

@implementation CALayer (CAAnimationEGOHelper)

- (void)popInAnimated {
	[self addAnimation:[CAAnimation popInAnimation] forKey:@"transform"];
}

@end

@implementation CAAnimation (MCAdditions)

+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGFloat)scaleFactor {
		// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CGFloat startValue = beginsOnTop ? 0.0f : M_PI;
    CGFloat endValue = beginsOnTop ? -M_PI : 0.0f;
    flipAnimation.fromValue = [NSNumber numberWithDouble:startValue];
    flipAnimation.toValue = [NSNumber numberWithDouble:endValue];

		// Shrinking the view makes it seem to move away from us, for a more natural effect
		// Can also grow the view to make it move out of the screen
    CABasicAnimation *shrinkAnimation = nil;
    if ( scaleFactor != 1.0f ) {
        shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];

			// We only have to animate the shrink in one direction, then use autoreverse to "grow"
        shrinkAnimation.duration = aDuration * 0.5;
        shrinkAnimation.autoreverses = YES;
    }

		// Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];

		// As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = aDuration;

		// Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;

    return animationGroup;
}
+(CAAnimation *)flipDown:(NSTimeInterval)aDuration scaleFactor:(CGFloat)scaleFactor {

		// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CGFloat startValue =  /*beginsOnTop ? 0.0f :*/ M_PI;
    CGFloat endValue =  /*beginsOnTop-M_PI :*/ 0.0f;
    flipAnimation.fromValue = [NSNumber numberWithDouble:startValue];
    flipAnimation.toValue = [NSNumber numberWithDouble:endValue];

		// Shrinking the view makes it seem to move away from us, for a more natural effect
		// Can also grow the view to make it move out of the screen
    CABasicAnimation *shrinkAnimation = nil;
    if ( scaleFactor != 1.0f ) {
        shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];

			// We only have to animate the shrink in one direction, then use autoreverse to "grow"
        shrinkAnimation.duration = aDuration * 0.5;
        shrinkAnimation.autoreverses = YES;
    }

		// Combine the flipping and shrinking into one smooth animation
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = [NSArray arrayWithObjects:flipAnimation, shrinkAnimation, nil];

		// As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = aDuration;

		// Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;

    return animationGroup;

}

@end



