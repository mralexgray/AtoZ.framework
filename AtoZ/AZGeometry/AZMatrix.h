//
//  THMatrix.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// A THMatrix is always mutable

@interface AZMatrix : NSObject {
  NSUInteger width, height;
  NSMutableArray *data;
}

@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;

-(id)objectAtX:(NSUInteger)x y:(NSUInteger)y;

@end
