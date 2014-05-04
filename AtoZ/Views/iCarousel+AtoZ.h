//
//  iCarousel+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 4/7/14.
//  Copyright (c) 2014 mrgray.com, inc. All rights reserved.
//

#import "iCarousel.h"
#import "AtoZUmbrella.h"


@protocol azCarouselDelegate <iCarouselDelegate>
@optional

//ALEX

- (void)carousel: (iC*) carousel shouldHoverItemAtIndex: (NSI)index;

- (CGF)carouselItemWidth: (iC*) carousel;

- (CAT3D)carousel: (iC*) carousel itemTransformForOffset: (CGF)offset
														baseTransform: (CAT3D)transform;

- (CGF)carousel: (iC*) carousel valueForOption: (iCarouselOption)option
															withDefault: (CGF)value;

@end
