
#import "AZLayer.h"

#define WINCOLS NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary
//I just came up with an even better way to do completion code for CAAnimations:
typedef void (^animationCompletionBlock)(void);
// key to add a block to an animation:
#define kAnimationCompletionBlock @"animationCompletionBlock"
@protocol AZSemiResponder;
@class  AZDynamicTabLayer, AZSizer;
@interface AZSemiResponderWindow : NSW

_NA AZDynamicTabLayer 	*tabs;
_NA CAL 				*content,
											*root;
_NA NSR  inactiveRect;
_NA NSP  scrollPoint, 	dragStart, 	dragDiff;
_NA BOOL dragging, 	noHit;
_NA NSI  unitOffset;
_NA CGF  unit;

@property (weak) id <AZSemiResponder> 	semiResponder;
@property (weak)              AZLayer * hit;
@end

@protocol  AZSemiResponder @optional
-(void)   logString:(NSS*)s;
-(void) windowEvent:(NSEvent*)event;
@end

@interface AZDynamicTabLayer : CAL <AZSemiResponder>

_NA     NSA 					*palette;
_NA id /* NSOrderedDictionary*/ 	tabs;
_NA  AZSizer 				*sizer;
// @property (ASS,   NA) AZRange 					 range;
_NA AZOrient				 orient;
_NA      CGF						 offset;
_NA     NSBP 					*scrollPath;

//+ (id<CAAction>)defaultActionForKey:(NSS*)event;

@end

//@property (NA, STR) BLKVIEW *contentBlock;
//@property (NA, ASS) NSR perfectRect;
//@property (STR, NA) AZSemiResponderWindow  *window;

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
