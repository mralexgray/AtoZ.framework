
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

NSR  nanRectCheck  ( NSR   rect );
NSP  nanPointCheck ( NSP  point );
NSSZ nanSizeCheck  ( NSSZ  size );
id 	 nanCheck	   ( NSV* point );

// Predifined Points, Sizes and Rects

#define AZHalfPoint NSMakePoint ( 0.5, 0.5 )
#define  AZMaxPoint NSMakePoint ( MAXFLOAT, MAXFLOAT )
#define  AZHalfSize NSMakeSize 	( 0.5, 0.5 )
#define   AZMaxSize NSMakeSize  ( MAXFLOAT, MAXFLOAT )

#define AZRelationRect NSMakeRect ( 0, 0, 1, 1 )

BOOL AZEqualRects ( NSR r1, NSR r2 );

NSNumber *iNum ( NSInteger   i );
NSNumber *uNum ( NSUInteger ui );
NSNumber *fNum ( CGF f );
NSNumber *dNum ( double  d );

FOUNDATION_EXPORT const CGP AZAnchorTop;
FOUNDATION_EXPORT const CGP AZAnchorBottom;
FOUNDATION_EXPORT const CGP AZAnchorRight;
FOUNDATION_EXPORT const CGP AZAnchorLeft;

FOUNDATION_EXPORT const CGP AZAnchorTopLeft;
FOUNDATION_EXPORT const CGP AZAnchorBottomLeft;
FOUNDATION_EXPORT const CGP AZAnchorTopRight;
FOUNDATION_EXPORT const CGP AZAnchorBottomLeft;





extern const CGRect CGRectOne;

//FOUNDATION_EXPORT const CGP AZAnchorTop,
//							AZAnchorBottom,
//							AZAnchorRight,
//							AZAnchorLeft;



NSP AZTopLeft  ( NSR rect );
NSP AZTopRight ( NSR rect );
NSP AZBotLeft  ( NSR rect );
NSP AZBotRight ( NSR rect );


AZPOS AZPositionOfRectInRect ( NSR rect, NSR outer );
AZPOS AZOutsideEdgeOfRectInRect (NSR rect, NSR outer );


AZWindowPosition AZPositionAtPerimeterInRect ( NSR edgeBox, NSR outer );
CGP AZAnchorPointForPosition( AZWindowPosition pos );
NSSZ  AZDirectionsOffScreenWithPosition ( NSR rect, AZWindowPosition position );


AZOrient deltaDirectionOfPoints ( NSP a, NSP b );

/**	NSRange from a min and max values even though the names imply that min should be greater than max the order does not matter the range will always start at the lower value and have a size to reach the upper value **/

NSRange AZMakeRange ( NSUInteger min, NSUInteger max );

CGF AZPointDistance ( CGP p1, CGP p2 );
CGF AZPointAngle ( CGP p1, CGP p2 );

CGF distanceFromPoint   ( NSP p1,NSP p2 );
CGF AZDistanceFromPoint ( NSP p1,NSP p2 );

NSP AZPointOffset  ( NSP p, NSP size );
NSP AZPointOffsetY ( NSP p, CGF distance );
NSP AZPointOffsetX ( NSP p, CGF distance );

int GCD ( int a, int b );

BOOL isWhole ( CGF fl );

NSI AZLowestCommonDenominator ( int a, int b );

NSS* AZAspectRatioString ( CGF ratio );
CGF  AZAspectRatioOf ( CGF width, CGF height );
CGF  AZAspectRatioForSize ( NSSZ size );

// Simple Length and Area calculus

CGF AZPerimeter ( NSR rect );
CGF AZPermineterWithRoundRadius  ( NSR rect, CGF radius );


NSR  AZScreenFrame ( void );
NSSZ AZScreenSize  ( void );
NSR  AZScreenFrameUnderMenu ( void );

CGF AZMinEdge ( NSR r );
CGF AZMaxEdge ( NSR r );
CGF AZMaxDim ( NSSZ sz );
CGF AZMinDim ( NSSZ sz );


CGF AZLengthOfPoint ( NSP pt );
CGF AZAreaOfSize ( NSSZ size );
CGF AZAreaOfRect ( NSR rect );

// Size -> Point conversion
NSP AZPointFromSize ( NSSZ size );

// NSP result methods
NSP AZOriginFromMenubarWithX ( CGF yOffset, CGF xOffset );

// returns the absolute values of a point  ( pt.x >= 0, pt.y >= 0)
NSP AZAbsPoint ( NSP point );

// floor, ceil and round simply use those functions on both values of the point
NSP AZFloorPoint ( NSP point );
NSP AZCeilPoint ( NSP point );
NSP AZRoundPoint ( NSP point );

// pt.x = -pt.x, pt.y = -pt.x
NSP AZNegatePoint ( NSP point );

// pt.x = 1 / pt.x, pt.y = 1 / pt.y
NSP AZInvertPoint ( NSP point );

// exchanges both x and y values
NSP AZSwapPoint ( NSP point );

// sum of two points
NSP AZAddPoints ( NSP one, NSP another );

// subtracts the 2nd from the 1st point
NSP AZSubtractPoints ( NSP origin, NSP subtrahend );

// sums a list of points
NSP AZSumPoints ( NSUInteger count, NSP points, ... );

// multiplies both x and y with one multiplier
NSP AZMultiplyPoint ( NSP point, CGF multiplier );

// multiplies each value with its corresponding value in another point
NSP AZMultiplyPointByPoint ( NSP one, NSP another );

// multiplies each value with its corresponding value in a size
NSP AZMultiplyPointBySize ( NSP one, NSSZ size );

// positions a relative {0-1,0-1} point within absolute bounds
NSP AZRelativeToAbsolutePoint ( NSP relative, NSR bounds );

// calculates the relative {0-1,0-1} point from absolute bounds
NSP AZAbsoluteToRelativePoint ( NSP absolute, NSR bounds );

NSP AZDividePoint ( NSP point, CGF divisor );
NSP AZDividePointByPoint ( NSP point, NSP divisor );
NSP AZDividePointBySize ( NSP point, NSSZ divisor );

// moves from an origin towards the destination point
// at a distance of 1 it will reach the destination
NSP AZMovePoint ( NSP origin, NSP target, CGF relativeDistance );

// moves from an origin towards the destination point
// distance on that way is measured in pixels
NSP AZMovePointAbs ( NSP origin, NSP target, CGF pixels );

// returns the center point of a rect
NSP AZCenterOfRect ( NSR rect );

// returns the center point of a size
NSP AZCenterOfSize ( NSSZ size );

// will return the origin + size value of a rect
NSP AZEndOfRect ( NSR rect );

// will return the average distance of two rects
NSP AZCenterDistanceOfRects ( NSR from, NSR to );

// will return the shortest possible distance in x and y
NSP AZBorderDistanceOfRects ( NSR from, NSR to );

// will return the shortes possible distance from point to rect
NSP AZPointDistanceToBorderOfRect ( NSP point, NSR rect );

NSP AZNormalizedDistanceOfRects ( NSR from, NSR to );
NSP AZNormalizedDistanceToCenterOfRect ( NSP point, NSR rect );

NSP AZPointFromDim ( CGF val );
// NSSZ result methods
// 
// converts a float to a rect of equal sized sizes of dim;
NSR AZRectFromDim ( CGF dim );

//  Makes Rect 0, 0, boundsX, boundsY  easy syntax AZRectBy ( 200,233)
NSR AZRectBy ( CGF boundX, CGF boundY );


// converts a float to a size;
NSSZ AZSizeFromDimension ( CGF dim );

// converts a point to a size
NSSZ AZSizeFromPoint ( NSP point );

// ABS on both values of the size
NSSZ AZAbsSize ( NSSZ size );

// Adds the width and height of two sizes
NSSZ AZAddSizes ( NSSZ one, NSSZ another );

// subtracts the subtrahends dimensions from the ones of the size
NSSZ AZSubtractSizes ( NSSZ size, NSSZ subtrahend );

// returns 1 / value on both values of the size
NSSZ AZInvertSize ( NSSZ size );

// will return the ratio of an inner size to an outer size
NSSZ AZRatioOfSizes ( NSSZ inner, NSSZ outer );

NSSZ AZMultiplySize( NSSZ size, CGF multiplier );

// will multiply a size by a single multiplier
NSSZ AZMultiplySizeBy( NSSZ size, CGF multiplier );
//NSSZ AZMultiplySize ( NSSZ size, CGF multiplier );

// will multiply a size by another size
NSSZ AZMultiplySizeBySize ( NSSZ size, NSSZ another );

// will multiply a size by a point
NSSZ AZMultiplySizeByPoint ( NSSZ size, NSP point );

// blends one size towards another
// percentage == 0 -> one
// percentage == 1 -> another
// @see AZMovePoint
NSSZ AZBlendSizes ( NSSZ one, NSSZ another, CGF percentage );

NSSZ AZSizeMax ( NSSZ one, NSSZ another );
NSSZ AZSizeMin ( NSSZ one, NSSZ another );
NSSZ AZSizeBound ( NSSZ preferred, NSSZ minSize, NSSZ maxSize );
// NSR result methods
NSR AZZeroHeightBelowMenu ( void );

NSR AZFlipRectinRect ( CGRect local, CGRect dest );

CGF AZMenuBarThickness  ( void );

NSR AZMenuBarFrame ( void );

NSR AZRectVerticallyOffsetBy ( CGRect rect, CGF offset );
NSR AZRectHorizontallyOffsetBy ( CGRect rect, CGF offset );

NSR AZMenulessScreenRect ( void );

NSR AZMakeRectMaxXUnderMenuBarY ( CGF distance );

CGF AZHeightUnderMenu ( void );
NSR AZSquareFromLength ( CGF length );

// returns a zero sized rect with the argumented point as origin
NSR AZMakeRectFromPoint ( NSP point );

// returns a zero point origin with the argumented size
NSR AZMakeRectFromSize ( NSSZ size );

// just another way of defining a rect
NSR AZMakeRect ( NSP point, NSSZ size );

// creates a square rect around a center point
NSR AZMakeSquare ( NSP center, CGF radius );

NSR AZMultiplyRectBySize ( NSR rect, NSSZ size );

// transforms a relative rect to an absolute within absolute bounds
NSR AZRelativeToAbsoluteRect ( NSR relative, NSR bounds );

// transforms an absolute rect to a relative rect within absolute bounds
NSR AZAbsoluteToRelativeRect ( NSR absolute, NSR bounds );

NSR AZPositionRectOnRect ( NSR inner, NSR outer, NSP position );

// moves the origin of the rect
NSR AZCenterRectOnPoint ( NSR rect, NSP center );

// returns the innter rect with its posiion centeredn on the outer rect
NSR AZCenterRectOnRect ( NSR inner, NSR outer );

// will a square rect with a given center
NSR AZSquareAround ( NSP center, CGF distance );

// blends a rect from one to another
NSR AZBlendRects ( NSR from, NSR to, CGF at );

// Croped Rects

NSR AZRectTrimmedOnRight ( NSR rect, CGF width );
NSR AZRectTrimmedOnBottom ( NSR rect, CGF height );
NSR AZRectTrimmedOnLeft ( NSR rect, CGF width );
NSR AZRectTrimmedOnTop ( NSR rect, CGF height );

NSR AZRectExceptWide  ( NSR rect, CGF wide );
NSR AZRectExceptHigh  ( NSR rect, CGF high );
NSR AZRectExceptOriginX  ( NSR rect, CGF x );
NSR AZRectExceptOriginY  ( NSR rect, CGF y );

// returns a rect with insets of the same size x and y
NSR AZInsetRect ( NSR rect, CGF inset );

// returns a rect at the left edge of a rect with a given inset width
NSR AZLeftEdge ( NSR rect, CGF width );

// returns a rect at the right edge of a rect with a given inset width
NSR AZRightEdge ( NSR rect, CGF width );

// returns a rect at the lower edge of a rect with a given inset width
NSR AZLowerEdge ( NSR rect, CGF height );

// returns a rect at the upper edge of a rect with a given inset width
NSR AZUpperEdge ( NSR rect, CGF height );

// macro to call a border drawing method with a border width
// this will effectively draw the border but clip the inner rect

// Example: AZInsideClip ( NSDrawLightBezel, rect, 2 );
//          Will draw a 2px light beezel around a rect
#define AZInsideClip ( METHOD,RECT,BORDER) \
  METHOD ( RECT, AZLeftEdge( RECT, BORDER ) ); \
  METHOD ( RECT, AZRightEdge ( RECT, BORDER ) ); \
  METHOD ( RECT, AZUpperEdge ( RECT, BORDER ) ); \
  METHOD ( RECT, AZLowerEdge ( RECT, BORDER ))
// Comparison methods
BOOL AZIsPointLeftOfRect ( NSP point, NSR rect );
BOOL AZIsPointRightOfRect ( NSP point, NSR rect );
BOOL AZIsPointAboveRect ( NSP point, NSR rect );
BOOL AZIsPointBelowRect ( NSP point, NSR rect );

BOOL AZIsRectLeftOfRect ( NSR rect, NSR compare );
BOOL AZIsRectRightOfRect ( NSR rect, NSR compare );
BOOL AZIsRectAboveRect ( NSR rect, NSR compare );
BOOL AZIsRectBelowRect ( NSR rect, NSR compare );

NSR rectZoom ( NSR rect,float zoom,int quadrant );


NSR AZSquareInRect ( NSR rect );


NSR AZSizeRectInRect ( NSR innerRect,NSR outerRect,bool expand );
NSP AZOffsetPoint 	 ( NSP fromPoint, NSP toPoint );
NSR AZFitRectInRect  ( NSR innerRect,NSR outerRect,bool expand );
NSR AZCenterRectInRect ( NSR rect, NSR mainRect );
NSR AZRectFromSize ( NSSZ size );
//NSR rectWithProportion ( NSR innerRect,float proportion,bool expand );

NSR sectionPositioned ( NSR r, AZWindowPosition p );
int oppositeQuadrant ( int quadrant );
NSR quadrant ( NSR r, AZQuadrant quad );

CGF quadrantsVerticalGutter ( NSR r );

CGF quadrantsHorizontalGutter ( NSR r );

NSR constrainRectToRect ( NSR innerRect, NSR outerRect );
NSR alignRectInRect ( NSR innerRect,NSR outerRect,int quadrant );
//NSR expelRectFromRect ( NSR innerRect, NSR outerRect,float peek );
//NSR expelRectFromRectOnEdge ( NSR innerRect, NSR outerRect,NSREdge edge,float peek );

CGRectEdge AZEdgeTouchingEdgeForRectInRect ( NSR innerRect, NSR outerRect );
AZPOS AZClosestCorner ( NSR innerRect,NSR outerRect );
QUAD AZOppositeQuadrant ( int quadrant );
//
NSR AZBlendRects ( NSR start, NSR end, CGF b );
void logRect ( NSR rect );


NSR	AZRandomRectinRect ( CGRect rect );
CGP AZRandomPointInRect ( CGRect rect );

/** Returns the center point of a CGRect. */
static inline CGP AZCenter( CGRect rect ) {
    return CGPointMake ( CGRectGetMidX ( rect ),CGRectGetMidY ( rect ) );
}
// EOF

//typedef struct _BTFloatRange {
//    float value;
//    float location;
//    float length;
//} BTFloatRange;
//
//
//BTFloatRange BTMakeFloatRange ( float value,float location,float length );
//float BTFloatRangeMod ( BTFloatRange range );
//float BTFloatRangeUnit ( BTFloatRange range );
//NSP rectOffset ( NSR innerRect,NSR outerRect,int quadrant );


@interface AtoZGeometry:NSObject
@end
