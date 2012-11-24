//  THRect.m
//
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "AZRect.h"

//#import "AtoZ.h"


@implementation AZRect
@synthesize position, orient, anchor;

+(AZRect *)rect {
//  return [[self alloc] init];

	return [[AZRect alloc] init];
}

+(AZRect *)rectOf:(id)object {
  if (object == nil) {
    return nil;
  }
  
  AZRect *re = [[AZRect alloc] init];
  
  if ([object isKindOfClass:NSNumber.class]) {
    NSNumber *num = (NSNumber *)object;
    CGFloat f = num.floatValue;
    re->x = f;
    re->y = f;
    re->width = f;
    re->height = f;
  } else if ([object isKindOfClass:AZRect.class]) {
    AZRect *r = (AZRect *)object;
    re.rect = r.rect;
  } else if ([object isKindOfClass:AZPoint.class]) {
    AZPoint *pt = (AZPoint *)object;
    re->x = pt.x;
    re->y = pt.y;
  } else if ([object isKindOfClass:AZSize.class]) {
    AZSize *s = (AZSize *)object;
    re->width = s.width;
    re->height = s.height;
  } else if ([object isKindOfClass:NSView.class]) {
    NSView *view = (NSView *)object;
    re.rect = view.frame;
  } else if ([object isKindOfClass:CALayer.class]) {
    CALayer *l = (CALayer *)object;
    re->x = l.frame.origin.x;
    re->y = l.frame.origin.y;
    re->width = l.frame.size.width;
    re->height = l.frame.size.height;
  }
  
  return re;
}

+(AZRect *)rectWithRect:(NSRect)r {
  AZRect *re = [[self alloc] init];
  re.rect = r;
  return re;
}

+(AZRect *)rectWithOrigin:(NSPoint)origin andSize:(NSSize)size {
  return [self rectWithRect:NSMakeRect(origin.x, origin.y, size.width, size.height)];
}

+(AZRect *)rectWithX:(CGFloat)x 
                andY:(CGFloat)y 
               width:(CGFloat)width 
              height:(CGFloat)height
{
  return [self rectWithRect:NSMakeRect(x, y, width, height)];
}

+(BOOL)maybeRect:(id)object {
  if (object == nil) {
    return NO;
  }
  
  NSArray *allowedClasses = 
  @[NSNumber.class, AZRect.class, AZSize.class,
   NSView.class, CALayer.class];
  
  for (id clazz in allowedClasses) {
    if ([object isKindOfClass:clazz]) {
      return YES;
    }
  }
  
  return NO;
}

#pragma mark - Instance Methods

-(id)init {
  if ((self = super.init)) {
    x = 0;
    y = 0;
    width = 0;
    height = 0;
  }
  
  return self;
}

-(id)initWithRect:(NSRect)r {
  if ((self = self.init)) {
    x = r.origin.x;
    y = r.origin.y;
    width = r.size.width;
    height = r.size.height;
  }
  
  return self;
}

-(id)initWithSize:(NSSize)s {
  if ((self = self.init)) {
    width = s.width;
    height = s.height;
  }
  
  return self;
}

- (id) initWithFrame:(NSR)frame inFrame:(NSR)superframe {
  	if (!(self = self.init)) return nil;
	width = frame.size.width;
    height = frame.size.height;
	self.orient = AZPositionAtPerimeterInRect(frame, superframe);
	self.anchor = AZAnchorPointForPosition(self.orient);
	return self;
}

-(id)initFromPoint:(NSPoint)ptOne toPoint:(NSPoint)ptTwo {

  if ((self = self.init)) {
    x = MIN(ptOne.x, ptTwo.x);
    y = MIN(ptOne.y, ptTwo.y);
    
    width = MAX(ptOne.x, ptTwo.x) - x;
    height = MAX(ptOne.y, ptTwo.y) - y;
  }
  
  return self;
}

-(id)copy {
  id re = super.copy;
  if ([re isKindOfClass:AZRect.class]) {
    AZRect *r = (AZRect *)re;
    r.rect = self.rect;
  }
  return re;
}

-(NSString *)description {
  return [NSString stringWithFormat:@"%@(%4.f,%4.f; %4.f x %4.f)",
          self.className, x, y, width, height];
}

@synthesize width, height;

-(NSPoint)origin {
  return self.point;
}

-(void)setOrigin:(NSPoint)pt {
  x = pt.x;
  y = pt.y;
}

-(CGFloat)area {
  return width * height;
}

-(NSSize)size {
  return NSMakeSize(width, height);
}

-(void)setSize:(NSSize)s {
  width = s.width;
  height = s.height;
}

-(NSPoint)center {
  return NSMakePoint(x + width  * 0.5, 
                     y + height * 0.5);
}

-(void)setCenter:(NSPoint)pt {
  x = pt.x - width  * 0.5;
  y = pt.y - height * 0.5;
}

-(NSRect)rect {
  return NSMakeRect(x, y, width, height);
}

-(void)setRect:(NSRect)r {
  self->x = r.origin.x;
  self->y = r.origin.y;
  self->width = r.size.width;
  self->height = r.size.height;
}

-(id)insetRectWithPadding:(NSInteger)padding {
  return [[self copy] shrinkByPadding:padding];
}

-(id)shrinkBy:(id)object {
  if (object == nil) {
    return self;
  }
  
  AZRect *r = [AZRect rectOf:object];
  x += r.x;
  y += r.y;
  width  -= (r.x + r.width);
  height -= (r.y + r.height);
  
  return self;
}

-(id)shrinkByPadding:(NSInteger)padding {
  x += padding;
  y += padding;
  width  -= 2 * padding;
  height -= 2 * padding;
  
  return self;
}

-(id)shrinkBySizePadding:(NSSize)padding {
  x += padding.width;
  y += padding.height;
  width  -= 2 * padding.width;
  height -= 2 * padding.height;
  
  return self;
}

-(id)growBy:(id)object {
  if (object == nil) {
    return self;
  }
  
  AZRect *padding = [AZRect rectOf:object];
  
  x -= padding.x;
  y -= padding.y;
  width  += (padding.x + padding.width);
  height += (padding.y + padding.height);
  
  return self;
}

-(id)growByPadding:(NSInteger)padding {
  return [self shrinkByPadding:-padding];
}

-(id)growBySizePadding:(NSSize)padding {
  x -= padding.width;
  y -= padding.height;
  width  += 2 * padding.width;
  height += 2 * padding.height;
  
  return self;
}

-(BOOL)equals:(id)object {
  if (object == nil) {
    return NO;
  }
  
  AZRect *compare = [AZRect rectOf:object];
  
  return 
    compare->x == self->x 
    && compare->y == self->y
    && compare->width == self->width
    && compare->height == self->height
  ;
}

-(BOOL)contains:(id)object {
  if (object == nil) {
    return NO;
  }
  
  if ([AZRect maybeRect:object]) {
    return [self containsRect:[AZRect rectOf:object].rect];
  } else if ([AZPoint maybePoint:object]) {
    return [self containsPoint:[AZPoint pointOf:object].point];
  }
  
  return NO;
}

-(BOOL)containsPoint:(NSPoint)pt {
  return 
    self->x <= pt.x 
    && self->x + self->width >= pt.x
    && self->y <= pt.y 
    && self->y + self->height >= pt.y
  ;
}

-(BOOL)containsRect:(NSRect)r {
  return 
    self->x <= r.origin.x 
    && self->y <= r.origin.y 
    && self->width >= r.size.height 
    && self->height >= r.size.height
  ;
}

// graphing
-(void)drawFrame {
  NSFrameRect(self.rect);
}

-(void)fill {
  NSRectFill(self.rect);
}

-(id)centerOn:(id)bounds {
  return [self moveTo:AZPoint.halfPoint ofRect:bounds];
}

-(id)moveTo:(id)point ofRect:(id)bounds {
  AZPoint *pt = [AZPoint pointOf:point];
  AZRect  *br = [AZRect rectOf:bounds];
  
  if (!br.area) {
    return self;
  }
  
  if (0 < pt.x && pt.x <= 1) {
    self->x = br.x + (br.width - width) * pt.x;
  } else {
    self->x = br.x + pt.x;
  }
  
  if (0 < pt.y && pt.y <= 1) {
    self->y = br.y + (br.height - height) * pt.y;
  } else {
    self->y = br.y + pt.y;
  }
  
  return self;
}

-(id)sizeTo:(id)point ofRect:(id)bounds {
  AZPoint *pt = [AZPoint pointOf:point];
  AZRect  *br = [AZRect rectOf:bounds];
  
  if (!br.area) {
    return self;
  }
  
  if (0 < pt.x && pt.x <= 1) {
    self->width = br.width * pt.x;
  } else if (pt.x < 0) {
    self->width = br.width - pt.x;
  }
  
  if (0 < pt.y && pt.y <= 1) {
    self->height = br.height * pt.y;
  } else if (pt.y < 0) {
    self->height = br.height - pt.y;
  }
  
  return self;
}

@end
