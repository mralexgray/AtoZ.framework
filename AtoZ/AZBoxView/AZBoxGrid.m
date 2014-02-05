
#import <Foundation/Foundation.h>
#import "AZBoxGrid.h"
#import "AZBox.h"
#import "AtoZ.h"
@class MyScrollView;
@interface AZBoxGrid  ()
{		
//	__weak MyScrollView *scrollView;
}// called when scroll view changed the size of content view
//- (void)updateScrollValues:(MyScrollView *)scrollView;

// called when content view is scrolled
//- (void)scrollValueChanged:(MyScrollView *)scrollView;

@end

@interface AZBoxGrid ()
- (void)updateLayout;
@end

@class MyScrollView;
@implementation AZBoxGrid
@synthesize cellSize, desiredNumberOfColumns, desiredNumberOfRows;
@synthesize dataSource, delegate, magicSizing;
@synthesize unselectOnMouseUp, allowsSelection, allowsMultipleSelection;
@synthesize boxRadius = boxRadius_, boxInset = boxInset_, scalar = scalar_;
@synthesize numberOfRows, numberOfColumns;

#pragma mark - Selection


- (NSIndexSet *)selection {
	return [selection copy];
}

- (float) boxInset {
	AZBox *cell = [[visibleCells allValues]randomElement];
	return cell.inset;
}
- (float) boxRadius {
	AZBox *cell = [[visibleCells allValues]randomElement];
	return cell.radius;
}

- (void) setScalar:(float)scalar {
	scalar_ = scalar;
	self.cellSize = NSMakeSize(scalar_,scalar_);
	[self updateLayout];
}

- (void) setBoxRadius:(float)boxRadius {
	if (boxRadius_ != boxRadius) {
		boxRadius_ = boxRadius;
		for (AZBox * b in [self subviews]) {
			b.radius = boxRadius;
			b.needsDisplay = YES;
		}
	}
}

- (void) setBoxInset:(float)boxInset {
	if (boxInset_ != boxInset) {
		boxInset_ = boxInset;
		for (AZBox * b in [self subviews]) {
			b.inset = boxInset;
			b.needsDisplay = YES;
		}
	}
}
//- (void) viewDidEndLiveResize {
//	[self setMaximizeIdeally:maximizeIdeally];

//}

- (void)selectCellAtIndex:(NSUInteger)index 		  {
	if(!allowsSelection || index == NSNotFound)
		return;
	[self selectCellsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}
- (void)selectCellsAtIndexes:(NSIndexSet *)indexSet 	  {
	if(!allowsSelection)
		return;
	NSIndexSet *oldSelection = [selection copy];
	if(allowsMultipleSelection) {
		
		[self deselectAllCells];
		[selection addIndexes:indexSet];
	}
	else {
		
		[self deselectAllCells];
		[selection addIndex:[indexSet firstIndex]];
	}
	BOOL delegateSingleClick = [delegate respondsToSelector:@selector(collectionView:didSelectCellAtIndex:)];
	BOOL delegateDoubleClick = [delegate respondsToSelector:@selector(collectionView:didDoubleClickedCellAtIndex:)];
	[selection enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		AZBox *cell = visibleCells[@(index)];
		NSLog(@"about your selection: %@", cell.propertiesPlease);
//		NSLog(@"parent: %@.  siblings:%@", cell.superview,[cell.superview subviews]);
		[(NSObject*)[NSApp delegate] setValue:$(@"%ld",cell.superview.subviews.count) forKey:@"activeViews"];
		NSLog(@"%@", NSStringFromRange([(AZBoxGrid*)cell.superview visibleRange]));
	NSLog(@"%@",[(AZBoxGrid*)cell.superview propertiesPlease]);

		[cell setSelected:YES];
		if(delegateSingleClick && ![oldSelection containsIndex:index]) {
			[delegate collectionView:self didSelectCellAtIndex:index];
		}
		else if(delegateDoubleClick && [oldSelection containsIndex:index]) {
			if([NSDate timeIntervalSinceReferenceDate] - lastSelection <= [NSEvent doubleClickInterval]) {
				if([NSDate timeIntervalSinceReferenceDate] - lastDoubleClick <= [NSEvent doubleClickInterval])
					return;
				[delegate collectionView:self didDoubleClickedCellAtIndex:index];
				lastDoubleClick = [NSDate timeIntervalSinceReferenceDate];
			}
		}
	}];
}
- (void)deselectCellAtIndex:(NSUInteger)index 		  {
	if(index == NSNotFound)
		return;
	[self deselectCellsAtIndexes:[NSIndexSet indexSetWithIndex:index]];
}
- (void)deselectCellsAtIndexes:(NSIndexSet *)indexSet {
	NSIndexSet *oldSelection = [selection copy];
	[selection removeIndexes:indexSet];
	BOOL implementsSelector = [delegate respondsToSelector:@selector(collectionView:didDeselectCellAtIndex:)];
	[indexSet enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
		AZBox *cell = visibleCells[@(index)];
		[cell setSelected:NO];
		if(implementsSelector && [oldSelection containsIndex:index])
			[delegate collectionView:self didDeselectCellAtIndex:index];
	}];
}
- (void)deselectAllCells {
	NSIndexSet *selectionCopy = [selection copy];
	[self deselectCellsAtIndexes:selectionCopy];
}

- (void)hoverOverCellAtIndex:(NSUInteger)index 		{
	if (lastHoverCellIndex != index) {
		// un-hover the previous cell
		[self hoverOutOfCellAtIndex:lastHoverCellIndex];
		// hover over current cell
		AZBox *cell = visibleCells[@(index)];
		[cell setHovered:YES];
		lastHoverCellIndex = index;
	}
}
- (void)hoverOutOfCellAtIndex:(NSUInteger)index 	{
	AZBox *cell = visibleCells[@(index)];
	[cell setHovered:NO];
}
- (void)hoverOutOfLastCell {
	AZBox *cell = visibleCells[@(lastHoverCellIndex)];
	[cell setHovered:NO];
}
- (NSUInteger)indexOfCellAtPoint:(NSPoint)point 	{
	NSSize boundsSize = [self bounds].size;
	if(point.x < 0.0 || point.y < 0.0 || point.x >= boundsSize.width || point.y >= boundsSize.height)
		return NSNotFound;
	point = NSMakePoint(floor(point.x / cellSize.width), floor(point.y / cellSize.height));
	NSUInteger index = (point.y * numberOfColumns) + point.x;
	return index;
}
- (NSUInteger)indexOfCellAtPosition:(NSPoint)point 	{
	if(point.x < 0.0 || point.y < 0.0 || point.x >= numberOfColumns || point.y >= numberOfRows)
		return NSNotFound;
	point = NSMakePoint(floor(point.x), floor(point.y));
	NSUInteger index = (point.y * numberOfColumns) + point.x;
	if(index >= numberOfCells)
		return NSNotFound;
	return index;
}
- (NSPoint)positionOfCellAtIndex:(NSUInteger)index 	{
	if(index >= numberOfCells || index == NSNotFound)
		return NSZeroPoint;
	NSUInteger x = index % numberOfColumns;
	if (x <1) x = 1;
	NSUInteger y = (index - x) / numberOfColumns;
	return NSMakePoint(x, y);
}
- (NSRect)rectForCellAtIndex:(NSInteger)index		{
	if(index >= numberOfCells || index == NSNotFound)
		return NSZeroRect;
	NSUInteger x = index % numberOfColumns;
	NSUInteger y = (index - x) / numberOfColumns;
	return NSMakeRect(x * (cellSize.width /1), y * (cellSize.height*1), cellSize.width, cellSize.height);
}
- (NSIndexSet *)indexesOfCellsInRect:(NSRect)rect 	{
	NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
	for(AZBox *cell in [visibleCells allValues]) {
		
		if(NSIntersectsRect([cell frame], rect))
			[indexSet addIndex:[cell index]];
	}
	return indexSet;
}

#pragma mark - Cells

- (AZBox *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
	NSMutableArray *queue = reusableCellQueues[identifier];
	if([queue count] > 0) {
		
		AZBox *cell = [queue lastObject];
		[queue removeLastObject];
		[cell prepareForReuse];
		return cell;
	}
	return nil;
}
- (AZBox *)cellAtIndex:(NSUInteger)index {
	return visibleCells[@(index)];
}
- (void)queueCell:(AZBox *)cell {
	[visibleCells removeObjectForKey:[NSNumber numberWithUnsignedInteger:cell.index]];
	[cell removeFromSuperview];
	[cell setIndex:-1];
	if(reusableCellQueues[cell.cellIdentifier]) {
		
		[reusableCellQueues[cell.cellIdentifier] addObject:cell];
	}
	else {
		
		NSMutableArray *array = [NSMutableArray arrayWithObject:cell];
		reusableCellQueues[cell.cellIdentifier] = array;
	}
}

- (void)reorderCellsAnimated:(BOOL)animated {
	if(animated) {
		
		[NSAnimationContext beginGrouping];
		[[NSAnimationContext currentContext] setDuration:0.1];
	}
	for(AZBox *cell in [visibleCells allValues]) {
		
		NSRect rect = [self rectForCellAtIndex:[cell index]];
		if(animated)
			[[cell animator] setFrame:rect];
		else
			[cell setFrame:rect];
	}
	if(animated)
		[NSAnimationContext endGrouping];
}
- (void)removeInvisibleCells {
	if (self.magicSizing) return;
	NSRange range  = [self visibleRange];
	NSArray *cells = [visibleCells allValues];
	for(AZBox *cell in cells) {
		
		if(!NSLocationInRange([cell index], range)) {
			
			[self queueCell:cell];
		}
	}
}
- (void)addMissingCells 	 {
	NSRange range = [self visibleRange];
	NSMutableIndexSet *missingIndicies = [NSMutableIndexSet indexSetWithIndexesInRange:range];
	for(AZBox *cell in [visibleCells allValues]) {
		
		if(NSLocationInRange([cell index], range)) {
			
			[missingIndicies removeIndex:[cell index]];
		}
	}
	[missingIndicies enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop){
		AZBox *cell = [[self dataSource] collectionView:self cellForIndex:index];
		if(!cell)
			return;
		if([selection containsIndex:index])
			[cell setSelected:YES];
		[cell setIndex:index];
		[cell setFrame:[self rectForCellAtIndex:index]];
//		[cell setHidden:YES];
		[self addSubview:cell];
//		[cell fadeIn];
//		[self per performSelector:@selector(fadeIn) afterDelay:index*.01];
		visibleCells[@(index)] = cell;
	}];
}
- (void)reloadData 			 {
	if(updatingData) {
		calledReloadData = YES;
		return;
	}
	
	for(NSView *view in [visibleCells allValues])
		[view removeFromSuperview];
	[visibleCells removeAllObjects];
	[reusableCellQueues removeAllObjects];
	[selection removeAllIndexes];
	numberOfCells = [dataSource numberOfCellsInCollectionView:self];
	[self updateLayout];
	[self addMissingCells];
}

#pragma mark - Row and Column handling

- (void)scrollViewDidScroll:(NSNotification *)notification {
	[self removeInvisibleCells];
	[self addMissingCells];
	[self updateLayout];
	[self setNeedsDisplay:YES];
}
- (NSRange)visibleRange {
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
- (void)updateLayout 	{
	if(updatingData) {// || ([self inLiveResize]) )
		return;}
//	NSThread *thread;
//	if (self.magicSizing) {
//		[self performSelector:@selector(updateMagicSizing) onThread:thread withObject:nil waitUntilDone:YES];
//		[self updateMagicSizing];
//	} else {
			
		NSRect frame = [self frame];
		CGFloat width, height;
		// Calculate new boundaries for the view...
		if(desiredNumberOfColumns == NSUIntegerMax) {
			
			numberOfColumns = floorf((float)frame.size.width / cellSize.width);
			if (numberOfColumns < 1) numberOfColumns = 1;
			width = frame.size.width;
		}
		else {
			
			numberOfColumns = desiredNumberOfColumns;
			if (numberOfColumns < 1) numberOfColumns = 1;
			width = numberOfColumns * cellSize.width;
		}
		
		if(desiredNumberOfRows == NSUIntegerMax && numberOfColumns > 0) {
			
			numberOfRows = ceilf((float)numberOfCells / numberOfColumns);
			height = numberOfRows * cellSize.height;
		}
		else {
			
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
//	}
}
- (void)setFrame:(NSRect)frameRect		{
	[super setFrame:frameRect];
	[self updateLayout];
}
- (void)setCellSize:(NSSize)newCellSize {
	cellSize = newCellSize;
	[self updateLayout];
}
- (void)setDesiredNumberOfColumns:(NSUInteger)newDesiredNumberOfColumns {
//	if (desiredNumberOfRows) desiredNumberOfRows = NSUIntegerMax;
	desiredNumberOfColumns = newDesiredNumberOfColumns;
	[self updateLayout];
}
- (void)setDesiredNumberOfRows:(NSUInteger)newDesiredNumberOfRows 		{
//	if (desiredNumberOfColumns) desiredNumberOfColumns = NSUIntegerMax;
	desiredNumberOfRows = newDesiredNumberOfRows;
	[self updateLayout];
}
- (void)beginChanges 		{
	if(updatingData)
		return;
	updatingData = YES;
}
- (void)commitChanges		{
	updatingData = NO;
	if(calledReloadData) {
		
		[self reloadData];
	}
	else {
		
		[self updateLayout];
	}
	calledReloadData = NO;
}

#pragma mark - Constructor / Destructor

- (void)setupCollectionView {
	desiredNumberOfColumns  = NSUIntegerMax;
	desiredNumberOfRows	 = NSUIntegerMax;
	reusableCellQueues  = NSMutableDictionary.new;
	visibleCells		= NSMutableDictionary.new;
	selection 			= NSMutableIndexSet.new;
	allowsSelection = YES;
	lastHoverCellIndex = -1;
	cellSize = NSMakeSize(128.0, 128.0);
	NSTrackingArea *area = [NSTrackingArea.alloc initWithRect:[self frame]
														options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect |
																 NSTrackingMouseMoved
																 )
														  owner:self
													   userInfo:nil];
	[self addTrackingArea:area];
	if ([self enclosingScrollView]) {
		NSClipView *clipView = [[self enclosingScrollView] contentView];
		[clipView setPostsBoundsChangedNotifications:YES];
		[clipView setCopiesOnScroll:YES];
	
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidScroll:) name:NSViewBoundsDidChangeNotification object:clipView];
	} else self.magicSizing = YES;

	[self updateLayout];
	[self reloadData];
}
- (BOOL)isFlipped 			{
	return YES;
}
- (id)initWithFrame:(NSRect)frame 		{
	if((self = [super initWithFrame:frame])) {
		if ([self enclosingScrollView])
			[[[self enclosingScrollView] contentView] setPostsBoundsChangedNotifications:YES];
		[self setupCollectionView];
	}
	return self;
}
- (id)initWithCoder:(NSCoder *)decoder 	{
	if((self = [super initWithCoder:decoder])) {
		
		[self setupCollectionView];
	}
	return self;
}
- (void)dealloc		{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Event Handling

- (void)mouseDown:(NSEvent *)event 		{
	[[self window] makeFirstResponder:self];
	
	NSUInteger index;
	NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
	index = [self indexOfCellAtPoint:mousePoint];
	
	[self selectCellAtIndex:index];
/**	AZBox *i = [self cellAtIndex:index];
	NSSize zDragOffset = NSMakeSize(0.0, 0.0);
	NSPasteboard *zPasteBoard = [NSPasteboard pasteboardWithName:NSDragPboard];
	[zPasteBoard declareTypes:[NSArray arrayWithObject:NSTIFFPboardType]
						owner:self];
	NSImage *snap = [(NSView*)i snapshot];
	[zPasteBoard setData:[snap TIFFRepresentation] 
				 forType:NSTIFFPboardType];
	
	NSPoint originFlip  = i.frame.origin;
	originFlip.y += i.frame.size.height;
	[self dragImage:snap
				 at:originFlip
			 offset:zDragOffset
			  event:event
		 pasteboard:zPasteBoard 
			 source:self 
		  slideBack:YES];
	*/
	return;
	
}
- (void)mouseDragged:(NSEvent *)event 	{
	NSUInteger index;
	NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
	index = [self indexOfCellAtPoint:mousePoint];
	
	[self selectCellAtIndex:index];
	[self autoscroll:event];
}
- (void)mouseMoved:(NSEvent *)event 	{
	NSUInteger index;
	NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
	index = [self indexOfCellAtPoint:mousePoint];
	
	[self hoverOverCellAtIndex:index];
	
//	float x  = NSMidX([self bounds]) - mousePoint.x;
//  this will log ALL mouse movements.. annoying
//	NSLog(@"x pos: %f", x);
}
- (void)mouseExited:(NSEvent *)theEvent {
	[self hoverOutOfLastCell];
}
- (void)mouseUp:(NSEvent *)event		{
	NSUInteger index;
	NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
	index = [self indexOfCellAtPoint:mousePoint];
	
	[self selectCellAtIndex:index];
	
	if(unselectOnMouseUp)
		[self deselectAllCells];
	
	lastSelection = [NSDate timeIntervalSinceReferenceDate];
}
- (void)keyDown:(NSEvent *)event 		{
	if([[self selection] count] == 0)
		return;
	
	NSUInteger index = [[self selection] firstIndex];
	BOOL isSelectionEvent = NO;
	
	switch([event keyCode])
	{
		case 123: // Left
			index --;
			isSelectionEvent = YES;
			break;
			
		case 124: // Right
			index ++;
			isSelectionEvent = YES;
			break;
			
		case 125: // Down
		{
			NSPoint point = [self positionOfCellAtIndex:index];
			point.y += 1;
			
			index = [self indexOfCellAtPosition:point];
			isSelectionEvent = YES;
			break;
		}
			
		case 126: // Up
		{
			NSPoint point = [self positionOfCellAtIndex:index];
			point.y -= 1;
			
			index = [self indexOfCellAtPosition:point];
			isSelectionEvent = YES;
			break;
		}
			
		default:
			break;
	}
	
	if(isSelectionEvent)
	{
		[self deselectAllCells];
		[self selectCellAtIndex:index];
		
		return;
	}
	
	BOOL delegateImplements = [delegate respondsToSelector:@selector(collectionView:keyEvent:forCellAtIndex:)];
	if(!delegateImplements)
		return;
	
	[[self selection] enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop){
		[delegate collectionView:self keyEvent:event forCellAtIndex:index];
	}];
}

@end
