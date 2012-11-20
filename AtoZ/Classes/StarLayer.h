//
//  StarLayer.h
//
//  Created by Ian Voyce on 02/12/2011.
//  Copyright (c) 2011 Ian Voyce. All rights reserved.
//

#import "AtoZ.h"

@interface StarLayer : CALayer

@property (STRNG, NATOM) NSC* color, *outlineColor;
@property (ASS, NATOM) 	AZState spinState;


-(void) toggleSpin: (AZState)state;
//-(id) initWithRect: (CGR)rect;

@end
