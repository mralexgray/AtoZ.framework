//
//  THMatrix.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AZMatrix.h"
@implementation AZMatrix

-(id)init {
  if ((self = super.init)) {
	data = NSMA.new;
	height = 0;
	width = 0;
  }
  
  return self;
}
@synthesize width, height;

-(void)setHeight:(NSUInteger)hv {
  // this is easy, just extend or crop the array
  if (hv == height) {
	// NADA
	return;
  }
  if (hv > height) {
	// FIXME hier weiterschreiben
  }
}

-(void)setWidth:(NSUInteger)wv {
  
}

-(id)objectAtX:(NSUInteger)x y:(NSUInteger)y {
  if (x > width || y > height) {
	[NSException raise:@"AZMatrixIndexOutOfBounds" 
				format:@"Matrix index (%ld, %ld) out of bounds (%ld, %ld)",
	 x,y,width,height];
	return nil;
  }
  return data[(y * width + x)];
}

@end
