/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <AppKit/AppKit.h>

@class NBBTheme;

/*
This category exists to intercept alloc calls for controls adopting the NBBThemable protocol.
The goal is to allocate and return overriding theme specific subclasses instead
*/

@interface NSControl (NBBControlProxy)
+ (id)allocWithZone:(NSZone *)zone;
- (void)viewWillMoveToWindow:(NSWindow *)newWindow;

- (NBBTheme*) theme; // part of NBBThemable protocol

- (NSDraggingSession*)beginDraggingSessionWithDraggingCell:(NSCell <NSDraggingSource> *)cell event:(NSEvent*) theEvent;
- (NSImage*)imageForCell:(NSCell*)cell;
- (NSImage*)imageForCell:(NSCell*)cell highlighted:(BOOL) highlight;
- (NSRect)frameForCell:(NSCell*)cell;
@end
