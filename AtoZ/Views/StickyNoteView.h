#import <AIUtilities/AIUtilities.h>


JROptionsDeclare(MWDraggingMode, MWDraggingModeMove, MWDraggingModeResize, MWDraggingModeNone);

@class StickyNote;
@interface StickyNoteView : AIWindowDraggingView
@property (weak) StickyNote 	*proxy;
@property NSEventMask 			draggingMode;
@property NSTrackingRectTag 	trackingRectTag;
@property (STRNG     ) CAL 	*glowBar;
@property (ASS       ) NSP 	eventStartPoint, lastDragPoint;
@property (NATOM, ASS) AZPOS 	align;
@property (NATOM, ASS) NSSZ 	dragThreshold;
@property (NATOM     ) NSSZ 	maxSize,minSize;
@end


@interface StickyNote : BaseModel 

+ (instancetype) instanceWithFrame: (NSR)rect;

@property 	  	  (RONLY)	NSW	*window;
@property    (CP, NATOM)  	NSS	*placeholderString;
@property (STRNG, NATOM)	NSC	*noteColor, *textColor;
@property (STRNG, NATOM) StickyNoteView *sticky;

@end


