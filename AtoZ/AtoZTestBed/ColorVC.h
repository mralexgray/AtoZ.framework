//
//  AZColorViewController.h
//  AtoZ
//
//  Created by Alex Gray on 11/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorVC : NSViewController
@property (nonatomic, retain) NSA *palette;
@property (assign) IBOutlet NSBUTT *reloadPalette;
@property IBOutlet AtoZGridViewAuto *autoGrid;
@property IBOutlet NSMatrix *matrix;
@property IBOutlet NSTableView *table;


@end
