//
//  AZMedallionView.h
//  AtoZ
//
//  Created by Alex Gray on 9/9/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

#define UIImage NSImage
#define UIColor NSColor

@interface AZMedallionView : NSView

@property (nonatomic, assign) CGGradientRef alphaGradient;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, retain) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowBlur;

@end
