//  StickyNoteView.h

#import <Cocoa/Cocoa.h>


JROptionsDeclare(MWDraggingMode, MWDraggingModeMove, MWDraggingModeResize, MWDraggingModeNone);

@interface StickyNoteView : NSControl

@property (NATOM) 	NSSZ 	maxSize,minSize;
@property (NATOM,CP) NSS* 	placeholderString;
@property (NATOM)		NSC 	*noteColor,*textColor;
@property (NATOM) 	AZA 	alignment;

@property NSPoint 				eventStartPoint, lastDragPoint;
@property NSEventMask 			draggingMode;
@property NSTrackingRectTag 	trackingRectTag;
@property CGSZ		dragThreshold;


@end

@interface StickyNoteView (PrivateMethods)
- (void)_doubleMouse:(NSEvent *)theEvent;
- (NSR)_fillRectForCurrentFrame;
- (NSR)_cellRectForCurrentFrame;
- (NSR)_closeButtonRectForCurrentFrame;
- (NSR)_resizeHandleRectForCurrentFrame;
- (NSR)_constrainRectSize:(NSR)rect;
@end


