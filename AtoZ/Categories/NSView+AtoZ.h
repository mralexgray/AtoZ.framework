
//  NSView+AtoZ.h
//  AtoZ

#import <objc/objc.h>
#import "AtoZUmbrella.h"
#import "AtoZ.h"
#import "CALayer+AtoZ.h"
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSI, AZViewAnimationType) {
	AZViewAnimationTypeJiggle = 0,
	AZViewAnimationTypeFlipHorizontally,
	AZViewAnimationTypeFlipVeryically
};
extern void AZMoveView				 	( NSV* view, 	CGF dX, CGF dY );
extern void AZResizeView			 	( NSV* view, 	CGF dX, CGF dY );
extern void AZResizeViewMovingSubviews	( NSV* view, 	CGF dXLeft, CGF dXRight, CGF dYTop, CGF dYBottom );
extern NSV* AZResizeWindowAndContent	( NSW* window, 	CGF dXLeft, CGF dXRight, CGF dYTop, CGF dYBottom, BOOL moveSubviews);

@interface NSView (ObjectRep)
@property (nonatomic, retain) id objectRep;
- (NSV*)viewWithObjectRep:(id)object;
@end

typedef void (^viewFrameDidChangeBlock)(void);

@interface NSView (AtoZ)

@property (RONLY) CGF maxDim, minDim;

- (NSV*) autosizeable;
// setup 3d transform
- (void) setZDistance: (NSUI) zDistance;

- (CGP) layerPoint: (NSE*)event;
- (CGP) layerPoint: (NSE*)event toLayer: (CAL*)layer;

- (void) observeFrameChangeUsingBlock: (void(^)(void))block;

- (void) replaceSubviewWithRandomTransition: (NSV*)oldView with: (NSV*)newView;

- (BOOL) isSubviewOfView: (NSV*) theView;
- (BOOL) containsSubView: (NSV*) subview;

- (NSP)  getCenterOnFrame;
- (NSP)  getCenter;
- (void) setCenter: (NSP)center;

- (void) maximize;
- (NSR)  centerRect: (NSR)aRect onPoint:(NSP) aPoint;
- (void) centerOriginInBounds;
- (void) centerOriginInFrame;
- (void) centerOriginInRect: (NSR)aRect;

- (CAL*) setupHostView;
- (CALayerNoHit*) setupHostViewNoHit;
- (CAL*) setupHostViewNamed:(NSS*)name;


- (NSA*) allSubviews;
- (NSV*) firstSubview;
- (NSV*) lastSubview;
- (void) removeAllSubviews;
- (void) setLastSubview:(NSV*)view;

- (NSIMG*) snapshot;
- (NSIMG*) snapshotFromRect:(NSR) sourceRect;
- (BOOL)  requestFocus;
- (NSTA*) trackFullView;
- (NSTA*) trackAreaWithRect:(NSR)rect;
- (NSTA*) trackAreaWithRect:(NSR)rect  userInfo:(NSD*)context;

// - (NSPoint) centerOfFrame;
// @property (assign) NSPoint center;
//- (NSImage*) captureFrame;

- (NSP) center;

- (void) swapSubs: (NSV*)view;
- (void) resizeFrameBy: (int)value;

- (void) animate: (AZViewAnimationType)type;
- (void) stopAnimating;
- (void) slideUp;
- (void) slideDown;
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

- (void) handleMouseEvent:(NSEventMask)event withBlock:(void (^)())block;
- (NSP) localPoint;
- (NSP) windowPoint;

@end

@interface NSView (Layout)

// Origin X
@property (nonatomic, assign) CGF leftEdge;
@property (nonatomic, assign) CGF rightEdge;
@property (nonatomic, assign) CGF centerX;
- (void) setLeftEdge:(CGF)t;
- (void) setRightEdge:(CGF)t ;
- (void) setCenterX:(CGF)t ;

// Origin Y
@property (nonatomic, assign) CGF bottom;
@property (nonatomic, assign) CGF top;
@property (nonatomic, assign) CGF centerY;
- (void) setBottom:(CGF)t ;
- (void) setTop:(CGF)t ;
- (void) setCenterY:(CGF)t ;
- (void) setBottom:(CGF)t duration:(NSTI)t ;
- (void) setTop:(CGF)t duration:(NSTI)t;
- (void) setCenterY:(CGF)t duration:(NSTI)t ;

// Size
@property (nonatomic, assign) CGF width;
@property (nonatomic, assign) CGF height;
@property (nonatomic, assign) NSSZ size;

- (void) setWidth:  (CGF) t;
- (void) setHeight: (CGF) t;
- (void) setSize:   (NSSZ) size;

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

- (void)sizeHeightToFitAllowShrinking:(BOOL)allowShrinking ;

/*!	@brief	Compares the left edge of the receiver with the left edge of a other view.
 	@param	otherView
 	@result   NSOrderedAscending if the other view's left edge is	to the right of the receiver, etc.	*/

- (NSComparisonResult)compareLeftEdges:(NSV*)otherView ;

/*!	@brief	Based on the "lowest" subview among the receiver's subview,
 	i.e. the one with the smallest frame.origin.y, sizes the receiver to fit it.
 	@details  This method takes a completely different approach than the others in this class.
	Indeed, it was written years later (201105).	*/

- (void)sizeHeightToFit ;

@end

@interface NSScrollView (Notifications)
- (void) performBlockOnScroll:(void (^)(void))block;
@end

@interface NSTableView (Scrolling)
- (void)scrollRowToTop:(NSI)row ;
@end


@interface NSView (findSubview)

- (NSA*) subviewsOfKind: (Class)kind  withTag:(NSI)tag;
- (NSA*) subviewsOfKind: (Class)kind;

- (NSV*)firstSubviewOfKind: (Class)kind  withTag:(NSI)tag;
- (NSV*)firstSubviewOfKind: (Class)kind;

@end


typedef void (^NSAnimationContextRunAnimationBlock)( dispatch_block_t group, dispatch_block_t completionHandler, NSTimeInterval time );


@interface NSAnimationContext (AtoZ)

+ (void)runAnimationBlock:(dispatch_block_t)group	completionHandler:(dispatch_block_t)completionHandler
				 duration:(NSTimeInterval)time		eased:(CAMediaTimingFunction*)timing;

+ (void)runAnimationBlock:(dispatch_block_t)group	completionHandler:(dispatch_block_t)completionHandler
				 duration:(NSTimeInterval)time;

@end