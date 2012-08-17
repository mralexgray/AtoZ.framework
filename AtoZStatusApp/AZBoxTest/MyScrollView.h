//
//  MyScrollView.h
//  MyScrollView
//
//  Created by Hoshi Takanori on 11/12/27.
//  Copyright (c) 2011 -. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>


////@interface MyScrollView ()
//- (void)updateScrollValues:(MyScrollView *)scrollView;
//- (void)scrollValueChanged:(MyScrollView *)scrollView;
//@end



@class MyScrollView;
@class MyScroller;

// may be CGFloat
typedef NSInteger MyScrollValueType;

typedef enum {
    MyScrollViewStateNormal,
    MyScrollViewStateKnobsVisible,
    MyScrollViewStateHorizontalKnobSlot,
    MyScrollViewStateVerticalKnobSlot,
} MyScrollViewState;

@protocol MyScrollContent <NSObject>

// called when scroll view changed the size of content view
- (void)updateScrollValues:(MyScrollView *)scrollView;

// called when content view is scrolled
- (void)scrollValueChanged:(MyScrollView *)scrollView;
NSScrollView
@end

@interface MyScrollView : NSView {
    NSView <MyScrollContent> *contentView;
    MyScroller *horizontalScroller;
    MyScroller *verticalScroller;

    MyScrollValueType x, minX, maxX, knobX, lineX, pageX;
    MyScrollValueType y, minY, maxY, knobY, lineY, pageY;

    MyScrollViewState state;    // visual state of overlay scrollers
    BOOL overlayTimerStarted;   // true if we are waiting to fade
    NSTimer *fadeTimer;         // timer to control fading animation
}

// when set, content view is resized and added subview of the scroll view.
@property (nonatomic, retain) IBOutlet NSView <MyScrollContent> *contentView;

@property (nonatomic, assign) MyScrollValueType x;      // scroll position x
@property (nonatomic, assign) MyScrollValueType minX;   // minimum value of x
@property (nonatomic, assign) MyScrollValueType maxX;   // maximum value of x
@property (nonatomic, assign) MyScrollValueType knobX;  // knob size
@property (nonatomic, assign) MyScrollValueType lineX;  // line scroll (pre Lion)
@property (nonatomic, assign) MyScrollValueType pageX;  // page scroll

@property (nonatomic, assign) MyScrollValueType y;      // scroll position y
@property (nonatomic, assign) MyScrollValueType minY;
@property (nonatomic, assign) MyScrollValueType maxY;
@property (nonatomic, assign) MyScrollValueType knobY;
@property (nonatomic, assign) MyScrollValueType lineY;
@property (nonatomic, assign) MyScrollValueType pageY;

// commit scroller values and call scrollValueChanged:
// you should call when you change x, minX, maxX, etc.
- (void)commitScrollValues;

- (void)mouseEnteredScroller:(MyScroller *)scroller;
- (void)mouseExitedScroller:(MyScroller *)scroller;

@end
