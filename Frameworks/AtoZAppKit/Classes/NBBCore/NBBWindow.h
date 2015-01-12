/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <AppKit/AppKit.h>

#import "NBBWindowBase.h"

@interface NBBWindow : NBBWindowBase <NBBThemable>
{
	// dummy values needed for KVC
	id _NSAnimationTriggerOrderIn;
	id _NSAnimationTriggerOrderOut;
}
# pragma mark - NBBThemable
- (id) initWithTheme:(NBBTheme*) theme;
- (BOOL)applyTheme:(NBBTheme*) theme;
@end
