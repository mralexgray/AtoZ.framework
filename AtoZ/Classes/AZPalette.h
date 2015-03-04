//
//  AZPalette.h
//  AtoZ
//
//  Created by Alex Gray on 11/4/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MArray.h"

#import <AtoZ/AtoZ.h>
@interface AZPalette : NSArray

+ (AZP*) randomPalette;

@property (strong, NATOM) 	NSA *indexed;
@property (strong, NATOM) 	NSMA *feeder;


- (NSC*) nextColor;
- (NSUI) indexOfColor:(NSC*)color;

@end
