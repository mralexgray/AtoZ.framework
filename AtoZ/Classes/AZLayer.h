//
//  AZLayer.h
//  AtoZ
//
//  Created by Alex Gray on 10/8/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"
#import <QuartzCore/QuartzCore.h>

@interface AZLayer : CATransformLayer



+ (AZLayer*)withFrame:(NSRect)frame forObject:(id)file atIndex:(NSUInteger)index;
- (void)orientWithX: (CGFloat)x andY: (CGFloat)y;

@property (assign, nonatomic) AZWindowPosition 	orient;

@property (retain, nonatomic) CALayer*			front;
@property (retain, nonatomic) CALayer*			back;
@property (retain, nonatomic) CALayer*			iconL;
@property (retain, nonatomic) CATextLayer*		labelL;

@property (assign, nonatomic) NSUInteger 		index;
@property (retain, nonatomic) NSString*			string;
@property (retain, nonatomic) NSImage*			image;

@property (retain, nonatomic) NSString*			stringToDraw;
@property (retain, nonatomic) NSFont*			font;

@property (assign, nonatomic) BOOL				flipped, hovered, selected;
@end
