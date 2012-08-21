//
//  AZGrid.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AZGrid.h"

@interface AZGrid (Private)
-(void)_init;
@end


@implementation AZGrid

-(void)_init {
  parallels = 1;
  style = AZGridStyleCompact;
  order = AZGridRowMajorOrder;
}


-(id)init {
  if ((self = [super init])) {
    [self _init];
    array = [[NSMutableArray alloc] init];
  }
  return self;
}

-(id)initWithCapacity:(NSUInteger)numItems {
  if ((self = [super init])) {
    [self _init];
    array = [[NSMutableArray alloc] initWithCapacity:numItems];
  }
  return self;
}

-(NSUInteger)parallels {
  return parallels;
}

-(void)setParallels:(NSUInteger)v {
  self->parallels = MAX(1, parallels);
}

-(NSUInteger)style {
  return style;
}

-(void)setStyle:(NSUInteger)v {
  if (v > 2) {
    self->style = 0;
  } else {
    self->style = v;
  }
}

-(NSUInteger)order {
  return order;
}

-(void)setOrder:(NSUInteger)o {
  if (o <= 1) {
    self->order = o;
  }
}

-(NSUInteger)count {
  return array.count;
}

-(NSMutableArray *)elements {
  return array;
}

-(void)addObject:(id)anObject {
  [array addObject:anObject];
}

-(void)insertObject:(id)anObject atIndex:(NSUInteger)index {
  [array insertObject:anObject atIndex:index];
}

-(void)removeAllObjects {
  [array removeAllObjects];
}

-(void)removeObjectAtIndex:(NSUInteger)index {
  [array removeObjectAtIndex:index];
}

-(id)objectAtIndex:(NSUInteger)index {
  return array[index];
}

-(AZSize *)size {
  NSSize s = NSMakeSize(0, 0);
  
  if (style == AZGridStyleHorizontal) {
    s.width = ceil(self.count / parallels);
    s.height = parallels;
  } else if (style == AZGridStyleVertical) {
    s.width = parallels;
    s.height = ceil(self.count / parallels);
  } else /* AZGridStyleCompact */ {
    float d = ceil(sqrt(self.count));
    s.width = d;
    s.height = d;
  }
  
  return [AZSize sizeWithSize:s];
}

-(CGFloat)width {
  return self.size.width;
}

-(CGFloat)height {
  return self.size.height;
}

-(CGFloat)min {
  return self.size.min;
}

-(CGFloat)max {
  return self.size.max;
}

-(AZPoint *)pointAtIndex:(NSUInteger)index {
  if (self.count == 0) {
    return nil;
  }
  
  AZSize *s = self.size;
  CGFloat x, y;
  
  if (order == AZGridColumnMajorOrder) {
    // column major order
    x = floor(index / s.height);
    y = index % (int)s.height;
  } else {
    // row major order
    x = index % (int)s.width;
    y = floor(index / s.width);
  }
  
  return [AZPoint pointWithPoint:NSMakePoint(x, y)];
}

-(NSNumber *)indexAtPoint:(NSPoint)point {
  if (self.count == 0) {
    return nil;
  }
  
  AZSize *s = self.size;
  NSInteger x = floor(point.x);
  NSInteger y = floor(point.y);

  if (x < 0 || x >= s.width || y < 0 || y >= s.height) {
    return nil;
  }
  
  if (order == AZGridRowMajorOrder) {
    // left to right -> top to bottom
    return [NSNumber numberWithUnsignedInt:point.y * s.width + point.x];
  } else if (order == AZGridColumnMajorOrder) {
    // top to bottom -> left to right
    return [NSNumber numberWithUnsignedInt:point.x * s.height + point.y];
  }
  
  return nil;
}

-(id)objectAtPoint:(NSPoint)point {
  NSNumber *index = [self indexAtPoint:point];
  if (index == nil) {
    return nil;
  }
  
  return [self objectAtIndex:index.unsignedIntValue];;
}

-(NSString *)description {
  AZSize *s = self.size;
  return [NSString stringWithFormat:@"%@(%.f, %.f; %i)",
          self.className,
          s.width,
          s.height,
          self.count];
}

@end