//
//  NSTableView+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 12/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

@interface NSTableView (AtoZ)

@end

/*
 Simulates UITableView's look and feel.

 For more details, see the related blog post at http://www.noodlesoft.com/blog/2009/09/25/sticky-section-headers-in-nstableview/
 */

@interface NoodleIPhoneTableView : NSTableView

@property (nonatomic) BOOL isDrawingStickyRow;

@end


/*
 This NSTableView subclass provides a couple of neat features.

 Sticky Row Headers
 ==================
 This allows you to specify certain rows (it uses group rows by default) to "stick" to the top of the tableview
 scroll area when it is scrolled out of view. This is similar to how section headers work in UITableView in the
 iPhone SDK. The bulk of the implementation and delegate API are in the NSTableView-NoodleExtensions category.

 To enable this feature, just set the showsStickyRowHeader property.

 For more details, see the related blog post at http://www.noodlesoft.com/blog/2009/09/25/sticky-section-headers-in-nstableview/


 Row Spanning Columns
 ====================

 Row Spanning Columns are columns whose cells are allow to span across multiple rows. The span is determined by
 a contiguous section of rows that have the same object value. The cells within such a span are consolidated into
 a single special cell. An example of this can be seen in the Artwork column in iTunes.

 For any columns where you want to have this take effect, just change the column class to NoodleTableColumn and
 set the rowSpanningEnabled property on it. You can alternatively call -setRowSpanningEnabledForCapablyColumns
 on the tableview in your -awakeFromNib to enable all the NoodleTableColumns in your table in one fell swoop.

 For more details, see the related blog post at http://www.noodlesoft.com/blog/2009/10/20/yet-another-way-to-mimic-the-artwork-column-in-cocoa/
 */
@interface NoodleTableView : NSTableView
@property (nonatomic) BOOL  hasSpanningColumns, isDrawingStickyRow;
@property (readwrite, assign) BOOL showsStickyRowHeader;

#pragma mark Row Spanning methods

/*
 Enables/disables row spanning for all NoodleTableColumns in the receiver. Note that row spanning is not enabled
 by default so if you want row spanning, call this from -awakeFromNib is a good idea.
 */
- (void)setRowSpanningEnabledForCapableColumns:(BOOL)flag;

@end


@class NoodleRowSpanningCell;

/*
 Special table column that enables row spanning functionality. Just set your columns in IB to use this class and
 enable it by calling -setRowSpaningEnabled:	*/
@interface NoodleTableColumn :NSTableColumn
{
	BOOL						_spanningEnabled;
	NoodleRowSpanningCell		*_cell;
}
@property (getter=isRowSpanningEnabled, setter=setRowSpanningEnabled:) BOOL rowSpanningEnabled;

@end

typedef NSUInteger		NoodleStickyRowTransition;

enum
{
	NoodleStickyRowTransitionNone,
	NoodleStickyRowTransitionFadeIn
};

@interface NSTableView (NoodleExtensions)

#pragma mark Sticky Row Header methods
// Note: see NoodleTableView's -drawRect on how to hook in this functionality in a subclass

/*
 Currently set to any groups rows (as dictated by the delegate). The
 delegate can implement -tableView:isStickyRow: to override this.
 */
- (BOOL)isRowSticky:(NSInteger)rowIndex;

/*
 Does the actual drawing of the sticky row. Override if you want a custom look.
 You shouldn't invoke this directly. See -drawStickyRowHeader.
 */
- (void)drawStickyRow:(NSInteger)row clipRect:(NSRect)clipRect;

/*
 Draws the sticky row at the top of the table. You have to override -drawRect
 and call this method, that being all you need to get the sticky row stuff
 to work in your subclass. Look at NoodleStickyRowTableView.
 Note that you shouldn't need to override this. To modify the look of the row,
 override -drawStickyRow: instead.
 */
- (void)drawStickyRowHeader;

/*
 Returns the rect of the sticky view header. Will return NSZeroRect if there is no current
 sticky row.
 */
- (NSRect)stickyRowHeaderRect;

/*
 Does an animated scroll to the current sticky row. Clicking on the sticky
 row header will trigger this.
 */
- (IBAction)scrollToStickyRow:(id)sender;

/*
 Returns what kind of transition you want when the row becomes sticky. Fade-in
 is the default.
 */
- (NoodleStickyRowTransition)stickyRowHeaderTransition;

#pragma mark Row Spanning methods

/*
 Returns the range of the span at the given column and row indexes. The span is determined by
 a range of contiguous rows having the same object value.
 */
- (NSRange)rangeOfRowSpanAtColumn:(NSInteger)columnIndex row:(NSInteger)rowIndex;

@end

@class NoodleRowSpanningCell;

@interface NSTableColumn (NoodleExtensions)

#pragma mark Row Spanning methods
/*
 Returns whether this column will try to consolidate rows into spans.
 */
- (BOOL)isRowSpanningEnabled;

/*
 Returns the cell used to draw the spanning regions. Default implementation returns nil.
 */
- (NoodleRowSpanningCell *)spanningCell;

@end


@interface NSOutlineView (NoodleExtensions)

#pragma mark Sticky Row Header methods
/*
 Currently set to any groups rows (or as dictated by the delegate). The
 delegate can implement -outlineView:isStickyRow: to override this.
 */
- (BOOL)isRowSticky:(NSInteger)rowIndex;

@end


@interface NSObject (NoodleStickyRowDelegate)

/*
 Allows the delegate to specify if a row is sticky. By default, group rows
 are sticky. The delegate can override that by implementing this method.
 */
- (BOOL)tableView:(NSTableView *)tableView isStickyRow:(NSInteger)rowIndex;

/*
 Allows the delegate to specify whether a certain cell should be drawn in the sticky row header
 */
- (BOOL)tableView:(NSTableView *)tableView shouldDisplayCellInStickyRowHeaderForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex;

/*
 Same as above but for outline views.
 */
- (BOOL)outlineView:(NSOutlineView *)outlineView isStickyItem:(id)item;

@end

