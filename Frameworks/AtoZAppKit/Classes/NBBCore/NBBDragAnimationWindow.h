/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <Cocoa/Cocoa.h>

#import "NBBWindowBase.h"

@interface NBBDragAnimationWindow : NBBWindowBase
@property(readonly, nonatomic) NSView* representedView;

+ (NBBDragAnimationWindow*)sharedAnimationWindow;

- (void)setupDragAnimationWith:(NSView*)view usingDragImage:(NSImage*)image;
- (void)animateToFrame:(NSRect)frame;
@end
