
#import "SubscriptProtocols.h"


#import <objc/message.h>

@implementation NSObject (ClassSubscriptable)

+ objectForKeyedSubscript:x { NSUInteger loc = [x rangeOfString:@"."].location;

  NSString *path = loc == NSNotFound ? nil : [x substringFromIndex:loc+1],
            *sel = path ? [x substringToIndex:loc] : x;

  NSLog(@"resolving %@ selector:%@", NSStringFromClass(self), sel);

  id (*sender)(id, SEL) = (void*)objc_msgSend;

  id z = [self respondsToSelector:NSSelectorFromString(sel)] ? sender(self, NSSelectorFromString(sel)) : nil;
  return path && z ? [z valueForKeyPath:path] : z ? z : nil;
}

- (void) setObject:x forKeyedSubscript:(id<NSCopying>)k { [self setValue:x forKey:(NSString*)k]; }
- objectForKeyedSubscript:x { return [self valueForKey:x]; }

@end
