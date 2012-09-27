
//  NSView+AtoZ.h
//  AtoZ

//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Cocoa/Cocoa.h>
#import <objc/objc.h>

typedef enum
{
	AZViewAnimationTypeJiggle = 0,
	AZViewAnimationTypeFlipHorizontally,
	AZViewAnimationTypeFlipVeryically
}
AZViewAnimationType;


extern void AZMoveView(NSView* view, float dX, float dY);
extern void AZResizeView(NSView* view, float dX, float dY);
extern void AZResizeViewMovingSubviews(NSView* view, float dXLeft, float dXRight, float dYTop, float dYBottom);
extern NSView* AZResizeWindowAndContent(NSWindow* window, float dXLeft, float dXRight, float dYTop, float dYBottom, BOOL moveSubviews);


@interface NSView (ObjectRep)

@property (nonatomic, retain) id objectRep;

- (NSView *)viewWithObjectRep:(id)object;

@end

@interface NSView (AtoZ)

- (NSRect) centerRect:(NSRect) aRect onPoint:(NSPoint) aPoint;
- (void) centerOriginInBounds;
- (void) centerOriginInFrame;
- (void) centerOriginInRect:(NSRect) aRect;

- (CALayer*) setupHostView;

- (NSArray*) allSubviews;
- (NSView*)	 firstSubview;
- (NSView*)	 lastSubview;
- (void)	 removeAllSubviews;
- (void)	 setLastSubview:(NSView *)view;

- (NSImage*) snapshot;
- (NSImage*) snapshotFromRect:(NSRect) sourceRect;
- (NSImage*) captureFrame;
- (BOOL)	 requestFocus;


-(NSTrackingArea *)trackFullView;
-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect;
-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect 
                            userInfo:(NSDictionary *)context;

// - (NSPoint) centerOfFrame;
// @property (assign) NSPoint center;

- (NSPoint) center;

- (void) resizeFrameBy:(int)value;

- (void) animate:(AZViewAnimationType)type;
- (void) stopAnimating;
- (void) slideUp;
- (void) slideDown;
- (void) fadeOut;
- (void) fadeIn;
- (void) animateToFrame:(NSRect) rect;
- (void) fadeToFrame: 	(NSRect) rect; // animates to supplied frame;fades in if view is hidden; fades out if view is visible

+ (void)setDefaultDuration:(NSTimeInterval)duration;
+ (void)setDefaultBlockingMode:(NSAnimationBlockingMode)mode;
+ (void)setDefaultAnimationCurve:(NSAnimationCurve)curve;

+ (void)animateWithDuration:(NSTimeInterval)duration 
                  animation:(void (^)(void))animationBlock;
+ (void)animateWithDuration:(NSTimeInterval)duration 
                  animation:(void (^)(void))animationBlock
                 completion:(void (^)(void))completionBlock;

+ (void)runEndBlock:(void (^)(void))completionBlock;

- (void) handleMouseEvent:(NSEventMask)event withBlock:(void (^)())block;
- (NSPoint) localPoint;
@end



@interface NSView (Layout)

// Origin X
@property (nonatomic, assign) float leftEdge;
@property (nonatomic, assign) float rightEdge;
@property (nonatomic, assign) float centerX;
//- (void) setLeftEdge:(float)t ;
//- (void) setRightEdge:(float)t ;
//- (void) setCenterX:(float)t ;

// Origin Y
@property (nonatomic, assign) float bottom;
@property (nonatomic, assign) float top;
@property (nonatomic, assign) float centerY;
//- (void) setBottom:(float)t ;
//- (void) setTop:(float)t ;
//- (void) setCenterY:(float)t ;

// Size
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;
//- (void) setWidth: (float) t;
//- (void) setHeight: (float) t;
- (void) setSize: (NSSize) size;

// Incrememental Changes
- (void)deltaX:(float)dX
		deltaW:(float)dW ;
- (void)deltaY:(float)dY
		deltaH:(float)dH ;
- (void)deltaX:(float)dX ;
- (void)deltaY:(float)dY ;
- (void)deltaW:(float)dW ;
- (void)deltaH:(float)dH ;


/*!
 @brief    Resizes the height of the receiver to fit its current content.

 @details  The default implementation works properly if the receiver is
 an NSTextField or NSTextView.&nbsp; For any other subclass, all it does
 is clip if the height is not taller than the screen, so subclasses
 may invoke super to get this function.&nbsp; Otherwise, it's a no-op, which
 is appropriate for subclasses that have a constant height,
 independent of their content, for example NSButton or NSPopUpButton.&nbsp;
 Todo: I should move the NSTextField and NSTextView code from
 this method into subclass methods, as I have done with NSTableView
 in SSLabelledList.m

 @param    allowShrinking  If YES, the method always resizes the
 receiver's height to fit the current content.&nbsp; If NO, and if the
 height required by the receiver's current content is smaller than
 the receiver's current height, the receiver's height is not resized.&nbsp;
 This is used to avoid a changing height which could be annoying in many
 circumstances.
 */
- (void)sizeHeightToFitAllowShrinking:(BOOL)allowShrinking ;

/*!
 @brief    Compares the left edge of the receiver with the left
 edge of a other view.

 @param    otherView
 @result   NSOrderedAscending if the other view's left edge is
 to the right of the receiver, etc.
 */
- (NSComparisonResult)compareLeftEdges:(NSView*)otherView ;

/*!
 @brief    Based on the "lowest" subview among the receiver's subview,
 i.e. the one with the smallest frame.origin.y, sizes the receiver
 to fit it.

 @details  This method takes a completely different approach than the
 others in this class.  Indeed, it was written years later (201105).
 */
- (void)sizeHeightToFit ;


@end


@interface NSView (findSubview)

- (NSArray *)subviewsOfKind:(Class)kind withTag:(NSInteger)tag;
- (NSArray *)subviewsOfKind:(Class)kind;

- (NSView *)firstSubviewOfKind:(Class)kind withTag:(NSInteger)tag;
- (NSView *)firstSubviewOfKind:(Class)kind;

@end
