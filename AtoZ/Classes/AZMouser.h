//
//  AZMouser.h
//  AtoZ
//
//  Created by Alex Gray on 7/15/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>
#import <AppKit/AppKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AtoZ.h"


CGPoint mouseLoc();
CGEventType getMouseButton(int btn, int btnState);
void mouseEvent(int btn, int btnState, int clickType);

/* MOUSE MOVEMENT */
void mouseMove(int posX, int posY);
void mouseMoveTo(int posX, int posY, float speed);
/* MOUSE CLICKING */
void mousePress(int btn, int clickType);
void mouseRelease(int btn, int clickType);
void mouseClick(int btn, int clickType);
void mouseDrag(int btn, int posX, int posY);

//static CGRect screenBounds;

CGPoint MousePoint();
void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point);
void Click(const CGPoint point);
void MoveTo(const CGPoint point);
void DragTo(const CGPoint where);
void DragBetwixt(const CGPoint a, const CGPoint b);

//extern void mouseEvent(CGEventRef type, CGFloat posx, CGFloat posy);
//extern void mousemove(CGFloat posx, CGFloat posy);
//extern void mouseclickdn(CGFloat posx, CGFloat posy);
//extern void mouseclickup(CGFloat posx, CGFloat posy);
//extern void mousedrag(CGFloat posx, CGFloat posy);

@interface AUWindowExtend : NSWindow
- (void)setAcceptsMouseMovedEvents:(BOOL)acceptMouseMovedEvents screen:(BOOL)anyWhere;
@end
@interface AZMouserIndicator : NSView
@property (nonatomic, retain) NSImage *indicatorImage;
@end
@interface AZMouserWindow : NSWindow
@property (assign) NSPoint initialLocation;
@property (assign) AZMouserIndicator *indicatorView;
@end
@interface AZMouser : BaseModel
@property (nonatomic, retain) AZMouserWindow *window;

@end
