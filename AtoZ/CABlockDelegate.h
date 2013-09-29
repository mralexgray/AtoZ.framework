
/*  CABlockDelegate.h	*//***  AtoZCodeFactory *//*  Created by Alex Gray on 6/1/13. */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AtoZUmbrella.h"

JROptionsDeclare( NSOVBlockDelegate, NSOVBlockDelegateDisclosureTriangle, NSOVBlockDelegateGroup );

#define OVDIBLK 	NSIMG* 	(^)(id cell, NSTC *tc, id item) // disclosureImage
#define OVTOGA 	void		(^)(id item)						  // toggleItemAction
#define OVIGR 		BOOL 		(^)(NSOV*v,id,x)						// isgroupitem
//typedef NSIMG* (^disclosureImageForItem) 		(id cell, NSTC *tc, id item);
//typedef void	(^outlineViewToggleItemAction)(id item);

@interface  NSOutlineViewBlockDelegate : NSO <NSOutlineViewDelegate, NSOutlineViewDataSource>

@property (WK) 						 NSOV * ov;
@property (NATOM,CP) 					id   block;
@property 				NSOVBlockDelegate   blockType;
@property (NATOM,STR) 				 NSMD	* toggleActionReference;
@property (NATOM,CP)  NSIMG*(^disclosureImage) (id cell, NSTC *tc, id item);
@property (NATOM,CP)	 void  (^toggleItemAction)(id item);
@property (NATOM,CP)  BOOL  (^isgroupItem)	  (NSOV*v,id x);
+ (instancetype) delegateFor:(NSOV*)v ofType:(NSOVBlockDelegate)type withBlock:(id)block;
- 			 (BOOL) outlineView:(NSOV*)v isGroupItem:(id)x;
- 			 (void) outlineView:(NSOV*)v willDisplayOutlineCell:(id)cell forTableColumn:(NSTC*)c item:(id)x;
- 			 (void) setToggleActionForItem:(id)item block:(OVTOGA)itemBlock;

@end


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
//	Delegate method called by CAAnimation at end of animation
 * @param theAnimation animation which issued the callback.
 * @param finished BOOL indicating whether animation succeeded or failed.
- (void)animationDidStop:(CAA*)theAnimation	finished:(BOOL)flag;
*/

//typedef         void (^ kvoObserverBlock ) ( CAL * l,    NSS * k );
//typedef 			 void (^ layoutBlock 	  ) ( CAL * l             );
//typedef id<CAAction> (^ layerActionBlock ) ( CAL * l,    NSS * k );
//typedef 			 void (^ drawBlock 		  ) ( CAL * l, CGCREF   x );
//typedef         void (^ aniComplete 	  ) ( BOOL  f,    CAA * a );


#define CABKVO 	void 			 (^) ( CAL * l,    NSS * k )  // kvoObserverBlock
#define CABLAYOUT	void 			 (^) ( CAL * l             )  // layoutBlock
#define CABACTION id<CAAction> (^) ( CAL * l,    NSS * k )  // layerActionBlock
#define CABDRAW	void 			 (^) ( CAL * l, CGCREF   x )  // drawBlock
#define CABANIC   void 			 (^) ( BOOL  f,    CAA * a )  // aniComplete
#define CABANIS   void 			 (^) ( CAA * a 				) 	//	aniStart

JROptionsDeclare( CABlockType,	CABlockTypeDrawBlock,	CABlockTypeDrawInContext,
  										   CABlockTypeAniComplete, CABlockTypeAniStart,
											CABlockTypeLayoutBlock, CABlockTypeLayerAction,
																			CABlockTypeKVOChange	);
@interface CABlockDelegate : NSObject
/*	Determines the delegate type, generates an instance, saves itself as property on layer,
	declares itself as layers delegate, or layoutmanager, etc.  calls setneeds.... blah blah.
	returns itself, but chances are you wont evem need to reference it again. */
+ (instancetype) delegateFor:(CAL*)l ofType:(CABlockType)t withBlock:(id)k;

@property (STR) 		NSMD *pendingAnimations;
@property (NATOM,CP) void 			 (^ kvoObserverBlock ) ( CAL* l,  NSS* k ); //kvoObserverBlock kvoBlock; void (^ layoutBlock 	  ) ( CALayer*               );
@property (NATOM,CP) void 			 (^ layoutBlock 	  	) ( CAL* l          ); // layoutBlock layoutBlock;// 		  void (^ layoutBlock 	  ) ( CALayer*               );
@property (NATOM,CP) id<CAAction> (^ layerActionBlock ) ( CAL* l,  NSS* k ); //layerActionBlock layerActionBlock;// id<CAAction> (^ layerActionBlock ) ( CALayer*,   NSString*  );
@property (NATOM,CP) void 			 (^ drawBlock 	 	   ) ( CAL* l,CGCREF x ); // drawBlock drawBlock;			// void (^ drawBlock 		  ) ( CALayer*, CGContextRef );
@property (NATOM,CP) void 			 (^ drawInContextBlk ) ( CAL* l  	 	  ); // drawINCONTEXTBlock drawBlock;			// void (^ drawBlock 		  ) ( CALayer*, CGContextRef );
@property (NATOM,CP) void 			 (^ aniComplete 	   ) ( BOOL f,  CAA* a ); // aniComplete aniComplete;//			 void (^ aniComplete 	  ) (     BOOL, CAAnimation* );
@property (NATOM,CP) void 			 (^ aniStart 	      ) ( CAA* a 			  );
@end

typedef id (^ transformBlock ) ( id value );
@interface NSObject (AZBlockFactory)
@property (readonly) NSString* properties;
@property (assign) 	CABlockType blockType;
//- (void)  bind:(NSString*)b toObject:(id)o withKeyPath:(NSString*)kp transform:(id(^)(id))transformBlock;
//- (BOOL)  overrideSelector:  			 (SEL)selector 						withBlock:    (void*)block;
//- (void*) superForSelector:		 	 (SEL)selector;
@end


@interface CALayer (BlockDrawLayer)
+ (CAL*) layerWithFrame:(NSR)f drawnUsingBlock:(void(^)(CAL*))drawBlock;
@end


#define CAABCOMPINFO void (^)	(CAAnimationDelegate*delegate) 	// completionWithInfo
#define CAABSTRTINFO void (^)	(CAAnimationDelegate*delegate) 	// startWithInfo
#define CAABCOMP		void (^)	(void)									// completion
#define CAABSTRT		void (^)	(void)									// start

@interface CAAnimationDelegate : NSObject
+ (instancetype) delegate:(CAA*)a forLayer:(CAL*)l;
@property BOOL andSet; 				// defaults to yes
@property (WK) CAA* ani;
@property (WK) CAL* layer;
@property (NATOM,CP) void (^completionWithInfo)	(CAAnimationDelegate*delegate);
@property (NATOM,CP) void (^startWithInfo)		(CAAnimationDelegate*delegate);
@property (NATOM,CP) void (^completion)			(void);
@property (NATOM,CP) void (^start)					(void);
//- (void)animationDidStart:	(CAA*)a;							// CALAyer deleagte methods
//- (void)animationDidStop:	(CAA*)a finished:(BOOL)f;  // CALAyer deleagte methods
@end
//- (void)setCompletion:(void (^)(CAA* a, BOOL finished))completion; // Forces auto-complete of setCompletion: to add the name 'finished' in the block parameter


@interface CAAnimation (BlocksAddition)
@property (weak) CAL * layer;
- (void) setCompletion: (CAABCOMPINFO)comp forLayer:(CAL*)l;
- (void) setCompletion:	(CAABCOMPINFO)complete;
- (void) setStart:		(CAABSTRTINFO)start;
//@property (nonatomic, copy) void (^start)					(void);
@end


//@interface CATransaction (AZBlockFactory)
//+ (void) transactionWithLength: (NSTimeInterval)dur actions:(void(^)()) block;
//+ (void) transactionWithLength: (NSTimeInterval)dur easing:(id)ease actions:(void(^)()) block;
//+ (void) immediately:(void (^)())block;
//@end
//
//@interface NSGraphicsContext (AZBlockFactory)
//+(void)drawInContext:(CGContextRef)ctx flipped:(BOOL)flipped actions:(void(^)())actions;
//-(void)state:(void(^)())actions;
//+(void)state:(void(^)())actions;
//@end
//
//
//
//
//@interface CALayer (CAScrollLayer_Extensions)
//-   (id) scanSubsForClass:		(Class)c;
//- (void) scrollBy:				(CGPoint)inDelta;
//- (void) scrollCenterToPoint:	(CGPoint)inPoint;
//@end



