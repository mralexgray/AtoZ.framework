
#import "AZPoint.h"
#import "AZSize.h"
#import "AZRect.h"
#import "AtoZ.h"

@implementation AZPoint // @synthesize  x = _x, y = _y;

#pragma mark statics

//- (id) initWithCoder:(NSCoder *)aDecoder {  self = [super initWithCoder:aDecoder];
//  for (id key in self.class.codableProperties.allKeys) [self setValue:[aDecoder valueForKey:key] forKey:key];
//  return self;
//}
//- (void) encodeWithCoder:(NSCoder *)aCoder {  [super encodeWithCoder:aCoder];
//  for (id key in self.class.codableProperties.allKeys)  [aCoder encodeObject:[self vFK:key] forKey:key];
//}
//- (id) init  { SUPERINIT;
//
//  [self addKVOBlockForKeyPath:@"point" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld handler:^(NSString *keyPath, id object, NSDictionary *change) {
//    
//    KVOChange k;  if ((k = [object onMove])) k(change[@"old"],change[@"new"]);//AZSubtractPoints([change pointForKey:@"old"],[change pointForKey:@"new"]));
//  }];
//  return self;
//}
+ (INST) point { return self.class.new; }

+ (INST) pointOf:(id)obj {

	AZPoint *re = self.class.new;
	
	if (!obj) return re;
  objswitch(obj)
  objkind(NSN)
    re.x = [(NSN*)obj fV];  re.y = [(NSN*)obj fV];
	objkind(AZPoint)
    re = [(AZPoint*)obj copy];
    objkind(AZSize)
      re.x = [(AZSize*)obj width];	re.y = [(AZSize*)obj height];
    objkind(NSView)
      re.x = [(NSV*)obj frameMinX];	re.y = [(NSV*)obj frameMinY];
    objkind(CALayer)
      re.x = [(CAL*)obj frameMinX];	re.y = [(CAL*)obj frameMinY];
	 objkind(NSE)
      re.x = [(NSE*)obj locationInWindow].x;	re.y = [(NSE*)obj locationInWindow].y;
  endswitch
	return re;
}

+ (INST) pointWithX:(CGF)xv y:(CGF)yv {
	return [self.class.alloc initWithX:xv y:yv];
}

+ (INST) pointWithPoint:(NSP)pt {
	return [self.class.alloc initWithPoint:pt];
}

+ (INST) halfPoint {
	return [self.class pointWithX:0.5 y:0.5];
}

+ (BOOL)maybePoint:(id) object {  if (!object) return NO;

	for (id clazz in @[NSN.class, AZPoint.class, AZSize.class, NSV.class, CAL.class, NSE.class]) if ([object isKindOfClass:clazz]) return YES;
	return NO;
}

#pragma mark initializer


-   (id)     initWithX:(CGF)xv
                     y:(CGF)yv { return  self = [self init] ? _x = xv, _y = yv, self : nil; 	}
-   (id) initWithPoint:(NSP)pt { return [self initWithX:pt.x y:pt.y]; }
- (INST) copy { return [self.class.alloc initWithX:_x y:_y]; }
- (INST) copyWithZone:(NSZone*) zone { return [[self.class allocWithZone:zone] initWithX:_x y:_y]; }

#pragma mark properties

-  (NSP)    point         { return NSMakePoint(_x, _y); }
- (void) setPoint:(NSP)pt {
	self.x = pt.x;
	self.y = pt.y;
}
-  (CGF) min { return MIN(_x,_y); }
-  (CGF) max { return MAX(_x,_y); }

+ (NSSet*) keyPathsForValuesAffectingValueForKey:(NSS*)k {

  objswitch(k)
    objcase(@"max", @"min") return NSSET(@"x", @"y", @"point");
    objcase(@"x", @"y")     return NSSET(@"point");
    objcase(@"point")       return NSSET(@"x", @"y");
    defaultcase             return [super keyPathsForValuesAffectingValueForKey:k];
  endswitch
}
#pragma mark methods

- (INST) swap {
	CGF t = _x;
	self.x = _y;
	self.y = t;
	return self;
}
- (INST) negate {
	self.x = -_x;
	self.y = -_y;
	return self;
}
- (INST) invert {
	self.x = 1 / _x;
	self.y = 1 / _y;
	return self;
}
- (INST) floor {
	self.x = floor(_x);
	self.y = floor(_y);
	
	return self;
}
- (INST) round {
	self.x = round(_x);
	self.y = round(_y);
	
	return self;
}
- (INST) ceil {
	self.x = ceil(_x);
	self.y = ceil(_y);
	
	return self;
}
- (INST) square {
	self.x *= _x;
	self.y *= _y;
	
	return self;
}
- (INST) root {
	self.x = sqrt(_x);
	self.y = sqrt(_y);
	
	return self;
}
- (INST) ratio {
	CGF max = MAX(_x, _y);
	CGF min = MIN(_x, _y);
	if (min < 0 && -min > max) {
	max = -min;
	}
	
	if (max != 0) {
	self.x /= max;
	self.y /= max;
	}
	
	return self;
}

- (INST) moveTo:(id) object { if (!object) return self;
 	self.x = 0;
	self.y = 0;
	
	return [self moveBy:object];
}
- (INST) moveTowards:(id) object withDistance:(CGF)relativeDistance {
	return [self moveTowardsPoint:[[self.class pointOf:object]point] withDistance:relativeDistance];
}
- (INST) moveTowardsPoint:(NSP)pt withDistance:(CGF)relativeDistance {
	NSP delta = NSMakePoint((self.x - pt.x) * relativeDistance, (self.y - pt.y) * relativeDistance);
	return [self moveByPoint:delta];
}
- (INST) moveBy:(id) object {
	if (object == nil) {
	return self;
	}
	
	AZPoint *p = [AZPoint pointOf:object];
	self.x += p.x;
	self.y += p.y;                            return self;
}
- (INST) moveByNegative:(id) object {
	if (object == nil)                        return self;
  AZPoint *p = [AZPoint pointOf:object];
	self.x -= p.x;
	self.y -= p.y;                            return self;
}
- (INST) moveByPoint:(NSP)pt {
	self.x += pt.x;
	self.y += pt.y;                           return self;
}
- (INST) moveByX:(CGF)xv andY:(CGF)yv {
	self.x += xv;
	self.y += yv;                             return self;
}

- (INST) multiplyBy:(id) object {
	if (object == nil)                        return self;
  AZPoint *p = [AZPoint pointOf:object];
	self.x *= p.x;
	self.y *= p.y;                            return self;
}
- (INST) divideBy:(id) object {
	if (!object)                              return self;
	AZPoint *p = [self.class pointOf:object];
	self.x /= p.x;
	self.y /= p.y;                            return self;
}

- (BOOL)isEqual:(id)object { return [self equals:object]; }
- (BOOL)equals:(id) object { AZPoint *p; return !object ? NO : ((p = [AZPoint pointOf:object])) ? _x == p.x && _y == p.y : NO; }
- (BOOL)equalsPoint:(NSP)p { return self.x == p.x && self.y == p.y; }

- (BOOL)isWithin:(id) object {
	if (!object)                              return NO;
	AZRect *rect = [AZRect rectOf:object];
	return [rect contaiNSP:self.point];
}

- (NSString*) description {
	return [NSString stringWithFormat:@"%@(%4.f,%4.f)", self.className, _x, _y];
}

@end
