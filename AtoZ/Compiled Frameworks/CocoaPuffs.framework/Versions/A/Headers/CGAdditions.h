/**
 
 \file      CGAdditions.h
 
 \brief     Adds a number of functions to facilitate working with CoreGraphics.
 
 \details   Many of the functions that are added by CGAdditions allow a more
            functional programming style, which avoids explicit intermediate
            variables and yields, in my opinion, cleaner code.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <QuartzCore/QuartzCore.h>

/// ----------------------------------------------------------------------------
/// # Additions for CGPoint 
/// ----------------------------------------------------------------------------

/**
 
 CGPointOffset
 
 \brief  Returns `p` translated by (`dx`,`dy`).
 
 \param  in  p   point to be offset.
 \param  in  dx  offset on the x coordinate.
 \param  in  dy  offset on the y coordinate.
 
 \return         {p.x + dx, p.y + dy}
 
 */
CGPoint CGPointOffset(CGPoint p, CGFloat dx, CGFloat dy);


/**
 
 CGPointDiff
 
 \brief  Returns `p` - `q`.
 
 \param  in  p   reference point.
 \param  in  q   value to subtract.
 
 \return         {p.x - q.x, p.y - q.y}
 
 */
CGPoint CGPointDiff(CGPoint p, CGPoint q);

/**
 
 CGPointAdd
 
 \brief  Returns `p` + `q`.
 
 \param  in  p   reference point.
 \param  in  q   value to add.
 
 \return         {p.x + q.x, p.y + q.y}
 
 */
CGPoint CGPointAdd(CGPoint p, CGPoint q);


/**
 
 \brief     Returns the angle between two points using the x-axis as the reference.

 \details   If the angle cannot be computed then defaultValue is returned.
            The only reason the angle could not be computed is if a and b
            coincide or are very close together.
 
            The return value is in the range 0..2pi.
 
 */
CGFloat CGPointAngleWithPoint(CGPoint a, CGPoint b, CGFloat defaultValue);


/**
 
 \brief     Returns a point after having applied a CATransform3D.
 
 \details   Only the affine aspect of the transform is applied.
 
 */
CGPoint CGPointAfterTransform(CGPoint p, CGPoint origin, CATransform3D transform);
CGPoint CGPointAfterInverseTransform(CGPoint p, CGPoint origin, CATransform3D transform);


/**
 
 \brief     Returns the distance between two points.
 
 */
double CGPointDistance(CGPoint a, CGPoint b);

/**
 
 \brief     Returns the point where each component has been scaled.
 
 */
CGPoint CGPointScale(CGPoint a, double scale);


/// ----------------------------------------------------------------------------
/// # Additions for CGSize 
/// ----------------------------------------------------------------------------

/**
 
 CGSizeMax
 
 \brief Returns a CGSize value where both width and height are the largest
        width and heights, respectively, of `a` and `b`.
 
 \param  in  a   first size parameter.
 \param  in  b   second size parameter.

 \return { max(a.width, a.height), max(a.height, b.height) }
 
 */
CGSize CGSizeMax(CGSize a, CGSize b);


/// ----------------------------------------------------------------------------
/// # Additions for CGRect
/// ----------------------------------------------------------------------------

/**
 
 CGRectInsetTRBL
 
 \brief  Returns an inset rectangle with insets specified for each side.
 
 \param  in  rect   rectangle to be inset.
 \param  in  t      inset for the top of the rectangle.
 \param  in  r      inset for the right of the rectangle.
 \param  in  b      inset for the bottom of the rectangle.
 \param  in  l      inset for the left of the rectangle.
 
 \return an inset rectangle.
 
 */
CGRect CGRectInsetTRBL(CGRect rect, CGFloat t, CGFloat r, CGFloat b, CGFloat l);

/**
 
 CGRectWithPoints
 
 \brief  Returns a normalized rectangle where `a` and `b` are two of its corners.
 
 \details Unless you want a zero-width or zero height rectangle, `a` and `b` should
          be two opposing corners along the diagonal of the rectangle.
 
 \param  in  a  one of the corners.
 \param  in  b  the other corner.
 
 \return a rectangle where `a` and `b` are two of its corners.
 
 */
CGRect CGRectWithPoints(CGPoint a, CGPoint b);

/**
 
 CGRectWithOriginAndSize
 
 \brief  A functional equivalent to declaring and initializing a rect structure.
 
 \param  in  origin  origin of the rectangle.
 \param  in  size    size of the rectangle.
 
 \return { origin, size }
 
 */
CGRect CGRectWithOriginAndSize(CGPoint origin, CGSize size);

/**
 
 CGRectWalkGrid
 
 \brief  Calls the provided block once for every sub-rectangle in a grid.
 
 \details The given rectangle is divided into a `rows` x `columns` grid and 
          then the block is called for each sub-rectangle with its relative
          position.
          
 \param  in  rect       rectangle to be divided.
 \param  in  rows       number of rows in the grid.
 \param  in  columns    number of columns in the grid.
 \param  in  callback   block to be called once for each region in the  grid.
 
 */
void CGRectWalkGrid(CGRect rect, int rows, int columns, void(^callback)(CGRect rect, int row, int col));


/**
 
 CGRectCenterInRect
 
 \brief   Aligns the middle of `rect` with the middle of `refRect`.
 
 \param  in  refRect    reference rectangle used to align `rect`.
 \param  in  rect       rect whose middle point should coincide with refRect.
 
 \return a rectangle whose middle point is aligned with `refRect` but has 
         the width and height of `rect`.
 
 */
CGRect CGRectCenterInRect(CGRect refRect, CGRect rect);
CGRect CGRectCenterVerticallyInRect(CGRect refRect, CGRect rect);
CGRect CGRectCenterHorizontallyInRect(CGRect refRect, CGRect rect);

/**
 
 \brief     Returns the top left corner of the rectangle.

 \details   If flipped is false then the rectangle origin is assumed to be the 
            bottom left corner. Otherwise it is the top left corner. 
 
 \param     in  rect      standardized rect (see CGRectStandardize).
 
 \return    one of the corners of the rectangle.
 
 */
CGPoint CGRectCornerTL(CGRect rect, BOOL flipped);
CGPoint CGRectCornerTR(CGRect rect, BOOL flipped);
CGPoint CGRectCornerBR(CGRect rect, BOOL flipped);
CGPoint CGRectCornerBL(CGRect rect, BOOL flipped);
CGPoint CGRectCorner(CGRect rect, BOOL isBottom, BOOL isLeft, BOOL flipped);

/**
 
 \brief     Returns the middle point of the rectangle;
 
 */
CGPoint CGRectCenter(CGRect rect);


/**
 
 \brief     Returns a relative point within the rectangle.
 
 \details   The relative position should be normalized point where
            0,0 meas the rectangle origin and 1,1 its opposing corner.
 
 */
CGPoint CGRectRelativePoint(CGRect rect, CGPoint relPos);


/**
 
 \brief     Returns the normalized position of p with respect to rect.
 
 */
CGPoint CGRectNormalizedPosition(CGRect rect, CGPoint p);


/// ----------------------------------------------------------------------------
/// # Additions for CGPath
/// ----------------------------------------------------------------------------

/**
 
 CGPathCreateWithRectAnd4CornerRadius
 
 \brief  Creates a CGPathRef for a rectangle with rounded corners where the 
         radius of each corner is specified.
 
 \param  in  rect  base rectangle.
 \param  in  rtl   radius of top-left corner.
 \param  in  rtr   radius of top-right corner.
 \param  in  rbr   radius of bottom-right corner.
 \param  in  rbl   radius of bottom-left corner.
 
 \return a CGPath with reference count equal to 1.
 
 */
CGMutablePathRef CGPathCreateWithRectAnd4CornerRadius(CGRect rect, CGFloat rtl, CGFloat rtr, CGFloat rbr, CGFloat rbl);



/// ----------------------------------------------------------------------------
/// # Additions for CGColor
/// ----------------------------------------------------------------------------

/**
 
 CGColorCreateWithMultipliedComponents
 
 \brief  Creates a CGColorRef using the RGB components of `color` multiplied by `factor`.
 
 \details Color components are clamped to a [0, 1] range.

 \param  in  color   base color.
 \param  in  factor  a value between 0.0 and 1.0.
 
 \return a CGColor with reference count equal to 1.
 
 */
CGColorRef CGColorCreateWithMultipliedComponents(CGColorRef color, CGFloat factor);

/**
 
 CGColorCreateWithOffsetComponents
 
 \brief  Creates a CGColorRef using the RGB component of `color` offset by `amount`. 
 
 \details Color components are clamped to a [0, 1] range.
 
 \param  in  color   base CGColorRef.
 \param  in  offset  a value between 0.0 and 1.0.
 
 \return a CGColor with reference count equal to 1.
 
 */
CGColorRef CGColorCreateWithOffsetComponents(CGColorRef color, CGFloat offset);


/**
 
 CGColorCreateWithGenericHSBA
 
 \brief  Creates a CGColorRef using the HSBA color model.
 
 \details Color components are clamped to a [0, 1] range.
 
 \param  in  h   hue should be between 0 and 1.
 \param  in  s   saturation should be between 0 and 1.
 \param  in  b   brightness should be between 0 and 1.
 \param  in  a   alpha should be between 0 and 1.
 
 \return a CGColor with reference count equal to 1.
 
 */
CGColorRef CGColorCreateWithGenericHSBA(CGFloat h, CGFloat s, CGFloat b, CGFloat a);


/**
 
 CGColorIsApproximatelyEqualToColor
 
 \brief     Returns true if the distance to the color is within tolerence.

 \details   The colors are converted to RGB for comparison. This is mostly used
            in unit testing.
 
 */
BOOL CGColorApproximatelyEqualsColor(CGColorRef a, CGColorRef b, CGFloat tolerence);


