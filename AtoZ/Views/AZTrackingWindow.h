

#import <Cocoa/Cocoa.h>
#import "AtoZ.h"


// key for dictionary in NSTrackingAreas's userInfo
// NSString *kAZTrackerChanged = @"trackerState";


//typedef NSInteger AZTrackerState;


@interface AZTrackingWindow : NSWindow
{
	NSNotificationCenter *center;

}

@property (nonatomic, retain) AZSimpleView *view;
@property (assign, nonatomic) AZOrient orientation;
@property (assign, nonatomic) AZTrackState state;
@property (assign, nonatomic) CGFloat intrusion;
@property (retain, nonatomic) NSImageView* handle;
@property (assign, nonatomic) BOOL showsHandle;


- (void) mouseHandler: (NSEvent*)event;
+ (AZTrackingWindow*) oriented:(AZOrient)orient intruding:(CGFloat)distance;
+ (AZTrackingWindow*) oriented:(AZOrient)orient intruding:(CGFloat)distance withDelegate:(id)del;

//@property (assign, nonatomic) BOOL isHit;

@end

//@protocol AZTrackingDelegate <NSObject>
//
//-(void)ignoreMouseDown:(NSEvent*)event;
//-(void)trackerDidReceiveEvent:(NSEvent*)event inRect:(NSRect)theRect;
//
//@end


