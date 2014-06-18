//
//  iCarousel.h
//
//  Version 1.8 beta 15
//
//  Created by Nick Lockwood on 01/04/2011.
//  Copyright 2011 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/iCarousel
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//


#import <Availability.h>
#undef weak_delegate
#undef __weak_delegate
#if __has_feature(objc_arc) && __has_feature(objc_arc_weak) && \
(!(defined __MAC_OS_X_VERSION_MIN_REQUIRED) || \
__MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_8)
#define weak_delegate weak
#else
#define weak_delegate unsafe_unretained
#endif

#import <QuartzCore/QuartzCore.h>
#if defined USING_CHAMELEON || defined __IPHONE_OS_VERSION_MAX_ALLOWED
#define ICAROUSEL_IOS
#else
#define ICAROUSEL_MACOS
#endif

#ifdef ICAROUSEL_IOS
#import <UIKit/UIKit.h>
#else
@import AppKit;
#define UIView NSView
//typedef NSView UIView;
#endif

typedef NS_ENUM(NSUInteger, iCarouselType)
{
    iCarouselTypeLinear,              iCarouselTypeRotary,
    iCarouselTypeInvertedRotary,      iCarouselTypeCylinder,
    iCarouselTypeInvertedCylinder,    iCarouselTypeWheel,
    iCarouselTypeInvertedWheel,       iCarouselTypeCoverFlow,
    iCarouselTypeCoverFlow2,          iCarouselTypeTimeMachine,
    iCarouselTypeInvertedTimeMachine, iCarouselTypeCustom
};


typedef NS_ENUM(NSUInteger, iCarouselOption)
{
    iCarouselOptionWrap,              iCarouselOptionShowBackfaces,
    iCarouselOptionOffsetMultiplier,  iCarouselOptionVisibleItems,
    iCarouselOptionCount,             iCarouselOptionArc,
    iCarouselOptionAngle,             iCarouselOptionRadius,
    iCarouselOptionTilt,              iCarouselOptionSpacing,
    iCarouselOptionFadeMin,           iCarouselOptionFadeMax,
    iCarouselOptionFadeRange,         iCarouselOptionFadeMinAlpha
};

@protocol iCarouselDataSource, iCarouselDelegate; @interface iCarousel : UIView

@property (nonatomic, weak_delegate) IBOutlet id<iCarouselDataSource> dataSource;
@property (nonatomic, weak_delegate) IBOutlet id<iCarouselDelegate> delegate;

@property (readonly)  UIView      * currentItemView,
                                  * contentView;
@property (readonly)  NSArray     * indexesForVisibleItems,
                                  * visibleItemViews;
@property (nonatomic) iCarouselType type;

@property (nonatomic) CGSize    contentOffset,    viewpointOffset;
@property (readonly)  CGFloat   offsetMultiplier, itemWidth,            toggle;
@property (nonatomic) CGFloat   decelerationRate, perspective,          bounceDistance,
                                scrollOffset,     scrollSpeed,          autoscroll;
@property (readonly)  NSInteger numberOfItems,    numberOfPlaceholders, numberOfVisibleItems, currentItemIndex;

@property (nonatomic, getter = isScrollEnabled) BOOL scrollEnabled;
@property (nonatomic, getter = isPagingEnabled) BOOL pagingEnabled;
@property (readonly,  getter = isWrapEnabled)   BOOL wrapEnabled;
@property (nonatomic, getter = isVertical)      BOOL vertical;
@property (readonly,  getter = isDragging)      BOOL dragging;
@property (readonly,  getter = isDecelerating)  BOOL decelerating;
@property (readonly,  getter = isScrolling)     BOOL scrolling;

@property (nonatomic) BOOL      ignorePerpendicularSwipes, centerItemWhenSelected,
                                stopAtItemBoundary, scrollToItemBoundary, bounces;


- (void)        scrollByOffset:(CGFloat)offst duration:(NSTimeInterval)duration;
- (void)        scrollToOffset:(CGFloat)offst duration:(NSTimeInterval)duration;
- (void) scrollByNumberOfItems:(NSInteger)iCt duration:(NSTimeInterval)duration;
- (void)   scrollToItemAtIndex:(NSInteger)idx duration:(NSTimeInterval)duration;
- (void)   scrollToItemAtIndex:(NSInteger)idx animated:(BOOL)animated;

- (UIView *)           itemViewAtIndex:(NSInteger)idx;
- (NSInteger)          indexOfItemView:(UIView *)view;
- (NSInteger) indexOfItemViewOrSubview:(UIView *)view;
- (CGFloat)       offsetForItemAtIndex:(NSInteger)idx;
- (UIView *)           itemViewAtPoint:(CGPoint)point;

- (void) removeItemAtIndex:(NSInteger)idx animated:(BOOL)animated;
- (void) insertItemAtIndex:(NSInteger)idx animated:(BOOL)animated;
- (void) reloadItemAtIndex:(NSInteger)idx animated:(BOOL)animated;

- (void) reloadData;

@end

@protocol iCarouselDataSource <NSObject>                   
                                                                      @required
- (NSUInteger) numberOfItemsInCarousel:(iCarousel *)c;
- (UIView *)                  carousel:(iCarousel *)c 
                    viewForItemAtIndex:(NSUInteger)idx 
                           reusingView:(UIView *)view;               
                                                                      @optional
- (NSUInteger) numberOfPlaceholdersInCarousel:(iCarousel *)c;
- (UIView *)                         carousel:(iCarousel *)c 
                       placeholderViewAtIndex:(NSUInteger)idx 
                                  reusingView:(UIView *)view;
@end

@protocol iCarouselDelegate <NSObject>                     
                                                                      @optional
- (void) carouselWillBeginScrollingAnimation:(iCarousel *)c;
- (void)    carouselDidEndScrollingAnimation:(iCarousel *)c;
- (void)                   carouselDidScroll:(iCarousel *)c;
- (void)   carouselCurrentItemIndexDidChange:(iCarousel *)c;
- (void)           carouselWillBeginDragging:(iCarousel *)c;
- (void)       carouselWillBeginDecelerating:(iCarousel *)c;
- (void)          carouselDidEndDecelerating:(iCarousel *)c;
- (void)              carouselDidEndDragging:(iCarousel *)c willDecelerate:(BOOL)decelerate;

- (BOOL) carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)idx;
- (void) carousel:(iCarousel *)carousel    didSelectItemAtIndex:(NSInteger)idx;

- (CGFloat) carouselItemWidth:(iCarousel *)c;
- (CATransform3D)    carousel:(iCarousel *)c 
       itemTransformForOffset:(CGFloat)offset
                baseTransform:(CATransform3D)transform;
                                                   
- (CGFloat) carousel:(iCarousel *)c valueForOption:(iCarouselOption)opt 
                                       withDefault:(CGFloat)value;
@end
