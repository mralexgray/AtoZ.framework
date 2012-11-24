//
//  CategoryDataWheel.m
//  AtoZ
//
//  Created by Alex Gray on 8/22/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "CategoryDataWheel.h"

@implementation CategoryDataWheel
- (void)awakeFromNib
{
		//set up data
		//your carousel should always be driven by an array of
		//data of some kind - don't store data in your item views
		//or the recycling mechanism will destroy your data once
		//your item views move off-screen
    self.items = [AtoZ appCategories].mutableCopy;
	// [NSMutableArray array];
//    for (int i = 0; i < 100; i++)
//    {
//        [items addObject:[NSNumber numberWithInt:i]];
//    }
}

//- (void)dealloc {
		//it's a good idea to set these to nil here to avoid
		//sending messages to a deallocated viewcontroller
		//this is true even if your project is using ARC, unless
		//you are targeting iOS 5 as a minimum deployment target
//    _carousel.delegate = nil;
//    _carousel.dataSource = nil;
//    [carousel release];
//    [items release];
//    [super dealloc];
//}

#pragma mark - View lifecycle

#pragma mark - iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
		//return the total number of items in the carousel
    return 10;//[_items count];
}

- (NSView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(NSView *)view
{
//    NSTextLabel *label = nil;

		//create new view if no view is available for recycling
    if (view == nil)
    {
			//don't do anything specific to the index within
			//this `if (view == nil) {...}` statement because the view will be
			//recycled and used with other index values later
        view = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, 200.0f, 200.0f)];
        ((NSImageView *)view).image = [NSImage az_imageNamed:@"4.pdf"];
	}
	return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionFadeMin:
            return -0.2;
        case iCarouselOptionFadeMax:
            return 0.2;
        case iCarouselOptionFadeRange:
            return 2.0;
        default:
            return value;
    }
}

@end
