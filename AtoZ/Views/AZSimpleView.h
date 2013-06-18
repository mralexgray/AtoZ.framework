
//  AZSimpleView.h
//  AtoZ

//  Created by Alex Gray on 7/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Cocoa/Cocoa.h>
#import "AtoZ.h"
#import <QuartzCore/QuartzCore.h>

@interface AZSimpleView : NSView
@property (assign) BOOL clear, glossy, gradient, checkerboard;
@property (nonatomic, strong) NSColor *backgroundColor;


+ (instancetype) withFrame:(NSR)f 		color:(NSC*)c;

-         (void) setFrameSizePinnedToTopLeft:(NSSZ)size;

@end

@interface AZSimpleGridView : NSView
@property (NATOM, ASS) NSSize dimensions;
@property (nonatomic, retain)  CALayer *grid;
@property (NATOM, ASS) NSUInteger rows, columns;

@end
