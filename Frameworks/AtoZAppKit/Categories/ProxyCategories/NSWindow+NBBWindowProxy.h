/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2013 Brad Allred
 *

 */

#import <AppKit/AppKit.h>

@class NBBTheme;

@interface NSWindow (NBBWindowProxy)
+ (id)allocWithZone:(NSZone *)zone;

- (NBBTheme*) theme; // part of NBBThemable protocol
@end
