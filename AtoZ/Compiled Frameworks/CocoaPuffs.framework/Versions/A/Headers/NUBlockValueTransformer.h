
#import <Foundation/Foundation.h>

typedef id (^NUBlockValueTransformerBlock)(id value);

@interface NUBlockValueTransformer : NSValueTransformer

- (id) initWithBlock:(NUBlockValueTransformerBlock)block;
+ (id) transformerWithBlock:(NUBlockValueTransformerBlock)block;

@property (copy) NUBlockValueTransformerBlock transformBlock;
@property (copy) NUBlockValueTransformerBlock reverseBlock;

@end
