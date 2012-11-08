//
//  AtoZGridViewDataSource.h
//  SieveMail
//
//  Created by cocoa:naut on 07.10.12.
//  Copyright (c) 2012 cocoa:naut. All rights reserved.
//


@class AtoZGridView;
@class AtoZGridViewItem;

@protocol AtoZGridViewDelegate <NSObject>
@optional
#pragma mark Managing selection
/** @name Managing selection */

- (void) gridView:(AtoZGridView*) gridView willHovertemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void) gridView:(AtoZGridView*) gridView willUnhovertemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void) gridView:(AtoZGridView*) gridView willSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void) gridView:(AtoZGridView*) gridView didSelectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void) gridView:(AtoZGridView*) gridView willDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;;
- (void) gridView:(AtoZGridView*) gridView didDeselectItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void) gridView:(AtoZGridView*) gridView didClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void) gridView:(AtoZGridView*) gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;
- (void) gridView:(AtoZGridView*) gridView rightMouseButtonClickedOnItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;

@end

@class AtoZGridView;
@protocol AtoZGridViewDataSource <NSObject>

- (NSUInteger)gridView:(AtoZGridView*) gridView numberOfItemsInSection:(NSInteger)section;
- (AtoZGridViewItem*) gridView:(AtoZGridView*) gridView itemAtIndex:(NSInteger)index inSection:(NSInteger)section;

@optional
- (NSUInteger)numberOfSectionsInGridView:(AtoZGridView*) gridView;
- (NSString*) gridView:(AtoZGridView*) gridView titleForHeaderInSection:(NSInteger)section;
- (NSArray*) sectionIndexTitlesForGridView:(AtoZGridView*) gridView;

@end

