

@interface InfiniteDocumentView : NSView
@end

@interface InfiniteImageView : NSImageView
- (BOOL)isFlipped;
@end

//@interface NSClipView (InfinityAdditions)
////- (BOOL)isFlipped;
//@end

@interface AtoZInfinity : NSScrollView // <NSWindowDelegate, AJSiTunesAPIDelegate>

@property (NA, ASS) NSTrackingArea *trackingArea;

_NA NSSize totalBar;
_NA NSRect barUnit, totalBarFrame;

_NA InfiniteDocumentView *docV;
_NA InfiniteImageView *imageViewBar;

_NA NSRect unit;
_NA AZInfiteScale scale;
_NA AZOrient orientation;
_NA NSArray *infiniteObjects;

- (void) setupInfiniBar;

//- (void) stack;
//- (void) popItForView:(AZSimpleView*)vv;
//- (void) simulateScrollWithOffset:(float)f orEvent:(NSEvent*)event;
@end
