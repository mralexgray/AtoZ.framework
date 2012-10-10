/**
 
 \brief     NUViewDelegate is an informal protocol used by NUDelegatingView 
            to communicate with its delegate. NUDelegatingView will forward 
            mouse, drag & drop and drawing methods to its delegate only if 
            the corresponding delegate method is implemented.
 
 */
#import <Cocoa/Cocoa.h>

@protocol NUViewDelegate
@optional

// Mouse Events & Cursors
- (void) view:(NSView*)aView mouseDown:(NSEvent*)theEvent;
- (void) view:(NSView*)aView mouseDragged:(NSEvent*)theEvent;
- (void) view:(NSView*)aView mouseUp:(NSEvent*)theEvent;
- (void) view:(NSView*)aView mouseEntered:(NSEvent*)theEvent;
- (void) view:(NSView*)aView mouseExited:(NSEvent*)theEvent;
- (void) viewResetCursorRects:(NSView*)aView;

// Methods for Dragging
- (NSDragOperation)view:(NSView*)aView draggingEntered:(id <NSDraggingInfo>)sender;
- (NSDragOperation)view:(NSView*)aView draggingUpdated:(id <NSDraggingInfo>)sender;
- (void)view:(NSView*)aView draggingExited:(id <NSDraggingInfo>)sender;
- (BOOL)view:(NSView*)aView prepareForDragOperation:(id <NSDraggingInfo>)sender;
- (BOOL)view:(NSView*)aView performDragOperation:(id <NSDraggingInfo>)sender;
- (void)view:(NSView*)aView concludeDragOperation:(id <NSDraggingInfo>)sender;
- (void)view:(NSView*)aView draggingEnded:(id <NSDraggingInfo>)sender;
- (BOOL)viewWantsPeriodicDraggingUpdates:(NSView*)aView ;
- (void)view:(NSView*)aView updateDraggingItemsForDrag:(id <NSDraggingInfo>)sender;

// Methods for Drawing
- (void) view:(NSView*)aView drawRect:(NSRect)dirtyRect;

@end


/**
 
 \brief     NUViewDelegate adds delegation to NSView for mouse events, drag & drop and drawing.
 
 \details   Sometimes its more useful or elegant to use composition in an 
            object model as opposed to inheritance. In these cases it would be 
            nice for the owner of a view do decide how to handle mouse events,
            drag & drop or drawing operations.  This is the role of the 
            NUDelegatingView. 
 
 */

@interface NUDelegatingView : NSView
@property (assign) IBOutlet id delegate;
@end
