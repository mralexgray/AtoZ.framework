

//#import <AtoZ/AZGrid.h>
//#import <AtoZ/AZMatrix.h>
//#import <AtoZ/AZPoint.h>
//#import <AtoZ/AZSize.h>
//#import <AtoZ/AZRect.h>
//#import <AtoZ/AZSegmentedRect.h>




// Predifined Points, Sizes and Rects
#define AZHalfPoint NSMakePoint ( .5, .5 )
#define  AZMaxPoint NSMakePoint ( MAXFLOAT, MAXFLOAT )
#define  AZHalfSize NSMakeSize 	( .5, .5 )
#define   AZMaxSize NSMakeSize  ( MAXFLOAT, MAXFLOAT )

#define AZRelationRect NSMakeRect ( 0, 0, 1, 1 )

/*! AZEqualRects(...) - Compare MANY rects. AZAllAreEqualRects(r2, r44, NSZeroRect), etc. */

#define AZEqualRects(...) (BOOL)_AZAllAreEqualRects(metamacro_argcount(__VA_ARGS__),__VA_ARGS__) //metamacro_head(__VA_ARGS__), metamacro_tail(__VA_ARGS__)))
/* helper */ BOOL _AZAllAreEqualRects(int ct,...);


OBJC_EXPORT NSR AZRectOffsetLikePoints(NSR r, NSP p1, NSP p2);
OBJC_EXPORT NSR AZRectResizedLikePointsInQuad(NSR frame, NSP point1, NSP point2, AZQuad quadrant);

OBJC_EXPORT BOOL            AZIsZeroSize( NSSZ z);
OBJC_EXPORT BOOL            AZIsZeroRect( NSR r);
OBJC_EXPORT  NSR  AZRectCheckWithMinSize( NSR r,     NSSZ    sz);
OBJC_EXPORT  NSR         AZTransformRect( NSR target, NSR model);
OBJC_EXPORT  NSR            nanRectCheck( NSR  r);
OBJC_EXPORT  NSP           nanPointCheck( NSP   p);
OBJC_EXPORT NSSZ            nanSizeCheck( NSSZ  s);
OBJC_EXPORT   id    	          nanCheck( NSV* point);

OBJC_EXPORT BOOL SameRect ( NSR r1, NSR r2 );

OBJC_EXPORT NSP AZAnchorPointInRect(CGP anch, NSR rect);
OBJC_EXPORT                   AZAP AZAnchorPointOfActualRect(NSR rect, AZA pos);
OBJC_EXPORT                   AZAP         AZAnchorPtAligned(AZA pos);

FOUNDATION_EXPORT const AZAnchorPt  AZAnchorTop,      AZAnchorBottom,     AZAnchorRight,    AZAnchorLeft, 
                                    AZAnchorTopLeft,  AZAnchorBottomLeft, AZAnchorTopRight, AZAnchorBottomRight,
                                    AZAnchorCenter;

OBJC_EXPORT const CGR CGRectOne;

OBJC_EXPORT NSP AZTopLeftPoint  ( NSR rect );
OBJC_EXPORT NSP AZTopRightPoint ( NSR rect );
OBJC_EXPORT NSP AZBotLeftPoint  ( NSR rect );
OBJC_EXPORT NSP AZBotRightPoint ( NSR rect );

/**	NSRange from a min and max values even though the names imply that min should be greater than max the order does not matter the range will always start at the lower value and have a size to reach the upper value **/
//NSRange AZMakeRange ( NSUI min, NSUI max );

#define AZDistanceBetween(A,B) AZPointDistance(A,B)
OBJC_EXPORT CGF     AZPointDistance ( CGP p1, CGP p2 );
OBJC_EXPORT CGF        AZPointAngle ( CGP p1, CGP p2 );
OBJC_EXPORT CGF AZDistanceFromPoint ( NSP p1, NSP p2 );

OBJC_EXPORT NSP	    AZPointOffsetBy	( NSP p, CGF x, CGF y);
OBJC_EXPORT NSP       AZPointOffset ( NSP p, NSP size );
OBJC_EXPORT NSP      AZPointOffsetY ( NSP p, CGF dist );
OBJC_EXPORT NSP      AZPointOffsetX ( NSP p, CGF dist );

OBJC_EXPORT int GCD ( int a, int b );
OBJC_EXPORT BOOL isWhole ( CGF fl );

OBJC_EXPORT NSI AZLowestCommonDenominator ( int a, int b );

OBJC_EXPORT NSS * AZAspectRatioString ( CGF ratio );
OBJC_EXPORT CGF   AZAspectRatioOf ( CGF width, CGF height );
OBJC_EXPORT CGF   AZAspectRatioForSize ( NSSZ size );

// Simple Length and Area calculus

OBJC_EXPORT CGF AZPerimeter ( NSR rect );
OBJC_EXPORT CGF AZPerimeterWithRoundRadius  ( NSR rect, CGF radius );

OBJC_EXPORT AZPOS                           AZPositionOpposite(AZPOS pos);
OBJC_EXPORT AZPOS AZPositionOfEdgeAtOffsetAlongPerimeterOfRect(CGF off, NSR r);
OBJC_EXPORT   CGP          AZPointAtOffsetAlongPerimeterOfRect(CGF off, NSR r);  //from bottom left going counterclockwise
OBJC_EXPORT AZPOS        AZPositionOfRectPinnedToOutisdeOfRect(NSR box, NSR innerBox  );
OBJC_EXPORT   AZA                        AZAlignmentInsideRect(NSR inner, NSR outer);
OBJC_EXPORT   AZA AZAlignNext(AZA a);

//NS_INLINE BOOL AZAlignIsCorner(AZA a){ AZA r; int ctr;
//
//  for(ctr = 0, r = AZAUnset; r; (AZA)(r<<=1)) if(r&a) ctr++;  return ctr == 1;
//}

//Includes corner preciion based on inner rect size;
OBJC_EXPORT AZPOS AZPositionOfRectAtOffsetInsidePerimeterOfRect(NSR inner, CGF offset, NSR outer);
OBJC_EXPORT AZPOS AZPositionOfQuadInRect ( NSR rect, NSR outer );
OBJC_EXPORT AZPOS AZOutsideEdgeOfRectInRect (NSR rect, NSR outer );

OBJC_EXPORT AZPOS AZOutsideEdgeOfPointInRect (NSP inside, NSR outer );

OBJC_EXPORT AZPOS AZPositionAtPerimeterInRect ( NSR edgeBox, NSR outer );
OBJC_EXPORT NSSZ  AZDirectionsOffScreenWithPosition ( NSR rect, AZPOS position );

OBJC_EXPORT AZOrient deltaDirectionOfPoints ( NSP a, NSP b );

OBJC_EXPORT NSR  AZScreenFrame ( void );
OBJC_EXPORT NSSZ AZScreenSize  ( void );
OBJC_EXPORT NSR  AZScreenFrameUnderMenu ( void );

OBJC_EXPORT CGF AZMinEdge ( NSR r );
OBJC_EXPORT CGF AZMaxEdge ( NSR r );
OBJC_EXPORT CGF AZMaxDim ( NSSZ sz );
OBJC_EXPORT CGF AZMinDim ( NSSZ sz );

//OBJC_EXPORT CGF AZLengthOfPoint ( NSP  p );
OBJC_EXPORT CGF    AZAreaOfSize ( NSSZ s );
OBJC_EXPORT CGF    AZAreaOfRect ( NSR  r );
// Size -> Point conversion
OBJC_EXPORT NSP AZPointFromSize ( NSSZ size );
OBJC_EXPORT CGF AZMenuBarH (void) ;
// NSP result methods
OBJC_EXPORT NSP AZOriginFromMenubarWithX ( CGF yOffset, CGF xOffset );
// returns the absolute values of a point  ( pt.x >= 0, pt.y >= 0)
OBJC_EXPORT NSP AZAbsPoint ( NSP point );
// floor, ceil and round simply use those functions on both values of the point
OBJC_EXPORT NSP AZFloorPoint ( NSP point );
OBJC_EXPORT NSP AZCeilPoint ( NSP point );
OBJC_EXPORT NSP AZRoundPoint ( NSP point );
// pt.x = -pt.x, pt.y = -pt.x
OBJC_EXPORT NSP AZNegatePoint ( NSP point );
// pt.x = 1 / pt.x, pt.y = 1 / pt.y
OBJC_EXPORT NSP AZInvertPoint ( NSP point );
// exchanges both x and y values
OBJC_EXPORT NSP AZSwapPoint ( NSP point );
// sum of two points
OBJC_EXPORT NSP AZAddPoints ( NSP one, NSP another );
// subtracts the 2nd from the 1st point
OBJC_EXPORT NSP AZSubtractPoints ( NSP origin, NSP subtrahend );
// sums a list of points
OBJC_EXPORT NSP AZSumPoints ( NSUI count, NSP points, ... );
// multiplies both x and y with one multiplier
OBJC_EXPORT NSP AZMultiplyPoint ( NSP point, CGF multiplier );
// multiplies each value with its corresponding value in another point
OBJC_EXPORT NSP AZMultiplyPointByPoint ( NSP one, NSP another );
// multiplies each value with its corresponding value in a size
OBJC_EXPORT NSP AZMultiplyPointBySize ( NSP one, NSSZ size );
// positions a relative {0-1,0-1} point within absolute bounds
OBJC_EXPORT NSP AZRelativeToAbsolutePoint ( NSP relative, NSR bounds );
// calculates the relative {0-1,0-1} point from absolute bounds
OBJC_EXPORT NSP AZAbsoluteToRelativePoint ( NSP absolute, NSR bounds );
OBJC_EXPORT NSP AZDividePoint ( NSP point, CGF divisor );
OBJC_EXPORT NSP AZDividePointByPoint ( NSP point, NSP divisor );
OBJC_EXPORT NSP AZDividePointBySize ( NSP point, NSSZ divisor );

// moves from an origin towards the destination point
// at a distance of 1 it will reach the destination
OBJC_EXPORT NSP AZMovePoint ( NSP origin, NSP target, CGF relativeDistance );

// moves from an origin towards the destination point
// distance on that way is measured in pixels
OBJC_EXPORT NSP AZMovePointAbs ( NSP origin, NSP target, CGF pixels );

// returns the center point of a rect
OBJC_EXPORT NSP AZCenterOfRect ( NSR rect );

// returns the center point of a size
OBJC_EXPORT NSP AZCenterOfSize ( NSSZ size );

// will return the origin + size value of a rect
OBJC_EXPORT NSP AZEndOfRect ( NSR rect );

/*! Returns the average distance of two rects

     +-------+
     |	     |
     |   a   |   +-------+
     |	     |   |	     |
     +-------+   |   b   |
    		         |	     |
 		  	         +-------+    
*/
OBJC_EXPORT NSP AZCenterDistanceOfRects ( NSR from, NSR to );

// will return the shortest possible distance in x and y
OBJC_EXPORT NSP AZBorderDistanceOfRects ( NSR from, NSR to );



OBJC_EXPORT NSP AZPointClosestOnRect ( NSP point, NSR rect );

// will return the shortes possible distance from point to rect
OBJC_EXPORT NSP AZPointDistanceToBorderOfRect ( NSP point, NSR rect );

OBJC_EXPORT NSP AZNormalizedDistanceOfRects ( NSR from, NSR to );
OBJC_EXPORT NSP AZNormalizedDistanceToCenterOfRect ( NSP point, NSR rect );

OBJC_EXPORT NSP AZPointFromDim ( CGF val );
/*! NSSZ result methods  */
// converts a float to a rect of equal sized sizes of dim;
OBJC_EXPORT NSR AZRectFromDim ( CGF dim );

OBJC_EXPORT NSP AZPt(CGF x, CGF y);

//  Makes Rect 0, 0, boundsX, boundsY  easy syntax AZRectBy ( 200,233)
OBJC_EXPORT NSR AZRectBy ( CGF boundX, CGF boundY );

// MaxX, MaxY point of Rect
OBJC_EXPORT NSP AZRectApex(NSR r);

// converts a float to a size;
OBJC_EXPORT NSSZ AZSizeFromDim ( CGF dim );

// Scale a size by factor.
OBJC_EXPORT NSSZ	AZScaleSize   (const NSSZ  sz, const CGF scale);

// converts a point to a size
OBJC_EXPORT NSSZ AZSizeFromPoint ( NSP point );
OBJC_EXPORT NSSZ 	AZSizeFromRect	(NSR rect);
// ABS on both values of the size
OBJC_EXPORT NSSZ AZAbsSize ( NSSZ size );

// Adds the width and height of two sizes
OBJC_EXPORT NSSZ AZAddSizes ( NSSZ one, NSSZ another );

// subtracts the subtrahends dimensions from the ones of the size
OBJC_EXPORT NSSZ AZSubtractSizes ( NSSZ size, NSSZ subtrahend );

// returns 1 / value on both values of the size
OBJC_EXPORT NSSZ AZInvertSize ( NSSZ size );

// will return the ratio of an inner size to an outer size
OBJC_EXPORT NSSZ AZRatioOfSizes ( NSSZ inner, NSSZ outer );

OBJC_EXPORT NSSZ AZMultiplySize( NSSZ size, CGF multiplier );

// will multiply a size by a single multiplier
OBJC_EXPORT NSSZ AZMultiplySizeBy( NSSZ size, CGF multiplier );
//NSSZ AZMultiplySize ( NSSZ size, CGF multiplier );

// will multiply a size by another size
OBJC_EXPORT NSSZ AZMultiplySizeBySize ( NSSZ size, NSSZ another );

// will multiply a size by a point
OBJC_EXPORT NSSZ AZMultiplySizeByPoint ( NSSZ size, NSP point );

// blends one size towards another
// percentage == 0 -> one
// percentage == 1 -> another
// @see AZMovePoint
OBJC_EXPORT NSSZ AZBlendSizes ( NSSZ one, NSSZ another, CGF percentage );

OBJC_EXPORT NSSZ AZSizeMax ( NSSZ one, NSSZ another );
OBJC_EXPORT NSSZ AZSizeMin ( NSSZ one, NSSZ another );
OBJC_EXPORT NSSZ AZSizeBound ( NSSZ preferred, NSSZ minSize, NSSZ maxSize );
// NSR result methods
OBJC_EXPORT NSR AZZeroHeightBelowMenu ( void );

OBJC_EXPORT NSR AZFlipRectinRect ( CGRect local, CGRect dest );

OBJC_EXPORT CGF AZMenuBarThickness  ( void );

OBJC_EXPORT NSR AZMenuBarFrame ( void );

OBJC_EXPORT NSR AZRectOffsetBy        (CGR rect, CGF x, CGF y);
OBJC_EXPORT NSR AZRectOffsetBySize    (CGR rect, CGSZ sz);
OBJC_EXPORT NSR	AZRectResizedBySize		(CGR rect, CGSZ sz);
OBJC_EXPORT NSR AZRectOffsetByPt      (CGR rect, NSP pt);
OBJC_EXPORT NSR AZRectOffsetFromDim   (CGR rect, CGF xyDistance);

OBJC_EXPORT NSR AZRectVerticallyOffsetBy (CGR rect, CGF offset );
OBJC_EXPORT NSR AZRectHorizontallyOffsetBy ( CGRect rect, CGF offset );

OBJC_EXPORT NSR AZMenulessScreenRect ( void );

OBJC_EXPORT NSR AZMakeRectMaxXUnderMenuBarY ( CGF distance );

OBJC_EXPORT CGF AZHeightUnderMenu ( void );
OBJC_EXPORT NSR AZSquareFromLength ( CGF length );

// returns a zero sized rect with the argumented point as origin
OBJC_EXPORT NSR AZMakeRectFromPoint ( NSP point );

// returns a zero point origin with the argumented size
OBJC_EXPORT NSR AZMakeRectFromSize ( NSSZ size );

// just another way of defining a rect
OBJC_EXPORT NSR AZMakeRect ( NSP point, NSSZ size );

// creates a square rect around a center point
OBJC_EXPORT NSR AZMakeSquare ( NSP center, CGF radius );

OBJC_EXPORT NSR AZMultiplyRectBySize ( NSR rect, NSSZ size );

// transforms a relative rect to an absolute within absolute bounds
OBJC_EXPORT NSR AZRelativeToAbsoluteRect ( NSR relative, NSR bounds );

// transforms an absolute rect to a relative rect within absolute bounds
OBJC_EXPORT NSR AZAbsoluteToRelativeRect ( NSR absolute, NSR bounds );

OBJC_EXPORT NSR AZPositionRectOnRect ( NSR inner, NSR outer, NSP position );

enum CAAutoresizingMask AZPositionToAutoresizingMask (AZPOS p);

OBJC_EXPORT NSR AZRectWithDimsCenteredOnPoints(CGF width, CGF heigt, CGF cx, CGF cy);  /** NICE **/

// moves the origin of the rect
OBJC_EXPORT NSR AZCenterRectOnPoint ( NSR rect, NSP center );

// returns the innter rect with its posiion centeredn on the outer rect
OBJC_EXPORT NSR AZCenterRectOnRect ( NSR inner, NSR outer );

OBJC_EXPORT NSR AZConstrainRectToRect(NSR innerRect, NSR outerRect);

// will a square rect with a given center
OBJC_EXPORT NSR AZSquareAround ( NSP center, CGF distance );

// blends a rect from one to another
OBJC_EXPORT NSR AZBlendRects ( NSR from, NSR to, CGF at );

// Croped Rects

OBJC_EXPORT NSR AZRectTrimmedOnRight ( NSR rect, CGF width );
OBJC_EXPORT NSR AZRectTrimmedOnBottom ( NSR rect, CGF height );
OBJC_EXPORT NSR AZRectTrimmedOnLeft ( NSR rect, CGF width );
OBJC_EXPORT NSR AZRectTrimmedOnTop ( NSR rect, CGF height );

OBJC_EXPORT NSSZ AZSizeExceptWide  ( NSSZ sz, CGF wide );
OBJC_EXPORT NSSZ AZSizeExceptHigh  ( NSSZ sz, CGF high );

OBJC_EXPORT NSR AZRectExtendedOnLeft(NSR rect, CGF amount);
OBJC_EXPORT NSR AZRectExtendedOnBottom(NSR rect, CGF amount);
OBJC_EXPORT NSR AZRectExtendedOnTop(NSR rect, CGF amount);
OBJC_EXPORT NSR AZRectExtendedOnRight(NSR rect, CGF amount);

OBJC_EXPORT NSR 	AZRectExceptSize (NSR rect, NSSZ size);
FOUNDATION_EXPORT NSR AZRectExceptWide  ( NSR rect, CGF wide );
FOUNDATION_EXPORT NSR AZRectExceptHigh  ( NSR rect, CGF high );
FOUNDATION_EXPORT NSR AZRectExceptOriginX  ( NSR rect, CGF x );
FOUNDATION_EXPORT NSR AZRectExceptOriginY  ( NSR rect, CGF y );
FOUNDATION_EXPORT NSR	AZRectExceptOrigin	(NSR r, NSP origin);

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


OBJC_EXPORT NSR AZRectInsideRectOnEdge(NSRect center, NSR outer, AZPOS position);
OBJC_EXPORT NSR AZRectOutsideRectOnEdge(NSRect center, NSR outer, AZPOS position);
OBJC_EXPORT NSR AZRectFlippedOnEdge(NSRect r, AZPOS position);

FOUNDATION_EXPORT NSR AZInsetRectInPosition ( NSR outside, NSSZ inset, AZPOS pos );

FOUNDATION_EXPORT AZPOS AZPosOfPointInInsetRects ( NSP point, NSR outside, NSSZ inset );

/* Is point "point" within edges of "rect" within inset of size? */ /* UNIT TESTS OK */
FOUNDATION_EXPORT BOOL  AZPointIsInInsetRects	(NSP innerPoint, NSR outerRect, NSSZ size);

typedef struct AZInsetRects {	NSR top; NSR right; NSR bottom;	NSR left; } AZInsetRects;

/*!  +-------+------------------+-------+
     |	     |        T         |       |             
     |=======+==================+=======+        +-------+
     |	     |                  |	      |        | sizes |
     |	     |                  |	      |        +-------+
     |	 L   |                  |	  R   |
     |	     |     INSIDE       |	      |     
     |	     |                  |	      |
     |	     |                  |	      |
     |=======+==================+=======+
     |	     |        B         |       |
     +-------+------------------+-------+    */

NS_INLINE AZInsetRects AZMakeInsideRects(NSRect rect, NSSZ inset) {

 return  (AZInsetRects){ AZUpperEdge(rect, inset.height), AZRightEdge(rect, inset.width),
                         AZLowerEdge(rect, inset.height),  AZLeftEdge(rect, inset.width)}; 
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
OBJC_EXPORT BOOL AZIsPointLeftOfRect  ( NSP point, NSR rect );
OBJC_EXPORT BOOL AZIsPointRightOfRect ( NSP point, NSR rect );
OBJC_EXPORT BOOL AZIsPointAboveRect   ( NSP point, NSR rect );
OBJC_EXPORT BOOL AZIsPointBelowRect   ( NSP point, NSR rect );

OBJC_EXPORT BOOL AZIsRectLeftOfRect   ( NSR rect, NSR compare );
OBJC_EXPORT BOOL AZIsRectRightOfRect  ( NSR rect, NSR compare );
OBJC_EXPORT BOOL AZIsRectAboveRect	( NSR rect, NSR compare );
OBJC_EXPORT BOOL AZIsRectBelowRect	( NSR rect, NSR compare );

OBJC_EXPORT NSR rectZoom 			 ( NSR rect,float zoom,int quadrant );
OBJC_EXPORT NSR 	AZSquareInRect      (NSR rect );
OBJC_EXPORT NSR 	AZSizeRectInRect    (NSR innerRect,NSR outerRect,bool expand );
OBJC_EXPORT NSP 	AZOffsetPoint       (NSP fromPoint, NSP toPoint );
OBJC_EXPORT NSR 	AZFitRectInRect     (NSR innerRect,NSR outerRect,bool expand );
OBJC_EXPORT NSR 	AZCenterRectInRect  (NSR rect, NSR mainRect );
OBJC_EXPORT NSR 	AZRectFromSize      (NSSZ size );
OBJC_EXPORT NSR	AZRectFromSizeOfRect  (NSR rect);
//NSR rectWithProportion ( NSR innerRect,float proportion,bool expand );

OBJC_EXPORT NSR AZRectInsideRectOnEdgeInset (NSR rect, AZA side, CGF inset );
OBJC_EXPORT NSR AZCornerRectPositionedWithSize(NSR outerRect, AZPOS pos, NSSZ sz);
//NSR 	sectionPositioned ( NSR r, AZPOS p );
OBJC_EXPORT int 	oppositeQuadrant ( int quadrant );
OBJC_EXPORT NSR 	quadrant ( NSR r, AZQuad quad );
OBJC_EXPORT NSR 	AZRectOfQuadInRect		  (NSR originalRect, AZQuad quad); //alias for quadrant

OBJC_EXPORT CGF 	quadrantsVerticalGutter   ( NSR r );
OBJC_EXPORT CGF quadrantsHorizontalGutter ( NSR r );
OBJC_EXPORT NSR constrainRectToRect 		  ( NSR innerRect, 	NSR outerRect );
OBJC_EXPORT NSR alignRectInRect			  ( NSR innerRect,	NSR outerRect,	int quadrant );
//NSR expelRectFromRect ( NSR innerRect, NSR outerRect,float peek );
//NSR expelRectFromRectOnEdge ( NSR innerRect, NSR outerRect,NSREdge edge,float peek );

OBJC_EXPORT AZPOS AZPosAtCGRectEdge ( CGRectEdge edge );
OBJC_EXPORT CGRectEdge CGRectEdgeAtPosition ( AZPOS pos );

OBJC_EXPORT CGRectEdge AZEdgeTouchingEdgeForRectInRect ( NSR innerRect, NSR outerRect );
AZPOS AZClosestCorner (NSR r,NSP pt);
OBJC_EXPORT QUAD 	AZOppositeQuadrant ( int quadrant );
OBJC_EXPORT NSR 	AZBlendRects ( NSR start, NSR end, CGF b );
OBJC_EXPORT void 	logRect ( NSR rect );
OBJC_EXPORT NSR AZRandomRectInRect 	( CGRect rect );
OBJC_EXPORT NSR AZRandomRectInFrame		( CGRect rect );
OBJC_EXPORT CGP AZRandomPointInRect ( CGRect rect );

/** Returns the center point of a CGRect. */
NS_INLINE CGP AZCenter(CGR r){ return CGPointMake( CGRectGetMidX(r),CGRectGetMidY(r)); }

//typedef struct _BTFloatRange { 	float value;	float location; 	float length; } BTFloatRange;
//BTFloatRange BTMakeFloatRange ( float value,float location,float length );
//float BTFloatRangeMod ( BTFloatRange range );
//float BTFloatRangeUnit ( BTFloatRange range );

//NSP AZRectOffset ( NSR innerRect, NSR outerRect, QUAD quadrant );

OBJC_EXPORT NSR        AZRectOffset(NSR r, NSP ptOff);
OBJC_EXPORT NSR NSRectFromTwoPoints	( const NSP a, const NSP b );
OBJC_EXPORT NSR NSRectCentredOnPoint	( const NSP p, const NSSZ size );
OBJC_EXPORT NSR AZUnionOfTwoRects		( const NSR a, const NSR b );
OBJC_EXPORT NSR AZUnionOfRectsInSet		( const NSSet* aSet );
OBJC_EXPORT NSST* AZDifferenceOfTwoRects ( const NSR a, const NSR b );
OBJC_EXPORT NSST* AZSubtractTwoRects		( const NSR a, const NSR b );

OBJC_EXPORT BOOL AZAreSimilarRects( const NSR a, const NSR b, const CGF epsilon );

OBJC_EXPORT CGF AZPointFromLine		 ( const NSP inPoint, const NSP a, const NSP b );
OBJC_EXPORT NSP AZNearestPointOnLine ( const NSP inPoint, const NSP a, const NSP b );
OBJC_EXPORT CGF AZRelPoint				 ( const NSP inPoint, const NSP a, const NSP b );
OBJC_EXPORT NSI AZPointInLineSegment ( const NSP inPoint, const NSP a, const NSP b );

OBJC_EXPORT NSP AZBisectLine( const NSP a, const NSP b );
OBJC_EXPORT NSP AZInterpolate( const NSP a, const NSP b, const CGF proportion);
OBJC_EXPORT CGF AZLineLength( const NSP a, const NSP b );

OBJC_EXPORT CGF AZSquaredLength( const NSP p );
OBJC_EXPORT NSP AZDiffPoint( const NSP a, const NSP b );
OBJC_EXPORT CGF AZDiffPointSquaredLength( const NSP a, const NSP b );
OBJC_EXPORT NSP AZSumPoint( const NSP a, const NSP b );

OBJC_EXPORT NSP AZEndPoint			( NSP origin, 	CGF angle, CGF length );
OBJC_EXPORT CGF AZSlope				( const NSP a, const NSP b );
OBJC_EXPORT CGF AZAngleBetween	( const NSP a, const NSP b, const NSP c );
OBJC_EXPORT CGF AZDotProduct		( const NSP a, const NSP b );
OBJC_EXPORT NSP AZIntersection	( const NSP aa, const NSP ab, const NSP ba, const NSP bb );
OBJC_EXPORT NSP AZIntersection2	( const NSP p1, const NSP p2, const NSP p3, const NSP p4 );

OBJC_EXPORT NSR AZCentreRectOnPoint		  ( const NSR inRect, const NSP p 	 );
OBJC_EXPORT NSP AZMapPointFromRect		  ( const NSP p, 		 const NSR rect );
OBJC_EXPORT NSP AZMapPointToRect			  ( const NSP p, 		 const NSR rect );
OBJC_EXPORT NSP AZMapPointFromRectToRect ( const NSP p, 		 const NSR srcRect, const NSR destRect );
OBJC_EXPORT NSR AZMapRectFromRectToRect  ( const NSR inRect, const NSR srcRect, const NSR destRect );

OBJC_EXPORT NSR AZRectExceptSpanAnchored(NSR r1, CGF span, AZA anchor);
OBJC_EXPORT NSR         AZScaleRect	( const NSR  inRect, const CGF scale 	);
OBJC_EXPORT NSR AZRectScaledToRect(NSR resizeRect, NSR fitRect);
OBJC_EXPORT NSR  AZCentreRectInRect	( const NSR  r, 		const NSR cr 		);
OBJC_EXPORT NSBP *    AZRotatedRect ( const NSR  r,	 	const CGF radians );

OBJC_EXPORT NSR AZNormalizedRect( const NSR r );

OBJC_EXPORT _AffT AZRotationTransform( const CGF radians, const NSP aboutPoint );

OBJC_EXPORT NSP AZNearestPointOnCurve( const NSP inp, const NSP bez[4], double* tValue );
OBJC_EXPORT NSP AZBezier( const NSP* v, const NSI degree, const double t, NSP* Left, NSP* Right );

OBJC_EXPORT CGF AZBezierSlope( const NSP bez[4], const CGF t );

//NSP			PerspectiveMap( NSP inPoint, NSSZ sourceSize, NSP quad[4]);
//extern const NSP NSNotFoundPoint;


//ADBGeometry provides various functions for manipulating NSPoints, NSSizes and NSRects.

#if __cplusplus // The C brace is needed when including this header from an Objective C++ file
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
//    #pragma mark - Debug logging
//    #ifndef NSStringFromCGRect
//    #define NSStringFromCGRect(rect) NSStringFromRect(NSRectFromCGRect(rect))
//    #endif
//    #ifndef NSStringFromCGSize
//    #define NSStringFromCGSize(size) NSStringFromSize(NSSizeFromCGSize(size))
//    #endif
//    #ifndef NSStringFromCGPoint
//    #define NSStringFromCGPoint(point) NSStringFromPoint(NSPointFromCGPoint(point))
//    #endif
    
#if __cplusplus
} //Extern C
#endif


/*
@protocol AZScalar <NSObject>
@required 
@prop_RO NSS *key1, *key2;
@concrete
@prop_RO   CGF   min, max;
@end

@interface AZPoint : NSObject <AZScalar>

@property (NA) NSP point;
@property (NA) CGF x, y;

@end

@interface AZSize : NSObject  <AZScalar>
@property (NA) CGF 	width, height;
@property (NA) NSSZ  size;
@end
*/

//OBJC_EXPORT NSN *iNum (NSI	  i);
//OBJC_EXPORT NSN *uNum (NSUI  ui);
//OBJC_EXPORT NSN *fNum (CGF   	f);
//OBJC_EXPORT NSN *dNum (double d);

//@class AZSize, AZRect, AZGrid, AGMatrix; //  <NSCoding>
//typedef void(^KVOChange)(id _self, id  oldVal);
//@property (CP) KVOChange onMove;

//  AZGeometricFunctions.h Lumumba

//  Created by Benjamin Schüttler on 19.11.09.  Copyright 2011 Rogue Coding. All rights reserved.



/// From AtoZAAPpKit

CGFloat AZDistanceBetweenPoints(NSPoint point1, NSPoint point2);
CGFloat AZDistancePointToLine(NSPoint point, NSPoint lineStartPoint, NSPoint lineEndPoint);
NSPoint AZLineNormal(NSPoint lineStart, NSPoint lineEnd);
NSPoint AZLineMidpoint(NSPoint lineStart, NSPoint lineEnd);

NSPoint FBAddPoint(NSPoint point1, NSPoint point2);
NSPoint FBScalePoint(NSPoint point, CGFloat scale);
NSPoint FBUnitScalePoint(NSPoint point, CGFloat scale);
NSPoint FBSubtractPoint(NSPoint point1, NSPoint point2);
CGFloat FBDotMultiplyPoint(NSPoint point1, NSPoint point2);
CGFloat FBPointLength(NSPoint point);
CGFloat FBPointSquaredLength(NSPoint point);
NSPoint FBNormalizePoint(NSPoint point);
NSPoint FBNegatePoint(NSPoint point);
NSPoint FBRoundPoint(NSPoint point);

BOOL AZArePointsClose(NSPoint point1, NSPoint point2);
BOOL AZArePointsCloseWithOptions(NSPoint point1, NSPoint point2, CGFloat threshold);
BOOL AZAreValuesClose(CGFloat value1, CGFloat value2);
BOOL AZAreValuesCloseWithOptions(CGFloat value1, CGFloat value2, CGFloat threshold);
