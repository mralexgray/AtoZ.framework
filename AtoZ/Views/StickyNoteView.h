//  StickyNoteView.h

#import <Cocoa/Cocoa.h>

@interface StickyNoteView : NSControl

{
NSPoint _eventStartPoint, _lastDragPoint;
	int _draggingMode;
	NSTrackingRectTag _trackingRectTag;
}

@property (nonatomic, assign) NSSize maxSize, minSize;
@property (nonatomic, copy) NSS* placeholderString;
@property (nonatomic, strong)	NSColor *noteColor, *textColor;
@property (nonatomic, assign) AZPOS edge;

@end

#define MWDraggingModeMove	 0
#define MWDraggingModeResize 1
#define MWDraggingModeNone	 2
@interface StickyNoteView (PrivateMethods)
- (void)_doubleMouse:(NSEvent *)theEvent;
- (NSR)_fillRectForCurrentFrame;
- (NSR)_cellRectForCurrentFrame;
- (NSR)_closeButtonRectForCurrentFrame;
- (NSR)_resizeHandleRectForCurrentFrame;
- (NSR)_constrainRectSize:(NSR)rect;
@end


