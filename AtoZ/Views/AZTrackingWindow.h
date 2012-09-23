

#import "AtoZ.h"

// key for dictionary in NSTrackingAreas's userInfo  NSString *kAZTrackerChanged = @"trackerState";


@interface AZTrackingWindow : NSWindow
@property (nonatomic, assign) AZWindowPosition 	position;

@property (nonatomic, assign) AZSlideState 		slideState;
@property (nonatomic, assign) CGFloat 			triggerWidth, 	intrusion;
@property (nonatomic, assign) NSRect 			triggerFrame, 	workingFrame, 	visibleFrame;

@property (nonatomic, strong) AZSimpleView 		*view;

+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance inRect:(NSRect)frame;
+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance;
+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance withDelegate:(id)del;

@property (readonly) NSRect	 	outFrame;
@property (readonly) AZOrient 	orientation;
@property (readonly) NSUInteger capacity;

- (void) slideOut;
- (void) slideIn;
- (void) setPosition: (AZWindowPosition)position;

@end


/*


@class AZTrackingWindow;

//+ (void) flipDown:(AZTrackingWindow*)window;
//+ (void) shakeWindow:(NSWindow*)window;

@protocol AZTrackingDelegate <NSObject>

-(void)ignoreMouseDown:(NSEvent*)event;
-(void)trackerDidReceiveEvent:(NSEvent*)event inRect:(NSRect)theRect;

@end
*/

