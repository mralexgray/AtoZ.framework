/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <Cocoa/Cocoa.h>
#import "NBBSwappableControl.h"

// maybe ununsed?  moved here to eliminate a set of files....
@interface NBBKeyboardKeyCell : NSActionCell
@end
@interface NBBVirtualKeyboard
@end

/*
 This category will implement most of the NBBSwappableControl protocol
 since the same code will apply to ALL	action cells
 
 We will use iOS style icon "jiggling".
 Touch and hold a swappable control to cause it and all COMPATIBLE swappable controls to jiggle
 While jiggling you may drag a control onto another jiggling control to initiate a swap
 */

@interface NSActionCell (NBBSwappable) <NBBSwappableControl, NSDraggingSource, NSDraggingDestination>
@property (nonatomic, retain) id <NBBSwappableControlDelegate> swapDelegate;

- (void)setSwappingEnabled:(BOOL) enable;
- (BOOL)swappingEnabled;
- (void)swapStateChanged:(NSNotification*) notification;
@end
