
#import "AZQuadObject.h"

NSString *const AZMenuPositionName[AZMenuPositionCount] = {
	[AZMenuN] = @"menu_N",
	[AZMenuS] = @"menu_S",
	[AZMenuE] = @"menu_E",
	[AZMenuW] = @"menu_W",
};

AZQuadCarousel * refToSelf;  //int cCallback()//{	//	[refToSelf someMethod:someArg];//}

//void wLog(NSString* log) { 	[refToSelf setWindowLog:log]; }

static const NSString *didScroll = @"scrollOffset";
@interface AZQuadCarousel ()

@property (nonatomic, strong) AZTrackingWindow *north, *south, *east, *west;
@property (nonatomic, strong) iCarousel *menu_N, *menu_S, *menu_E, *menu_W;
@property (nonatomic, strong) NSString *activeMenuID, *activeQuadID, *windowLog;
@property (nonatomic, strong) NSArray 	 *menus, *quads;

@end
@implementation AZQuadCarousel

- (NSMutableArray *)items {
	return _items = _items ?: [AZFolder samplerWithCount:RAND_INT_VAL(34, 55)];
//	self.southWest = _items; self.northEast = _items.reversed;
}

- (CGFloat)intrusion {	 _intrusion = AZPerimeter(AZScreenFrame()) / (self.items.count);
	if (_quads)	[_quads  do:^(AZTrackingWindow* obj) { [obj setIntrusion:_intrusion]; }];
	return _intrusion;
}
- (id) init { self = [super init];  if (self) {
	_intrusion = self.intrusion;
	self.refToSelf = self;
	self.quads =  @[
	self.north =   [AZTrackingWindow oriented: AZPositionTop 	 intruding:_intrusion], // withDelegate:self],
	self.south =   [AZTrackingWindow oriented: AZPositionBottom  intruding:_intrusion], //withDelegate:self],
	self.east  =   [AZTrackingWindow oriented: AZPositionRight 	 intruding:_intrusion],// withDelegate:self],
	self.west  =   [AZTrackingWindow oriented: AZPositionLeft 	 intruding:_intrusion] ]; // withDelegate:self] ];

//	[self addObserver:<#(NSObject *)#> forKeyPaths:<#(id<NSFastEnumeration>)#>:self forKeyPaths:@[NSApplicationDidBecomeActiveNotification, NSApplicationDidResignActiveNotification]];
	[AZNOTCENTER addObserver:self selector:@selector(applicationDidBecomeActive:) name:NSApplicationDidBecomeActiveNotification object:nil];
//	id eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSMouseEnteredMask handler:^(NSEvent *incomingEvent)
//	 {NSEvent *result = incomingEvent;
	/*NSLog(@"%i", (int)[result keyCode]);*/ //NSLog(@"%@",result);	 return result;		}];

	self.menus  =
	[@[
	self.menu_N =  [[iCarousel alloc]initWithFrame: AZMakeRectFromSize(_north.visibleFrame.size)],
	self.menu_S =  [[iCarousel alloc]initWithFrame: AZMakeRectFromSize(_south.visibleFrame.size)],
	self.menu_E =  [[iCarousel alloc]initWithFrame: AZMakeRectFromSize(_east.visibleFrame.size)],
	self.menu_W =  [[iCarousel alloc]initWithFrame: AZMakeRectFromSize(_west.visibleFrame.size)]
	]
	 arrayUsingIndexedBlock:^id(iCarousel* obj, NSUInteger idx) {

		AZTrackingWindow* w = [_quads objectAtIndex:idx];
		[w.contentView addSubview:obj];
		w.identifier 	= idx == 0 ? @"quad_N" : idx == 1 ? @"quad_S" : idx == 2 ? @"quad_E" : @"quad_W";
		obj.identifier	= idx == 0 ? @"menu_N" : idx == 1 ? @"menu_S" : idx == 2 ? @"menu_E" : @"menu_W";
		obj.type 		= 1;//iCarouselTypeCustom;  idx == 0 ? iCarouselTypeCustom : idx == 1 ? iCarouselTypeLinear : RAND_INT_VAL(0, 12);
		obj.dataSource 	= self;
		obj.delegate 	= self;
		obj.vertical 	= idx <= 1 ?  NO : YES;
		obj.scrollToItemBoundary	= YES;
		obj.stopAtItemBoundary		= YES;
		obj.centerItemWhenSelected	= YES;
		obj.bounceDistance = 20;
		obj.wantsLayer 	= YES;
		[obj.window orderFrontRegardless];
		[NSEvent addGlobalMonitorForEventsMatchingMask: NSMouseMovedMask handler:^(NSEvent *e) {
			if ( NSMouseInRect( mouseLoc(), w.triggerFrame, NO)) {  [NSApp activateIgnoringOtherApps:YES];
				[_quads az_each:^(id obj, NSUI index, BOOL *stop) {	[obj orderFrontRegardless]; }];
			}
		}];
	 return obj;
	}];	[NSApp activateIgnoringOtherApps:YES];		//	self.tilt = 0;
} return self;
	
}

			//			/* (NSStringFromPoint(  AZPointDistanceToBorderOfRect(mouseLoc(), AZScreenFrame())));  */
			//		[obj addObserver:self forKeyPath:@"dragging" options:0 context:NULL];
			//@{ @"id" : obj.identifier }
			//							addObserver:self forKeyPath:$(@"%@.scrollOffset", obj.identifier)];

			//		[self observeObject:obj.scrollOffset forName:$(@"scrollOffset", obj.identifier) calling:@selector(scrollOffsetChanged)];

			//		[obj setValuesForKeysWithDictionary:	@{		@"dataSource" : self,
			//		 @"delegate" : self,
			//		 @"vertical" : index <= 1 ?  @(NO) : @(YES),
			//		 @"type" : @(iCarouselTypeLinear) } ];

-(void) carouselDidScroll:(iCarousel *)carousel
{
//	wLog($(@"%@ scrolling! %@  %f", carousel.window.identifier, carousel.identifier, carousel.scrollOffset));
		//	NSLog(@"%@ scrolling", carousel.identifier);
		//	NSArray *fileredCars = [_menus filteredArrayUsingBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		//		return NSPointInRect(mouseLoc(), [carousel frame]) ? NO : YES;															}];
		//	[fileredCars az_each:^(iCarousel* obj, NSUInteger index, BOOL *stop) {
		//		AZWindowPosition d =	 obj.window.position;
		//		NSLog(@"setting %@ to offset: %@", [obj valueForKey:@"identifier"], @(carousel.scrollOffset));
		// 		return expression
		//		CGFloat wasoff = [obj scrollOffset];
		//		[obj scrollByOffset:carousel.scrollOffset duration:0];
		//		[obj setScrollOffset: wasoff + ];
		//	[_menus az_each:^(id obj, NSUInteger index, BOOL *stop) {
		//		AZWindowPosition d = [(AZTrackingWindow*)carousel.window position];
		//		CGFloat so = (( d == AZPositionRight) || ( d == AZPositionTop) ? carousel.scrollOffset : NEG(carousel.scrollOffset));
		//		[obj setScrollOffset:so];
		//	}];
}

-(void) carouselDidEndScrollingAnimation:(iCarousel *)carousel {
	NSLog(@"%@ didendscrolling", carousel.identifier);
}
-(void) carouselWillBeginScrollingAnimation:(iCarousel *)carousel {
	NSLog(@"%@ willbeginscrolling", carousel.identifier);

		//		self.activeMenuID = carousel.identifier;
}
- (void) applicationDidBecomeActive:(NSNotification*) note {
	[self toggleQuadFlip:nil];
	NSLog(@"Active!");
}
- (void) applicationWillFinishLaunching:(NSNotification *)notification {

		//		[self.carousel reloadData];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
	return self.items.count;
}
- (NSUInteger) numberOfPlaceholdersInCarousel:(iCarousel *)carousel
{
	return 0 ;  //( self.items.count - [(AZTrackingWindow*)carousel.window capacity] );
}

- (NSView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(NSView *)view
{
		//	NSLog(@"view reuqested by %@ for index:%ld", carousel.identifier, index );

	/**	AZTrackingWindow *t = (AZTrackingWindow*)carousel.window;
	 NSSize trkrSize		= [[t contentView] bounds].size;
	 CGFloat trkLong 	= t.orientation == AZOrientVertical ? trkrSize.height : trkrSize.width;
	 trkLong = trkLong / t.capacity;
	 NSSize dim 			= t.orientation == AZOrientVertical ? (NSSize) { _intrusion,  trkLong  }
	 : (NSSize) { trkLong, 	_intrusion };
	 if(!_fontSize) self.fontSize = [AtoZ fontSizeForAreaSize:dim withString:@"300" usingFont:@"Ubuntu Mono Bold"];
	 NSTextView *label = nil;
	 if (view == nil)	{
	 view = [[NSTextView alloc] initWithFrame: AZMakeRectFromSize(dim) ];
	 [(NSTextView*)view setBackgroundColor: RANDOMCOLOR ];

	 [(NSTextView*)view setFont:[NSFont fontWithName:@"Ubuntu Mono Bold" size:_fontSize]];
	 [(NSTextView*)view setTextColor: [[(NSTextView*)view backgroundColor] contrastingForegroundColor]];
	 }   // else//		label = (NSTextView*)[view viewWithTag:1];
	 [(NSTextView*)view setString: $(@"%@", [[self.items objectAtIndex:index] stringValue])];
	 //, [(NSColor*)[view valueForKey:@"backgroundColor"] nameOfColor])];
	 view.frame = AZMakeRectFromSize(dim);  */
	AZWindowPosition d = [(AZTrackingWindow*)carousel.window position];
		//	id flipIt =   carousel.window posi == @"menu_S"  || carousel.identifier == @"menu_W"  ? self.items.reversed[index] : self.items[index] ;
		//	 NSUInteger e;
		//	 if 	 ( d == AZPositionRight  ) 	e = ( index + _north.capacity);
		//	 else if ( d == AZPositionBottom ) 	e = ( index + _north.capacity + _east.capacity );
		//	 else if ( d == AZPositionLeft   ) 	e = ( index + _north.capacity + _east.capacity + _south.capacity) ;
		//	 else								e =   index;
		//	NSUInteger reg = e % _items.count;

		//	AZWindowPosition d = [(AZTrackingWindow*)carousel.window position];
	id item = _items[index];// = (( d == AZPositionRight) || ( d == AZPositionTop) ? _northEast[index] : _southWest[index]);

		//	else id flipper = self.items[index];
	return  view = view == nil ?
	(NSView*)[[AZQuadCell alloc]initInWindow:(AZTrackingWindow*)[carousel window] withObject:item atIndex:index] : view;

		//	//] [_items objectAtIndex:reg] atIndex:reg]

		//view.needsDisplay = YES;
		//	return view;
}
/*
 - (NSView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(NSView *)view
 {	NSLog(@"placeholder reuqested by %@ for index:%ld", carousel.identifier, index );
 NSTextView *label = nil;
 if (view == nil)	{
 view = [[NSTextView alloc] initWithFrame:AZRectFromDim(_intrusion)];
 [(NSTextView*)view setBackgroundColor: BLACK ];
 [(NSTextView*)view setTextColor:WHITE];
 }	else		label = (NSTextView*)[view viewWithTag:1];
 [(NSTextView*)view setString: $(@"%ld", index)];
 return view;
 }
	*/
/*
 -(NSUInteger)visibleItems {
 __block	NSUInteger i = 0;
 [_menus az_each:^(iCarousel *obj, NSUInteger index, BOOL *stop) {
 i += [obj visibleItemViews].count;
 }];
 return i;
 }*/

- (void)carousel:(iCarousel *)carousel  didSelectItemAtIndex:(NSInteger)index {

	AZQuadCell *v = (AZQuadCell *)[carousel itemViewAtIndex:index];

		//	self.selectedIndex = $int(index);
		//	self.activeMenu = carousel;
	self.activeQuadID = carousel.window.identifier;
	self.activeMenuID = carousel.identifier;
	self.selectedIndex = index;
	self.windowLog = $(@"%@", [v propertiesPlease]);

	CAShapeLayer *u 	= [CAShapeLayer layer];
	CALayer *x 			= [CALayer layer];
	u.frame = x.frame 	= v.layer.bounds;
	x.backgroundColor 	= cgRANDOMCOLOR;
	x.borderColor 		= cgWHITE;
	u.fillColor			= cgCLEARCOLOR;
	u.strokeColor		= cgBLACK;			// [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
	u.lineWidth			= v.dynamicStroke;
	u.lineJoin			= kCALineJoinRound;
	u.lineDashPattern	= @[ @(15), @(15) ];
	u.path				= [NSBezierPath bezierPathWithRoundedRect:NSInsetRect( v.bounds, v.dynamicStroke/2, v.dynamicStroke/2) cornerRadius:0].quartzPath;
	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
	dashAnimation.fromValue		= @(0.0f);
	dashAnimation.toValue		= @(30.0f);
	dashAnimation.duration 		= 0.75f;
	dashAnimation.repeatCount 	= 10000;
	[u addAnimation:dashAnimation forKey:@"linePhase"];
	NSRect windowrect = [v.layer convertRect:v.layer.frame fromLayer:nil];// convertRect:v.frame fromView:nil];
//	CGPoint where = [v convertPoint:v.frame.origin fromView:v.superview];// loc;// convertPoint:v.layer.origin locationInWindow fromView: nil]]);
//	where = [_gameboard convertPoint: where fromLayer:			 self.layer];
	self.windowLog = $(@"Vlayer frame = %@", NSStringFromRect(windowrect));
	CGFloat inset = AZMaxDim(v.frame.size);
	AZTrackingWindow *e = [AZTrackingWindow oriented:v.position intruding:2*inset inRect:v.layer.frame];
//						   AZRectVerticallyOffsetBy([v frame],inset)];
//	oriented:AZPositionTop intruding:60 inRect:AZRectHorizontallyOffsetBy(v.frame)];
//	NSBezierPath *p2 =[NSBezierPath bezierPathWithRoundedRect:AZLowerEdge(v.frame,25) cornerRadius:10 inCorners:(OSBottomRightCorner|OSBottomLeftCorner)];
	[v.layer addSublayers:@[x, u]];
	[v.layer needsDisplay];
	[[v window] addChildWindow:e ordered:NSWindowBelow];
	[e slideIn];
}
-(void) advance {	[_quads az_each:^(id obj, NSUInteger index, BOOL *stop) {
	[obj shiftIndexesStartingAtIndex:[obj firstIndex] by:1];
}];
}
-(void) rewind {		[_quads az_each:^(id obj, NSUInteger index, BOOL *stop) {
	[obj shiftIndexesStartingAtIndex:[obj firstIndex] by:-1];
}];
}

- (IBAction)toggleQuad:(id)sender	{

	NSString *sliderID;
	if ([sender isKindOfClass:[NSString class]]) sliderID = [sender stringValue];
	else sliderID = _activeQuadID;
	AZTrackingWindow *slider = [_quads filterOne:^BOOL(AZTrackingWindow* object) {
		return [object.identifier isEqualToString:sliderID] ? YES : NO;
	}];

	[slider cw_ARCPerformSelector:slider.slideState == AZOut ? @selector(slideIn) : @selector(slideOut)];
}
- (IBAction)toggleQuadFlip:(id)sender {

	NSString *sliderID;
	if ([sender isKindOfClass:[NSString class]]) sliderID = [sender stringValue];
	else sliderID = _activeQuadID;
	AZTrackingWindow *slider = [_quads filterOne:^BOOL(AZTrackingWindow* object) {
		return [object.identifier isEqualToString:sliderID] ? YES : NO;
	}];
	AZWindowPosition pos = slider.position;
	iCarousel *carrie = [[slider.contentView subviewsOfKind:[iCarousel class]]objectAtIndex:0];
	__block NSTimeInterval time = 0;

//	CGFloat count = carrie.numberOfItems; //increase this to make a larger circle
//	CGFloat spacing = 1.0f; // increase this to increase separation distance between items
//	CGFloat arc = M_PI * 2.0f; //reduce this if you don't want a complete circle
//
//	CGFloat radius = fmaxf(_itemWidth * spacing / 2.0f, _itemWidth * spacing / 2.0f / tanf(arc/2.0f/count));
//	CGFloat angle = offset / count * arc;
//
//	return CATransform3DTranslate(transform, radius * cos(angle) - radius, radius * sin(angle), 0.0f);
//#define DEBUGTALKER 0 
	[carrie.layer sublayersBlockSkippingSelf:^(CALayer *layer) {
		[layer  performBlock:^{
			[layer flipBackAtEdge:pos];
		} afterDelay:time];   time += .1;
	}];
//	CALayer *itsLayer = [[[slider.contentView subviewsOfKind:[iCarousel class]]objectAtIndex:0]layer];
	
//	if ([itsLayer valueForKey:@"flippedOver"]) {
//		BOOL flippedDown = [[itsLayer valueForKey:@"flippedOver"] boolValue];
//		CATransform3D = flippedDown ? CATransform3DIdentity : CATransform3DPerspective(<#t#>, <#x#>, <#y#>)
// 		if (flippedDown)	[itsLayer animate:@"bounds" toTransform:<#(CATransform3D)#> time:<#(NSTimeInterval)#> ;
//		else  				[itsLayer flipOver];  flippedDown =! flippedDown;
//		[itsLayer setValue:@(flippedDown) forKey:@"flippedOver"];
//	} else {
//		[itsLayer flipOver];
//		[itsLayer setValue:@(YES) forKey:@"flippedOver"];
//	}
}

- (IBAction)setType:(id)sender {

		//	type =	type <= 11 ? type++ : 1 ;
	self.cType =  RAND_INT_VAL(0 , 12);
	NSLog(@"setting type to : %ul", _cType);
	[_menus az_each:^(iCarousel *obj, NSUInteger index, BOOL *stop) {
		[obj setType:_cType];
		[obj reloadData];
	}];

}

//- (IBAction)setVeils:(id)sender; {
//	[_quads az_each:^(AZTrackingWindow *obj, NSUInteger index, BOOL *stop) {
//		if (! [[obj contentView]layer] ) 		[[obj contentView]setWantsLayer:YES];
//	[[[obj contentView]layer]addSublayer:
//	 [obj veilLayerForView:[[[obj contentView]subviews]lastObject]]];
//}];
//}
//		CALayer * f =  [CALayer veilForView:	[[obj contentView]layer]];
			//		f.frame  = [[obj contentView]bounds];
		/*		iCarousel *c = [[[obj contentView]subviews] filterOne:^BOOL(id object) {
		 return [object isKindOfClass:[iCarousel class]] ? YES : NO;
		 }];
		 */
			//		[f display];
			//		[obj reloadData];
	//-(AZSizer*) szrForPerimeter {
	//	return [AZSizer forQuantity:_content.count aroundRect:AZScreenFrame()];
	//}

	//- (AZSizer*)szr {
	//	return [self szrForPerimeter];
	//}
- (void) setOption:(Option)option {

	_option=option;
	[_menus az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[obj reloadData];
	}];
}
- (CATransform3D)carousel:(iCarousel *)_carousel index:(NSInteger)index  baseTransform:(CATransform3D)transform;

{
	NSLog(@"inside custom delegate");
	NSPoint now = [self.seg pointOfSegmentAtIndex:index];
	CATransform3D translate = CATransform3DMakeTranslation(now.x,now.y , 0);
	transform = CATransform3DConcat(transform, translate);
	return transform;

}
- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
	if (_option == 0) {				/*  factory linear */
		CGFloat spacing = 1;// [carousel valueForOption:iCarouselOptionSpacing withDefault:1.0f];
		return CATransform3DTranslate(transform, offset * _seg.width ,0, 0);//_itemWidth * spacing, 0.0f, 0.0f);

	}
	else if (_option == 1) 		/*	implement 'flip3D' style carousel */
	{
		transform = CATransform3DRotate(	transform, 		M_PI / 8.0f, 0.0f, 		1.0f, 			0.0f);
		return CATransform3DTranslate(		transform, 		0.0f, 		 0.0f, 		offset * carousel.itemWidth);
	}
	else if (_option == 2) 		/*	dock style effect  */
	{
		CGFloat MAX_SCALE = 1.2f; 		//	max scale of center item
		CGFloat MAX_SHIFT = 25.0f; 		// 	amount to shift items to keep spacing the same

		CGFloat shift = fminf(	1.0f, fmaxf(-1.0f, offset)	);			CGFloat scale = 1.0f + (1.0f - fabs(shift)) * (MAX_SCALE - 1.0f);

		transform = CATransform3DTranslate(		transform,		offset * carousel.itemWidth * 1.08f + shift * MAX_SHIFT,
										   0.0f,		0.0f);
		return CATransform3DScale(			transform, scale, scale, scale);
	}
	else if (_option == 3)
	{

		CGFloat distance = 200.0f; //number of pixels to move the items away from camera
		CGFloat z = - fminf(1.0f, fabs(offset)) * distance;
		return CATransform3DTranslate(transform, offset * carousel.itemWidth, 0.0f, z);
	}
	else if (_option == 4)
	{
		NSRect indentR = NSInsetRect(carousel.frame, 66, 66);
		CGFloat lenn = AZPerimeter(indentR);
		NSBezierPath *movePath = [NSBezierPath bezierPathWithRect:indentR];
			//the control point is now set to centre of the filled screen. Change this to make the path different.
			// CGPoint ctlPoint	   = CGPointMake(0.0, 0.5);
		CGPoint ctlPoint	   = CGPointMake(1024/2, 768/2);
			// This is the starting point of the animation. This should ideally be a function of the frame of the view to be animated. Hardcoded here.
			// Set here to get the accurate point..
		[movePath moveToPoint:indentR.origin];
			//The anchor point is going to end up here at the end of the animation.
			//		[movePath   addQuadCurveToPoint:CGPointMake(1024/2, 768/2) controlPoint:ctlPoint];
		CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
		moveAnim.path				= [movePath quartzPath];
		moveAnim.removedOnCompletion = YES;
			// Setup rotation animation
		CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
			//start from 180 degrees (done in 1st line)
		CATransform3D fromTransform	   = CATransform3DMakeRotation( DEG2RAD(180),0,1,0);
			//		myRotationAngle(180), 0, 1, 0);
			//come back to 0 degrees
		CATransform3D toTransform		 = CATransform3DMakeRotation(DEG2RAD(0), 0, 1, 0);
			//		myRotationAngle(0), 0, 1, 0);
			//This is done to get some perspective.
			//		CATransform3D persp1 = CATransform3DIdentity;
			//		persp1.m34 = 1.0 / -3000;
			//		fromTransform = CATransform3DConcat(fromTransform, persp1);
			//		toTransform = CATransform3DConcat(toTransform,persp1);
		rotateAnimation.toValue			 = [NSValue valueWithCATransform3D:toTransform];
		rotateAnimation.fromValue		   = [NSValue valueWithCATransform3D:fromTransform];
			//rotateAnimation.duration			= 2;
		rotateAnimation.fillMode			= kCAFillModeForwards;
		rotateAnimation.removedOnCompletion = NO;
			// Setup and add all animations to the group
		CAAnimationGroup *group = [CAAnimationGroup animation];
		[group setAnimations:@[moveAnim,rotateAnimation]];
		group.fillMode			= kCAFillModeForwards;
		group.removedOnCompletion = NO;
		group.duration			= 0.7f;
		group.delegate			= self;
			//		[group setValue:currentView forKey:kGroupAnimation];
			//		[currentView.layer addAnimation:group forKey:kLayerAnimation];	}
		CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		pathAnimation.calculationMode = kCAAnimationPaced;
		pathAnimation.fillMode = kCAFillModeForwards;
		pathAnimation.removedOnCompletion = NO;

		/*		CGMutablePathRef curvedPath = CGPathCreateMutable();
		 CGPathMoveToPoint(curvedPath, NULL, startPos.x, startPos.y);
		 CGPathAddCurveToPoint(curvedPath, NULL,	startPos.x, startPos.y - height,
		 targetPos.x, startPos.y - height, targetPos.x, targetPos.y);
		 pathAnimation.path = curvedPath;
		 CGPathRelease(curvedPath);
		 pathAnimation.duration = duration;
		 [view.layer addAnimation:pathAnimation forKey:@"curveAnimation"]; /*/
			//	return (__bridge CATransform3D)pathAnimation;
	}/* else if (_option ==5) {

			CATransform3D existing = transform;
			CATransform3D transform = CATransform3DIdentity;
			CALayer *topSleeve;
			CALayer *middleSleeve;
			CALayer *bottomSleeve;
			CALayer *topShadow;
			CALayer *middleShadow;
			NSView *mainView = [carousel ];
			CGFloat width = 300;
			CGFloat height = 150;
			CALayer *firstJointLayer;
			CALayer *secondJointLayer;
			CALayer *perspectiveLayer;

			mainView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, width, height*3)];
			mainView.backgroundColor = [NSColor yellowColor];
			[self.view addSubview:mainView];

			perspectiveLayer = [CALayer layer];
			perspectiveLayer.frame = CGRectMake(0, 0, width, height*2);
			[mainView.layer addSublayer:perspectiveLayer];

			firstJointLayer = [CATransformLayer layer];
			firstJointLayer.frame = mainView.bounds;
			[perspectiveLayer addSublayer:firstJointLayer];

			topSleeve = [CALayer layer];
			topSleeve.frame = CGRectMake(0, 0, width, height);
			topSleeve.anchorPoint = CGPointMake(0.5, 0);
			topSleeve.backgroundColor = [NSColor redColor].CGColor;
			topSleeve.position = CGPointMake(width/2, 0);
			[firstJointLayer addSublayer:topSleeve];
			topSleeve.masksToBounds = YES;

			secondJointLayer = [CATransformLayer layer];
			secondJointLayer.frame = mainView.bounds;
			secondJointLayer.frame = CGRectMake(0, 0, width, height*2);
			secondJointLayer.anchorPoint = CGPointMake(0.5, 0);
			secondJointLayer.position = CGPointMake(width/2, height);
			[firstJointLayer addSublayer:secondJointLayer];

			middleSleeve = [CALayer layer];
			middleSleeve.frame = CGRectMake(0, 0, width, height);
			middleSleeve.anchorPoint = CGPointMake(0.5, 0);
			middleSleeve.backgroundColor = [NSColor blueColor].CGColor;
			middleSleeve.position = CGPointMake(width/2, 0);
			[secondJointLayer addSublayer:middleSleeve];
			middleSleeve.masksToBounds = YES;

			bottomSleeve = [CALayer layer];
			bottomSleeve.frame = CGRectMake(0, height, width, height);
			bottomSleeve.anchorPoint = CGPointMake(0.5, 0);
			bottomSleeve.backgroundColor = [NSColor grayColor].CGColor;
			bottomSleeve.position = CGPointMake(width/2, height);
			[secondJointLayer addSublayer:bottomSleeve];

			firstJointLayer.anchorPoint = CGPointMake(0.5, 0);
			firstJointLayer.position = CGPointMake(width/2, 0);

			topShadow = [CALayer layer];
			[topSleeve addSublayer:topShadow];
			topShadow.frame = topSleeve.bounds;
			topShadow.backgroundColor = [NSColor blackColor].CGColor;
			topShadow.opacity = 0;

			middleShadow = [CALayer layer];
			[middleSleeve addSublayer:middleShadow];
			middleShadow.frame = middleSleeve.bounds;
			middleShadow.backgroundColor = [NSColor blackColor].CGColor;
			middleShadow.opacity = 0;

			transform.m34 = -1.0/700.0;
			perspectiveLayer.sublayerTransform = transform;

			CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
			[animation setDuration:2];
			[animation setAutoreverses:YES];
			[animation setRepeatCount:INFINITY];
			[animation setFromValue:[NSNumber numberWithDouble:0]];
			[animation setToValue:[NSNumber numberWithDouble:-90*M_PI/180]];
			[firstJointLayer addAnimation:animation forKey:nil];

			animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
			[animation setDuration:2];
			[animation setAutoreverses:YES];
			[animation setRepeatCount:INFINITY];
			[animation setFromValue:[NSNumber numberWithDouble:0]];
			[animation setToValue:[NSNumber numberWithDouble:180*M_PI/180]];
			[secondJointLayer addAnimation:animation forKey:nil];

			animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
			[animation setDuration:2];
			[animation setAutoreverses:YES];
			[animation setRepeatCount:INFINITY];
			[animation setFromValue:[NSNumber numberWithDouble:0]];
			[animation setToValue:[NSNumber numberWithDouble:-90*M_PI/180]];
			[bottomSleeve addAnimation:animation forKey:nil];

			animation = [CABasicAnimation animationWithKeyPath:@"bounds.size.height"];
			[animation setDuration:2];
			[animation setAutoreverses:YES];
			[animation setRepeatCount:INFINITY];
			[animation setFromValue:[NSNumber numberWithDouble:perspectiveLayer.bounds.size.height]];
			[animation setToValue:[NSNumber numberWithDouble:0]];
			[perspectiveLayer addAnimation:animation forKey:nil];

			animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
			[animation setDuration:2];
			[animation setAutoreverses:YES];
			[animation setRepeatCount:INFINITY];
			[animation setFromValue:[NSNumber numberWithDouble:perspectiveLayer.position.y]];
			[animation setToValue:[NSNumber numberWithDouble:0]];
			[perspectiveLayer addAnimation:animation forKey:nil];

			animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			[animation setDuration:2];
			[animation setAutoreverses:YES];
			[animation setRepeatCount:INFINITY];
			[animation setFromValue:[NSNumber numberWithDouble:0]];
			[animation setToValue:[NSNumber numberWithDouble:0.5]];
			[topShadow addAnimation:animation forKey:nil];

			animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
			[animation setDuration:2];
			[animation setAutoreverses:YES];
			[animation setRepeatCount:INFINITY];
			[animation setFromValue:[NSNumber numberWithDouble:0]];
			[animation setToValue:[NSNumber numberWithDouble:0.5]];
			[middleShadow addAnimation:animation forKey:nil];
		}
			//		if (carousel.identifier != AZMenuPositionName[AZMenuN] ) return transform;
			//		else {

			//			CGFloat MAX_SCALE = 1.2f; //max scale of center item
			//			CGFloat MAX_SHIFT = 25.0f; //amount to shift items to keep spacing the same
			//
			//			CGFloat shift = fminf(1.0f, fmaxf(-1.0f, offset));
			//			CGFloat scale = 1.0f + (1.0f - fabs(shift)) * (MAX_SCALE - 1.0f);
			//			transform = CATransform3DTranslate(transform, offset * carousel.itemWidth * 1.08f + shift * MAX_SHIFT, 0.0f, 0.0f);
			//			return CATransform3DScale(transform, scale, scale, scale);

			//		NSRect indentR = NSInsetRect(carousel.frame, 66, 66);
			//		CGFloat lenn = AGPerimeter(indentR);
			//		NSUInteger t = _carousel.numberOfItems;
			//		hUnit = lenn / t;

	} */ else return  transform;
}

	//		//implement 'flip3D' style carousel
	//	transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
	//	return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
	//}

	//- (CGFloat)carousel:(iCarousel *)someCarousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
	////	NSString *unique 	= someCarousel.identifier;
	////	BOOL vertical  		= someCarousel.vertical;

	//	switch (option)
	//	{
	////		case 	iCarouselOptionWrap:
	////			return 	YES;
	////		case 	iCarouselOptionVisibleItems: {
	//////			NSUInteger s = _carousel.currentItemIndex.
	////			return 466;//value;// _items.count;// [(AZTrackingWindow*)someCarousel.window capacity];
	////		}//floor(_carousel.frame.size.height / _intrusion) \
	//							: floor(_carousel.frame.size.width  / _intrusion);

	////		This is the maximum number of item views (including placeholders) that should be visible in the carousel at once. Half of this number of views will be displayed to either side of the currently selected item index. Views beyond that will not be loaded until they are scrolled into view. This allows for the carousel to contain a very large number of items without adversely affecting performance. iCarousel chooses a suitable default value based on the carousel type, however you may wish to override that value using this property (e.g. if you have implemented a custom carousel type).

	////		case iCarouselOptionWrap:
	////			return value;/// return YES;
	////		case iCarouselOptionSpacing:
	////
	////			return value;// * 1.05f;
	//		default:
	//			return value;
	//	}
	//}
	//	[_menu_N setValuesForKeysWithDictionary:@ { @"windowPosition" : @(AZPositionTop),
	//		@"vertical" : @(NO)} ];

	//	[_car1 setValue:AZPositionLeft]	 :	if (remainder > 1) base++;	break;
	//		case AZQuadRight :	if (remainder > 2) base++;  break;
	//		default			 :	if (remainder > 3) base++;	break;
	//[self observeName:@"content" usingBlock:^(NSNotification *m) {
	//		_content = self.content;
	//		[_menu_N reloadData];
	//	}];
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {

		//	if ([keyPath isEqual:@"scrollOffset"]) {
	NSLog(@"notified...  KP:%@ ", keyPath);
	NSLog(@" obhj: %@::", object);
		//		[openingBalanceInspectorField setObjectValue:
		//		 [change objectForKey:NSKeyValueChangeNewKey]];
		//	}
	/*
	 Be sure to call the superclass's implementation *if it implements it*.
	 NSObject does not implement the method.
	 */
		//	[super observeValueForKeyPath:keyPath
		//						 ofObject:object
		//						   change:change
		//						  context:context];
}

	//	if (context == DotViewUndoAndRedisplay) {
	//		NSUndoManager *undoManager = [[self window] undoManager];
	//		if ([keyPath isEqual:@"center"]) [[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];
	//		else if ([keyPath isEqual:@"radius"]) [[undoManager prepareWithInvocationTarget:self] setRadius:[[change objectForKey:NSKeyValueChangeOldKey] doubleValue]];
	//		else if ([keyPath isEqual:@"color"]) [undoManager registerUndoWithTarget:self selector:@selector(setColor:) object:[change objectForKey:NSKeyValueChangeOldKey]];
	//	if ([keyPath isEqual:@"multiplier"]) {
	//	if ([keyPath isEqual:@"desiredNumberOfColumns"]) {
	//	[[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];

	//- (void)setContent:(NSMutableArray *)content
	//{
	//	_content = content;
	//	NSLog(@"set content: %@", _content);
	// 	[ _menus az_each:^(id obj, NSUInteger index, BOOL *stop) {
	//		[obj reloadData];
	//	}];
	//}
	//- (NSUInteger)	total {	return _content.count;	}

- (NSUInteger) 	itemsInQuad:		 (AZWindowPosition)		quadrant;	{

	NSUInteger base, remainder;	base = ceil( _items.count / 4 );		remainder  	= _items.count % 4;

	switch (quadrant) {		case AZPositionTop	  :	if (remainder > 0) base++;	break;
		case AZPositionRight  :	if (remainder > 1) base++;	break;
		case AZPositionBottom :	if (remainder > 2) base++;  break;
		default				  :	if (remainder > 3) base++;	break;
	}	return base;
}
	//	return 	(carousel == _menu_N) ? ( self.total - [self itemsInQuad: AZPositionTop]	)
	//	:  carousel  == _menu_S  ? ( self.total - [self itemsInQuad: AZPositionBottom]	)
	//	:  carousel  == _menu_E  ? ( self.total - [self itemsInQuad: AZPositionLeft]	)
	//	: 					  		( self.total - [self itemsInQuad: AZPositionRight]	);

	//- (NSView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(NSView *)view {

- (void)carousel:(iCarousel *)carousel shouldHoverItemAtIndex:(NSInteger)index{
	/*	NSView *v = [carousel itemViewAtIndex:index];
	 AZLassoView *lassie = [v.allSubviews filterOne:^BOOL(id object) {
	 return  ([object isKindOfClass:[AZLassoView class]] ? YES : NO);
	 }];
	 lassie.hovered = YES;
	 [[[carousel allSubviews] filter:^BOOL(id object) {

	 if ([object isEqualTo:lassie]) return  NO;
	 else if ([object isKindOfClass:[AZLassoView class]]) return YES;
	 else return NO;
	 }] az_each:^(AZLassoView* obj, NSUInteger index, BOOL *stop) {
	 obj.hovered = NO;
	 }];
	 */
}


#pragma mark - iCarousel methods
/* - (NSView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(NSView *)view {

 NSLog(@"view reuqested by %@ for index:%ld", carousel.identifier, index );
 //create new view if no view is available for recycling
 if (view == nil)	{

 CALayer *root = [CALayer layer];
 view = [[AZSimpleView alloc]initWithFrame:(NSRect){0,0,100,100}];
 //AZMakeRectFromSize( AZSizeFromDimension(399))];//AZMinDim([carousel bounds].size)))];
 [view setValue: RANDOMCOLOR forKey:@"backgroundColor"]; // [[[_content objectAtIndex: index] valueForKey:@"color"]CGColor];
 //		root.contents 			= [[_content objectAtIndex: index] valueForKey:@"image"];
 //		root.frame 	  			= [view bounds];
 //		root.delegate 			= self;
 //		shape.name =  @"lasso";
 //		[root addSublayer:shape];
 //		view.layer   = root;
 //		view.wantsLayer = YES;
 }
 NSLog(@"returning: %@", NSStringFromRect([view frame]));
 return view;
 }	*/
	//	NSTextField *label = nil;

	//		//create new view if no view is available for recycling
	//	if (view == nil)	{
	//		NSImage *image = [NSImage az_imageNamed:@"2.pdf"];
	//	   	view = [[[NSImageView alloc] initWithFrame:NSMakeRect(0,0,image.size.width,image.size.height)] autorelease];
	//		[(NSImageView *)view setImage:image];
	//		[(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
	//		label = [[[NSTextField alloc] init] autorelease];
	//		[label setBackgroundColor:[NSColor clearColor]];
	//		[label setBordered:NO];
	//		[label setSelectable:NO];
	//		[label setAlignment:NSCenterTextAlignment];
	//		[label setFont:[NSFont fontWithName:[[label font] fontName] size:50]];
	//		label.tag = 1;
	//		[view addSubview:label];
	//	}	else				//get a reference to the label in the recycled view
	//		label = (NSTextField *)[view viewWithTag:1];
	//		//set item label   			remember to always set any properties of your carousel item views outside of the `if (view == nil) {...}` check otherwise you'll get weird issues with carousel item content appearing  in the wrong place in the carousel
	//	[label setStringValue:(index == 0)? @"[": @"]"];
	//	[label sizeToFit];
	//	[label setFrameOrigin:(NSPoint){(view.bounds.size.width - label.frame.size.width)/2.0,	((view.bounds.size.height - label.frame.size.height)/2.0)}];

	//	return view;
	//}


	//- (CGFloat)carouselItemWidth:(iCarousel *)carousel
	//{
	//		//set correct view size
	//		//because the background image on the views makes them too large
	//}

	//- (void)carouselDidScroll:(iCarousel *)carousel {
	////	if (carousel == carousel)
	////	{
	//			//adjust perspective for inner carousels
	//			//every time the outer carousel is moved
	//			//for 2D carousel styles this wouldn't be neccesary
	//		for (iCarousel *subCarousel in _carousel.visibleItemViews)
	//		{
	//			NSInteger index = subCarousel.tag;
	//			CGFloat offset = [_carousel offsetForItemAtIndex:index];
	//			subCarousel.viewpointOffset = CGSizeMake(-offset * _carousel.itemWidth, 0.0f);
	//			subCarousel.contentOffset = CGSizeMake(-offset * _carousel.itemWidth, 0.0f);
	//		}
	//	}
	//	else if (SYNCHRONIZE_CAROUSELS)
	//	{
	//			//synchronise inner carousel scroll offsets each time any
	//			//of the inner carousels is moved - if you don't want this
	//			//you can turn it off, but then you'd need to keep track of
	//			//the scroll state for each carousel when they are loaded/unloaded
	//		for (iCarousel *subCarousel in _carousel.visibleItemViews)
	//		{
	//			subCarousel.scrollOffset = carousel.scrollOffset;
	//		}
	//	}
	//}

- (void) setTilt:(NSUInteger)tilt {

	_tilt = tilt;
	[_menus  az_each:^(id obj, NSUInteger index, BOOL *stop) {
		[obj reloadData];
	}];
}
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
	switch (option)
	{

		case 	iCarouselOptionVisibleItems: 		return self.items.count;

		case 	iCarouselOptionOffsetMultiplier:	return 	value;  //self.multi;  return 4;// 	RAND_INT_VAL(0,5);).multi;//value;
																	//		The offset multiplier to use when the user drags the carousel with their finger. It does not affect programmatic scrolling or deceleration speed. This defaults to 1.0 for most carousel types, but defaults to 2.0 for the CoverFlow-style carousels to compensate for the fact that their items are more closely spaced and so must be dragged further to move the same distance.

		case 	iCarouselOptionCount:  				return value;
				//		The number of items to be displayed in the Rotary, Cylinder and Wheel transforms. Normally this is calculated automatically based on the view size and number of items in the carousel, but you can override this if you want more precise control of the carousel appearance. This property is used to calculate the carousel radius, so another option is to manipulate the radius directly. //  [[AtoZ dockSorted] count];//);RAND_INT_VAL(3,

		case 	iCarouselOptionWrap:				return 	YES;//RAND_BOOL();

				//		boolean indicating whether the carousel should wrap when it scrolls to the end. Return YES if you want the carousel to wrap around when it reaches the end, and NO if you want it to stop. Generally, circular carousel types will wrap by default and linear ones won't. Don't worry that the return type is a floating point value - any value other than 0.0 will be treated as YES.

		case 	iCarouselOptionSpacing:				return 1;//	RAND_FLOAT_VAL(0, 2*self.carousel.itemWidth);//.space;
															 // 		The spacing between  item views. This value is multiplied by the item width (or height, if the carousel is vertical) to get the total space between each item, so a value of 1.0 (the default) means no space between views (unless the views already include padding, as they do in many of the example projects).	 // 	Reduce item spacing to compensate for drop shadow and reflection around views

		case	iCarouselOptionShowBackfaces:		return  YES;
				//		For some carousel types, e.g. iCarouselTypeCylinder, the rear side of some views can be seen (iCarouselTypeInvertedCylinder now hides the back faces by default). If you wish to hide the backward-facing views you can return NO for this option. To override the default back-face hiding for the iCarouselTypeInvertedCylinder, you can return YES. This option may also be useful for custom carousel transforms that cause the back face of views to be displayed.

		case	iCarouselOptionArc:					return value;				//			return 	RAND_FLOAT_VAL(.3, 2*M_PI);
																				//		The arc of the Rotary, Cylinder and Wheel transforms (in radians). Normally this defaults to 2*M_PI (a complete circle) but you can specify a smaller value, so for example a value of M_PI will create a half-circle or cylinder. This property is used to calculate the carousel radius and angle step, so another option is to manipulate those values directly.

		case	iCarouselOptionAngle:				return 	value;
				//		The angular step between each item in the Rotary, Cylinder and Wheel transforms (in radians). Manipulating this value without changing the radius will cause a gap at the end of the carousel or cause the items to overlap.

		case	iCarouselOptionRadius:				return 	value;
				//		The radius of the Rotary, Cylinder and Wheel transforms in pixels/points. This is usually calculated so that the number of visible items exactly fits into the specified arc. You can manipulate this value to increase or reduce the item spacing (and the radius of the circle).

		case	iCarouselOptionTilt:				return 	self.tilt;
				//		The tilt applied to the non-centered items in the CoverFlow, CoverFlow2 and TimeMachine carousel types. This value should be in the range 0.0 to 1.0.

		case 	iCarouselOptionFadeMax:				return 	value;		case	iCarouselOptionFadeMin:				return 	value;
		case	iCarouselOptionFadeRange:			return 	value;
				// These three options control the fading out of carousel item views based on their offset from the currently centered item. FadeMin is the minimum negative offset an item view can reach before it begins to fade. FadeMax is the maximum positive offset a view can reach before if begins to fade. FadeRange is the distance the item can move between the point at which it begins to fade and the point at which it becomes completely invisible.   		//	if (self.carousel.type == iCarouselTypeCustom)	return1.0f;				 //set opacity based on distance from camera

		default:									return 	value;
	}
}



/*		//	if (!view) {
 _iconStyle = RAND_INT_VAL(1, 3);
 if (view == nil)	 //create new view if no view is available for recycling
 {
 AZFile* f = [[AtoZ fengShui]objectAtIndex:index];   NSColor *c = f.color;
 if (!c) c = [[NSColor fengshui] objectAtIndex:index]; // { 		NSLog(@"no colore! reload! (idx:%ld)",index); [carousel reloadData]; }
 NSLog(@"view nil, making it (idx:%ld), again", index);
 NSImage *ico = 	f.image;
 if (!ico) ico = [[[NSImage systemImages]randomElement]imageScaledToFitSize:AZSizeFromDimension(214)];
 //			NSSize icosize = AZSizeFromDimension(self.size);
 //			NSRect icorect = AZSquareFromLength(self.size);
 NSString *desc = $(@"%@: %ld",[[[AtoZ fengShui]objectAtIndex:index]valueForKey:@"name"], index);
 NSImage *swatch = [NSImage swatchWithGradientColor:c size:ico.size];
 NSMutableParagraphStyle *theStyle =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
 [theStyle setLineBreakMode:NSLineBreakByWordWrapping];
 [theStyle setAlignment:NSCenterTextAlignment];
 switch (_iconStyle) {
 case 1: {
 //		if (c) image = [image tintedWithColor:c];

 //[self carouselItemWidth:_carousel], _carousel.frame.size.height)];
 [swatch lockFocus];
 [NSShadow setShadowWithOffset:AZSizeFromDimension(6) blurRadius:10 color:c.contrastingForegroundColor];
 [[ico filteredMonochromeEdge] drawCenteredinRect:AZMakeRectFromSize(ico.size) operation:NSCompositeSourceOver fraction:1];
 [NSShadow clearShadow];
 [desc drawAtPoint:NSZeroPoint withAttributes:@{ NSParagraphStyleAttributeName: theStyle, NSForegroundColorAttributeName: WHITE, NSFontSizeAttribute: @55 } ];
 [swatch unlockFocus];
 swatch = [swatch addReflection:.5];
 view = [[NSImageView alloc] initWithFrame:AZMakeRectFromSize(swatch.size)];
 view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
 [(NSImageView *)view setImage:swatch];
 [(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
 break;
 }
 case 2: {
 //		if (c) image = [image tintedWithColor:c];
 //[self carouselItemWidth:_carousel], _carousel.frame.size.height)];
 [swatch lockFocus];
 [ico drawInRect:AZMakeRectFromSize(ico.size) fromRect:NSZeroRect operation:NSCompositeDestinationIn fraction:1];
 //	[[ico filteredMonochromeEdge] drawCenteredinRect:icorect
 // AZRightEdge(AZUpperEdge(icorect, 40), 40)
 operation:NSCompositeDestinationIn fraction:1];
 //	[[ico filteredMonochromeEdge] drawCenteredinRect:AZRightEdge(AZUpperEdge(icorect, 40), 40) operation:NSCompositeSourceOver fraction:1];
 NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: desc.firstLetter attributes:@{ NSFontAttributeName: [NSFont fontWithName:@"Ubuntu Mono Bold" size:190],
 NSForegroundColorAttributeName :WHITE} ];
 //			[theStyle setLineSpacing:12];
 //			NSTextView *atv = [[NSTextView alloc]initWithFrame:NSInsetRect([self bounds],3,3)];
 //			[atv setDefaultParagraphStyle:theStyle];
 //			[atv setBackgroundColor:CLEAR];
 //			[[atv textStorage] setForegroundColor:BLACK];
 //			[[atv textStorage] setAttributedString:string];
 [NSShadow setShadowWithOffset:AZSizeFromDimension(3) blurRadius:10 color:c.contrastingForegroundColor];
 [string drawAtPoint:NSMakePoint(10,8)];
 [NSShadow clearShadow];
 //			[string drawAtPoint:NSZeroPoint withAttributes:@{ NSParagraphStyleAttributeName: style, NSForegroundColorAttributeName: WHITE, NSFontSizeAttribute: @200 } ];// withAttributes:att];
 [swatch unlockFocus];
 swatch = [swatch addReflection:.5];
 view = [[NSImageView alloc] initWithFrame:AZMakeRectFromSize(swatch.size)];
 //			view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
 [(NSImageView *)view setImage:swatch];
 //			[(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
 break;
 }
 case 3:
 default: {
 //		if (c) image = [image tintedWithColor:c];

 //[self carouselItemWidth:_carousel], _carousel.frame.size.height)];
 [swatch lockFocus];
 [NSShadow setShadowWithOffset:AZSizeFromDimension(6) blurRadius:10 color:BLACK];
 [[ico filteredMonochromeEdge] drawInRect:AZMakeRectFromSize(ico.size) fromRect:NSZeroRect operation:NSCompositeDestinationIn fraction:1];
 //			[[ico coloredWithColor:c.contrastingForegroundColor] drawCenteredinRect:icorect operation:NSCompositeSourceOver fraction:1];
 [NSShadow clearShadow];
 [desc drawAtPoint:NSZeroPoint withAttributes:@{ NSParagraphStyleAttributeName: theStyle, NSForegroundColorAttributeName: WHITE, NSFontSizeAttribute: @55 } ];
 [swatch unlockFocus];
 swatch = [swatch addReflection:.5];
 view = [[NSImageView alloc] initWithFrame:AZMakeRectFromSize(swatch.size)];
 view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
 [(NSImageView *)view setImage:swatch];
 [(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
 break;
 }
 }
 AZLassoView *b = [[AZLassoView alloc]initWithFrame:AZUpperEdge(view.frame, 200)];
 [view addSubview:b];

 //		}
 }
 [view setNeedsDisplay:YES];
 return view;
	*/
	//}
	//don't do anything specific to the index within
	//this `if (view == nil) {...}` statement because the view will be
	//recycled and used with other index values later
/*		NSImage *image = [NSImage az_imageNamed:@"4.pdf"];
 view = [[[NSImageView alloc] initWithFrame:NSMakeRect(0,0,image.size.width,image.size.height)] autorelease];
 [(NSImageView *)view setImage:image];
 [(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];

 label = [[[NSTextField alloc] init] autorelease];
 [label setBackgroundColor:[NSColor clearColor]];
 [label setBordered:NO];
 [label setSelectable:NO];
 [label setAlignment:NSCenterTextAlignment];
 [label setFont:[NSFont fontWithName:[[label font] fontName] size:50]];
 label.tag = 1;
 [view addSubview:label];	*/

/*	else
 {
 //get a reference to the label in the recycled view
 label = (NSTextField *)[view viewWithTag:1];
 }

 //set item label
 //remember to always set any properties of your carousel item
 //views outside of the `if (view == nil) {...}` check otherwise
 //you'll get weird issues with carousel item content appearing
 //in the wrong place in the carousel
 [label setStringValue:[NSString stringWithFormat:@"%lu", index]];
 [label sizeToFit];
 [label setFrameOrigin:NSMakePoint((view.bounds.size.width - label.frame.size.width)/2.0,
 (view.bounds.size.height - label.frame.size.height)/2.0)];	*/


	//	u.backgroundColor = cgCLEARCOLOR;
	//	u.path = [[NSBezierPath bezierPathWithRoundedRect:[v frame] cornerRadius:0] quartzPath];
	//	u.borderColor = cgRANDOMCOLOR;
	////	u.borderWidth = 10;
	//	u.lineWidth = 10;
	//
	//	u.lineJoin		= kCALineJoinRound;
	//	[u setLineDashPattern : @[ @(10), @(5) ]];
	//	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
	//	[dashAnimation setValuesForKeysWithDictionary:@{ 	@"fromValue":@(0.0), 	@"toValue"	   :@(15.0),
	//	 @"duration" : @(0.75),	@"repeatCount" : @(10000) }];
	//	[u addAnimation:dashAnimation forKey:@"linePhase"];

	//
	//	CAShapeLayer *l = [[v.layer sublayers]filterOne:^BOOL(id object) {
	//		return [[object valueForKey:@"name"] isEqualToString:@"lasso"] ? YES : NO;
	//	}];
	//	l = [self lassoLayerForLayer:v.layer];
	//	l.frame = v.layer.bounds;
	//	NSLog(@"Get A Rope... %@", v.layer.debugLayerTree);//.propertiesPlease);
	//	[v.layer addSublayer:rope];

	//	[AtoZiTunes searchForFile:[[AtoZ currentScope]objectAtIndex:index]];
	// [[[AtoZ dockSorted]objectAtIndex:index]valueForKey:@"name"]];
	//	NSLog(@"response: %@", r);
	//	NSLog(@"selected allsubvs: %@", v.allSubviews);

/**  NSVIEW lasso
 AZLassoView *lassie = [carousel.allSubviews filterOne:^BOOL(id object) {
 return  ([object isKindOfClass:[AZLassoView class]] ? YES : NO);
 }];
 lassie.selected= YES;
 [[[carousel allSubviews] filter:^BOOL(id object) {

 if ([object isEqualTo:lassie]) return  NO;
 else if ([object isKindOfClass:[AZLassoView class]]) return YES;
 else return NO;
 }] az_each:^(AZLassoView* obj, NSUInteger index, BOOL *stop) {
 obj.selected = NO;
 }];

 //	self.attacheView = [AZBlockView viewWithFrame:AZSquareFromLength(200)  opaque:YES drawnUsingBlock: ^(AZBlockView *view, NSRect dirtyRect) {
 //		NSBezierPath *path = [NSBezierPath bezierPathWithRect:[view bounds]];
 //		[RANDOMCOLOR set];
 //		[path fill];
 //	}];
 //
 //
 //	self.attache = [[AZAttachedWindow alloc] initWithView:self.attacheView attachedToPoint:AZCenterOfRect(lassie.frame)];
 //	[_attache setLevel:NSFloatingWindowLevel];
 //	[_attache orderFrontRegardless];

 //	[ attachedToPoint:  attachedToPoint: AZCenteredRect( [[_carousel itemViewAtIndex:index]frame]) inWindow:[self.carousel window] onSide:AZPositionBottom atDistance:0];
 //	[[_carousel window]
 //	[addChildWindow:_attache ordered:NSWindowAbove];

 //	[_attache makeKeyAndOrderFront:_attache];
 //	NSString *url = $(@"http://api.alternativeto.net/software/%@/?count=5&platform=mac", [[[AtoZ dockSorted]objectAtIndex:index]valueForKey: @"name"]);// urlEncoded];

 //	NSLog(@"%@", [AtoZ jsonReuest:url]);

 //	AZBox *b = [[AZBox alloc]initWithFrame:v.frame];
 //	[v addSubview:b];
 //	[b setSelected:YES];
 //	[b setHovered:YES];
 //	[v setNeedsDisplay:YES];	*/
/*
 - (NSA*) allItems {
 //	__block	NSMutableArray *i = [NSMutableArray array];
 //	[_quads az_each:^(id obj, NSUInteger index, BOOL *stop) {
 //		[i addObjectsFromArray:obj];
 //	}];
 return [_quadContent arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
 return [_quadContent objectAtNormalizedIndex:_externalZeroIndex + idx];
 }];
 //	i.copy;
 }

 -(NSA*)itemsinQuad:(AZQuad)quadrant;{
 NSUInteger ct = [self itemsInQuad:quadrant];
 NSUInteger first = [self _firstIndexInQuad:quadrant];
 NSUInteger firstadjusted = first + _externalZeroIndex;
 NSUInteger firstadjustedEnd = first + ct;
 return [[@(firstadjusted) to:@(firstadjustedEnd)] arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {

 return  [_quadContent objectAtNormalizedIndex:[obj intValue]];
 }];
 //	NSMutableArray *q = [self quadForType:quadrant];
 //	return q.copy;
 //	 [_quadContent subarrayFromIndex:q.firstIndex toIndex:q.lastIndex];
 }
 -(NSRange) forQuad:(AZQuad) quadrant {

 }
 -(void)insertItems:(NSA*)items{


 }

 -(void)insertItem:(id)item;{

 //	NSUInteger last = [_quadContent count];
 //	[_quadContent addObject:item];
 //	[_quads enumerateObjectsUsingBlock:^(NSMutableIndexSet* obj, NSUInteger idx, BOOL *stop) {
 //		if ([obj containsIndex:last]) [obj addIndex:[_quadContent count]];
 //
 //	}];
 }
 - (NSUInteger) _firstIndexInQuad :(AZQuad)quadrant {

 NSUInteger start =  0;
 if (quadrant == AZQuadLeft) return  start;
 start += [self itemsInQuad:AZQuadLeft];
 if (quadrant == AZQuadTop) return  start;
 start += [self itemsInQuad:AZQuadTop];
 if (quadrant == AZQuadRight) return  start;
 start += [self itemsInQuad:AZQuadRight];
 return start;

 }

 -(void)removeItem:(id)item;{

 }
 -(void)removeItems:(NSA*)items;{

 }

 -(id) objectAtIndex:(NSUInteger)index {
 //		NSMutableIndexSet

 }
 -(id) objectAtIndex:(NSUInteger)index inQuad:(AZQuad)quadrant {

 NSMutableArray *q = [self quadForType:quadrant];
 return  [q objectAtIndex:index];
 }	*/

/*	self.window = [[NSWindow alloc]initWithContentRect:
 NSInsetRect([[NSScreen mainScreen]frame],200,200) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered  defer:NO];

 NSImageView *backgroundView = [[NSImageView alloc] initWithFrame:[[_window contentView] bounds]];
 backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
 [backgroundView setImageScaling:NSImageScaleAxesIndependently];
 backgroundView.image = 	[NSImage az_imageNamed:@"3.pdf"];

 [_window.contentView addSubview:backgroundView];
 self.carousel = [[iCarousel alloc] initWithFrame:[[_window contentView] bounds]];
 _carousel.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
 _carousel.type = iCarouselTypeCoverFlow;
 [self.carousel setDelegate : self ];
 [self.carousel setDataSource : self];
 [self.carousel setWantsLayer:YES];
 //add carousel to view
 [[self.window contentView] addSubview:self.carousel];	*/
@end
