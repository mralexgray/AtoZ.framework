
#import <AtoZ/AtoZ.h>
#import "CAAnimation+AtoZ.h"

@implementation CAAnimationGroup (oneLine)
+ (CAAG *)groupWithAnimations:(NSA *)anis
                     duration:(NSTI)ti
                       andSet:(CAL *)toSet {

  CAAnimationGroup *group = self.new;
  for (CAA *a in anis) {
    a.duration = ti;

    if (!toSet || ![a vFK:@"toValue"])
      return nil;
    a.start = ^(CAAnimationDelegate *d) {
      [d.layer.modelCALayer sV:((CABA *)d.ani).toValue
                            fK:((CAPropertyAnimation *)d.ani).keyPath];
    };
  }
  group.animations = anis;
  return group;
}
@end

//- (void) dealloc	{	self.completion = nil;	self.start = nil;	}
@implementation CATransaction (AtoZ)

+ (void)flushBlock:(Blk)block {
  [self begin];
  block();
  [self flush];
  [self commit];
}

+ (void)transactionWithLength:(NSTI)l
                      actions:(Blk)block
                   completion:(Blk)comp {

  [self begin];
  [self setAnimationDuration:l];
  [self setAnimationTimingFunction:CAMEDIAEASY];
  [self setCompletionBlock:comp];
  block();
  [self commit];
}

@end
/*
- _Void_ bounceView:(UIView *)view amplitude:(CGFloat)amplitude
duration:(CGFloat)duration {
    CGFloat m34 = 1 / 300.f * (view.layer.anchorPoint.x == 0 ? -1 : 1);
    CGFloat bounceAngleModifiers[] = {1, 0.33f, 0.13f};
    NSInteger bouncesCount = sizeof(bounceAngleModifiers) / sizeof(CGFloat);
    bouncesCount = bouncesCount * 2 + 1;

    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = m34;
    view.layer.transform = transform;

    CAKeyframeAnimation *bounceKeyframe = [CAKeyframeAnimation
animationWithKeyPath:@"transform.rotation.y"];
    bounceKeyframe.timingFunction = [CAMediaTimingFunction
functionWithName:kCAMediaTimingFunctionLinear];
    bounceKeyframe.duration = duration;

    NSMutableArray *bounceValues = [NSMutableArray array];
    for (NSInteger i = 0; i < bouncesCount; i++) {
        CGFloat angle = 0;
        if (i % 2 > 0) {
            angle = bounceAngleModifiers[i / 2] * amplitude;
        }
        [bounceValues addObject:@(DEGREES(angle))];
    }
    bounceKeyframe.values = bounceValues;

    view.parentShadowLayer.path = [self parentShadowPathForView:view
withModifier:0];
    [view.layer setValue:@(0) forKeyPath:bounceKeyframe.keyPath];
    [view.layer addAnimation:bounceKeyframe forKey:nil];

    CAKeyframeAnimation *shadowKeyframe = [bounceKeyframe copy];
    shadowKeyframe.keyPath = @"opacity";

    if (self.rippleHasShading) {
        [view.shadingLayer addAnimation:shadowKeyframe forKey:nil];
    }

    if (self.rippleHasParentShading) {
        [view.parentShadowLayer addAnimation:shadowKeyframe forKey:nil];

        CAKeyframeAnimation *shadowPathKeyframe = [bounceKeyframe copy];
        shadowPathKeyframe.keyPath = @"path";

        NSMutableArray *pathValues = [NSMutableArray array];
        CGPathRef initialPath = view.parentShadowLayer.path;
        for (NSInteger i = 0; i < bouncesCount; i++) {
            CGPathRef path = initialPath;
            if (i % 2 > 0) {
                CGFloat modifier = bounceAngleModifiers[i / 2];
                path = [self parentShadowPathForView:view
withModifier:modifier];
            }
            [pathValues addObject:(__bridge id)path];
        }
        shadowPathKeyframe.values = pathValues;
        [view.parentShadowLayer addAnimation:shadowPathKeyframe forKey:nil];
    }
}

#pragma mark - Table animation

- _Void_ rippleAtOrigin:(NSInteger)originIndex {
    [self rippleAtOrigin:originIndex amplitude:self.rippleAmplitude];
}

- _Void_ rippleAtOrigin:(NSInteger)originIndex amplitude:(CGFloat)amplitude {
    [self rippleAtOrigin:originIndex amplitude:amplitude
duration:self.rippleDuration];
}

- _Void_ rippleAtOrigin:(NSInteger)originIndex amplitude:(CGFloat)amplitude
duration:(CGFloat)duration {
    UIView *originView = [self viewForIndex:originIndex];

    [self bounceView:originView amplitude:amplitude];

    CGFloat delay = self.rippleDelay;
    NSMutableArray *viewGroups = [NSMutableArray array];
    NSArray *visibleViews = [self visibleViews];

    for (NSInteger i = 1; i <= self.rippleOffset; i++) {
        NSMutableArray *viewGroup = [NSMutableArray array];
        if (originIndex - i > -1) {
            UIView *view = [self viewForIndex:originIndex - i];
            if (view && [visibleViews containsObject:view]) {
                [viewGroup addObject:view];
            }
        }
        if (originIndex + i < [self.dataSource numberOfItemsInTableView:self]) {
            UIView *view = [self viewForIndex:originIndex + i];
            if (view && [visibleViews containsObject:view]) {
                [viewGroup addObject:view];
            }
        }
        if ([viewGroup count] > 0) {
            [viewGroups addObject:viewGroup];
        }
    }

    [viewGroups enumerateObjectsUsingBlock:^(NSArray *viewGroup, NSUInteger idx,
BOOL *stop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * (idx + 1) *
NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            CGFloat modifier = 1 / (1.f * idx + 1);
            modifier = powf(modifier, idx);
            CGFloat subAmplitude = amplitude * modifier;
            for (UIView *view in viewGroup) {
                [self bounceView:view amplitude:subAmplitude];
            }
        });
    }];
}
@end

*/

@implementation CATransition (AtoZ)
+ (INST)transitionOfType:(NSS *)type {
  CATransition *animation;
  [animation = self.new setType:type];
  return animation;
}

+ (CATransition *)randomTransition {
  static NSArray *AZTransitionTypes = nil;
  static NSArray *AZTransitionSubtypes = nil;
  AZTransitionTypes = AZTransitionTypes ?: @[
                                             kCATransitionFade,
                                             kCATransitionMoveIn,
                                             kCATransitionPush,
                                             kCATransitionReveal
                                           ];
  AZTransitionSubtypes = AZTransitionSubtypes ?: @[
                                                   kCATransitionFromRight,
                                                   kCATransitionFromLeft,
                                                   kCATransitionFromTop,
                                                   kCATransitionFromBottom
                                                 ];
  CATransition *t = [CATransition animation];
  t.type = [AZTransitionTypes randomElement];
  t.subtype = [AZTransitionSubtypes randomElement];
  return t;
}
+ (NSA *)transitionsFor: targetView {

  NSRect rect = [targetView bounds];
  CIImage *inputMaskImage, *inputShadingImage;
  inputMaskImage = inputShadingImage =
      [[NSImage az_imageNamed:@"linen"] toCIImage];
  //	CIImage  = [inputMaskImagetoCIImage];
  return @[
    kCATransitionFade,
    kCATransitionMoveIn,
    kCATransitionPush,
    kCATransitionReveal,
    ^{
        CIFilter *transitionFilter =
            CIFilterDefaultNamed(@"CICopyMachineTransition");
        transitionFilter.name = @"CICopyMachineTransition";
        [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x
                                                       Y:rect.origin.y
                                                       Z:rect.size.width
                                                       W:rect.size.height]
                            forKey:@"inputExtent"];
        return transitionFilter;
    }(),
    ^{ // Scale our mask image to match the transition area size, and set the
       // scaled result as the "inputMaskImage" to the transitionFilter.
        CIFilter *transitionFilter =
            CIFilterDefaultNamed(@"CIDisintegrateWithMaskTransition");
        CIFilter *maskScalingFilter =
            CIFilterDefaultNamed(@"CILanczosScaleTransform");
        transitionFilter.name = @"CIDisintegrateWithMaskTransition";
        CGRect maskExtent = [[[targetView
                snapshot] toCIImage] extent]; // rect;//[inputMaskImage extent];
        float xScale = rect.size.width / maskExtent.size.width;
        float yScale = rect.size.height / maskExtent.size.height;
        [maskScalingFilter setValue:@(yScale) forKey:@"inputScale"];
        [maskScalingFilter setValue:@(xScale / yScale)
                             forKey:@"inputAspectRatio"];
        [maskScalingFilter setValue:inputMaskImage forKey:@"inputImage"];
        [transitionFilter
            setValue:[maskScalingFilter valueForKey:@"outputImage"]
              forKey:@"inputMaskImage"];
        return transitionFilter;
    }(),
    ^{ return CIFilterDefaultNamed(@"CIDissolveTransition"); }(),
    ^{
        CIFilter *transitionFilter = CIFilterDefaultNamed(@"CIFlashTransition");
        [transitionFilter
            setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)]
              forKey:@"inputCenter"];
        [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x
                                                       Y:rect.origin.y
                                                       Z:rect.size.width
                                                       W:rect.size.height]
                            forKey:@"inputExtent"];
        transitionFilter.name = @"CIFlashTransition";
        return transitionFilter;
    }(),
    ^{
        CIFilter *transitionFilter = CIFilterDefaultNamed(@"CIModTransition");
        [transitionFilter
            setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)]
              forKey:@"inputCenter"];
        transitionFilter.name = @"CIModTransition";
        return transitionFilter;
    }(),
    ^{

        CIFilter *transitionFilter =
            CIFilterDefaultNamed(@"CIPageCurlTransition");
        [transitionFilter setValue:[NSNumber numberWithFloat:-M_PI_4]
                            forKey:@"inputAngle"];
        [transitionFilter setValue:inputShadingImage
                            forKey:@"inputShadingImage"];
        [transitionFilter setValue:inputShadingImage
                            forKey:@"inputBacksideImage"];
        [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x
                                                       Y:rect.origin.y
                                                       Z:rect.size.width
                                                       W:rect.size.height]
                            forKey:@"inputExtent"];
        return transitionFilter;
    }(),
    ^{ return CIFilterDefaultNamed(@"CISwipeTransition"); }(),
    ^{
        CIFilter *transitionFilter =
            CIFilterDefaultNamed(@"CIRippleTransition");
        [transitionFilter
            setValue:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)]
              forKey:@"inputCenter"];
        [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x
                                                       Y:rect.origin.y
                                                       Z:rect.size.width
                                                       W:rect.size.height]
                            forKey:@"inputExtent"];
        [transitionFilter setValue:inputShadingImage
                            forKey:@"inputShadingImage"];
        return transitionFilter;
    }()
  ];
}
@end

NSString *AZCAAnimationCompletionBlockAssociatedObjectKey =
    @"AZCAAnimationCompletionBlockAssociatedObjectKey";

// void disableCA(){
//	[CATransaction flush];	[CATransaction begin];	[CATransaction
//setValue: kCFBooleanTrue forKey:kCATransactionDisableActions];
//}
//@implementation CATransaction (AtoZ)   SEE CAANIMATION + ATOZ
//+ (void) immediatelyWithCompletion:(void (^)())completion transaction:(void
//(^)())block;
//+ (void)az_performWithDisabledActions:(void(^)(void))block
//{
//	if	([self disableActions])   		   block();
//	else { [self setDisableActions:YES]; block(); [self setDisableActions:NO]; }
//}

@implementation CABA (AtoZ)

+ (CABA *)animationWithKeyPath:(NSS *)path
                          from: v1
                            to: v2
                      duration:(NSTI)time
                        repeat:(CGF)ct {
  CABA *new = [self animationWithKeyPath : path];

  return ({
    new.fromValue = v1;
    new.toValue = v2;
    new.duration = time;
    new.repeatCount = ct;
    new;
  });
}

+ (CABA *)dashPhaseAnimation {
  AZSTATIC_OBJ(CABA, dashAnimation, [self dashPhaseAnimationForPerimeter:40]);
  return dashAnimation;
}

+ (CABA *)dashPhaseAnimationForPerimeter:(CGF)p {

  return [[CABA animationWithKeyPath:@"lineDashPhase"]
      objectBySettingValuesWithDictionary:@{
                                            @"fromValue" : @0,
                                            @"toValue" : @(p),
                                            @"duration" : @10,
                                            @"repeatCount" : @(HUGE_VAL)
                                          }];
}
+ (CABA *)groupAnimationWithKP:(NSS *)path
                         begin:(NSTI)start
                    fromOption: from
                            to: to
                        andSet:(CAL *)set {

  CABA *a = [self animationWithKeyPath:path];
  a.beginTime = start;
  if (from) {
    a.fromValue = from;
    a.toValue = to;
  } else
    a.byValue = to;
  a.layer = set;
  if (set)
    [CAAnimationDelegate delegate:a forLayer:set];
  return a;
}
+ (CABA *)withKP:(NSS *)path
        duration:(NSTI)interval
      fromOption: from
              to: to
          andSet:(CAL *)set {

  CABA *a = [self animationWithKeyPath:path];
  if (from) {
    a.fromValue = from;
    a.toValue = to;
  } else
    a.byValue = to;
  if (set)
    [CAAnimationDelegate delegate:a forLayer:set];
  //		a.start = ^(CAAnimationDelegate *delegate) {
  //			[[delegate.layer modelCALayer] sV:((CABA*)delegate.ani).toValue
  //fK:((CABA*)delegate.ani).keyPath];
  //		};
  return a;
}
@end
@implementation CAAnimation (AtoZ)


+ (CABA*) rotationWithDuration:(NSTI)dur repeats:(int)times {

  return [[CABA animationWithKeyPath:@"transform.rotation" from: @0 to: @(TWOPI) duration:dur repeat:times]
                              objectBySettingValue:@NO forKey:@"autoreverses"];
}
+ (CABA *)rotationAnimation { // By:(CGF)deg {
  // create a CABasic animation
  CABA *a = [CABA animationWithKeyPath:@"transform.rotation.z"];

  // set the values for the rotation
  a.fromValue = DegreesToNumber(359);
  a.toValue = DegreesToNumber(0);
  a.removedOnCompletion = NO;

  // set the speed and the fill mode
  a.speed = 0.5f;
  a.fillMode = kCAFillModeBackwards;

  // set the repeat count
  a.repeatCount = HUGE_VALF;
  return a;
}

+ (CABA *)rotationAt:(NSP)p center:(NSP)c by:(CGF)deg {

  CATransform3D t = CATransform3DIdentity;
  t = CATransform3DTranslate(t, p.x, p.y, 0.0);
  t = CATransform3DRotate(t, deg, 0.0, 0.0, -1.0);
  t = CATransform3DTranslate(t, c.x, c.y, 0.0);

  CABA *a = [CABA animationWithKeyPath:@"transform.rotation"];

  // set the values for the rotation
  a.toValue = AZV3d(t);
  a.removedOnCompletion = NO;
  a.duration = 1;
  // set the speed and the fill mode
  //	a.speed = 0.5f;
  //	a.fillMode = kCAFillModeBackwards;

  // set the repeat count
  a.repeatCount = 0;
  return a;
}

+ (CABA *)wKP:(NSS*)kp duration:(NSTI)d andProps:(NSS*)firstKey, ... { NSS* property = firstKey; id val;

  CABA *a = [CABA animationWithKeyPath:kp]; a.duration = d;  va_list list; va_start(list, firstKey);
  while (!!property && (val = va_arg(list, id))) {
      [a sV:val fK:property]; property = va_arg(list, NSS*); }  va_end(list); return a;
}

+ (CABA *)animationWithKeyPath:(NSS *)path
                   andDuration:(NSTI)interval
                        andSet:(CAL *)set {
  return [self kP:path t:interval f:nil t:nil andSet:set];
}
+ (CABA *)kP:(NSS *)path
           t:(NSTI)interval
           f: from
           t: to
      andSet:(CAL *)set {

  CABA *a = [CABA animationWithKeyPath:path];
  a.keyPath = path;
  ((CABA *)a).duration = interval;
  if (to)
    a.toValue = to;
  if (from)
    a.fromValue = from;
  if (set)
    [CAAnimationDelegate delegate:a forLayer:set];
  //		a.delegate = (d = CAAnimationDelegate.new);
  //		d.start = ^{
  //			[set.modelCALayer sV:a.toValue fK:path];
  //		};
  //	}
  return a;
}

+ (CABA *)propertyAnimation:(NSD *)dict {
  CABA *newA = [dict hasKey:@"keyPath"]
                       ? [CABA animationWithKeyPath:dict[@"keyPath"]]
                       : [CABA animation];
  [dict hasKey:@"keyPath"] ? [newA setValuesForKeysWithDictionary:
                                       [dict dictionaryWithoutKey:@"keyPath"]]
                           : [newA setValuesForKeysWithDictionary:dict];
  return newA;
}

+ (CAA *)backgroundColorAnimationTo:(NSC *)color duration:(NSTI)dur {
  CABA *animation = [CABA animationWithKeyPath:@"backgroundColor"];
  NSDictionary *dic = @{
    @"toValue" : (id)[color CGColor],
    @"duration" : @(dur),
    @"removedOnCompletion" : @NO,
    @"additive" : @YES,
    @"fillMode" : kCAFillModeForwards
  };
  [animation setValuesForKeysWithDictionary:dic];

  return LogAndReturn(animation);
}
+ (CAA *)backgroundColorAnimationFrom:(NSColor *)color1
                                   to:(NSColor *)color2
                             duration:(NSTI)dur {

  CABA *animation = [CABA animationWithKeyPath:@"backgroundColor"];
  NSDictionary *dic = @{
    @"fromValue" : (id)[color1 CGColor],
    @"toValue" : (id)[color2 CGColor],
    @"duration" : @(dur),
    @"removedOnCompletion" : @NO,
    @"fillMode" : kCAFillModeForwards
  };
  [animation setValuesForKeysWithDictionary:dic];
  return animation;
}

+ (CAA *)colorAnimationForLayer:(CALayer *)theLayer
              WithStartingColor:(NSColor *)color1
                       endColor:(NSColor *)color2 {
  CABA *animation = [CABA animationWithKeyPath:@"backgroundColor"];
  NSDictionary *dic = @{
    @"fromValue" : (id)[color1 CGColor],
    @"toValue" : (id)[color2 CGColor],
    @"duration" : @2,
    @"removedOnCompletion" : @(YES),
    @"fillMode" : kCAFillModeForwards
  };
  [animation setValuesForKeysWithDictionary:dic];
  [theLayer addAnimation:animation forKey:@"color"];
  return animation;
}

//+ (CAAnimation*)rotateAnimationForLayer:(CALayer *)theLayer
//start:(CGFloat)starting end:(CGFloat)ending {
//	CABA *animation = [CABA animationWithKeyPath:@"transform.rotation.z"];
////	[animation setFromValue:DegreesToNumber(<#CGFloat
///degrees#>)(previousValue)];
//	[animation setToValue:DegreesToNumber([slider floatValue])];
//
//	[animation setRemovedOnCompletion:NO];
//	[animation setFillMode:kCAFillModeForwards];
//
//	previousValue = [slider floatValue];
//
//	return animation;
//}
//
//}
- (CAA *)rotateAnimationTo:(CGF)endDegrees {
  CABA *animation;
  animation = [CABA animationWithKeyPath:@"transform.rotation.z"];

  //	[animation setFromValue:DegreesToNumber(startDegree)];// previousValue)];
  [animation setToValue:DegreesToNumber(endDegrees)];

  [animation setRemovedOnCompletion:NO];
  [animation setFillMode:kCAFillModeForwards];

  //	previousValue = [slider floatValue];

  return animation;
}

// create a CAAnimation object with result of -newRandomPath as the movement pat
+ (CAA *)randomPathAnimationInFrame:(NSR)frame {
  return [self randomPathAnimationWithStartingPoint:AZRandomPointInRect(frame)
                                            inFrame:frame];
}

// create a CAAnimation object with result of -newRandomPath as the movement
// path
+ (CAA *)randomPathAnimationWithStartingPoint:(CGP)firstPoint
                                      inFrame:(NSR)rect {
  //	CGPathRef path = AZRandomPathWithStartingPointInRect(firstPoint,
  //rect);//:firstPoint];

  CAKA *animation = [CAKA animationWithKeyPath:@"position"];
  animation.path = AZRandomPathWithStartingPointInRect(firstPoint, rect);
  ;
  animation.timingFunction =
      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  animation.duration = RAND_FLOAT_VAL(15, 32);
  animation.autoreverses = YES;
  animation.repeatCount = HUGE_VALF;
  return animation;
}

#pragma mark - Sphere Layer Generation
+ (CAKA *)rotateAnimation {

  CAKA *rotateAnimation = [CAKA animationWithKeyPath:@"transform.rotation.z"];
  rotateAnimation.values = @[ @(0.0), @(M_PI * 2), @(0.0) ];
  rotateAnimation.duration = 0.5f;
  rotateAnimation.keyTimes = @[ @(0), @(.4), @(.5) ];
  return rotateAnimation;
  //	CAKA *positionAnimation = [CAKA animationWithKeyPath:@"position"];
  //	positionAnimation.duration = 0.5f;
  //	CGMutablePathRef path = CGPathCreateMutable();
  //	CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
  //	CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
  //	CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
  //	positionAnimation.path = path;
  //	CGPathRelease(path);
}

//	CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
//	animationgroup.animations = [NSArray arrayWithObjects:positionAnimation,
//rotateAnimation, nil];
//	animationgroup.duration = 0.5f;
//	animationgroup.fillMode = kCAFillModeForwards;
//	animationgroup.timingFunction = [CAMediaTimingFunction
//functionWithName:kCAMediaTimingFunctionEaseIn];
//	[item.layer addAnimation:animationgroup forKey:@"Close"];
//	item.layer.position = item.startPoint;
//	_flag --;
//	}

+ (CAAG *)blowupAnimationAtPoint:(CGP)p {
  CAKA *positionAnimation = [CAKA animationWithKeyPath:@"position"];
  positionAnimation.values = @[ AZVpoint(p) ];
  positionAnimation.keyTimes = @[ @.3f ];

  CABA *scaleAnimation = [CABA animationWithKeyPath:@"transform"];
  scaleAnimation.toValue =
      [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];

  CABA *opacityAnimation = [CABA animationWithKeyPath:@"opacity"];
  opacityAnimation.toValue = @0.0f;

  CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
  animationgroup.animations =
      @[ positionAnimation, scaleAnimation, opacityAnimation ];
  animationgroup.duration = 0.3f;
  animationgroup.fillMode = kCAFillModeForwards;

  return animationgroup;
}
+ (CAAG *)shrinkAnimationAtPoint:(CGP)p {
  CAKA *positionAnimation = [CAKA animationWithKeyPath:@"position"];
  positionAnimation.values = @[ AZVpoint(p) ];
  positionAnimation.keyTimes = @[ @.3f ];

  CABA *scaleAnimation = [CABA animationWithKeyPath:@"transform"];
  scaleAnimation.toValue =
      [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];

  CABA *opacityAnimation = [CABA animationWithKeyPath:@"opacity"];
  opacityAnimation.toValue = @0.0f;

  CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
  animationgroup.animations =
      @[ positionAnimation, scaleAnimation, opacityAnimation ];
  animationgroup.duration = 0.3f;
  animationgroup.fillMode = kCAFillModeForwards;

  return animationgroup;
}
+ (CAA *)
    animationOnPath:(CGPR)p
           duration:(CFTI)d
         timeOffset:(CFTI)
         o { //-
             //(CAAnimation*)animationForCurrentPath:(CFTimeInterval)timeOffset
             //{
  CAKA *animation = [CAKA animation];
  animation.path = p;
  animation.duration = d;
  animation.timeOffset = o;
  animation.repeatCount = 1;
  animation.removedOnCompletion = NO;
  return animation;
}
+ (CAA *)animationForOpacity {
  CABA *fadeAnimation = [CABA animationWithKeyPath:@"opacity"];
  [fadeAnimation setDuration:1];
  [fadeAnimation setAutoreverses:YES];
  [fadeAnimation setToValue:@0.0f];
  return fadeAnimation;
}

+ (CAA *)fadeOutAnimation {
  CABA *fadeAnimation = [CABA animationWithKeyPath:@"opacity"];
  [fadeAnimation setDuration:2];
  [fadeAnimation setAutoreverses:NO];
  [fadeAnimation setToValue:@0];
  [fadeAnimation setFromValue:@1];
  return fadeAnimation;
}
+ (CAA *)fadeInAnimation {
  CABA *fadeAnimation = [CABA animationWithKeyPath:@"opacity"];
  [fadeAnimation setDuration:2];
  [fadeAnimation setAutoreverses:NO];
  [fadeAnimation setToValue:@1];
  [fadeAnimation setFromValue:@0];
  return fadeAnimation;
}

+ (CAA *)animateionForScale {
  CABA *scaleAnimation = [CABA animationWithKeyPath:@"transform.scale"];
  [scaleAnimation setAutoreverses:YES];
  [scaleAnimation setToValue:@0.0f];

  return scaleAnimation;
}
+ (CAA *)animationForRotation {
  CABA *rotateAnimation = [CABA animationWithKeyPath:@"transform.rotation"];
  [rotateAnimation setToValue:AZV3d(CATransform3DMakeRotation(M_PI, 0, 1, 0))];
  [rotateAnimation setRepeatCount:HUGE_VALF];
  [rotateAnimation setDuration:2];
  return rotateAnimation;
}
- _Void_ setAz_completionBlock:(AZCAAnimationCompletionBlock)block {
  self.delegate = self;
  objc_setAssociatedObject(self,
                           &AZCAAnimationCompletionBlockAssociatedObjectKey,
                           block, OBJC_ASSOCIATION_COPY);
}

- (AZCAAnimationCompletionBlock)az_completionBlock {
  return objc_getAssociatedObject(
      self, &AZCAAnimationCompletionBlockAssociatedObjectKey);
}

- _Void_ animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (flag && self.az_completionBlock != nil)
    self.az_completionBlock();
}
+ (CAA *)shakeAnimation {
  CAKA *animation;
  animation = [CAKA animationWithKeyPath:@"transform.rotation.z"];
  [animation setDuration:0.3];
  [animation setRepeatCount:10000];

  // Try to get the animation to begin to start with a small offset
  // that will make it shake out of sync with other layers.
  srand([[NSDate date] timeIntervalSince1970]);
  float rand = (float)random();
  [animation setBeginTime:CACurrentMediaTime() + rand * .0000000001];

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

+ (CAA *)rotateAnimationForLayer:(CAL *)theLayer
                           start:(CGF)starting
                             end:(CGF)ending {
  CABA *animation = [CABA animationWithKeyPath:@"transform.rotation.z"];
  [animation setFromValue:DegreesToNumber(starting)];
  [animation setToValue:DegreesToNumber(ending)];

  [animation setRemovedOnCompletion:NO];
  [animation setFillMode:kCAFillModeForwards];

  //	previousValue = [slider floatValue];

  return animation;
}

//- (CAAnimation *)rotateAnimationFrom:(NSNumber*)startDegree
//to:(NSNumber*)endDegrees
//{
//	CABA * animation;
//	animation = [CABA
//				 animationWithKeyPath:@"transform.rotation.z"];
//
//	[animation setFromValue:NSValue DegreesToNumber(startDegree.floatValue)];//
//previousValue)];
//	[animation setToValue:DegreesToNumber(endDegrees.floatValue)];
//
//	[animation setRemovedOnCompletion:NO];
//	[animation setFillMode:kCAFillModeForwards];
//
//	previousValue = [slider floatValue];
//
//	return animation;
//}
+ (CAKA *)popInAnimation {
  CAKA *animation = [CAKA animation];

  animation.values = @[
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)],
    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]
  ];

  animation.duration = 0.3f;
  return animation;
}
+ (CAA *)flipAnimationWithDuration:(NSTI)aDuration
            forLayerBeginningOnTop:(BOOL)beginsOnTop
                       scaleFactor:(CGF)scaleFactor {
  // Rotating halfway (pi radians) around the Y axis gives the appearance of
  // flipping
  CABA *flipAnimation = [CABA animationWithKeyPath:@"transform.rotation.y"];
  CGFloat startValue = beginsOnTop ? 0.0f : M_PI;
  CGFloat endValue = beginsOnTop ? -M_PI : 0.0f;
  flipAnimation.fromValue = @(startValue);
  flipAnimation.toValue = @(endValue);
  // Shrinking the view makes it seem to move away from us, for a more natural
  // effect
  //	Can also grow the view to make it move out of the screen
  CABA *shrinkAnimation = nil;
  if (scaleFactor != 1.0f) {
    shrinkAnimation = [CABA animationWithKeyPath:@"transform.scale"];
    shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];
    // We only have to animate the shrink in one direction, then use autoreverse
    // to "grow"
    shrinkAnimation.duration = aDuration * 0.5;
    shrinkAnimation.autoreverses = YES;
  }
  // Combine the flipping and shrinking into one smooth animation
  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.animations = @[ flipAnimation, shrinkAnimation ];
  // As the edge gets closer to us, it appears to move faster. Simulate this in
  // 2D with an easing function
  animationGroup.timingFunction = [CAMediaTimingFunction
      functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  animationGroup.duration = aDuration;
  // Hold the view in the state reached by the animation until we can fix it, or
  // else we get an annoying flicker
  animationGroup.fillMode = kCAFillModeForwards;
  animationGroup.removedOnCompletion = NO;
  return animationGroup;
}
+ (CAA *)flipDown:(NSTI)aDuration scaleFactor:(CGF)scaleFactor {

  // Rotating halfway (pi radians) around the Y axis gives the appearance of
  // flipping
  CABA *flipAnimation = [CABA animationWithKeyPath:@"transform.rotation.y"];
  CGFloat startValue = /*beginsOnTop ? 0.0f :*/ M_PI;
  CGFloat endValue = /*beginsOnTop-M_PI :*/ 0.0f;
  flipAnimation.fromValue = @(startValue);
  flipAnimation.toValue = @(endValue);

  // Shrinking the view makes it seem to move away from us, for a more natural
  // effect
  // Can also grow the view to make it move out of the screen
  CABA *shrinkAnimation = nil;
  if (scaleFactor != 1.0f) {
    shrinkAnimation = [CABA animationWithKeyPath:@"transform.scale"];
    shrinkAnimation.toValue = [NSNumber numberWithFloat:scaleFactor];

    // We only have to animate the shrink in one direction, then use autoreverse
    // to "grow"
    shrinkAnimation.duration = aDuration * 0.5;
    shrinkAnimation.autoreverses = YES;
  }

  // Combine the flipping and shrinking into one smooth animation
  CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
  animationGroup.animations = @[ flipAnimation, shrinkAnimation ];

  // As the edge gets closer to us, it appears to move faster. Simulate this in
  // 2D with an easing function
  animationGroup.timingFunction = [CAMediaTimingFunction
      functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  animationGroup.duration = aDuration;

  // Hold the view in the state reached by the animation until we can fix it, or
  // else we get an annoying flicker
  animationGroup.fillMode = kCAFillModeForwards;
  animationGroup.removedOnCompletion = NO;

  return animationGroup;
}

//@implementation CAKA (JumpingAndShaking)

+ (CAKA *)shakeAnimation:(NSRect)frame {
  static int numberOfShakes = 3;
  static float durationOfShake = .4;
  static float vigourOfShake = 0.2f;
  CAKA *shakeAnimation = [CAKA animation];
  CGMutablePathRef shakePath = CGPathCreateMutable();
  CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
  for (int index = 0; index < numberOfShakes; ++index) {
    CGPathAddLineToPoint(shakePath, NULL,
                         NSMinX(frame) - frame.size.width * vigourOfShake,
                         NSMinY(frame));
    CGPathAddLineToPoint(shakePath, NULL,
                         NSMinX(frame) + frame.size.width * vigourOfShake,
                         NSMinY(frame));
  }
  CGPathCloseSubpath(shakePath);
  shakeAnimation.path = shakePath;
  shakeAnimation.duration = durationOfShake;
  return shakeAnimation;
}
+ (CAKA *)jumpAnimation {
  // these three values are subject to experimentation
  CGFloat initialMomentum = 300.0f;       // positive is upwards, per sec
  CGFloat gravityConstant = 250.0f;       // downwards pull per sec
  CGFloat dampeningFactorPerBounce = 0.6; // percent of rebound

  // internal values for the calculation
  CGFloat momentum = initialMomentum; // momentum starts with initial value
  CGFloat positionOffset = 0;         // we begin at the original position
  CGFloat slicesPerSecond = 60.0f;    // how many values per second to calculate
  CGFloat lowerMomentumCutoff =
      5.0f; // below this upward momentum animation ends

  CGFloat duration = 0;
  NSMutableArray *values = [NSMutableArray array];

  do {
    duration += 1.0f / slicesPerSecond;
    positionOffset += momentum / slicesPerSecond;

    if (positionOffset < 0) {
      positionOffset = 0;
      momentum = -momentum * dampeningFactorPerBounce;
    }

    // gravity pulls the momentum down
    momentum -= gravityConstant / slicesPerSecond;

    CATransform3D transform =
        CATransform3DMakeTranslation(0, -positionOffset, 0);
    [values addObject:[NSValue valueWithCATransform3D:transform]];
  } while (!(positionOffset == 0 && momentum < lowerMomentumCutoff));

  CAKA *animation = [CAKA animationWithKeyPath:@"transform"];
  animation.repeatCount = 1;
  animation.duration = duration;
  animation.fillMode = kCAFillModeForwards;
  animation.values = values;
  animation.removedOnCompletion = YES; // final stage is equal to starting stage
  animation.autoreverses = NO;

  return animation;
}

+ (CAKA *)dockBounceAnimationWithIconHeight:(CGFloat)iconHeight {
  CGFloat factors[32] = {0,   32, 60, 83, 100, 114, 124, 128, 128, 124, 114,
                         100, 83, 60, 32, 0,   24,  42,  54,  62,  64,  62,
                         54,  42, 24, 0,  18,  28,  32,  28,  18,  0};

  NSMutableArray *values = [NSMutableArray array];

  for (int i = 0; i < 32; i++) {
    CGFloat positionOffset = factors[i] / 128.0f * iconHeight;

    CATransform3D transform =
        CATransform3DMakeTranslation(0, -positionOffset, 0);
    [values addObject:[NSValue valueWithCATransform3D:transform]];
  }

  CAKA *animation = [CAKA animationWithKeyPath:@"transform"];
  animation.repeatCount = 1;
  animation.duration = 32.0f / 30.0f;
  animation.fillMode = kCAFillModeForwards;
  animation.values = values;
  animation.removedOnCompletion = YES; // final stage is equal to starting stage
  animation.autoreverses = NO;

  return animation;
}

- (CAKA *)negativeShake:(NSRect)frame {
  int numberOfShakes = 4;
  float durationOfShake = 0.5f;
  float vigourOfShake = 0.05f;

  CAKA *shakeAnim = [CAKA animation];

  CGMutablePathRef shakePath = CGPathCreateMutable();
  CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
  int index;
  for (index = 0; index < numberOfShakes; ++index) {
    CGPathAddLineToPoint(shakePath, NULL,
                         NSMinX(frame) - frame.size.width * vigourOfShake,
                         NSMinY(frame));
    CGPathAddLineToPoint(shakePath, NULL,
                         NSMinX(frame) + frame.size.width * vigourOfShake,
                         NSMinY(frame));
  }
  CGPathCloseSubpath(shakePath);
  shakeAnim.path = shakePath;
  shakeAnim.duration = durationOfShake;
  return shakeAnim;
}

- (IBAction)shakeBabyShake: sender;
{
  NSString *key = @"frameOrigin";
  if ([NSWindow defaultAnimationForKey:key] == nil) {
    NSLog(@"NSVindow not animatable for key '%@'", key);
  } else {
    [[NSApp keyWindow]
        setAnimations:@{key : [self negativeShake:[[NSApp keyWindow] frame]]}];
    [[[NSApp keyWindow] animator]
        setFrameOrigin:[[NSApp keyWindow] frame].origin];
  }
}

+ (CAKA *)colorAnimationWithPalette:(NSA *)p duration:(NSTI)t {

  CAKA *animation = [CAKA animationWithKeyPath:@"backgroundNSColor"];
  animation.repeatCount = HUGE_VALF;
  animation.duration = t;
  animation.fillMode = kCAFillModeForwards;
  animation.values = [NSC gradientPalletteLooping:p steps:p.count * 2];
  animation.keyTimes = [@0 to:@1 by:@(t / (CGF)animation.values.count)];
  animation.removedOnCompletion = YES; // final stage is equal to starting stage
  animation.autoreverses = NO;
  return animation;
}

@end

@implementation NSView (CAAnimationEGOHelper)

- _Void_ popInAnimated {
  if ([self wantsLayer])
    [[self layer] popInAnimated];
}

@end

@implementation CALayer (CAAnimationEGOHelper)

- _Void_ popInAnimated {
  [self addAnimation:[CAAnimation popInAnimation] forKey:@"transform"];
}

@end

//@implementation CAAnimation (MCAdditions)

//	//assuming view is your NSView
// CGPoint newCenter = CGPointMake(view.center.x - 300, view.center.y);
// CABA *animation = [CABA animation];
//	//setup your animation eg. duration/other options
// animation.fromValue = [NSValue valueWithCGPoint:v.center];
// animation.toValue = [NSValue valueWithCGPoint:newCenter];
//[view.layer addAnimation:animation forKey:@"key"];
//
//- (CAKA *)slideOut:(NSRect)frame oriented: (AZOrient)orientation{
//
//	CAKA *slideout = [CAKA animation];
//
//	CGMutablePathRef slidePath = CGPathCreateMutable();
//	CGFloat xFin, yFin;  CGPoint go;
//
//	switch (orientation) {
//		case AZOrientLeft:
//		case AZOrientRight:
//			xFin = 	orientation == AZOrientLeft ?  - NSMaxX(frame)	:
//NSMaxX(frame) ;
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
//				CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width
//* vigourOfShake, NSMinY(frame));
//				CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width
//* vigourOfShake, NSMinY(frame));
//			}
//			CGPathCloseSubpath(shakePath);
//			shakeAnim.path = shakePath;
//			shakeAnim.duration = durationOfShake;
//			return shakeAnim;
//	}
//

//- _Void_ animateView:(NSView*)sender {
//		// Get the relevant frames.
//	NSView *enclosingView = [[[NSApplication sharedApplication] mainWindow]
//contentView];
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
//	yellowFadeView = NSView.new;
//	[yellowFadeView setWantsLayer:YES];
//	[yellowFadeView setFrame:cellFrame];
//	[yellowFadeView setLayer:layer];
//	[[yellowFadeView layer] setNeedsDisplay];
//	[yellowFadeView setAlphaValue:0.0];
//	[sourceList addSubview:yellowFadeView];
//
//		// Create the animation pieces.
//	CABA *alphaAnimation = [CABA animationWithKeyPath: @"alphaValue"];
//	alphaAnimation.beginTime = 1.0;
//	alphaAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
//	alphaAnimation.toValue = [NSNumber numberWithFloat: 1.0];
//	alphaAnimation.duration = 0.25;
//	CABA *alphaAnimation2 = [CABA animationWithKeyPath: @"alphaValue"];
//	alphaAnimation2.beginTime = 1.25;
//	alphaAnimation2.duration = 0.25;
//	alphaAnimation2.fromValue = [NSNumber numberWithFloat: 1.0];
//	alphaAnimation2.toValue = [NSNumber numberWithFloat: 0.0];
//	CABA *alphaAnimation3 = [CABA animationWithKeyPath: @"alphaValue"];
//	alphaAnimation3.beginTime = 1.5;
//	alphaAnimation3.duration = 0.25;
//	alphaAnimation3.fromValue = [NSNumber numberWithFloat: 0.0];
//	alphaAnimation3.toValue = [NSNumber numberWithFloat: 1.0];
//	CABA *alphaAnimation4 = [CABA animationWithKeyPath: @"alphaValue"];
//	alphaAnimation4.beginTime = 1.75;
//	alphaAnimation4.duration = 0.25;
//	alphaAnimation4.fromValue = [NSNumber numberWithFloat: 1.0];
//	alphaAnimation4.toValue = [NSNumber numberWithFloat: 0.0];
//
//		// Create the animation group.
//	CAAnimationGroup *yellowFadeAnimation = [CAAnimationGroup animation];
//	yellowFadeAnimation.delegate = self;
//	yellowFadeAnimation.animations =@[ alphaAnimation, alphaAnimation2,
//alphaAnimation3, alphaAnimation4 ];
//	yellowFadeAnimation.duration = 2.0;
//	[yellowFadeView setAnimations:@{ @"frameOrigin":yellowFadeAnimation} ];
//
//		// Start the yellow fade animation.
//	[[yellowFadeView animator] setFrame:[yellowFadeView frame]];
//}
//
//- _Void_ drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
//		// Bezier path radius
//	int radius = 4;
//
//		// Setup graphics context.
//	NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext
//graphicsContextWithGraphicsPort:ctx flipped:NO];
//	[NSGraphicsContext saveGraphicsState];
//	[NSGraphicsContext setCurrentContext:nsGraphicsContext];
//
//		// Convert to NSRect.
//	CGRect aRect = [layer frame];
//	NSRect rect = NSMakeRect(aRect.origin.x, aRect.origin.y, aRect.size.width,
//aRect.size.height);
//
//		// Draw dark outside line.
//	[NSBezierPath setDefaultLineWidth:2];
//	NSBezierPath *highlightPath = [NSBezierPath bezierPathWithRoundedRect:rect
//xRadius:radius yRadius:radius];
//	[[NSColor yellowColor] set];
//	[highlightPath stroke];
//
//		// Draw transparent inside fill.
//	CGFloat r, g, b, a;
//	[[NSColor yellowColor] getRed:&amp;r green:&amp;g blue:&amp;b alpha:&amp;a];
//	NSColor *transparentYellow = [NSColor colorWithCalibratedRed:r green:g
//blue:b alpha:0.5];
//	NSBezierPath *fillPath = [NSBezierPath bezierPathWithRoundedRect:rect
//xRadius:radius yRadius:radius];
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

 @property (NA, CP) void (^completion)(BOOL);
 @property (NA, CP) void (^start)();

 - _Void_ animationDidStart:(CAAnimation *)anim;
 - _Void_ animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;

 @end
 @implementation CAAnimationDelegate

 @synthesize completion=_completion;
 @synthesize start=_start;

 - init
 {
 self = [super init];
 if (self) {
 self.completion = nil;
 self.start = nil;
 }
 return self;
 }

 - _Void_ dealloc
 {
 self.completion = nil;
 self.start = nil;
 //	[super dealloc];
 }

 - _Void_ animationDidStart:(CAAnimation *)anim
 {
 if (self.start != nil) {
 self.start();
 }
 }

 - _Void_ animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
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
 if (self.delegate != nil && ![self.delegate isKindOfClass:[CAAnimationDelegate
 class]]) {
 NSLog(@"CAAnimation(BlocksAddition) Warning: CAAnimation instance's delegate
 was modified externally");
 return NO;
 }
 return YES;
 }

 - _Void_ setCompletion:(void (^)(BOOL))completion
 {
 CAAnimationDelegate *newDelegate = CAAnimationDelegate.new;
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

 - _Void_ setStart:(void (^)())start
 {
 CAAnimationDelegate *newDelegate = CAAnimationDelegate.new;
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

 - _Void_ runAnimation: unused
 {
 // Create a shaking animation that rotates a bit counter clockwisely and then
 rotates another
 // bit clockwisely and repeats. Basically, add a new rotation animation in the
 opposite
 // direction at the completion of each rotation animation.
 const CGFloat duration = 0.1f;
 const CGFloat angle = 0.03f;
 NSNumber *angleR = [NSNumber numberWithFloat:angle];
 NSNumber *angleL = [NSNumber numberWithFloat:-angle];

 CABA *animationL = [CABA animationWithKeyPath:@"transform.rotation.z"];
 CABA *animationR = [CABA animationWithKeyPath:@"transform.rotation.z"];

 void (^completionR)(BOOL) = ^(BOOL finished) {
 [self.imageView.layer setValue:angleL forKey:@"transform.rotation.z"];
 [self.imageView.layer addAnimation:animationL forKey:@"L"]; // Add rotation
 animation in the opposite direction.
 };

 void (^completionL)(BOOL) = ^(BOOL finished) {
 [self.imageView.layer setValue:angleR forKey:@"transform.rotation.z"];
 [self.imageView.layer addAnimation:animationR forKey:@"R"];
 };

 animationL.fromValue = angleR;
 animationL.toValue = angleL;
 animationL.duration = duration;
 animationL.completion = completionL; // Set completion to perform rotation in
 opposite direction upon completion.

 animationR.fromValue = angleL;
 animationR.toValue = angleR;
 animationR.duration = duration;
 animationR.completion = completionR;

 // First animation performs half rotation and then proceeds to enter the loop
 by playing animationL in its completion block
 CABA *animation = [CABA animationWithKeyPath:@"transform.rotation.z"];
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
 CABA *anotherAnimation = [CABA animationWithKeyPath:@"position.x"];
 anotherAnimation.fromValue = @(self.anotherImageView.layer.position.x);
 anotherAnimation.toValue = @600.0f;
 anotherAnimation.duration = 2;
 [anotherAnimation setCompletion:^(BOOL finished) {
 CABA *oneMoreAnimation = [CABA animationWithKeyPath:@"position.x"];
 oneMoreAnimation.fromValue = @600.0f;
 oneMoreAnimation.toValue = @160.0f;
 oneMoreAnimation.duration = 1;
 [self.anotherImageView.layer addAnimation:oneMoreAnimation forKey:@"1"];
 }];
 [self.anotherImageView.layer addAnimation:anotherAnimation forKey:@"1"];

 */

@implementation CAKA (AtoZ)

+ (CAKA *)animationWithKeyPath:(NSS *)path
                        values:(NSA *)vals
                      duration:(NSTI)time
                        repeat:(CGF)ct {

  CAKA *new = [self animationWithKeyPath : path];
  new.values = [vals copy];
  new.duration = time;
  new.repeatCount = ct;
  return new;
}

@end
