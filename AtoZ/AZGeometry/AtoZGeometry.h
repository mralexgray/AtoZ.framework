
//  AZGeometricFunctions.h
//  Lumumba
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.

#import "AtoZUmbrella.h"
#import "AtoZTypes.h"
#import "AZPoint.h"
#import "AZSize.h"
#import "AZRect.h"
#import "AZGrid.h"
#import "AZMatrix.h"
#import "AZSegmentedRect.h"


NSR AZTransformRect (NSRect target, NSR model);

NSR  AZRectCheckWithMinSize(NSR rect, NSSZ size);
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

NSNumber *iNum ( NSI	i );
NSNumber *uNum ( NSUI  ui );
NSNumber *fNum ( CGF	f );
NSNumber *dNum ( double d );

NSP AZAnchorPointOfActualRect(NSR rect, AZPOS pos);

FOUNDATION_EXPORT const CGP AZAnchorTop;
FOUNDATION_EXPORT const CGP AZAnchorBottom;
FOUNDATION_EXPORT const CGP AZAnchorRight;
FOUNDATION_EXPORT const CGP AZAnchorLeft;

FOUNDATION_EXPORT const CGP AZAnchorTopLeft;
FOUNDATION_EXPORT const CGP AZAnchorBottomLeft;
FOUNDATION_EXPORT const CGP AZAnchorTopRight;
FOUNDATION_EXPORT const CGP AZAnchorBottomRight;

FOUNDATION_EXPORT const CGP AZAnchorCenter;


extern const CGRect CGRectOne;

//FOUNDATION_EXPORT const CGP AZAnchorTop,
//				AZAnchorBottom,
//				AZAnchorRight,
//				AZAnchorLeft;

NSP AZTopLeftPoint  ( NSR rect );
NSP AZTopRightPoint ( NSR rect );
NSP AZBotLeftPoint  ( NSR rect );
NSP AZBotRightPoint ( NSR rect );

/**	NSRange from a min and max values even though the names imply that min should be greater than max the order does not matter the range will always start at the lower value and have a size to reach the upper value **/

//NSRange AZMakeRange ( NSUI min, NSUI max );


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

AZA AZAlignmentInsideRect(NSR edgeBox, NSR outer);


//Includes corner preciion based on inner rect size;
AZPOS AZPositionOfRectAtOffsetInsidePerimeterOfRect(NSR inner, CGF offset, NSR outer);


AZPOS AZPositionOfQuadInRect ( NSR rect, NSR outer );
AZPOS AZOutsideEdgeOfRectInRect (NSR rect, NSR outer );

AZPOS AZOutsideEdgeOfPointInRect (NSP inside, NSR outer );

AZPOS AZPositionAtPerimeterInRect ( NSR edgeBox, NSR outer );
CGP	  AZAnchorPointForPosition( AZPOS pos );
NSSZ  AZDirectionsOffScreenWithPosition ( NSR rect, AZPOS position );


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


CGF AZMenuBarH (void) ;


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
NSP AZSumPoints ( NSUI count, NSP points, ... );

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

NSP AZP(CGF x, CGF y);

//  Makes Rect 0, 0, boundsX, boundsY  easy syntax AZRectBy ( 200,233)
NSR AZRectBy ( CGF boundX, CGF boundY );


// converts a float to a size;
NSSZ AZSizeFromDimension ( CGF dim );

// converts a point to a size
NSSZ AZSizeFromPoint ( NSP point );
NSSZ 	AZSizeFromRect	(NSR rect);
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

NSR AZRectOffsetBy(CGRect rect, CGF x, CGF y);
NSR AZRectOffsetBySize(CGRect rect, CGSZ sz);
NSR AZRectOffsetByPt(CGRect rect, NSP pt);
NSR AZRectOffsetFromDim(CGRect rect, CGF xyDistance);

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

NSR AZRectExtendedOnLeft(NSR rect, CGF amount);
NSR AZRectExtendedOnBottom(NSR rect, CGF amount);
NSR AZRectExtendedOnTop(NSR rect, CGF amount);
NSR AZRectExtendedOnRight(NSR rect, CGF amount);


NSR 	AZRectExceptSize (NSR rect, NSSZ size);
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


NSR AZRectInsideRectOnEdge(NSRect center, NSR outer, AZPOS position);

NSR AZRectOutsideRectOnEdge(NSRect center, NSR outer, AZPOS position);
NSR AZRectFlippedOnEdge(NSRect r, AZPOS position);

FOUNDATION_EXPORT NSR AZInsetRectInPosition ( NSR outside, NSSZ inset, AZPOS pos );

FOUNDATION_EXPORT AZPOS AZPosOfPointInInsetRects ( NSP point, NSR outside, NSSZ inset );
FOUNDATION_EXPORT BOOL  AZPointIsInInsetRects	( NSP point, NSR outside, NSSZ inset );

static inline AZInsetRects AZMakeInsideRects(NSRect rect, NSSZ inset) {

	 AZInsetRects rects = { AZUpperEdge( rect, inset.height ), AZRightEdge( rect, inset.width  ),
		  AZLowerEdge( rect, inset.height ), AZLeftEdge ( rect, inset.width  ) };
	return rects;
}

//FOUNDATION_EXPORT AZOutsideEdges AZOutsideEdgesSized(NSRect rect, NSSZ size);

//BOOL AZPointInOutsideEdgeOfRect(NSP point, NSR rect, NSSZ size);

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
BOOL	AZIsPointLeftOfRect  ( NSP point, NSR rect );
BOOL	AZIsPointRightOfRect ( NSP point, NSR rect );
BOOL	AZIsPointAboveRect   ( NSP point, NSR rect );
BOOL	AZIsPointBelowRect   ( NSP point, NSR rect );

BOOL	AZIsRectLeftOfRect   ( NSR rect, NSR compare );
BOOL	AZIsRectRightOfRect  ( NSR rect, NSR compare );
BOOL	AZIsRectAboveRect	( NSR rect, NSR compare );
BOOL	AZIsRectBelowRect	( NSR rect, NSR compare );

NSR	rectZoom 			 ( NSR rect,float zoom,int quadrant );
NSR 	AZSquareInRect 	 ( NSR rect );
NSR 	AZSizeRectInRect   ( NSR innerRect,NSR outerRect,bool expand );
NSP 	AZOffsetPoint 	 	 ( NSP fromPoint, NSP toPoint );
NSR 	AZFitRectInRect  	 ( NSR innerRect,NSR outerRect,bool expand );
NSR 	AZCenterRectInRect ( NSR rect, NSR mainRect );
NSR 	AZRectFromSize 	 ( NSSZ size );
//NSR rectWithProportion ( NSR innerRect,float proportion,bool expand );

NSR AZCornerRectPositionedWithSize(NSR outerRect, AZPOS pos, NSSZ sz);
//NSR 	sectionPositioned ( NSR r, AZPOS p );
int 	oppositeQuadrant ( int quadrant );
NSR 	quadrant ( NSR r, AZQuad quad );
NSR 	AZRectOfQuadInRect		  (NSR originalRect, AZQuad quad); //alias for quadrant

CGF 	quadrantsVerticalGutter   ( NSR r );
CGF	quadrantsHorizontalGutter ( NSR r );
NSR	constrainRectToRect 		  ( NSR innerRect, 	NSR outerRect );
NSR	alignRectInRect			  ( NSR innerRect,	NSR outerRect,	int quadrant );
//NSR expelRectFromRect ( NSR innerRect, NSR outerRect,float peek );
//NSR expelRectFromRectOnEdge ( NSR innerRect, NSR outerRect,NSREdge edge,float peek );

AZPOS AZPosAtCGRectEdge ( CGRectEdge edge );
CGRectEdge CGRectEdgeAtPosition ( AZPOS pos );

CGRectEdge AZEdgeTouchingEdgeForRectInRect ( NSR innerRect, NSR outerRect );
//AZPOS AZClosestCorner ( NSR innerRect,NSR outerRect );
QUAD 	AZOppositeQuadrant ( int quadrant );
NSR 	AZBlendRects ( NSR start, NSR end, CGF b );
void 	logRect ( NSR rect );
NSR	AZRandomRectInRect 	( CGRect rect );
NSR AZRandomRectInFrame		( CGRect rect );
CGP	AZRandomPointInRect ( CGRect rect );

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

NSR	NSRectFromTwoPoints	( const NSP a, const NSP b );
NSR	NSRectCentredOnPoint	( const NSP p, const NSSZ size );
NSR	AZUnionOfTwoRects		( const NSR a, const NSR b );
NSR	AZUnionOfRectsInSet		( const NSSet* aSet );
NSST*	AZDifferenceOfTwoRects ( const NSR a, const NSR b );
NSST*	AZSubtractTwoRects		( const NSR a, const NSR b );

BOOL	AZAreSimilarRects( const NSR a, const NSR b, const CGF epsilon );

CGF	AZPointFromLine		 ( const NSP inPoint, const NSP a, const NSP b );
NSP	AZNearestPointOnLine ( const NSP inPoint, const NSP a, const NSP b );
CGF	AZRelPoint				 ( const NSP inPoint, const NSP a, const NSP b );
NSI	AZPointInLineSegment ( const NSP inPoint, const NSP a, const NSP b );

NSP	AZBisectLine( const NSP a, const NSP b );
NSP	AZInterpolate( const NSP a, const NSP b, const CGF proportion);
CGF	AZLineLength( const NSP a, const NSP b );

CGF	AZSquaredLength( const NSP p );
NSP	AZDiffPoint( const NSP a, const NSP b );
CGF	AZDiffPointSquaredLength( const NSP a, const NSP b );
NSP	AZSumPoint( const NSP a, const NSP b );

NSP	AZEndPoint			( NSP origin, 	CGF angle, CGF length );
CGF	AZSlope				( const NSP a, const NSP b );
CGF	AZAngleBetween	( const NSP a, const NSP b, const NSP c );
CGF	AZDotProduct		( const NSP a, const NSP b );
NSP	AZIntersection	( const NSP aa, const NSP ab, const NSP ba, const NSP bb );
NSP	AZIntersection2	( const NSP p1, const NSP p2, const NSP p3, const NSP p4 );

NSR	AZCentreRectOnPoint		  ( const NSR inRect, const NSP p 	 );
NSP	AZMapPointFromRect		  ( const NSP p, 		 const NSR rect );
NSP	AZMapPointToRect			  ( const NSP p, 		 const NSR rect );
NSP	AZMapPointFromRectToRect ( const NSP p, 		 const NSR srcRect, const NSR destRect );
NSR	AZMapRectFromRectToRect  ( const NSR inRect, const NSR srcRect, const NSR destRect );

NSR	AZScaleRect			( const NSR  inRect, const CGF scale 	);
NSR	AZScaledRectForSize	( const NSSZ inSize, NSR const fitRect );
NSR	AZCentreRectInRect	( const NSR  r, 		const NSR cr 		);
NSBP*	AZRotatedRect			( const NSR  r,	 	const CGF radians );

NSR	AZNormalizedRect( const NSR r );

NSAffineTransform*	RotationTransform( const CGF radians, const NSP aboutPoint );

//NSP			PerspectiveMap( NSP inPoint, NSSZ sourceSize, NSP quad[4]);

NSP	NearestPointOnCurve( const NSP inp, const NSP bez[4], double* tValue );
NSP	Bezier( const NSP* v, const NSI degree, const double t, NSP* Left, NSP* Right );

CGF	BezierSlope( const NSP bez[4], const CGF t );

extern const NSP NSNotFoundPoint;


@interface AtoZGeometry:NSObject
@end


//ADBGeometry provides various functions for manipulating NSPoints, NSSizes and NSRects.

//The C brace is needed when including this header from an Objective C++ file
#if __cplusplus
extern "C" {
#endif

	#import <Foundation/Foundation.h>

	//Returns the nearest power of two that can accommodate the specified value
	NSInteger fitToPowerOfTwo(NSInteger value);

	//Returns the aspect ratio (width / height) for size. This will be 0 if either dimension was 0.
	CGFloat aspectRatioOfSize(NSSize size);
	
	//Returns the specified size scaled to match the specified aspect ratio, preserving either width or height.
	//Will return NSZeroSize if the aspect ratio is 0.
	NSSize sizeToMatchRatio(NSSize size, CGFloat aspectRatio, BOOL preserveHeight);

    //Returns the specified point with x and y snapped to the nearest integral values.
    NSPoint integralPoint(NSPoint point);
        
	//Returns the specified size with width and height rounded up to the nearest integral values.
	//Equivalent to NSIntegralRect. Will return NSZeroSize if width or height are 0 or negative.
	NSSize integralSize(NSSize size);

	//Returns whether the inner size is equal to or less than the outer size.
	//An analogue for NSContainsRect.
	BOOL sizeFitsWithinSize(NSSize innerSize, NSSize outerSize);

	//Returns innerSize scaled to fit exactly within outerSize while preserving aspect ratio.
	NSSize sizeToFitSize(NSSize innerSize, NSSize outerSize);

	//Same as sizeToFitSize, but will return innerSize without scaling up if it already fits within outerSize.
	NSSize constrainToFitSize(NSSize innerSize, NSSize outerSize);

	//Resize an NSRect to the target NSSize, using a relative anchor point: 
	//{0,0} is bottom left, {1,1} is top right, {0.5,0.5} is center.
	NSRect resizeRectFromPoint(NSRect theRect, NSSize newSize, NSPoint anchor);

	//Get the relative position ({0,0}, {1,1} etc.) of an NSPoint origin, relative to the specified NSRect.
	NSPoint pointRelativeToRect(NSPoint thePoint, NSRect theRect);

	//Align innerRect within outerRect relative to the specified anchor point: 
	//{0,0} is bottom left, {1,1} is top right, {0.5,0.5} is center.
	NSRect alignInRectWithAnchor(NSRect innerRect, NSRect outerRect, NSPoint anchor);

	//Center innerRect within outerRect. Equivalent to alignRectInRectWithAnchor of {0.5, 0.5}.
	NSRect centerInRect(NSRect innerRect, NSRect outerRect);
		
	//Proportionally resize innerRect to fit inside outerRect, relative to the specified anchor point.
	NSRect fitInRect(NSRect innerRect, NSRect outerRect, NSPoint anchor);
	
	//Same as fitInRect, but will return alignInRectWithAnchor instead if innerRect already fits within outerRect.
	NSRect constrainToRect(NSRect innerRect, NSRect outerRect, NSPoint anchor);
	
	
	//Clamp the specified point so that it fits within the specified rect.
	NSPoint clampPointToRect(NSPoint point, NSRect rect);
	
	//Calculate the delta between two points.
	NSPoint deltaFromPointToPoint(NSPoint pointA, NSPoint pointB);
	
	//Add/remove the specified delta from the specified starting point.
	NSPoint pointWithDelta(NSPoint point, NSPoint delta);
	NSPoint pointWithoutDelta(NSPoint point, NSPoint delta);

    
	
	//CG implementations of the above functions.
	BOOL CGSizeFitsWithinSize(CGSize innerSize, CGSize outerSize);
	
	CGSize CGSizeToFitSize(CGSize innerSize, CGSize outerSize);
    
    //Returns the specified point with x and y snapped to the nearest integral values.
    CGPoint CGPointIntegral(CGPoint point);
    
	//Returns the specified size with width and height rounded up to the nearest integral values.
	//Equivalent to CGRectIntegral. Will return CGSizeZero if width or height are 0 or negative.
	CGSize CGSizeIntegral(CGSize size);
//    
//    #pragma mark -
//    #pragma mark Debug logging
//        
//    #ifndef NSStringFromCGRect
//    #define NSStringFromCGRect(rect) NSStringFromRect(NSRectFromCGRect(rect))
//    #endif
//        
//    #ifndef NSStringFromCGSize
//    #define NSStringFromCGSize(size) NSStringFromSize(NSSizeFromCGSize(size))
//    #endif
//        
//    #ifndef NSStringFromCGPoint
//    #define NSStringFromCGPoint(point) NSStringFromPoint(NSPointFromCGPoint(point))
//    #endif
    
#if __cplusplus
} //Extern C
#endif
