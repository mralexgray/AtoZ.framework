
#import <QuartzCore/QuartzCore.h>

@interface CAKeyframeAnimation (NUExtensions)
/// Ensures that there is a keyTime zeroTime and 1.
- (void) normalizeKeytimesAndValuesWithZeroTime:(double)zeroTime;
@end
