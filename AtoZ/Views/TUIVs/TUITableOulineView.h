//
//  TUITableOulineView.h
//  Example
//
//  Created by Ivan Ablamskyi on 13.02.13.
//
//

//#import "TUITableView.h"
#import <TwUI/TUIKit.h>
@class TUITableOulineView;
@protocol TUITableOutlineViewDelegate <TUITableViewDelegate>

- (void)tableView:(TUITableOulineView *)tableView willOpenSection:(NSInteger)section;
- (void)tableView:(TUITableOulineView *)tableView didOpenSection:(NSInteger)section;

- (void)tableView:(TUITableOulineView *)tableView willCloseSection:(NSInteger)section;
- (void)tableView:(TUITableOulineView *)tableView didCloseSection:(NSInteger)section;

@end

@interface TUITableOulineView : TUITableView
@property (strong, nonatomic) TUIView *openedSectionBackgroundView;

- (void)toggleSection:(NSInteger)section;

- (BOOL)sectionIsOpened:(NSInteger)section;
- (void)scrollToSection:(NSInteger)section;

@end
    