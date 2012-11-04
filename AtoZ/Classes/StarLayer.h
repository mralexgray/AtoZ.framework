//
//  StarLayer.h
//
//  Created by Ian Voyce on 02/12/2011.
//  Copyright (c) 2011 Ian Voyce. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AtoZ/AtoZ.h>

#import <QuartzCore/CALayer.h>

@interface StarLayer : CALayer

@property (ASS, NATOM) AZPOS orient;
-(id)initWithRect:(CGRect)rect;

@end
