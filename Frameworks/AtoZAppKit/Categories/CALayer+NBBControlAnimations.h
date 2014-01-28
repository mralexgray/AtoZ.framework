/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <QuartzCore/QuartzCore.h>

static NSString * const kNBBJiggleTransformAnimation = @"NBBJiggleTransformAnimation";
static NSString * const kNBBJiggleTransformTranslationXAnimation = @"NBBJiggleTransformTranslationXAnimation";

@interface CALayer (NBBControlAnimations)
- (void)startJiggling;
- (void)stopJiggling;
@end
