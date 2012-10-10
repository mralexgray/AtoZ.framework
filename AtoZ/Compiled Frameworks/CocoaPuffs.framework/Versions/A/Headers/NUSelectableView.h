/**
 
 \brief     A view whose unique subview can be bound.
 
 \details   Setting the contentView of a NUSelectableView will remove any
            existing subview and replace it with the new contentView, which
            will have been resized to fit the entire bounds of its superview.  
            
            The typical use case would bind contentView to an array controllers
            `selection.view` so that when the selection changes so does
            the contentView.
 
 */
#import <Cocoa/Cocoa.h>
#import "NUDelegatingView.h"


@interface NUSelectableView : NUDelegatingView<NSDraggingDestination>
@property (retain,nonatomic) NSView *contentView;
@end
