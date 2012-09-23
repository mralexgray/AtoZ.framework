
//  CAAnimation+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 7/13/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.

#import <QuartzCore/QuartzCore.h>
#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

typedef void (^AZCAAnimationCompletionBlock)();

//Note this is slightly flawed as we set ourself as the delegate, really we should create a chained proxy, if we need that I will add it.
@interface CATransaction (AtoZ)
+ (void)CADisabledBlock:(void(^)(void))block;
@end

////typedef void (^disableCA) {
//- (NSArray *)setPropertiesWithCADisabled:(BOOL (^)(id obj))block		{
//		NSMutableArray * results = [[NSMutableArray alloc] init];
//		[self each:^(id obj, NSUInteger index, BOOL *stop) {
//			if (block(obj))		[results addObject:obj];
//		}];
//		return results;
//	}
//	[CATransaction flush];  [CATransaction begin];
//	[CATransaction setValue:@(YES) forKey:kCATransactionDisableActions];
//}

extern void disableCA();

@interface CAAnimation (AtoZ)

+ (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p;

+ (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p;

+ (CAAnimation*)animationOnPath:(CGPathRef)p duration:(CFTimeInterval)d timeOffset:(CFTimeInterval)o;
+ (CAAnimation*) animationForOpacity;
+ (CAAnimation*) animationForScale;
+ (CAAnimation*) animationForRotation;

+(CAAnimation *)flipDown:(NSTimeInterval)aDuration scaleFactor:(CGFloat)scaleFactor;

@property (nonatomic, copy) AZCAAnimationCompletionBlock az_completionBlock;

+ (CAAnimation*) shakeAnimation;

+ (CAAnimation*) colorAnimationForLayer:(CALayer*) theLayer withStartingColor:(NSColor*) color1 endColor:(NSColor*) color2;

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

//+ (CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration;

@end

@interface CAKeyframeAnimation (JumpingAndShaking)

+ (CAKeyframeAnimation *)shakeAnimation:(NSRect)frame;

+ (CAKeyframeAnimation *)jumpAnimation;

+ (CAKeyframeAnimation *)dockBounceAnimationWithIconHeight:(CGFloat)iconHeight;

@end



@interface CAAnimation (BlocksAddition)

@property (nonatomic, copy) void (^completion)(BOOL);
@property (nonatomic, copy) void (^start)();

@end