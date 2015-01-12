/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import <AppKit/AppKit.h>
#import "NBBThemable.h"

@interface NBBTableView : NSTableView <NBBThemable>
{
	@private
	NSAnimation* _scrollAnimation;
	CGFloat _scrollDelta;
}
# pragma mark - NBBThemable
- (id) initWithTheme:(NBBTheme*) theme;
- (BOOL)applyTheme:(NBBTheme*) theme;
@end
