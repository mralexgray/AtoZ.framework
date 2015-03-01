//
//  AtoZ+UITableView.m
//  AtoZ
//
//  Created by Alex Gray on 2/5/15.
//  Copyright (c) 2015 mrgray.com, inc. All rights reserved.
//

#import "UITableView+AtoZ.h"

@implementation UITableView (AtoZ)

- (void) update:(void(^)(UITableView*t)) block {

  __block typeof(self) bSelf = self;

  [bSelf beginUpdates];
  {
    block(bSelf);
  }
  [bSelf endUpdates];

}


@end




@implementation UITabBarController (Swipe)

- (void) setupSwipeGestureRecognizersAllowCyclingThroughTabs:(BOOL)allowsCycling {     UISwipeGestureRecognizer *leftSwipeGR, *rightSwipeGR;
 

    leftSwipeGR = [UISwipeGestureRecognizer.alloc initWithTarget:self action:allowsCycling ? @selector(handleSwipeLeftWithCycling:)
                                                                                           : @selector(handleSwipeLeft:)];
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;

    [self.view addGestureRecognizer:leftSwipeGR]; //  [self.tabBar addGestureRecognizer:leftSwipeGestureRecognizer];


    rightSwipeGR = [UISwipeGestureRecognizer.alloc initWithTarget:self action:allowsCycling ? @selector(handleSwipeRightWithCycling:)
                                                                                            : @selector(handleSwipeRight:)];
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;

    [self.view addGestureRecognizer:rightSwipeGR]; // [self.tabBar addGestureRecognizer:rightSwipeGestureRecognizer];
}

- (void)  handleSwipeLeft:(UISwipeGestureRecognizer*)_ { self.selectedIndex -= 1; }

- (void) handleSwipeRight:(UISwipeGestureRecognizer*)_ { self.selectedIndex += 1;
}

- (void)handleSwipeLeftWithCycling:(UISwipeGestureRecognizer *)swipe { NSInteger nextIndex = self.selectedIndex - 1;

    self.selectedIndex = nextIndex >= 0 ? nextIndex : self.viewControllers.count - 1;
}

- (void)handleSwipeRightWithCycling:(UISwipeGestureRecognizer *)swipe { NSInteger nextIndex = self.selectedIndex + 1;

    self.selectedIndex = nextIndex < self.viewControllers.count ? nextIndex : 0;
}


@end
