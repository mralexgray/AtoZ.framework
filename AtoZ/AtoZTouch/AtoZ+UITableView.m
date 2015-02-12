//
//  AtoZ+UITableView.m
//  AtoZ
//
//  Created by Alex Gray on 2/5/15.
//  Copyright (c) 2015 mrgray.com, inc. All rights reserved.
//

#import "AtoZ+UITableView.h"

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
