/**
 
 \brief     A that vertically stacks its subviews.
 
 \details   Subviews of a NUStackedView are vertically stacked with and may
            have additional padding between them.
 
 */
#import <Cocoa/Cocoa.h>
#import "NUDelegatingView.h"

@interface NUStackedView : NUDelegatingView
@property (assign) double rowSpacing;
@end
