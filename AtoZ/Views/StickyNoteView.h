//#import <AIUtilities/AIUtilities.h>


#import "StickyNoteView2.h"

JREnumDeclare(AZDraggingMode, AZDraggingModeMove, AZDraggingModeResize, AZDraggingModeNone);

@class StickyNote;

@interface   StickyNoteView : NSView
@property (weak) StickyNote * proxy;
@property       NSEventMask 	draggingMode;
@property NSTrackingRectTag 	trackingRectTag;
@property               CAL * glowBar;
@property               NSP 	eventStartPoint, lastDragPoint;
@property (NA)     AZPOS 	align;
@property (NA)      NSSZ 	dragThreshold, maxSize, minSize;
@end

@interface StickyNote : BaseModel 
+ (instancetype) instanceWithFrame: (NSR)rect;
@property 	  	  (RO)	NSW	*window;
@property    (CP, NA)  	NSS	*placeholderString;
@property (STR, NA)	NSC	*noteColor, *textColor;
@property (STR, NA) StickyNoteView *sticky;

@end


@interface AZStickyNoteView : NSControl 
@property (assign)    AZDraggingMode   draggingMode;
@property (assign) NSTrackingRectTag   trackingRectTag;
@property (strong) 			 NSString * placeholderString;
@property (strong) 			  NSColor * noteColor, 
												 * textColor;
@property (assign)           NSPoint   eventStartPoint,
													lastDragPoint;
@property (assign)            NSSize   minSize, 
													maxSize;

@end


