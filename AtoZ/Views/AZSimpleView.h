
//  AZSimpleView.h
//  AtoZ

//  Created by Alex Gray on 7/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import <Cocoa/Cocoa.h>

@interface AZSimpleView : NSView
@property (assign) BOOL glossy;
@property (assign) BOOL gradient;
@property (assign) BOOL checkerboard;
@property (nonatomic, strong) NSColor *backgroundColor;
@end
