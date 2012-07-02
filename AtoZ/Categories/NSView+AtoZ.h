//
//  NSView+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/1/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
	AZViewAnimationTypeJiggle = 0,
	AZViewAnimationTypeFlipHorizontally,
	AZViewAnimationTypeFlipVeryically
}
AZViewAnimationType;

@interface NSView (AtoZ)



- (void)setupHostView;

-(NSView *)firstSubview;
-(NSView *)lastSubview;
-(void)setLastSubview:(NSView *)view;

- (void)removeAllSubviews;

- (NSImage *) snapshot;
- (NSImage *) snapshotFromRect:(NSRect) sourceRect;


-(NSTrackingArea *)trackFullView;
-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect;
-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect 
                            userInfo:(NSDictionary *)context;

- (BOOL)		requestFocus;

//@property (assign) NSPoint center;
- (NSPoint) center;

- (void)	animate:(AZViewAnimationType)type;
- (void)	stopAnimating;

- (void)resizeFrameBy:(int)value;
//- (void)removeAllSubviews;


- (void)fadeOut;
- (void)fadeIn;
- (void)animateToFrame:(NSRect)rect;
- (void)fadeToFrame:(NSRect)rect; // animates to supplied frame;fades in if view is hidden; fades out if view is visible

+ (void)setDefaultDuration:(NSTimeInterval)duration;
+ (void)setDefaultBlockingMode:(NSAnimationBlockingMode)mode;
+ (void)setDefaultAnimationCurve:(NSAnimationCurve)curve;

+ (void)animateWithDuration:(NSTimeInterval)duration 
                  animation:(void (^)(void))animationBlock;
+ (void)animateWithDuration:(NSTimeInterval)duration 
                  animation:(void (^)(void))animationBlock
                 completion:(void (^)(void))completionBlock;


@end