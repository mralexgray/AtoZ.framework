
#define CRNR OSCornerType

JREnumDeclare(NSWindowResize, NSWindowResizeTopLeftCorner     = 1,
                              NSWindowResizeTopRightCorner    = 2,
                              NSWindowResizeBottomRightCorner = 3,
                              NSWindowResizeBottomLeftCorner  = 4);



@interface NSAnimationContext (Blocks)

+ (void) groupWithDuration:(NSTI)d
    timingFunctionWithName:(NSS*)tF
         completionHandler:(VBlk)blk
            animationBlock:(VBlk)aniB;

+ (void) groupWithDuration:(NSTI)d
         completionHandler:(VBlk)cH
            animationBlock:(VBlk)ani;

+ (void)groupWithDuration:(NSTI)d
           animationBlock:(VBlk)an;
@end

@interface NSResponder (AtoZ)
- (void)        overrideResponder:(SEL)sel
                         withBool:(BOOL)accepts;
- (void) setAcceptsFirstResponder:(BOOL)a;
- (void)  setPerformKeyEquivalent:(BOOL)p;


/*! [win animateWithDuration:2 block:^(id w){ 
      [w setFrame:AZScreenFrameUnderMenu()]; 
    }]
*/
- (void) animateWithDuration:(NSTI)d block:(ObjBlk)stuff;
@end


@interface NSWindow (SBSWindowAdditions)
+ (void) setLiveFrameTracking:(BOOL) bol;
+ (BOOL) isLiveFrameTracking;
@end

@interface NSWindow (Resize)
- (void) resizeToWidth:(CGF)w height:(CGF)h;
- (void) resizeToWidth:(CGF)w height:(CGF)h origin:(NSWindowResize)theOrigin;
- (void) resizeToWidth:(CGF)w height:(CGF)h origin:(NSWindowResize)theOrigin duration:(NSTI)dur;
@end

@interface NSWindow		(AtoZ)  <RectLike> 

- (void) activate;

+ (INST) withFrame:(NSR)r mask:(NSUI)m;
#pragma mark - THE MISSING ACCESSORS

@prop_NA NSA * childWindows;
@prop_RO NSV * frameView;
@prop_   NSV * view;
@prop_RO CAL * windowLayer,
             * contentLayer;
@prop_RO CGR   contentRect;
@prop_RO CGF   heightOfTitleBar, toolbarHeight;

- (void) toggleVisibility;

- (void) overrideCanBecomeMainWindow:(BOOL)canBecomeMain;
- (void)  overrideCanBecomeKeyWindow:(BOOL)canBecomeKey;
- (void)               setIgnoresEventsButAcceptsMoved;

#pragma mark - FACTORIES

+ (INST) windowWithFrame:(NSR)r view:(NSView*)v mask:(NSUI)m;
+ (INST) windowWithFrame:(NSR)r mask:(NSUI)m;

+ (NSW*) borderlessWindowWithContentRect:(NSR)aRect;
+   (id) hitTest:			(NSE*) event;
+   (id) hitTestPoint:(NSP)location;
+ (NSA*) appWindows;

- (NSA*) windowAndChildren;
+ (NSA*) allWindows;

+ desktopWindow;

@prop_RO CAL* veilLayer;
- (CAL*) veilLayerForView:(NSV*)view;

- (void) addViewToTitleBar:	(NSV*)viewToAdd atXPosition:(CGFloat)x;

- (void) setContentSize:		(NSSZ)z display:(BOOL)f animate:(BOOL)a;
- (void) betterCenter;
- (void) fadeIn;
- (void) fadeOut;
- (void) slideUp;
- (void) slideDown;
- (void) extendVerticallyBy: (CGF) amount;
- (void) animateInsetTo:(CGF)f anchored:(AZA)edge;
- (void) delegateBlock: (void(^)(NSNOT*))block;

@end

//@property (readonly, nonatomic) BOOL isBorderless;
//-  (NSP) midpoint; //get the midpoint of the window
//- (void) setMidpoint:		(NSPoint) midpoint; //set the midpoint of the window
/* - (void) fadeInYesOrOutNo: (BOOL)fade andResizeTo: (NSRect)frame;	*/
//- (void) setDefaultFirstResponder;

#define kNTSetDefaultFirstResponderNotification @"NTSetDefaultFirstResponderNotification"  // object is the window, must check


#define NSBorderlessWindowMaskSet(bitMask) (bitMask == 0)  // NSBorderlessWindowMask == 0
#define NSTexturedBackgroundWindowMaskSet(bitMask) ((bitMask & NSTexturedBackgroundWindowMask) != 0)

@interface  NSWindow (UKFade)

-(void)       fadeInOneStep:(NSTimer*)timer;
-(void)      fadeOutOneStep:(NSTimer*)timer;
-(void)  fadeInWithDuration:(NSTimeInterval)duration;
-(void) fadeOutWithDuration:(NSTimeInterval)duration;
-(void)	        fadeToLevel:(int)lev
               withDuration:(NSTimeInterval)duration;
@end

@interface NSWindow (SDResizableWindow)

- (void) setContentViewSize:(NSSize)x
                    display:(BOOL)d
                    animate:(BOOL)a;

-  (NSR) windowFrameForNewContentViewSize:(NSSize)newSize;

@end

/*@interface NSWindow (Utilities)
- (void) eil:(NSView*)view;
+ (void) cascadeWindow:(NSWindow*)inWindow;
+ (NSA*) visibleWindows:(BOOL)ordered;
+ (NSA*)visibleWindows:(BOOL)ordered delegateClass:(Class)delegateClass;
- (NSWindow*)topWindowWithDelegateClass:(Class)klass;
+ (BOOL)isAnyWindowVisibleWithDelegateClass:(Class)klass;

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

 (NSRect) setContentViewAndResizeWindow: (NSView*)view 		display:(BOOL)display;
- (NSRect) resizeWindowToContentSize: (NSSize)contentSize 	display:(BOOL)display;
- (NSRect) windowFrameForContentSize: (NSSize)contentSize;
+ (BOOL) windowRectIsOnScreen: (NSRect)windowRect;
@end

@interface NSWindow (UndocumentedRoutines)
- (void) setBottomCornerRounded:(BOOL)set;
- (BOOL)bottomCornerRounded;
@end
*/
/*
 Provides a "zoom" animation for windows when ordering on and off screen.
 For more details, check out the related blog posts at http://www.noodlesoft.com/blog/2007/06/30/animation-in-the-time-of-tiger-part-1/ and http://www.noodlesoft.com/blog/2007/09/20/animation-in-the-time-of-tiger-part-3/	*/
/*
@interface NSWindow (NoodleEffects)

- (void) animateToFrame: (NSRect) frameRect duration:(NSTimeInterval)duration;
- (void) zoomOnFromRect: (NSRect) startRect;
- (void) zoomOffToRect:  (NSRect) endRect;

@end
//- (void) setFrame:(NSR)frame;
//@prop_RO NSR   bounds;
//@prop_RO CGF   originX, originY;
// Size
//@property (nonatomic) CGF width;
//@property (nonatomic) CGF height;
//@property (nonatomic) NSSZ frameSize;

//- (void) setWidth: (CGF) t;
//- (void) setHeight: (CGF) t;
//- (void) setFrameSize: (NSSZ) size;

*/

@interface NSWindow (Transforms)

- (NSPoint) windowToScreenCoordinates:(NSPoint)point;
- (NSPoint) screenToWindowCoordinates:(NSPoint)point;

- (void) rotate:(double)radians;
- (void) rotate:(double)radians about:(NSPoint)point;

- (void) scaleBy:(double)scaleFactor;
- (void) scaleX:(double)x Y:(double)y;
- (void) setScaleX:(double)x Y:(double)y;
- (void) scaleX:(double)x Y:(double)y about:(NSPoint)point concat:(BOOL)concat;

- (void) reset;

- (void) setSticky:(BOOL)flag;
@end
