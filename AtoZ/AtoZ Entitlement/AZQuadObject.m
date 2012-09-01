
#import "AZQuadObject.h"



	//NSString *const FormatTypeName[FormatTypeCount] = {
	//	[JSON] = @"JSON",
	//	[XML] = @"XML",
	//	[Atom] = @"Atom",
	//	[RSS] = @"RSS",
	//};

NSString *const AZMenuPositionName[AZMenuPositionCount] = {
	[AZMenuN] = @"menu_N",
	[AZMenuS] = @"menu_S",
	[AZMenuE] = @"menu_E",
	[AZMenuW] = @"menu_W",
};

AZQuadCarousel * refToSelf;
	//int cCallback()
	//{
	//    [refToSelf someMethod:someArg];
	//}

void wLog(NSString* log) {
	[refToSelf setWindowLog:log];
}


static const NSString *didScroll = @"scrollOffset";

@implementation AZQuadCarousel


- (NSMutableArray *)items { 	if  ( _items == nil ) _items = [AtoZ appFolderSamplerWith:RAND_INT_VAL(34, 55)].mutableCopy;
	self.southWest = _items;
	self.northEast = _items.reversed;
	return  _items;
}

- (CGFloat)intrusion {

	_intrusion = AZPerimeter(AZScreenFrame()) / (self.items.count);
	if (_quads) [_quads each:^(AZTrackingWindow* obj, NSUInteger index, BOOL *stop) {
		[obj setIntrusion:_intrusion];
	}];
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
	

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:NSApplicationDidBecomeActiveNotification object:nil];


		//	id eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:NSMouseEnteredMask handler:^(NSEvent *incomingEvent)
		//	 {		NSEvent *result = incomingEvent;		/*NSLog(@"%i", (int)[result keyCode]);*/ NSLog(@"%@",result);	 return result;		}];

	self.menus  = @[
	self.menu_N =  [[iCarousel alloc]initWithFrame: AZMakeRectFromSize(_north.visibleFrame.size)],
	self.menu_S =  [[iCarousel alloc]initWithFrame: AZMakeRectFromSize(_south.visibleFrame.size)],
	self.menu_E =  [[iCarousel alloc]initWithFrame: AZMakeRectFromSize(_east.visibleFrame.size)],
	self.menu_W =  [[iCarousel alloc]initWithFrame: AZMakeRectFromSize(_west.visibleFrame.size)] ];
	

	[ _menus each:^(iCarousel * obj, NSUInteger idx, BOOL *go) {
		AZTrackingWindow* w = [_quads objectAtIndex:idx];
		[[w contentView] addSubview:obj];
		[w setIdentifier: 	idx == 0 ? @"quad_N" : idx == 1 ? @"quad_S" : idx == 2 ? @"quad_E" : @"quad_W"];
		[obj setIdentifier: idx == 0 ? @"menu_N" : idx == 1 ? @"menu_S" : idx == 2 ? @"menu_E" : @"menu_W"];

		[NSEvent addGlobalMonitorForEventsMatchingMask: AZMouseActive  handler:^(NSEvent *e) {
			BOOL activated = NSMouseInRect(mouseLoc(), w.triggerFrame, NO);
			if (activated) { [NSApp activateIgnoringOtherApps:YES];
				[_quads each:^(id obj, NSUInteger index, BOOL *stop) {
					[obj orderFrontRegardless];
				}];
			}
				//			NSLog(@"mousein rect: %@      :%@", StringFromBOOL(,
				//			 w.identifier);
		}];


			//			/* (NSStringFromPoint(  AZPointDistanceToBorderOfRect(mouseLoc(), AZScreenFrame())));  */
		self.tilt = 0;
		[obj setDataSource : self];
		[obj setDelegate : self];
		[obj setVertical : idx <= 1 ?  NO : YES];
		[obj setType : idx == 0 ? iCarouselTypeCustom : idx == 1 ? iCarouselTypeLinear : RAND_INT_VAL(0, 12)];
		[obj setScrollToItemBoundary : YES];
		[obj setStopAtItemBoundary:YES];
		[obj setCenterItemWhenSelected:NO];
			//		[obj setHidden:YES];
		[obj setWantsLayer:YES];
		[[obj window] orderFrontRegardless];
			//		[obj addObserver:self forKeyPath:@"dragging" options:0 context:NULL];
			//@{ @"id" : obj.identifier }
			//						    addObserver:self forKeyPath:$(@"%@.scrollOffset", obj.identifier)];

			//		[self observeObject:obj.scrollOffset forName:$(@"scrollOffset", obj.identifier) calling:@selector(scrollOffsetChanged)];

			//		[obj setValuesForKeysWithDictionary:	@{		@"dataSource" : self,
			//		 @"delegate" : self,
			//		 @"vertical" : index <= 1 ?  @(NO) : @(YES),
			//		 @"type" : @(iCarouselTypeLinear) } ];

	}];
	[NSApp activateIgnoringOtherApps:YES];


} return self;

}

-(void) carouselDidScroll:(iCarousel *)carousel
{
	wLog($(@"%@ scrolling! %@  %f", carousel.window.identifier, carousel.identifier, carousel.scrollOffset));
		//	NSLog(@"%@ scrolling", carousel.identifier);
		//	NSArray *fileredCars = [_menus filteredArrayUsingBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		//		return NSPointInRect(mouseLoc(), [carousel frame]) ? NO : YES;															}];
		//	[fileredCars each:^(iCarousel* obj, NSUInteger index, BOOL *stop) {
		//		AZWindowPosition d =	 obj.window.position;
		//		NSLog(@"setting %@ to offset: %@", [obj valueForKey:@"identifier"], @(carousel.scrollOffset));
		// 		return <#expression#>
		//		CGFloat wasoff = [obj scrollOffset];
		//		[obj scrollByOffset:carousel.scrollOffset duration:0];
		//		[obj setScrollOffset: wasoff + ];
		//	[_menus each:^(id obj, NSUInteger index, BOOL *stop) {
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
	 }   // else//        label = (NSTextView*)[view viewWithTag:1];
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
	id item = (( d == AZPositionRight) || ( d == AZPositionTop) ? _northEast[index] : _southWest[index]);

		//	else id flipper = self.items[index];
	return  view = view == nil ?
	(NSView*)[[AZQuadCell alloc]initInWindow:(AZTrackingWindow*)[carousel window] withObject:item atIndex:index] : view;

		//	//] [_items objectAtIndex:reg] atIndex:reg]

		//view.needsDisplay = YES;
		//    return view;
}
/*
 - (NSView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSUInteger)index reusingView:(NSView *)view
 {	NSLog(@"placeholder reuqested by %@ for index:%ld", carousel.identifier, index );
 NSTextView *label = nil;
 if (view == nil)	{
 view = [[NSTextView alloc] initWithFrame:AZRectFromDim(_intrusion)];
 [(NSTextView*)view setBackgroundColor: BLACK ];
 [(NSTextView*)view setTextColor:WHITE];
 }    else        label = (NSTextView*)[view viewWithTag:1];
 [(NSTextView*)view setString: $(@"%ld", index)];
 return view;
 }

 */
/*
 -(NSUInteger)visibleItems {
 __block	NSUInteger i = 0;
 [_menus each:^(iCarousel *obj, NSUInteger index, BOOL *stop) {
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


	CGFloat dynStrk = AZMaxDim(v.bounds.size)  * .07 ;
	CAShapeLayer *u = [CAShapeLayer layer];
	CALayer *x = [CALayer layer];
	u.frame = v.layer.bounds;
	x.frame = v.layer.bounds;
	x.backgroundColor = cgRANDOMCOLOR;
	x.borderColor = cgWHITE;
	[u setFillColor:cgCLEARCOLOR];
	[u setStrokeColor: cgBLACK];// [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
	[u setLineWidth:dynStrk];
	[u setLineJoin:kCALineJoinRound];
	[u setLineDashPattern:@[ @(15), @(15)]];
	NSBezierPath *p = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(v.bounds, dynStrk/2, dynStrk/2) cornerRadius:0];
	[u setPath:[p quartzPath]];
	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
	[dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
	[dashAnimation setToValue:[NSNumber numberWithFloat:30.0f]];
	[dashAnimation setDuration:0.75f];
	[dashAnimation setRepeatCount:10000];
	[u addAnimation:dashAnimation forKey:@"linePhase"];


	AZTrackingWindow *e = [AZTrackingWindow oriented:v.position intruding:[v height] inRect:AZRectVerticallyOffsetBy([v frame],[v height])];

		//	oriented:AZPositionTop intruding:60 inRect:AZRectHorizontallyOffsetBy(v.frame)];


		//	NSBezierPath *p2 =[NSBezierPath bezierPathWithRoundedRect:AZLowerEdge(v.frame,25) cornerRadius:10 inCorners:(OSBottomRightCorner|OSBottomLeftCorner)];
	[u setPath:[p quartzPath]];
	[v.layer addSublayer:x];
	[v.layer addSublayer:u];
	[v.layer needsDisplay];
	[[v window] addChildWindow:e ordered:NSWindowBelow];
	[e slideIn];


}


-(void) advance {	[_quads each:^(id obj, NSUInteger index, BOOL *stop) {
	[obj shiftIndexesStartingAtIndex:[obj firstIndex] by:1];
}];
}


-(void) rewind {		[_quads each:^(id obj, NSUInteger index, BOOL *stop) {
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

	[slider performSelector:slider.slideState == AZOut ? @selector(slideIn) : @selector(slideOut)];
}

- (IBAction)setType:(id)sender {

		//	type =	type <= 11 ? type++ : 1 ;
	self.cType =  RAND_INT_VAL(0 , 12);
	NSLog(@"setting type to : %ul", _cType);
	[_menus each:^(iCarousel *obj, NSUInteger index, BOOL *stop) {
		[obj setType:_cType];
		[obj reloadData];
	}];

}

- (IBAction)setVeils:(id)sender; {
	[_quads each:^(AZTrackingWindow *obj, NSUInteger index, BOOL *stop) {

		if (! [[obj contentView]layer] ) 		[[obj contentView]setWantsLayer:YES];
			//		CALayer * f =  [CALayer veilForView:	[[obj contentView]layer]];
			//		f.frame  = [[obj contentView]bounds];
		/*		iCarousel *c = [[[obj contentView]subviews] filterOne:^BOOL(id object) {
		 return [object isKindOfClass:[iCarousel class]] ? YES : NO;
		 }];
		 */		[[[obj contentView]layer]addSublayer:
				 [obj veilLayerForView:[[[obj contentView]subviews]lastObject]]];

			//		[f display];
			//		[obj reloadData];
	}];
}


	//-(AZSizer*) szrForPerimeter {
	//	return [AZSizer forQuantity:_content.count aroundRect:AZScreenFrame()];
	//}

	//- (AZSizer*)szr {
	//	return [self szrForPerimeter];
	//}

- (CATransform3D)carousel:(iCarousel *)_carousel index:(NSInteger)index  baseTransform:(CATransform3D)transform;

{

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
			// CGPoint ctlPoint       = CGPointMake(0.0, 0.5);
		CGPoint ctlPoint       = CGPointMake(1024/2, 768/2);
			// This is the starting point of the animation. This should ideally be a function of the frame of the view to be animated. Hardcoded here.
			// Set here to get the accurate point..
		[movePath moveToPoint:indentR.origin];
			//The anchor point is going to end up here at the end of the animation.
			//		[movePath   addQuadCurveToPoint:CGPointMake(1024/2, 768/2) controlPoint:ctlPoint];
		CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"path"];
		moveAnim.path                = [movePath quartzPath];
		moveAnim.removedOnCompletion = YES;
			// Setup rotation animation
		CABasicAnimation* rotateAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
			//start from 180 degrees (done in 1st line)
		CATransform3D fromTransform       = CATransform3DMakeRotation( DEG2RAD(180),0,1,0);
			//		myRotationAngle(180), 0, 1, 0);
			//come back to 0 degrees
		CATransform3D toTransform         = CATransform3DMakeRotation(DEG2RAD(0), 0, 1, 0);
			//		myRotationAngle(0), 0, 1, 0);
			//This is done to get some perspective.
			//		CATransform3D persp1 = CATransform3DIdentity;
			//		persp1.m34 = 1.0 / -3000;
			//		fromTransform = CATransform3DConcat(fromTransform, persp1);
			//		toTransform = CATransform3DConcat(toTransform,persp1);
		rotateAnimation.toValue             = [NSValue valueWithCATransform3D:toTransform];
		rotateAnimation.fromValue           = [NSValue valueWithCATransform3D:fromTransform];
			//rotateAnimation.duration            = 2;
		rotateAnimation.fillMode            = kCAFillModeForwards;
		rotateAnimation.removedOnCompletion = NO;
			// Setup and add all animations to the group
		CAAnimationGroup *group = [CAAnimationGroup animation];
		[group setAnimations:@[moveAnim,rotateAnimation]];
		group.fillMode            = kCAFillModeForwards;
		group.removedOnCompletion = NO;
		group.duration            = 0.7f;
		group.delegate            = self;
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
	} else if (_option ==3) {

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

	}else return  transform;
}





	//		//implement 'flip3D' style carousel
	//    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
	//    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
	//}

	//- (CGFloat)carousel:(iCarousel *)someCarousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
	////	NSString *unique 	= someCarousel.identifier;
	////	BOOL vertical  		= someCarousel.vertical;

	//    switch (option)
	//    {
	////		case 	iCarouselOptionWrap:
	////			return 	YES;
	////		case 	iCarouselOptionVisibleItems: {
	//////			NSUInteger s = _carousel.currentItemIndex.
	////			return 466;//value;// _items.count;// [(AZTrackingWindow*)someCarousel.window capacity];
	////		}//floor(_carousel.frame.size.height / _intrusion) \
	//					        : floor(_carousel.frame.size.width  / _intrusion);

	////		This is the maximum number of item views (including placeholders) that should be visible in the carousel at once. Half of this number of views will be displayed to either side of the currently selected item index. Views beyond that will not be loaded until they are scrolled into view. This allows for the carousel to contain a very large number of items without adversely affecting performance. iCarousel chooses a suitable default value based on the carousel type, however you may wish to override that value using this property (e.g. if you have implemented a custom carousel type).

	////        case iCarouselOptionWrap:
	////            return value;/// return YES;
	////        case iCarouselOptionSpacing:
	////
	////            return value;// * 1.05f;
	//        default:
	//            return value;
	//    }
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

		//    if ([keyPath isEqual:@"scrollOffset"]) {
	NSLog(@"notified...  KP:%@ ", keyPath);
	NSLog(@" obhj: %@::", object);
		//        [openingBalanceInspectorField setObjectValue:
		//		 [change objectForKey:NSKeyValueChangeNewKey]];
		//    }
    /*
     Be sure to call the superclass's implementation *if it implements it*.
     NSObject does not implement the method.
     */
		//    [super observeValueForKeyPath:keyPath
		//                         ofObject:object
		//                           change:change
		//						  context:context];
}



	//	if (context == DotViewUndoAndRedisplay) {
	//        NSUndoManager *undoManager = [[self window] undoManager];
	//        if ([keyPath isEqual:@"center"]) [[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];
	//        else if ([keyPath isEqual:@"radius"]) [[undoManager prepareWithInvocationTarget:self] setRadius:[[change objectForKey:NSKeyValueChangeOldKey] doubleValue]];
	//        else if ([keyPath isEqual:@"color"]) [undoManager registerUndoWithTarget:self selector:@selector(setColor:) object:[change objectForKey:NSKeyValueChangeOldKey]];
	//	if ([keyPath isEqual:@"multiplier"]) {
	//	if ([keyPath isEqual:@"desiredNumberOfColumns"]) {
	//	[[undoManager prepareWithInvocationTarget:self] setCenter:[[change objectForKey:NSKeyValueChangeOldKey] pointValue]];



	//- (void)setContent:(NSMutableArray *)content
	//{
	//	_content = content;
	//	NSLog(@"set content: %@", _content);
	// 	[ _menus each:^(id obj, NSUInteger index, BOOL *stop) {
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
	 }] each:^(AZLassoView* obj, NSUInteger index, BOOL *stop) {
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
 }
 */


	//	NSTextField *label = nil;

	//		//create new view if no view is available for recycling
	//	if (view == nil)	{
	//		NSImage *image = [NSImage imageInFrameworkWithFileName:@"2.pdf"];
	//       	view = [[[NSImageView alloc] initWithFrame:NSMakeRect(0,0,image.size.width,image.size.height)] autorelease];
	//        [(NSImageView *)view setImage:image];
	//        [(NSImageView *)view setImageScaling:NSImageScaleAxesIndependently];
	//        label = [[[NSTextField alloc] init] autorelease];
	//        [label setBackgroundColor:[NSColor clearColor]];
	//        [label setBordered:NO];
	//        [label setSelectable:NO];
	//        [label setAlignment:NSCenterTextAlignment];
	//        [label setFont:[NSFont fontWithName:[[label font] fontName] size:50]];
	//        label.tag = 1;
	//        [view addSubview:label];
	//	}	else				//get a reference to the label in the recycled view
	//		label = (NSTextField *)[view viewWithTag:1];
	//		//set item label   			remember to always set any properties of your carousel item views outside of the `if (view == nil) {...}` check otherwise you'll get weird issues with carousel item content appearing  in the wrong place in the carousel
	//	[label setStringValue:(index == 0)? @"[": @"]"];
	//    [label sizeToFit];
	//    [label setFrameOrigin:(NSPoint){(view.bounds.size.width - label.frame.size.width)/2.0,	((view.bounds.size.height - label.frame.size.height)/2.0)}];

	//    return view;
	//}




	//- (CGFloat)carouselItemWidth:(iCarousel *)carousel
	//{
	//		//set correct view size
	//		//because the background image on the views makes them too large
	//}



	//- (void)carouselDidScroll:(iCarousel *)carousel {
	////    if (carousel == carousel)
	////    {
	//			//adjust perspective for inner carousels
	//			//every time the outer carousel is moved
	//			//for 2D carousel styles this wouldn't be neccesary
	//        for (iCarousel *subCarousel in _carousel.visibleItemViews)
	//        {
	//            NSInteger index = subCarousel.tag;
	//            CGFloat offset = [_carousel offsetForItemAtIndex:index];
	//            subCarousel.viewpointOffset = CGSizeMake(-offset * _carousel.itemWidth, 0.0f);
	//            subCarousel.contentOffset = CGSizeMake(-offset * _carousel.itemWidth, 0.0f);
	//        }
	//    }
	//    else if (SYNCHRONIZE_CAROUSELS)
	//    {
	//			//synchronise inner carousel scroll offsets each time any
	//			//of the inner carousels is moved - if you don't want this
	//			//you can turn it off, but then you'd need to keep track of
	//			//the scroll state for each carousel when they are loaded/unloaded
	//        for (iCarousel *subCarousel in _carousel.visibleItemViews)
	//        {
	//            subCarousel.scrollOffset = carousel.scrollOffset;
	//        }
	//    }
	//}

- (void) setTilt:(NSUInteger)tilt {

	_tilt = tilt;
	[_menus  each:^(id obj, NSUInteger index, BOOL *stop) {
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

		case	iCarouselOptionShowBackfaces:		return  NO;
				//		For some carousel types, e.g. iCarouselTypeCylinder, the rear side of some views can be seen (iCarouselTypeInvertedCylinder now hides the back faces by default). If you wish to hide the backward-facing views you can return NO for this option. To override the default back-face hiding for the iCarouselTypeInvertedCylinder, you can return YES. This option may also be useful for custom carousel transforms that cause the back face of views to be displayed.

		case	iCarouselOptionArc:					return value;				//			return 	RAND_FLOAT_VAL(.3, 2*M_PI);
																				//		The arc of the Rotary, Cylinder and Wheel transforms (in radians). Normally this defaults to 2*M_PI (a complete circle) but you can specify a smaller value, so for example a value of M_PI will create a half-circle or cylinder. This property is used to calculate the carousel radius and angle step, so another option is to manipulate those values directly.

		case	iCarouselOptionAngle:				return 	value;
				//		The angular step between each item in the Rotary, Cylinder and Wheel transforms (in radians). Manipulating this value without changing the radius will cause a gap at the end of the carousel or cause the items to overlap.

		case	iCarouselOptionRadius:				return 	value;
				//		The radius of the Rotary, Cylinder and Wheel transforms in pixels/points. This is usually calculated so that the number of visible items exactly fits into the specified arc. You can manipulate this value to increase or reduce the item spacing (and the radius of the circle).

		case	iCarouselOptionTilt:				return 	_tilt;
				//		The tilt applied to the non-centered items in the CoverFlow, CoverFlow2 and TimeMachine carousel types. This value should be in the range 0.0 to 1.0.

		case 	iCarouselOptionFadeMax:				return 	value;		case	iCarouselOptionFadeMin:				return 	value;
		case	iCarouselOptionFadeRange:			return 	value;
				// These three options control the fading out of carousel item views based on their offset from the currently centered item. FadeMin is the minimum negative offset an item view can reach before it begins to fade. FadeMax is the maximum positive offset a view can reach before if begins to fade. FadeRange is the distance the item can move between the point at which it begins to fade and the point at which it becomes completely invisible.   		//	if (self.carousel.type == iCarouselTypeCustom)	return1.0f;                 //set opacity based on distance from camera

		default:									return 	value;
	}
}



- (CAShapeLayer*) lassoLayerForLayer:(CALayer*)layer {

		//	NSLog(@"Clicked: %@", [[layer valueForKey:@"azfile"] propertiesPlease] );
	CAShapeLayer *shapeLayer = [CAShapeLayer layer];
		//	[shapeLayer setValue:layer forKey:@"mommy"];
	CGRect shapeRect = layer.bounds;
	[shapeLayer setBounds:shapeRect];
	CGFloat dynnamicStroke = .1*AZMaxDim(layer.bounds.size);
	CGFloat half = dynnamicStroke / 2;
		//	[shapeLayer setAutoresizingMask:kCALayerWidthSizable|kCALayerHeightSizable];
	shapeLayer.constraints = @[		AZConstScaleOff( kCAConstraintMinX,@"superlayer", 1, half), //2), 	AZConstScaleOff( kCAConstraintMaxX,@"superlayer", 1,2),
	AZConstScaleOff( kCAConstraintMinY,@"superlayer", 1,half), /*2),*/ 	AZConstScaleOff( kCAConstraintMaxY,@"superlayer", 1,half),
	AZConstScaleOff( kCAConstraintWidth,@"superlayer", 1,-dynnamicStroke), 	AZConstScaleOff( kCAConstraintHeight,@"superlayer", 1, - dynnamicStroke),
	AZConst( kCAConstraintMidX,@"superlayer"), 					AZConst( kCAConstraintMidY,@"superlayer") ];

	[shapeLayer setPosition:CGPointMake(.5,.5)];
	shapeRect.size.width -= dynnamicStroke;		shapeRect.size.height -= dynnamicStroke;

	shapeLayer.fillColor 	= cgCLEARCOLOR;
	shapeLayer.strokeColor 	= cgBLACK; [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor];
	shapeLayer.lineWidth	= dynnamicStroke;
	shapeLayer.lineJoin		= kCALineJoinRound;
	shapeLayer.lineDashPattern = @[ @(10), @(5)];
	shapeLayer.path = [[NSBezierPath bezierPathWithRoundedRect:NSRectFromCGRect(shapeRect) cornerRadius:layer.cornerRadius] quartzPath];
	shapeLayer.zPosition = 3300;
	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
	[dashAnimation setValuesForKeysWithDictionary:@{ 	@"fromValue":@(0.0), 	@"toValue"	   :@(15.0),
	 @"duration" : @(0.75),	@"repeatCount" : @(10000) }];
	[shapeLayer addAnimation:dashAnimation forKey:@"linePhase"];
	[shapeLayer needsDisplay];
	return shapeLayer;
}




/*		//	if (!view) {
 _iconStyle = RAND_INT_VAL(1, 3);
 if (view == nil)     //create new view if no view is available for recycling
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
/*		NSImage *image = [NSImage imageInFrameworkWithFileName:@"4.pdf"];
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
 [view addSubview:label];    */

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
 (view.bounds.size.height - label.frame.size.height)/2.0)];
 */




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
 }] each:^(AZLassoView* obj, NSUInteger index, BOOL *stop) {
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
 //	[v setNeedsDisplay:YES];
 */


/*
 - (NSArray*) allItems {
 //	__block	NSMutableArray *i = [NSMutableArray array];
 //	[_quads each:^(id obj, NSUInteger index, BOOL *stop) {
 //		[i addObjectsFromArray:obj];
 //	}];
 return [_quadContent arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
 return [_quadContent objectAtNormalizedIndex:_externalZeroIndex + idx];
 }];
 //	i.copy;
 }

 -(NSArray*)itemsinQuad:(AZQuad)quadrant;{
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
 -(void)insertItems:(NSArray*)items{




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
 -(void)removeItems:(NSArray*)items;{

 }

 -(id) objectAtIndex:(NSUInteger)index {
 //		NSMutableIndexSet

 }


 -(id) objectAtIndex:(NSUInteger)index inQuad:(AZQuad)quadrant {

 NSMutableArray *q = [self quadForType:quadrant];
 return  [q objectAtIndex:index];
 }
 */



/*	self.window = [[NSWindow alloc]initWithContentRect:
 NSInsetRect([[NSScreen mainScreen]frame],200,200) styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered  defer:NO];

 NSImageView *backgroundView = [[NSImageView alloc] initWithFrame:[[_window contentView] bounds]];
 backgroundView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
 [backgroundView setImageScaling:NSImageScaleAxesIndependently];
 backgroundView.image = 	[NSImage imageInFrameworkWithFileName:@"3.pdf"];

 [_window.contentView addSubview:backgroundView];
 self.carousel = [[iCarousel alloc] initWithFrame:[[_window contentView] bounds]];
 _carousel.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
 _carousel.type = iCarouselTypeCoverFlow;
 [self.carousel setDelegate : self ];
 [self.carousel setDataSource : self];
 [self.carousel setWantsLayer:YES];
 //add carousel to view
 [[self.window contentView] addSubview:self.carousel];
 */
@end
