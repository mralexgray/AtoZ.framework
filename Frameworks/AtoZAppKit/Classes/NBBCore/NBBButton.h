/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <Cocoa/Cocoa.h>
#import "NBBTheme.h"

@interface NBBButtonCell : NSButtonCell

@end

@interface NBBButton : NSButton <NBBThemable>
# pragma mark - NBBThemable
- (id) initWithTheme:(NBBTheme*) theme;
- (BOOL)applyTheme:(NBBTheme*) theme;
@end
