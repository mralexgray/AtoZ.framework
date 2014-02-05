//
//  TUITableView+Updating.m
//  TwUI
//
//  Created by Adam Kirk on 6/22/13.
//
//

#import "TUITableView+Updating.h"
#import "TUIView+Dimensions.h"
#import <TwUI/TUITableViewCell+Private.h>
#import <TwUI/UIView+MTAnimation.h>
#import <objc/runtime.h>
#import <AtoZ/AtoZ.h>


static const char updateOperationsKey;
static const char updatingKey;


@interface TUITableViewUpdateOperation : NSObject
- (id)initWithTableView:(TUITableView *)tableView rowAnimation:(TUITableViewRowAnimation)animation;
- (void)updateCell:(TUITableViewCell *)cell;
- (void)insertCell:(TUITableViewCell *)cell;
- (void)deleteCell:(TUITableViewCell *)cell;
- (void)tempCell:(TUITableViewCell *)cell;
- (void)beginWithCompletion:(void (^)())completion;
@end


@interface TUITableViewCell (FrameShortcuts)
@property (nonatomic, assign) CGFloat ux;       // update end x
@property (nonatomic, assign) CGFloat uy;       // update end y
@property (nonatomic, assign) CGFloat uwidth;   // update end w
@property (nonatomic, assign) CGFloat uheight;  // update end h
@end


@interface TUITableViewCellClipView : TUIView
@end

@implementation TUITableViewCellClipView
@end


@interface TUITableView ()
@property (nonatomic, strong) NSMutableArray *updateOperations;
@property (nonatomic, assign) BOOL           updating;
@end


@implementation TUITableView (Updating)

- (void)__beginUpdates
{
    self.updating = YES;
    [self enumerateIndexPathsUsingBlock:^(NSIndexPath *indexPath, BOOL *stop) {
        TUITableViewCell *cell  = [self cellForRowAtIndexPath:indexPath];
        cell.updateEndFrame     = cell.frame;
        cell.updateEndAlpha     = cell.alpha;
    }];
}

- (void)__endUpdates
{
    self.updating = NO;
    for (TUITableViewUpdateOperation *operation in [self.updateOperations copy]) {
        [operation beginWithCompletion:^{
            [self.updateOperations removeObject:operation];

            // if all operations have completed
            if ([self.updateOperations count] == 0) {
                [self reloadData];
            }
        }];
    }

    // reset the table timing functions to defaults
    self.updateTimingFunction       = kMTEaseInOutSine;
    self.updateAnimationDuration    = 0.25;
}

- (void)__insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(TUITableViewRowAnimation)animation
{
    TUITableViewUpdateOperation *operation  = [TUITableViewUpdateOperation.alloc initWithTableView:self rowAnimation:animation];
    NSArray *sortedIndexPaths               = [indexPaths sortedArrayUsingSelector:@selector(compare:)];

    for (NSIndexPath *currentPath in sortedIndexPaths) {

        CGFloat newCellHeight = [_delegate tableView:self heightForRowAtIndexPath:currentPath];

        [self enumerateIndexPathsUsingBlock:^(NSIndexPath *indexPath, BOOL *stop) {

            // if this index path is in the place of or below where we want to insert, move the cell down
            NSComparisonResult result = [indexPath compare:currentPath];
            if (result != NSOrderedAscending || result == NSOrderedSame) {
                TUITableViewCell *currentCell = [self cellForRowAtIndexPath:indexPath];
                if (currentCell) {
                    CGRect r                    = self.updating ? currentCell.updateEndFrame : currentCell.frame;
                    r.origin.y                  -= newCellHeight;
                    currentCell.updateEndFrame  = r;
                    currentCell.updateEndAlpha  = 1;
                    [operation updateCell:currentCell];
                }
            }
        }];

        TUITableViewCell *newCell   = [_dataSource tableView:self cellForRowAtIndexPath:currentPath];
        [self addSubview:newCell];

        newCell.alpha               = animation == TUITableViewRowAnimationFade ? 0 : 1;
        newCell.updateEndAlpha      = 1;

        CGFloat height              = [_delegate tableView:self heightForRowAtIndexPath:currentPath];
        CGRect r                    = [self rectForRowAtIndexPath:currentPath];
        r.origin.y                  = r.origin.y + (r.size.height - height);
        r.size.height               = height;
        newCell.updateEndFrame      = r;
        newCell.frame               = r;

        [operation insertCell:newCell];
    }

    [self.updateOperations addObject:operation];
}

- (void)__deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(TUITableViewRowAnimation)animation
{
    TUITableViewUpdateOperation *operation  = [TUITableViewUpdateOperation.alloc initWithTableView:self rowAnimation:animation];
    NSArray *sortedIndexPaths               = [indexPaths sortedArrayUsingSelector:@selector(compare:)];

    for (NSIndexPath *currentPath in sortedIndexPaths) {

        TUITableViewCell *cell      = [self cellForRowAtIndexPath:currentPath];
        CGFloat deletingRowHeight   = cell.frame.size.height;

        // animate all other cells up
        [self enumerateIndexPathsUsingBlock:^(NSIndexPath *indexPath, BOOL *stop) {
            NSComparisonResult result = [indexPath compare:currentPath];
            if (result != NSOrderedAscending || result == NSOrderedSame) {
                TUITableViewCell *currentCell = [self cellForRowAtIndexPath:indexPath];
                if (currentCell) {
                    CGRect r                    = self.updating ? currentCell.updateEndFrame : currentCell.frame;
                    r.origin.y                 += deletingRowHeight;
                    currentCell.updateEndFrame  = r;
                    [operation updateCell:currentCell];
                }
            }
        }];

        // create cells that do not currently exist but will be shown when showing cells slide upward
        NSIndexPath *nextIndexPath = [[[_visibleItems allKeys] sortedArrayUsingSelector:@selector(compare:)] lastObject];
        if (nextIndexPath) {
            TUITableViewCell *bottomCell    = _visibleItems[nextIndexPath];
            CGFloat heightToCompensateFor   = deletingRowHeight;
            while (true) {

                // make sure the index path is valid
                if (nextIndexPath.row >= [_delegate tableView:self numberOfRowsInSection:nextIndexPath.section]) {
                    nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:nextIndexPath.section + 1];
                }
                if (nextIndexPath.section >= [self numberOfSections]) break;

                // create a cell that is off the bottom of the screen but will become visible as it's slid up during deletion.
                TUITableViewCell *compensationCell  = [_delegate tableView:self cellForRowAtIndexPath:nextIndexPath];
                if (!compensationCell) break;

                // frame and add a cell that will slide up and be visible durtion deletion
                CGRect frame                        = bottomCell.frame;
                frame.size.height                   = [_delegate tableView:self heightForRowAtIndexPath:nextIndexPath];
                frame.origin.y                     -= frame.size.height;
                compensationCell.frame              = frame;
                frame.origin.y                     += deletingRowHeight;
                compensationCell.updateEndFrame     = frame;
                [self addSubview:compensationCell];
                [operation tempCell:compensationCell];

                // see if we've added enough cells
                heightToCompensateFor               -= compensationCell.frame.size.height;
                if (heightToCompensateFor <= 0) break;

                // prepare for the next cell below it
                bottomCell      = compensationCell;
                nextIndexPath   = [NSIndexPath indexPathForRow:nextIndexPath.row + 1 inSection:nextIndexPath.section];
            }
        }

        cell.updateEndAlpha = animation == TUITableViewRowAnimationFade ? 0 : 1;

        [operation deleteCell:cell];
    }

    [self.updateOperations addObject:operation];
}


#pragma mark - Private

#pragma mark (properties)

- (NSMutableArray *)updateOperations
{
    NSMutableArray *cells = objc_getAssociatedObject(self, &updateOperationsKey);
    if (!cells) {
        cells = [NSMutableArray new];
        objc_setAssociatedObject(self, &updateOperationsKey, cells, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cells;
}

- (void)setUpdating:(BOOL)updating
{
    objc_setAssociatedObject(self, &updatingKey, @(updating), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)updating
{
    NSNumber *n = objc_getAssociatedObject(self, &updatingKey);
    return n ? [n boolValue] : NO;
}


@end



@interface TUITableViewUpdateOperation ()
@property (nonatomic, strong) TUITableView             *tableView;
@property (nonatomic, assign) TUITableViewRowAnimation rowAnimation;
@property (nonatomic, strong) NSMutableArray           *cells;
@property (nonatomic, strong) NSMutableArray           *cellsBeingInserted;
@property (nonatomic, strong) NSMutableArray           *cellsBeingDeleted;
@property (nonatomic, strong) NSMutableArray           *temporaryCells;
@property (nonatomic, assign) MTTimingFunction         animationTimingFunction;
@property (nonatomic, assign) NSTimeInterval           animationDuration;
@end


@implementation TUITableViewUpdateOperation

- (id)initWithTableView:(TUITableView *)tableView rowAnimation:(TUITableViewRowAnimation)animation
{
    self = [super init];
    if (self) {
        _tableView                  = tableView;
        _rowAnimation               = animation;
        _cells                      = [NSMutableArray new];
        _cellsBeingInserted         = [NSMutableArray new];
        _cellsBeingDeleted          = [NSMutableArray new];
        _temporaryCells             = [NSMutableArray new];
    }
    return self;
}

- (void)updateCell:(TUITableViewCell *)cell
{
    [_cells addObject:cell];
}

- (void)insertCell:(TUITableViewCell *)cell
{
    [self updateCell:cell];
    [_cellsBeingInserted addObject:cell];
}

- (void)deleteCell:(TUITableViewCell *)cell
{
    [self updateCell:cell];
    [_cellsBeingDeleted addObject:cell];
}

- (void)tempCell:(TUITableViewCell *)cell
{
    [self updateCell:cell];
    [_temporaryCells addObject:cell];
}

- (void)beginWithCompletion:(void (^)())completion
{
    [self configureInsertingAndDeletingCellFrames];

    [TUIView mt_animateViews:_cells duration:_animationDuration timingFunction:_animationTimingFunction animations:^{
        for (TUITableViewCell *cell in _cells) {
            cell.frame = cell.updateEndFrame;
            cell.alpha = cell.updateEndAlpha;
        }
    } completion:^{
        NSArray *cells = [_cellsBeingInserted arrayByAddingObjectsFromArray:[_cellsBeingDeleted arrayByAddingObjectsFromArray:_temporaryCells]];
        for (TUITableViewCell *cell in cells) {
            TUIView *superview = cell.superview;
            [cell removeFromSuperview]; // these were only for animation, the permaent ones will be put in during table reload.
            if ([superview isKindOfClass:[TUITableViewCellClipView class]]) {
                [superview removeFromSuperview];
            }
        }
        [_cells removeAllObjects];
        [_cellsBeingInserted removeAllObjects];
        [_cellsBeingDeleted removeAllObjects];
        [_temporaryCells removeAllObjects];
        if (completion) completion();
    }];
}


#pragma mark - Private

- (void)configureInsertingAndDeletingCellFrames
{
    _animationDuration          = _tableView.updateAnimationDuration;
    _animationTimingFunction    = _tableView.updateTimingFunction;

    for (TUITableViewCell *cell in _cellsBeingInserted) {

        if (_rowAnimation == TUITableViewRowAnimationNone) {
            _animationDuration = 0.01;
        }
        else if (_rowAnimation == TUITableViewRowAnimationFade) {
            cell.alpha          = 0;
            cell.updateEndAlpha = 1;
        }
        else if (_rowAnimation == TUITableViewRowAnimationRight) {
            cell.originX += cell.width;
        }
        else if (_rowAnimation == TUITableViewRowAnimationLeft) {
            cell.originX -= cell.width;
        }
        else if (_rowAnimation == TUITableViewRowAnimationTop) {
            [_tableView sendSubviewToBack:cell];
            [self wrapCellInClipView:cell insert:YES];
            cell.originY     += cell.height;
            cell.alpha  = 0;
        }
        else if (_rowAnimation == TUITableViewRowAnimationBottom) {
            [_tableView sendSubviewToBack:cell];
            [self wrapCellInClipView:cell insert:YES];
            cell.originY     -= cell.height;
            cell.alpha  = 0;
        }
        else if (_rowAnimation == TUITableViewRowAnimationMiddle) {
            [_tableView sendSubviewToBack:cell];
        }
        else if (_rowAnimation == TUITableViewRowAnimationGravityDrop) {
            [_tableView bringSubviewToFront:cell];
            cell.originY                      = [_tableView visibleRect].origin.y + [_tableView visibleRect].size.height;
            _animationTimingFunction    = kMTEaseOutExpo;
            _animationDuration          = 0.75;
        }
    }

    for (TUITableViewCell *cell in _cellsBeingDeleted) {

        cell.updateEndFrame = cell.frame;

        if (_rowAnimation == TUITableViewRowAnimationNone) {
            _animationDuration = 0.01;
        }
        else if (_rowAnimation == TUITableViewRowAnimationFade) {
            cell.alpha          = 1;
            cell.updateEndAlpha = 0;
        }
        else if (_rowAnimation == TUITableViewRowAnimationRight) {
            cell.ux += cell.width;
        }
        else if (_rowAnimation == TUITableViewRowAnimationLeft) {
            cell.ux -= cell.width;
        }
        else if (_rowAnimation == TUITableViewRowAnimationTop) {
            [_tableView sendSubviewToBack:cell];
            [self wrapCellInClipView:cell insert:YES];
            cell.uy                += cell.height;
            cell.updateEndAlpha     = 0;
        }
        else if (_rowAnimation == TUITableViewRowAnimationBottom) {
            [_tableView sendSubviewToBack:cell];
            [self wrapCellInClipView:cell insert:YES];
            cell.uy                -= cell.height;
            cell.updateEndAlpha     = 0;
        }
        else if (_rowAnimation == TUITableViewRowAnimationMiddle) {
            [_tableView sendSubviewToBack:cell];
        }
        else if (_rowAnimation == TUITableViewRowAnimationGravityDrop) {
            [_tableView bringSubviewToFront:cell];
            cell.uy                     = [_tableView visibleRect].origin.y - cell.height;
            _animationTimingFunction    = kMTEaseInExpo;
            _animationDuration          = 0.75;
        }
    }
}

- (void)wrapCellInClipView:(TUITableViewCell *)cell insert:(BOOL)insert
{
    CGRect frame                        = insert ? cell.updateEndFrame : cell.frame;
    TUIView *superview                  = cell.superview;
    TUITableViewCellClipView *clipView  = [TUITableViewCellClipView new];
    clipView.clipsToBounds              = YES;
    clipView.frame                      = CGRectInset(frame, 0, -20);
    [superview addSubview:clipView];
    [superview sendSubviewToBack:clipView];
    cell.frame                          = [superview convertRect:cell.frame toView:clipView];
    cell.updateEndFrame                 = [superview convertRect:cell.updateEndFrame toView:clipView];
    [clipView addSubview:cell];
}


@end



@implementation TUITableViewCell (FrameShortcuts)

- (CGFloat)ux
{
    return self.updateEndFrame.origin.x;
}

- (void)setUx:(CGFloat)ux
{
    CGRect updateFrame = self.updateEndFrame;
    updateFrame.origin.x = ux;
    self.updateEndFrame = updateFrame;
}

- (CGFloat)uy
{
    return self.updateEndFrame.origin.y;
}

- (void)setUy:(CGFloat)uy
{
    CGRect updateFrame = self.updateEndFrame;
    updateFrame.origin.y = uy;
    self.updateEndFrame = updateFrame;
}

- (CGFloat)uwidth
{
    return self.updateEndFrame.size.width;
}

- (void)setUwidth:(CGFloat)uwidth
{
    CGRect updateFrame = self.updateEndFrame;
    updateFrame.size.width = uwidth;
    self.updateEndFrame = updateFrame;
}

- (CGFloat)uheight
{
    return self.updateEndFrame.size.height;
}

- (void)setUheight:(CGFloat)uheight
{
    CGRect updateFrame = self.updateEndFrame;
    updateFrame.size.height = uheight;
    self.updateEndFrame = updateFrame;
}

@end
