#import <Cocoa/Cocoa.h>
#import "AtoZ.h"


typedef enum {
	AZOrientTop,
	AZOrientLeft,
	AZOrientBottom,
	AZOrientRight,
	AZOrientFiesta
}	AZOrient;

typedef enum {
	AZInfiteScale0X,
	AZInfiteScale1X,
	AZInfiteScale2X,
	AZInfiteScale3X,
	AZInfiteScale10X
} 	AZInfiteScale;


@interface InfiniteDocumentView : NSView
@end

@interface NSClipView (InfinityAdditions)
//- (BOOL)isFlipped;
@end

@interface AtoZInfinity : NSScrollView // <NSWindowDelegate, AJSiTunesAPIDelegate>

@property (assign, nonatomic) NSTrackingArea *trackingArea;

@property (assign, nonatomic) NSSize totalBar;
@property (assign, nonatomic) NSRect barUnit;
@property (assign, nonatomic) NSRect totalBarFrame;

@property (retain, nonatomic) InfiniteDocumentView *docV;
@property (retain, nonatomic) NSImageView *imageViewBar;

@property (assign, nonatomic) NSRect unit;
@property (assign, nonatomic) AZInfiteScale scale;
@property (assign, nonatomic) AZOrient orientation;
@property (retain, nonatomic) NSArray *infiniteObjects;
- (void) setupInfiniBar;

//- (void) stack;
//- (void) popItForView:(AZSimpleView*)vv;
//- (void) simulateScrollWithOffset:(float)f orEvent:(NSEvent*)event;
@end