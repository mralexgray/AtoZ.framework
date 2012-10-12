
//  GTMNSBezierPath+CGPath.h

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface NSAffineTransform (UKShearing)
-(void)	shearXBy: (CGFloat)xFraction yBy: (CGFloat)yFraction;
@end

typedef enum _OSCornerTypes
{
	OSTopLeftCorner = 1,
	OSBottomLeftCorner = 2,
	OSTopRightCorner = 4,
	OSBottomRightCorner = 8
} OSCornerType;

typedef enum {
	AMTriangleUp = 0,
	AMTriangleDown,
	AMTriangleLeft,
	AMTriangleRight
} AMTriangleOrientation;

@interface NSBezierPath (AtoZ)

+ (NSBezierPath *)bezierPathWithPlateInRect:(NSRect)rect;

- (void)appendBezierPathWithPlateInRect:(NSRect)rect;
- (void)appendBezierPathWithRoundedRect:(NSRect)rect cornerRadius:(float)radius;
+ (NSBezierPath *)bezierPathWithTriangleInRect:(NSRect)aRect orientation:(AMTriangleOrientation)orientation;
- (void)appendBezierPathWithTriangleInRect:(NSRect)aRect orientation:(AMTriangleOrientation)orientation;
- (void) drawWithFill:(NSColor*)fill andStroke:(NSColor*)stroke;
- (void)fillGradientFrom:(NSColor*)inStartColor to:(NSColor*)inEndColor angle:(float)inAngle;

+ (NSBezierPath *)bezierPathWithLeftRoundedRect:(NSRect)rect radius:(CGFloat)radius;
+ (NSBezierPath *)bezierPathWithRightRoundedRect:(NSRect)rect radius:(CGFloat)radius;

- (NSArray *)dashPattern;
- (void)setDashPattern:(NSArray *)newPattern;

- (NSRect)nonEmptyBounds;

- (NSPoint)associatedPointForElementAtIndex:(NSUInteger)anIndex;
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)aRect cornerRadius:(CGFloat)radius;
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)aRect cornerRadius:(CGFloat)radius inCorners:(OSCornerType)corners;
- (CGPathRef)quartzPath;
+ (NSBezierPath *)bezierPathWithCGPath:(CGPathRef)pathRef;
- (CGPathRef)cgPath;
///  Extract a CGPathRef from a NSBezierPath.
//  Args: 
//  Returns:
//    Converted autoreleased CGPathRef. 
//    nil if failure.

- (NSBezierPath *)pathWithStrokeWidth:(CGFloat)strokeWidth;

- (void)applyInnerShadow:(NSShadow *)shadow;
- (void)fillWithInnerShadow:(NSShadow *)shadow;
- (void)drawBlurWithColor:(NSColor *)color radius:(CGFloat)radius;

- (void)strokeInside;
- (void)strokeInsideWithinRect:(NSRect)clipRect;

+ (NSBezierPath*) bezierPathWithCappedBoxInRect: (NSRect)rect;

#pragma mark Rounded rectangles

+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)rect radius:(CGFloat)radius;
+ (NSBezierPath *)bezierPathRoundedRectOfSize:(NSSize)backgroundSize;
+ (NSBezierPath *)bezierPathWithRoundedRect:(NSRect)bounds;
+ (NSBezierPath *)bezierPathWithRoundedTopCorners:(NSRect)rect radius:(CGFloat)radius;
+ (NSBezierPath *)bezierPathWithRoundedBottomCorners:(NSRect)rect radius:(CGFloat)radius;

#pragma mark Arrows

/* default metrics of the arrow (as returned by +bezierPathWithArrow):
 *    ^
 *   / \
 *  /   \
 * /_   _\ ___
 *   | |    | shaft length multiplier:
 *   | |    | 1.0
 *   | |    | equals shaft length:
 *   |_|   _|_0.5
 *
 *   default shaft width: 1/3
 * the bounds of this arrow are { { 0, 0 }, { 1, 1 } }.
 *
 * the other three methods allow you to override either or both of these metrics.
 */
+ (NSBezierPath *)bezierPathWithArrowWithShaftLengthMultiplier:(CGFloat)shaftLengthMulti shaftWidth:(CGFloat)shaftWidth;
+ (NSBezierPath *)bezierPathWithArrowWithShaftLengthMultiplier:(CGFloat)shaftLengthMulti;
+ (NSBezierPath *)bezierPathWithArrowWithShaftWidth:(CGFloat)shaftWidth;
+ (NSBezierPath *)bezierPathWithArrow;

#pragma mark Nifty things

//these three are in-place. they return self, so that you can do e.g. [[NSBezierPath bezierPathWithArrow] flipVertically].
- (NSBezierPath *)flipHorizontally;
- (NSBezierPath *)flipVertically;
- (NSBezierPath *)scaleToSize:(NSSize)newSize;

//these three return an autoreleased copy.
- (NSBezierPath *)bezierPathByFlippingHorizontally;
- (NSBezierPath *)bezierPathByFlippingVertically;
- (NSBezierPath *)bezierPathByScalingToSize:(NSSize)newSize;

@end
/*

 Available at
 http://earthlingsoft.net/code/NSBezierPath+ESPoints/
 More code at
 http://earthlingsoft.net/code/

 You may use this code in your own projects at your own risk.
 Please notify us of problems you discover and be sure to give
 reasonable credit.

 ********************************************************************

 Category on NSBezierPath for drawing anchor and handle control
 points with a single method call:

 -drawPointsAndHandles

 draws the control points of the path and associated handles in green
 and the anchor points in red, which is particularly useful when
 debugging Bézier paths.

 Call it after stroking the path to get the full picture.

 The remaining methods allow finer control of the colour usage and are
 helper methods for doing the drawing.
 */
@interface NSBezierPath (ESPoints)

- (void) drawPointsAndHandles;

- (void) drawPointsInColor: (NSColor*) pointColor withHandlesInColor: (NSColor *) handleColor;

- (void) drawPoint: (NSPoint) pt;
- (void) drawPoint: (NSPoint) pt inColor: (NSColor*) pointColor;
- (void) drawHandlePoint: (NSPoint) pt;
- (void) drawHandlePoint: (NSPoint) pt inColor: (NSColor*) pointColor;

- (NSPoint) drawPathElement:(int) n withPreviousPoint: (NSPoint) previous;
- (NSPoint) drawPathElement:(int) n  withPreviousPoint: (NSPoint) previous inColor: (NSColor*) pointColor withHandlesInColor: (NSColor*) handleColor;
@end
