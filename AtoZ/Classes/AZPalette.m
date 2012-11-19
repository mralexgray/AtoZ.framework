//
//  AZPalette.m
//  AtoZ
//
//  Created by Alex Gray on 11/4/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZPalette.h"
//#import "MArray.h"


static 	NSUI internalIndex = 0;

@implementation AZPalette

//- (id) init
//{
//	if(!(self=[super initWithCapacity:500])) return nil;
//  	internalIndex = 0;
////        self.indexed = [NSC randomPalette];
//    return self;
//}


+ (AZP*) randomPalette
{
	return  [AZP arrayWithArray:[NSC randomPalette]];
}

- (void) setIndexed:(NSA*)indexed
{
	_feeder = [NSMA arrayWithArray:indexed.copy];
	_indexed = indexed;
}

- (NSC*)nextColor {

	NSC *c = (NSC*)self[internalIndex];
	internalIndex = internalIndex < self.count -1 ? internalIndex +1 : 0;
//	[_feeder firstToLast];
	return c;
}

-(NSUI) indexOfColor:(NSC*)color
{
	return [_indexed indexOfObject:color];
}


@end
