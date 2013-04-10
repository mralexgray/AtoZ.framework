
//  AtoZGridView.h

//  Created by cocoa:naut on 06.10.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.

#import "AtoZ.h"

#pragma mark Managing selection
/** @name Managing selection */

#define AZGV 	 AtoZGridView
#define AZGVI 	 AtoZGridViewItem
#define AZGVDATA AtoZGridViewDataSouce
#define AZGVDEL  AtoZGridViewDelegate

@class 	   AtoZGridView, AtoZGridViewItem;
@protocol 			  AtoZGridViewDelegate  <NSObject>
@optional
- (void) gridView: (AZGV*) gridView  willHovertemAtIndex:		(NSUI)index  inSection: (NSUI)section;
- (void) gridView: (AZGV*) gridView  willUnhovertemAtIndex:		(NSUI)index  inSection: (NSUI)section;
- (void) gridView: (AZGV*) gridView  willSelectItemAtIndex:		(NSUI)index  inSection: (NSUI)section;
- (void) gridView: (AZGV*) gridView  didSelectItemAtIndex:		(NSUI)index  inSection: (NSUI)section;
- (void) gridView: (AZGV*) gridView  willDeselectItemAtIndex:   (NSUI)index  inSection: (NSUI)section;
- (void) gridView: (AZGV*) gridView  didDeselectItemAtIndex:	(NSUI)index  inSection: (NSUI)section;
- (void) gridView: (AZGV*) gridView  didClickItemAtIndex:		(NSUI)index  inSection: (NSUI)section;
- (void) gridView: (AZGV*) gridView  didDoubleClickItemAtIndex: (NSUI)index  inSection: (NSUI)section;

- (void) gridView: (AZGV*) gridView  rightMouseButtonClickedOnItemAtIndex:(NSUI)index inSection:(NSUI)section;
@end

@class AtoZGridView;
@protocol AtoZGridViewDataSource <NSObject>
- (NSUI)   gridView: (AZGV*) gridView			numberOfItemsInSection:(NSI)section;
- (AZGVI*) gridView: (AZGV*) gridView itemAtIndex:(NSI)index  inSection:(NSI)section;
@optional
- (NSUI) numberOfSectionsInGridView:	(AZGV*) gridView;
- (NSS*) gridView: 						(AZGV*) gridView titleForHeaderInSection:(NSI)section;
- (NSA*) sectionIndexTitlesForGridView: (AZGV*) gridView;
@end

@class 	AtoZGridView;
@interface AtoZGridViewAuto : NSView <AtoZGridViewDataSource>//, AtoZGridViewDelegate>

@property (NATOM, STRNG) NSSV 	*scrollView;
@property (NATOM, STRNG) AZGV 	*grid;
@property (NATOM, STRNG) NSMA	*items;

- (id) 	 initWithFrame:(NSR)frame andArray:(NSArray *)array;

- (NSUI) countOfItems;
- (id)   objectInItemsAtIndex: (NSUI)index;
- (void) insertObject:(id)obj inItemsAtIndex: (NSUI)index;
- (void) removeObjectFromItemsAtIndex: 		  (NSUI)index;
- (void) replaceObjectInItemsAtIndex:  		  (NSUI)index withObject:(id)obj;

@end


FOUNDATION_EXPORT NSString *const reuseIdentifier;

typedef NS_ENUM( NSUInteger, AtoZGridViewItemVisibleContent ) {
	AtoZGridViewItemVisibleContentNothing	= 0,
	AtoZGridViewItemVisibleContentImage		= 1 << 0,
	AtoZGridViewItemVisibleContentTitle		= 1 << 1,
};

/**	`AtoZGridView` is an easy to use (wanna be) `NSCollectionView` replacement.
	It has full delegate and dataSource support with method calls like known from NSTableView/UITableView.	*/
@class AtoZGridViewItem;
@interface AtoZGridView : NSView

#pragma mark - Initializing a AtoZGridView Object
/** @name Initializing a AtoZGridView Object */
@property (NATOM, STRNG) NSColor *backgroundColor;

#pragma mark - Managing the Delegate and the Data Source
/** @name Managing the Delegate and the Data Source */
/**	Property for the receiver's delegate. */
@property (NATOM, STRNG) IBOutlet id <AtoZGridViewDelegate> delegate;
/**	Property for the receiver's data source. */
@property (NATOM, STRNG) IBOutlet id <AtoZGridViewDataSource> dataSource;

#pragma mark - Configuring the GridView
/** @name Configuring the GridView */
/**	A title string for the grid view. The default value is `nil`. */
@property (NATOM, STRNG) NSS *gridViewTitle;
/**	Property for setting the elasticity of the enclosing `NSScrollView`.
 This property will be set and overwrite the values from Interface Builder. There is no horizontal-vertical distinction.
 The default value is `YES`.
 @param	 YES Elasticity is on.
 @param	 NO Elasticity is off. */
@property (NATOM, ASS) BOOL scrollElasticity;
/**	Property for setting the grid view item size. */
@property (NATOM, ASS) NSSZ itemSize;
/**	Returns the number of currently visible items of `AtoZGridView`.
 The returned value of this method is subject to continous variation. It depends on the actual size of its view and will be calculated in realtime. */
@property (RONLY) NSUI numberOfVisibleItems;
@property (RONLY) NSN *visibleItems;

#pragma mark - Creating GridView Items
/** @name Creating GridView Items */
- (id) dequeueReusableItemWithIdentifier:(NSString*) identifier;

#pragma mark - Managing Selections and Hovering
/** @name Managing Selections */
/**	Property for setting whether the grid view allows item selection or not.
 	The default value is `YES`. */
@property (NATOM, ASS) BOOL allowsSelection, allowsMultipleSelection, useSelectionRing, useHover;

/**	A bit mask that defines the content a `AtoZGridViewItem` should show.
 There are three possible values:  Default value is `AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle`. */
@property (NATOM, ASS) AtoZGridViewItemVisibleContent visibleContentMask;
@property (NATOM, ASS) CGF  selectionRingLineWidth;
@property (NATOM, ASS) NSUI contentInset;
@property (NATOM, ASS) NSUI itemBorderRadius;
@property (STRNG	 ) NSD  *itemTitleTextAttributes;

#pragma mark - Colors
/** @name GridView Item Colors */
/**	The background color of the `AtoZGridViewItem`. You can set any known `NSColor` values, also pattern images. If this property is not used it will be set to the */
@property (NATOM, STRNG) NSC *itemBackgroundColor;
/** Returns the standard `AtoZGridViewItem` background color when the item is in mouse over state (property must be enabled) */
@property (NATOM, STRNG) NSC *itemBackgroundHoverColor;
/** Returns the standard `AtoZGridViewItem` background color when the item is selected */
@property (NATOM, STRNG) NSC *itemBackgroundSelectionColor;
/**	The color of the selection ring.
 If this property is not used it will be set to the default value `[NSColor itemSelectionRingColor]`. Also see NSColor(AtoZGridViewPalette). */
/** Returns the standard `AtoZGridViewItem` selection ring color when the item is selected */
@property (NATOM, STRNG) NSC *itemSelectionRingColor;
@property (NATOM, STRNG) NSC *itemTitleColor, *itemTitleShadowColor, *selectionFrameColor;

#pragma mark - Managing the Content
/** @name  Managing the Content */
- (void) removeItem:(AZGVI*) theItem;
- (void) removeItemAtIndex:(NSUI)index;
- (void) removeAllItems;
- (void) removeAllSelectedItems;

#pragma mark - Reloading GridView Data
/** @name  Reloading GridView Data */
- (void) reloadData;

#pragma mark - Scrolling to GridView Items
/** @name  Scrolling to GridView Items */
- (void) scrollToGridViewItem: (AZGVI*) gridViewItem	animated:(BOOL)animated;
- (void) scrollToGridViewItemAtIndexPath: (NSIndexPath*) indexPath animated:(BOOL)animated;

@end


__unused static NSS *kCNDefaultItemIdentifier;
__unused static NSI CNItemIndexNoIndex = -1;
__unused static NSS *kAtoZGridViewItemClearHoveringNotification;
__unused static NSS *kAtoZGridViewItemClearSelectionNotification;

@interface AtoZGridViewItem : NSView
#pragma mark - Initialization
/** @name Initialization */
/**	Creates and returns an initialized  This is the designated initializer. */
- (id)initInGrid:(AZGV*)grid reuseIdentifier:(NSString*) reuseIdentifier;

#pragma mark - Reusing Grid View Items
/** @name Reusing Grid View Items */
@property (STRNG	   ) NSS *reuseIdentifier;
@property (RONLY, NATOM) BOOL isReuseable;
- (void) prepareForReuse;

#pragma mark - Item Default Content
/** @name Item Default Content */
@property (NATOM, STRNG)   NSC 		*itemColor;
@property (STRNG) IBOutlet NSIMG 	*itemImage;
@property (STRNG) IBOutlet NSS 		*itemTitle;
@property (ASS) 		   NSI 		index;

#pragma mark - Grid View Item Layout
/** @name Grid View Item Layout */
@property (weak) AtoZGridView *grid;
//AtoZGridViewItemLayout *standardLayout, *hoverLayout, *selectionLayout;
@property (NATOM, ASS) BOOL useLayout;

#pragma mark - Selection and Hovering
/** @name Selection and Hovering */
@property (NATOM, ASS) BOOL isSelected, isSelectable, isHovered;
@end

