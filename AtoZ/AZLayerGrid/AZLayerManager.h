//
//  AZLayerManager.h
//  AtoZ
//
//  Created by Alex Gray on 7/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

@interface AZLayerManager : NSObject
@end
/* Abstract: Abstract superclass of regular geometric grids of GridCells that Bits can be placed on.
*/

//#import "Piece.h"
@class GridCell;

// Hit-testing callbacks (to identify which layers caller is interested in).
typedef BOOL (*LayerMatchCallback)(CALayer*);

BOOL layerIsPiece( CALayer* layer );
BOOL layerIsGridCell( CALayer* layer );
// ----------------------------------------------------------------------------

/** Regular geometric grids of GridCells that Bits can be placed on.
 *  (customized for Xiangqi).	*/
@interface Grid : CALayer
{
	unsigned		_nRows, _nColumns;
	CGSize		  _spacing;
	CGColorRef	  _lineColor;
	CGColorRef	  _highlightColor;
	CGColorRef	  _animateColor;
	CGPoint		 _cellOffset;
	NSMutableArray* _cells; // Really a 2D array, in row-major order.
}

/** Initializes a new Grid with the given dimensions and cell size, and position in superview.
 Note that a new Grid has no cells! Either call -addAllCells, or -addCellAtRow:column:. */
- (id) initWithRows:(unsigned)nRows columns:(unsigned)nColumns
			spacing:(CGSize)spacing position:(CGPoint)pos
		 cellOffset:(CGPoint)cellOffset
	backgroundColor:(CGColorRef)backgroundColor;

_RO unsigned rows, columns;	// Dimensions of the grid
_RO CGSize spacing;			// x,y spacing of GridCells
@property CGColorRef lineColor;	  // Cell background color, line color (or nil)
@property CGColorRef highlightColor;
@property CGColorRef animateColor;

/** Returns the GridCell at the given coordinates, or nil if there is no cell there.
 It's OK to call this with off-the-board coordinates; it will just return nil.*/
- (GridCell*) cellAtRow:(unsigned)row column: (unsigned)col;

/** Adds cells at all coordinates, creating a complete grid. */
- (void) addAllCells;

- (void) removeAllCells;

/** Adds a GridCell at the given coordinates. */
- (GridCell*) addCellAtRow:(unsigned)row column:(unsigned)col;

/** Removes a particular cell, leaving a blank space. */
- (void) removeCellAtRow:(unsigned)row column:(unsigned)col;

@end
/** A single cell in a grid (customized for Xiangqi). */
@interface GridCell : CALayer
{
	BOOL	 _highlighted;
	BOOL	 _animated;
	Grid*	_grid;
	unsigned _row, _column;
	BOOL	 dotted;
	BOOL	 cross;
}

- (id) initWithGrid:(Grid*)grid row:(unsigned)row column:(unsigned)col
			  frame:(CGRect)frame;

@property (nonatomic, setter=setHighlighted:) BOOL highlighted;
@property (nonatomic, setter=setAnimated:) BOOL animated;

@property (nonatomic) unsigned row, column;
@property (nonatomic) BOOL dotted;
@property (nonatomic) BOOL cross;
_RO GridCell *nw, *n, *ne, *e, *se, *s, *sw, *w; // Absolute directions (n = increasing row#)

- (CGPoint) getMidInLayer:(CALayer*)layer;

// protected:
- (void) drawInParentContext:(CGContextRef)ctx;
@end
