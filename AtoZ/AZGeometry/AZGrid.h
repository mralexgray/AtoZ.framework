//
//  AZGrid.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AZPoint.h"
#import "AZSize.h"
#import "AZRect.h"
#import "AZGrid.h"
#import "AZMatrix.h"

enum {
  AZGridStyleCompact = 0,
  AZGridStyleHorizontal = 1,
  AZGridStyleVertical = 2
};

enum AZGridOrder {
  AZGridRowMajorOrder = 0,
  AZGridColumnMajorOrder = 1
};

@class AZPoint, AZSize, AZRect, AZMatrix;

@interface AZGrid : NSObject {
  NSMutableArray *array;
  NSUInteger parallels;
  NSUInteger style;
  NSUInteger order;
  BOOL rowMajorOrder;
}

-(id)initWithCapacity:(NSUInteger)numItems;

@property (readonly) NSUInteger count;
@property (unsafe_unretained, readonly) AZSize* size;
@property (readonly) CGFloat width;
@property (readonly) CGFloat height;

@property (readonly) CGFloat min;
@property (readonly) CGFloat max;

@property (assign) NSUInteger parallels;
@property (assign) NSUInteger order;
@property (assign) NSUInteger style;

-(NSMutableArray *)elements;
-(NSNumber *)indexAtPoint:(NSPoint)point;
-(id)objectAtIndex:(NSUInteger)index;
-(id)objectAtPoint:(NSPoint)point;
-(AZPoint *)pointAtIndex:(NSUInteger)index;

-(void)addObject:(id)anObject;
-(void)insertObject:(id)anObject atIndex:(NSUInteger)index;
-(void)removeObjectAtIndex:(NSUInteger)index;
-(void)removeAllObjects;

@end