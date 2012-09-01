

#import <Cocoa/Cocoa.h>

// key for dictionary in NSTrackingAreas's userInfo
// NSString *kAZTrackerChanged = @"trackerState";


//typedef NSInteger AZTrackerState;



typedef struct AZTri {
	CGPoint a;
	CGPoint b;
	CGPoint c;
}AZTri;
typedef struct AZTriPair {
	AZTri uno;
	AZTri duo;
}AZTriPair;


@class AZTrackingWindow;
@interface CornerClipView : NSView
@property (assign, nonatomic, getter = getPair) AZTriPair t;
@property (weak) AZTrackingWindow *windy;
+ initInWindow:(AZTrackingWindow*)windy;
@end

@class AZSimpleView;
@interface AZTrackingWindow : NSWindow <NSWindowDelegate>
{
	NSRect _workingFrame;
}
@property (nonatomic, retain) AZSimpleView *view;
@property (assign, nonatomic) AZOrient orientation;
@property (assign, nonatomic) AZWindowPosition position;
@property (nonatomic, assign) NSRect outFrame;
@property (nonatomic, assign) NSRect visibleFrame;
@property (nonatomic, assign) NSRect triggerFrame;


@property (assign, nonatomic) NSUInteger capacity;


@property (assign, nonatomic) AZSlideState slideState;
@property (assign, nonatomic) CGFloat intrusion;
@property (assign, nonatomic) CGFloat triggerWidth;


@property (retain, nonatomic) NSImageView* handle;
@property (assign, nonatomic) BOOL showsHandle;
@property (strong, nonatomic) CornerClipView *clippy;

@property (nonatomic, assign) NSRect workingFrame;

+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance inRect:(NSRect)frame;
- (void) mouseHandler: (NSEvent*)event;
+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance;
+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance withDelegate:(id)del;
-(void) slideOut;
-(void) slideIn;

//@property (assign, nonatomic) BOOL isHit;

@end

//@protocol AZTrackingDelegate <NSObject>

//-(void)ignoreMouseDown:(NSEvent*)event;
//-(void)trackerDidReceiveEvent:(NSEvent*)event inRect:(NSRect)theRect;

//@end


