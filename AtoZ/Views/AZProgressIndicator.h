


@interface AZProgressBar : NSProgressIndicator

@property NSC * color;
@property (NA) CGF stripeWidth;
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
-  (void)	startAnimation:a ___
                              -  (void)	stopAnimation _ a ___
                              -  (void)	animateInBackgroundThread;
@end
