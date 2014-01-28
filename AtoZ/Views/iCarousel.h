/**
  iCarousel.h

  Version 1.7.ALEX

  Created by Nick Lockwood on 01/04/2011.
  Copyright 2011 Charcoal Design

  Distributed under the permissive zlib License
  Get the latest version from either of these locations:

  http://charcoaldesign.co.uk/source/cocoa#icarousel
  https://github.com/nicklockwood/iCarousel

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
  claim that you wrote the original software. If you use this software
  in a product, an acknowledgment in the product documentation would be
  appreciated but is not required.

  2. Altered source versions must be plainly marked as such, and must not be
  misrepresented as being the original software.

  3. This notice may not be removed or altered from any source distribution.

  ARC Helper

  Version 2.1

  Created by Nick Lockwood on 05/01/2012.
  Copyright 2012 Charcoal Design

  Distributed under the permissive zlib license
  Get the latest version from here:

  https://gist.github.com/1563325
*/

#ifndef ah_retain
#if				__has_feature(objc_arc)
#define ah_retain self
#define ah_dealloc self
#define release self
#define autorelease self
#else
#define ah_retain retain
#define ah_dealloc dealloc
#define				__bridge
#endif
#endif
//  Weak delegate support
#ifndef ah_weak
#import <Availability.h>
#if (__has_feature(objc_arc)) && \
((defined				__IPHONE_OS_VERSION_MIN_REQUIRED && \
__IPHONE_OS_VERSION_MIN_REQUIRED >=				__IPHONE_5_0) || \
(defined				__MAC_OS_X_VERSION_MIN_REQUIRED && \
__MAC_OS_X_VERSION_MIN_REQUIRED >				__MAC_10_7))
#define ah_weak weak
#define				__ah_weak				__weak
#else
#define ah_weak unsafe_unretained
#define				__ah_weak				__unsafe_unretained
#endif
#endif
//  ARC Helper ends
#import <QuartzCore/QuartzCore.h>
#ifdef USING_CHAMELEON
#define ICAROUSEL_IOS
#elif defined				__IPHONE_OS_VERSION_MAX_ALLOWED
#define ICAROUSEL_IOS
typedef CGRect NSRect;
typedef CGSZ NSSize;
#else
#define ICAROUSEL_MACOS
#endif
#ifdef ICAROUSEL_IOS
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
typedef NSView UIView;
#endif

typedef NS_ENUM(NSUI, iCarouselType)
{
	iCarouselTypeLinear,					iCarouselTypeRotary,			iCarouselTypeInvertedRotary,			iCarouselTypeCylinder,
	iCarouselTypeInvertedCylinder,	iCarouselTypeWheel,			iCarouselTypeInvertedWheel,				iCarouselTypeCoverFlow,
	iCarouselTypeCoverFlow2,				iCarouselTypeTimeMachine,	iCarouselTypeInvertedTimeMachine,		iCarouselTypeCustom
};

typedef NS_ENUM (NSUI, iCarouselOption) 
{
		iCarouselOptionWrap,		iCarouselOptionShowBackfaces,		iCarouselOptionOffsetMultiplier,		iCarouselOptionVisibleItems,	
		iCarouselOptionCount, 	iCarouselOptionArc,					iCarouselOptionAngle,						iCarouselOptionRadius,	
		iCarouselOptionTilt,		iCarouselOptionSpacing,				iCarouselOptionFadeMin,					iCarouselOptionFadeMax,
		iCarouselOptionFadeRange		
};

typedef enum{	OPTION1,	OPTION2,	OPTION3,	OPTION4,	OPTION5,	OPTION6,	OPTION7,	OPTION8 } 	Option;

@protocol iCarouselDataSource, iCarouselDelegate;
@interface iCarousel : UIView

//required for 32-bit Macs
#ifdef				__i386__
{
@private

	id<iCarouselDelegate>	__ah_weak	_delegate;
	id<iCarouselDataSource>	__ah_weak	_dataSource;
	NSMutableDictionary *				_itemViews;
	NSMutableSet *		_itemViewPool;
	NSMutableSet *		_placeholderViewPool;
	NSI			_previousItemIndex;
	iCarouselType		_type;
	CGF				_perspective;
	NSI			_numberOfItems;
	NSI			_numberOfPlaceholders;
	NSI			_numberOfPlaceholdersToShow;
	NSI			_numberOfVisibleItems;
	UIView *			_contentView;
	CGF				_itemWidth;
	CGF				_scrollOffset;
	CGF				_offsetMultiplier;
	CGF				_startVelocity;
	NSTimer				__unsafe_unretained *_timer;
	BOOL				_decelerating;
	BOOL				_scrollEnabled;
	CGF				_decelerationRate;
	BOOL				_bounces;
	CGSZ				_contentOffset;
	CGSZ				_viewpointOffset;
	CGF				_startOffset;
	CGF				_endOffset;
	NSTI		_scrollDuration;
	NSTI 		_startTime;
	BOOL				_scrolling;
	CGF				_previousTranslation;
	BOOL				_centerItemWhenSelected;
	BOOL				_wrapEnabled;
	BOOL				_dragging;
	BOOL				_didDrag;
	CGF				_scrollSpeed;
	CGF				_bounceDistance;
	NSTI		_toggleTime;
	CGF				_toggle;
	BOOL				_stopAtItemBoundary;
	BOOL				_scrollToItemBoundary;
	BOOL				_vertical;
	BOOL				_ignorePerpendicularSwipes;
	NSI			_animationDisableCount;

}
#endif

@property (NATOM, ah_weak) IBOutlet id<iCarouselDataSource> dataSource;
@property (NATOM, ah_weak) IBOutlet id<iCarouselDelegate> delegate;
@property (NATOM,  ASS)  iCarouselType type;

@property (NATOM,  ASS) 	CGF   perspective;
@property (NATOM,  ASS) 	CGF   decelerationRate;
@property (NATOM,  ASS) 	CGF  	scrollSpeed;
@property (NATOM,  ASS) 	CGF   bounceDistance;
@property (NATOM,  ASS) 	CGF   scrollOffset;
@property (NATOM,RONLY) CGF   offsetMultiplier;
@property (NATOM,  ASS) 	CGSZ 	contentOffset;
@property (NATOM,	 ASS) CGSZ	viewpointOffset;
@property (NATOM,RONLY) NSI	 	numberOfItems;
@property (NATOM,RONLY) NSI 	numberOfPlaceholders;
@property (NATOM,  ASS) 	NSI 	currentItemIndex;
@property (NATOM,STRNG) 	NSV *	currentItemView;
@property (NATOM,RONLY) NSI 	numberOfVisibleItems;
@property (NATOM,RONLY) CGF   itemWidth;
@property (NATOM,  ASS) 	CGF   toggle;		//RONLY
@property (NATOM,  ASS) 	BOOL	bounces;
@property (NATOM,  ASS) BOOL 	stopAtItemBoundary;
@property (NATOM,  ASS) BOOL 	scrollToItemBoundary;
@property (NATOM,  ASS) BOOL	ignorePerpendicularSwipes;
@property (NATOM,  ASS) BOOL	centerItemWhenSelected;

@property (NATOM, ASS, 	 getter = isScrollEnabled) 	BOOL scrollEnabled;
@property (NATOM, ASS, 	 getter = isVertical) 	  	BOOL vertical;
@property (NATOM, RONLY, getter = isWrapEnabled)   	BOOL wrapEnabled;
@property (NATOM, RONLY, getter = isDragging) 	 	BOOL dragging;
@property (NATOM, RONLY, getter = isDecelerating) 	BOOL decelerating;
@property (NATOM, RONLY, getter = isScrolling) 	 	BOOL scrolling;

@property (NATOM,STRNG,RONLY) NSV *	contentView;
@property (NATOM,STRNG,RONLY) NSA *	indexesForVisibleItems;
@property (NATOM,STRNG,RONLY) NSA *	visibleItemViews;


- (void) scrollByOffset: 			 (CGF)offset 	 duration: (NSTI)duration;
- (void) scrollToOffset: 			 (CGF)offset 	 duration: (NSTI)duration;
- (void) scrollByNumberOfItems: (NSI)itemCount duration: (NSTI)duration;
- (void) scrollToItemAtIndex: 	 (NSI)index 		 duration: (NSTI)duration;
- (void) scrollToItemAtIndex: 	 (NSI)index 		 animated: (BOOL)animated;
- (void) removeItemAtIndex: 		 (NSI)index 		 animated: (BOOL)animated;
- (void) insertItemAtIndex: 		 (NSI)index 		 animated: (BOOL)animated;
- (void) reloadItemAtIndex: 		 (NSI)index 		 animated: (BOOL)animated;
- (void) reloadData;

- (UIView*)	  itemViewAtIndex: (NSI)index;
- (NSI)		  indexOfItemView: (UIView*) view;
- (NSI) indexOfItemViewOrSubview: (UIView*) view;
//- (CGF)offsetForItemAtIndex: 	(NSI)index;

@end

@protocol iCarouselDataSource <NSObject>
- (NSUInteger)numberOfItemsInCarousel: (iCarousel*) carousel;
- (UIView*) carousel: (iCarousel*) carousel viewForItemAtIndex: (NSUInteger)index reusingView: (UIView*) view;
@optional
- (NSUInteger)numberOfPlaceholdersInCarousel: (iCarousel*) carousel;
- (UIView*) carousel: (iCarousel*) carousel placeholderViewAtIndex: (NSUInteger)index reusingView: (UIView*) view;
@end

@protocol iCarouselDelegate <NSObject>
@optional
- (void) carouselWillBeginScrollingAnimation: (iCarousel*) carousel;
- (void) carouselDidEndScrollingAnimation: (iCarousel*) carousel;
- (void) carouselDidScroll: (iCarousel*) carousel;
- (void) carouselCurrentItemIndexDidChange: (iCarousel*) carousel;
- (void) carouselWillBeginDragging: (iCarousel*) carousel;
- (void) carouselDidEndDragging: (iCarousel*) carousel willDecelerate: (BOOL)decelerate;
- (void) carouselWillBeginDecelerating: (iCarousel*) carousel;
- (void) carouselDidEndDecelerating: (iCarousel*) carousel;

- (BOOL) carousel: (iCarousel*) carousel shouldSelectItemAtIndex: (NSI)index;
- (void) carousel: (iCarousel*) carousel	didSelectItemAtIndex: (NSI)index;

//ALEX

- (void)carousel: (iC*) carousel shouldHoverItemAtIndex: (NSI)index;

- (CGF)carouselItemWidth: (iC*) carousel;

- (CAT3D)carousel: (iC*) carousel itemTransformForOffset: (CGF)offset
														baseTransform: (CAT3D)transform;

- (CGF)carousel: (iC*) carousel valueForOption: (iCarouselOption)option
															withDefault: (CGF)value;

@end

/**	@protocol iCarouselDeprecated
		@optional
		deprecated delegate and datasource methods use carousel:valueForOption:withDefault: instead

- (NSUInteger)numberOfVisibleItemsInCarousel: (iCarousel*) carousel;
- (void)carouselCurrentItemIndexUpdated: (iCarousel*) carousel				__attribute__((deprecated));
- (BOOL)carouselShouldWrap: (iCarousel*) carousel				__attribute__((deprecated));
- (CGF)carouselOffsetMultiplier: (iCarousel*) carousel				__attribute__((deprecated));
- (CGF)carousel: (iCarousel*) carousel itemAlphaForOffset: (CGF)offset				__attribute__((deprecated));
- (CGF)carousel: (iCarousel*) carousel valueForTransformOption: (iCarouselOption)option withDefault: (CGF)value				__attribute__((deprecated));
@end
*/
