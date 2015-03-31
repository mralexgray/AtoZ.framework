//  THMatrix.h
//  Lumumba Framework
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.

// A THMatrix is always mutable


@interface AZMatrix : NSObject {
	NSUI width, height;
	NSMA *data;
}

@property (NA,ASS) NSUI width, height;

- (id) objectAtX:(NSUInteger)x y:(NSUInteger)y;

@end
