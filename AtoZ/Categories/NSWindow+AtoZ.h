//
//  NSWindow+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (AtoZ)

- (NSPoint)		midpoint; //get the midpoint of the window
- (void)		setMidpoint:		(NSPoint)midpoint; //set the midpoint of the window
- (void)		addViewToTitleBar:	(NSView*)viewToAdd atXPosition:(CGFloat)x;
- (CGFloat)		heightOfTitleBar;
- (void) setContentSize:(NSSize)aSize display:(BOOL)displayFlag animate:(BOOL)animateFlag;
- (void) betterCenter;

//@property (readonly, nonatomic) BOOL isBorderless;
@property (readonly, nonatomic) CGFloat toolbarHeight;
@end



#define kNTSetDefaultFirstResponderNotification @"NTSetDefaultFirstResponderNotification"  // object is the window, must check

@interface NSWindow (Utilities)

+ (void)cascadeWindow:(NSWindow*)inWindow;

+ (NSArray*)visibleWindows:(BOOL)ordered;
//+ (NSArray*)visibleWindows:(BOOL)ordered delegateClass:(Class)delegateClass;

//- (NSWindow*)topWindowWithDelegateClass:(Class)class;

+ (BOOL)isAnyWindowVisible;
//+ (BOOL)isAnyWindowVisibleWithDelegateClass:(Class)class;
+ (NSArray*)miniaturizedWindows;

- (void)setFloating:(BOOL)set;
- (BOOL)isFloating;

- (BOOL)isMetallic;
- (BOOL)isBorderless;

// returns parentWindow if an NSDrawerWindow, returns self if not a drawerWindow
- (NSWindow*)parentWindowIfDrawerWindow;

- (BOOL)dimControls;
- (BOOL)dimControlsKey;
- (BOOL)keyWindowIsMenu;

- (void)flushActiveTextFields;

- (NSRect)setContentViewAndResizeWindow:(NSView*)view display:(BOOL)display;
- (NSRect)resizeWindowToContentSize:(NSSize)contentSize display:(BOOL)display;
- (NSRect)windowFrameForContentSize:(NSSize)contentSize;

+ (BOOL)windowRectIsOnScreen:(NSRect)windowRect;

- (void)setDefaultFirstResponder;

- (void)fadeIn;
- (void)fadeOut;

- (void)slideUp;
- (void)slideDown;

- (void) extendVerticallyBy:(int) amount;

@end

//@interface NSWindow (UndocumentedRoutines)
//- (void)setBottomCornerRounded:(BOOL)set;
//- (BOOL)bottomCornerRounded;
//@end

#define NSBorderlessWindowMaskSet(bitMask) (bitMask == 0)  // NSBorderlessWindowMask == 0
#define NSTexturedBackgroundWindowMaskSet(bitMask) ((bitMask & NSTexturedBackgroundWindowMask) != 0)

