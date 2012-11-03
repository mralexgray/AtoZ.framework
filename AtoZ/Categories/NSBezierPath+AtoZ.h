
//  GTMNSBezierPath+CGPath.h

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>



@interface NSAffineTransform (UKShearing)

+ (NSAffineTransform *)transformRotatingAroundPoint:(NSPoint) p byDegrees:(CGFloat) deg;
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


///**********************************************************************************************************************************
///  NSBezierPath-Geometry.h
///  DrawKit �2005-2008 Apptree.net
///
///  Created by graham on 22/10/2006.



@interface NSBezierPath (Geometry)

// simple transformations

- (NSBezierPath*)		scaledPath:(float) scale;
- (NSBezierPath*)		scaledPath:(float) scale aboutPoint:(NSPoint) cp;
- (NSBezierPath*)		rotatedPath:(float) angle;
- (NSBezierPath*)		rotatedPath:(float) angle aboutPoint:(NSPoint) cp;
- (NSBezierPath*)		insetPathBy:(float) amount;
- (NSBezierPath*)		horizontallyFlippedPathAboutPoint:(NSPoint) cp;
- (NSBezierPath*)		verticallyFlippedPathAboutPoint:(NSPoint) cp;
- (NSBezierPath*)		horizontallyFlippedPath;
- (NSBezierPath*)		verticallyFlippedPath;

- (NSPoint)				centreOfBounds;
- (float)				minimumCornerAngle;

// iterating over a path using a iteration delegate:

- (NSBezierPath*)		bezierPathByIteratingWithDelegate:(id) delegate contextInfo:(void*) contextInfo;

- (NSBezierPath*)		paralleloidPathWithOffset:(float) delta;
- (NSBezierPath*)		paralleloidPathWithOffset2:(float) delta;
- (NSBezierPath*)		paralleloidPathWithOffset22:(float) delta;
- (NSBezierPath*)		offsetPathWithStartingOffset:(float) delta1 endingOffset:(float) delta2;
- (NSBezierPath*)		offsetPathWithStartingOffset2:(float) delta1 endingOffset:(float) delta2;

// interpolating flattened paths:

- (NSBezierPath*)		bezierPathByInterpolatingPath:(float) amount;

// calculating a fillet

- (NSBezierPath*)		filletPathForVertex:(NSPoint[]) vp filletSize:(float) fs;

// roughening and randomising paths

- (NSBezierPath*)		bezierPathByRandomisingPoints:(float) maxAmount;
#if 0
- (NSBezierPath*)		bezierPathWithRoughenedStrokeOutline:(float) amount;
#endif
- (NSBezierPath*)		bezierPathWithFragmentedLineSegments:(float) flatness;

// zig-zags and waves

- (NSBezierPath*)		bezierPathWithZig:(float) zig zag:(float) zag;
- (NSBezierPath*)		bezierPathWithWavelength:(float) lambda amplitude:(float) amp spread:(float) spread;

// getting the outline of a stroked path:
#if 0
- (NSBezierPath*)		strokedPath;
- (NSBezierPath*)		strokedPathWithStrokeWidth:(float) width;
#endif
// breaking a path apart:

- (NSArray*)			subPaths;
- (int)					countSubPaths;

// converting to and from Core Graphics paths

#if 0
- (CGPathRef)			newQuartzPath;
- (CGMutablePathRef)	newMutableQuartzPath;
- (CGContextRef)		setQuartzPath;
- (void)				setQuartzPathInContext:(CGContextRef) context isNewPath:(BOOL) np;

+ (NSBezierPath*)		bezierPathWithCGPath:(CGPathRef) path;
+ (NSBezierPath*)		bezierPathWithPathFromContext:(CGContextRef) context;
#endif
- (NSPoint)				pointOnPathAtLength:(float) length slope:(float*) slope;
- (float)				slopeStartingPath;
- (float)				distanceFromStartOfPathAtPoint:(NSPoint) p tolerance:(float) tol;

- (int)					pointWithinPathRegion:(NSPoint) p;


// clipping utilities:
#if 0
- (void)				addInverseClip;
#endif
// path trimming

- (float)				lengthOfElement:(int) i;
- (float)				lengthOfPathFromElement:(int) startElement toElement:(int) endElement;

- (NSPoint)				firstPoint;
- (NSPoint)				lastPoint;

// trimming utilities - modified source originally from A J Houghton, see copyright notice below

- (NSBezierPath*)		bezierPathByTrimmingToLength:(float) trimLength;
- (NSBezierPath*)		bezierPathByTrimmingToLength:(float) trimLength withMaximumError:(float) maxError;

- (NSBezierPath*)		bezierPathByTrimmingFromLength:(float) trimLength;
- (NSBezierPath*)		bezierPathByTrimmingFromLength:(float) trimLength withMaximumError:(float) maxError;

- (NSBezierPath*)		bezierPathByTrimmingFromBothEnds:(float) trimLength;
- (NSBezierPath*)		bezierPathByTrimmingFromBothEnds:(float) trimLength withMaximumError:(float) maxError;

- (NSBezierPath*)		bezierPathByTrimmingFromCentre:(float) trimLength;
- (NSBezierPath*)		bezierPathByTrimmingFromCentre:(float) trimLength withMaximumError:(float) maxError;

- (NSBezierPath*)		bezierPathByTrimmingFromLength:(float) startLength toLength:(float) newLength;
- (NSBezierPath*)		bezierPathByTrimmingFromLength:(float) startLength toLength:(float) newLength withMaximumError:(float) maxError;

- (NSBezierPath*)		bezierPathWithArrowHeadForStartOfLength:(float) length angle:(float) angle closingPath:(BOOL) closeit;
- (NSBezierPath*)		bezierPathWithArrowHeadForEndOfLength:(float)length angle:(float) angle closingPath:(BOOL) closeit;

- (void)				appendBezierPathRemovingInitialMoveToPoint:(NSBezierPath*) path;

- (float)				length;
- (float)				lengthWithMaximumError:(float) maxError;

@end



// informal protocol for iterating over the elements in a bezier path using bezierPathByIteratingWithDelegate:contextInfo:

@interface NSObject (BezierElementIterationDelegate)

- (void)				path:(NSBezierPath*) path			// the new path that the delegate can build or modify from the information given
						elementIndex:(int) element			// the element index 
						type:(NSBezierPathElement) type		// the element type
						points:(NSPoint*) p					// list of associated points 0 = next point, 1 = cp1, 2 = cp2 (for curves), 3 = last point on subpath
						subPathIndex:(int) spi				// which subpath this is
						subPathClosed:(BOOL) spClosed		// is the subpath closed?
						contextInfo:(void*) contextInfo;	// the context info


@end

// undocumented Core Graphics:
#if 0
extern CGPathRef	CGContextCopyPath( CGContextRef context );
#endif

/*
 * Bezier path utility category (trimming)
 *
 * (c) 2004 Alastair J. Houghton
 * All Rights Reserved.
 *
*/
void subdivideBezierAtT(const NSPoint bez[4], NSPoint bez1[4], NSPoint bez2[4], float t);


