//
//  AtoZGridView.h
//
//  Created by cocoa:naut on 06.10.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//


#import "AtoZGridViewProtocols.h"


@class AZGridView;
@interface AtoZGridViewAuto : NSView <AtoZGridViewDataSource, AtoZGridViewDelegate>
-(id)initWithArray:(NSArray*)array;// inView:(NSView*)view;
@property (nonatomic, assign) NSSize itemSize;
@property (weak) NSView* view;
@property (strong, nonatomic) NSScrollView *scrollView;
@property (strong, nonatomic) NSArray * array;
@property (strong, nonatomic) AtoZGridView *grid;

@end



FOUNDATION_EXPORT NSString *const reuseIdentifier;
typedef enum {
    AtoZGridViewItemVisibleContentNothing         = 0,
    AtoZGridViewItemVisibleContentImage           = 1 << 0,
    AtoZGridViewItemVisibleContentTitle           = 1 << 1,
} AtoZGridViewItemVisibleContent;

@class AtoZGridViewItem;
/**	`AtoZGridView` is an easy to use (wanna be) `NSCollectionView` replacement. It was completely written from the ground up.
 `AtoZGridView` is a (wanna be) replacement for NSCollectionView. It has full delegate and dataSource support with method calls like known from NSTableView/UITableView.
 
 The use of `AtoZGridView` is just simple as possible. */
@interface AtoZGridView : NSView

#pragma mark - Initializing a AtoZGridView Object
/** @name Initializing a AtoZGridView Object */
@property (nonatomic, strong) NSColor *backgroundColor;

#pragma mark - Managing the Delegate and the Data Source
/** @name Managing the Delegate and the Data Source */
/**	Property for the receiver's delegate. */
@property (nonatomic, strong) IBOutlet id<AtoZGridViewDelegate> delegate;
/**	Property for the receiver's data source. */
@property (nonatomic, strong) IBOutlet id<AtoZGridViewDataSource> dataSource;

#pragma mark - Configuring the GridView
/** @name Configuring the GridView */
/**	A title string for the grid view. The default value is `nil`. */
@property (nonatomic, strong) NSString *gridViewTitle;
/**	Property for setting the elasticity of the enclosing `NSScrollView`.
 This property will be set and overwrite the values from Interface Builder. There is no horizontal-vertical distinction.
 The default value is `YES`.
 @param     YES Elasticity is on.
 @param     NO Elasticity is off. */
@property (nonatomic, assign) BOOL scrollElasticity;
/**	Property for setting the grid view item size. */
@property (nonatomic, assign) NSSize itemSize;
/**	Returns the number of currently visible items of `AtoZGridView`.
 The returned value of this method is subject to continous variation. It depends on the actual size of its view and will be calculated in realtime. */
@property (readonly) NSUInteger numberOfVisibleItems;
@property (readonly) NSNumber *visibleItems;

#pragma mark - Creating GridView Items
/** @name Creating GridView Items */
- (id) dequeueReusableItemWithIdentifier:(NSString*) identifier;

#pragma mark - Managing Selections and Hovering
/** @name Managing Selections */
/**	Property for setting whether the grid view allows item selection or not.
 The default value is `YES`. */
@property (nonatomic, assign) BOOL allowsSelection;
@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL useSelectionRing;
@property (nonatomic, assign) BOOL useHover;

/**	A bit mask that defines the content a `AtoZGridViewItem` should show.
 There are three possible values:  Default value is `AtoZGridViewItemVisibleContentImage | AtoZGridViewItemVisibleContentTitle`. */
@property (nonatomic, assign) AtoZGridViewItemVisibleContent visibleContentMask;
@property (nonatomic, assign) CGFloat selectionRingLineWidth;
@property (nonatomic, assign) NSUInteger contentInset;
@property (nonatomic, assign) NSUInteger itemBorderRadius;
@property (strong) 			  NSDictionary *itemTitleTextAttributes;

#pragma mark - Colors
/** @name GridView Item Colors */
/**	The background color of the `AtoZGridViewItem`. You can set any known `NSColor` values, also pattern images. If this property is not used it will be set to the */
@property (nonatomic, strong) NSColor *itemBackgroundColor;
/** Returns the standard `AtoZGridViewItem` background color when the item is in mouse over state (property must be enabled) */
@property (nonatomic, strong) NSColor *itemBackgroundHoverColor;
/** Returns the standard `AtoZGridViewItem` background color when the item is selected */
@property (nonatomic, strong) NSColor *itemBackgroundSelectionColor;
/**	The color of the selection ring.
 If this property is not used it will be set to the default value `[NSColor itemSelectionRingColor]`. Also see NSColor(AtoZGridViewPalette). */
/** Returns the standard `AtoZGridViewItem` selection ring color when the item is selected */
@property (nonatomic, strong) NSColor *itemSelectionRingColor;
@property (nonatomic, strong) NSColor *itemTitleColor, *itemTitleShadowColor, *selectionFrameColor;

#pragma mark - Managing the Content
/** @name  Managing the Content */
- (void) removeItem:(AtoZGridViewItem*) theItem;
- (void) removeItemAtIndex:(NSUInteger)index;
- (void) removeAllItems;
- (void) removeAllSelectedItems;

#pragma mark - Reloading GridView Data
/** @name  Reloading GridView Data */
- (void) reloadData;

#pragma mark - Scrolling to GridView Items
/** @name  Scrolling to GridView Items */
- (void) scrollToGridViewItem:(AtoZGridViewItem*) gridViewItem animated:(BOOL)animated;
- (void) scrollToGridViewItemAtIndexPath:(NSIndexPath*) indexPath animated:(BOOL)animated;

@end


__unused static NSString *kCNDefaultItemIdentifier;
__unused static NSInteger CNItemIndexNoIndex = -1;
__unused static NSString *kAtoZGridViewItemClearHoveringNotification;
__unused static NSString *kAtoZGridViewItemClearSelectionNotification;

@interface AtoZGridViewItem : NSView
#pragma mark - Initialization
/** @name Initialization */
/**	Creates and returns an initialized  This is the designated initializer. */
- (id)initInGrid:(AtoZGridView*)grid reuseIdentifier:(NSString*) reuseIdentifier;

#pragma mark - Reusing Grid View Items
/** @name Reusing Grid View Items */
@property (strong) 				NSString *reuseIdentifier;
@property (readonly, nonatomic) BOOL isReuseable;
- (void) prepareForReuse;

#pragma mark - Item Default Content
/** @name Item Default Content */
@property (strong) IBOutlet NSImage 	*itemImage;
@property (strong) IBOutlet NSString 	*itemTitle;
@property (assign) 			NSInteger 	index;

#pragma mark - Grid View Item Layout
/** @name Grid View Item Layout */
@property (weak) AtoZGridView *grid;
//AtoZGridViewItemLayout *standardLayout, *hoverLayout, *selectionLayout;
@property (nonatomic, assign) BOOL useLayout;

#pragma mark - Selection and Hovering
/** @name Selection and Hovering */
@property (nonatomic, assign) BOOL isSelected, isSelectable, isHovered;
@end

