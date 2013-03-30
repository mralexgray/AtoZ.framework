//
//  AppDelegate.h
//  AZLayerGrid
//
//  Created by Alex Gray on 7/20/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZGridView.h"

@interface AZLayerGridDelegate : NSObject <NSApplicationDelegate, AZBoxGridDataSource, AZBoxGridDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet AZGridView *gridView;

@property (nonatomic, retain) NSMA *content;
@property (NATOM,ASS) IBOutlet AZBoxGrid *boxes;

@end
