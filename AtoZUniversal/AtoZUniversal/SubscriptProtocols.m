
#import <AtoZUniversal/AtoZUniversal.h>

//@concreteprotocol(KeyGet)
//
//- objectForKeyedSubscript:_ { return
//
//  [self respondsToSelector:@selector(objectForKey:)] ? [(id)self objectForKey:_] : [self valueForKey:_];
//}
//
//@end

//@concreteprotocol(KeySet)
//
//- (void) setObject:_  forKeyedSubscript:(id<NSCopying>)k {
//
//  [self respondsToSelector:@selector(setObject:forKey:)] ? [(id)self setObject:_ forKey:k]
//                                                         : [self  setValue:_ forKey:k];
//}
//
//@end

//@concreteprotocol(ClassKeyGet)


//@end

//@concreteprotocol(ClassKeySet)


//@end

@implementation NSObject (KeySub)

- (void) setObject:x forKeyedSubscript:(CopyObject)k { [self setValue:x forKey:(id)k]; }

- objectForKeyedSubscript:x { return [self valueForKey:x]; }

+ objectForKeyedSubscript:x { NSUInteger loc = [x rangeOfString:@"."].location;

  NSString *path = loc == NSNotFound ? nil : [x substringFromIndex:loc+1],
            *sel = path ? [x substringToIndex:loc] : x;

  NSLog(@"resolving %@ selector:%@", NSStringFromClass(self), sel);

  id (*sender)(id, SEL) = (void*)objc_msgSend;

  id z = [self respondsToSelector:NSSelectorFromString(sel)] ? sender(self, NSSelectorFromString(sel)) : nil;
  return path && z ? [z valueForKeyPath:path] : z ? z : nil;
}

+ (void) setObject:_  forKeyedSubscript:(id<NSCopying>)k {

  if (![self respondsToSelector:NSSelectorFromString((id)k)]) return;

  ((void(*)(id, SEL,id))objc_msgSend)(self, NSSelectorFromString((id)k),_);
}

@end

