
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface NULayerCoordinateValueTransformer : NSValueTransformer
- (id) initWithSourceLayer:(CALayer*)aLayer andTargetLayer:(CALayer*)bLayer;
+ (id) transformerWithSourceLayer:(CALayer*)aLayer andTargetLayer:(CALayer*)bLayer;
@end
