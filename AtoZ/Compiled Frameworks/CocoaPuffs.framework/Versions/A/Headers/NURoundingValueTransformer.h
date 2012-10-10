
#import <Foundation/Foundation.h>

@interface NURoundingValueTransformer : NSValueTransformer

@property (assign) double rounding;
@property (assign) double multiplier;
@property (assign) double constant;

- (id) initWithRoundingFactor:(double)aRounding
                   multiplier:(double)aMultiplier
                     constant:(double)aConstant
;

@end
