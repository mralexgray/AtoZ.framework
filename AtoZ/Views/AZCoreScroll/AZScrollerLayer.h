#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

#import "AZScrollerProtocols.h"

#define AZSCROLLER_HEIGHT 50.0 // The default height

JROptionsDeclare(AZScrollerMouseDownInput, AZNoInput = (1 << 1),
	AZLeftArrowInput = (1 << 2),
	AZRightArrowInput = (1 << 3),
	AZSliderInput = (1 << 4),
	AZTrayInputLeft = (1 << 5),
	AZTrayInputRight = (1 << 6));

@interface AZScrollerLayer : CALayer < AZScrollerContentController > {

	CALayer* leftArrow;
	CALayer* leftArrowHighlight;

	CALayer* rightArrow;
	CALayer* rightArrowHighlight;

	CALayer* tray;
	CALayer* slider;

	id <AZScrollerContent> __unsafe_unretained _scrollerContent;

	// -------- Event variables --------------
	AZScrollerMouseDownInput _inputMode;
	CGPoint _mouseDownPointForCurrentEvent;
	BOOL _mouseOverSelectedInput;
	NSTimer* mouseDownTimer;
}

@property(unsafe_unretained) id <AZScrollerContent> scrollerContent;

// returns YES if the scroller should be notified of mouse
// dragged and mouse up notifications
- (BOOL)mouseDownAtPointInSuperlayer:(CGPoint)inputPoint;
- (void)mouseDragged:(CGPoint)inputPoint;
- (void)mouseUp:(CGPoint)inputPoint;

- (void)moveSlider:(CGFloat)dx;
@end
