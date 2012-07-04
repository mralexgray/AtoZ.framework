//
//  AZBoxGrid.m
//  AZBoxGrid
//

#import "AZBoxGrid.h"

@interface AZBox ()
@property (nonatomic, assign) NSInteger index;
@end

@interface AZBoxGrid ()
- (void)updateLayout;
@end

@implementation AZBoxGrid
@synthesize cellSize, desiredNumberOfColumns, desiredNumberOfRows;
@synthesize dataSource, delegate;
@synthesize unselectOnMouseUp, allowsSelection, allowsMultipleSelection;

#pragma mark -
#pragma mark Selection

- (NSIndexSet *)selection
{
    return [selection copy];
}

- (void)selectCellAtIndex:(NSUInteger)index
{
    if(!allowsSelection || index == NSNotFound)
        return;
    
    [self selectCellsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)selectCellsAtIndexes:(NSIndexSet *)indexSet
{
    if(!allowsSelection)
        return;
    
    NSIndexSet *oldSelection = [selection copy];
    
    if(allowsMultipleSelection)
    {
        [self deselectAllCells];
        [selection addIndexes:indexSet];
    }
    else
    {
        [self deselectAllCells];
        [selection addIndex:[indexSet firstIndex]];
    }
    
    BOOL delegateSingleClick = [delegate respondsToSelector:@selector(collectionView:didSelectBoxAtIndex:)];
    BOOL delegateDoubleClick = [delegate respondsToSelector:@selector(collectionView:didDoubleClickedCellAtIndex:)];
    
    [selection enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        AZBox *cell = [visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
        [cell setSelected:YES];
        
        if(delegateSingleClick && ![oldSelection containsIndex:index])
        {
            [delegate grid:self didSelectBoxAtIndex:index];
        }
        else if(delegateDoubleClick && [oldSelection containsIndex:index])
        {
            if([NSDate timeIntervalSinceReferenceDate] - lastSelection <= [NSEvent doubleClickInterval])
            {
                if([NSDate timeIntervalSinceReferenceDate] - lastDoubleClick <= [NSEvent doubleClickInterval])
                    return;
                
                [delegate grid:self didDoubleClickedBoxAtIndex:index];
                lastDoubleClick = [NSDate timeIntervalSinceReferenceDate];
            }
        }
    }];
}

- (void)deselectCellAtIndex:(NSUInteger)index
{
    if(index == NSNotFound)
        return;
    
    [self deselectCellsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}

- (void)deselectCellsAtIndexes:(NSIndexSet *)indexSet
{
    NSIndexSet *oldSelection = [selection copy];
    [selection removeIndexes:indexSet]; 
    
    BOOL implementsSelector = [delegate respondsToSelector:@selector(collectionView:didDeselectBoxAtIndex:)];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        AZBox *cell = [visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
        [cell setSelected:NO];
        
        if(implementsSelector && [oldSelection containsIndex:index])
            [delegate grid:self didDeselectBoxAtIndex:index];
    }];
}

- (void)deselectAllCells
{
    NSIndexSet *selectionCopy = [selection copy];
    [self deselectCellsAtIndexes:selectionCopy];
}

- (void)hoverOverCellAtIndex:(NSUInteger)index
{
	if (lastHoverCellIndex != index)
	{
		// un-hover the previous cell
		[self hoverOutOfCellAtIndex:lastHoverCellIndex];
		
		// hover over current cell
		AZBox *cell = [visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
		[cell setHovering:YES];
		lastHoverCellIndex = index;
	}
}

- (void)hoverOutOfCellAtIndex:(NSUInteger)index
{
	AZBox *cell = [visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
	[cell setHovering:NO];
}

- (void)hoverOutOfLastCell
{
    AZBox *cell = [visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:lastHoverCellIndex]];
    [cell setHovering:NO];
}

- (NSUInteger)indexOfCellAtPoint:(NSPoint)point
{
    NSSize boundsSize = [self bounds].size;
    if(point.x < 0.0 || point.y < 0.0 || point.x >= boundsSize.width || point.y >= boundsSize.height)
        return NSNotFound;
    
    point = NSMakePoint(floor(point.x / cellSize.width), floor(point.y / cellSize.height));    
    NSUInteger index = (point.y * numberOfColumns) + point.x;
    
    return index;
}

- (NSUInteger)indexOfCellAtPosition:(NSPoint)point
{
    if(point.x < 0.0 || point.y < 0.0 || point.x >= numberOfColumns || point.y >= numberOfRows)
        return NSNotFound;
    
    point = NSMakePoint(floor(point.x), floor(point.y));    
    NSUInteger index = (point.y * numberOfColumns) + point.x;
    
    if(index >= numberOfCells)
        return NSNotFound;
    
    return index;
}

- (NSPoint)positionOfCellAtIndex:(NSUInteger)index
{
    if(index >= numberOfCells || index == NSNotFound)
        return NSZeroPoint;
    
    NSUInteger x = index % numberOfColumns;
    NSUInteger y = (index - x) / numberOfColumns;
    
    return NSMakePoint(x, y);
}

- (NSRect)rectForCellAtIndex:(NSInteger)index
{
    if(index >= numberOfCells || index == NSNotFound)
        return NSZeroRect;
    
    NSUInteger x = index % numberOfColumns;
    NSUInteger y = (index - x) / numberOfColumns;
    
    return NSMakeRect(x * cellSize.width, y * cellSize.height, cellSize.width, cellSize.height);
}

- (NSIndexSet *)indexesOfCellsInRect:(NSRect)rect
{
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for(AZBox *cell in [visibleCells allValues])
    {
        if(NSIntersectsRect([cell frame], rect))
            [indexSet addIndex:[cell index]];
    }
    
    return indexSet;
}

#pragma mark -
#pragma mark Cells

- (AZBox *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    NSMutableArray *queue = [reusableCellQueues objectForKey:identifier];
    if([queue count] > 0)
    {
        AZBox *cell = [queue lastObject];
        [queue removeLastObject];
        
//        [cell prepareForReuse];
        return cell;
    }
    
    return nil;
}

- (AZBox *)cellAtIndex:(NSUInteger)index
{
    return [visibleCells objectForKey:[NSNumber numberWithUnsignedInteger:index]];
}

- (void)queueCell:(AZBox *)cell
{
    [visibleCells removeObjectForKey:[NSNumber numberWithUnsignedInteger:cell.index]];
    
    [cell removeFromSuperview];
    [cell setIndex:-1];
    
    if([reusableCellQueues objectForKey:cell.cellIdentifier])
    {
        [[reusableCellQueues objectForKey:cell.cellIdentifier] addObject:cell];
    }
    else
    {
        NSMutableArray *array = [NSMutableArray arrayWithObject:cell];
        [reusableCellQueues setObject:array forKey:cell.cellIdentifier];
    }
}



- (void)reorderCellsAnimated:(BOOL)animated
{
    if(animated)
    {
        [NSAnimationContext beginGrouping];
        [[NSAnimationContext currentContext] setDuration:0.1];
    }
    
    for(AZBox *cell in [visibleCells allValues])
    {
        NSRect rect = [self rectForCellAtIndex:[cell index]];
        
        if(animated)
            [[cell animator] setFrame:rect];
        else
            [cell setFrame:rect];
    }
	
    if(animated)
        [NSAnimationContext endGrouping];
}

- (void)removeInvisibleCells
{
    NSRange range  = [self visibleRange];
    NSArray *cells = [visibleCells allValues];
    
    for(AZBox *cell in cells)
    {
        if(!NSLocationInRange([cell index], range))
        {
            [self queueCell:cell];
        }
    }
}

- (void)addMissingCells
{
    NSRange range = [self visibleRange];
    NSMutableIndexSet *missingIndicies = [NSMutableIndexSet indexSetWithIndexesInRange:range];
    
    for(AZBox *cell in [visibleCells allValues])
    {
        if(NSLocationInRange([cell index], range))
        {
            [missingIndicies removeIndex:[cell index]];
        }
    }
    
    [missingIndicies enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop){
        AZBox *cell = [dataSource grid:self boxForIndex:index];
        
        if(!cell)
            return;
        
        if([selection containsIndex:index])
            [cell setSelected:YES];
        
        [cell setIndex:index];
        [cell setFrame:[self rectForCellAtIndex:index]];
        
        [self addSubview:cell];
        [visibleCells setObject:cell forKey:[NSNumber numberWithUnsignedInteger:index]];
    }];
}

- (void)reloadData
{
    if(updatingData)
    {
        calledReloadData = YES;
        return;
    }
    
    for(NSView *view in [visibleCells allValues])
        [view removeFromSuperview];
    
    [visibleCells removeAllObjects];
    [reusableCellQueues removeAllObjects];
    [selection removeAllIndexes];
    
    numberOfCells = [dataSource numberOfBoxesInGrid:self];    
    
    [self updateLayout];
    [self addMissingCells];
}

#pragma mark -
#pragma mark Row and Column handling

- (void)scrollViewDidScroll:(NSNotification *)notification
{
    [self removeInvisibleCells];
    [self addMissingCells];
    [self setNeedsDisplay:YES];
}

- (NSRange)visibleRange
{
    NSRect rect = [self visibleRect];
    rect.origin.y -= cellSize.height;
    rect.size.height += (cellSize.height * 2);
    
    if(rect.origin.y < 0.0)
        rect.origin.y = 0.0;
    
    NSInteger rows = rect.origin.y / cellSize.height;
    NSInteger startIndex = rows * numberOfColumns;
    NSInteger endIndex = 0;
    
    rows = (rect.origin.y + rect.size.height) / cellSize.height;
    endIndex = rows * numberOfColumns;
    endIndex = MIN(numberOfCells, endIndex);
    
    return NSMakeRange(startIndex, endIndex-startIndex);
}

- (void)updateLayout
{
    if(updatingData)
        return;
    
    NSRect frame = [self frame];
    CGFloat width, height;
    
    // Calculate new boundaries for the view...
    if(desiredNumberOfColumns == NSUIntegerMax)
    {
        numberOfColumns = floorf((float)frame.size.width / cellSize.width);
        width = frame.size.width;
    }
    else
    {
        numberOfColumns = desiredNumberOfColumns;
        width = numberOfColumns * cellSize.width;
    }
    
    
    if(desiredNumberOfRows == NSUIntegerMax && numberOfColumns > 0)
    {
        numberOfRows = ceilf((float)numberOfCells / numberOfColumns);
        height = numberOfRows * cellSize.height; 
    }
    else
    {
        numberOfRows = desiredNumberOfRows;
        height = numberOfRows * cellSize.height; 
    }
    
    
    frame.size.width  = width;
    frame.size.height = height;
    
    
    
    // Update the frame and then all cells
    [super setFrame:frame];
    
    [self reorderCellsAnimated:YES];
    [self removeInvisibleCells];
    [self addMissingCells];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [self updateLayout];
}

- (void)setCellSize:(NSSize)newCellSize
{
    cellSize = newCellSize;
    [self updateLayout];
}

- (void)setDesiredNumberOfColumns:(NSUInteger)newDesiredNumberOfColumns
{
    desiredNumberOfColumns = newDesiredNumberOfColumns;
    [self updateLayout];
}

- (void)setDesiredNumberOfRows:(NSUInteger)newDesiredNumberOfRows
{
    desiredNumberOfRows = newDesiredNumberOfRows;
    [self updateLayout];
}

- (void)beginChanges
{
    if(updatingData)
        return;
    
    updatingData = YES;
}

- (void)commitChanges
{
    updatingData = NO;
    
    if(calledReloadData)
    {
        [self reloadData];
    }
    else
    {
        [self updateLayout];
    }
    
    calledReloadData = NO;
}

#pragma mark -
#pragma mark Constructor / Destructor

- (void)setupCollectionView
{
    desiredNumberOfColumns  = NSUIntegerMax;
    desiredNumberOfRows     = NSUIntegerMax;
    
    reusableCellQueues  = [[NSMutableDictionary alloc] init];
    visibleCells        = [[NSMutableDictionary alloc] init];
    
    selection = [[NSMutableIndexSet alloc] init];
    allowsSelection = YES;
	lastHoverCellIndex = -1;
    
    cellSize = NSMakeSize(32.0, 32.0);
	
	NSTrackingArea *area = [[NSTrackingArea alloc] initWithRect:[self frame] 
														options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect)
														  owner:self
													   userInfo:nil];
	[self addTrackingArea:area];
//	[area release];	
    
    NSClipView *clipView = [[self enclosingScrollView] contentView];
    [clipView setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidScroll:) name:NSViewBoundsDidChangeNotification object:clipView];
    
    [self updateLayout];
    [self reloadData];
}


- (BOOL)isFlipped
{
    return YES;
}


- (id)initWithFrame:(NSRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        [self setupCollectionView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super initWithCoder:decoder]))
    {
        [self setupCollectionView];
    }
    
    return self;
}

- (void)dealloc
{
//    [reusableCellQueues release];
//    [visibleCells release];
//    [selection release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [super dealloc];
}

@end
