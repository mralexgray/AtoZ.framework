//
//  StarLayer.h
//
//  Created by Ian Voyce on 02/12/2011.
//  Copyright (c) 2011 Ian Voyce. All rights reserved.
//

#import <AtoZ/AtoZ.h>
@interface StarLayer : CALayer

@property (STR, NA) NSC* color, *outlineColor;
@property (ASS, NA) 	AZState spinState;


-(void) toggleSpin: (AZState)state;
//-(id) initWithRect: (CGR)rect;

@end
