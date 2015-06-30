


// key for dictionary in NSTrackingAreas's userInfo  NSString *kAZTrackerChanged = @"trackerState";
@interface AZTrackingWindow : NSWindow
@property (nonatomic) AZState 		slideState;
@property (nonatomic) AZA     position;
@property (nonatomic) CGF 		triggerWidth, 	intrusion;
@property (nonatomic) NSR 		triggerFrame, 	workingFrame, 	visibleFrame;

@property (nonatomic) AZSimpleView 		*view;

+ oriented:(AZA)o intruding:(CGF)d inRect:(NSRect)frame;
+ oriented:(AZA)o intruding:(CGF)d;
+ oriented:(AZA)o intruding:(CGF)d withDelegate:(id)del;

_RO NSRect	 	outFrame;
_RO AZOrient 	orientation;
_RO NSUInteger capacity;
@property (NA, ASS) NSRange range;

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

