//
//  TUITableView+Updating.h
//  TwUI
//
//  Created by Adam Kirk on 6/22/13.
//
//

#import <TwUI/TUIKit.h>

//#import "TUITableView.h"

@interface TUITableView (Updating)

- (void)__beginUpdates;
- (void)__endUpdates;
- (void)__insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(TUITableViewRowAnimation)animation;
- (void)__deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(TUITableViewRowAnimation)animation;

@end
