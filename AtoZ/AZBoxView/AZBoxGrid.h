//
//  AZBoxGrid.h
//  AtoZ
//
//  Created by Alex Gray on 7/3/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "AtoZ.h"
#import "AZBox.h"


@class AZBox, AZBoxGrid;
/*** The data source protocol, used to gather the needed data for the collection view. **/
@protocol AZBoxGridDataSource <NSObject>
@required
/** * This method is invoked to ask the data source for the number of cells inside the collection view.**/
- (NSUInteger)numberOfBoxesInGrid:(AZBoxGrid *)grid;
/** * This method is involed to ask the data source for a cell to display at the given index. You should first try to dequeue an old cell before creating a new one! **/
- (AZBox*)grid:(AZBoxGrid *)grid boxForIndex:(NSUInteger)index;

@end

/**
 * The collections views delegate protocol.
 **/
@protocol AZBoxGridDelegate <NSObject>
@optional
/**
 * Invoked when the cell at the given index was selected.
 **/
- (void)grid:(AZBoxGrid*)grid didSelectBoxAtIndex:(NSUInteger)index;
/**
 * Invoked when the user double clicked on the given cell.
 **/
- (void)grid:(AZBoxGrid *)grid didDoubleClickedBoxAtIndex:(NSUInteger)index;
/**
 * Invoked when the cell at the given index was deselected.
 **/
- (void)grid:(AZBoxGrid *)grid didDeselectBoxAtIndex:(NSUInteger)index;
/**
 * Invoked when there was an unhandled key event. The method will be invoked for every selected cell.
 * @remark Currently handled are the cursor keys.
 **/
- (void)grid:(AZBoxGrid*)grid keyEvent:(NSEvent *)event forBoxAtIndex:(NSUInteger)index;

@end
@interface AZBoxGrid : NSView

/**
 * View for displaying items in a grid like order.
 * The collection view is designed to be inside of an NSScrollView instance! The JUCollectionView class behaves much like UITableView on iOS allowing it
 * to have hundreds of thousands cells without great performance impact (unlike NSCollectionView).
 **/
{
@public
//    AGIdealSizer 		*sizer;	
    BOOL allowsSelection, allowsMultipleSelection;
    
@private
    id <AZBoxGridDataSource> __unsafe_unretained dataSource;
    id <AZBoxGridDelegate> __unsafe_unretained delegate;
    
    NSUInteger 				desiredNumberOfColumns, 		desiredNumberOfRows;
    NSUInteger 				numberOfColumns, 			numberOfRows;
    NSUInteger		 		numberOfCells;
    NSSize 					cellSize;
	NSUInteger 				lastHoverCellIndex;
    
    NSMutableDictionary 	*reusableCellQueues;
    NSMutableDictionary 	*visibleCells;
    NSMutableIndexSet 		*selection;
    NSTimeInterval 			lastSelection, lastDoubleClick;
    
    BOOL unselectOnMouseUp, updatingData, 	calledReloadData;
}



@property (strong) IBOutlet NSClipView *clipView;

@property (assign) int layoutStyle;
/**
 * The size of one cell. Each cell shares the very same size.
 **/
@property (nonatomic, assign) NSSize cellSize;
/**
 * The number of columns the collection view should use, or NSUIntegerMax to let the collection view decide what column number fits best.
 **/
@property (nonatomic, assign) NSUInteger desiredNumberOfColumns;
/**
 * The number of rows the collection view should use, or NSUIntegerMax to let the collection view use an dynmaic row number.
 * @remark If you set desiredNumberOfRows to a fixed value, the collection view might not show all cells but only those who fit into the desired rows.
 **/
@property (nonatomic, assign) NSUInteger desiredNumberOfRows;
/**
 * The currently selected cells.
 **/
@property (unsafe_unretained, nonatomic, readonly) NSIndexSet *selection;

/**
 * The data source of the collection view.
 **/
@property (unsafe_unretained, nonatomic /*assign*/) IBOutlet id<AZBoxGridDataSource> dataSource;
/**
 * The delegate of the collection view.
 **/
@property (unsafe_unretained, nonatomic/*assign*/) IBOutlet id<AZBoxGridDelegate> delegate;

/**
 * YES if the collection view should allow selection, otherwise NO. The default value is YES.
 **/
@property (nonatomic, assign) BOOL allowsSelection;
/**
 * YES if the collection view should allow the selection of multiple cells at the same time, otherwise NO. The default value is NO.
 **/
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/**
 * YES if the collection view should deselect the currently selected cell when the mouse button is released. The default value is NO.
 **/
@property (nonatomic, assign) BOOL unselectOnMouseUp;

/**
 * Returns a queued cell or nil if no cell is currently in the queue. Use this if possible instead of creating new JUCollectionViewCell instances. 
 **/
- (AZBox *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
/**
 * Returns the cell at the given index.
 * @remark The cell must be visible, otherwise the method will return nil.
 **/
- (AZBox *)cellAtIndex:(NSUInteger)index;

/**
 * Forces the collection view to throw away all cached data including cells and selections and then reloading the data from scratch.
 **/
- (void)reloadData;

/**
 * Selects the cell with the given index.
 **/
- (void)selectCellAtIndex:(NSUInteger)index;
/**
 * Selects all cells of the index set, or, if allowsMultipleSelection is set to NO, selectes the cell at the first index of the set.
 **/
- (void)selectCellsAtIndexes:(NSIndexSet *)indexSet;

/**
 * Deselects the cell at the given index.
 **/
- (void)deselectCellAtIndex:(NSUInteger)index;
/**
 * Deselcts all cells of the index set.
 **/
- (void)deselectCellsAtIndexes:(NSIndexSet *)indexSet;
/**
 * Deselects all previously selected cells.
 **/
- (void)deselectAllCells;

/**
 * The mouse is hovering over the given cell.
 **/
- (void)hoverOverCellAtIndex:(NSUInteger)index;
/**
 * The mouse was hovering over the given cell and is now out of the cell area.
 **/
- (void)hoverOutOfCellAtIndex:(NSUInteger)index;
/**
 * Hover out of the most recent cell that the mouse was hovering over.
 **/
- (void)hoverOutOfLastCell;

/**
 * Returns the index of the cell at the given point.
 **/
- (NSUInteger)indexOfCellAtPoint:(NSPoint)point;
/**
 * Returns the index of the cell at the given position.
 **/
- (NSUInteger)indexOfCellAtPosition:(NSPoint)point;
/**
 * Returns the position of the cell at the given index. For example the top left cell has the point 0|0 while the one on the right side of it has 1|0 etc.
 **/
- (NSPoint)positionOfCellAtIndex:(NSUInteger)index;
/**
 * Returns the frame of the cell at the given index.
 **/
- (NSRect)rectForCellAtIndex:(NSInteger)index;
/**
 * Returns a set of indexes that are inside the rect.
 **/
- (NSIndexSet *)indexesOfCellsInRect:(NSRect)rect;

/**
 * Returns the currently visible index range.
 **/
- (NSRange)visibleRange;

/**
 * Begins a block of changes. The collection view will only update its data and appereance when you call commitChanges.
 * @remark A call to reloadData will also be delayed until a commitChanges call.
 **/
- (void)beginChanges;
/**
 * Updates the collection views data and appereance according to the previously made changes.
 * @remark Use this and beginChanges if you want to update multiple properties of the collection view in one batch call to save performance.
 **/
- (void)commitChanges;

@end




