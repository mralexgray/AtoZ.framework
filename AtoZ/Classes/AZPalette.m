//
//  AZPalette.m
//  AtoZ
//
//  Created by Alex Gray on 11/4/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZPalette.h"

@implementation AZPalette

- (id)init
{
    self = [super init];
    if (self) {
        self.indexed = [NSC randomPalette];
    }
    return self;
}

- (void) setIndexed:(NSA*)indexed
{
	_feeder = [NSMA arrayWithArray:indexed.copy];
	_indexed = indexed;
}

- (NSC*)nextColor {
	NSC*c = [[_feeder first]copy];
	[_feeder firstToLast];
	return c;
}

-(NSUI) indexOfColor:(NSC*)color
{
	return [_indexed indexOfObject:color];
}


@end
