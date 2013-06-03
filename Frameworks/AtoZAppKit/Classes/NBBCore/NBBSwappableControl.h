/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <Foundation/Foundation.h>

@protocol NBBSwappableControlDelegate;

@protocol NBBSwappableControl <NSObject, NSDraggingDestination, NSDraggingSource>
@property (nonatomic, retain) IBOutlet id <NBBSwappableControlDelegate> swapDelegate;

- (BOOL)swappingEnabled;
- (void)setSwappingEnabled:(BOOL) enable;
@end

@protocol NBBSwappableControlDelegate <NSObject>
- (BOOL)controlAllowedToSwap:(NSControl <NBBSwappableControl> *) control;
@end
