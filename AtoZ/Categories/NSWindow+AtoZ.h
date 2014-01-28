
#import "AtoZUmbrella.h"
#import "AtoZCategories.h"
#import "NSArray+AtoZ.h"
#import "JREnum.h"
	
#define CRNR OSCornerType


@interface NSAnimationContext (Blocks)
+ (void)groupWithDuration:(NSTimeInterval)duration
   timingFunctionWithName:(NSString *)timingFunction
        completionHandler:(void (^)(void))completionHandler
           animationBlock:(void (^)(void))animationBlock;

+ (void)groupWithDuration:(NSTimeInterval)duration
        completionHandler:(void (^)(void))completionHandler
           animationBlock:(void (^)(void))animationBlock;

+ (void)groupWithDuration:(NSTimeInterval)duration
           animationBlock:(void (^)(void))animationBlock;
@end

JREnumDeclare(NSWindowResize, NSWindowResizeTopLeftCorner = 1, NSWindowResizeTopRightCorner = 2, NSWindowResizeBottomRightCorner = 3, NSWindowResizeBottomLeftCorner = 4);

@interface NSWindow (SBSWindowAdditions)

+ (void) setLiveFrameTracking:(BOOL) bol;
+ (BOOL) isLiveFrameTracking;

@end
@interface NSWindow (Resize)

- (void) resizeToWidth:(CGF)theWidth height:(CGF)theHeight;
- (void) resizeToWidth:(CGF)theWidth height:(CGF)theHeight origin:(NSWindowResize)theOrigin;
- (void) resizeToWidth:(CGF)theWidth height:(CGF)theHeight origin:(NSWindowResize)theOrigin duration:(NSTI)theDuration;

@end

/*
 Provides a "zoom" animation for windows when ordering on and off screen.
 For more details, check out the related blog posts at http://www.noodlesoft.com/blog/2007/06/30/animation-in-the-time-of-tiger-part-1/ and http://www.noodlesoft.com/blog/2007/09/20/animation-in-the-time-of-tiger-part-3/	*/
/*
@interface NSWindow (NoodleEffects)

- (void) animateToFrame: (NSRect) frameRect duration:(NSTimeInterval)duration;
- (void) zoomOnFromRect: (NSRect) startRect;
- (void) zoomOffToRect:  (NSRect) endRect;

@end
*/


@interface NSWindow		(AtoZ)
+ (NSW*) borderlessWindowWithContentRect: (NSRect)aRect;
+   (id) hitTest:			(NSE*) event;
+   (id) hitTestPoint:(NSP)location;
+ (NSA*) appWindows;

- (void) setFrame:		(NSR)frame;
@property (readonly) NSR   bounds;
@property						 CAL * layer;
@property (readonly) CGR contentRect;
@property (readonly) CGF originX, originY;
// Size
@property (nonatomic) CGF width;
@property (nonatomic) CGF height;
@property (nonatomic) NSSZ size;

- (void) setWidth: (CGF) t;
- (void) setHeight: (CGF) t;
- (void) setSize: (NSSZ) size;

- (NSA*) windowAndChildren;
+ (NSA*) allWindows;
- (CAL*) veilLayer;
- (CAL*) veilLayerForView: (NSV*)view;

-  (NSP)	midpoint; //get the midpoint of the window
- (void)	setMidpoint:		(NSPoint) midpoint; //set the midpoint of the window
- (void)	addViewToTitleBar:	(NSView*) viewToAdd atXPosition:(CGFloat)x;
-  (CGF)	heightOfTitleBar;
- (void) setContentSize:		(NSSize) aSize display:(BOOL)displayFlag animate:(BOOL)animateFlag;
- (void) betterCenter;

//@property (readonly, nonatomic) BOOL isBorderless;
@property (readonly, nonatomic) CGFloat toolbarHeight;

- (void) fadeIn;
- (void) fadeOut;
/* - (void) fadeInYesOrOutNo: (BOOL)fade andResizeTo: (NSRect)frame;	*/
- (void) slideUp;
- (void) slideDown;
- (void) extendVerticallyBy: (CGF) amount;
//- (void) setDefaultFirstResponder;

- (void) setIgnoresEventsButAcceptsMoved;
- (void) delegateBlock: (void(^)(NSNOT*))block;
@end

#define kNTSetDefaultFirstResponderNotification @"NTSetDefaultFirstResponderNotification"  // object is the window, must check

/*@interface NSWindow (Utilities)
//- (void)veil:(NSView*)view;

+ (void) cascadeWindow:(NSWindow*)inWindow;

+ (NSA*) visibleWindows:(BOOL)ordered;

//+ (NSA*)visibleWindows:(BOOL)ordered delegateClass:(Class)delegateClass;
//- (NSWindow*)topWindowWithDelegateClass:(Class)klass;
//+ (BOOL)isAnyWindowVisibleWithDelegateClass:(Class)klass;

+ (BOOL) isAnyWindowVisible;
+ (NSA*) miniaturizedWindows;

- (void) setFloating:(BOOL)set;
- (BOOL) isFloating;

- (BOOL) isMetallic;
- (BOOL) isBorderless;

// returns parentWindow if an NSDrawerWindow, returns self if not a drawerWindow
- (NSWindow*) parentWindowIfDrawerWindow;

- (BOOL) dimControls;
- (BOOL) dimControlsKey;
- (BOOL) keyWindowIsMenu;

- (void) flushActiveTextFields;

- (NSRect) setContentViewAndResizeWindow: (NSView*)view 		display:(BOOL)display;
- (NSRect) resizeWindowToContentSize: (NSSize)contentSize 	display:(BOOL)display;
- (NSRect) windowFrameForContentSize: (NSSize)contentSize;

+ (BOOL) windowRectIsOnScreen: (NSRect)windowRect;


@end
*/

//@interface NSWindow (UndocumentedRoutines)
//- (void)setBottomCornerRounded:(BOOL)set;
//- (BOOL)bottomCornerRounded;
//@end

#define NSBorderlessWindowMaskSet(bitMask) (bitMask == 0)  // NSBorderlessWindowMask == 0
#define NSTexturedBackgroundWindowMaskSet(bitMask) ((bitMask & NSTexturedBackgroundWindowMask) != 0)

@interface  NSWindow (UKFade)

-(void) fadeInWithDuration: (NSTimeInterval)duration;
-(void) fadeInOneStep: 		(NSTimer*)timer;
-(void) fadeOutWithDuration:(NSTimeInterval)duration;
-(void) fadeOutOneStep: 	(NSTimer*)timer;
-(void)	fadeToLevel: 		(int)lev withDuration: (NSTimeInterval)duration;
@end


@interface DesktopWindow : NSWindow 
@end

@interface NSWindow (SDResizableWindow)
- (void) setContentViewSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate;
-  (NSR) windowFrameForNewContentViewSize:(NSSize)newSize;

@end
