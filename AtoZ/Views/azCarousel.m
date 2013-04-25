	//#import "azCarousel.h"
#import <AtoZ/AtoZ.h>
#import "iCarousel.h"
#define MIN_TOGGLE_DURATION 0.2f
#define MAX_TOGGLE_DURATION 0.4f
#define SCROLL_DURATION 0.4f
#define INSERT_DURATION 0.4f
#define DECELERATE_THRESHOLD 0.1f
#define SCROLL_SPEED_THRESHOLD 4.0f		//	2.0f
#define SCROLL_DISTANCE_THRESHOLD 0.1f
#define DECELERATION_MULTIPLIER 20.0f	   //5.0f   		//	30.0f

#ifdef ICAROUSEL_MACOS
#define MAX_VISIBLE_ITEMS 500 //50
#else
#define MAX_VISIBLE_ITEMS 30
#endif
@interface iCarousel ()

//- (AZTrackingWindow*)hostWindow;

- (void)layOutItemViews;
	//- (void)didScroll;

- (void) loadUnloadViews;
- (void) transformItemViews;
- (void) startAnimation;
- (void) disableAnimation;
- (void) enableAnimation;
- (NSInteger)minScrollDistanceFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
@property (nonatomic, assign) Option option;
@end
@interface NSObject  (iCarouselDelegate)
- (CATransform3D)carousel:(iCarousel *)carousel index:(NSInteger)index  baseTransform:(CATransform3D)transform;
@end

@interface iCarousel (AtoZ)
- (CGFloat)		offsetForItemAtIndex:(NSInteger)index;
- (NSInteger)	clampedIndex:(NSInteger)index;
- (CGFloat)		az_clampedOffset:(CGFloat)offset;
//- (NSInteger)	currentItemIndex;
@property (nonatomic, assign) NSInteger currentItemIndex;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) CGFloat startVelocity;
@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

@property (nonatomic, assign) NSInteger previousItemIndex;
@property (nonatomic, assign) NSTimeInterval toggleTime;
	//@property (nonatomic, assign, getter = isWrapEnabled) BOOL wrapEnabled;
@property (nonatomic, assign) CGFloat previousTranslation;
@property (nonatomic, assign) NSInteger numberOfPlaceholdersToShow;
@property (nonatomic, assign) NSInteger numberOfVisibleItems;
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat offsetMultiplier;
@property (nonatomic, assign) CGFloat startOffset;
@property (nonatomic, assign) CGFloat endOffset;

@end

	//@property (nonatomic, strong) UIView *contentView;
	//@property (nonatomic, strong) NSMutableDictionary *itemViews;
	//@property (nonatomic, strong) NSMutableSet *itemViewPool;
	//@property (nonatomic, strong) NSMutableSet *placeholderViewPool;
	//@property (nonatomic, assign) NSTimeInterval scrollDuration;
	//@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;
	//@property (nonatomic, assign) NSTimeInterval startTime;
	//@property (nonatomic, assign) CGFloat startVelocity;
	//@property (nonatomic, unsafeself.unretained) NSTimer *timer;
	//@property (nonatomic, assign, getter = isDecelerating) BOOL decelerating;
	//@property (nonatomic, assign, getter = isDragging) BOOL dragging;
	//@property (nonatomic, assign) BOOL didDrag;

	//@property (nonatomic, assign) NSInteger animationDisableCount;
@implementation iCarousel (AtoZ)

@dynamic startVelocity, 	startTime, 						scrolling, 					previousItemIndex, currentItemIndex;
@dynamic itemWidth, 		numberOfVisibleItems, 			offsetMultiplier, 			endOffset;
@dynamic startOffset, 		numberOfPlaceholdersToShow,		previousTranslation,		toggleTime;
- (AZTrackingWindow*) hostWindow {	return  (AZTrackingWindow*)[self window]; }

	//- (id)initWithFrame:(NSRect)frame {	 if ((self = [super initWithFrame:frame])) {

+ (void) load {
	
//	[$ swizzleMethod:@selector(clampedOffset:) 		in:iCarousel.class 
//					with:@selector(az_clampedOffset:) 	in:iCarousel.class];
	[$ swizzleMethod:@selector(currentItemIndex) 		in:iCarousel.class
					with:@selector(az_currentItemIndex) 	in:iCarousel.class];
}


-(void) additionalSetUp {
	/*		[NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *e) {
	 CGPoint position = [e locationInWindow];
	 position = [self convertPoint:position fromView:self.window.con];

	 //check for tapped view
	 for (UIView *view in [[[_itemViews allValues] sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))compareViewDepth context:(__bridge void *)self] reverseObjectEnumerator])
	 {
	 if ([view.layer containsPoint:position])
	 {
	 NSInteger index = [self indexOfItemView:view];
	 [_delegate carousel:self shouldHoverItemAtIndex:index];
	 break;
	 }
	 //		[self updateTrackingAreas];
	 }
	 }];*/
		//		[self setUp];
}

- (void)scrollWheel:(NSEvent *)theEvent {
		//	NSLog(@"EXTENDED!");
		//	[s]didDrag = YES;
		//	if (self.scrollEnabled)
		//	{
		//		if (!self.isDragging)
		//		{
		//			self.dragging = YES;
		//			if ([self.delegate respondsToSelector:@selector(carouselWillBeginDragging:)])
		//			{
		//				[self.delegate carouselWillBeginDragging:self];
		//			}
		//		}
		//		self.scrolling = NO;
		//		self.decelerating = NO;

//	AZWindowPosition d = [self hostWindow].position;

	CGFloat translation = (self.vertical) ? [theEvent deltaY]	: [theEvent deltaX];
		//		translation	 = d == AZPositionBottom ? translation	:
		//					   d == AZPositionLeft   ? translation	: -translation;
	CGFloat factor = 1.f;
	if (!self.wrapEnabled && self.bounces)

		factor = 1.0f - fminf(fabsf(self.scrollOffset - [self az_clampedOffset:self.scrollOffset]), self.bounceDistance) / self.bounceDistance;
	NSTimeInterval thisTime = [theEvent timestamp];
	self.startVelocity = -(translation / (thisTime - self.startTime)) * factor * self.scrollSpeed / self.itemWidth;
	self.startTime = thisTime;

	self.scrollOffset -= translation * factor * self.offsetMultiplier / self.itemWidth;
	[self disableAnimation];
	[self didScroll];
	[self enableAnimation];
}
	//}

- (void)didScroll
{
	if (self.wrapEnabled || !self.bounces)
	{
		self.scrollOffset = [self az_clampedOffset:self.scrollOffset];
	}
	else
	{
		CGFloat min = -self.bounceDistance;
		CGFloat max = fmaxf(self.numberOfItems - 1, 0.0f) + self.bounceDistance;
		if (self.scrollOffset < min)
		{
			self.scrollOffset = min;
			self.startVelocity = 0.0f;
		}
		else if (self.scrollOffset > max)
		{
			self.scrollOffset = max;
			self.startVelocity = 0.0f;
		}
	}

		//check if index has changed
	NSInteger currentIndex = roundf(self.scrollOffset);
	NSInteger difference = [self minScrollDistanceFromIndex:self.previousItemIndex toIndex:currentIndex];
	if (difference)
	{
		self.toggleTime = CACurrentMediaTime();
		self.toggle = fmaxf(-1.0f, fminf(1.0f, -(CGFloat)difference));

#ifdef ICAROUSEL_MACOS
			//		AZTrackingWindow* w = (NSWindow*)[self window];
			//		AZWindowPosition d = w.position;
			//		translation = d == AZPositionBottom ? NEG(translation)
			//				:	  d == AZPositionLeft 	? NEG(translation) :  translation;

		if (self.vertical)					//invert toggle
			self.toggle = -self.toggle;
#endif
		[self startAnimation];
	}

	[self loadUnloadViews];
	[self transformItemViews];

	if ([self.delegate respondsToSelector:@selector(carouselDidScroll:)])
	{
		[self enableAnimation];		[self.delegate carouselDidScroll:self];
		[self disableAnimation];
	}

		//notify delegate of change index
	if ([self clampedIndex:self.previousItemIndex] != self.currentItemIndex &&
		[self.delegate respondsToSelector:@selector(carouselCurrentItemIndexDidChange:)])
	{
		[self enableAnimation];		[self.delegate carouselCurrentItemIndexDidChange:self];
		[self disableAnimation];
	}
				//DEPRECATED	// if ([self clampedIndex:self.previousItemIndex] != self.currentItemIndex &&
								//	[self.delegate respondsToSelector:@selector(carouselCurrentItemIndexUpdated:)])
								//		[(id<iCarouselDeprecated>)self.delegate carouselCurrentItemIndexUpdated:self];
	//update previous index
	self.previousItemIndex = currentIndex;
}
- (CGFloat)offsetForItemAtIndex:(NSInteger)index
{
		//calculate relative position
	CGFloat offset = index - self.scrollOffset;
	if (self.wrapEnabled)
	{
		if (offset > self.numberOfItems/2)  //larger than ghjalf the view
		{
			offset -= self.numberOfItems;
		}
		else if (offset < -self.numberOfItems/2)
		{
			offset += self.numberOfItems;
		}
	}

		//handle special case for one item
	if (self.numberOfItems + self.numberOfPlaceholdersToShow == 1)
	{
		offset = 0.0f;
	}

#ifdef ICAROUSEL_MACOS

	if (self.vertical)
	{
			//invert transform
		offset = -offset;
	}

#endif

	return offset;
}

- (NSInteger)clampedIndex:(NSInteger)index
{
	if (self.wrapEnabled)
	{
		if (self.numberOfItems == 0)
		{
			return 0;
		}
		return index - floorf((CGFloat)index / (CGFloat)self.numberOfItems) * self.numberOfItems;
	}
	else
	{
		return MIN(MAX(index, 0), self.numberOfItems - 1);
	}
}

- (CGFloat)az_clampedOffset:(CGFloat)offset
{
	[self az_clampedOffset:offset];
//	LOGWARN(@"Swizzled az_clampedoff:");
	if (self.wrapEnabled)	//	if (_wrapEnabled)
	{
		return self.numberOfItems? (offset - floorf(offset / (CGFloat)self.numberOfItems) * self.numberOfItems): 0.0f;
	}
	else
	{
		return fminf(fmaxf(0.0f, offset), (CGFloat)self.numberOfItems - 1.0f);
	}
}

- (NSInteger)az_currentItemIndex
{
	NSI i = [self az_currentItemIndex];
	NSLog(@"swixxled: az_currentItemIndex");
	return [self clampedIndex:roundf(self.scrollOffset)];
}

@end
	//
	//- (void)didScroll
	//{
	//
	//
	//	if (self.wrapEnabled || !self.bounces){
	//		self.scrollOffset = - [self clampedOffset:self.scrollOffset];
	//	}	else	{
	//		CGFloat min = - self.bounceDistance;
	//		CGFloat max = fmaxf(self.numberOfItems - 1, 0.0f) + self.bounceDistance;
	//
	////		CGFloat off;
	////
	//		if (self.scrollOffset < min)
	//		{
	////			off = min;
	//				self.scrollOffset = min;
	//			self.startVelocity = 0.0f;
	//		}
	//		else if (self.scrollOffset > max)
	//		{
	////			off = max;
	//			self.scrollOffset = max;
	//			self.startVelocity = 0.0f;
	//		}
	//	}
	//
	//
	//		//check if index has changed
	//	NSInteger currentIndex = roundf(self.scrollOffset);
	//	NSInteger difference = [self minScrollDistanceFromIndex:self.previousItemIndex toIndex:currentIndex];
	////
	////	if (off >= 0.0f) {
	/////	NSLog(@"offset reported as  %f.  min %f  max  %ff.   " ,off, min, max);
	//	}
	//	if (difference)
	//	{
	//		self.toggleTime = CACurrentMediaTime();
	////		self.toggle =
	////		float dd = fmaxf(-1.0f, fminf(1.0f, -(CGFloat)difference));
	////		self.toggle =  d == AZPositionBottom ? NEG(dd)
	////					:  d == AZPositionLeft 	 ? NEG(dd) :  dd;
	//
	////#ifdef ICAROUSELself.MACOS
	//
	////		if (self.vertical)
	////		{ NSLog(@"carousel: %ld thinks it is vertical.", currentIndex);//[self propertiesPlease]);
	//				//invert toggle
	////			self.toggle = -self.toggle;
	////		}
	//
	////#endif
	//
	//		[self startAnimation];
	//	}
	//
	//	[self loadUnloadViews];
	//	[self transformItemViews];
	//
	//	if ([self.delegate respondsToSelector:@selector(carouselDidScroll:)])
	//	{
	//		[self enableAnimation];
	//		[self.delegate carouselDidScroll:self];
	//		[self disableAnimation];
	//	}
	//
	//		//notify delegate of change index
	//	if ([self clampedIndex:self.previousItemIndex] != self.currentItemIndex &&
	//		[self.delegate respondsToSelector:@selector(carouselCurrentItemIndexDidChange:)])
	//	{
	//		[self enableAnimation];
	//		[self.delegate carouselCurrentItemIndexDidChange:self];
	//		[self disableAnimation];
	//	}
	//
	////		//DEPRECATED
	////	if ([self clampedIndex:self.previousItemIndex] != self.currentItemIndex &&
	////		[self.delegate respondsToSelector:@selector(carouselCurrentItemIndexUpdated:)])
	////	{
	////		[(id<iCarouselDeprecated>)self.delegate carouselCurrentItemIndexUpdated:self];
	////	}
	//
	//		//update previous index
	//	self.previousItemIndex = currentIndex;
	//}
	//

	//- (CGFloat)offsetForItemAtIndex:(NSInteger)index
	//{
	//		//calculate relative position
	//	CGFloat offset = index - self.scrollOffset;
	////	if (_wrapEnabled)
	////	{
	//		if (offset > self.numberOfItems/2)  //larger than ghjalf the view
	//		{
	//			offset -= self.numberOfItems;
	//		}
	//		else if (offset < -self.numberOfItems/2)
	//		{
	//			offset += self.numberOfItems;
	//		}
	////	}
	//									//handle special case for one item
	//	if (self.numberOfItems + self.numberOfPlaceholdersToShow == 1)		offset = 0.0f;
	//
	//	if (self.vertical)			//invert transform
	//		offset = -offset;
	//
	//	return offset;
	//}
	//
	//- (NSInteger)clampedIndex:(NSInteger)index
	//{
	//	if (self.wrapEnabled)
	//		{		if (self.numberOfItems == 0)			{			return 0;  }
	//		return index - floorf((CGFloat)index / (CGFloat)self.numberOfItems) * self.numberOfItems;
	//	}
	//	else
	//		return MIN(MAX(index, 0), self.numberOfItems - 1);
	//}
	//
	//- (CGFloat)clampedOffset:(CGFloat)offset
	//{
	//	if (self.wrapEnabled)
	//		return self.numberOfItems? (offset - floorf(offset / (CGFloat)self.numberOfItems) * self.numberOfItems): 0.0f;
	//	else
	//		return fminf(fmaxf(0.0f, offset), (CGFloat)self.numberOfItems - 1.0f);
	//}
	//
	//- (NSInteger)currentItemIndex {	return [self clampedIndex:roundf(self.scrollOffset)];	}
	//
	//

