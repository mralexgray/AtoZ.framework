#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@class CIFilter;
@class CIImage;

typedef enum {
    AnimatingTabViewCopyMachineTransitionStyle = 0,
    AnimatingTabViewDissolveTransitionStyle,
    AnimatingTabViewFlashTransitionStyle,
    AnimatingTabViewModTransitionStyle,
    AnimatingTabViewPageCurlTransitionStyle,
    AnimatingTabViewRippleTransitionStyle,
    AnimatingTabViewSwipeTransitionStyle,
	AnimatingTabViewFlipTransitionStyle,  
	AnimatingTabViewCubeTransitionStyle, 
	AnimatingTabViewZoomDissolveTransitionStyle
} TransitionStyle;

@interface Transition : NSObject

@property (nonatomic, assign) TransitionStyle style; // one of the AnimatingTabViewTransitionStyle values
@property (nonatomic, assign) CGFloat 		  direction;	 // +1 = left, -1=right
@property (nonatomic, assign) NSTimeInterval  transitionDuration;

@property (nonatomic, retain) CIImage		 *finalImage, 		*initialImage,      *inputShadingImage;
@property (nonatomic, retain) CIFilter       *transitionFilter, *transitionFilter2;

@property (nonatomic, assign) BOOL			   chaining;
@property (nonatomic, retain) NSAnimation	  *animation;
@property (assign) 			  id				delegate;

@property (nonatomic, assign) NSUInteger		frames;//debug

- (id)initWithDelegate:(id)object shadingImage:(CIImage*)aInputShadingImage;

- (void)setStyle:(int)aStyle direction:(float)aDirection;

- (NSTimeInterval)transitionDuration;
- (void)setTransitionDuration:(NSTimeInterval)aTransitionDuration;

- (void)setInitialView:(NSView*)view;
- (void)setFinalView:(NSView*)view;

// After start is called you'll have to re-load the views again if you want to repeat the animation
- (void)start;

- (void)draw:(NSRect)viewRect;
- (BOOL)isAnimating;
@end

@interface NSObject(TransitionDelegate)
- (void)drawBackground:(NSRect)rect;
@end
