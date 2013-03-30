
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


NSR AZTransformRect (NSRect target, NSRect model);

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



NSP AZTopLeftPoint  ( NSR rect );
NSP AZTopRightPoint ( NSR rect );
NSP AZBotLeft  ( NSR rect );
NSP AZBotRight ( NSR rect );



/**	NSRange from a min and max values even though the names imply that min should be greater than max the order does not matter the range will always start at the lower value and have a size to reach the upper value **/

//NSRange AZMakeRange ( NSUInteger min, NSUInteger max );


CGF AZPointDistance ( CGP p1, CGP p2 );
#define AZDistanceBetween(A,B) AZPointDistance(A,B)

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
CGF AZPerimeterWithRoundRadius  ( NSR rect, CGF radius );


AZPOS AZPositionOpposite(AZPOS position);

AZPOS AZPositionOfEdgeAtOffsetAlongPerimeterOfRect(CGF offset, NSR r);

CGP   AZPointAtOffsetAlongPerimeterOfRect(CGF offset, NSR r);  //from bottom left going counterclockwise

AZPOS AZPositionOfRectPinnedToOutisdeOfRect(NSR box, NSR innerBox  );



//Includes corner preciion based on inner rect size;
AZPOS AZPositionOfRectAtOffsetInsidePerimeterOfRect(NSR inner, CGF offset, NSR outer);


AZPOS AZPositionOfRectInRect ( NSR rect, NSR outer );
AZPOS AZOutsideEdgeOfRectInRect (NSR rect, NSR outer );


AZPOS AZPositionAtPerimeterInRect ( NSR edgeBox, NSR outer );
CGP	  AZAnchorPointForPosition( AZWindowPosition pos );
NSSZ  AZDirectionsOffScreenWithPosition ( NSR rect, AZWindowPosition position );


AZOrient deltaDirectionOfPoints ( NSP a, NSP b );


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


CGF AZMenuBarH (void);


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

NSR AZConstrainRectToRect(NSR innerRect, NSR outerRect);

// will a square rect with a given center
NSR AZSquareAround ( NSP center, CGF distance );

// blends a rect from one to another
NSR AZBlendRects ( NSR from, NSR to, CGF at );

// Croped Rects

NSR AZRectTrimmedOnRight ( NSR rect, CGF width );
NSR AZRectTrimmedOnBottom ( NSR rect, CGF height );
NSR AZRectTrimmedOnLeft ( NSR rect, CGF width );
NSR AZRectTrimmedOnTop ( NSR rect, CGF height );

NSSZ AZSizeExceptWide  ( NSSZ sz, CGF wide );
NSSZ AZSizeExceptHigh  ( NSSZ sz, CGF high );

NSR AZRectExtendedOnLeft(NSR rect, CGFloat amount);
NSR AZRectExtendedOnBottom(NSR rect, CGFloat amount);
NSR AZRectExtendedOnTop(NSR rect, CGFloat amount);
NSR AZRectExtendedOnRight(NSR rect, CGFloat amount);



FOUNDATION_EXPORT NSR AZRectExceptWide  ( NSR rect, CGF wide );
FOUNDATION_EXPORT NSR AZRectExceptHigh  ( NSR rect, CGF high );
FOUNDATION_EXPORT NSR AZRectExceptOriginX  ( NSR rect, CGF x );
FOUNDATION_EXPORT NSR AZRectExceptOriginY  ( NSR rect, CGF y );

// returns a rect with insets of the same size x and y
FOUNDATION_EXPORT NSR AZInsetRect ( NSR rect, CGF inset );

// returns a rect at the left edge of a rect with a given inset width
FOUNDATION_EXPORT NSR AZLeftEdge ( NSR rect, CGF width );

// returns a rect at the right edge of a rect with a given inset width
FOUNDATION_EXPORT NSR AZRightEdge ( NSR rect, CGF width );

// returns a rect at the lower edge of a rect with a given inset width
FOUNDATION_EXPORT NSR AZLowerEdge ( NSR rect, CGF height );

// returns a rect at the upper edge of a rect with a given inset width
FOUNDATION_EXPORT NSR AZUpperEdge ( NSR rect, CGF height );



typedef struct AZInsetRects {
	NSRect top;
	NSRect right;
	NSRect bottom;
	NSRect left;
} AZInsetRects;

NSR AZRectInsideRectOnEdge(NSRect center, NSRect outer, AZPOS position);

NSR AZRectOutsideRectOnEdge(NSRect center, NSRect outer, AZPOS position);
NSR AZRectFlippedOnEdge(NSRect r, AZPOS position);

FOUNDATION_EXPORT NSR AZInsetRectInPosition ( NSRect outside, NSSZ inset, AZPOS pos );

FOUNDATION_EXPORT AZPOS AZPosOfPointInInsetRects ( NSP point, NSRect outside, NSSZ inset );
FOUNDATION_EXPORT BOOL  AZPointIsInInsetRects    ( NSP point, NSRect outside, NSSZ inset );

static inline AZInsetRects AZMakeInsideRects(NSRect rect, NSSize inset) {

   AZInsetRects rects = { AZUpperEdge( rect, inset.height ), AZRightEdge( rect, inset.width  ),
						  AZLowerEdge( rect, inset.height ), AZLeftEdge ( rect, inset.width  ) };
	return rects;
}

//FOUNDATION_EXPORT AZOutsideEdges AZOutsideEdgesSized(NSRect rect, NSSZ size);

//BOOL AZPointInOutsideEdgeOfRect(NSP point, NSRect rect, NSSZ size);

// macro to call a border drawing method with a border width
// this will effectively draw the border but clip the inner rect

// Example: AZInsideClip ( NSDrawLightBezel, rect, 2 );
//		  Will draw a 2px light beezel around a rect
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
NSR AZRectOfQuadInRect(NSR originalRect, AZQuadrant quad); //alias for quadrant

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
//	float value;
//	float location;
//	float length;
//} BTFloatRange;
//
//
//BTFloatRange BTMakeFloatRange ( float value,float location,float length );
//float BTFloatRangeMod ( BTFloatRange range );
//float BTFloatRangeUnit ( BTFloatRange range );

//NSP AZRectOffset ( NSR innerRect, NSR outerRect, QUAD quadrant );


NSRect AZOffsetRect(NSR rect, NSP offset);

NSRect				NSRectFromTwoPoints( const NSPoint a, const NSPoint b );
NSRect				NSRectCentredOnPoint( const NSPoint p, const NSSize size );
NSRect				UnionOfTwoRects( const NSRect a, const NSRect b );
NSRect				UnionOfRectsInSet( const NSSet* aSet );
NSSet*				DifferenceOfTwoRects( const NSRect a, const NSRect b );
NSSet*				SubtractTwoRects( const NSRect a, const NSRect b );

BOOL				AreSimilarRects( const NSRect a, const NSRect b, const CGFloat epsilon );

CGFloat				PointFromLine( const NSPoint inPoint, const NSPoint a, const NSPoint b );
NSPoint				NearestPointOnLine( const NSPoint inPoint, const NSPoint a, const NSPoint b );
CGFloat				RelPoint( const NSPoint inPoint, const NSPoint a, const NSPoint b );
NSInteger			PointInLineSegment( const NSPoint inPoint, const NSPoint a, const NSPoint b );

NSPoint				BisectLine( const NSPoint a, const NSPoint b );
NSPoint				Interpolate( const NSPoint a, const NSPoint b, const CGFloat proportion);
CGFloat				LineLength( const NSPoint a, const NSPoint b );

CGFloat				SquaredLength( const NSPoint p );
NSPoint				DiffPoint( const NSPoint a, const NSPoint b );
CGFloat				DiffPointSquaredLength( const NSPoint a, const NSPoint b );
NSPoint				SumPoint( const NSPoint a, const NSPoint b );

NSPoint				EndPoint( NSPoint origin, CGFloat angle, CGFloat length );
CGFloat				Slope( const NSPoint a, const NSPoint b );
CGFloat				AngleBetween( const NSPoint a, const NSPoint b, const NSPoint c );
CGFloat				DotProduct( const NSPoint a, const NSPoint b );
NSPoint				Intersection( const NSPoint aa, const NSPoint ab, const NSPoint ba, const NSPoint bb );
NSPoint				Intersection2( const NSPoint p1, const NSPoint p2, const NSPoint p3, const NSPoint p4 );

NSRect				CentreRectOnPoint( const NSRect inRect, const NSPoint p );
NSPoint				MapPointFromRect( const NSPoint p, const NSRect rect );
NSPoint				MapPointToRect( const NSPoint p, const NSRect rect );
NSPoint				MapPointFromRectToRect( const NSPoint p, const NSRect srcRect, const NSRect destRect );
NSRect				MapRectFromRectToRect( const NSRect inRect, const NSRect srcRect, const NSRect destRect );

NSRect				ScaleRect( const NSRect inRect, const CGFloat scale );
NSRect				ScaledRectForSize( const NSSize inSize, NSRect const fitRect );
NSRect				CentreRectInRect(const NSRect r, const NSRect cr );
NSBezierPath*		RotatedRect( const NSRect r, const CGFloat radians );

NSRect				NormalizedRect( const NSRect r );
NSAffineTransform*	RotationTransform( const CGFloat radians, const NSPoint aboutPoint );

//NSPoint			PerspectiveMap( NSPoint inPoint, NSSize sourceSize, NSPoint quad[4]);

NSPoint				NearestPointOnCurve( const NSPoint inp, const NSPoint bez[4], double* tValue );
NSPoint				Bezier( const NSPoint* v, const NSInteger degree, const double t, NSPoint* Left, NSPoint* Right );

CGFloat				BezierSlope( const NSPoint bez[4], const CGFloat t );

extern const NSPoint NSNotFoundPoint;


@interface AtoZGeometry:NSObject
@end
