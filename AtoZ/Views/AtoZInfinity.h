
#import <AtoZ/AtoZUmbrella.h>

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

@property (NA, ASS) NSSize totalBar;
@property (NA, ASS) NSRect barUnit;
@property (NA, ASS) NSRect totalBarFrame;

@property (retain, nonatomic) InfiniteDocumentView *docV;
@property (retain, nonatomic) InfiniteImageView *imageViewBar;

@property (NA, ASS) NSRect unit;
@property (NA, ASS) AZInfiteScale scale;
@property (NA, ASS) AZOrient orientation;
@property (retain, nonatomic) NSArray *infiniteObjects;
- (void) setupInfiniBar;

//- (void) stack;
//- (void) popItForView:(AZSimpleView*)vv;
//- (void) simulateScrollWithOffset:(float)f orEvent:(NSEvent*)event;
@end
