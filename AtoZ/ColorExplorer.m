//
//  ColorExplorer.m
//  AtoZ
//
//  Created by Alex Gray on 4/5/15.
//  Copyright (c) 2015 mrgray.com, inc. All rights reserved.
//

#import "ColorExplorer.h"
#import <AtoZ/AtoZ.h>

@interface ColorExplorer ()

@end

@implementation ColorExplorer

- (void)windowDidLoad {

    [super windowDidLoad];
    [self.window overrideCanBecomeKeyWindow:YES];
    [self.window overrideCanBecomeMainWindow:YES];
    [_treeController setContent:[NSCL namedColorDictionary]];
  [_outline reloadData];

  NSLog(@"what a huge vageen");

}

@end
