
#import "MutableGeometry.h"

@concreteprotocol(SSGeo) @dynamic grouping;
- (void) beginGroup  { [self setValue:@YES forKey:@"grouping"]; }
- (void) commitGroup { [self setValue:@NO forKey:@"grouping"];  [self notifyReceiver]; }
@end

@implementation SSPoint

- (id)initWithReceiver:(id)inReceiver key:(NSString *)inKey
{
  if ((self = [super init])) {
    receiver = inReceiver;
    key = [inKey copy];

    NSValue *value = [inReceiver valueForKey:inKey];
    if ([value isKindOfClass:[NSValue class]]) {
      if (strcmp([value objCType], @encode(NSCGPoint)) == 0) {
        objCType = @encode(NSCGPoint);
        NSCGPoint buffer;
        [value getValue:&buffer];
        x = buffer.x;
        y = buffer.y;
      }
    }
  }

  return self;
}

- (id)initWithRect:(SSRect *)inRect
{
  if ((self == [super init])) {
    rect = inRect;
    x = rect.x;
    y = rect.y;
  }

  return self;
}

- (void)notifyReceiver
{
  if (!grouping) {
    if (rect) {
      [rect beginGroup];
      rect.x = x;
      rect.y = y;
      [rect commitGroup];
    } else if (objCType && strcmp(objCType, @encode(NSCGPoint)) == 0) {
      NSValue *value = [NSValue valueWithNSCGPoint:NSCGPointMake(x, y)];
      [receiver setValue:value forKey:key];
    }
  }
}

- (CGFloat)x { return x; }
- (void)setX:(CGFloat)inX { x = inX; [self notifyReceiver]; }

- (CGFloat)y { return y; }
- (void)setY:(CGFloat)inY { y = inY; [self notifyReceiver]; }

@end


@implementation SSSize

- (id)initWithReceiver:(id)inReceiver key:(NSString *)inKey
{
  if ((self = [super init])) {
    receiver = inReceiver;
    key = [inKey copy];

    NSValue *value = [inReceiver valueForKey:inKey];
    if ([value isKindOfClass:[NSValue class]]) {
      if (strcmp([value objCType], @encode(NSCGSize)) == 0) {
        objCType = @encode(NSCGSize);
        NSCGSize buffer;
        [value getValue:&buffer];
        width = buffer.width;
        height = buffer.height;
      }
    }
  }

  return self;
}

- (id)initWithRect:(SSRect *)inRect
{
  if (self != [super init]) return nil;
  rect = inRect;
  width = rect.width;
  height = rect.height;
  return self;
}

- (void)notifyReceiver
{
  if (!grouping) {
    if (rect) {
      [rect beginGroup];
      rect.width = width;
      rect.height = height;
      [rect commitGroup];
    } else if (objCType && strcmp(objCType, @encode(NSCGSize)) == 0) {
      NSValue *value = [NSValue valueWithNSCGSize:NSCGSizeMake(width, height)];
      [receiver setValue:value forKey:key];
    }
  }
}

- (CGFloat)width { return width; }
- (void)setWidth:(CGFloat)inWidth { width = inWidth; [self notifyReceiver]; }

- (CGFloat)height { return height; }
- (void)setHeight:(CGFloat)inHeight { height = inHeight; [self notifyReceiver]; }

@end



@implementation SSRect

- (id)initWithReceiver:(id)inReceiver key:(NSString *)inKey
{
  if (!(self = super.init)) return nil;
  receiver = inReceiver;
  key = [inKey copy];

  NSValue *value = [inReceiver valueForKey:inKey];
  if ([value isKindOfClass:[NSValue class]]) {
    if (strcmp([value objCType], @encode(NSCGRect)) == 0) {
      objCType = @encode(NSCGRect);
      NSCGRect buffer;
      [value getValue:&buffer];
      x = buffer.origin.x;
      y = buffer.origin.y;
      width = buffer.size.width;
      height = buffer.size.height;
    }
  }
  return self;
}

- (void)notifyReceiver
{
  if (!grouping && objCType && strcmp(objCType, @encode(NSCGRect)) == 0) {
    NSValue *value = [NSValue valueWithNSCGRect:NSCGRectMake(x, y, width, height)];
    [receiver setValue:value forKey:key];
  }
}

- (CGFloat)x { return x; }
- (void)setX:(CGFloat)inX { x = inX; [self notifyReceiver]; }

- (CGFloat)y { return y; }
- (void)setY:(CGFloat)inY { y = inY; [self notifyReceiver]; }

- (CGFloat)width { return width; }
- (void)setWidth:(CGFloat)inWidth { width = inWidth; [self notifyReceiver]; }

- (CGFloat)height { return height; }
- (void)setHeight:(CGFloat)inHeight { height = inHeight; [self notifyReceiver]; }

- (NSCGPoint)origin { return NSCGPointMake(x, y); }
- (void)setOrigin:(NSCGPoint)inOrigin { x = inOrigin.x; y = inOrigin.y; [self notifyReceiver]; }

- (NSCGSize)size { return NSCGSizeMake(width, height); }
- (void)setSize:(NSCGSize)inSize { width = inSize.width; height = inSize.height; [self notifyReceiver]; }


- (SSPoint *)mutableOrigin
{
  return [SSPoint.alloc initWithRect:self];
}

- (SSSize *)mutableSize
{
  return [SSSize.alloc initWithRect:self];
}

@end


@implementation NSObject (SSGeometry)

- (void) setGeoValuesForKey:(NSString*)key, ... {

  NSO* c = [self mutableGeoValueForKey:key];
  va_list list; va_start(list,key);
  id numOrString = nil;
  while ((numOrString = va_arg(list,id))) {

    NSS* key = nil;
    NSN* val = [numOrString isKindOfClass:NSString.class] ? nil : numOrString;
    if (!val) { key = numOrString; val = va_arg(list, NSN*); }
    else { key = va_arg(list, NSS*); }
    [c setValue:val forKey:key];
  }
  va_end(list);
}

- (NSObject<SSGeo>*) mutableGeoValueForKey:(NSString*)key {

  NSVAL*c = [self vFK:key]; const char *t = [c objCType];

  return !strcmp(t, @encode(NSR)) ? [self mutableRectValueForKey:key] :
         !strcmp(t, @encode(NSSZ)) ? [self mutableSizeValueForKey:key] :
         !strcmp(t, @encode(NSP)) ? [self mutablePointValueForKey:key] : nil;
}
- (SSSize*)mutableSizeValueForKey:(NSString *)key {
  return [SSSize.alloc initWithReceiver:self key:key];
}
- (SSPoint *)mutablePointValueForKey:(NSString *)key
{
  return [SSPoint.alloc initWithReceiver:self key:key];
}
- (SSRect *)mutableRectValueForKey:(NSString *)key
{
  return [SSRect.alloc initWithReceiver:self key:key];
}

@end


@implementation NSValue (SSGeometryCompatibility)

+ (id)valueWithNSCGRect:(NSCGRect)inRect
{
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
  return [self valueWithCGRect:inRect];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
  return [self valueWithRect:inRect];
#endif
}

+ (id)valueWithNSCGSize:(NSCGSize)inSize
{
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
  return [self valueWithCGSize:inSize];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
  return [self valueWithSize:inSize];
#endif
}

+ (id)valueWithNSCGPoint:(NSCGPoint)inPoint;
{
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED
  return [self valueWithCGPoint:inPoint];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
  return [self valueWithPoint:inPoint];
#endif
}

@end
