//
//  NSTableView+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 12/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSTableView+AtoZ.h"

@implementation NSTableView (AtoZ)

- (void)selectItemsInArray:(NSA*)selectedItems usingSourceArray:(NSA*)sourceArray
{
	if ([sourceArray count] != [self numberOfRows]) {
		NSLog(@"SourceArray is %lu; rows is %ld",(unsigned long)[sourceArray count], (long)[self numberOfRows]);
	}

	NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];

	NSEnumerator *enumerator = [selectedItems objectEnumerator];
	id	item;
	while ((item = [enumerator nextObject])) {
		NSUInteger i = [sourceArray indexOfObject:item];
		if (i != NSNotFound) {
			[indexes addIndex:i];
		}
	}

	[self selectRowIndexes:indexes byExtendingSelection:NO];
}


@end
//
//@implementation NoodleIPhoneTableView
//
//- (id)initWithFrame:(NSRect)frameRect
//{
//	if (self != [super initWithFrame:frameRect]) return nil;
//	[self setGridColor:[NSC colorWithCalibratedWhite:0.849 alpha:1.0]];
//	[self setGridStyleMask:NSTableViewSolidHorizontalGridLineMask];
//	return self;
//}
//
//- (id)initWithCoder:(NSCoder *)decoder
//{
//	if (!(self = [super initWithCoder:decoder])) return nil;
//	[self setGridColor:[NSC colorWithCalibratedWhite:0.849 alpha:1.0]];
//	[self setGridStyleMask:NSTableViewSolidHorizontalGridLineMask];
//	return self;
//}
//
//- (void)drawRect:(NSRect)rect
//{
//	[super drawRect:rect];
//	[self drawStickyRowHeader];
//}
//
//// Since we are going to ensure that the regular and sticky versions of a row look the same, no transition is needed here.
//- (NoodleStickyRowTransition)stickyRowHeaderTransition { 	return NoodleStickyRowTransitionNone;	}
//
//- (void)drawRow:(NSInteger)rowIndex clipRect:(NSRect)clipRect
//{
//	if ([self isRowSticky:rowIndex])
//	{
//		NSRect					rowRect, cellRect;
//		NSUInteger				colIndex, count;
//		NSCell					*cell;
//		NSGradient				*gradient;
//		NSAttributedString		*attrString;
//		NSShadow				*textShadow;
//		NSBezierPath			*path;
//		NSDictionary			*attributes;
//
//		rowRect = [self rectOfRow:rowIndex];
//
//		if (!_isDrawingStickyRow)
//		{
//			// Note that NSTableView will still draw the special background that it does for group row so we re-draw the background over it.
//			[self drawBackgroundInClipRect:rowRect];
//			if (NSIntersectsRect(rowRect, [self stickyRowHeaderRect]))
//			{
//				// You can barely notice it but if the sticky view is showing, the actual row it represents is still seen underneath. We check for this and don't
//				// draw the row in such a case.
//				return;
//			}
//		}
//
//		gradient = [NSG.alloc initWithStartingColor:
//					[NSColor colorWithCalibratedRed:0.490 green:0.556 blue:0.600 alpha:0.9]  endingColor:[NSC colorWithCalibratedRed:0.665 green:0.706 blue:0.738 alpha:0.9]];
//		[gradient drawInRect:rowRect angle:90];
//		[gradient release];
//		textShadow = [NSShadow.alloc init];
//		[textShadow setShadowOffset:NSMakeSize(1.0, -1.0)];
//		[textShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.5 alpha:1.0]];
//		[textShadow setShadowBlurRadius:0.0];
//
//		attributes = [NSDictionary dictionaryWithObjectsAndKeys:
//					  [NSFont fontWithName:@"Helvetica-Bold" size:16.0],
//					  NSFontAttributeName,
//					  textShadow,
//					  NSShadowAttributeName,
//					  [NSColor whiteColor],
//					  NSForegroundColorAttributeName,
//					  nil];
//		[textShadow release];
//
//		count = [self numberOfColumns];
//		for (colIndex = 0; colIndex < count; colIndex++)
//		{
//			cell = [self preparedCellAtColumn:colIndex row:rowIndex];
//			attrString = [NSAS.alloc initWithString:[cell stringValue] attributes:attributes];
//			cellRect = [self frameOfCellAtColumn:colIndex row:rowIndex];
//			[cell setAttributedStringValue:attrString];
//			[cell drawWithFrame:cellRect inView:self];
//			[attrString release];
//		}
//		[[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] set];
//		path = [NSBezierPath bezierPath];
//		[path moveToPoint:NSMakePoint(NSMinX(rowRect), NSMinY(rowRect))];
//		[path lineToPoint:NSMakePoint(NSMaxX(rowRect), NSMinY(rowRect))];
//		[path moveToPoint:NSMakePoint(NSMinX(rowRect), NSMaxY(rowRect))];
//		[path lineToPoint:NSMakePoint(NSMaxX(rowRect), NSMaxY(rowRect))];
//		[path stroke];
//	}
//	else		[super drawRow:rowIndex clipRect:clipRect];
//}
//
//- (void)drawStickyRow:(NSInteger)row clipRect:(NSRect)clipRect
//{
//	_isDrawingStickyRow = YES;
//	[self drawRow:row clipRect:clipRect];
//	_isDrawingStickyRow = NO;
//}
//@end
//
//#define NOODLE_STICKY_ROW_VIEW_TAG		233931134
//
//void NoodleClearRect(NSRect rect)
//{
//	[[NSColor clearColor] set];
//	NSRectFill(rect);
//}
//
//@interface NSTableView (NoodlePrivate)
//
//#pragma mark Sticky Row Header methods
//
//// Returns index of the sticky row previous to the first visible row.
//- (NSInteger)_previousStickyRow;
//
//// Returns index of the sticky row after the first visible row.
//- (NSInteger)_nextStickyRow;
//
//- (void)_updateStickyRowHeaderImageWithRow:(NSInteger)row;
//
//// Returns the view used for the sticky row header
//- (id)_stickyRowHeaderView;
//
//@end
//
//
//@implementation NSTableView (NoodleExtensions)
//
//#pragma mark Sticky Row Header methods
//
//- (BOOL)isRowSticky:(NSInteger)rowIndex
//{
//	id		delegate;
//
//	delegate = [self delegate];
//
//	if ([delegate respondsToSelector:@selector(tableView:isStickyRow:)])
//	{
//		return [delegate tableView:self isStickyRow:rowIndex];
//	}
//	else if ([delegate respondsToSelector:@selector(tableView:isGroupRow:)])
//	{
//		return [delegate tableView:self isGroupRow:rowIndex];
//	}
//	return NO;
//}
//
//- (void)drawStickyRowHeader
//{
//	id			stickyView;
//	NSInteger	row;
//
//	stickyView = [self _stickyRowHeaderView];
//	row = [self _previousStickyRow];
//	if (row != -1)
//	{
//		[stickyView setFrame:[self stickyRowHeaderRect]];
//		[self _updateStickyRowHeaderImageWithRow:row];
//	}
//	else
//	{
//		[stickyView setFrame:NSZeroRect];
//	}
//}
//
//- (IBAction)scrollToStickyRow:(id)sender
//{
//	NSInteger		row;
//
//	row = [self _previousStickyRow];
//	if (row != -1)
//	{
//		[self scrollRowToVisible:row];
//	}
//}
//
//- (id)_stickyRowHeaderView
//{
//	NSButton		*view;
//
//	view = [self viewWithTag:NOODLE_STICKY_ROW_VIEW_TAG];
//
//	if (view == nil)
//	{
//		view = [[NSButton alloc] initWithFrame:NSZeroRect];
//		[view setEnabled:YES];
//		[view setBordered:NO];
//		[view setImagePosition:NSImageOnly];
//		[view setTitle:nil];
//		[[view cell] setHighlightsBy:NSNoCellMask];
//		[[view cell] setShowsStateBy:NSNoCellMask];
//		[[view cell] setImageScaling:NSImageScaleNone];
//		[[view cell] setImageDimsWhenDisabled:NO];
//
//		[view setTag:NOODLE_STICKY_ROW_VIEW_TAG];
//
//		[view setTarget:self];
//		[view setAction:@selector(scrollToStickyRow:)];
//
//		[self addSubview:view];
//		[view release];
//	}
//	return view;
//}
//
//- (void)drawStickyRow:(NSInteger)row clipRect:(NSRect)clipRect
//{
//	NSRect				rowRect, cellRect;
//	NSCell				*cell;
//	NSInteger			colIndex, count;
//	id					delegate;
//
//	delegate = [self delegate];
//
//	if (![delegate respondsToSelector:@selector(tableView:shouldDisplayCellInStickyRowHeaderForTableColumn:row:)])
//	{
//		delegate = nil;
//	}
//
//	rowRect = [self rectOfRow:row];
//
//	[[[self backgroundColor] highlightWithLevel:0.5] set];
//	NSRectFill(rowRect);
//
//	// PENDING: -drawRow:clipRect: is too smart for its own good. If the row is not visible,
//	//	this method won't draw anything. Useless for row caching.
//	//	[self drawRow:row clipRect:rowRect];
//
//	count = [self numberOfColumns];
//	for (colIndex = 0; colIndex < count; colIndex++)
//	{
//		if ((delegate == nil) ||
//			[delegate tableView:self shouldDisplayCellInStickyRowHeaderForTableColumn:[[self tableColumns] objectAtIndex:colIndex] row:row])
//		{
//			cell = [self preparedCellAtColumn:colIndex row:row];
//			cellRect = [self frameOfCellAtColumn:colIndex row:row];
//			[cell drawWithFrame:cellRect inView:self];
//		}
//	}
//
//	[[self gridColor] set];
//	[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(rowRect), NSMaxY(rowRect)) toPoint:NSMakePoint(NSMaxX(rowRect), NSMaxY(rowRect))];
//}
//
//- (NoodleStickyRowTransition)stickyRowHeaderTransition
//{
//	return NoodleStickyRowTransitionFadeIn;
//}
//
//- (void)_updateStickyRowHeaderImageWithRow:(NSInteger)row
//{
//	NSImage							*image;
//	NSRect							rowRect, visibleRect, imageRect;
//	CGFloat							offset, alpha;
//	NSAffineTransform				*transform;
//	id								stickyView;
//	NoodleStickyRowTransition		transition;
//	BOOL							isSelected;
//
//	rowRect = [self rectOfRow:row];
//	imageRect = NSMakeRect(0.0, 0.0, NSWidth(rowRect), NSHeight(rowRect));
//	stickyView = [self _stickyRowHeaderView];
//
//	isSelected = [self isRowSelected:row];
//	if (isSelected)
//	{
//		[self deselectRow:row];
//	}
//
//	// Optimization: instead of creating a new image each time (and since we can't
//	// add ivars in a category), just use the image in the sticky view. We're going
//	// to put it there in the end anyways, why not reuse it?
//	image = [stickyView image];
//
//	if ((image == nil) || !NSEqualSizes(rowRect.size, [image size]))
//	{
//		image = [[NSImage alloc] initWithSize:rowRect.size];
//		[image setFlipped:[self isFlipped]];
//		[stickyView setImage:image];
//		[image release];
//	}
//
//	visibleRect = [self visibleRect];
//
//	// Calculate a distance between the row header and the actual sticky row and normalize it
//	// over the row height (plus some extra). We use this to do the fade in effect as you
//	// scroll away from the sticky row.
//	offset = (NSMinY(visibleRect) - NSMinY(rowRect)) / (NSHeight(rowRect) * 1.25);
//
//	// When the button is disabled, it passes through to the view underneath. So, until the
//	// original header view is mostly out of view, allow mouse events to pass through. After
//	// that, the header is clickable.
//	if (offset < 0.5)
//	{
//		[stickyView setEnabled:NO];
//	}
//	else
//	{
//		[stickyView setEnabled:YES];
//	}
//
//	// Row is drawn in tableview coord space.
//	transform = [NSAffineTransform transform];
//	[transform translateXBy:-NSMinX(rowRect) yBy:-NSMinY(rowRect)];
//
//	transition = [self stickyRowHeaderTransition];
//	if (transition == NoodleStickyRowTransitionFadeIn)
//	{
//		// Since we want to adjust the transparency based on position, we draw the row into an
//		// image which we then draw with alpha into the final image.
//		NSImage *rowImage;
//
//		// Optimization: Since this is a category and we can't add any ivars, we instead use
//		// the unused alt image of the sticky view (which is a button) as a cache so we don't
//		// have to keep creating images. Yes, a little hackish.
//		rowImage = [stickyView alternateImage];
//		if ((rowImage == nil) || !NSEqualSizes(rowRect.size, [rowImage size]))
//		{
//			rowImage = [[NSImage alloc] initWithSize:rowRect.size];
//			[rowImage setFlipped:[self isFlipped]];
//
//			[stickyView setAlternateImage:rowImage];
//			[rowImage release];
//		}
//
//		// Draw the original image
//		[rowImage lockFocus];
//		NoodleClearRect(imageRect);
//
//		[transform concat];
//		[self drawStickyRow:row clipRect:rowRect];
//
//		[rowImage unlockFocus];
//
//		alpha = MIN(offset, 0.9);
//
//		// Draw it with transparency in the final image
//		[image lockFocus];
//
//		NoodleClearRect(imageRect);
//		[rowImage drawAdjustedAtPoint:NSZeroPoint fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];
//
//		[image unlockFocus];
//	}
//	else if (transition == NoodleStickyRowTransitionNone)
//	{
//		[image lockFocus];
//		NoodleClearRect(imageRect);
//
//		[transform concat];
//		[self drawStickyRow:row clipRect:rowRect];
//
//		[image unlockFocus];
//	}
//	else
//	{
//		[image lockFocus];
//		NoodleClearRect(imageRect);
//
//		[@"You returned a bad NoodleStickyRowTransition value. Tsk. Tsk." drawInRect:imageRect withAttributes:nil];
//
//		[image unlockFocus];
//	}
//
//	if (isSelected)
//	{
//		[self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:YES];
//	}
//
//}
//
//- (NSInteger)_previousStickyRow
//{
//	NSRect			visibleRect;
//	NSInteger		row;
//
//	visibleRect = [self visibleRect];
//	row = [self rowAtPoint:visibleRect.origin];
//
//	while (row >= 0)
//	{
//		if ([self isRowSticky:row])
//		{
//			return row;
//		}
//		row--;
//	}
//	return -1;
//}
//
//- (NSInteger)_nextStickyRow
//{
//	NSRect			visibleRect;
//	NSInteger		row;
//	NSInteger		numberOfRows;
//
//	visibleRect = [self visibleRect];
//	row = [self rowAtPoint:visibleRect.origin];
//	if (row != -1)
//	{
//		numberOfRows = [self numberOfRows];
//		while (++row < numberOfRows)
//		{
//			if ([self isRowSticky:row])
//			{
//				return row;
//			}
//		}
//	}
//	return -1;
//}
//
//- (NSRect)stickyRowHeaderRect
//{
//	NSInteger	row;
//
//	row = [self _previousStickyRow];
//
//	if (row != -1)
//	{
//		NSInteger		nextGroupRow;
//		NSRect			visibleRect, rowRect;
//
//		rowRect = [self rectOfRow:row];
//		visibleRect = [self visibleRect];
//
//		// Move it to the top of the visible area
//		rowRect.origin.y = NSMinY(visibleRect);
//
//		nextGroupRow = [self _nextStickyRow];
//		if (nextGroupRow != -1)
//		{
//			NSRect		nextRect;
//
//			// "Push" the row up if it's butting up against the next sticky row
//			nextRect = [self rectOfRow:nextGroupRow];
//			if (NSMinY(nextRect) < NSMaxY(rowRect))
//			{
//				rowRect.origin.y = NSMinY(nextRect) - NSHeight(rowRect);
//			}
//		}
//		return rowRect;
//	}
//	return NSZeroRect;
//}
//
//#pragma mark Row Spanning methods
//
//- (NSRange)rangeOfRowSpanAtColumn:(NSInteger)columnIndex row:(NSInteger)rowIndex
//{
//	id				dataSource, objectValue, originalObjectValue;
//	NSInteger		i, start, end, count;
//	NSTableColumn	*column;
//
//	dataSource = [self dataSource];
//
//	column = [[self tableColumns] objectAtIndex:columnIndex];
//
//	if ([column isRowSpanningEnabled])
//	{
//		originalObjectValue = [dataSource tableView:self objectValueForTableColumn:column row:rowIndex];
//
//		// Figure out the span of this cell. We determine this by going up and down finding contiguous rows with
//		// the same object value.
//		i = rowIndex;
//		while (i-- > 0)
//		{
//			objectValue = [dataSource tableView:self objectValueForTableColumn:column row:i];
//
//			if (![objectValue isEqual:originalObjectValue])
//			{
//				break;
//			}
//		}
//		start = i + 1;
//
//		count = [self numberOfRows];
//		i = rowIndex + 1;
//		while (i < count)
//		{
//			objectValue = [dataSource tableView:self objectValueForTableColumn:column row:i];
//
//			if (![objectValue isEqual:originalObjectValue])
//			{
//				break;
//			}
//			i++;
//		}
//		end = i - 1;
//
//		return NSMakeRange(start, end - start + 1);
//	}
//	return NSMakeRange(rowIndex, 1);
//}
//
//@end
//
//@implementation NSTableColumn (NoodleExtensions)
//
//#pragma mark Row Spanning methods
//
//- (BOOL)isRowSpanningEnabled
//{
//	return NO;
//}
//
//- (NoodleRowSpanningCell *)spanningCell
//{
//	return nil;
//}
//
//@end
//
//@implementation NSOutlineView (NoodleExtensions)
//
//#pragma mark Sticky Row Header methods
//
//- (BOOL)isRowSticky:(NSInteger)rowIndex
//{
//	id		delegate;
//
//	delegate = [self delegate];
//
//	if ([delegate respondsToSelector:@selector(outlineView:isStickyItem:)])
//	{
//		return [delegate outlineView:self isStickyItem:[self itemAtRow:rowIndex]];
//	}
//	else if ([delegate respondsToSelector:@selector(outlineView:isGroupItem:)])
//	{
//		return [delegate outlineView:self isGroupItem:[self itemAtRow:rowIndex]];
//	}
//	return NO;
//}
//
//@end
//
//
//
///*
// Internal cell class. Wraps around another cell. Draws the inner cell in its "full frame" but when drawing in
// the tableview, draws each row sliver from the full image.
// */
//@interface NoodleRowSpanningCell : NSCell
//{
////	NSRect			_fullFrame;
////	NSCell			*_cell;
//	NSImage			*_cachedImage;
////	NSColor			*_backgroundColor;
////	NSInteger		_startIndex;
//	NSInteger		_lastStartIndex;
////	NSInteger		_endIndex;
//	NSInteger		_lastEndIndex;
//}
//
//@property NSR fullFrame;
//@property (assign) NSCell *cell;
//@property (copy) NSC *backgroundColor;
//@property NSI startIndex;
//@property NSI endIndex;
//
//@end
//
//@implementation NoodleRowSpanningCell
//
////@synthesize fullFrame = _fullFrame;
////@synthesize cell = _cell;
////@synthesize backgroundColor = _backgroundColor;
////@synthesize startIndex = _startIndex;
////@synthesize endIndex = _endIndex;
//
//- (void)_clearOutCaches
//{
//	_startIndex = -1;
//	_endIndex = -1;
//	_lastStartIndex = -1;
//	_lastEndIndex = -1;
//	_cell = nil;
//}
//
//- (void)dealloc
//{
//	[self _clearOutCaches];
//	[_backgroundColor release];
//	[_cachedImage release];
//
////	[super dealloc];
//}
//
//- (id)copyWithZone:(NSZone *)zone
//{
//	NoodleRowSpanningCell		*copy;
//
//	copy = [super copyWithZone:zone];
//
//	// super will copy the pointer across (via NSCopyObject()) but we need to retain or copy the actual instances
//	copy->_cachedImage = [_cachedImage copy];
//	copy->_backgroundColor = [_backgroundColor copy];
//
//	return copy;
//}
//
//- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
//{
//	// Draw the full span of the cell into a cached image and then pull out the correct sliver as needed
//
//	if ((_startIndex != _lastStartIndex) || (_endIndex != _lastEndIndex) || (_cachedImage == nil))
//	{
//		// If the indices have changed, we are dealing with a new span so recache the cell's full image
//		NSAffineTransform	*transform;
//		NSColor				*color;
//
//		if ((_cachedImage == nil) || !NSEqualSizes(_fullFrame.size, [_cachedImage size]))
//		{
//			[_cachedImage release];
//			_cachedImage = [[NSImage alloc] initWithSize:_fullFrame.size];
//			[_cachedImage setFlipped:[controlView isFlipped]];
//		}
//
//		[_cachedImage lockFocus];
//
//		transform = [NSAffineTransform transform];
//		[transform translateXBy:-NSMinX(_fullFrame) yBy:-NSMinY(_fullFrame)];
//		[transform concat];
//
//		color = _backgroundColor;
//		if (color == nil)
//		{
//			color = [NSColor clearColor];
//		}
//		[color set];
//		NSRectFill(_fullFrame);
//
//		[_cell drawWithFrame:_fullFrame inView:controlView];
//
//		[_cachedImage unlockFocus];
//
//		_lastStartIndex = _startIndex;
//		_lastEndIndex = _endIndex;
//	}
//
//	// Now draw the sliver for the current row in the right spot
//	[_cachedImage drawAdjustedInRect:cellFrame
//							fromRect:NSMakeRect(NSMinX(cellFrame) - NSMinX(_fullFrame),
//												NSMinY(cellFrame) - NSMinY(_fullFrame),
//												NSWidth(cellFrame), NSHeight(cellFrame))
//						   operation:NSCompositeSourceOver fraction:1.0];
//}
//
//@end
//
//@implementation NoodleTableColumn : NSTableColumn
//
//@synthesize rowSpanningEnabled = _spanningEnabled;
//
//#define SPANNING_ENABLED_KEY			@"spanningEnabled"
//
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//	[super encodeWithCoder:encoder];
//
//	if ([encoder allowsKeyedCoding])
//	{
//		[encoder encodeObject:[NSNumber numberWithBool:_spanningEnabled] forKey:SPANNING_ENABLED_KEY];
//	}
//	else
//	{
//		[encoder encodeObject:[NSNumber numberWithBool:_spanningEnabled]];
//	}
//}
//
//- (id)initWithCoder:(NSCoder *)decoder
//{
//	if ((self = [super initWithCoder:decoder]) != nil)
//	{
//		id			value;
//
//		if ([decoder allowsKeyedCoding])
//		{
//			value = [decoder decodeObjectForKey:SPANNING_ENABLED_KEY];
//		}
//		else
//		{
//			value = [decoder decodeObject];
//		}
//
//		if (value != nil)
//		{
//			_spanningEnabled = [value boolValue];
//		}
//	}
//	return self;
//}
//
//- (void)dealloc
//{
//	[_cell release];
////	[super dealloc];
//}
//
//- (NoodleRowSpanningCell *)spanningCell
//{
//	return _cell ?: [NoodleRowSpanningCell.alloc initTextCell:@""];
//}
//
//@end
//
//
//@implementation NoodleTableView
//
//@synthesize showsStickyRowHeader = _showsStickyRowHeader;
//
//#pragma mark NSCoding methods
//
//#define SHOWS_STICKY_ROW_HEADER_KEY			@"showsStickyRowHeader"
//
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//	[super encodeWithCoder:encoder];
//
//	if ([encoder allowsKeyedCoding])
//	{
//		[encoder encodeObject:[NSNumber numberWithBool:_showsStickyRowHeader] forKey:SHOWS_STICKY_ROW_HEADER_KEY];
//	}
//	else
//	{
//		[encoder encodeObject:[NSNumber numberWithBool:_showsStickyRowHeader]];
//	}
//}
//
//- (id)initWithCoder:(NSCoder *)decoder
//{
//	if ((self = [super initWithCoder:decoder]) != nil)
//	{
//		id			value;
//
//		if ([decoder allowsKeyedCoding])
//		{
//			value = [decoder decodeObjectForKey:SHOWS_STICKY_ROW_HEADER_KEY];
//		}
//		else
//		{
//			value = [decoder decodeObject];
//		}
//		_showsStickyRowHeader = [value boolValue];
//
//		for (NSTableColumn *column in [self tableColumns])
//		{
//			if ([column isKindOfClass:[NoodleTableColumn class]])
//			{
//				_hasSpanningColumns = YES;
//				break;
//			}
//		}
//	}
//	return self;
//}
//
//- (void)addTableColumn:(NSTableColumn *)column
//{
//	[super addTableColumn:column];
//
//	if ([column isKindOfClass:[NoodleTableColumn class]])
//	{
//		_hasSpanningColumns = YES;
//	}
//}
//
//- (void)removeTableColumn:(NSTableColumn *)column
//{
//	[super removeTableColumn:column];
//
//	for (NSTableColumn *column in [self tableColumns])
//	{
//		if ([column isKindOfClass:[NoodleTableColumn class]])
//		{
//			_hasSpanningColumns = YES;
//			break;
//		}
//	}
//}
//
//#pragma mark Row Spanning methods
//
//- (void)setRowSpanningEnabledForCapableColumns:(BOOL)flag
//{
//	for (id column in [self tableColumns])
//	{
//		if ([column respondsToSelector:@selector(setRowSpanningEnabled:)])
//		{
//			[column setRowSpanningEnabled:flag];
//		}
//	}
//}
//
//// Does the actual work of drawing the grid. Originally, was trying to set the grid mask and calling super's
//// -drawGridInClipRect: method on specific regions to get the effect I wanted but all the setting of the masks
//// ended up sucking down CPU cycles as it got into a loop queueing up tons of redraw requests.
//- (void)_drawGrid:(NSUInteger)gridMask inClipRect:(NSRect)aRect
//{
//	NSRect			rect;
//
//	[[self gridColor] set];
//
//	if ((gridMask & NSTableViewSolidHorizontalGridLineMask) != 0)
//	{
//		NSRange			range;
//		NSInteger		i;
//
//		range = [self rowsInRect:aRect];
//		for (i = range.location; i < NSMaxRange(range); i++)
//		{
//			rect = [self rectOfRow:i];
//			if (NSMaxY(rect) <= NSMaxY(aRect))
//			{
//				rect.origin.x = NSMinX(aRect);
//				rect.size.width = NSWidth(aRect);
//				rect.origin.y -= 0.5;
//				[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMinX(rect), NSMaxY(rect)) toPoint:NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
//			}
//		}
//	}
//	if ((gridMask & NSTableViewSolidVerticalGridLineMask) != 0)
//	{
//		NoodleIndexSetEnumerator	*enumerator;
//		NSInteger					i;
//
//		enumerator = [[self columnIndexesInRect:aRect] indexEnumerator];
//		while ((i = [enumerator nextIndex]) != NSNotFound)
//		{
//			rect = [self rectOfColumn:i];
//			if (NSMaxX(rect) <= NSMaxX(aRect))
//			{
//				rect.origin.y = NSMinY(aRect);
//				rect.size.height = NSHeight(aRect);
//				rect.origin.x -= 0.5;
//				[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect)) toPoint:NSMakePoint(NSMaxX(rect), NSMaxY(rect))];
//			}
//		}
//	}
//}
//
//- (void)drawGridInClipRect:(NSRect)aRect
//{
//	NSUInteger					origGridMask;
//
//	origGridMask = [self gridStyleMask];
//
//	if (_hasSpanningColumns && ((origGridMask & NSTableViewSolidHorizontalGridLineMask) != 0))
//	{
//		// Rules:
//		// - No spanning cell should have grid lines within it. Only at the bottom.
//		// - Non-spanning cells inherit their grid lines from the closest spanning cell to the left (or to the right
//		// if there are none to the left.
//
//		NSRange						range, spanRange;
//		NSInteger					columnIndex, endColumnIndex, startColumnIndex, row;
//		NSMutableIndexSet			*columnIndexes;
//		NoodleIndexSetEnumerator	*enumerator;
//		NSRect						topLeft, bottomRight, rect;
//
//		// Grab the indexes of all the spanning columns.
//		columnIndex = 0;
//		columnIndexes = [NSMutableIndexSet indexSet];
//		for (NSTableColumn *column in [self tableColumns])
//		{
//			if ([column isRowSpanningEnabled])
//			{
//				[columnIndexes addIndex:columnIndex];
//			}
//			columnIndex++;
//		}
//
//		// Hard to explain but we calculate regions going from left to right, defining regions horizontally
//		// from one spanning column to the next and vertically by row spans. We first draw the non-horizontal
//		// grid lines within a span (taking into account precedence rules concerning columns as noted above).
//		// Then we draw the horizontal grid line at the bottom of a span. We are trying to find the maximal
//		// regions to send to the grid drawing routine as doing it cell by cell incurs a bit of overhead.
//		startColumnIndex = 0;
//		enumerator = [columnIndexes indexEnumerator];
//		while ((columnIndex = [enumerator nextIndex]) != NSNotFound)
//		{
//			// This column is the right edge of this region (which is up to the next spanning column)
//			endColumnIndex = [columnIndexes indexGreaterThanIndex:columnIndex];
//			if (endColumnIndex == NSNotFound)
//			{
//				endColumnIndex = [self numberOfColumns] - 1;
//			}
//			else
//			{
//				endColumnIndex--;
//			}
//
//			range = [self rowsInRect:aRect];
//
//			row = range.location;
//			while (row < NSMaxRange(range))
//			{
//				spanRange = [self rangeOfRowSpanAtColumn:columnIndex row:row];
//
//				// Get the rects of the top left of our region (the start column and start row of the span)
//				// to the bottom right (the end column and the row in the span just before the last one).
//				topLeft = [self frameOfCellAtColumn:startColumnIndex row:spanRange.location];
//				bottomRight = [self frameOfCellAtColumn:endColumnIndex row:NSMaxRange(spanRange) - 2];
//
//				rect = NSIntersectionRect(aRect, NSUnionRect(topLeft, bottomRight));
//
//				if (spanRange.length > 1)
//				{
//					// Draw span region without horizontal grid lines
//					[self _drawGrid:origGridMask & ~NSTableViewSolidHorizontalGridLineMask inClipRect:rect];
//
//					// Now, calculate the region at the last row of the span
//					topLeft = [self frameOfCellAtColumn:startColumnIndex row:NSMaxRange(spanRange) - 1];
//					bottomRight = [self frameOfCellAtColumn:endColumnIndex row:NSMaxRange(spanRange) - 1];
//
//					// Draw bottom of span with horizontal grid lines
//					rect = NSIntersectionRect(aRect, NSUnionRect(topLeft, bottomRight) );
//					[self _drawGrid:origGridMask inClipRect:rect];
//				}
//				else
//				{
//					// Not a span row or just a single row. Either way, draw with horizontal grid lines
//					[self _drawGrid:origGridMask inClipRect:rect];
//				}
//				// Advance to the next row span
//				row = NSMaxRange(spanRange);
//			}
//			// Advance to the next span column region
//			startColumnIndex = endColumnIndex + 1;
//		}
//	}
//	else
//	{
//		// We only need the special logic when we have row spanning columns and drawing horizontal lines. Otherwise,
//		// just call super.
//		[super drawGridInClipRect:aRect];
//	}
//}
//
//- (NSCell *)preparedCellAtColumn:(NSInteger)columnIndex row:(NSInteger)rowIndex
//{
//	NSTableColumn				*column;
//
//	column = [[self tableColumns] objectAtIndex:columnIndex];
//
//	if (!_isDrawingStickyRow && [column isRowSpanningEnabled])
//	{
//		NSRange		range;
//
//		range = [self rangeOfRowSpanAtColumn:columnIndex row:rowIndex];
//
//		if (range.length >= 1)
//		{
//			// Here is where we insert our special cell for row spanning behavior
//			NoodleRowSpanningCell	*spanningCell;
//			NSCell					*cell;
//			NSInteger				start, end;
//			BOOL					wasSelected;
//
//			start = range.location;
//			end = NSMaxRange(range) - 1;
//
//			// Want to draw cell in its unhighlighted state since spanning cells aren't selectable. Unfortuantely,
//			// can't just setHighlight:NO on it because NSTableView sets other attributes (like text color).
//			// Instead, we deselect the row, grab the cell, then set it back (if it was selected before).
//			wasSelected = [self isRowSelected:start];
//			[self deselectRow:start];
//
//			cell = [super preparedCellAtColumn:columnIndex row:start];
//
//			if (wasSelected)
//			{
//				[self selectRowIndexes:[NSIndexSet indexSetWithIndex:start] byExtendingSelection:YES];
//			}
//
//			spanningCell = [column spanningCell];
//			[spanningCell setCell:cell];
//
//			// The full frame is the rect encompassing the first and last rows of the span.
//			[spanningCell setFullFrame:NSUnionRect([self frameOfCellAtColumn:columnIndex row:start],
//												   [self frameOfCellAtColumn:columnIndex row:end])];
//			[spanningCell setStartIndex:start];
//			[spanningCell setEndIndex:end];
//
//			[spanningCell setBackgroundColor:[self backgroundColor]];
//
//			return spanningCell;
//		}
//	}
//	return [super preparedCellAtColumn:columnIndex row:rowIndex];
//}
//
//- (void)mouseDown:(NSEvent *)event
//{
//	if (_hasSpanningColumns)
//	{
//		// Eat up any clicks on spanning cells. In the future, may want to consider having clicks select the
//		// first row in the span (like when clicking on the artwork in iTunes).
//
//		NSPoint				point;
//		NSInteger			columnIndex;
//		NSTableColumn		*column;
//
//		point = [event locationInWindow];
//		point = [self convertPointFromBase:point];
//
//		columnIndex = [self columnAtPoint:point];
//		column = [[self tableColumns] objectAtIndex:columnIndex];
//		if ([column isRowSpanningEnabled])
//		{
//			return;
//		}
//	}
//	[super mouseDown:event];
//}
//
//
//- (void)drawRect:(NSRect)dirtyRect
//{
//	[super drawRect:dirtyRect];
//
//	// All that needs to be done to enable the sticky row header functionality (bulk of the work
//	// done in the NSTableView category)
//	if ([self showsStickyRowHeader])
//	{
//		[self drawStickyRowHeader];
//	}
//
//	if (_hasSpanningColumns)
//	{
//		// Clean up any cached data. Don't want to keep stale cache data around.
//		for (NSTableColumn *column in [self tableColumns])
//		{
//			if ([column isRowSpanningEnabled])
//			{
//				[[column spanningCell] _clearOutCaches];
//			}
//		}
//	}
//}
//
//- (void)drawStickyRow:(NSInteger)row clipRect:(NSRect)clipRect
//{
//	_isDrawingStickyRow = YES;
//	[super drawStickyRow:row clipRect:clipRect];
//	_isDrawingStickyRow = NO;
//}
//
//@end
//
