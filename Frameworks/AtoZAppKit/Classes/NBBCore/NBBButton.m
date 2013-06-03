/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import "NBBButton.h"

@implementation NBBButtonCell

@end

@implementation NBBButton
@dynamic theme;

+ (void)initialize
{
	// force custom button cell class
	[self setCellClass:[NBBButtonCell class]];
}

# pragma mark - Initializers
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

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if (![[self cell] isKindOfClass:[NBBButtonCell class]])
		{
			// TODO: force custom button cell class for NIB archived buttons
		}
    }
    return self;
}

- (BOOL)applyTheme:(NBBTheme*) theme
{
	self.font = [theme normalFont];
	NSAttributedString* title = [[NSAttributedString alloc] initWithString:self.title
																attributes:[theme cellTextAttributes]];

	self.attributedTitle = title;
//	[title release];
	return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
	[super drawRect:dirtyRect];
}

@end
