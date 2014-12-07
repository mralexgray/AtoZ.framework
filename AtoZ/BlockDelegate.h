
/*  BlockDelegate.h	*//***  AtoZCodeFactory *//*  Created by Alex Gray on 6/1/13. */

#import "AtoZUmbrella.h"

JREnumDeclare( BlockDelegateType,	
  UndefinedBlockDelegate    = 0x00000000,
  CABlockTypeDrawBlock      = 0x00000001, 
  CABlockTypeDrawInContext  = 0x00000010,
  CABlockTypeLayoutBlock    = 0x00000100, 
  CABlockTypeLayerAction    = 0x00001000,
  CABlockTypeAniStart       = 0x00010000, 
  CABlockTypeAniComplete    = 0x00100000,
  KVOChangeBlock            = 0x11111111,
);

typedef void(^KVOB)       (id o, NSS *kp, NSD *x);    // KVOChangeBlock         
typedef void(^CABANIS)    (CAL *l, CAA *a);           // CABlockTypeAniStart
typedef void(^CABANIC)    (CAL *l, BOOL f, CAA *ani); // CABlockTypeAniComplete
typedef void(^LayerBlock)    (CAL *l);                   // CABlockTypeDrawBlock
typedef void(^LayerCTXBlock) (CAL *l, CGCREF ctx);       // CABlockTypeDrawInContext
//typedef void(^CABLAYOUT)  (CAL *l);                   // CABlockTypeLayoutBlock
typedef  ACT(^CABACTION)  (CAL *l, NSS *k);           // CABlockTypeLayerAction

#define BDEL BlockDelegate
@class BlockDelegate; @interface NSO (KVOBlockDelegate) 

@property       BDEL * blockDelegate;
@property       KVOB   KVOBlock;

- (void) setKVOBlock:(KVOB)blk;
- (void) addDelegate:(BlockDelegateType)type block:(id)blk;
@end

@interface       CAL (BlockDrawLayer)

@property    CABANIS   aniStartBlock;
@property    LayerBlock   drawBlock, layoutBlock;
@property LayerCTXBlock   drawInContextBlk;
@property  CABACTION   layerActionBlock;

- (void)    setAniStartBlock:(CABANIS)blk;
- (void)        setDrawBlock:(LayerBlock)blk;
- (void) setDrawInContextBlk:(LayerCTXBlock)blk;
- (void)      setLayoutBlock:(LayerBlock)blk;
- (void) setLayerActionBlock:(CABACTION)blk;
+ (CAL*)      layerWithFrame:(NSR)f 
             drawnUsingBlock:(LayerCTXBlock)drawBlock;
@end

//@prop_RO NSString * delegateDescription;

@interface BlockDelegate : NSO
/*	Determines the delegate type, generates an instance, saves itself as property on layer, declares itself as layers delegate, or layoutmanager, etc.  calls setneeds.... blah blah.
	  returns itself, but chances are you wont eve need to reference it again. */
+ (INST) delegateFor:(id)l ofType:(BlockDelegateType)t withBlock:(id)k;
@property            NSMD * pendingAnimations;
@property (CP)       KVOB   KVOChangeBlock;
@property (CP)  CABACTION   CABlockTypeLayerAction;
@property (CP)    LayerBlock   CABlockTypeDrawBlock,CABlockTypeLayoutBlock;
@property (CP) LayerCTXBlock   CABlockTypeDrawInContext;
@property (CP)    CABANIC   CABlockTypeAniComplete;
@property (CP)    CABANIS   CABlockTypeAniStart;
@property (WK)        CAL * layer;
//@property (WK)         id   owner;
@property BlockDelegateType blockTypes;
@end

typedef id (^transformBlock) (id val);

//@interface NSObject (AZBlockFactory)
//@property (readonly) NSString* properties;

//- (void)  bind:(NSString*)b toObject:(id)o withKeyPath:(NSString*)kp transform:(id(^)(id))transformBlock;
//- (BOOL)  overrideSelector:  			 (SEL)selector 						withBlock:    (void*)block;
//- (void*) superForSelector:		 	 (SEL)selector;
//@end


#define CAABCOMPINFO void (^)	(CAAnimationDelegate*delegate) 	// completionWithInfo
#define CAABSTRTINFO void (^)	(CAAnimationDelegate*delegate) 	// startWithInfo
#define CAABCOMP		void (^)	(void)									// completion
#define CAABSTRT		void (^)	(void)									// start

@interface CAAnimationDelegate : NSObject
+ (instancetype) delegate:(CAA*)a forLayer:(CAL*)l;
@property BOOL andSet; 				// defaults to yes
@property (WK) CAA* ani;
@property (WK) CAL* layer;
@property (CP) void (^completionWithInfo)	(CAAnimationDelegate*delegate);
@property (CP) void (^startWithInfo)      (CAAnimationDelegate*delegate);
@property (CP) void (^completion)         (CAL*l,BOOL f, CAA*a);
@property (CP) void (^start)              (CAL*l,CAA*a);
@end
//- (void)animationDidStart:	(CAA*)a;							// CALAyer deleagte methods
//- (void)animationDidStop:	(CAA*)a finished:(BOOL)f;  // CALAyer deleagte methods
//- (void)setCompletion:(void (^)(CAA* a, BOOL finished))completion; // Forces auto-complete of setCompletion: to add the name 'finished' in the block parameter


@interface CAAnimation (BlocksAddition)
@property (weak) CAL * layer;
- (void) setCompletion: (CAABCOMPINFO)comp forLayer:(CAL*)l;
- (void) setCompletion:	(CAABCOMPINFO)complete;
- (void) setStart:		(CAABSTRTINFO)start;
//@property (nonatomic, copy) void (^start)					(void);
@end


@interface NSObject (AddMethodToDelegate)
- (void) addToOrCreateDelegateMethod:(SEL)sel imp:(IMP)imp;
@end

typedef NSTableRowView*(^OutlineViewRowViewForItemBlock)(NSOV * ov,id x);
typedef void(^OutlineViewSelectionDidChangeBlock)(NSOV * ov);

@interface  NSOutlineView  (BlockDelegate) <NSOutlineViewDelegate>

@property (CP) OutlineViewRowViewForItemBlock outlineViewRowViewForItem;
-(void) setOutlineViewRowViewForItem:(OutlineViewRowViewForItemBlock)outlineViewRowViewForItem;

@property (CP) OutlineViewSelectionDidChangeBlock outlineViewSelectionDidChange;
- (void) setOutlineViewSelectionDidChange:(OutlineViewSelectionDidChangeBlock)outlineViewSelectionDidChange;

@end

@interface NSText (LastTyped)
@property (readonly) NSS * lastLetter;
@end

@interface NSTextView (BlockChange) <NSTextViewDelegate>
@property (CP,NATOM) void(^shouldChangeTextInRangeWithReplacement)(NSRNG,NSS*);
-(void) setShouldChangeTextInRangeWithReplacement:(void (^)(NSRange rng, NSString *rplcmnt))shouldChangeTextInRangeWithReplacement;
@property (CP,NATOM) void(^textDidChange)(NSText*);
@end

JREnumDeclare( NSOVBlockDelegate,  NSOVBlockDelegateDisclosureTriangle,
                                      NSOVBlockDelegateGroup,
                                      NSOVBlockDelegateRowViewForItem )

#define OVDIBLK 	NSIMG* 	(^)(id cell, NSTC *tc, id item) // disclosureImage
#define OVTOGA    void		(^)(id item)                    // toggleItemAction
#define OVIGR 		BOOL 		(^)(NSOV*v,id,x)                // isgroupitem
//typedef NSIMG* (^disclosureImageForItem) 		(id cell, NSTC *tc, id item);
//typedef void	(^outlineViewToggleItemAction)(id item);

typedef NSTableRowView*(^RowViewForItem)(NSOutlineView *ov,id x);

@interface NSOV (AtoZBlocks)
@property (CP) RowViewForItem rowViewForItem;
-(void) setRowViewForItem:(NSTableRowView*(^)(NSOutlineView *ov,id x))rowViewForItem;
@end

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



// void (^ kvoObserverBlock ) ( CAL * l,    NSS * k );
//typedef 			 void (^ layoutBlock 	  ) ( CAL * l             );
//typedef IDCAA(^ layerActionBlock ) ( CAL * l,    NSS * k );
//typedef 			 void (^ drawBlock 		  ) ( CAL * l, CGCREF   x );
//typedef         void (^ aniComplete 	  ) ( BOOL  f,    CAA * a );

//#define LayerCTXBlock  void(^)(CAL*l)
//#define CABKVO      void(^)(CAL*l,NSS*k,id val)   // kvoObserverBlock
//#define CABLAYOUT   void(^)(CAL*l)                // layoutBlock
//#define CABACTION    ACT(^)(CAL*l,NSS*k)          // layerActionBlock
//#define LayerBlock     void(^)(CAL*l,CGCREF ctx)     // drawBlock
//#define CABANIC     void(^)(BOOL f,CAA *ani)      // aniComplete
//#define CABANIS     void(^)(CAA *ani)             // aniStart

/*! inspiredby

@note Block to call when animation is started
@property (nonatomic, strong) void(^blockOnAnimationStarted)(void);
@note Block to call when animation is successful
@property (nonatomic, strong) void(^blockOnAnimationSucceeded)(void);
@note Block to call when animation fails
@property (nonatomic, strong) void(^blockOnAnimationFailed)(void);
 * Delegate method called by CAAnimation at start of animation
 * @param theAnimation animation which issued the callback.
- (void)animationDidStart:(CAA*)theAnimation;
//	Delegate method called by CAAnimation at end of animation
 * @param theAnimation animation which issued the callback.
 * @param finished BOOL indicating whether animation succeeded or failed.
- (void)animationDidStop:(CAA*)theAnimation	finished:(BOOL)flag;
*/
