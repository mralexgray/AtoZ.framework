//  CAA+AtoZ.h
//  AtoZ

#import <QuartzCore/QuartzCore.h>



@interface CAAnimationGroup (oneLine)
+ (CAAnimationGroup*) groupWithAnimations:(NSA*)anis duration:(NSTI)ti andSet:(CAL*)layer;
@end


typedef void (^AZCAAnimationCompletionBlock)();

//Note this is slightly flawed as we set ourself as the delegate, really we should create a chained proxy, if we need that I will add it.
@interface CATransaction (AtoZ)
+ (void)flushBlock:(VoidBlock)block;

//+ (void)CADisabledBlock:(void(^)(void))block;
//+ (void) immediatelyWithCompletion:(void (^)())completion transaction:(void (^)())block;
//+ (void)az_performWithDisabledActions:(void(^)(void))block
@end

//typedef void (^disableCA) {
//- (NSArray*) setPropertiesWithCADisabled:(BOOL (^)(id obj))block		{
//		NSMutableArray * results = NSMA.new;
//		[self each:^(id obj, NSUInteger index, BOOL *stop) {
//			if (block(obj))		[results addObject:obj];		}];
//		return results;
//	}
//	[CATransaction flush];  [CATransaction begin];
//	[CATransaction setValue:@(YES) forKey:kCATransactionDisableActions];
//}

@interface CAAnimationDelegate : NSObject

@property (nonatomic, copy) void (^completion)(CAA*,BOOL);
@property (nonatomic, copy) void (^start)(void);
@property (weak) CAL* layer;
- (void)animationDidStart:(CAAnimation *)anim;
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag;
@end

@interface CAAnimation (BlocksAddition)

@property (weak) CAL *layer;
@property (nonatomic, copy) void (^completion)(CAA* a, BOOL finished);
@property (nonatomic, copy) void (^start)(void);

- (void)setCompletion:(void (^)(CAA* a, BOOL finished))completion; // Forces auto-complete of setCompletion: to add the name 'finished' in the block parameter

@end
extern void disableCA();
@interface CAKeyframeAnimation (JumpingAndShaking)
+ (CAKA*) shakeAnimation:(NSR)frame;
+ (CAKA*) jumpAnimation;
+ (CAKA*) dockBounceAnimationWithIconHeight:(CGF)iconHeight;
@end

@interface CABA (AtoZ)
+ (CABA*) groupAnimationWithKP:(NSS*)path begin:(NSTI)start fromOption:(id)from to:(id)to andSet:(CAL*)set;
+ (CABA*) withKP:(NSS*)path duration:(NSTI)interval fromOption:(id)from to:(id)to andSet:(CAL*)set;
@end
@interface CAA (AtoZ)

+ (CABA*) animationWithKeyPath: (NSS*)path andDuration:(NSTI)interval andSet:(CAL*)set;
+ (CABA*) propertyAnimation: (NSD*) dict;

+ (CAA*)  randomPathAnimationWithStartingPoint:(CGP)firstPoint inFrame:(NSR)rect;
+ (CAA*)  randomPathAnimationInFrame:(NSR) frame;

+ (CAKA*)	 popInAnimation;
+ (CAAG*) shrinkAnimationAtPoint: (CGP)p;
+ (CAAG*) blowupAnimationAtPoint: (CGP)p;

+ (CAA*)	shakeAnimation;
+ (CAA*)	animationForOpacity;
+ (CAA*)	flipDown: (NSTI)aDur  scaleFactor: (CGF)scale;
+ (CAA*)	animationOnPath: (CGPR)path  duration:	(CFTI)d 	  timeOffset: (CFTI)o;
+ (CAA*) rotateAnimationForLayer: (CAL*)layer start:(CGF)fl1	 end: (CGF)fl1;
+ (CAA*) colorAnimationForLayer:(CALayer*) theLayer WithStartingColor:(NSColor*)color1 endColor:(NSColor*)color2;
+ (CAA*) backgroundColorAnimationFrom:	(NSC*)color1 to:(NSC*)color2 duration:(NSTI)dur;
+ (CAA*) backgroundColorAnimationTo:	(NSC*)color 					  duration:(NSTI)dur;

@property (NATOM, CP) AZCAAnimationCompletionBlock az_completionBlock;
@end

//+ (CAA*) animationForScale;
//+ (CAA*) animationForRotation;
//+ (CAA*) flipAnimationWithDuration: (NSTI)aDur;
//+ (CAA*) colorAnimationForLayer: (CAL*)layer start:	   (NSC*)c1  	  end: (NSC*)c2;
//- (CAA*) rotateAnimationFrom:(NSNumber*)startDegree to:(NSNumber*)endDegrees;
//+ (CAA*)rotateAnimationForLayer:(CALayer*) theLayer start:(CGF)starting end:(CGF)ending;

@interface NSView (CAAEGOHelper)
- (void)popInAnimated;
@end
@interface CALayer (CAAEGOHelper)
- (void)popInAnimated;
@end

@interface CATransition (AtoZ)
+ (CATransition*) randomTransition;
+ (NSA*)transitionsFor:(id)targetView;
@end

