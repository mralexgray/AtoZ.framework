
#import <objc/objc.h>
#import <QuartzCore/QuartzCore.h>

@interface NSViewFlipped : NSView @end

@interface NSView (IsFlipped)
- (void) setIsFlipped:(BOOL)f;
- (void)  setIsOpaque:(BOOL)f;
@end


@interface NSView (MoveAndResize)
- _Void_ setNewFrameFromMouseDrag:(NSRect)newFrame;
- _Void_ trackMouseDragsForEvent:(NSEvent *)theEvent clickType:(int)clickType;

/*  USAGE  

 // just set of xample layers...

	CAL *ll; [win.layer addSublayer:ll=[CAL layerWithFrame:AZRandomRectInRect(win.bounds)]];
	ll.bgC = cgRANDOMCOLOR;
	ll.needsDisplayOnBoundsChange = YES;
	ll.arMASK = RAND_INT_VAL(0,8);
	BlockDelegate delegateFor:ll ofType:CABlockTypeDrawBlock withBlock:^(CAL*lll, CGCREF ref){
		[NSGC drawInContext:ref flipped:NO actions:^{
			R r = AZCenterRectOnPoint(AZRectFromDim(20),ll.position);
			NSRectFillWithColor (r, WHITE);
			AZString(ll.frame) drawAtPoint:AZPointOffsetX(AZCenter(ll.bounds), -100) withAttributes:NSAS.defaults];
		}];
	}];

//  DRAG EXAMPLE				  CAL *superL 	= win.layer;
							__block CAL *hitL 	= nil;
							__block NSP refP;

	[win.contentView dragBlock:^(NSP clk,NSP move){
		if (!hitL) {	hitL = [superL hitTest:clk];	refP = hitL.position;	} // look for hits, save position
 		if  (hitL)	[CATRANNY immediately:^{	hitL.position = AZSubtractPoints(refP,move);	[hitL setNeedsDisplay];	}];} 
	mouseUp:^{	hitL = nil;}];  // clear the hitlayer in between drags, or do whatever
*/
- (void) dragBlock:(void(^)(NSP click,NSP delta, NSMD * context))block mouseUp:(void(^)(void))upBlock;
@end

typedef NS_ENUM(NSI, AZViewAnimationType) {
	AZViewAnimationTypeJiggle = 0,
	AZViewAnimationTypeFlipHorizontally,
	AZViewAnimationTypeFlipVeryically
};
extern void AZMoveView				 	( NSV* view, 	CGF dX, CGF dY );
extern void AZResizeView			 	( NSV* view, 	CGF dX, CGF dY );
extern void AZResizeViewMovingSubviews	( NSV* view, 	CGF dXLeft, CGF dXRight, CGF dYTop, CGF dYBottom );
extern NSV* AZResizeWindowAndContent	( NSW* window, 	CGF dXLeft, CGF dXRight, CGF dYTop, CGF dYBottom, BOOL moveSubviews);

typedef void (^viewFrameDidChangeBlock)(void);

#define NSViewDidMoveToWindowNotification @"NSViewDidMoveToWindowNotification"

@class AZWT;
@interface NSView  (AtoZ) <NSCopying>

@property (NA) ObjBlk onEndLiveResize;
@property (getter = isOpaque) BOOL opaque;  // overrides isOpaque method..

@property (NA) NSI tag;
@prop_RO NSIMG* captureFrame;
@property (NA) BOOL faded;
@prop_RO NSA* visibleSubviews;
@prop_RO CGF heightOfSubviews, widthOfSubviews, heightOfVisibleSubviews, widthOfVisibleSubviews;

+ (instancetype) viewBy:(NSN*)width,...;
+ (instancetype) viewWithFrame:(NSR)r;
+ (instancetype) viewWithFrame:(NSR)r mask:(NSUI)m;

@property NSA* needsDisplayForKeys;

@property // (getter=getBackground, setter=doSetBackground:)
  id background;

- (NSV*) dragSubviewWihEvent:(NSE*)e;
- (void) handleDragForTypes:(NSA*)files withHandler:(void (^)(NSURL *URL))handler;


- (void) debug;
- (void) debuginQuadrant:(AZQuad)q;

- (void) goFullScreen;
- (AZWT*) preview;
+ (AZWT*) preview; //	returns new window
+ (AZWT*) previewOfClass:(Class)klass;

-(CALayer *)layerFromContents;

@prop_RO NSBP *path;
@prop_RO CGF maxDim, minDim;

- (NSV*) autosizeable;
// setup 3d transform
- (void) setZDistance: (NSUI) zDistance;

- (CGP) layerPoint: (NSE*)event;
- (CGP) layerPoint: (NSE*)event toLayer: (CAL*)layer;

@property (NA) BOOL postsRectChangedNotifications;

- (void) observeFrameChange: (void(^)(NSV*))block;
- (void) observeFrameChangeUsingBlock: (void(^)(void))block;
- (void) observeFrameNotifications:(void(^)(NSNOT*n))block;

- (void) replaceSubviewWithRandomTransition: (NSV*)oldView with: (NSV*)newView;

- _IsIt_ isSubviewOfView: (NSV*) theView;
- _IsIt_ containsSubView: (NSV*) subview;

//- (NSP)  getCenterOnFrame;
//@property NSP center;

//- (void) maximize;
//- (NSR)  centerRect: (NSR)aRect onPoint:(NSP) aPoint;
//- (void) centerOriginInBounds;
//- (void) centerOriginInFrame;
//- (void) centerOriginInRect: (NSR)aRect;

- _Layr_ setupHostView;

_RO _Layr azLayer,
          zLayer,
          setupHostViewNoHit,
          guaranteedLayer;

- _Layr_ setupHostViewNamed:_Text_ name;

@prop_RO NSA * allSubviews, *subviewsRecursive;
@property id firstSubview;
@prop_RO id  lastSubview,  lastSplitPane, lastLastSubview;
- (void) removeAllSubviews;

@prop_RO NSIMG* snapshot;
- (NSIMG*) snapshotFromRect:(NSR) sourceRect;
- _IsIt_  requestFocus;
- (NSTA*) trackFullView;
- (NSTA*) trackAreaWithRect:(NSR)rect;
- (NSTA*) trackAreaWithRect:(NSR)rect  userInfo:(NSD*)context;

// - (NSPoint) centerOfFrame;
// @property (assign) NSPoint center;
//- (NSImage*) captureFrame;

- (void) swapSubs: (NSV*)view;
- (void) resizeFrameBy: (int)value;

- (void) animate: (AZViewAnimationType)type;
- (void) stopAnimating;
- (void) slideUp;
//- (void) slideDown;
- (void) fadeOut;
- (void) fadeIn;
- (void) animateToFrame:(NSR) rect;
- (void) fadeToFrame: 	(NSR) rect; // animates to supplied frame;fades in if view is hidden; fades out if view is visible

+ (void)setDefaultDuration: (NSTI)duration;
+ (void)setDefaultBlockingMode: (NSAnimationBlockingMode)mode;
+ (void)setDefaultAnimationCurve: (NSAnimationCurve)curve;

+ (void) animateWithDuration: (NSTI)duration  animation:(void (^)(void))animationBlock;
+ (void) animateWithDuration: (NSTI)duration  animation:(void (^)(void))animationBlock
				 							 completion:(void (^)(void))completionBlock;

+ (void) runEndBlock: (void (^)(void))completionBlock;

- (void) fadeOutAndThen:(void(^)(NSAnimation*))block;


- (void) handleMouseEvent:(NSEventType)event withBlock:(void (^)())block;
- (NSP) localPoint;
- (NSP) windowPoint;

@prop_RO CAL* hitTestLayer;

@end

@interface NSView (Layout)

- (void) setBottom:(CGF)bot duration:(NSTI)t ;
- (void) setTop:(CGF)top duration:(NSTI)t;
- (void) setCenterY:(CGF)center duration:(NSTI)t ;

// Incrememental Changes
- (void) deltaX: (CGF)dX  deltaW: (CGF)dW ;
- (void) deltaY: (CGF)dY  deltaH: (CGF)dH ;
- (void) deltaX: (CGF)dX;
- (void) deltaY: (CGF)dY;
- (void) deltaW: (CGF)dW;
- (void) deltaH: (CGF)dH;

/*!	@brief	Resizes the height of the receiver to fit its current content.
 	@details  The default implementation works properly if the receiver is an NSTextField or NSTextView.
	For any other subclass, all it does is clip if the height is not taller than the screen, so subclasses
 	may invoke super to get this function.&nbsp; Otherwise, it's a no-op, which is appropriate for subclasses that have a constant height,
 	independent of their content, for example NSButton or NSPopUpButton.
  	Todo: I should move the NSTextField and NSTextView code from this method into subclass methods, as I have done with NSTableView	in SSLabelledList.m

 	@param	allowShrinking  If YES, the method always resizes the receiver's height to fit the current content.
	If NO, and if the height required by the receiver's current content is smaller than the receiver's current height, the receiver's height is not resized.&nbsp;
	This is used to avoid a changing height which could be annoying in many circumstances. */

- _Void_ sizeHeightToFitAllowShrinking:(BOOL)allowShrinking ;

/*!	@brief	Compares the left edge of the receiver with the left edge of a other view.
 	@param	otherView
 	@result   NSOrderedAscending if the other view's left edge is	to the right of the receiver, etc.	*/

- (NSComparisonResult)compareLeftEdges:(NSV*)otherView ;

/*!	@brief	Based on the "lowest" subview among the receiver's subview,
 	i.e. the one with the smallest frame.origin.y, sizes the receiver to fit it.
 	@details  This method takes a completely different approach than the others in this class.
	Indeed, it was written years later (201105).	*/

- _Void_ sizeHeightToFit ;

@end

@interface NSScrollView (Notifications)
- (void) performBlockOnScroll:(void (^)(void))block;

/*! @brief Set if the scrollView should scroll to the bottom when new content is added
 * If YES, the scrollView will scroll to the bottom when new content is added (i.e. when the frame of the document view increases), bringing the new data into visibility. Automatic scrolling will only occur if the view was scrolled to the bottom previously; it will not force a scroll to the bottom if the user has scrolled up in the scrollView. The default value is NO.
 * @param inValue YES if the scrollView should automatically scroll as described above.
 */
@property (assign,nonatomic) BOOL autoScrollToBottom;
/*!* @brief Scroll to the top of the documentView.
 *croll to the top of the documentView.*/
- _Void_ scrollToTop;
/*! @brief Scroll to the bottom of the documentView.Scroll to the bottom of the documentView. */
- _Void_ scrollToBottom;

@end

@interface NSTableView (Scrolling)
- _Void_ scrollRowToTop:(NSI)row ;
@end


@interface NSView (findSubview)

- (NSA*) subviewsOfKind: (Class)k withTag:(NSI)tag;
- (NSA*) subviewsOfKind: (Class)k;

-   (id) firstSubviewOfClass:(Class)k;
- (NSA*)     subviewsOfClass:(Class)k;

-   (id) firstSubviewOfKind:(Class)k withTag:(NSI)tag;
-   (id) firstSubviewOfKind:(Class)k;

@end


typedef void (^NSAnimationContextRunAnimationBlock)( dispatch_block_t group, dispatch_block_t completionHandler, NSTimeInterval time );


@interface NSAnimationContext (AtoZ)

+ (void)runAnimationBlock:(dispatch_block_t)group	completionHandler:(dispatch_block_t)completionHandler
				 duration:(NSTimeInterval)time		eased:(CAMediaTimingFunction*)timing;

+ (void)runAnimationBlock:(dispatch_block_t)group	completionHandler:(dispatch_block_t)completionHandler
				 duration:(NSTimeInterval)time;


@end


@interface NSPopover (Message)

+ (void) showRelativeToRect:(NSRect)rect
					 ofView:(NSView *)view
			  preferredEdge:(NSRectEdge)edge
					 string:(NSS*)string
				   maxWidth:(float)width;

+ (void) showRelativeToRect:(NSRect)rect
					 ofView:(NSView *)view
			  preferredEdge:(NSRectEdge)edge
					 string:(NSS*)string
			backgroundColor:(NSColor *)backgroundColor
				   maxWidth:(float)width;

+ (void) showRelativeToRect:(NSRect)rect
					 ofView:(NSView *)view
			  preferredEdge:(NSRectEdge)edge
					 string:(NSS*)string
			backgroundColor:(NSColor *)backgroundColor
			foregroundColor:(NSColor *)foregroundColor
					   font:(NSFont *)font
				   maxWidth:(float)width;

+ (void) showRelativeToRect:(NSRect)rect
					 ofView:(NSView *)view
			  preferredEdge:(NSRectEdge)edge
		   attributedString:(NSAttributedString *)attributedString
			backgroundColor:(NSColor *)backgroundColor
				   maxWidth:(float)width;
@end

#import <Rebel/RBLPopover.h>

@interface RBLPopover (AtoZ)

+ (void) showRelativeTo:(NSR)r ofView:(NSV*)v edge:(NSRectEdge)edge string:(NSS*)s bg:(NSC*)bg size:(NSSZ)sz;

@end
