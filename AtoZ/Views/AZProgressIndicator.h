
#import <Foundation/Foundation.h>
#import "AtoZ.h"


@interface AZProgressBar : NSProgressIndicator

@property NSTimer * animator;
@property NSC * color;
@property (NATOM) CGF stripeWidth;
@property  double   progressOffset;
@property BOOL clickable;

//-  (void) drawBezel;
//-  (void) drawProgressWithBounds: (NSR)bounds;
//-  (void) drawStripesInBounds:    (NSR)bounds;
//-  (void) drawShadowInBounds:     (NSR)bounds;
//- (NSBP*) stripeWithOrigin:       (NSP)origin bounds:(NSR)frame;

@end

@interface AZProgressIndicator : NSView {

	NSThread *_animationThread;
	int 		position;
	NSRect 	indeterminateRect;

@private
	int 	_step;
	NSTimer *_timer;
	NSImage *_indeterminateImage, *_indeterminateImage2;
	BOOL	_animationStarted;
	BOOL	_animationStartedThreaded;
	float 	_gradientWidth;
}

@property (nonatomic)           double doubleValue, maxValue,	cornerRadius;
@property (nonatomic)            float fontSize,    shadowBlur;
@property (nonatomic) BOOL 		usesThreadedAnimation;
@property (nonatomic) NSString 	*progressText;
@property (nonatomic) NSColor 	*progressHolderColor, 	*progressColor, *backgroundTextColor,*frontTextColor, *shadowColor;
@property (nonatomic, setter = setIsIndeterminate:) BOOL isIndeterminate;

-  (void)	setProgressTextAlign:(int)pos;
-   (int)		progressTextAlignt;
- (float)	alignTextOnProgress:(NSRect)rect fontSize:(NSSize)size;
-  (void)	startAnimation:(id)sender;
-  (void)	stopAnimation:(id)sender;
-  (void)	animateInBackgroundThread;
@end
