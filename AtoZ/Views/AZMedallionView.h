//
//  AZMedallionView.h
//  AtoZ
//
//  Created by Alex Gray on 9/9/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"

#define UIImage NSImage
#define UIColor NSColor

@interface AZMedallionView : NSView

@property (nonatomic, retain) NSImage 		*image;
@property (nonatomic, assign) CGFloat 		borderWidth, shadowBlur;
@property (nonatomic, retain) NSColor 		*shadowColor, *borderColor, 	*backgroundColor;
@property (nonatomic, assign) CGSize 		shadowOffset;
@property (nonatomic, assign) CGGradientRef alphaGradient;


@end
