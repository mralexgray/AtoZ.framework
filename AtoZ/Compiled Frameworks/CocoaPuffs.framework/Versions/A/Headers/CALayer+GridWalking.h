/**
 
 \category  CALayer(GridWalking)
 
 \brief     Uses the grid walking function of CGAdditions to perform
            the same function with an arbitrary rect within the layer. 
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */


#import <QuartzCore/QuartzCore.h>

@interface CALayer (GridWalking)


/**
 
 walkGridInRect:rows:columns:yield
 
 \brief  Splits `rect` into a `rows` by `cols` grid and calls `block`
         once for each sub-rectangle in the grid passing the sub-rect
         and its relative position in the grid.
 
 \details This method is simply issues a call to CGRectWalkGrid().
 
 \param  in  rect   outer bounds of the grid.
 \param  in  rows   number of rows in the grid.
 \param  in  cols   number of columns in the grid.
 
 */
- (void) walkGridInRect:(CGRect) rect 
                   rows:(int) rows
                columns:(int) cols
                  yield:(void(^)(CGRect rect, int row, int col)) block
;


/**
 
 walkGridInBoundsRows:columns:yield
 
 \brief  Same as walkGridInRect:rows:columns:yield but forces the rect to
         be the layer bounds.
 
 \param  in  rect   outer bounds of the grid.
 \param  in  rows   number of rows in the grid.
 \param  in  cols   number of columns in the grid.
 
 */
- (void) walkGridInBoundsRows:(int)rows
                      columns:(int)cols
                        yield:(void(^)(CGRect rect, int row, int col)) block
;

@end
