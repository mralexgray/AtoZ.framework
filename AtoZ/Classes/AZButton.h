
#import "AtoZUmbrella.h"

@interface AZButtonCell : NSButtonCell
@property (nonatomic) NSColor *color;
@property BOOL isTopTab;
@end
@interface AZButton : NSButton
typedef void (^AZButtonCallback)();

/// Set the callback block to be called when the mouse **enters** the button.
- (void)setInCallback:(AZButtonCallback)block;

/// Set the callback block to be called when the mouse **exits** the button.
- (void)setOutCallback:(AZButtonCallback)block;

/// Set both the **enter* and **exit** callback blocks.
- (void)setInCallback:(AZButtonCallback)inBlock
	   andOutCallback:(AZButtonCallback)outBlock;
@end
