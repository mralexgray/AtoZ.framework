//
//  TUITableOulineView.m
//  Example
//
//  Created by Ivan Ablamskyi on 13.02.13.
//
//

#import "TUITableOulineView.h"
//#import "TUILayoutConstraint.h"
#import <TwUI/TUIKit.h>
@interface TUIView (PrivateKludge)
+ (id) _currentAnimation;
@end


/*
CG_INLINE CGRect CGRectWithPoints(CGPoint s, CGPoint e)
{
    CGRect res = CGRectZero;
    
    res.size.width = e.x - s.x;
    res.size.height = e.y - s.y;
    res.origin = s;
    
    return res;
};*/

CG_INLINE CGPoint CGRectGetTopPoint(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
}

CG_INLINE CGPoint CGRectGetBottomPoint(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
}

CG_INLINE CGFloat durationForOffset(CGFloat offset)
{
    return 0.5;
    return 1.0/300.0 * ABS(offset);
}


@interface TUITableOulineView (Private)

- (void)_updateSectionInfo;
- (BOOL)_preLayoutCells;
- (void)_layoutSectionHeaders:(BOOL)visibleHeadersNeedRelayout;
- (void)_layoutCells:(BOOL)visibleCellsNeedRelayout;

@end

@implementation TUITableOulineView
{
    CGFloat _transitionOffset;
    CGFloat _topOffset, _bottomOffset;
    
    NSInteger   _openedSection;
    NSInteger   _openningSection;
    BOOL        _openning;
    TUIView     *_oldBackgroundView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _openedSection = NSIntegerMin;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)toggleSection:(NSInteger)section
{
    CGRect currentSectionRect = [self rectForSection:section];
    __block CGRect visibleRect = [self visibleRect];
    
    CGRect openedSectionRect    = [self rectForSection:_openedSection];
    CGFloat openedSectionHeight = CGRectGetHeight(openedSectionRect);
    
    CGRect openedHeader         = [self rectForHeaderOfSection:_openedSection];
    CGFloat openedHeaderHeight  = CGRectGetHeight(openedHeader);
    
    NSMutableIndexSet *topSections = (NSMutableIndexSet *)[self indexesOfSectionsInRect:
                                                           CGRectWithPoints(CGRectGetTopPoint(currentSectionRect), CGRectGetTopPoint(visibleRect))];
    
    NSMutableIndexSet *bottomSections = (NSMutableIndexSet *)[self indexesOfSectionsInRect:
                                                              CGRectWithPoints(CGRectGetBottomPoint(visibleRect), CGRectGetBottomPoint(currentSectionRect))];
    
    [topSections removeIndex:section];
    [bottomSections removeIndex:section];

    _openning = YES;
    _openningSection = section;
    
    BOOL haveOpened = [topSections containsIndex:_openedSection] || [bottomSections containsIndex:_openedSection];
    BOOL previousTop = [topSections containsIndex:_openedSection];
    
    
    if (haveOpened && self.delegate && [_delegate respondsToSelector:@selector(tableView:willCloseSection:)]) {
        [_delegate tableView:self willCloseSection:_openedSection];
    }
    
    _oldBackgroundView = self.openedSectionBackgroundView;
    self.openedSectionBackgroundView = nil;
    

    // Update sctions info to get fill up new sectio
    _topOffset = [topSections containsIndex:_openedSection] ? openedSectionHeight : 0.0;
    [self _updateSectionInfo];

    // Calculate section size and header size to find out fix sizes
    CGRect headerRect   = [self rectForHeaderOfSection:section];
    CGRect sectionRect  = [self rectForSection:section];
    
    CGFloat sectionHeight   = CGRectGetHeight(sectionRect);
    CGFloat headerHeight    = CGRectGetHeight(headerRect);
    CGFloat newHeight = (_contentHeight - openedSectionHeight) + headerHeight;
    
//**  WARNING TO FIX warning This is not proper height and needs to be improved
    if (haveOpened && topSections) {
        _topOffset = openedSectionHeight;
        _bottomOffset = sectionHeight;
    } else if (haveOpened) {
        _bottomOffset = openedSectionHeight;
        _topOffset =sectionHeight;
    } else {
        _topOffset = sectionHeight;
        _bottomOffset = sectionHeight;
    }
    
    if (_openedSection != section) {
    } else {
        // Append indexes
        [topSections addIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, section)]];
    }
    
    _transitionOffset = (sectionHeight - headerHeight);
    __block CGPoint beginOffset = self.contentOffset;
    
    // In case not closing section - needs to create background that will apear under cells
    if (section != _openedSection) {
        self.openedSectionBackgroundView = [[TUIView alloc] initWithFrame:sectionRect];
        [self addSubview:self.openedSectionBackgroundView];
    }
    
    if (self.delegate && [_delegate respondsToSelector:@selector(tableView:willOpenSection:)]) {
        [_delegate tableView:self willOpenSection:section];
    }

    
    // Layoyt new section and retur all cell to previus state
    self.contentSize = CGSizeMake(self.contentSize.width, _contentHeight);
    [self _layoutSectionHeaders:YES];
    [self _layoutCells:YES];
    
    
    if(!_tableFlags.layoutSubviewsReentrancyGuard) {
        _tableFlags.layoutSubviewsReentrancyGuard = 1;
        
        
        [TUIView setAnimationsEnabled:NO block:^{
            [CATransaction setDisableActions:YES];
            if (section != _openedSection) {
                [self _moveSections:topSections forOffset: -_transitionOffset];
                [self _moveSection:section forOffset: -_transitionOffset];
                [self sendSubviewToBack:self.openedSectionBackgroundView];
            }
        }];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [TUIView beginAnimations:NSStringFromSelector(_cmd) context:NULL];
            
            void (^compleationBlock)(BOOL) = ^(BOOL finished) {
                [TUIView setAnimationsEnabled:NO block:^{
                    NSLog(@"done %@", @(finished));

                    if (_openedSection != section && self.delegate && [_delegate respondsToSelector:@selector(tableView:didOpenSection:)]) {
                        [_delegate tableView:self didOpenSection:section];
                    }
                    
                    if (haveOpened && self.delegate && [_delegate respondsToSelector:@selector(tableView:willCloseSection:)]) {
                        [_delegate tableView:self willCloseSection:_openedSection];
                    }
                    
                    if (_oldBackgroundView) {
                        [_oldBackgroundView removeFromSuperview];
                        _oldBackgroundView = nil;
                    }

                    _openning = NO;
                    _openedSection = _openedSection == section ? NSIntegerMin : section;
                    _openningSection = NSIntegerMin;
                    _transitionOffset = 0;
                    _topOffset = 0;
                    _bottomOffset = 0;
                    _tableFlags.layoutSubviewsReentrancyGuard = 0;
                    
                    [self reloadData];
                    
                }];
            };

            // !******!
            // !* In case openned section is lower - we need two step animation
            // !******!
            if (haveOpened && previousTop && (openedSectionHeight < sectionHeight || CGRectGetMaxY(headerRect) > CGRectGetMaxY(visibleRect))) {
                CGFloat firstOffset = MIN(openedSectionHeight - openedHeaderHeight, (CGRectGetMaxY(visibleRect) - CGRectGetMinY(sectionRect) - headerHeight));
                CGFloat secondOffset = _transitionOffset - firstOffset;
                [self _orderBackSection:_openedSection];

                [TUIView animateWithDuration:durationForOffset(firstOffset) animations:^{
                    [TUIView setAnimationCurve:TUIViewAnimationCurveEaseIn];
                    [topSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        if (idx > _openedSection)
                            [self _moveSection:idx forOffset:firstOffset];
                    }];
                    
                    [self _moveSection:section forOffset:firstOffset];
                } completion:^(BOOL finished) {
                    [TUIView animateWithDuration:durationForOffset(secondOffset) animations:^{
                        [TUIView setAnimationCurve:TUIViewAnimationCurveEaseOut];
                        [topSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                            [self _moveSection:idx forOffset:secondOffset];
                        }];
                        
                        [self _moveSection:section forOffset:secondOffset];
                        [self setContentSize:CGSizeMake(self.contentSize.width, newHeight)];
                        
                        // If content have fit on screen itself, then needs to help with
                        if (CGRectGetMaxY(headerRect) > CGRectGetMaxY(visibleRect)) {
                            CGPoint newOffset = CGPointMake(self.contentOffset.x, - (CGRectGetMaxY(headerRect) - CGRectGetHeight(visibleRect)));
                            [self setContentOffset: newOffset];
                            beginOffset = self.contentOffset;
                        } else if (newHeight < CGRectGetHeight(self.bounds)) {
                            CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(self.bounds) - newHeight);
                            [self setContentOffset: newOffset];
                            beginOffset = self.contentOffset;
                        }
                    } completion:^(BOOL finished) {
                        [self _orderFrontSection:_openedSection];
                        compleationBlock(finished);
                    }];
                }];
                
            } else if (haveOpened && previousTop) {
                CGFloat firstOffset = _transitionOffset;
                CGFloat secondOffset = openedSectionHeight - _transitionOffset - openedHeaderHeight;
                [self _orderBackSection:_openedSection];

                [TUIView animateWithDuration:durationForOffset(firstOffset) animations:^{
                    [TUIView setAnimationCurve:TUIViewAnimationCurveEaseIn];
                    [topSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        if (idx > _openedSection) {
                            [self _moveSection:idx forOffset:firstOffset];
                        }
                    }];
                    
                    [self _moveSection:section forOffset:firstOffset];
                    
                } completion:^(BOOL finished) {
                    [TUIView animateWithDuration:durationForOffset(secondOffset) animations:^{
                        [TUIView setAnimationCurve:TUIViewAnimationCurveEaseInOut];
                        [topSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                            if (idx <= _openedSection) {
                                [self _moveSection:idx forOffset:-secondOffset];
                            }
                        }];
                        [self setContentSize:CGSizeMake(self.contentSize.width, newHeight)];
                        
                        if (newHeight < CGRectGetHeight(self.bounds)) {
                            CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(self.bounds) - newHeight);
                            [self setContentOffset:newOffset];
                        } else if (newHeight < CGRectGetMaxY(visibleRect)) {
                            CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(visibleRect) - newHeight);
                            [self setContentOffset:newOffset];
                        }
                    } completion:^(BOOL finished) {
                        [self _orderFrontSection:_openedSection];
                        compleationBlock(finished);
                    }];
                }];
            } else if (haveOpened && (openedSectionHeight <= sectionHeight || CGRectGetMinY(sectionRect) < CGRectGetMinY(visibleRect)) ) {
                // Bottom slides;
                NSLog(@"slide down");
                CGFloat firstOffset =  openedSectionHeight - openedHeaderHeight;
                CGFloat secondOffset = _transitionOffset - openedSectionHeight + headerHeight;
                [self _orderBackSection:section];
                [topSections addIndex:section];
                
                [TUIView animateWithDuration:durationForOffset(firstOffset) animations:^{
                    [TUIView setAnimationCurve:TUIViewAnimationCurveEaseIn];
                    [bottomSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        if (idx <= _openedSection)
                            [self _moveSection:idx forOffset:-firstOffset];
                    }];
                    
                } completion:^(BOOL finished) {
                    [TUIView animateWithDuration:durationForOffset(secondOffset) animations:^{
                        [TUIView setAnimationCurve:TUIViewAnimationCurveEaseOut];
                        
                        [self _moveSections:topSections forOffset:secondOffset];
                        [self setContentSize:CGSizeMake(self.contentSize.width, newHeight)];
                        // If content have fit on screen itself, then needs to help with
                        if (newHeight < CGRectGetHeight(self.bounds)) {
                            CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(self.bounds) - newHeight);
                            [self setContentOffset:newOffset];
                        } else if (newHeight < CGRectGetMaxY(visibleRect)) {
                            CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(visibleRect) - newHeight);
                            [self setContentOffset:newOffset];
                        }
                    } completion:^(BOOL finished) {
                        [self _orderFrontSection:section];
                        compleationBlock(finished);
                    }];
                }];
            } else if (haveOpened && (openedSectionHeight > sectionHeight)) {
                CGFloat firstOffset = sectionHeight - headerHeight;
                CGFloat secondOffset = openedSectionHeight - sectionHeight;
                [self _orderBackSection:section];
                [self _orderBackSection:_openedSection];
                [topSections addIndex:section];

                [TUIView animateWithDuration:durationForOffset(firstOffset) animations:^{
                    [TUIView setAnimationCurve:TUIViewAnimationCurveEaseIn];
                    [bottomSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                        if (idx <= _openedSection)
                            [self _moveSection:idx forOffset:-firstOffset];
                    }];
                } completion:^(BOOL finished) {
                    [TUIView animateWithDuration:durationForOffset(secondOffset) animations:^{
                        [TUIView setAnimationCurve:TUIViewAnimationCurveEaseOut];
                        [self _moveSections:topSections forOffset:-secondOffset];
                        [bottomSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
                            if (idx <= _openedSection)
                                [self _moveSection:idx forOffset:-secondOffset];
                        }];

                        [self setContentSize:CGSizeMake(self.contentSize.width, newHeight)];

                        // If content have fit on screen itself, then needs to help with
                        if (newHeight < CGRectGetHeight(self.bounds)) {
                            CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(self.bounds) - newHeight);
                            [self setContentOffset:newOffset];
                        } else if (newHeight < CGRectGetMaxY(visibleRect)) {
                            CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(visibleRect) - newHeight);
                            [self setContentOffset:newOffset];
                        }
                        
                    } completion:^(BOOL finished) {
                        [self _orderFrontSection:section];
                        [self _orderFrontSection:_openedSection];
                        compleationBlock(finished);
                    }];
                }];
            } else if (section == _openedSection) {
                // !***
                // !** Needs to close
                // !**
                CGFloat offset = sectionHeight - headerHeight;
                [self _orderBackSection:section];
                [topSections addIndex:section];
                
                [TUIView animateWithDuration:durationForOffset(offset) animations:^{
                    [self _moveSections:topSections forOffset:-offset];

                    [self setContentSize:CGSizeMake(self.contentSize.width, newHeight)];
                    // If content have fit on screen itself, then needs to help with
                    if (newHeight < CGRectGetHeight(self.bounds)) {
                        CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(self.bounds) - newHeight);
                        [self setContentOffset:newOffset];
                    } else if (newHeight < CGRectGetMaxY(visibleRect)) {
                        CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(visibleRect) - newHeight);
                        [self setContentOffset:newOffset];
                    }

                } completion:^(BOOL finished) {
                    [self _orderFrontSection:section];
                    compleationBlock(finished);
                }];

            } else {
                // !**
                // !** Needs to open section
                // !**
                [self _orderBackSection:section];
                [topSections addIndex:section];
                
                [TUIView animateWithDuration:durationForOffset(_transitionOffset) animations:^{
                    [self _moveSections:topSections forOffset:_transitionOffset];
                    
                    // If content have fit on screen itself, then needs to help with
                    if (CGRectGetMaxY(headerRect) > CGRectGetMaxY(visibleRect)) {
                        CGPoint newOffset = CGPointMake(self.contentOffset.x, - (CGRectGetMaxY(headerRect) - CGRectGetHeight(visibleRect)));
                        [self setContentOffset: newOffset];
                        beginOffset = self.contentOffset;
                    } else if (newHeight < CGRectGetHeight(self.bounds)) {
                        CGPoint newOffset = CGPointMake(self.contentOffset.x, CGRectGetHeight(self.bounds) - newHeight);
                        [self setContentOffset: newOffset];
                        beginOffset = self.contentOffset;
                    }
                } completion:^(BOOL finished) {
                    [self _orderFrontSection:section];
                    compleationBlock(finished);
        
                }];
            }
            [TUIView commitAnimations];
        });
        
        
    }


}


- (CGRect)proposedScrollRectForSection:(NSInteger)section;
{
    CGFloat padding = 10;
    CGRect scrollRect = CGRectOffset([self rectForSection:section], 0, padding);
    CGRect visibleRect = [self visibleRect];
    
    // If section not fit in visible rect, will place it on screen by header to top
    // or if section is above
    if (    CGRectGetHeight(scrollRect) > CGRectGetHeight(visibleRect)
        ||  CGRectGetMaxY(scrollRect) > CGRectGetMaxY(visibleRect))
    {
        scrollRect = [self rectForHeaderOfSection:section];
        scrollRect.origin.y -= CGRectGetHeight(visibleRect) - CGRectGetHeight(scrollRect);
        scrollRect.size.height = CGRectGetHeight(visibleRect);
    }

    return scrollRect;
}

- (void)scrollToSection:(NSInteger)section;
{
    BOOL animated = [TUIView _currentAnimation] != nil;
    if (section == 0)
        return [self scrollToTopAnimated:animated];
    
    [self scrollRectToVisible:[self proposedScrollRectForSection:section] animated:animated];
}

- (BOOL)sectionIsOpened:(NSInteger)section;
{
    return (_openning && _openningSection == section) || (section == _openedSection);
}



#pragma mark - Helpers
- (void)_orderFrontSection:(NSInteger)section
{
    TUIView *header = [self headerViewForSection:section];
    header.layer.zPosition += 100;
    
    if (_openning && _openningSection == section && self.openedSectionBackgroundView) {
        self.openedSectionBackgroundView.layer.zPosition += 100;
    }
    if (_openning && _openedSection == section && _oldBackgroundView) {
        _oldBackgroundView.layer.zPosition += 100;
    }
    
    TUIFastIndexPath *from = [TUIFastIndexPath indexPathForRow:0 inSection:section];
    TUIFastIndexPath *to = [TUIFastIndexPath indexPathForRow:[self numberOfRowsInSection:section] - 1 inSection:section];
    
    [self enumerateIndexPathsFromIndexPath:from toIndexPath:to withOptions:0 usingBlock:^(NSIndexPath *indexPath, BOOL *stop){

//	 ^(TUIFastIndexPath *indexPath, BOOL *stop) {
        TUITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        cell.layer.zPosition += 100;
    }];
    
}

- (void)_orderBackSection:(NSInteger)section
{
    TUIView *header = [self headerViewForSection:section];
    header.layer.zPosition -= 100;
    
    if (_openning && _openningSection == section && self.openedSectionBackgroundView) {
        self.openedSectionBackgroundView.layer.zPosition -= 100;
    }
    if (_openning && _openedSection == section && _oldBackgroundView) {
        _oldBackgroundView.layer.zPosition -= 100;
    }
    
    NSIndexPath *from = [NSIndexPath indexPathForRow:0 inSection:section];
    NSIndexPath *to = [NSIndexPath indexPathForRow:[self numberOfRowsInSection:section] - 1 inSection:section];
    
    [self enumerateIndexPathsFromIndexPath:from toIndexPath:to withOptions:0 usingBlock:^(NSIndexPath *indexPath, BOOL *stop) {
        TUITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        cell.layer.zPosition -= 100;
    }];
    
}

- (void)_moveSections:(NSIndexSet *)indexes forOffset:(CGFloat)offset;
{
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [self _moveSection:idx forOffset:offset];
    }];
}

- (void)_moveSection:(NSInteger)section forOffset:(CGFloat)offset
{
    TUIView *header = [self headerViewForSection:section];
    header.frame = CGRectOffset(header.frame, 0, offset);
    
    if (_openning && _openningSection == section && self.openedSectionBackgroundView) {
        self.openedSectionBackgroundView.frame = CGRectOffset(self.openedSectionBackgroundView.frame, 0, offset);
    }
    if (_openning && _openedSection == section && _oldBackgroundView) {
        _oldBackgroundView.frame = CGRectOffset(_oldBackgroundView.frame, 0, offset);
    }
    
    NSIndexPath *from = [NSIndexPath indexPathForRow:0 inSection:section];
    NSIndexPath *to = [NSIndexPath indexPathForRow:[self numberOfRowsInSection:section] - 1 inSection:section];
    
    [self enumerateIndexPathsFromIndexPath:from toIndexPath:to withOptions:0 usingBlock:^(NSIndexPath *indexPath, BOOL *stop) {
        TUITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (!cell)
            NSLog(@"no cell: %@", indexPath);

//        NSLog(@"(%d) %d/%d -> off %@", (int)[TUIView isInAnimationContext], (int)indexPath.section, (int)indexPath.row, @(offset));
        cell.frame = CGRectOffset(cell.frame, 0, offset);
    }];
}

#pragma mark - Overload
- (CGRect)visibleRect
{
    CGRect vr = [super visibleRect];
    if (_openning) {
        vr.size.height += (_topOffset + _transitionOffset + _bottomOffset);
        vr.origin.y -= _bottomOffset;
    }
    
    return vr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_openning && self.openedSectionBackgroundView)
    {
        self.openedSectionBackgroundView.frame = [self rectForSection:_openedSection];
    }
    
    if (_openning && _oldBackgroundView)
    {
        CGRect sectionRect = [self rectForSection:_openedSection];
        CGRect currentRect = [[self headerViewForSection:_openedSection] frame];
        sectionRect = CGRectOffset(sectionRect, 0, -(CGRectGetMaxY(sectionRect) - CGRectGetMaxY(currentRect)));
        _oldBackgroundView.frame = sectionRect;
    }
}

@end
