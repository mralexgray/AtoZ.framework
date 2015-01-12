
#import "AtoZUmbrella.h"
#import "AZLayer.h"

#define WINCOLS NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary
//I just came up with an even better way to do completion code for CAAnimations:
typedef void (^animationCompletionBlock)(void);
// key to add a block to an animation:
#define kAnimationCompletionBlock @"animationCompletionBlock"
@protocol AZSemiResponder;
@class  AZDynamicTabLayer, AZSizer;
@interface AZSemiResponderWindow : NSW

@prop_NA AZDynamicTabLayer 	*tabs;
@prop_NA CAL 				*content,
											*root;
@prop_NA NSR  inactiveRect;
@prop_NA NSP  scrollPoint, 	dragStart, 	dragDiff;
@prop_NA BOOL dragging, 	noHit;
@prop_NA NSI  unitOffset;
@prop_NA CGF  unit;

@property (weak) id <AZSemiResponder> 	semiResponder;
@property (weak)              AZLayer * hit;
@end

@protocol  AZSemiResponder @optional
-(void)   logString:(NSS*)s;
-(void) windowEvent:(NSEvent*)event;
@end

@interface AZDynamicTabLayer : CAL <AZSemiResponder>

@prop_NA     NSA 					*palette;
@prop_NA id /* NSOrderedDictionary*/ 	tabs;
@prop_NA  AZSizer 				*sizer;
// @property (ASS,   NATOM) AZRange 					 range;
@prop_NA AZOrient				 orient;
@prop_NA      CGF						 offset;
@prop_NA     NSBP 					*scrollPath;

//+ (id<CAAction>)defaultActionForKey:(NSS*)event;

@end

//@property (NATOM, STRNG) BLKVIEW *contentBlock;
//@property (NATOM, ASS) NSR perfectRect;
//@property (STRNG, NATOM) AZSemiResponderWindow  *window;

//@property (nonatomic,retain) NSMD *spots;
//@property (nonatomic,retain) CAL *scrollLayer;
//@property (nonatomic,retain) NSView *bar, *drawerView;

//@interface  Drawer : NSWindow
//@property (weak) NSView*leverView;
//@property (nonatomic,retain) NSView *bar;
//@property (nonatomic, strong) CAL *root;
//-(void) registerLevers:(NSView*)leverView;
//@end

//typedef void (^animationCompletionBlock)(void);
//typedef void (^eventActionBlock (NSEvent*event));

@interface  NSWindow (BorderlessInit)
-(void) bordlerlessInit;
@end
