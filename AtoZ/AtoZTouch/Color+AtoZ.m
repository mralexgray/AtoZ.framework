
#import "Color+AtoZ.h"

@implementation UIColor (AtoZ)

+ (UIColor*) r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a {

#if TARGET_OS_IPHONE
 return [self colorWithRed:r green:g blue:b alpha:a];
#else
 return [self colorWithDeviceRed:r green:g blue:b alpha:a];
#endif
}

@end
