
//  AZSimpleView.h
//  AtoZ

//  Created by Alex Gray on 7/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Cocoa/Cocoa.h>
#import "AtoZ.h"
#import <QuartzCore/QuartzCore.h>


@interface AZSimpleView : NSView
@property (assign) BOOL clear;
@property (assign) BOOL glossy;
@property (assign) BOOL gradient;
@property (assign) BOOL checkerboard;
@property (nonatomic, strong) NSColor *backgroundColor;
@end


@interface AZSimpleGridView : NSView
@property (assign, nonatomic) NSSize dimensions;
@property (nonatomic, retain)  CALayer *grid;
@property (assign, nonatomic) NSUInteger rows, columns;
@end