//
//  MyScrollView.m
//  MyScrollView
//
//  Created by Hoshi Takanori on 11/12/27.
//  Copyright (c) 2011 -. All rights reserved.
//

#import "MyScrollView.h"
#import "MyScroller.h"


#define OVERLAY_FADE_DELAY 1
#define OVERLAY_FADE_INTERVAL 0.05
#define OVERLAY_FADE_STEP 0.2




@interface MyScrollView ()

- (void)createScrollers;
- (void)resizeContents:(NSNotification *)notification;

- (void)scrolledHorizontally:(id)sender;
- (void)scrolledVertically:(id)sender;

- (void)setState:(MyScrollViewState)newState;
- (void)startOverlayTimer;
- (void)stopOverlayTimer;
- (void)overlayTimeout;
- (void)fadeScrollers:(NSTimer*)timer;

@end

@implementation MyScrollView

@synthesize contentView;
@synthesize x, minX, maxX, knobX, lineX, pageX;
@synthesize y, minY, maxY, knobY, lineY, pageY;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self createScrollers];

        if ([NSScroller respondsToSelector:@selector(preferredScrollerStyle)]) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(resizeContents:)
                                                         name:NSPreferredScrollerStyleDidChangeNotification
                                                       object:nil];
        }
    }
    return self;
}

- (void)createScrollers
{
    NSRect bounds = self.bounds;
    CGFloat scrollerWidth = [NSScroller scrollerWidth];

    horizontalScroller = [[MyScroller alloc] initWithFrame:NSMakeRect(0, 0, bounds.size.width, scrollerWidth)];
    horizontalScroller.autoresizingMask = NSViewWidthSizable | NSViewMaxYMargin;
    horizontalScroller.enabled = YES;
    horizontalScroller.action = @selector(scrolledHorizontally:);
    horizontalScroller.target = self;
    horizontalScroller.scrollView = self;
    horizontalScroller.knobAlphaValue = 1;
    [self addSubview:horizontalScroller];

    verticalScroller = [[MyScroller alloc] initWithFrame:NSMakeRect(0, 0, scrollerWidth, bounds.size.height)];
    verticalScroller.autoresizingMask = NSViewMinXMargin | NSViewHeightSizable;
    verticalScroller.enabled = YES;
    verticalScroller.action = @selector(scrolledVertically:);
    verticalScroller.target = self;
    verticalScroller.scrollView = self;
    verticalScroller.knobAlphaValue = 1;
    [self addSubview:verticalScroller];
}

- (void)setContentView:(NSView <MyScrollContent> *)view
{
    if (view != contentView) {
        [contentView removeFromSuperview];
//        [contentView release];

        contentView = view;// retain];
        contentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:contentView positioned:NSWindowBelow relativeTo:nil];

        [self resizeContents:nil];

        self.state = MyScrollViewStateKnobsVisible;
        [self startOverlayTimer];
    }
}

- (void)resizeContents:(NSNotification *)notification
{
    NSScrollerStyle scrollerStyle = [MyScroller preferredScrollerStyle];
    CGFloat scrollerWidth = [MyScroller scrollerWidthForScrollerStyle:scrollerStyle];
    if ([horizontalScroller respondsToSelector:@selector(setScrollerStyle:)]) {
        horizontalScroller.scrollerStyle = scrollerStyle;
        verticalScroller.scrollerStyle = scrollerStyle;
    }

    NSRect bounds = self.bounds;
    horizontalScroller.frame = NSMakeRect(bounds.origin.x, bounds.origin.y,
                                          bounds.size.width - scrollerWidth, scrollerWidth);
    verticalScroller.frame = NSMakeRect(bounds.origin.x + bounds.size.width - scrollerWidth, bounds.origin.y + scrollerWidth,
                                        scrollerWidth, bounds.size.height - scrollerWidth);
    if (scrollerStyle == NSScrollerStyleLegacy) {
        contentView.frame = NSMakeRect(bounds.origin.x, bounds.origin.y + scrollerWidth,
                                       bounds.size.width - scrollerWidth, bounds.size.height - scrollerWidth);
    } else {
        contentView.frame = bounds;
    }

    [contentView updateScrollValues:self];

    self.state = MyScrollViewStateNormal;
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldSize
{
    [super resizeSubviewsWithOldSize:oldSize];
    [contentView updateScrollValues:self];
    self.state = MyScrollViewStateKnobsVisible;
    [self startOverlayTimer];
}

- (void)commitScrollValues
{
    if (maxX < minX) { maxX = minX; }
    if (x < minX) { x = minX; }
    if (x > maxX) { x = maxX; }
    if (maxY < minY) { maxY = minY; }
    if (y < minY) { y = minY; }
    if (y > maxY) { y = maxY; }
    horizontalScroller.doubleValue = (double) (x - minX) / (maxX - minX);
    horizontalScroller.knobProportion = (double) knobX / (maxX - minX + knobX);
    verticalScroller.doubleValue = (double) (y - minY) / (maxY - minY);
    verticalScroller.knobProportion = (double) knobY / (maxY - minY + knobY);
    [contentView scrollValueChanged:self];
}

- (void)scrolledHorizontally:(id)sender
{
    MyScrollValueType dx = 0;
    switch (horizontalScroller.hitPart) {
        case NSScrollerIncrementLine:   dx = + lineX;   break;
        case NSScrollerDecrementLine:   dx = - lineX;   break;
        case NSScrollerIncrementPage:   dx = + pageX;   break;
        case NSScrollerDecrementPage:   dx = - pageX;   break;
    }
    if (dx != 0) {
        x += dx;
        [self commitScrollValues];
    } else {
        x = minX + horizontalScroller.doubleValue * (maxX - minX);
        [contentView scrollValueChanged:self];
    }
}

- (void)scrolledVertically:(id)sender
{
    MyScrollValueType dy = 0;
    switch (verticalScroller.hitPart) {
        case NSScrollerIncrementLine:   dy = + lineY;   break;
        case NSScrollerDecrementLine:   dy = - lineY;   break;
        case NSScrollerIncrementPage:   dy = + pageY;   break;
        case NSScrollerDecrementPage:   dy = - pageY;   break;
    }
    if (dy != 0) {
        y += dy;
        [self commitScrollValues];
    } else {
        y = minY + verticalScroller.doubleValue * (maxY - minY);
        [contentView scrollValueChanged:self];
    }
}

- (void)scrollWheel:(NSEvent *)event
{
    if ([event respondsToSelector:@selector(scrollingDeltaX)]) {
        x -= event.scrollingDeltaX;
        y -= event.scrollingDeltaY;
    } else {
        x -= event.deltaX;
        y -= event.deltaY;
    }
    [self commitScrollValues];

    if (state == MyScrollViewStateNormal || fadeTimer != nil) {
        NSPoint point = [self convertPoint:[event locationInWindow] fromView:nil];
        if (NSPointInRect(point, horizontalScroller.frame)) {
            self.state = MyScrollViewStateHorizontalKnobSlot;
        } else if (NSPointInRect(point, verticalScroller.frame)) {
            self.state = MyScrollViewStateVerticalKnobSlot;
        } else {
            self.state = MyScrollViewStateKnobsVisible;
            [self startOverlayTimer];
        }
    } else if (overlayTimerStarted) {
        [self startOverlayTimer];
    }
}

- (void)setState:(MyScrollViewState)newState
{
    [self stopOverlayTimer];

    if ([MyScroller preferredScrollerStyle] == NSScrollerStyleOverlay) {
        state = newState;
        [horizontalScroller setState:state knobSlotState:MyScrollViewStateHorizontalKnobSlot];
        [verticalScroller setState:state knobSlotState:MyScrollViewStateVerticalKnobSlot];
    } else {
        state = MyScrollViewStateNormal;
        horizontalScroller.hidden = NO;
        verticalScroller.hidden = NO;
    }
}

- (void)startOverlayTimer
{
    [self stopOverlayTimer];

    if ([MyScroller preferredScrollerStyle] == NSScrollerStyleOverlay && state != MyScrollViewStateNormal) {
        [self performSelector:@selector(overlayTimeout) withObject:nil afterDelay:OVERLAY_FADE_DELAY];
        overlayTimerStarted = YES;
    }
}

- (void)stopOverlayTimer
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(overlayTimeout) object:nil];

    if (fadeTimer != nil) {
        horizontalScroller.knobAlphaValue = 1;
        [horizontalScroller setNeedsDisplay];
        verticalScroller.knobAlphaValue = 1;
        [verticalScroller setNeedsDisplay];
        [fadeTimer invalidate];
        fadeTimer = nil;
    }

    overlayTimerStarted = NO;
}

- (void)overlayTimeout
{
    // use timer instead of Core Animation which doesn't work for overlay scrollers.
    fadeTimer = [NSTimer timerWithTimeInterval:OVERLAY_FADE_INTERVAL
                                        target:self
                                      selector:@selector(fadeScrollers:)
                                      userInfo:nil
                                       repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:fadeTimer forMode:NSRunLoopCommonModes];

    overlayTimerStarted = NO;
}

- (void)fadeScrollers:(NSTimer*)timer
{
    CGFloat alpha = horizontalScroller.knobAlphaValue - OVERLAY_FADE_STEP;
    if (alpha > 0) {
        horizontalScroller.knobAlphaValue = alpha;
        [horizontalScroller setNeedsDisplay];
        verticalScroller.knobAlphaValue = alpha;
        [verticalScroller setNeedsDisplay];
    } else {
        self.state = MyScrollViewStateNormal;
    }
}

- (void)viewWillStartLiveResize
{
    [super viewWillStartLiveResize];
    self.state = MyScrollViewStateKnobsVisible;
}

- (void)viewDidEndLiveResize
{
    [super viewDidEndLiveResize];
    [self startOverlayTimer];
}

- (void)mouseEnteredScroller:(MyScroller *)scroller
{
    if (scroller == horizontalScroller) {
        self.state = MyScrollViewStateHorizontalKnobSlot;
    } else {
        self.state = MyScrollViewStateVerticalKnobSlot;
    }
}

- (void)mouseExitedScroller:(MyScroller *)scroller
{
    [self startOverlayTimer];
}

- (void)dealloc
{
    if ([NSScroller respondsToSelector:@selector(preferredScrollerStyle)]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [self stopOverlayTimer];
//    [contentView release];
//    [horizontalScroller release];
//    [verticalScroller release];
//    [super dealloc];
}

@end
