/**
 
 \brief     Container to three subviews one of which is a splitbar.
 
 \details   Instead of having a thin splitter, the splitter is a subview
            that can have controls on it. The above and below views are
            resized accordingly.
 
 */
#import <Cocoa/Cocoa.h>

@class NUDelegatingView;

@interface NUSplitbarView : NSView

@property (assign,nonatomic) IBOutlet NSView *aboveView;
@property (assign,nonatomic) IBOutlet NUDelegatingView *barView;
@property (assign,nonatomic) IBOutlet NSView *belowView;

@property (assign) BOOL belowViewIsCollapsed;

/**
 
 \brief     Sets the new bar position and resizes the other views accordingly.
 
 */
- (void) resizeViewsWithBarPosition:(CGFloat)position;

@end
