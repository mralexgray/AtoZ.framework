	//
	//  CAAnimation+AtoZ.m
	//  AtoZ
	//
	//  Created by Alex Gray on 7/13/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import "CAAnimation+AtoZ.h"
#import <AtoZFunctions.h>
#import "AtoZ.h"
#import "AtoZUmbrella.h"
#import <objc/runtime.h>


@interface CAAnimationDelegate : NSObject

@property (nonatomic, copy) void (^completion)(BOOL);
@property (nonatomic, copy) void (^start)(void);

- (void)animationDidStart:(CAAnimation *)anim;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end

@implementation CAAnimationDelegate

@synthesize completion=_completion;
@synthesize start=_start;

- (id)init
{
	if (!(self = [super init])) return nil;
	self.completion = nil;
	self.start = nil;
    return self;
}

- (void)dealloc
{
    self.completion = nil;
    self.start = nil;
//    [super dealloc];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    if (self.start != nil) self.start();
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.completion != nil)        self.completion(flag);
}

@end


@implementation CAAnimation (BlocksAddition)

- (void)setCompletion:(void (^)(BOOL))completion
{
    if ([self.delegate isKindOfClass:[CAAnimationDelegate class]])
        ((CAAnimationDelegate *)self.delegate).completion = completion;
    else {
        CAAnimationDelegate *delegate = [[CAAnimationDelegate alloc] init];
        delegate.completion = completion;
        self.delegate = delegate;
    }
}

- (void (^)(BOOL))completion
{
    return [self.delegate isKindOfClass:[CAAnimationDelegate class]]? ((CAAnimationDelegate *)self.delegate).completion: nil;
}

- (void)setStart:(void (^)(void))start
{
    if ([self.delegate isKindOfClass:[CAAnimationDelegate class]])
        ((CAAnimationDelegate *)self.delegate).start = start;

    else {
        CAAnimationDelegate *delegate = [[CAAnimationDelegate alloc] init];
        delegate.start = start;
        self.delegate = delegate;

    }
}

- (void (^)(void))start
{
    return [self.delegate isKindOfClass:[CAAnimationDelegate class]]? ((CAAnimationDelegate *)self.delegate).start: nil;
}

@end



@implementation CATransition (AtoZ)




+ (CATransition*) randomTransition
{
	static NSArray *AZTransitionTypes = nil;
	static NSArray *AZTransitionSubtypes = nil;
	AZTransitionTypes = AZTransitionTypes ?: @[ kCATransitionFade, kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal];
	AZTransitionSubtypes = AZTransitionSubtypes ?: @[kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom];
	CATransition *t = [CATransition animation];
	t.type  = [AZTransitionTypes randomElement];
	t.subtype = [AZTransitionSubtypes randomElement];
	return t;
}

+ (NSA*)transitionsFor:(id)targetView
{

	NSRect rect = [targetView bounds];
	CIImage *inputMaskImage, *inputShadingImage;
	inputMaskImage = inputShadingImage = [[NSImage az_imageNamed:@"linen"] toCIImage];
	//	CIImage  = [inputMaskImagetoCIImage];
	return  @[ kCATransitionFade, kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal,
	^{ 		CIFilter *transitionFilter = CIFilterDefaultNamed(@"CICopyMachineTransition");
		transitionFilter.name = @"CICopyMachineTransition";
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x
													   Y:rect.origin.y
													   Z:rect.size.width
													   W:rect.size.height] forKey:@"inputExtent"];
		return transitionFilter;
	}(), ^{	// Scale our mask image to match the transition area size, and set the scaled result as the "inputMaskImage" to the transitionFilter.
		CIFilter *transitionFilter = CIFilterDefaultNamed(@"CIDisintegrateWithMaskTransition");
		CIFilter *maskScalingFilter = CIFilterDefaultNamed(@"CILanczosScaleTransform");
		transitionFilter.name = @"CIDisintegrateWithMaskTransition";
		CGRect maskExtent = [[[targetView snapshot]toCIImage] extent];// rect;//[inputMaskImage extent];
		float xScale = rect.size.width  / maskExtent.size.width;
		float yScale = rect.size.height / maskExtent.size.height;
		[maskScalingFilter setValue:@(yScale) forKey:@"inputScale"];
		[maskScalingFilter setValue:@(xScale / yScale) forKey:@"inputAspectRatio"];
		[maskScalingFilter setValue:inputMaskImage forKey:@"inputImage"];
		[transitionFilter setValue:[maskScalingFilter valueForKey:@"outputImage"] forKey:@"inputMaskImage"];
		return transitionFilter;
	}(), ^{
		return CIFilterDefaultNamed(@"CIDissolveTransition");
	}(),^{
		CIFilter* transitionFilter = CIFilterDefaultNamed(@"CIFlashTransition");
		[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
		transitionFilter.name = @"CIFlashTransition";
		return transitionFilter;
	}(),^{
		CIFilter* transitionFilter = CIFilterDefaultNamed(@"CIModTransition");
		[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
		transitionFilter.name = @"CIModTransition";
		return transitionFilter;
	}(),^{

		CIFilter*transitionFilter = CIFilterDefaultNamed(@"CIPageCurlTransition");
		[transitionFilter setValue:[NSNumber numberWithFloat:-M_PI_4] forKey:@"inputAngle"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputBacksideImage"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
		return transitionFilter;
	}(),^{	return CIFilterDefaultNamed(@"CISwipeTransition");
	}(),^{
		CIFilter*transitionFilter = CIFilterDefaultNamed(@"CIRippleTransition");
		[transitionFilter setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] forKey:@"inputCenter"];
		[transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
		[transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
		return transitionFilter;
	}()];
	
}

@end


NSString *AZCAAnimationCompletionBlockAssociatedObjectKey = @"AZCAAnimationCompletionBlockAssociatedObjectKey";

//void disableCA(){
//
//	[CATransaction flush];
//	[CATransaction begin];
//	[CATransaction setValue:(id)kCFBooleanTrue
//					 forKey:kCATransactionDisableActions];
//}


@implementation CATransaction (AtoZ)
+ (void)az_performWithDisabledActions:(void(^)(void))block
{
	if    ([self disableActions])	     block();
	else { [self setDisableActions:YES]; block(); [self setDisableActions:NO]; }
}

@end

@implementation CAAnimation (AtoZ)

+ (CABA*) animationWithKeyPath: (NSS*)path andDuration:(NSTI)interval;
{
//	id<CAAction>
	CABA* a = [CABasicAnimation animationWithKeyPath:path];
	((CABasicAnimation*)a).duration = interval;
	return a;
}

+ (CABA*) propertyAnimation:(NSD*)dict
{
	CABA* newA = [dict hasKey:@"keyPath"] ? [CABA animationWithKeyPath:dict[@"keyPath"]] : [CABA animation];
	[dict hasKey:@"keyPath"] ?  [newA setWithDictionary:[dict dictionaryWithoutKey:@"keyPath"]] : [newA setWithDictionary:dict];
	return newA;
}


+ (CAAnimation*)colorAnimationForLayer:(CALayer *)theLayer WithStartingColor:(NSColor *)color1 endColor:(NSColor *)color2
{
	CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
	NSDictionary *dic = @{	 	@"fromValue":(id)[color1 CGColor],
									@"toValue":(id)[color2 CGColor],
								@"duration":@2,
								@"removedOnCompletion":@(YES),
									@"fillMode": kCAFillModeForwards};
	[animation setValuesForKeysWithDictionary:dic];
	[theLayer addAnimation:animation forKey:@"color"];    
	return animation;
}

//+ (CAAnimation*)rotateAnimationForLayer:(CALayer *)theLayer start:(CGFloat)starting end:(CGFloat)ending {
//	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
////    [animation setFromValue:DegreesToNumber(<#CGFloat degrees#>)(previousValue)];
//    [animation setToValue:DegreesToNumber([slider floatValue])];
//    
//    [animation setRemovedOnCompletion:NO];
//    [animation setFillMode:kCAFillModeForwards];
//    
//    previousValue = [slider floatValue];
//    
//	return animation;
//}
//
//}


- (CAAnimation *)rotateAnimationTo:(CGF)endDegrees
{
	CABasicAnimation * animation;
	animation = [CABasicAnimation 
                 animationWithKeyPath:@"transform.rotation.z"];
    
//    [animation setFromValue:DegreesToNumber(startDegree)];// previousValue)];
    [animation setToValue:DegreesToNumber(endDegrees)];
    
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
//    previousValue = [slider floatValue];

	return animation;
}


// ---------------------------------------------------------------------------
// -randomPathAnimation
// ---------------------------------------------------------------------------
// create a CAAnimation object with result of -newRandomPath as the movement pat

+ (CAAnimation*)randomPathAnimationInFrame:(NSRect) frame;
{
    return [self randomPathAnimationWithStartingPoint:AZRandomPointInRect(frame) inFrame:frame];
}


// ---------------------------------------------------------------------------
// -randomPathAnimationWithStartingPoint:
// ---------------------------------------------------------------------------
// create a CAAnimation object with result of -newRandomPath as the movement path

+ (CAAnimation*)randomPathAnimationWithStartingPoint:(CGPoint)firstPoint inFrame:(NSR)rect
{
//    CGPathRef path = AZRandomPathWithStartingPointInRect(firstPoint, rect);//:firstPoint];

    
    CAKA* animation 			= [CAKA animationWithKeyPath:@"position"];
    animation.path              = AZRandomPathWithStartingPointInRect(firstPoint, rect);;
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.duration          = RAND_FLOAT_VAL(15,32);
    animation.autoreverses      = YES;
    animation.repeatCount       = HUGE_VALF;
    return animation;
}



#pragma mark -
#pragma mark Sphere Layer Generation





+ (CAKeyframeAnimation *)rotateAnimation{

	CAKeyframeAnimation *rotateAnimation= [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.values = @[@(0.0), @(M_PI * 2), @(0.0)];
	rotateAnimation.duration = 0.5f;
	rotateAnimation.keyTimes = @[@(0), @(.4), @(.5)];
	return  rotateAnimation;
//	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//	positionAnimation.duration = 0.5f;
//	CGMutablePathRef path = CGPathCreateMutable();
//	CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
//	CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
//	CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
//	positionAnimation.path = path;
//	CGPathRelease(path);
}
//	CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
//	animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
//	animationgroup.duration = 0.5f;
//	animationgroup.fillMode = kCAFillModeForwards;
//	animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//	[item.layer addAnimation:animationgroup forKey:@"Close"];
//	item.layer.position = item.startPoint;
//	_flag --;
//	}

+ (CAAnimationGroup *)blowupAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = @[AZVpoint(p)];
    positionAnimation.keyTimes = @[@.3f];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = @0.0f;

    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = @[positionAnimation, scaleAnimation, opacityAnimation];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;

    return animationgroup;
}

+ (CAAnimationGroup *)shrinkAnimationAtPoint:(CGPoint)p
{
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = @[AZVpoint(p)];
    positionAnimation.keyTimes = @[@.3f];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];

    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.toValue  = @0.0f;

    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = @[positionAnimation, scaleAnimation, opacityAnimation];
    animationgroup.duration = 0.3f;
    animationgroup.fillMode = kCAFillModeForwards;

    return animationgroup;
}


+ (CAAnimation*)animationOnPath:(CGPathRef)p duration:(CFTimeInterval)d timeOffset:(CFTimeInterval)o;
{//- (CAAnimation*)animationForCurrentPath:(CFTimeInterval)timeOffset {
	CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
	animation.path = p;
	animation.duration = d;
	animation.timeOffset = o;
    animation.repeatCount = 1;
	animation.removedOnCompletion = NO;
	return animation;
}

+ (CAAnimation *) animationForOpacity {
	CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	[fadeAnimation setAutoreverses:YES];
	[fadeAnimation setToValue:@0.0f];

	return fadeAnimation;
}

+ (CAAnimation *) animateionForScale {
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	[scaleAnimation setAutoreverses:YES];
	[scaleAnimation setToValue:@0.0f];

	return scaleAnimation;
}

+ (CAAnimation *) animationForRotation {
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
	[rotateAnimation setToValue:AZV3d( CATransform3DMakeRotation(M_PI, 0, 1, 0) )];
	[rotateAnimation setRepeatCount:HUGE_VALF];
	[rotateAnimation setDuration:2];
	return rotateAnimation;
}
- (void)setAz_completionBlock:(AZCAAnimationCompletionBlock)block
{
	self.delegate = self;
	objc_setAssociatedObject(self, &AZCAAnimationCompletionBlockAssociatedObjectKey, block, OBJC_ASSOCIATION_COPY);
}

- (AZCAAnimationCompletionBlock)az_completionBlock
{
	return objc_getAssociatedObject(self, &AZCAAnimationCompletionBlockAssociatedObjectKey);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if (flag && self.az_completionBlock != nil)
		self.az_completionBlock();
}
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

+(CAAnimation *)flipAnimationWithDuration:(NSTimeInterval)aDuration forLayerBeginningOnTop:(BOOL)beginsOnTop scaleFactor:(CGFloat)scaleFactor {
		// Rotating halfway (pi radians) around the Y axis gives the appearance of flipping
    CABasicAnimation *flipAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    CGFloat startValue = beginsOnTop ? 0.0f : M_PI;
    CGFloat endValue = beginsOnTop ? -M_PI : 0.0f;
    flipAnimation.fromValue = @(startValue);
    flipAnimation.toValue = @(endValue);

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
    animationGroup.animations = @[flipAnimation, shrinkAnimation];

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
    flipAnimation.fromValue = @(startValue);
    flipAnimation.toValue = @(endValue);

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
    animationGroup.animations = @[flipAnimation, shrinkAnimation];

		// As the edge gets closer to us, it appears to move faster. Simulate this in 2D with an easing function
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animationGroup.duration = aDuration;

		// Hold the view in the state reached by the animation until we can fix it, or else we get an annoying flicker
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;

    return animationGroup;
	
}


	//@implementation CAKeyframeAnimation (JumpingAndShaking)

+ (CAKeyframeAnimation *)shakeAnimation:(NSRect)frame	{
	static int 	numberOfShakes = 3;
	static float durationOfShake = .4;
	static float vigourOfShake = 0.2f;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	for (int index = 0; index < numberOfShakes; ++index)		{
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
	}
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;
    return shakeAnimation;
}
+ (CAKeyframeAnimation *)jumpAnimation
{
		// these three values are subject to experimentation
	CGFloat initialMomentum = 300.0f; // positive is upwards, per sec
	CGFloat gravityConstant = 250.0f; // downwards pull per sec
	CGFloat dampeningFactorPerBounce = 0.6;  // percent of rebound

		// internal values for the calculation
	CGFloat momentum = initialMomentum; // momentum starts with initial value
	CGFloat positionOffset = 0; // we begin at the original position
	CGFloat slicesPerSecond = 60.0f; // how many values per second to calculate
	CGFloat lowerMomentumCutoff = 5.0f; // below this upward momentum animation ends

	CGFloat duration = 0;
	NSMutableArray *values = [NSMutableArray array];

	do
		{
		duration += 1.0f/slicesPerSecond;
		positionOffset+=momentum/slicesPerSecond;

		if (positionOffset<0)
			{
			positionOffset=0;
			momentum=-momentum*dampeningFactorPerBounce;
			}

			// gravity pulls the momentum down
		momentum -= gravityConstant/slicesPerSecond;

		CATransform3D transform = CATransform3DMakeTranslation(0, -positionOffset, 0);
		[values addObject:[NSValue valueWithCATransform3D:transform]];
		} while (!(positionOffset==0 && momentum < lowerMomentumCutoff));

	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.repeatCount = 1;
	animation.duration = duration;
	animation.fillMode = kCAFillModeForwards;
	animation.values = values;
	animation.removedOnCompletion = YES; // final stage is equal to starting stage
	animation.autoreverses = NO;

	return animation;
}

+ (CAKeyframeAnimation *)dockBounceAnimationWithIconHeight:(CGFloat)iconHeight
{
	CGFloat factors[32] = {0, 32, 60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 32,
		0, 24, 42, 54, 62, 64, 62, 54, 42, 24, 0, 18, 28, 32, 28, 18, 0};

	NSMutableArray *values = [NSMutableArray array];

	for (int i=0; i<32; i++)
		{
		CGFloat positionOffset = factors[i]/128.0f * iconHeight;

		CATransform3D transform = CATransform3DMakeTranslation(0, -positionOffset, 0);
		[values addObject:[NSValue valueWithCATransform3D:transform]];
		}

	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	animation.repeatCount = 1;
	animation.duration = 32.0f/30.0f;
	animation.fillMode = kCAFillModeForwards;
	animation.values = values;
	animation.removedOnCompletion = YES; // final stage is equal to starting stage
	animation.autoreverses = NO;
	
	return animation;
}

- (CAKeyframeAnimation *)negativeShake:(NSRect)frame{
	int numberOfShakes = 4;
	float durationOfShake = 0.5f;
	float vigourOfShake = 0.05f;

	CAKeyframeAnimation *shakeAnim = [CAKeyframeAnimation animation];

	CGMutablePathRef shakePath = CGPathCreateMutable();
	CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	int index;
	for (index = 0; index < numberOfShakes; ++index)
		{
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
		CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
		}
	CGPathCloseSubpath(shakePath);
	shakeAnim.path = shakePath;
	shakeAnim.duration = durationOfShake;
	return shakeAnim;
}

- (IBAction)shakeBabyShake:(id)sender;
{
	NSString *key = @"frameOrigin";
	if ([NSWindow defaultAnimationForKey:key] == nil){
		NSLog(@"NSVindow not animatable for key '%@'",key);
	}else {
		[[NSApp keyWindow] setAnimations:@{key: [self negativeShake:[[NSApp keyWindow] frame]]}];
		[[[NSApp keyWindow] animator] setFrameOrigin:[[NSApp keyWindow] frame].origin];
	}
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

//@implementation CAAnimation (MCAdditions)

	//	//assuming view is your NSView
	//CGPoint newCenter = CGPointMake(view.center.x - 300, view.center.y);
	//CABasicAnimation *animation = [CABasicAnimation animation];
	//	//setup your animation eg. duration/other options
	//animation.fromValue = [NSValue valueWithCGPoint:v.center];
	//animation.toValue = [NSValue valueWithCGPoint:newCenter];
	//[view.layer addAnimation:animation forKey:@"key"];
	//
	//- (CAKeyframeAnimation *)slideOut:(NSRect)frame oriented: (AZOrient)orientation{
	//
	//    CAKeyframeAnimation *slideout = [CAKeyframeAnimation animation];
	//
	//    CGMutablePathRef slidePath = CGPathCreateMutable();
	//	CGFloat xFin, yFin;  CGPoint go;
	//
	//	switch (orientation) {
	//		case AZOrientLeft:
	//		case AZOrientRight:
	//			xFin = 	orientation == AZOrientLeft ?  - NSMaxX(frame)	:   NSMaxX(frame) ;
	//			yFin =  0;
	//			go   =  orientation == AZOrientLeft ? (CGPoint){ NSMidY(frame), -
	//				break;
	//
	//			default:
	//				break;
	//			}
	//			xFin =  orientation == AZOrientBottom  	?  0
	//			:	orientation == AZOrientTop 		?  0
	//			yFin = 	orientation == AZOrientLeft || orientation == AZOrientRight ?  0
	//			:	orientation == AZOrientTop 		?   NSMaxY(frame) : -NSMaxY(frame);
	//			go 	 =  orientation == AZOrientBottom 	:
	//
	//
	//			CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
	//			int index;
	//			for (index = 0; index < numberOfShakes; ++index)
	//			{
	//				CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
	//				CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
	//			}
	//			CGPathCloseSubpath(shakePath);
	//			shakeAnim.path = shakePath;
	//			shakeAnim.duration = durationOfShake;
	//			return shakeAnim;
	//	}
	//

	//- (void)animateView:(NSView*)sender {
	//		// Get the relevant frames.
	//	NSView *enclosingView = [[[NSApplication sharedApplication] mainWindow] contentView];
	////	int rowIndex = [sender selectedRow];
	//	NSRect cellFrame = [sender frame];//OfCellAtColumn:0 row:rowIndex];
	////	NSRect buttonFrame = [button frame];
	////	NSRect mainViewFrame = [enclosingView frame];
	//
	//	/*	      * Yellow fade animation/9**/
	//
	//		// Create the yellow fade layer.
	//	CALayer *layer = [CALayer layer];
	//	[layer setDelegate:self];
	//	yellowFadeView = [[NSView alloc] init];
	//	[yellowFadeView setWantsLayer:YES];
	//	[yellowFadeView setFrame:cellFrame];
	//	[yellowFadeView setLayer:layer];
	//	[[yellowFadeView layer] setNeedsDisplay];
	//	[yellowFadeView setAlphaValue:0.0];
	//	[sourceList addSubview:yellowFadeView];
	//
	//		// Create the animation pieces.
	//	CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath: @"alphaValue"];
	//	alphaAnimation.beginTime = 1.0;
	//	alphaAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
	//	alphaAnimation.toValue = [NSNumber numberWithFloat: 1.0];
	//	alphaAnimation.duration = 0.25;
	//	CABasicAnimation *alphaAnimation2 = [CABasicAnimation animationWithKeyPath: @"alphaValue"];
	//	alphaAnimation2.beginTime = 1.25;
	//	alphaAnimation2.duration = 0.25;
	//	alphaAnimation2.fromValue = [NSNumber numberWithFloat: 1.0];
	//	alphaAnimation2.toValue = [NSNumber numberWithFloat: 0.0];
	//	CABasicAnimation *alphaAnimation3 = [CABasicAnimation animationWithKeyPath: @"alphaValue"];
	//	alphaAnimation3.beginTime = 1.5;
	//	alphaAnimation3.duration = 0.25;
	//	alphaAnimation3.fromValue = [NSNumber numberWithFloat: 0.0];
	//	alphaAnimation3.toValue = [NSNumber numberWithFloat: 1.0];
	//	CABasicAnimation *alphaAnimation4 = [CABasicAnimation animationWithKeyPath: @"alphaValue"];
	//	alphaAnimation4.beginTime = 1.75;
	//	alphaAnimation4.duration = 0.25;
	//	alphaAnimation4.fromValue = [NSNumber numberWithFloat: 1.0];
	//	alphaAnimation4.toValue = [NSNumber numberWithFloat: 0.0];
	//
	//		// Create the animation group.
	//	CAAnimationGroup *yellowFadeAnimation = [CAAnimationGroup animation];
	//	yellowFadeAnimation.delegate = self;
	//	yellowFadeAnimation.animations =@[ alphaAnimation, alphaAnimation2, alphaAnimation3, alphaAnimation4 ];
	//	yellowFadeAnimation.duration = 2.0;
	//	[yellowFadeView setAnimations:@{ @"frameOrigin":yellowFadeAnimation} ];
	//
	//		// Start the yellow fade animation.
	//	[[yellowFadeView animator] setFrame:[yellowFadeView frame]];
	//}
	//
	//- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
	//		// Bezier path radius
	//	int radius = 4;
	//
	//		// Setup graphics context.
	//	NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO];
	//	[NSGraphicsContext saveGraphicsState];
	//	[NSGraphicsContext setCurrentContext:nsGraphicsContext];
	//
	//		// Convert to NSRect.
	//	CGRect aRect = [layer frame];
	//	NSRect rect = NSMakeRect(aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
	//
	//		// Draw dark outside line.
	//	[NSBezierPath setDefaultLineWidth:2];
	//	NSBezierPath *highlightPath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
	//	[[NSColor yellowColor] set];
	//	[highlightPath stroke];
	//
	//		// Draw transparent inside fill.
	//	CGFloat r, g, b, a;
	//	[[NSColor yellowColor] getRed:&amp;r green:&amp;g blue:&amp;b alpha:&amp;a];
	//	NSColor *transparentYellow = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:0.5];
	//	NSBezierPath *fillPath = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:radius yRadius:radius];
	//	[transparentYellow set];
	//	[fillPath fill];
	//
	//		// Finish with graphics context.
	//	[NSGraphicsContext restoreGraphicsState];
	//}
	//

	//	@end

/*
@interface CAAnimationDelegate : NSObject {
	void (^_completion)(BOOL);
	void (^_start)();
}

@property (NATOM, CP) void (^completion)(BOOL);
@property (NATOM, CP) void (^start)();

- (void)animationDidStart:(CAAnimation *)anim;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

@end
@implementation CAAnimationDelegate

@synthesize completion=_completion;
@synthesize start=_start;

- (id)init
{
	self = [super init];
	if (self) {
		self.completion = nil;
		self.start = nil;
	}
	return self;
}

- (void)dealloc
{
	self.completion = nil;
	self.start = nil;
		//    [super dealloc];
}

- (void)animationDidStart:(CAAnimation *)anim
{
	if (self.start != nil) {
		self.start();
	}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if (self.completion != nil) {
		self.completion(flag);
	}
}

	//@end

@end

@implementation CAAnimation (BlocksAddition)

-  (BOOL)delegateCheck
{
	if (self.delegate != nil && ![self.delegate isKindOfClass:[CAAnimationDelegate class]]) {
		NSLog(@"CAAnimation(BlocksAddition) Warning: CAAnimation instance's delegate was modified externally");
		return NO;
	}
	return YES;
}

- (void)setCompletion:(void (^)(BOOL))completion
{
	CAAnimationDelegate *newDelegate = [[CAAnimationDelegate alloc] init];
	newDelegate.completion = completion;
	newDelegate.start = ((CAAnimationDelegate *)self.delegate).start;
	self.delegate = newDelegate;
	[newDelegate release];
}

- (void (^)(BOOL))completion
{
	if (![self delegateCheck]) {
		return nil;
	}
	return ((CAAnimationDelegate *)self.delegate).completion;
}

- (void)setStart:(void (^)())start
{
	CAAnimationDelegate *newDelegate = [[CAAnimationDelegate alloc] init];
	newDelegate.start = start;
	newDelegate.completion = ((CAAnimationDelegate *)self.delegate).completion;
	self.delegate = newDelegate;
	[newDelegate release];
}

- (void (^)())start
{
	if (![self delegateCheck]) {
		return nil;
	}
	return ((CAAnimationDelegate *)self.delegate).start;
}

@end
*/
/*   example of blocks category below

 - (void)runAnimation:(id)unused
 {
 // Create a shaking animation that rotates a bit counter clockwisely and then rotates another
 // bit clockwisely and repeats. Basically, add a new rotation animation in the opposite
 // direction at the completion of each rotation animation.
 const CGFloat duration = 0.1f;
 const CGFloat angle = 0.03f;
 NSNumber *angleR = [NSNumber numberWithFloat:angle];
 NSNumber *angleL = [NSNumber numberWithFloat:-angle];

 CABasicAnimation *animationL = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
 CABasicAnimation *animationR = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];

 void (^completionR)(BOOL) = ^(BOOL finished) {
 [self.imageView.layer setValue:angleL forKey:@"transform.rotation.z"];
 [self.imageView.layer addAnimation:animationL forKey:@"L"]; // Add rotation animation in the opposite direction.
 };

 void (^completionL)(BOOL) = ^(BOOL finished) {
 [self.imageView.layer setValue:angleR forKey:@"transform.rotation.z"];
 [self.imageView.layer addAnimation:animationR forKey:@"R"];
 };

 animationL.fromValue = angleR;
 animationL.toValue = angleL;
 animationL.duration = duration;
 animationL.completion = completionL; // Set completion to perform rotation in opposite direction upon completion.

 animationR.fromValue = angleL;
 animationR.toValue = angleR;
 animationR.duration = duration;
 animationR.completion = completionR;

 // First animation performs half rotation and then proceeds to enter the loop by playing animationL in its completion block
 CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
 animation.fromValue = [NSNumber numberWithFloat:0.f];
 animation.toValue = angleR;
 animation.duration = duration/2;
 animation.completion = completionR;

 [self.imageView.layer setValue:angleR forKey:@"transform.rotation.z"];
 [self.imageView.layer addAnimation:animation forKey:@"0"];
 }
 
 */



/* alternative style  

  // Setup another animation just to show a different coding style
    CABasicAnimation *anotherAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    anotherAnimation.fromValue = @(self.anotherImageView.layer.position.x);
    anotherAnimation.toValue = @600.0f;
    anotherAnimation.duration = 2;
    [anotherAnimation setCompletion:^(BOOL finished) {
        CABasicAnimation *oneMoreAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        oneMoreAnimation.fromValue = @600.0f;
        oneMoreAnimation.toValue = @160.0f;
        oneMoreAnimation.duration = 1;
        [self.anotherImageView.layer addAnimation:oneMoreAnimation forKey:@"1"];
    }];
    [self.anotherImageView.layer addAnimation:anotherAnimation forKey:@"1"];
	
	*/