/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import "NBBSlider.h"

@implementation NBBSlider
@dynamic theme;

# pragma mark - NBBThemable
- (id)initWithTheme:(NBBTheme*) theme
{
	CGRect frame = {}; // TODO: implement a way to get frame from theme
	self = [self initWithFrame:frame]; // initWithFrame is the designated initializer for NSControl
	if (self) {
		// special theme initialization will go here
		// could just call applyTheme
	}
	return self;
}

- (BOOL)applyTheme:(NBBTheme*) theme
{
	return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

@end
