
//  THPoint.h   Lumumba Framework  Created by Benjamin Schüttler on 28.09.09.  Copyright 2011 Rogue Coding. All rights reserved.

#import "AtoZUmbrella.h"


@interface AZPoint (Methods)

+ (INST)          point;
+ (INST)      halfPoint;
+ (INST)        pointOf:(id)obj;
+ (INST)     pointWithX:(CGF)x
                      y:(CGF)y;
+ (INST) pointWithPoint:(NSP)p;

+ (BOOL)     maybePoint:(id)x;

- (id)    initWithPoint:(NSP)p;
- (id)        initWithX:(CGF)x
                      y:(CGF)y;

- (INST)           moveTo:(id)x;
- (INST)      moveTowards:(id)x
             withDistance:(CGF)relativeDist;
- (INST) moveTowardsPoint:(NSP)p
             withDistance:(CGF)relativeDist;
- (INST)           moveBy:(id)x;
- (INST)      moveByPoint:(NSP)p;
- (INST)          moveByX:(CGF)x
                     andY:(CGF)y;
- (INST)   moveByNegative:(id)x;
- (INST)       multiplyBy:(id)x;
- (INST)         divideBy:(id)x;

@property (RONLY) AZPoint *swapped, *negated, *inverted, *floored, *ceiled, *squared, *rooted;

- (BOOL)     equals:(id)x;
- (BOOL)equalsPoint:(NSP)p;
- (BOOL)   isWithin:(id)x;

//- (INST) swap;
//- (INST) negate;
//- (INST) invert;
//- (INST) floor;
//- (INST) round;
//- (INST) ceil;
//- (INST) square;
//- (INST) root;
//- (INST) ratio;


@end
