//
//  iCarousel+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 4/7/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//

#import "iCarousel+AtoZ.h"


@interface iCarousel (AtoZ)
@property (nonatomic) NSInteger currentItemIndex;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic) CGFloat startVelocity;
@property (nonatomic, getter = isScrolling) BOOL scrolling;
@end

@implementation iC (ScrollWheel)

- (CGFloat)az_clampedOffset:(CGFloat)o {
	[self az_clampedOffset:o];
//	LOGWARN(@"Swizzled az_clampedoff:");
	return self.wrapEnabled ?	//	if (_wrapEnabled)
		 self.numberOfItems? (o - floorf(o / (CGFloat)self.numberOfItems) * self.numberOfItems): 0.0f :
      fminf(fmaxf(0.0f, o), (CGFloat)self.numberOfItems - 1.0f);
}

- (void) setScrollWheelEnabled:(BOOL)x {


  [NSEVENTLOCALMASK:NSScrollWheelMask handler:^NSEvent *(NSEvent *theEvent) {

    CGFloat translation = (self.vertical) ? [theEvent deltaY]	: [theEvent deltaX];
      //		translation	 = d == AZBtm ? translation	:
      //					   d == AZLft   ? translation	: -translation;
    CGFloat factor = 1.f;
    if (!self.wrapEnabled && self.bounces)

      factor = 1.0f - fminf(fabsf(self.scrollOffset - [self az_clampedOffset:self.scrollOffset]), self.bounceDistance) / self.bounceDistance;
    NSTimeInterval thisTime = [theEvent timestamp];
    self.startVelocity = -(translation / (thisTime - self.startTime)) * factor * self.scrollSpeed / self.itemWidth;
    self.startTime = thisTime;

    self.scrollOffset -= translation * factor * self.offsetMultiplier / self.itemWidth;
//    [self disableAnimation];
//    [self didScroll];
//    [self enableAnimation];
    return theEvent;
  }];
}
@end
