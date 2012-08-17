//
//  MyScroller.m
//  MyScrollView
//
//  Created by Hoshi Takanori on 11/12/27.
//  Copyright (c) 2011 -. All rights reserved.
//

#import "MyScroller.h"

#define OVERLAY_SCROLLER_WIDTH 10

@implementation MyScroller

@synthesize scrollView;
@synthesize knobAlphaValue;

+ (BOOL)isCompatibleWithOverlayScrollers
{
    return YES;
}

+ (NSScrollerStyle)preferredScrollerStyle
{
    if ([NSScroller respondsToSelector:@selector(preferredScrollerStyle)]) {
        return [NSScroller preferredScrollerStyle];
    } else {
        return NSScrollerStyleLegacy;
    }
}

+ (CGFloat)scrollerWidthForScrollerStyle:(NSScrollerStyle)scrollerStyle
{
    if (scrollerStyle == NSScrollerStyleOverlay) {
        // BUG: +[NSScroller scrollerWidthForControlSize:scrollerStyle:] returns 15 for NSScrollerStyleOverlay...
        return OVERLAY_SCROLLER_WIDTH;
    } else {
        return [NSScroller scrollerWidth];
    }
}

- (void)setState:(MyScrollViewState)state knobSlotState:(MyScrollViewState)knobSlotState
{
    self.hidden = (state == MyScrollViewStateNormal);
    knobSlotVisible = (state == knobSlotState);
    [self setNeedsDisplay];
}

- (void)drawRect:(NSRect)dirtyRect
{
    if ([self respondsToSelector:@selector(scrollerStyle)] && self.scrollerStyle == NSScrollerStyleOverlay) {
        [[NSColor clearColor] set];
        NSRectFill(NSInsetRect([self bounds], -1.0, -1.0));
        CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
        CGContextSaveGState(context);
        CGContextSetAlpha(context, knobAlphaValue);
        if (knobSlotVisible) {
            [self drawKnobSlotInRect:[self rectForPart:NSScrollerKnobSlot] highlight:NO];
        }
        [self drawKnob];
        CGContextRestoreGState(context);
    } else {
        [super drawRect:dirtyRect];
    }
}

- (void)removeTrackingAreas
{
    if (trackingArea != nil) {
        [self removeTrackingArea:trackingArea];
//        [trackingArea release];
        trackingArea = nil;
    }
}

- (void)updateTrackingAreas {
    [self removeTrackingAreas];
    if ([self respondsToSelector:@selector(scrollerStyle)]) {
        trackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds
                                                    options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                      owner:self
                                                   userInfo:nil];
        [self addTrackingArea:trackingArea];
    }
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [scrollView mouseEnteredScroller:self];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [scrollView mouseExitedScroller:self];
}

- (void)dealloc
{
    [self removeTrackingAreas];
//    [super dealloc];
}

@end
