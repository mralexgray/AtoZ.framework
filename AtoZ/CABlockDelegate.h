
/*  CABlockDelegate.h	*//***  AtoZCodeFactory *//*  Created by Alex Gray on 6/1/13. */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AtoZUmbrella.h"



JROptionsDeclare( NSOVBlockDelegate,NSOVBlockDelegateDisclosureTriangle);

typedef NSIMG*(^disclosureImageForItem) (id cell,NSTC *tc, id item);
typedef void(^outlineViewToggleItemAction)(id item);


@interface NSOutlineViewBlockDelegate : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource>

+ (instancetype) delegateFor:(NSOV*)v ofType:(NSOVBlockDelegate)type withBlock:(id)block;

@property (weak) NSOutlineView *ov;
@property (nonatomic, copy) id block;
@property NSOVBlockDelegate blockType;
@property (strong, nonatomic) NSMD *toggleActionReference;
@property (nonatomic, strong) disclosureImageForItem disclosureImage;
- (void)outlineView:(NSOV*)v willDisplayOutlineCell:(id)c forTableColumn:(NSTC*)c item:(id)x;

- (void) setToggleActionForItem:(id)item block:(outlineViewToggleItemAction)itemBlock;

@end

typedef         void (^ kvoObserverBlock ) ( CAL * l,    NSS * k );
typedef 			 void (^ layoutBlock 	  ) ( CAL * l             );
typedef id<CAAction> (^ layerActionBlock ) ( CAL * l,    NSS * k );
typedef 			 void (^ drawBlock 		  ) ( CAL * l, CGCREF   x );
typedef         void (^ aniComplete 	  ) ( BOOL  f,    CAA * a );

JROptionsDeclare( CABlockType,	CABlockTypeDrawBlock,		CABlockTypeLayoutBlock, 
																CABlockTypeAniComplete, 	CABlockTypeLayerAction, CABlockTypeKVOChange	);
@interface CABlockDelegate : NSObject


/*inspiredby 
// Block to call when animation is started
 @property (nonatomic, strong) void(^blockOnAnimationStarted)(void);
	// Block to call when animation is successful
@property (nonatomic, strong) void(^blockOnAnimationSucceeded)(void);
	// Block to call when animation fails
@property (nonatomic, strong) void(^blockOnAnimationFailed)(void);
 * Delegate method called by CAAnimation at start of animation
 * @param theAnimation animation which issued the callback.
- (void)animationDidStart:(CAA*)theAnimation;
/* Delegate method called by CAAnimation at end of animation
 * @param theAnimation animation which issued the callback.
 * @param finished BOOL indicating whether animation succeeded or failed.
- (void)animationDidStop:(CAA*)theAnimation	finished:(BOOL)flag;
*/

@property (strong) NSMD *pendingAnimations;
// Determines the delegate type, generates an instance, saves itself as property on layer, declares itself as layers delegate, or layoutmanager, etc.  calls setneeds.... blah blah.  returns itself, but chances are you wont evem need to reference it again.
+ (instancetype) delegateFor:(CALayer*)layer ofType:(CABlockType)type withBlock:(id)block;

@property (nonatomic, strong) kvoObserverBlock kvoBlock;// 		  void (^ layoutBlock 	  ) ( CALayer*               );
@property (nonatomic, strong) layoutBlock layoutBlock;// 		  void (^ layoutBlock 	  ) ( CALayer*               );
@property (nonatomic, strong) layerActionBlock layerActionBlock;// id<CAAction> (^ layerActionBlock ) ( CALayer*,   NSString*  );
@property (nonatomic, strong) drawBlock drawBlock;			// void (^ drawBlock 		  ) ( CALayer*, CGContextRef );
@property (nonatomic, strong) aniComplete aniComplete;//			 void (^ aniComplete 	  ) (     BOOL, CAAnimation* );
@end

typedef id (^ transformBlock ) ( id value );
@interface NSObject (AZBlockFactory)
@property (readonly) NSString* properties;
@property (assign) CABlockType blockType;
- (void)  bind:(NSString*)b toObject:(id)o withKeyPath:(NSString*)kp transform:(id(^)(id))transformBlock;
- (BOOL)  overrideSelector:  			 (SEL)selector 						withBlock:    (void*)block;
- (void*) superForSelector:		 	 (SEL)selector;
@end

@interface CATransaction (AZBlockFactory)
+ (void) transactionWithLength: (NSTimeInterval)dur actions:(void(^)()) block;
+ (void) transactionWithLength: (NSTimeInterval)dur easing:(id)ease actions:(void(^)()) block;
+ (void) immediately:(void (^)())block;
@end

@interface NSGraphicsContext (AZBlockFactory)
+(void)drawInContext:(CGContextRef)ctx flipped:(BOOL)flipped actions:(void(^)())actions;
-(void)state:(void(^)())actions;
+(void)state:(void(^)())actions;
@end




@interface CALayer (CAScrollLayer_Extensions)
-   (id) scanSubsForClass:		(Class)c;
- (void) scrollBy:				(CGPoint)inDelta;
- (void) scrollCenterToPoint:	(CGPoint)inPoint;
@end




