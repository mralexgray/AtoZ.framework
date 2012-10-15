
//  AZAttachedWindow.h

//  Created by Matt Gemmell on 27/09/2007.
//  Copyright 2007 Magic Aubergine.
#import <Cocoa/Cocoa.h>
#import "AtoZ.h"

/*
 Below are the positions the attached window can be displayed at.
 
 Note that these positions are relative to the point passed to the constructor, 
 e.g. AZPositionBottomRight will put the window below the point and towards the right, 
      AZPositionTop will horizontally center the window above the point, 
      AZPositionRightTop will put the window to the right and above the point, 
 and so on.
 
 You can also pass AZPositionAutomatic (or use an initializer which omits the 'onSide:' 
 argument) and the attached window will try to position itself sensibly, based on 
 available screen-space.
 
 Notes regarding automatically-positioned attached windows:
 
 (a) The window prefers to position itself horizontally centered below the specified point.
     This gives a certain enhanced visual sense of an attachment/relationship.
 
 (b) The window will try to align itself with its parent window (if any); i.e. it will 
     attempt to stay within its parent window's frame if it can.
 
 (c) The algorithm isn't perfect. :) If in doubt, do your own calculations and then 
     explicitly request that the window attach itself to a particular side.
 */

@interface AZAttachedWindow : NSWindow {
     @private
    NSColor *_AZBackgroundColor;
	NSView *_view;
 	NSWindow *_window;
    NSPoint _point;
    AZWindowPosition _side;
    float _distance;
    NSRect _viewFrame;
    BOOL _resizing;
}
@property (retain, nonatomic) NSColor *borderColor;
@property (NATOM, ASS) float borderWidth;
@property (NATOM, ASS) float viewMargin;
@property (NATOM, ASS) float arrowBaseWidth;
@property (NATOM, ASS) float arrowHeight;
@property (NATOM, ASS) BOOL hasArrow;
@property (NATOM, ASS) float cornerRadius;
@property (NATOM, ASS) BOOL drawsRoundCornerBesideArrow;
/*
 Initialization methods

 Parameters:
 
 view       The view to display in the attached window. Must not be nil.
 
 point      The point to which the attached window should be attached. If you 
            are also specifying a parent window, the point should be in the 
            coordinate system of that parent window. If you are not specifying 
            a window, the point should be in the screen's coordinate space.
            This value is required.
 
 window     The parent window to attach this one to. Note that no actual 
            relationship is created (particularly, this window is not made 
            a childWindow of the parent window).
 r            Default: nil.
 
 side       The side of the specified point on which to attach this window.
            Default: AZPositionAutomatic.
 
 distance   How far from the specified point this window should be.
            Default: 0.
 */

- (AZAttachedWindow *)initWithView:(NSView *)view           // designated initializer
                   attachedToPoint:(NSPoint)point 
                          inWindow:(NSWindow *)window 
                            onSide:(AZWindowPosition)side 
                        atDistance:(float)distance;
- (AZAttachedWindow *)initWithView:(NSView *)view 
                   attachedToPoint:(NSPoint)point 
                          inWindow:(NSWindow *)window 
                        atDistance:(float)distance;
- (AZAttachedWindow *)initWithView:(NSView *)view 
                   attachedToPoint:(NSPoint)point 
                            onSide:(AZWindowPosition)side 
                        atDistance:(float)distance;
- (AZAttachedWindow *)initWithView:(NSView *)view 
                   attachedToPoint:(NSPoint)point 
                        atDistance:(float)distance;
- (AZAttachedWindow *)initWithView:(NSView *)view 
                   attachedToPoint:(NSPoint)point 
                          inWindow:(NSWindow *)window;
- (AZAttachedWindow *)initWithView:(NSView *)view 
                   attachedToPoint:(NSPoint)point 
                            onSide:(AZWindowPosition)side;
- (AZAttachedWindow *)initWithView:(NSView *)view 
                   attachedToPoint:(NSPoint)point;

// Accessor methods
//- (NSColor *)borderColor;
//- (void)setBorderColor:(NSColor *)value;
//- (float)borderWidth;
//- (void)setBorderWidth:(float)value;                   // See note 1 below.
//- (float)viewMargin;
//- (void)setViewMargin:(float)value;                    // See note 2 below.
//- (float)arrowBaseWidth;
//- (void)setArrowBaseWidth:(float)value;                // See note 2 below.
//- (float)arrowHeight;
//- (void)setArrowHeight:(float)value;                   // See note 2 below.
//- (float)hasArrow;
//- (void)setHasArrow:(float)value;

//- (float)cornerRadius;
//- (void)setCornerRadius:(float)value;                  // See note 2 below.
//- (float)drawsRoundCornerBesideArrow;                  // See note 3 below.
//- (void)setDrawsRoundCornerBesideArrow:(float)value;   // See note 2 below.
//- (void)setBackgroundImage:(NSImage *)value;
//- (NSColor *)windowBackgroundColor;                    // See note 4 below.
//- (void)setBackgroundColor:(NSColor *)value;
@property (retain, nonatomic) NSView *view;
/* ot at one of the four primary compass directions. In this situation, 
    if drawsRoundCornerBesideArrow is YES (the default), then that corner of the window 
    will be rounded just like the other three corners, thus the arrow will be inset 
    slightly from the edge of the window to allow room for the rounded corner. If this 
    value is NO, the corner beside the arrow will be a square corner, and the other 
    three corners will be rounded.
 
    This is useful when you want to attach a window very near the edge of another window, 
    and don't want the attached window's edge to be visually outside the frame of the 
    parent window.
 
 4. Note that to retrieve the background color of the window, you should use the 
    -windowBackgroundColor method, instead of -backgroundColor. This is because we draw 
    the entire background of the window (rounded path, arrow, etc) in an NSColor pattern 
    image, and set it as the backgroundColor of the window.
 */
@property (nonatomic, assign) AZSlideState pos;

@end
