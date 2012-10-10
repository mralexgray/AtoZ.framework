/**
 
 \category  CATransaction(NoAnimation)
 
 \brief     Makes it a little easier, cleaner and safer to write Core Animation
            transaction with disabled animations.
 
 \author    Eric Methot
 \date      2012-04-10
 
 \copyright Copyright 2011 NUascent Sàrl. All rights reserved.
 
 */

#import <QuartzCore/QuartzCore.h>

@interface CATransaction (NoAnimationTransaction)

/**
 
 withDisabledAnimation
 
 \brief   starts a transaction and disables actions before calling the block.
          The transaction is commited when the block returns.
 
 \details The method is functionally equivalent to this code:
 
          [CATransaction begin];
          [CATransaction setDisableActions:YES];
 
          block();
 
          [CATransaction commit];
 
 */
+ (void) withDisabledAnimation:(void(^)(void)) block;

/**
 
 withAnimationDuration:
 
 \brief     starts a transaction that will animate for `time` seconds.
 
 \details   The method is functionally equivalent to this code:
 
            [CATransaction begin];
            [CATransaction setValue:[NSNumber numberWithFloat:time] forKey:kCATransactionAnimationDuration];
             
            block();
             
            [CATransaction commit];
 */
+ (void) withAnimationDuration:(float)time andBlock:(void(^)(void))block;

@end
