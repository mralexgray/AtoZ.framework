
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
//- _Void_ setObject:_  forKeyedSubscript:(id<NSCopying>)k {
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

- _Void_ setObject:x forKeyedSubscript: _Copy_ k { [self setValue:x forKey:(id)k]; }

- objectForKeyedSubscript:x { return [self valueForKey:x]; }

+ objectForKeyedSubscript: _Copy_ x { NSUInteger loc = [(id)x rangeOfString:@"."].location;

  NSString *path = loc == NSNotFound ? nil : [(id)x substringFromIndex:loc+1],
            *sel = path ? [(id)x substringToIndex:loc] : (id)x;

  NSLog(@"resolving %@ selector:%@", NSStringFromClass(self), sel);

  id (*sender)(id, SEL) = (void*)objc_msgSend;

  id z = [self respondsToSelector:NSSelectorFromString(sel)] ? sender(self, NSSelectorFromString(sel)) : nil;
  return path && z ? [z valueForKeyPath:path] : z ? z : nil;
}

+ (void) setObject:__  forKeyedSubscript:(id<NSCopying>)k {

  if (![self respondsToSelector:NSSelectorFromString((id)k)]) return;

  ((void(*)(id, SEL,id))objc_msgSend)(self, NSSelectorFromString((id)k),__);
}

@end

@implementation NSUserDefaults (SubscriptAndUnescape)

- objectForKeyedSubscript: _Copy_ k{ id obj = [self oFK:(id)k];

  return ISA(obj,NSS) && [obj hasPrefix:@"\\"] ? [obj substringFromIndex:1] : obj;
}

@end


