//
//  ColorExplorer.h
//  AtoZ
//
//  Created by Alex Gray on 4/5/15.
//  Copyright (c) 2015 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorExplorer : NSWindowController
@property (strong) IBOutlet NSTreeController *treeController;
@property (weak) IBOutlet NSOutlineView *outline;

@end
