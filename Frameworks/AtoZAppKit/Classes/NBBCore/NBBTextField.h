/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <AppKit/AppKit.h>
#import "NBBThemable.h"

@interface NBBTextField : NSTextField <NBBThemable>
# pragma mark - NBBThemable
- (id) initWithTheme:(NBBTheme*) theme;
- (BOOL)applyTheme:(NBBTheme*) theme;
@end
