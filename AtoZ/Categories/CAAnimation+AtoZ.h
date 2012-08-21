//
//  CAAnimation+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/13/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@interface CAAnimation (AtoZ)

+ (CAAnimation*)shakeAnimation;

+ (CAAnimation*)colorAnimationForLayer:(CALayer *)theLayer withStartingColor:(NSColor*)color1 endColor:(NSColor*)color2;

+ (CAAnimation*)rotateAnimationForLayer:(CALayer *)theLayer start:(CGFloat)starting end:(CGFloat)ending;

+ (CAKeyframeAnimation*)popInAnimation;	
@end

@interface NSView (CAAnimationEGOHelper)
- (void)popInAnimated;
@end

@interface CALayer (CAAnimationEGOHelper)
- (void)popInAnimated;
@end

@interface CAAnimation (MCAdditions)

+ (CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration;

@end
