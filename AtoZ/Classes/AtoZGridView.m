
#import <AtoZ/AtoZ.h>
#import "AtoZGridView.h"

NSS *const reuseIdentifier = @"AtoZGridViewItem";

#pragma mark CNSelectionFrameView
@interface CNSelectionFrameView : NSView @end

typedef NS_ENUM(NSUI,CNClick) { CNSingleClick = 1, CNDoubleClick, CNTrippleClick };
typedef struct    CNItemPoint { NSUI column; NSUI row; } CNItemPoint;
CNItemPoint CNMakeItemPoint(NSUI c, NSUI r) { return (CNItemPoint) { .column = c, .row = r }; }

@interface AZGView ()

@property CNSelectionFrameView *selectionFrameView;

@property NSMD * keyedVisibleItems, *reuseableItems, *selectedItems, *selectedItemsBySelectionFrame;
@property NSTA * gridViewTrackingArea;
@property NSMA * clickEvents;
@property  TMR * clickTimer;
@property  CGP 	selectionFrameInitialPoint;
@property BOOL  isInitialCall, abortSelection;
@property  NSI 	lastHoveredIndex, lastSelectedIndex, numberOfItems;
@end

@class AtoZGridViewItem;
@implementation AtoZGridView { CIImage *inputMaskImage, *inputShadingImage; }

DEFAULTINIT(setupDefaults)

- (void) setupDefaults
{
  _itemBackgroundColor            = GRAY2;///[NSC colorWithCalibratedWhite:0.238 alpha:1.000];
  _itemBackgroundHoverColor       = GREEN;
  _itemBackgroundSelectionColor   = GRAY5;//[NSC colorWithCalibratedWhite:0.172 alpha:1.000];
  _itemSelectionRingColor         = WHITE;//[NSC colorWithCalibratedWhite:0.740 alpha:1.000];
	_itemTitleColor                 = GRAY9;//[NSC colorWithDeviceRed:0.969 green:0.994 blue:0.994 alpha:1.000];
  _itemTitleShadowColor   = BLACK;//[NSC colorWithDeviceWhite:0.011 alpha:0.930];
	_selectionFrameColor    = [NSC r:.908 g:.784 b:.17 a:1];
  _backgroundColor        = GRAY8;//[NSC colorWithCalibratedWhite:0.137 alpha:1.000];

	_visibleContentMask   = (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle);
	_itemTitleTextAttributes        = @{ NSFontAttributeName : [AtoZ font:@"UbuntuMono-Bold" size:14],
                                     NSShadowAttributeName : [NSSHDW shadowWithColor:self.itemTitleShadowColor offset:NSMakeSize(.5, -1) blurRadius:2],
                            NSForegroundColorAttributeName : self.itemTitleColor,
                             NSParagraphStyleAttributeName : [NSParagraphStyle defaultParagraphStyleWithDictionary:@{@"alignment":@(NSCenterTextAlignment)}]};
  // private properties
  _keyedVisibleItems              = NSMD.new;
  _reuseableItems                 = NSMD.new;
  _selectedItems                  = NSMD.new;
  _selectedItemsBySelectionFrame  = NSMD.new;
	// public properties
	_itemSize                       = AZSizeFromDim(96);// [AZGVItem defaultItemSize];
	_allowsMultipleSelection        =
	_useSelectionRing               =
  _allowsSelection                =
//  _scrollElasticity               =
  _useHover                       =
  _isInitialCall                  = YES;
	_lastHoveredIndex               = _lastSelectedIndex = NSNotFound;
	_clickEvents                    = NSMA.new;

}

	//	[self updateSubviewsWithTransition:@"CIRippleTransition"];
	//	self.enclosingScrollView.drawsBackground 	= YES;
	//	self.enclosingScrollView.backgroundColor = [NSC redColor];
//	NSClipView *clipView 						= self.enclosingScrollView.contentView;
//	clipView.postsBoundsChangedNotifications	= YES;
//	[AZNOTCENTER addObserver:self selector:@selector(updateVisibleRect) name:NSViewBoundsDidChangeNotification object:clipView];

- (void) viewDidMoveToSuperview {

  [@[@"horizontalScrollElasticity", @"verticalScrollElasticity"] do:^(id obj) {
    [self.enclosingScrollView b:obj tO:self wKP:@"scrollElasticity" t:^id(id v) { return [v bV] ? @(NSScrollElasticityAllowed) : @(NSScrollElasticityNone); }];
  }];
  [self.enclosingScrollView.contentView setPostsBoundsChangedNotifications:YES];
	[AZNOTCENTER observeName:NSViewBoundsDidChangeNotification usingBlock:^(NSNotification *n) {
    XX(n);
  }];

//	self.enclosingScrollView.drawsBackground 	= NO; self.enclosingScrollView.backgroundColor = [NSC redColor];
}

#pragma mark - Accessors

- (void) setItemSize:(NSSize)itemSize {

	_selectionRingLineWidth = _itemBorderRadius = .05 * (_itemSize = itemSize).width; // kDefaultSelectionRingLineWidth;
	_contentInset           = .1 * _itemSize.width;                                   // kDefaultContentInset;   //kDefaultItemBorderRadius;
	[self refreshGridViewAnimated:YES];
}

- (void) drawRect:(NSR)dirtyRect { 	NSRectFillWithColor(self.bounds, _backgroundColor);  }

- (void) setAllowsMultipleSelection:(BOOL)allow {

  IF_VOID(_allowsMultipleSelection == allow);
  IF_VOID(_allowsMultipleSelection || _selectedItems.count <= 1);
  [_selectedItems each:^(id key, AZGVItem *item) {
    item.isSelected = NO;
    [self.selectedItems removeObjectForKey:key];
  }];
  [self updateVisibleRect];
}

#pragma mark - Private Helper

- (void) updateVisibleRect { [self updateReuseableItems]; [self updateVisibleItems]; [self arrangeGridViewItemsAnimated:NO]; }

- (void) refreshGridViewAnimated:(BOOL)ani {
//	NSR scrollRect = [self frame]; scrollRect.size.width = scrollRect.size.width; scrollRect.size.height = [self allOverRowsInGridView] * self.itemSize.height;
	super.frame = AZRectExceptHigh(self.frame, self.allOverRowsInGridView * _itemSize.height );
//  super.frame = AZRectExceptHigh(self.frame, self.allOverRowsInGridView * _itemSize.height );


	[self updateReuseableItems];	[self updateVisibleItems];	[self arrangeGridViewItemsAnimated:ani];
}

- (void) updateReuseableItems {

	NSRange currentRange = self.currentRange;
	[_keyedVisibleItems.allValues eachWithIndex:^(AZGVItem *item, NSInteger idx) {
		IF_VOID(NSLocationInRange(item.index, currentRange) || !item.isReuseable);
    [_keyedVisibleItems removeObjectForKey:@(item.index)];
    [item removeFromSuperview];	  	   [item prepareForReuse]; // NSMSet *reuseQueue = ; [reuseQueue addObject:item];
    self.reuseableItems[item.reuseIdentifier] = [_reuseableItems[item.reuseIdentifier] ?: NSSet.new setByAddingObject:item];
	}];
}
- (void) updateVisibleItems {

	NSMIS *visibleItemIndexes = [NSMIS indexSetWithIndexesInRange:self.currentRange]; //  NSRange currentRange =
	[visibleItemIndexes removeIndexes:self.indexesForVisibleItems];
	/// update all visible items
	[visibleItemIndexes enumerateIndexesUsingBlock:^(NSUI idx, BOOL *stop) { AZGVItem *item;

    IF_VOID(!(item = [self gridView:self itemAtIndex:idx inSection:0]));
		item.index = idx;
    if (self.isInitialCall) {
      item.alphaValue	= 0;
      item.frame		= [self rectForItemAtIndex:idx];
    }
    self.keyedVisibleItems[@(item.index)] = item;
    [self.animator addSubview:item];
	}];
}
- (NSIS*) indexesForVisibleItems {

  return [NSIS indexWithIndexes:[_keyedVisibleItems mapToArray:^id(id k, AZGVItem* obj) {
    return @(obj.index);
	}]];
}

- (void)updateSubviewsWithTransition:(NSS*)transition {

	NSRect		rect = self.bounds;
	CIFilter	*transitionFilter = nil;
	// Use Core Animation's four built-in CATransition types, or an appropriately instantiated and configured Core Image CIFilter.
	transitionFilter = [CIFilter filterWithDefaultsNamed:transition];
	[transition loMismo:@"CICopyMachineTransition"] ?
	[transitionFilter sV:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] fK:@"inputExtent"] :
	[transition loMismo:@"CIDisintegrateWithMaskTransition"] ? ^{
		// scale our mask image to match the transition area size, and set the scaled result as the "inputMaskImage" to the transitionFilter.
		CIFilter *maskScalingFilter = [CIFilter filterWithDefaultsNamed:@"CILanczosScaleTransform"];
    CGRect maskExtent = inputMaskImage.extent;
		float xScale = rect.size.width / maskExtent.size.width;
		float yScale = rect.size.height / maskExtent.size.height;
		[maskScalingFilter sV:@(yScale) fK:@"inputScale"];
		[maskScalingFilter sV:@(xScale / yScale) fK:@"inputAspectRatio"];
		[maskScalingFilter sV:inputMaskImage fK:@"inputImage"];
		[transitionFilter sV:[maskScalingFilter valueForKey:@"outputImage"] fK:@"inputMaskImage"]; }() :
	[transition loMismo:@"CIFlashTransition"] ? ^{
		[transitionFilter sV:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] fK:@"inputCenter"];
		[transitionFilter sV:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] fK:@"inputExtent"]; }() :
	[transition loMismo:@"CIModTransition"] ?
	[transitionFilter sV:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] fK:@"inputCenter"] :[transition loMismo:@"CIPageCurlTransition"] ? ^{
		[transitionFilter sV:@(-M_PI_4) fK:@"inputAngle"];
		[transitionFilter sV:inputShadingImage fK:@"inputShadingImage"];
		[transitionFilter sV:inputShadingImage fK:@"inputBacksideImage"];
		[transitionFilter sV:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] fK:@"inputExtent"]; }() :
	[transition loMismo:@"CIRippleTransition"] ? ^{
		[transitionFilter sV:[CIVector vectorWithX:NSMidX(rect) Y:NSMidY(rect)] fK:@"inputCenter"];
		[transitionFilter sV:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] fK:@"inputExtent"];
		[transitionFilter sV:inputShadingImage fK:@"inputShadingImage"];
	}() : nil;
	CATransition *newTransition = [CATransition animation];	// new CATransition that describes the transition
	// we want to build a CIFilter-based CATransition. When an CATransition's "filter" property is set, the CATransition's "type" and "subtype" properties are ignored, so we don't need to bother setting them.   else we want to specify one of Core Animation's built-in transitions.
	transitionFilter ? [newTransition setFilter:transitionFilter] : ^{ [newTransition setType:transition]; [newTransition setSubtype:kCATransitionFromLeft]; }();
	// specify an explicit duration for the transition.
	[newTransition setDuration:1.0];
	// associate the CATransition we've just built with the "subviews" key for this SlideshowView instance,
	// so that when we swap ImageView instances in our -transitionToImage: method below (via -replaceSubview:with:).
	[self setAnimations:@{@"alphaValue": newTransition, @"frame":newTransition}];
}


- (void) arrangeGridViewItemsAnimated:(BOOL)animated {	[self updateSubviewsWithTransition:@"CICopyMachineTransition"];

	/// on initial call (aka application startup) we will fade all items (after loading it) in
  [NSACTX runAnimationBlock:^{ // [NSAnimationContext beginGrouping];  [[NSAnimationContext currentContext] setDuration:(animated ? 1 : 0.0)];
  	_isInitialCall && _keyedVisibleItems.count ?
      _isInitialCall = NO,
      [_keyedVisibleItems enumerateKeysAndObjectsUsingBlock:^(id key, AZGVItem* obj, BOOL *stop) {
				[[obj layer] addAnimation:[CATransition transitionOfType:kCATransitionMoveIn] forKey:@"isSelected"];
				[[obj animator] setAlphaValue:1.0];
			}]
  : _keyedVisibleItems.count ?

      [_keyedVisibleItems each:^(id key, AZGVItem* obj){ [obj.animator setFrame:[self rectForItemAtIndex:obj.index]]; }] : nil;
		} completionHandler:nil duration:animated eased:CAMEDIAEASY]; // [NSAnimationContext endGrouping];

//     }]; } completionHandler:nil duration:animated eased:CAMEDIAEASEOUT] : nil; //		NSAnimationContext.currentContext.duration = animated ? 1 : 0;	NSAnimationContext.currentContext.timingFunction = CAMEDIAEASEOUT;
}

- (NSRange)currentRange {

	NSR clippedRect	= self.clippedRect;
	NSUI   columns	= self.columnsInGridView, rows = self.visibleRowsInGridView,
       rangeStart = clippedRect.origin.y > _itemSize.height	? (ceilf(clippedRect.origin.y / _itemSize.height) * columns) - columns : 0,
      rangeLength = MIN(self.numberOfItems, (columns * rows) + columns);
	return (NSRNG){rangeStart, rangeStart + rangeLength > self.numberOfItems ? self.numberOfItems - rangeStart : rangeLength};// rangeForVisibleRect;
}
- (NSRect)rectForItemAtIndex:(NSUI)index  {	NSUI columns = self.columnsInGridView;
 	return (NSR){          (index % columns)             * _itemSize.width,
               ((index - (index % columns)) / columns) * _itemSize.height, _itemSize};
}
- (NSUI) columnsInGridView      {	return MAX(floorf(NSWidth(self.clippedRect) / self.itemSize.width),1);  }
- (NSUI) allOverRowsInGridView	{	return ceilf(        self.numberOfItems / self.columnsInGridView);      }
- (NSUI) visibleRowsInGridView	{	return ceilf(NSHeight(self.clippedRect) / _itemSize.height);        }
-  (NSR) clippedRect            { return [self.enclosingScrollView.contentView bounds];                   }

- (NSUI)  indexForItemAtLocation:(NSP)loc { NSP point = [self convertPoint:loc fromView:nil];

  if (point.x > _itemSize.width * self.columnsInGridView) return NSNotFound;
  NSUI currentColumn      = floor( point.x / _itemSize.width  );
  NSUI currentRow         = floor( point.y / _itemSize.height );
  NSUI indexForItemAtLoc  = currentRow	* self.columnsInGridView + currentColumn;
  return indexForItemAtLoc > self.numberOfItems ? NSNotFound : indexForItemAtLoc;
}

- (CNItemPoint)locationForItemAtIndex:(NSUI)itemIndex {

	NSUI row	 	=             floor(itemIndex / self.columnsInGridView) + 1;
	NSUI column = itemIndex - floor( (row -1) * self.columnsInGridView) + 1;
	return CNMakeItemPoint(column, row);
}

#pragma mark - NSView Methods
- (BOOL) isFlipped           { return YES; }
- (void) setFrame:(NSR)r     { AZLOGCMD;

	CGSize size = self.frame.size;
	CGFloat newHeight = [self allOverRowsInGridView] * self.itemSize.height + _contentInset * 2;
	if (ABS(newHeight - size.height) > 1) {
		size.height = newHeight;
    XX(self.size);
    XX(size);
    XX(self.enclosingScrollView.size);
		[super setFrameSize:size];
	}

//[super setFrame:r];

	[self refreshGridViewAnimated:YES];// self.width != (super.frame = r).size.width ];
//	self.enclosingScrollView.needsDisplay = YES;
}
- (void) updateTrackingAreas {	if (_gridViewTrackingArea) [self removeTrackingArea:_gridViewTrackingArea];

	[self addTrackingArea:self.gridViewTrackingArea =
    [NSTA.alloc initWithRect:self.frame options:NSTrackingMouseMoved | NSTrackingActiveInKeyWindow owner:self userInfo:nil]];
}

#pragma mark - Creating GridView Items
-   (id) dequeueReusableItemWithIdentifier:(NSS*)uid {

	NSMSet * reuseQueue = _reuseableItems[uid];
	if (!reuseQueue || !reuseQueue.count) return nil;
	AZGVItem *reusableItem = reuseQueue.anyObject;
	[reuseQueue removeObject:reusableItem];
	_reuseableItems[uid] = reuseQueue;
	return reusableItem;
}

#pragma mark - Reloading GridView Data
- (void) reloadData {

  _numberOfItems = [self gridView:self numberOfItemsInSection:0];
  if (_keyedVisibleItems.allValues.count)
    [_keyedVisibleItems.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_keyedVisibleItems removeAllObjects];
	[_reuseableItems removeAllObjects];
	[self refreshGridViewAnimated:YES];
}

#pragma mark - Selection Handling

- (void) scrollToGridViewItem:(AZGVItem*)gridViewItem animated:(BOOL)ani          {}
- (void) scrollToGridViewItemAtIndexPath:(NSIP*)idxPath animated:(BOOL)ani        {}
- (void) selectItemAtIndex:(NSUI)selectedItemIdx usingModifierFlags:(NSUI)mFlags  {

	AZGVItem *gridViewItem = nil;

	if (self.lastSelectedIndex != NSNotFound && self.lastSelectedIndex != selectedItemIdx) {
		/// inform the delegate
		[self gridView:self willDeselectItemAtIndex:self.lastSelectedIndex inSection:0];
		gridViewItem 			= self.keyedVisibleItems[@(self.lastSelectedIndex)];
		gridViewItem.isSelected = NO;
		[self.selectedItems removeObjectForKey:@(gridViewItem.index)];
		/// inform the delegate
		[self gridView:self didDeselectItemAtIndex:self.lastSelectedIndex inSection:0];
	}
	IF_VOID(!(gridViewItem = self.keyedVisibleItems[@(selectedItemIdx)]));
  // inform the delegate
  [self gridView:self willSelectItemAtIndex:selectedItemIdx inSection:0];
  gridViewItem.isSelected = self.allowsMultipleSelection ? !gridViewItem.isSelected ?: mFlags & NSCommandKeyMask ? NO
                                                         :  gridViewItem.isSelected :  mFlags & NSCommandKeyMask ? !gridViewItem.isSelected
                                                         : YES;
  self.lastSelectedIndex = self.allowsMultipleSelection ? NSNotFound : selectedItemIdx;
  self.selectedItems[@(selectedItemIdx)] = gridViewItem;
  /// inform the delegate
  [self gridView:self didSelectItemAtIndex:selectedItemIdx inSection:0];
}
- (void) handleClicks:(TMR*)t                                     { 	NSUI clickCount = self.clickEvents.count;

      clickCount == CNSingleClick ?  [self handleSingleClickForItemAtIndex:[self indexForItemAtLocation:[self.clickEvents.lastObject locationInWindow]]]
    : clickCount == CNDoubleClick ? ^{
      NSUI indexClick1 = [self indexForItemAtLocation:[self.clickEvents[0] locationInWindow]];
      NSUI indexClick2 = [self indexForItemAtLocation:[self.clickEvents[1] locationInWindow]];
      indexClick1 == indexClick2 ?  [self handleDoubleClickForItemAtIndex:indexClick1]
                                 :  [self handleSingleClickForItemAtIndex:indexClick1],
                                    [self handleSingleClickForItemAtIndex:indexClick2];
}() : clickCount == CNTrippleClick ? ^{
      NSUI indexClick1 = [self indexForItemAtLocation:[self.clickEvents[0] locationInWindow]];
      NSUI indexClick2 = [self indexForItemAtLocation:[self.clickEvents[1] locationInWindow]];
      NSUI indexClick3 = [self indexForItemAtLocation:[self.clickEvents[2] locationInWindow]];
      indexClick1 == indexClick2 == indexClick3                 ?	[self handleDoubleClickForItemAtIndex:indexClick1]
    : indexClick1 == indexClick2 && indexClick1 != indexClick3  ? [self handleDoubleClickForItemAtIndex:indexClick1], [self handleSingleClickForItemAtIndex:indexClick3]
    : indexClick1 != indexClick2 && indexClick2 == indexClick3  ? [self handleSingleClickForItemAtIndex:indexClick1], [self handleDoubleClickForItemAtIndex:indexClick3]
    : indexClick1 != indexClick2 != indexClick3                 ? [self handleSingleClickForItemAtIndex:indexClick1], [self handleSingleClickForItemAtIndex:indexClick2], [self handleSingleClickForItemAtIndex:indexClick3]
                                                                : nil;
}(): nil; [self.clickEvents removeAllObjects];
}
- (void) handleSingleClickForItemAtIndex:(NSUI)selectedItemIndex  {
	/// inform the delegate
	[self gridView:self didClickItemAtIndex:selectedItemIndex inSection:0];
	NSLog(@"handleSingleClick for item at index: %lu", selectedItemIndex);
}
- (void) handleDoubleClickForItemAtIndex:(NSUI)selectedItemIndex  {
	/// inform the delegate
	[self gridView:self didDoubleClickItemAtIndex:selectedItemIndex inSection:0];
	NSLog(@"handleDoubleClick for item at index: %lu", selectedItemIndex);
}
- (void) drawSelectionFrameForMousePointerAtLocation:(NSP)loc     {

	if (!_selectionFrameView || ![self containsSubView:_selectionFrameView])
    return [self addSubview:_selectionFrameView = [CNSelectionFrameView viewWithFrame:(NSR){(_selectionFrameInitialPoint = loc).x, loc.y, 0, 0}]];

  NSR        clippedRect = self.clippedRect;
	NSUI columnsInGridView = self.columnsInGridView;

  CGF   posX = ceil(loc.x > self.selectionFrameInitialPoint.x ? self.selectionFrameInitialPoint.x : loc.x);
        posX = posX < NSMinX(clippedRect) ? NSMinX(clippedRect) : posX;

  CGF   posY = ceil(loc.y > self.selectionFrameInitialPoint.y ? self.selectionFrameInitialPoint.y : loc.y);
        posY = posY < NSMinY(clippedRect) ? NSMinY(clippedRect) : posY;

  CGF  width = loc.x > self.selectionFrameInitialPoint.x ? loc.x - self.selectionFrameInitialPoint.x : self.selectionFrameInitialPoint.x - posX;
       width = posX + width >= (columnsInGridView * self.itemSize.width) ? (columnsInGridView * self.itemSize.width) - posX - 1 : width;

  CGF height = loc.y > self.selectionFrameInitialPoint.y ? loc.y - self.selectionFrameInitialPoint.y : self.selectionFrameInitialPoint.y - posY;
      height = posY + height > NSMaxY(clippedRect) ? NSMaxY(clippedRect) - posY : height;

  self.selectionFrameView.frame = (NSR){posX, posY, width, height};
}
- (void) selectItemsCoveredBySelectionFrame:(NSR)selectionFrame usingModifierFlags:(NSUI)modifierFlags {

	NSUI topLeftItemIndex = [self indexForItemAtLocation:[self convertPoint:selectionFrame.origin toView:nil]],
   bottomRightItemIndex = [self indexForItemAtLocation:[self convertPoint:AZRectApex(selectionFrame) toView:nil]]; // NSMakePoint(NSMaxX(selectionFrame), NSMaxY(selectionFrame)) toView:nil]];
	CNItemPoint topLeftItemPoint = [self locationForItemAtIndex:topLeftItemIndex],
          bottomRightItemPoint = [self locationForItemAtIndex:bottomRightItemIndex];
	/// handle all "by selection frame" selected items beeing now outside
	/// the selection frame
	[self.indexesForVisibleItems enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		AZGVItem *selectedItem = _selectedItems[@(idx)],
       *selectionFrameItem = _selectedItemsBySelectionFrame[@(idx)];

		IF_VOID(!selectionFrameItem);

    CNItemPoint itemPoint = [self locationForItemAtIndex:selectionFrameItem.index];

    /// handle all 'out of selection frame range' items
    IF_VOID(
      itemPoint.row     > topLeftItemPoint.row        ||  // top edge out of range
      itemPoint.column  < bottomRightItemPoint.column ||  // right edge out of range
      itemPoint.row     < bottomRightItemPoint.row    ||  // bottom edge out of range
      itemPoint.column  > topLeftItemPoint.column);       // left edge out of range

    // ok. before we deselect this item, lets take a look into our `keyedVisibleItems`
    // if it there is selected too. If it so, keep it untouched!

    (selectionFrameItem.isSelected = [selectionFrameItem isEqual:selectedItem]) ?
      // the current item already was selected, so reselect it.
      [_selectedItemsBySelectionFrame setObject:selectionFrameItem forKey:@(selectionFrameItem.index)] :
      // so, the current item wasn't selected, we can restore its old state (to unselected)
      [_selectedItemsBySelectionFrame removeObjectForKey:@(selectionFrameItem.index)];
	}];

	/// update all items that needs to be selected
	NSUI columnsInGridView = [self columnsInGridView];
	for (NSUI row = topLeftItemPoint.row; row <= bottomRightItemPoint.row; row++) {
		for (NSUI col = topLeftItemPoint.column; col <= bottomRightItemPoint.column; col++) {
			NSUI itemIndex = ((row -1) * columnsInGridView + col) -1;
			AZGVItem *selectedItem = _selectedItems[@(itemIndex)];
			AZGVItem *itemToSelect = _keyedVisibleItems[@(itemIndex)];
			_selectedItemsBySelectionFrame[@(itemToSelect.index)] = itemToSelect;
			itemToSelect.isSelected = modifierFlags & NSCommandKeyMask ? ![itemToSelect isEqual:selectedItem] : YES;
		}
	}
	
/**	/// handle all "by selection frame" selected items beeing now outside the selection frame
	[self.indexesForVisibleItems enumerateIndexesUsingBlock:^(NSUI idx, BOOL *stop) {
		AZGVItem *item = self.selectedItemsBySelectionFrame[[NSNumber numberWithInt:idx]];
		if (item) {
			CNItemPoint itemPoint = [self locationForItemAtIndex:item.index];
			if ( itemPoint.row	< topLeftItemPoint.row		||  /// top edge out of range
				 itemPoint.column > bottomRightItemPoint.column	||  /// right edge out of range
				 itemPoint.row 	  > bottomRightItemPoint.row	||  /// bottom edge out of range
				 itemPoint.column < topLeftItemPoint.column )		/// left edge out of range
			{
				/// ok. before we deselect this item, lets take a look into our `keyedVisibleItems`
				/// if it there is selected too. If it so, keep it untouched!

				/// so, the current item wasn't selected, we can restore its old state (to unselected)
				if (![selectionFrameItem isEqual:selectedItem]) {
					selectionFrameItem.selected = NO;
					[selectedItemsBySelectionFrame removeObjectForKey:[NSNumber numberWithInteger:selectionFrameItem.index]];
				}

				/// the current item already was selected, so reselect it.
				else {
					selectionFrameItem.selected = YES;
					[selectedItemsBySelectionFrame setObject:selectionFrameItem fK:[NSNumber numberWithInteger:selectionFrameItem.index]];
				}

//				/// ok. before we deselect this item, lets take a look into our `keyedVisibleItems`
//				/// if it there is selected too. If it so, keep it untouched!
//				item.isSelected = NO;
//				[self.selectedItemsBySelectionFrame removeObjectForKey:@(item.index)];
			}
		}
	}];
	*/
	/// update all items that needs to be selected
//	NSUI columnsInGridView = self.columnsInGridView;
//	for (NSUI row = topLeftItemPoint.row; row <= bottomRightItemPoint.row; row++) {
//		for (NSUI col = topLeftItemPoint.column; col <= bottomRightItemPoint.column; col++) {
//			NSUI itemIndex = ((row -1) * columnsInGridView + col) -1;
//			AZGVItem *item = self.keyedVisibleItems[@(itemIndex)];
//			if (modifierFlags & NSCommandKeyMask)
//				item.isSelected = (item.isSelected ? NO : YES) ?: YES;
//			(self.selectedItemsBySelectionFrame)[@(item.index)] = item;
//		}
//	}
}

#pragma mark - Managing the Content
- (NSUI) numberOfVisibleItems  {	return _keyedVisibleItems.count;	}
//- (void) removeItem:(AZGVItem*) theItem{}
//- (void) removeItemAtIndex:(NSUI)index{}
//- (void) removeAllItems{}
//- (void) removeAllSelectedItems{}

#pragma mark - NSResponder Methods
- (void)    mouseExited:(NSE*)e { self.lastHoveredIndex = NSNotFound; }
- (void)     mouseMoved:(NSE*)e {	IF_VOID(!_useHover);

	NSUI hoverItemIndex = [self indexForItemAtLocation:e.locationInWindow];

	IF_VOID(hoverItemIndex == NSNotFound || hoverItemIndex == _lastHoveredIndex);

  if (_lastHoveredIndex != NSNotFound) {   /// unhover the last hovered item  + inform the delegate
    [self gridView:self willUnhovertemAtIndex:_lastHoveredIndex inSection:0];
    [self.keyedVisibleItems[@(self.lastHoveredIndex)] setHovered:NO];
  }									 		 /// inform the delegate
  [self gridView:self willHovertemAtIndex:hoverItemIndex inSection:0];
  [self.keyedVisibleItems[@(_lastHoveredIndex	= hoverItemIndex)] setHovered:YES];
}
- (void)   mouseDragged:(NSE*)e {

	if (!_allowsMultipleSelection || _abortSelection) return;

	[NSCursor pointingHandCursor];
  [self drawSelectionFrameForMousePointerAtLocation: [self convertPoint:e.locationInWindow fromView:nil]];
  [self selectItemsCoveredBySelectionFrame:self.selectionFrameView.frame usingModifierFlags:e.modifierFlags];
}
- (void)        mouseUp:(NSE*)e {
	[NSCursor arrowCursor];	/// remove selection frame
	[_selectionFrameView.animator setAlphaValue:0];
	 _selectionFrameView 	= nil;
	 _abortSelection      = NO;
	[_selectedItems	addEntriesFromDictionary:_selectedItemsBySelectionFrame];
	[_selectedItemsBySelectionFrame removeAllObjects];
	[_clickEvents 			addObject:e];
  _clickTimer = [NST scheduledTimerWithTimeInterval:NSE.doubleClickInterval target:self selector:@selector(handleClicks:) userInfo:nil repeats:NO];
}
- (void)      mouseDown:(NSE*)e { _allowsSelection ? [self selectItemAtIndex:[self indexForItemAtLocation:e.locationInWindow] usingModifierFlags:e.modifierFlags] : nil; }
- (void) rightMouseDown:(NSE*)e {	[self gridView:self rightMouseButtonClickedOnItemAtIndex:[self indexForItemAtLocation:e.locationInWindow] inSection:0]; }
- (void)        keyDown:(NSE*)e {	AZLOG(@"keyDown"); [e keyCode] == 53 /*escape*/ ?  ^{ self.abortSelection = YES; }() : nil; }


#pragma mark - AZGView Delegate Calls
- (void) gridView:(AZGV*)v                  willHovertemAtIndex:(NSUI)i inSection:(NSUI)s { ![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v willHovertemAtIndex:i inSection:s];                   }
- (void) gridView:(AZGV*)v                willUnhovertemAtIndex:(NSUI)i inSection:(NSUI)s { ![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v willUnhovertemAtIndex:i inSection:s];                 }
- (void) gridView:(AZGV*)v                willSelectItemAtIndex:(NSUI)i inSection:(NSUI)s { ![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v willSelectItemAtIndex:i inSection:s];                 }
- (void) gridView:(AZGV*)v                 didSelectItemAtIndex:(NSUI)i inSection:(NSUI)s {	![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v didSelectItemAtIndex:i inSection:s];                  }
- (void) gridView:(AZGV*)v              willDeselectItemAtIndex:(NSUI)i inSection:(NSUI)s { ![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v willDeselectItemAtIndex:i inSection:s];               }
- (void) gridView:(AZGV*)v               didDeselectItemAtIndex:(NSUI)i inSection:(NSUI)s { ![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v didDeselectItemAtIndex:i inSection:s];                }
- (void) gridView:(AZGV*)v                  didClickItemAtIndex:(NSUI)i inSection:(NSUI)s { ![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v didClickItemAtIndex:i inSection:s];                   }
- (void) gridView:(AZGV*)v            didDoubleClickItemAtIndex:(NSUI)i inSection:(NSUI)s { ![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v didDoubleClickItemAtIndex:i inSection:s];             }
- (void) gridView:(AZGV*)v rightMouseButtonClickedOnItemAtIndex:(NSUI)i inSection:(NSUI)s { ![_delegate respondsToSelector:_cmd] ?: [_delegate gridView:v rightMouseButtonClickedOnItemAtIndex:i inSection:s];  }

#pragma mark - AZGView DataSource Calls
-      (NSUI) gridView:(AZGV*)v         numberOfItemsInSection:(NSI)s { return [_dataSource respondsToSelector:_cmd] ? [_dataSource gridView:v numberOfItemsInSection:s]    : NSNotFound; }
- (AZGVItem*) gridView:(AZGV*)v itemAtIndex:(NSI)idx inSection:(NSI)s { return [_dataSource respondsToSelector:_cmd] ? [_dataSource gridView:v itemAtIndex:idx inSection:s] : nil; }
-      (NSS*) gridView:(AZGV*)v        titleForHeaderInSection:(NSI)s {	return [_dataSource respondsToSelector:_cmd] ? [_dataSource gridView:v titleForHeaderInSection:s]   : nil; }
-      (NSUI)    numberOfSectionsInGridView:(AZGV*)v                  { return [_dataSource respondsToSelector:_cmd] ? [_dataSource numberOfSectionsInGridView:v]           : NSNotFound; }
-      (NSA*) sectionIndexTitlesForGridView:(AZGV*)v                  {	return [_dataSource respondsToSelector:_cmd] ? [_dataSource sectionIndexTitlesForGridView:v]        : nil; }

#pragma mark - AZGView Item Default Colors

@end

static CGF mPhase = 0;

#pragma mark - CNSelectionFrameView
@implementation CNSelectionFrameView { NSTimer *timer; }

- (void) drawRect:(NSRect)rect {
	
	NSR dirtyRect = NSMakeRect(.5, .5, floorf(self.width)-1, floorf(self.height)-1);

	NSBP *selectionFramePath = [NSBP withR:dirtyRect];
	[selectionFramePath   fillWithColor:[GRAY4 alpha:0.42]];
	[selectionFramePath strokeWithColor:WHITE andWidth:4 inside:dirtyRect];
//	DKStrokeDash *d = DKStrokeDash.defaultDash;//;equallySpacedDashToFitSize:dirtyRect.size dashLength:40];
////	[d setScalesToLineWidth:YES];//setPhase:phase];
//	[d setPhase:mPhase];
//	[d applyToPath:selectionFramePath];
  const CGFloat dashArray[2] = {10,10};
  [selectionFramePath setLineDash:dashArray count:sizeof(dashArray) / sizeof(dashArray[0]) phase:mPhase]; // [selectionPath stroke]; } }
  [selectionFramePath strokeWithColor:BLACK andWidth:4 inside:dirtyRect];
	mPhase += 5;
//	timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(aniHandler:) userInfo:nil repeats:YES];
	timer =	[NSTimer timerWithTimeInterval:.5 block:^(TMR *tmr) { [self display];/*:YES];*/ AZLOG($(@"NSTIMER %@!", tmr));	} repeats:NO];
}
- (BOOL)isFlipped {	return YES; }
- (void)aniHandler:(TMR*)t {

	CGF halfwayWithInset = AZPerimeterWithRoundRadius( self.frame,/*radiuus*/ 0 );
	mPhase = mPhase < halfwayWithInset ? mPhase + halfwayWithInset / 128 : 0;
	[self setNeedsDisplayInRect:NSInsetRect(self.bounds, 8, 8)];
}
@end


//@property (strong, nonatomic) CAShapeLayer *selectionLayer;
//@property (strong) AZGVItemLayout *currentLayout;
@interface AZGVItem ()
@property NSIV *itemImageView;
@end

@implementation AZGVItem
#define	kCNDefaultItemIdentifier @"AZGVItem"

#pragma mark - Initialzation
//+ (void)initialize { 	kDefaultItemSize		 = NSMakeSize(96, 96); }
//+ (CGSize)defaultItemSize {	return kDefaultItemSize; }

- (id)init
{
	if (!(self = [super init])) return nil;
	[self initProperties];
	return self;
}
- (id)initWithCoder:(NSCoder*) aDecoder
{
	if (!(self = [super initWithCoder:aDecoder])) return nil;
	[self initProperties];
	return self;
}
- (id)initInGrid:(AZGView *)grid reuseIdentifier:(NSString *)reuseIdentifier
{
	if (!(self = [super init])) return nil;
	_grid = grid;
	[self initProperties];
	//	_standardLayout = layout;
	//	_reuseIdentifier = reuseIdentifier;
	return self;
}
- (void) initProperties {
	//	self.wantsLayer		= YES;
	/// Reusing Grid View Items
	_reuseIdentifier 	= kCNDefaultItemIdentifier;
	/// Item Default Content
	_itemImage	 		= nil;
	_itemTitle 			= @"";
	_index 				= CNItemIndexNoIndex;
	/// Grid View Item Layout
	//	_standardLayout 	= [AZGVItemLayout defaultLayout];
	//	_hoverLayout 		= [AZGVItemLayout defaultLayout];
	//	_selectionLayout 	= [AZGVItemLayout defaultLayout];
	//	_currentLayout 		= _standardLayout;
	_useLayout 			= YES;
	/// Selection and Hovering
	_isSelected	 		= NO;
	_isSelectable 		= YES;
	_isHovered 			= NO;
}
- (BOOL)isFlipped {	return YES; }

#pragma mark - Reusing Grid View Items
- (void) prepareForReuse
{
	self.itemImage 		= nil;
	self.itemTitle 		= @"";
	self.index 			= CNItemIndexNoIndex;
	self.isSelected 	= NO;
	self.isSelectable 	= YES;
	self.isHovered 		= NO;
}


#pragma mark - ViewDrawing
- (void) drawRect:(NSRect)rect
{
	NSR dirtyRect = self.bounds;
	// decide which layout we have to use
	/// contentRect is the rect respecting the value of layout.contentInset
	NSR contentRect = NSMakeRect(dirtyRect.origin.x + self.grid.contentInset, //self.currentLayout.contentInset,
									dirtyRect.origin.y + self.grid.contentInset, //self.currentLayout.contentInset,
									dirtyRect.size.width - self.grid.contentInset * 2, //self.currentLayout.contentInset * 2,
									dirtyRect.size.height - self.grid.contentInset * 2); //self.currentLayout.contentInset * 2);
	NSBP *contentRectPath = [NSBP bezierPathWithRoundedRect:contentRect
																	xRadius:self.grid.itemBorderRadius //self.currentLayout.itemBorderRadius
																	yRadius:self.grid.itemBorderRadius];//self.currentLayout.itemBorderRadius];
	[self.itemColor ?: self.grid.itemBackgroundColor setFill];//currentLayout.itemBackgroundColor setFill];
	[contentRectPath fill];
	if (self.isSelected) [self.grid.itemBackgroundSelectionColor setFill];
	[contentRectPath fill];
	if (self.isHovered) [self.grid.itemBackgroundHoverColor setFill];
	[contentRectPath fill];

	/// draw selection ring
	if (self.isSelected) {
		[self.grid.itemSelectionRingColor setStroke];//currentLayout.itemSelectionRingColor setStroke];
		[contentRectPath setLineWidth:self.grid.selectionRingLineWidth];//currentLayout.selectionRingLineWidth];
		[contentRectPath stroke];
	}

	//	NSR srcRect = NSZeroRect;
	//	srcRect.size = self.itemImage.size;
	NSR imageRect = NSInsetRect([self bounds], self.grid.contentInset*2, self.grid.contentInset*2);//NSZeroRect;
	NSR textRect = NSZeroRect;
	if (self.grid.visibleContentMask & (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle)) {
		//currentLayout.visibleContentMask & (AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle)) {
		//		imageRect = NSMakeRect(((NSWidth(contentRect) - self.itemImage.size.width) / 2) + self.currentLayout.contentInset,
		//							   self.currentLayout.contentInset + 10,
		//							   self.itemImage.size.width,
		//							   self.itemImage.size.height);
		[self.itemImage drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
		if (self.isHovered) {
			textRect = NSMakeRect(contentRect.origin.x + 3,
								  NSHeight(contentRect) - 6,
								  NSWidth(contentRect) - 6,
								  14);
			[self.itemTitle drawInRect:textRect withAttributes:self.grid.itemTitleTextAttributes];
		}
	}
	else if (self.grid.visibleContentMask & AtoZGridViewItemVisibleContentImage) {
		//		imageRect = NSMakeRect(((NSWidth(contentRect) - self.itemImage.size.width) / 2) + self.currentLayout.contentInset,
		//							   ((NSHeight(contentRect) - self.itemImage.size.height) / 2) + self.currentLayout.contentInset,
		//							   self.itemImage.size.width,
		//							   self.itemImage.size.height);
	}
	else if (self.grid.visibleContentMask & AtoZGridViewItemVisibleContentTitle) {
	}
}


#pragma mark - Notifications
//- (void) clearHovering
//{
//	self.isHovered = NO;
//}
//- (void) clearSelection
//{
//	self.isSelected = NO;
//}


//- (CAShapeLayer*)selectionLayer {
//	CAShapeLayer *layer = _selectionLayer ?: [CAShapeLayer layer];
//	NSBP *path = [NSBP bezierPathWithRoundedRect:self.bounds xRadius:self.grid.itemBorderRadius yRadius:self.grid.itemBorderRadius];
////	layer.path =
//	return layer;
//}

#pragma mark - Accessors
- (void) setIsHovered:(BOOL)isHovered
{
	_isHovered = isHovered;
	//	_currentLayout = (isHovered ? _hoverLayout : (_isSelected ? _selectionLayout : _standardLayout));
	[self setNeedsDisplay:YES];
}
- (void) setIsSelected:(BOOL)isSelected
{
	_isSelected = isSelected;
	//	_currentLayout = isSelected ? _selectionLayout : _standardLayout;
	[self setNeedsDisplay:YES];
}
- (BOOL)isReuseable{
	return _isSelected ? NO : YES;
}

@end

CLANG_IGNORE_PROTOCOL
@class AZSizer;
@implementation  AtoZGridViewAuto

//-(void) scrollWheel:(NSE*)e
//{
//  AZLOGCMD;
//  [super scrollWheel:e];
//	self.grid.itemSize = AZAddSizes(_grid.itemSize, AZSizeFromDim(e.deltaX));
//	[self.nextResponder scrollWheel:e];
//}
- (void) viewDidMoveToSuperview
{
	__unused NSR superF = self.superview.bounds;
  NSLog(@"Autogrid did move to superV. self:%@ items:%@", AZString(self.frame), self.subviews);//self.items);

  self.scrollView.documentView  = self.grid;
  self.subviews = @[_scrollView];
//  [self.subviews each:^(id sender) { [sender setFrame:self.bounds]; }];

//  for (__unsafe_unretained id obj in @[self, self.scrollView, self.grid]) {
//    XX(obj);
//    if (!NSEqualSizes([obj sizeForKey:@"size"], superF.size) && [obj respondsToSelector:@selector(setFrame:)])
//      [obj setFrame:superF];
//  }

	!self.storage.count ?: [_grid reloadData];
//	if (_items.count != 0) [_grid reloadData];
}

- (NSSCRLV*) scrollView { IF_RETURNIT(_scrollView);

  _scrollView = [NSSCRLV viewWithFrame:self.bounds mask:NSSIZEABLE];
  _scrollView.bgC					= [NSC leatherTintedWithColor:RANDOMCOLOR];
	_scrollView.borderType 			= NSNoBorder;
  return _scrollView;
}

//- (void) setItems:(NSMA*)items
//{
//	_items = [items map:^id(NSO* obj) {
//
//		return 	@{ 	kContentImageKey: obj.imageValue ?: [NSIMG imageNamed:@"missing"] ELSENULL,
//					kContentTitleKey: [obj respondsToString:@"name"] ? [obj valueForKey:@"name"] : @"N/A",
//					kContentColorKey: obj.colorValue ELSENULL } ?: nil;
//	}].mutableCopy;
//}

- (AZGV*)grid { IF_RETURNIT(_grid);

  _grid = [AZGView viewWithFrame:self.bounds mask:NSSIZEABLE];  // _grid.delegate 			= self;
	_grid.dataSource              = self;
	_grid.scrollElasticity        = NO;
	_grid.allowsMultipleSelection = YES;
	_grid.itemSize                = AZSizeFromDim(65);
	return _grid;
}
+ (INST) gridWithFrame:(NSR)f withObjects:(NSA*)a {

	AZGVA *new = [AZGVA viewWithFrame:f mask:NSSIZEABLE];
//	new.autoresizesSubviews = YES;
  [a do:^(id obj) {
    [new addObject: @{ 	kContentImageKey: [obj imageValue] ?: [NSIMG imageNamed:@"missing"] ELSENULL,
                        kContentTitleKey: [obj vFK:@"name"] ?: @"N/A",
                        kContentColorKey: [obj colorValue] ELSENULL }];
  }];
	return new;
}
//- (BOOL)acceptsFirstResponder {	return YES; }

//- (void) scrollWheel:(NSEvent *)theEvent
//{
//		AZLOG(theEvent);
//		self.grid.itemSize = AZAddSizes(self.grid.itemSize, AZSizeFromDim(theEvent.deltaX));
//		[[self nextResponder] scrollWheel:theEvent];
//}

//	[NSEVENTLOCALMASK: NSLeftMouseUpMask | NSScrollWheelMask | NSEventMaskGesture | NSEventMaskMagnify handler:^NSEvent *(NSEvent *e) {
//
//		if ([e type] == NSEventTypeMagnify ) {
//
//			NSSize size = _grid.itemSize;
//			size = AZMultiplySize(size, e.magnification);
//
//			self.grid.itemSize = size;
//		}
//		if ( e.type == NSLeftMouseUp && [e clickCount] == 3 ) {
//			//			grid.itemSize = [AZSizer forQuantity:_array.count inRect:self.bounds].size;
//			//			NSSize s = _grid.itemSize;
//			//			s.width += 10;
//			//			s.height += 10;
//			//			_grid.itemSize = s;
//			//			[grid reloadData];
//			//		AZSizer *sizer = [AZSizer forQuantity: _array.count aroundRect:_grid.enclosingScrollView.contentView.frame];
//			//		AZLOG(sizer.propertiesPlease);
//			//		_grid.itemSize = sizer.size;
//		}
//		}
//		return e;
//	}];

//-(void) setItemSize:(NSSize)itemSize
//{
//	_itemSize = itemSize;
//	self.grid.itemSize = _itemSize;
//	[self.grid reloadData];
//}

- (NSUI)gridView:(AZGV*)v numberOfItemsInSection:(NSInteger)section
{
	NSLog(@"gris view items reported as %ld", self.storage.count);
	return self.storage.count;
}
- (AZGVItem*) gridView:(AZGV*)v itemAtIndex:(NSI)index inSection:(NSI)section
{
	if (self.storage.count == 0) return nil;
	AZGVItem *item  =	[v dequeueReusableItemWithIdentifier:reuseIdentifier] ?: [AZGVItem.alloc initInGrid:_grid reuseIdentifier:reuseIdentifier];
//	if (item) { NSLog(@"did dequeue index: %lu item: %@", index, item);


//		NSLog(@"did create item for index: %lu", index);
//	}
//	NSDictionary *contentDict = self.storage[index];
//	item.itemTitle = self.storage[index][kContentTitleKey] ELSENULL;
//	item.itemImage = contentDict [kContentImageKey] ELSENULL;
//	item.itemColor = contentDict [kContentColorKey] ELSENULL;
//	NSLog(@"Returning cell for index: %ld, cell:%@", index, item.propertiesPlease);
	return item;
}


#pragma mark - AZGView Delegate
- (void) gridView:(AZGV*)v rightMouseButtonClickedOnItemAtIndex:(NSUI)index inSection:(NSUI)s
{
	NSLog(@"rightMouseButtonClickedOnItemAtIndex: %li", index);
}
@end
CLANG_POP

/*

#import <DrawKit/DrawKit.h>
#import <DrawKit/DKStrokeDash.h>
static CGFloat kDefaultContentInset;
static CGFloat kDefaultSelectionRingLineWidth;
static CGFloat kDefaultItemBorderRadius;

- (void)  setupDefaults;
- (void)  updateVisibleRect;
- (void)  updateReuseableItems;
- (void)  updateVisibleItems;
- (NSIS*) indexesForVisibleItems;
- (void)  refreshGridViewAnimated:		(BOOL)animated;
- (void)  arrangeGridViewItemsAnimated:	(BOOL)animated;
- (NSR)   rectForItemAtIndex:		(NSUI)index;
- (NSUI)  indexForItemAtLocation:	(NSP)location;
- (NSRNG) currentRange;
- (NSUI)  columnsInGridView;
- (NSUI)  allOverRowsInGridView;
- (NSUI)  visibleRowsInGridView;
- (NSR)   clippedRect;

- (CNItemPoint) locationForItemAtIndex:(NSUI)itemIndex;
- (void) selectItemAtIndex:(NSUI)selectedItemIndex usingModifierFlags:(NSUI)modifierFlags;
- (void) handleClicks:(NSTimer*) theTimer;
- (void) handleSingleClickForItemAtIndex:(NSUI)selectedItemIndex;
- (void) handleDoubleClickForItemAtIndex:(NSUI)selectedItemIndex;
- (void) drawSelectionFrameForMousePointerAtLocation:(NSPoint)location;
- (void) selectItemsCoveredBySelectionFrame:(NSRect)selectionFrame usingModifierFlags:(NSUI)modifierFlags;


+ (id)defaultAnimationForKey:(NSString *)key {
	if ([key loMismo:@"frame"]) {
		NSR rect = ;
		CIFilter* transitionFilter = [CIFilter filterWithName:key];  [transitionFilter setDefaults];
		[transitionFilter sV:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] fK:@"inputExtent"] :

		// By default, animate border color changes with simple linear interpolation to the new color value.
		return [CABasicAnimation animation];
	} else {
		// Defer to super's implementation for any keys we don't specifically handle.
		return [super defaultAnimationForKey:key];
	}
}

+ (void)initialize { kDefaultSelectionRingLineWidth = 12.0f; kDefaultContentInset = 7.0f; kDefaultItemBorderRadius = 10.0f; }

	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	// preload shading bitmap to use in transitions:
	// this one is for "SlideshowViewPageCurlTransitionStyle", and "SlideshowViewRippleTransitionStyle"
	NSURL *pathURL = [NSURL fileURLWithPath:[bundle pathForResource:@"restrictedshine" ofType:@"tiff"]];
	inputShadingImage = [CIImage imageWithContentsOfURL:pathURL];
	// this one is for "SlideshowViewDisintegrateWithMaskTransitionStyle"
	pathURL = [NSURL fileURLWithPath:[bundle pathForResource:@"transitionmask" ofType:@"jpg"]];
	inputMaskImage = [CIImage imageWithContentsOfURL:pathURL];

	CATiledLayer *laya = [CATiledLayer layer];
	laya.frame = self.window.frame;
	laya.backgroundColor = [[NSC greenColor]CGColor];
	self.enclosingScrollView.layer = laya;
	self.enclosingScrollView.wantsLayer = YES;

- (NSC*) itemBackgroundColor
{
	return _itemBackgroundColor ?: GRAY2;///[NSC colorWithCalibratedWhite:0.238 alpha:1.000];
}
- (NSC*) itemBackgroundHoverColor
{
	return _itemBackgroundHoverColor ?: GREEN;
}
- (NSC*) itemBackgroundSelectionColor
{
	return _itemBackgroundSelectionColor ?: GRAY5;//[NSC colorWithCalibratedWhite:0.172 alpha:1.000];
}
- (NSC*) itemSelectionRingColor
{
	return _itemSelectionRingColor ?: WHITE;//[NSC colorWithCalibratedWhite:0.740 alpha:1.000];
}
- (NSC*) itemTitleColor
{
	return _itemTitleColor ?: GRAY9;//[NSC colorWithDeviceRed:0.969 green:0.994 blue:0.994 alpha:1.000];
}
- (NSC*) itemTitleShadowColor
{
	return _itemTitleShadowColor ?: BLACK;//[NSC colorWithDeviceWhite:0.011 alpha:0.930];
}
- (NSC*) selectionFrameColor
{
	return _selectionFrameColor ?: [NSC colorWithCalibratedRed:0.908 green:0.784 blue:0.170 alpha:1.000];
}
- (NSC*) backgroundColor
{
	return _backgroundColor ?: GRAY8;//[NSC colorWithCalibratedWhite:0.137 alpha:1.000];
}

+ (AZGVItemLayout*) defaultLayout
{
	AZGVItemLayout *defaultLayout = [[self class] new];
	return defaultLayout;
}

- (NSUI) countOfItems 												 {  return self.items.count;							   }
- (id)   objectInItemsAtIndex: (NSUI)index 							 {  return self.items[index]; 							   }
- (void) insertObject:(id)obj inItemsAtIndex: (NSUI)index 			 {  self.items[index] = obj; 							   }
- (void) removeObjectFromItemsAtIndex: (NSUI)index 					 { [self.items removeObjectAtIndex:index]; 				   }
- (void) replaceObjectInItemsAtIndex: (NSUI)index withObject:(id)obj { [self.items replaceObjectAtIndex:index withObject:obj]; }

- (void) awakeFromNib {
	if (!_items) [self  = NSMA.new;
	[self addObserver:self keyPath:@"items" options:(NSKeyValueChangeInsertion|NSKeyValueChangeReplacement) block:^(MAKVONotification *notification) {
		NSLog(@"autogrid kvo notified of item insertion.  reloading");
		[self.grid reloadData];	}];
}

	_gridViewTitle
	_clickTimer
	_selectionFrameView          = nil;
	_selectionFrameInitialPoint  = CGPointZero;
	_abortSelection              = NO;

*/
