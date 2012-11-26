
#import "AtoZ.h"

#define WINCOLS NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorStationary
//I just came up with an even better way to do completion code for CAAnimations:
typedef void (^animationCompletionBlock)(void);
// key to add a block to an animation:
#define kAnimationCompletionBlock @"animationCompletionBlock"
@protocol AZSemiResponder;
@class  AZDynamicTabLayer;
@interface AZSemiResponderWindow : NSWindow

@property (NATOM, STRNG) AZDynamicTabLayer 	*tabs;
@property (NATOM, STRNG) CAL 				*content,
											*root;
@property (ASS,	  NATOM) NSR  inactiveRect;
@property (ASS,	  NATOM) NSP  scrollPoint, 	dragStart, 	dragDiff;
@property (ASS,   NATOM) BOOL dragging, 	noHit;
@property (ASS,   NATOM) NSI  unitOffset;
@property (ASS,   NATOM) CGF  unit;

@property (weak) id <AZSemiResponder> 		semiResponder;
@property (weak) AZLayer					*hit;
@end

@protocol  AZSemiResponder
@optional
-(void) logString:(NSS*)s;
-(void) windowEvent:(NSEvent*)event;
@end

@interface AZDynamicTabLayer : CAL <AZSemiResponder>

@property (STRNG, NATOM) NSA 					*palette;
@property (STRNG, NATOM) OrderedDictionary 		*tabs;
@property (STRNG, NATOM) AZSizer 				*sizer;
@property (ASS,   NATOM) RNG 					 range;
@property (ASS,   NATOM) AZOrient				 orient;
@property (ASS,   NATOM) CGF						 offset;
@property (STRNG, NATOM) NSBP 					*scrollPath;

+ (id<CAAction>)defaultActionForKey:(NSS*)event;

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
