//
//  AZBox.h
//  AtoZ
//
//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@interface AZBox : NSView
@property (nonatomic, retain) NSColor *pattern;
@property (nonatomic, retain) NSColor *color;
@property (assign) NSUInteger tag;

@property (nonatomic, retain) id representedObject;
@property (nonatomic, retain) id string;
@property (assign) CGFloat radius;

@end
