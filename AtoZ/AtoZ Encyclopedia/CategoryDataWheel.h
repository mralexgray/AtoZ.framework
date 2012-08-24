//
//  CategoryDataWheel.h
//  AtoZ
//
//  Created by Alex Gray on 8/22/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCarousel.h"
#import <AtoZ/AtoZ.h>

@interface CategoryDataWheel : NSObject <iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, retain) IBOutlet iCarousel *carousel;
@property (nonatomic, retain) NSMutableArray *items;

@end
