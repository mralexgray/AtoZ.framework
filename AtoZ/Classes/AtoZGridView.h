
#import "AtoZUmbrella.h"

@class 	   AtoZGridView, AtoZGridViewItem;
@protocol  AtoZGridViewDelegate  <NSObject>
@optional
- (void) gridView:(AZGV*)v                  willHovertemAtIndex:(NSUI)i inSection:(NSUI)s;
- (void) gridView:(AZGV*)v                willUnhovertemAtIndex:(NSUI)i inSection:(NSUI)s;
- (void) gridView:(AZGV*)v                willSelectItemAtIndex:(NSUI)i inSection:(NSUI)s;
- (void) gridView:(AZGV*)v                 didSelectItemAtIndex:(NSUI)i inSection:(NSUI)s;
- (void) gridView:(AZGV*)v              willDeselectItemAtIndex:(NSUI)i inSection:(NSUI)s;
- (void) gridView:(AZGV*)v               didDeselectItemAtIndex:(NSUI)i inSection:(NSUI)s;
- (void) gridView:(AZGV*)v                  didClickItemAtIndex:(NSUI)i inSection:(NSUI)s;
- (void) gridView:(AZGV*)v            didDoubleClickItemAtIndex:(NSUI)i inSection:(NSUI)s;
- (void) gridView:(AZGV*)v rightMouseButtonClickedOnItemAtIndex:(NSUI)i inSection:(NSUI)s;
@end

@class AtoZGridView;
@protocol AtoZGridViewDataSource <NSObject>
-   (NSUI) gridView:(AZGV*)v       numberOfItemsInSection:(NSI)s;
- (AZGVI*) gridView:(AZGV*)v itemAtIndex:(NSI)i inSection:(NSI)s;
@optional
- (NSUI) numberOfSectionsInGridView:(AZGV*)v;
- (NSS*) gridView:(AZGV*)v titleForHeaderInSection:(NSI)s;
- (NSA*) sectionIndexTitlesForGridView:(AZGV*)v;
@end

@class 	AtoZGridView;
@interface AtoZGridViewAuto : NSView <ArrayLike, AtoZGridViewDataSource>//, AtoZGridViewDelegate>

@property (NATOM) NSSCRLV * scrollView;
@property (NATOM)    AZGV * grid;

+ (INST) gridWithFrame:(NSR)f withObjects:(NSA*)a;
//- (NSUI) countOfItems;
//-   (id) objectInItemsAtIndex: (NSUI)index;
//- (void) insertObject:(id)obj inItemsAtIndex: (NSUI)index;
//- (void) removeObjectFromItemsAtIndex: 		  (NSUI)index;
//- (void) replaceObjectInItemsAtIndex:  		  (NSUI)index withObject:(id)obj;

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
@prop_RO NSUI numberOfVisibleItems;
@prop_RO NSN *visibleItems;

#pragma mark - Creating GridView Items
/** @name Creating GridView Items */
- (id) dequeueReusableItemWithIdentifier:(NSString*) identifier;

#pragma mark - Managing Selections and Hovering
/** @name Managing Selections */
/**	Property for setting whether the grid view allows item selection or not.
 	The default value is `YES`. */
@property (NATOM) BOOL allowsSelection, allowsMultipleSelection, useSelectionRing, useHover;

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
//- (void) removeItem:(AZGVI*) theItem;
//- (void) removeItemAtIndex:(NSUI)index;
//- (void) removeAllItems;
//- (void) removeAllSelectedItems;

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
@property NSS *reuseIdentifier;
@prop_RO BOOL isReuseable;
- (void) prepareForReuse;

#pragma mark - Item Default Content
/** @name Item Default Content */
@property (NATOM)   NSC 		*itemColor;
@property IBOutlet NSIMG 	*itemImage;
@property IBOutlet NSS 		*itemTitle;
@property NSI 		index;

#pragma mark - Grid View Item Layout
/** @name Grid View Item Layout */
@property (WK) AtoZGridView *grid;
//AtoZGridViewItemLayout *standardLayout, *hoverLayout, *selectionLayout;
@property (NATOM, ASS) BOOL useLayout;

#pragma mark - Selection and Hovering
/** @name Selection and Hovering */
@property (NATOM, ASS) BOOL isSelected, isSelectable, isHovered;
@end

