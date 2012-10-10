
#import <Foundation/Foundation.h>

@interface NSData (NUExtensions)

+ (id) rampWithUInt64StartingAt:(uint64_t)x increment:(uint64_t)dx count:(uint64_t)n;
+ (id) rampWithUInt64StartingAt:(uint64_t)x increment:(uint64_t)dx count:(uint64_t)n reverseOrder:(BOOL)reverse;

- (NSString*) asciiArtOfWidth:(int)w andHeight:(int)h;

@end
