//
//  AtoZ+UITableView.h
//  AtoZ
//
//  Created by Alex Gray on 2/5/15.
//  Copyright (c) 2015 mrgray.com, inc. All rights reserved.
//

@import UIKit;

@interface UITableView (AtoZ)

- (void) update:(void(^)(UITableView*)) block;

@end


@interface UITabBarController (Swipe)

- (void) setupSwipeGestureRecognizersAllowCyclingThroughTabs:(BOOL)allowsCycling;

@end
