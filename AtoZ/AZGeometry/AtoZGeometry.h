
//  AZGeometricFunctions.h
//  Lumumba
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.

#import "AtoZUmbrella.h"
#import "AZPoint.h"
#import "AZSize.h"

#import "AZRect.h"
#import "AZGrid.h"
#import "AZMatrix.h"
#import "AZSegmentedRect.h"
#import "AtoZ.h"

@interface AtoZGeometry:NSObject
@end

BOOL AZEqualRects(NSR r1, NSR r2);

NSNumber *iNum ( NSInteger   i );
NSNumber *uNum ( NSUInteger ui );
NSNumber *fNum ( CGFloat f );
NSNumber *dNum ( double  d );

CGFloat AZMinEdge ( NSRect r );
CGFloat AZMaxEdge ( NSRect r );
CGFloat AZMaxDim ( NSSize sz );
CGFloat AZMinDim ( NSSize sz );

NSRect AZScreenFrame(void);
NSSize AZScreenSize(void);
NSRect AZScreenFrameUnderMenu(void);

FOUNDATION_EXPORT const CGPoint AZAnchorTop;
FOUNDATION_EXPORT const CGPoint AZAnchorBottom;
FOUNDATION_EXPORT const CGPoint AZAnchorRight;
FOUNDATION_EXPORT const CGPoint AZAnchorLeft;

CGPoint AZAnchorPointForPosition( AZWindowPosition pos);
NSSize  AZDirectionsOffScreenWithPosition ( NSRect rect, AZWindowPosition position );

AZWindowPosition AZPositionOfRect ( NSRect rect );
AZOrient deltaDirectionOfPoints ( NSPoint a, NSPoint b );

/**	NSRange from a min and max values even though the names imply that min should be greater than max the order does not matter the range will always start at the lower value and have a size to reach the upper value **/

NSRange AZMakeRange ( NSUInteger min, NSUInteger max );

 NSRect nanRectCheck  ( NSRect 	 rect  );
NSPoint nanPointCheck ( NSPoint  point );
 NSSize nanSizeCheck  ( NSSize   size  );
     id nanCheck	  ( NSValue* point );

// Predifined Points, Sizes and Rects

#define AZHalfPoint NSMakePoint ( 0.5, 0.5 )
#define  AZMaxPoint NSMakePoint ( MAXFLOAT, MAXFLOAT )
#define  AZHalfSize NSMakeSize ( 0.5, 0.5 )
#define   AZMaxSize NSMakeSize ( MAXFLOAT, MAXFLOAT )

#define AZRelationRect NSMakeRect ( 0, 0, 1, 1 )


CGFloat AZPointDistance(CGPoint p1, CGPoint p2);
CGFloat AZPointAngle(CGPoint p1, CGPoint p2);

CGFloat distanceFromPoint (NSPoint p1,NSPoint p2);
CGFloat AZDistanceFromPoint (NSPoint p1,NSPoint p2);
NSPoint AZPointOffset (NSPoint p, NSPoint size);
NSPoint AZPointOffsetY (NSPoint p, CGFloat distance);
NSPoint AZPointOffsetX (NSPoint p, CGFloat distance);

int GCD(int a, int b);
BOOL isWhole(CGFloat fl);
NSI AZLowestCommonDenominator(int a, int b);


NSString* AZAspectRatioString(CGFloat ratio);
CGFloat AZAspectRatioOf(CGFloat width, CGFloat height);
CGFloat AZAspectRatioForSize(NSSize size);

// Simple Length and Area calculus

CGFloat AZPerimeter(NSRect rect);
CGFloat AZPermineterWithRoundRadius (NSRect rect, CGFloat radius);

CGFloat AZLengthOfPoint(NSPoint pt);
CGFloat AZAreaOfSize(NSSize size);
CGFloat AZAreaOfRect(NSRect rect);

// Size -> Point conversion
NSPoint AZPointFromSize(NSSize size);

// NSPoint result methods
NSPoint AZOriginFromMenubarWithX(CGFloat yOffset, CGFloat xOffset);

// returns the absolute values of a point (pt.x >= 0, pt.y >= 0)
NSPoint AZAbsPoint(NSPoint point);

// floor, ceil and round simply use those functions on both values of the point
NSPoint AZFloorPoint(NSPoint point);
NSPoint AZCeilPoint(NSPoint point);
NSPoint AZRoundPoint(NSPoint point);

// pt.x = -pt.x, pt.y = -pt.x
NSPoint AZNegatePoint(NSPoint point);

// pt.x = 1 / pt.x, pt.y = 1 / pt.y
NSPoint AZInvertPoint(NSPoint point);

// exchanges both x and y values
NSPoint AZSwapPoint(NSPoint point);

// sum of two points
NSPoint AZAddPoints(NSPoint one, NSPoint another);

// subtracts the 2nd from the 1st point
NSPoint AZSubtractPoints(NSPoint origin, NSPoint subtrahend);

// sums a list of points
NSPoint AZSumPoints(NSUInteger count, NSPoint points, ...);

// multiplies both x and y with one multiplier
NSPoint AZMultiplyPoint(NSPoint point, CGFloat multiplier);

// multiplies each value with its corresponding value in another point
NSPoint AZMultiplyPointByPoint(NSPoint one, NSPoint another);

// multiplies each value with its corresponding value in a size
NSPoint AZMultiplyPointBySize(NSPoint one, NSSize size);

// positions a relative {0-1,0-1} point within absolute bounds
NSPoint AZRelativeToAbsolutePoint(NSPoint relative, NSRect bounds);

// calculates the relative {0-1,0-1} point from absolute bounds
NSPoint AZAbsoluteToRelativePoint(NSPoint absolute, NSRect bounds);

NSPoint AZDividePoint(NSPoint point, CGFloat divisor);
NSPoint AZDividePointByPoint(NSPoint point, NSPoint divisor);
NSPoint AZDividePointBySize(NSPoint point, NSSize divisor);

// moves from an origin towards the destination point
// at a distance of 1 it will reach the destination
NSPoint AZMovePoint(NSPoint origin, NSPoint target, CGFloat relativeDistance);

// moves from an origin towards the destination point
// distance on that way is measured in pixels
NSPoint AZMovePointAbs(NSPoint origin, NSPoint target, CGFloat pixels);

// returns the center point of a rect
NSPoint AZCenterOfRect(NSRect rect);

// returns the center point of a size
NSPoint AZCenterOfSize(NSSize size);

// will return the origin + size value of a rect
NSPoint AZEndOfRect(NSRect rect);

// will return the average distance of two rects
NSPoint AZCenterDistanceOfRects(NSRect from, NSRect to);

// will return the shortest possible distance in x and y
NSPoint AZBorderDistanceOfRects(NSRect from, NSRect to);

// will return the shortes possible distance from point to rect
NSPoint AZPointDistanceToBorderOfRect(NSPoint point, NSRect rect);

NSPoint AZNormalizedDistanceOfRects(NSRect from, NSRect to);
NSPoint AZNormalizedDistanceToCenterOfRect(NSPoint point, NSRect rect);

NSPoint AZPointFromDim(CGFloat val);
// NSSize result methods
// 
// converts a float to a rect of equal sized sizes of dim;
NSRect AZRectFromDim(CGFloat dim);

//  Makes Rect 0, 0, boundsX, boundsY  easy syntax AZRectBy(200,233)
NSRect AZRectBy(CGFloat boundX, CGFloat boundY);


// converts a float to a size;
NSSize AZSizeFromDimension(CGFloat dim);

// converts a point to a size
NSSize AZSizeFromPoint(NSPoint point);

// ABS on both values of the size
NSSize AZAbsSize(NSSize size);

// Adds the width and height of two sizes
NSSize AZAddSizes(NSSize one, NSSize another);

// subtracts the subtrahends dimensions from the ones of the size
NSSize AZSubtractSizes(NSSize size, NSSize subtrahend);

// returns 1 / value on both values of the size
NSSize AZInvertSize(NSSize size);

// will return the ratio of an inner size to an outer size
NSSize AZRatioOfSizes(NSSize inner, NSSize outer);

NSSize AZMultiplySize( NSSize size, CGFloat multiplier);

// will multiply a size by a single multiplier
NSSize AZMultiplySizeBy( NSSize size, CGFloat multiplier);
//NSSize AZMultiplySize(NSSize size, CGFloat multiplier);

// will multiply a size by another size
NSSize AZMultiplySizeBySize(NSSize size, NSSize another);

// will multiply a size by a point
NSSize AZMultiplySizeByPoint(NSSize size, NSPoint point);

// blends one size towards another
// percentage == 0 -> one
// percentage == 1 -> another
// @see AZMovePoint
NSSize AZBlendSizes(NSSize one, NSSize another, CGFloat percentage);

NSSize AZSizeMax(NSSize one, NSSize another);
NSSize AZSizeMin(NSSize one, NSSize another);
NSSize AZSizeBound(NSSize preferred, NSSize minSize, NSSize maxSize);
// NSRect result methods
NSRect AZZeroHeightBelowMenu(void);

NSRect AZFlipRectinRect(CGRect local, CGRect dest);

CGFloat AZMenuBarThickness (void);

NSRect AZMenuBarFrame(void);

NSRect AZRectVerticallyOffsetBy(CGRect rect, CGFloat offset);
NSRect AZRectHorizontallyOffsetBy(CGRect rect, CGFloat offset);

NSRect AZMenulessScreenRect(void);

NSRect AZMakeRectMaxXUnderMenuBarY(CGFloat distance);

CGFloat AZHeightUnderMenu(void);
NSRect AZSquareFromLength(CGFloat length);

// returns a zero sized rect with the argumented point as origin
NSRect AZMakeRectFromPoint(NSPoint point);

// returns a zero point origin with the argumented size
NSRect AZMakeRectFromSize(NSSize size);

// just another way of defining a rect
NSRect AZMakeRect(NSPoint point, NSSize size);

// creates a square rect around a center point
NSRect AZMakeSquare(NSPoint center, CGFloat radius);

NSRect AZMultiplyRectBySize(NSRect rect, NSSize size);

// transforms a relative rect to an absolute within absolute bounds
NSRect AZRelativeToAbsoluteRect(NSRect relative, NSRect bounds);

// transforms an absolute rect to a relative rect within absolute bounds
NSRect AZAbsoluteToRelativeRect(NSRect absolute, NSRect bounds);

NSRect AZPositionRectOnRect(NSRect inner, NSRect outer, NSPoint position);

// moves the origin of the rect
NSRect AZCenterRectOnPoint(NSRect rect, NSPoint center);

// returns the innter rect with its posiion centeredn on the outer rect
NSRect AZCenterRectOnRect(NSRect inner, NSRect outer);

// will a square rect with a given center
NSRect AZSquareAround(NSPoint center, CGFloat distance);

// blends a rect from one to another
NSRect AZBlendRects(NSRect from, NSRect to, CGFloat at);

// Croped Rects

NSRect AZRectTrimmedOnRight(NSRect rect, CGFloat width);
NSRect AZRectTrimmedOnBottom(NSRect rect, CGFloat height);
NSRect AZRectTrimmedOnLeft(NSRect rect, CGFloat width);
NSRect AZRectTrimmedOnTop(NSRect rect, CGFloat height);

NSRect AZRectExceptWide (NSRect rect, CGFloat wide);
NSRect AZRectExceptHigh (NSRect rect, CGFloat high);
NSRect AZRectExceptOriginX (NSRect rect, CGFloat x);
NSRect AZRectExceptOriginY (NSRect rect, CGFloat y);

// returns a rect with insets of the same size x and y
NSRect AZInsetRect(NSRect rect, CGFloat inset);

// returns a rect at the left edge of a rect with a given inset width
NSRect AZLeftEdge(NSRect rect, CGFloat width);

// returns a rect at the right edge of a rect with a given inset width
NSRect AZRightEdge(NSRect rect, CGFloat width);

// returns a rect at the lower edge of a rect with a given inset width
NSRect AZLowerEdge(NSRect rect, CGFloat height);

// returns a rect at the upper edge of a rect with a given inset width
NSRect AZUpperEdge(NSRect rect, CGFloat height);

// macro to call a border drawing method with a border width
// this will effectively draw the border but clip the inner rect

// Example: AZInsideClip(NSDrawLightBezel, rect, 2);
//          Will draw a 2px light beezel around a rect
#define AZInsideClip(METHOD,RECT,BORDER) \
  METHOD(RECT, AZLeftEdge( RECT, BORDER)); \
  METHOD(RECT, AZRightEdge(RECT, BORDER)); \
  METHOD(RECT, AZUpperEdge(RECT, BORDER)); \
  METHOD(RECT, AZLowerEdge(RECT, BORDER))
// Comparison methods
BOOL AZIsPointLeftOfRect(NSPoint point, NSRect rect);
BOOL AZIsPointRightOfRect(NSPoint point, NSRect rect);
BOOL AZIsPointAboveRect(NSPoint point, NSRect rect);
BOOL AZIsPointBelowRect(NSPoint point, NSRect rect);

BOOL AZIsRectLeftOfRect(NSRect rect, NSRect compare);
BOOL AZIsRectRightOfRect(NSRect rect, NSRect compare);
BOOL AZIsRectAboveRect(NSRect rect, NSRect compare);
BOOL AZIsRectBelowRect(NSRect rect, NSRect compare);

NSRect rectZoom(NSRect rect,float zoom,int quadrant);


NSRect AZSquareInRect(NSRect rect);


NSRect sizeRectInRect(NSRect innerRect,NSRect outerRect,bool expand);
NSPoint offsetPoint(NSPoint fromPoint, NSPoint toPoint);
NSRect fitRectInRect(NSRect innerRect,NSRect outerRect,bool expand);
NSRect centerRectInRect(NSRect rect, NSRect mainRect);
NSRect rectFromSize(NSSize size);
//NSRect rectWithProportion(NSRect innerRect,float proportion,bool expand);

NSRect sectionPositioned(NSRect r, AZWindowPosition p);
int oppositeQuadrant(int quadrant);
NSRect quadrant(NSRect r, AZQuadrant quad);

CGFloat quadrantsVerticalGutter(NSRect r);

CGFloat quadrantsHorizontalGutter(NSRect r);

NSRect constrainRectToRect(NSRect innerRect, NSRect outerRect);
NSRect alignRectInRect(NSRect innerRect,NSRect outerRect,int quadrant);
//NSRect expelRectFromRect(NSRect innerRect, NSRect outerRect,float peek);
//NSRect expelRectFromRectOnEdge(NSRect innerRect, NSRect outerRect,NSRectEdge edge,float peek);

NSRectEdge touchingEdgeForRectInRect(NSRect innerRect, NSRect outerRect);
int closestCorner(NSRect innerRect,NSRect outerRect);
int oppositeQuadrant(int quadrant);
//
NSRect blendRects(NSRect start, NSRect end,float b);
void logRect(NSRect rect);

CGPoint NSMakeRandomPointInRect(CGRect rect);
NSPoint randomPointInRect(NSRect rect);

/** Returns the center point of a CGRect. */
static inline CGPoint GetCGRectCenter( CGRect rect ) {
    return CGPointMake(CGRectGetMidX(rect),CGRectGetMidY(rect));
}
	// EOF

	//typedef struct _BTFloatRange {
	//    float value;
	//    float location;
	//    float length;
	//} BTFloatRange;
	//
	//
	//BTFloatRange BTMakeFloatRange(float value,float location,float length);
	//float BTFloatRangeMod(BTFloatRange range);
	//float BTFloatRangeUnit(BTFloatRange range);
	//NSPoint rectOffset(NSRect innerRect,NSRect outerRect,int quadrant);
