#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

@interface InfiniteDocumentView : NSView
@end

@interface InfiniteImageView : NSImageView
- (BOOL)isFlipped;
@end

@interface NSClipView (InfinityAdditions)
//- (BOOL)isFlipped;
@end

@interface AtoZInfinity : NSScrollView // <NSWindowDelegate, AJSiTunesAPIDelegate>

@property (NATOM, ASS) NSTrackingArea *trackingArea;

@property (NATOM, ASS) NSSize totalBar;
@property (NATOM, ASS) NSRect barUnit;
@property (NATOM, ASS) NSRect totalBarFrame;

@property (retain, nonatomic) InfiniteDocumentView *docV;
@property (retain, nonatomic) InfiniteImageView *imageViewBar;

@property (NATOM, ASS) NSRect unit;
@property (NATOM, ASS) AZInfiteScale scale;
@property (NATOM, ASS) AZOrient orientation;
@property (retain, nonatomic) NSArray *infiniteObjects;
- (void) setupInfiniBar;

//- (void) stack;
//- (void) popItForView:(AZSimpleView*)vv;
//- (void) simulateScrollWithOffset:(float)f orEvent:(NSEvent*)event;
@end
