#import "AtoZ.h"

#import "AZSemiResponderWindow.h"
#import "AZBlockView.h"
#import "AZMouser.h"

@implementation AZSemiResponderWindow

- (id) init { if (!(self = [self initWithContentRect:AZScreenFrameUnderMenu() styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO] )) return nil;

	self.scrollPoint  = NSZeroPoint;
	self.unitOffset   = 1;
	self.opaque 					= NO;
	self.level 					 	= NSNormalWindowLevel;	// CGWindowLevelForKey(kCGCursorWindowLevelKey)];
	self.backgroundColor 			= CLEAR;//[RED alpha:.2];
	self.hidesOnDeactivate  			= NO;
	self.collectionBehavior			= WINCOLS;
	self.ignoresMouseEvents 			= NO;
	self.acceptsMouseMovedEvents  	= YES;
	self.inactiveRect 				= NSInsetRect(self.frame, 100, 100);

	[self.contentView addSubview:	[BLKVIEW viewWithFrame:_inactiveRect opaque:NO drawnUsingBlock:^(BNRBlockView *view, NSRect dirtyRect) {
		static NSC *c = nil;  c = c ?: RANDOMCOLOR;
		//		int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
		//		NSTA *tarea = [NSTA.alloc initWithRect:view.bounds options:opts owner:self userInfo:nil];//		[view setWantsLayer:YES];
		//		[view addTrackingArea:tarea];
		//		[CATransaction immediately:^{ [[view layer] setOpacity:0.0]; }];
		[[c alpha:.4]set];
		[NSBezierPath fillRect:dirtyRect];
	}]];
	self.content = [self.contentView setupHostView];
	//	_content.backgroundColor = cgRED;
	self.tabs	= [AZDynamicTabLayer layer];
	[_content addSublayer:_tabs];
	[_tabs setNeedsLayout];
	//	AZCenteredRect(AZMultiplySize(self.frame.size, .5), [self frame])
	//	([[self contentView] bounds], 100)
	//	opaque:NO drawnUsingBlock:^(BLKVIEW *view, NSRect dirtyRect) {
	//		[NSEVENTLOCALMASK:NSMouseEnteredMask handler:^NSEvent *(NSEvent *e) {
	//			NSLog(@"Enttry!: %@", AZString(e.locationInWindow)); return e;
	//		}];
	//		view.wantsLayer = YES;
	//		view.layer.backgroundColor = cgORANGE;
	//		NSRectFillWithColor(dirtyRect, [BLUE alpha:.2]);
	//	}]];
	//	self.root = [(NSV*)[self contentView] setupHostView];
	//	self.content = [CAL layerNamed:@"content"];
	//	_root.sublayers = @[_content];
	//	_content.bounds = AZRectFromDim(400);
	//	_content.bgC = cgRED;
	return LogAndReturn(self);
}

- (void) nimationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	NSLog(@"The ani: %@ stopped with flag %@", theAnimation, AZString(flag));
}

- (void) endEvent:(NSE*)e
{
	_hit = (AZLayer*)[_content hitTest:[self.contentView convertPoint:e.locationInWindow fromView:nil] forClass:[AZLayer class]] ?: nil;
	if (_semiResponder  && respondsToString(_semiResponder, @"logString:")) [_semiResponder logString:_hit.debugDescription];//, AZString(e.locationInWindow)];
	if (_hit) [_hit setBool:YES forKey:@"hovered"];
	////	_noHit = NSPointInRect(where, _inactiveRect);
	switch (e.type)  {
		case NSLeftMouseDown: {
			if (_semiResponder)
				if (respondsToString(_semiResponder, @"windowEvent:")) [_semiResponder windowEvent:e];
			if (_hit) {
				[_hit setBool: YES forKey:@"selecte"];
				[self setIgnoresMouseEvents:NO];
				NSLog(@"ay cuuucarracha  %@", _hit.debugDescription);
			} else {
				NSLog(@"Trying to click!");

				[self setIgnoresMouseEvents:YES];
//				[self setIgnoresEventsButAcceptsMoved];
				AZLeftClick(mouseLoc());
				[self setIgnoresMouseEvents:NO];
				//			NSLog(@"mousedown:%@  noHit?:%@",AZString(where), StringFromBOOL(_noHit));
				//			if (_noHit) {	LOG_EXPR(_noHit);
				// 			Don't let our events block local hardware events
				//			CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateSupressionInterval);
				//			CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateRemoteMouseDrag);
				//		_hit = [[(NSV*)self.contentView layer] hitTest:theEvent.locationInWindow];
				//		_hit == _content ? ^{
				//			NSLog(@"leftdown pt:%@  hit:%@", AZString(theEvent.locationInWindow), _hit.debugDescription);
				//			_dragDiff = AZSubtractPoints(theEvent.locationInWindow, _hit.position);
				//			_dragStart = theEvent.locationInWindow;
				//		}():^{
				//			self.ignoresMouseEvents =YES;
				//			AZLeftClick(mouseLoc());
				//			self.ignoresMouseEvents = NO;
				////		tab = areSame(tab.name, @"tab") ? tab.superlayer : [[tab sublayerWithName:@"tab"] superlayer];
				//		}();
				break;
			}
		case NSLeftMouseUp: {
			//			if (_noHit) { CGPostMouseEvent(mouseLoc(), FALSE, 1,FALSE);
			_hit = nil;
//			AZBlockSelf(bSelf);
//			[self performBlock:^{ [bSelf setIgnoresMouseEvents: NO]; } afterDelay:.1];
			break;
		}
		case NSMouseEntered:
		case NSMouseExited:			NSLog(@"mouse entered or exited!");	break;
		case NSScrollWheel:	_tabs.offset += e.deltaY;	break;
		default: break;
		}
			//	[theEvent type] == NSLeftMouseDown || [NSEvent modifierFlags] != NSCommandKeyMask ? ^{   }():nil;
			//	[theEvent type] == (NSMouseMoved || NSLeftMouseDown/* && !NSLeftMouseDragged)*/) ? ^{
			//		AZLOG(@"moved, clicked, but not dragged");
			//	}():nil;
			//	NSLog(@"sendevent says: %@", theEvent);
	}
	[super sendEvent:e];
}
- (BOOL) acceptsFirstResponder {	return YES; 	}
@end


@implementation AZDynamicTabLayer

-(id) init
{
	if (!(self = [super init])) return nil;

	[self addObserver:self forKeyPath:@"offset"options:0 context:NULL];

	self.palette 		= [[NSC randomPalette]withMinItems:RAND_INT_VAL(24, 56)];
	self.tabs  			= [NSOrderedDictionary	 new];
	//	self.layoutManager 	= self;

	NSSZ __unused unitSize 		= self.sizer.size;

	//	_scrollPath = [NSBP bezierPathWithRoundedRect:NSInsetRect(AZScreenFrameUnderMenu(), _sizer.width, _sizer.height) cornerRadius:20];

	self.sublayers  	= [_palette nmap:^id(id obj, NSUInteger index) {
		AZLayer*z 		= [AZLayer layer];  //]AtIndex:index inRange:AZMakeRange(-1,_palette.count-1) unit:AZPerimeter(self.frame)/_palette.count];
		z.frame 		= [[_sizer.rects normal:index]rectValue];
		//		else z.bounds = AZRectFromSize(unitSize);
		z.name			= $(@"%ld", index);

		CAKeyframeAnimation *anim 			= [CAKA animationWithKeyPath:@"position"];
		anim.path 			= [_scrollPath quartzPath];//[[self scrollPath]quartzPath];
		anim.calculationMode	 =  kCAAnimationPaced;// kCAAnimationDiscrete;
		anim.rotationMode 	= kCAAnimationRotateAuto;  //kCAAnimationRotateAutoReverse;
		anim.repeatCount 	= HUGE_VALF;
		//		anim.duration 		= 8.0;
		anim.timeOffset	 = (index / _palette.count) *8;
		anim.beginTime 		= 0;//index;//(index / _palette.count) *8;
		[z addAnimation:anim forKey:@"race"];
		z.bgC = [obj CGColor];
		//		z.delegate = self;
		return z;
	}];
	//	}];
	return self;
}

- (NSBP*) scrollPath
{
	return _scrollPath = _scrollPath ?: [NSBP bezierPathWithRoundedRect:AZScreenFrameUnderMenu() cornerRadius:25];
}

-(id<CAAction>) animationForTabOnPathForOffset:(CGF)offset
{
	//	CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	//	pathAnimation.duration 	= 10.0;
	//	pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
	//	pathAnimation.toValue 	= [NSNumber numberWithFloat:1.0f];
	//	[self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
	CAKeyframeAnimation *penAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	penAnimation.duration 	= 2.0;
	penAnimation.path 		= [[self scrollPath]quartzPath];;
	penAnimation.calculationMode = kCAAnimationPaced;
	penAnimation.delegate 	= self;
   	return  penAnimation;
}

#pragma mark - CALayer Animation Delegate

- (id < CAAction >)actionForLayer:(CALayer *)layer forKey:(NSString *)key
{
	//
	//	 return [key isEqualToString: @"position"] ?
	//	 ^{
	//		CGP oldP  = layer.position;													CGP newP  = [[CATransaction valueForKey: @"newP"] pointValue];
	//		CGF d 	  = sqrt(pow(oldP.x - newP.x, 2) + pow(oldP.y - newP.y, 2));		CGF r 	  = d / 3.0;
	//		CGF theta = atan2(newP.y - oldP.y, newP.x - oldP.x);						CGF wag   = 10 * M_PI / 180.0;
	//		CGP p1 	  = (CGP) { oldP.x + r *	 cos ( theta + wag ), 	oldP.y + r * sin 	 ( theta + wag )};
	//		CGP p2 	  = (CGP) { oldP.x + r * 2 * cos ( theta - wag ), 	oldP.y + r * 2 * sin ( theta - wag )};
	//
	//		CAKA* anim  = [CAKeyframeAnimation animation];  anim.values = @[ AZVpoint(oldP), AZVpoint(p1), AZVpoint(p2), AZVpoint(newP)];	anim.calculationMode = kCAAnimationCubic;
	//	return anim;
	//	}():
	//	return
	[key isEqualToString:kCAOnOrderOut] ?
	^{
		CABA* anim1 	= [CABA animationWithKeyPath:@"opacity"];
		CABA* anim2 	= [CABA animationWithKeyPath:@"transform"];

		anim1.fromValue = @0;  anim1.toValue 	= @1;//(layer.opacity);
		anim2.toValue 	= AZV3d( CATransform3DScale(layer.transform, 2, 2, 1.0));	anim2.autoreverses 	= NO;  /*YES*/		anim2.duration 		= 3;

		CAAG* group = [CAAG animation];		group.animations = @[ anim1, anim2 ];	group.duration = 0.2;
		return group;
	}():[key isEqualToString:@"opacity"] ?
	^{
		return [CATransaction valueForKey:@"byebye"] ?
		^{
			CABA* anim1 	=  [CABasicAnimation animationWithKeyPath:@"opacity"];
			anim1.fromValue 	= @(layer.opacity);
			anim1.toValue 	= @0;
			CABA* anim2 	= [CABA animationWithKeyPath:@"transform"];
			anim2.toValue 	= AZV3d( CATransform3DScale(layer.transform, 0.1, 0.1, 1.0));
			CAAG* group 	= [CAAG animation];
			group.animations = @[ anim1, anim2 ];
			group.duration = 0.2;
			return group;
		}(): nil;
	}():nil;

	// Set up an animation delegate when we are removing a layer so we can remove it from the view hierarchy when it is done
	if ( [layer valueForKey:@"toRemove"] )
	{
		CABA *animation = [CABA animation];
		if ( [key isEqualToString:@"bounds"] ) animation.delegate = self;
		return animation;
	}

	return nil;
}

#pragma mark - CAAnimationDelegate

- (void) nimationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	// Remove any sublayers marked for removal
	//	for ( CALayer *layer in self.sublayers ) [[layer valueForKey:@"toRemove"] boolValue]  ?: [layer removeFromSuperlayer];
}

// works.  just need to observe
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (areSame(@"offset",keyPath)) 			[self setNeedsLayout];
}

-(AZSizer*) sizer
{
	return _sizer = _sizer ?: [AZSizer forQuantity:_palette.count aroundRect:AZScreenFrameUnderMenu()];//:_palette withFrame:self.bounds arranged:AZOrientPerimeter];
}


//-(void) layoutSublayersOfLayer:(CALayer *)layer
//{
//	if (layer == self) [layer.sublayers eachWithIndex:^(AZLayer *obj, NSInteger idx) {
//	obj.frame =	(NSR) { (idx-1) * obj.unit + _scrollPoint.x, AZHeightUnderMenu() - unit/1.7	, unit, unit };
////		obj.bounds  	= AZRectFromSize(_sizer.size);
////		obj.position	= AZCenterOfRect(AZRectVerticallyOffsetBy([[self.sizer.rects normal:idx]rectValue], _offset));
//	}];
//}


//- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event;
//{
//	NSLog(@"? actionforlayer:%@  event:%@", layer, event );
//	if ( [@[self]doesNotContainObject:layer] ) {
//		__block id theA 		 			= [CABA animationWithKeyPath:@"transform"];
//		__block CATransform3D transform;
//		transform	 = [layer.permaPresentation[@"transform"]CATransform3DValue]  ;//CATransform3DValue] : [layer transform];
//		//																		: CATransform3DIdentity;
//		((CABA*)theA).removedOnCompletion 	= NO;
//		((CABA*)theA).fillMode 				= kCAFillModeForwards;
//		((CABA*)theA).fromValue 			= AZV3d(transform);
//		((CABA*)theA).toValue 				=
//		areSame(event,@"selected")				? AZV3d(CATransform3DConcat(transform, CATransform3DMakeRotation(TWOPI, 1, 0, 0)))
//		: [@[@"hovered"] containsObject:event]	? ^{ 	BOOL h = [layer boolForKey:@"hovered"];
//			CGF val = h ? 200 : -200;
//			return AZV3d(CATransform3DConcat( transform, CATransform3DMakeRotation(-DEG2RAD(180), 0,1, 0)));// CATransform3DMakeTranslation(0, val, 0)));
//		}() : 0;
//
//		return theA;
//	}
//	return nil;//@{@"transform":theA, @ ?: nil;	}	else return  nil;
//}


@end

//	NSP where = [self.contentView convertPoint:e.locationInWindow toView:nil];
//	CAT3D subT 			= CATransform3DIdentity;
//	subT.m34 			= 1.0 / -2000;
//	_scrollLayer.sublayerTransform = subT;
//	self.perfectRect 	= AZRectBy(unit, AZScreenFrameUnderMenu().size.height);
/*
 _scrollLayer.sublayers 	= [[NSArray from:-1 to:r.count] nmap:^id(id obj, NSUInteger index) {
 AZSemiResponderWindowTab *root  		 	= [AZSemiResponderWindowTab layerNamed:$(@"%@",obj)];
 //		root[@"hovered"] 	= @(NO);
 CAL *tab 		 	= [CAL layerNamed:@"tab"];
 tab.doubleSided		= YES;
 CALNH *ribbon  		= [CALNH layerNamed:@"ribbon"];
 [@[root, tab, ribbon] eachWithIndex:^(id z, NSInteger idx) { ((CAL*)z).zPosition = (idx *1000 * [obj intValue]); }];
 tab.sublayers   = @[ribbon];
 root.sublayers 	= @[tab];	*/		/* ! */	//root.anchorPoint 	= AZAnchorTop;
/* ! *///	root.delegate 		= self;
/* ! */	//ribbon.delegate	 	= self;
/* ! *///	[ribbon setNeedsDisplay];

//		[@[tab,ribbon] each:^(CAL* obj) { [obj addConstraintsSuperSize];  AddShadow(obj);	obj.cRadius = .19 * perfectRect.size.width;}];
//		tab.	bgC	 		= cgWHITE;
//		ribbon.	bgC	 		= [[NSColor leatherTintedWithColor:[r normal:[obj integerValue]]] CGColor];
//		[tab addConstraints:		@[	AZConstRelSuperScaleOff(kCAConstraintWidth,  .9, 1 ),
//		 AZConstRelSuperScaleOff(kCAConstraintMaxY,  1.2, 0 )]];
//		[ribbon addConstraints:	@[	AZConstRelSuperScaleOff(kCAConstraintWidth,  .9, 0 ),
//		 AZConstRelSuperScaleOff(kCAConstraintMinY,  1  , 7 )]];
//		return root;
//	}];
//	[_scrollLayer enableDebugBordersRecursively:YES];
//	[self makeKeyAndOrderFront:nil];


/*
 - (void) layoutSublayersOfLayer:(CALayer *)layer
 {
 AZLOG($(@"layoing out subs of : %@", layer));
 if (layer == _scrollLayer) [layer.sublayers eachWithIndex:^(CAL* obj, NSInteger idx) {	obj.frame =
 [@[@"scroll", @"drawer"] containsObject: [obj name]] ? obj.frame :
 //		(NSR){ (idx-1) * unit + _scrollPoint.x, AZHeightUnderMenu() - unit/1.7	, unit, unit }; }];
 }

 -(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
 {
 AZLOG($(@"d in c for %@", layer.debugDescription));
 if ( areSame(layer.name, @"ribbon")) {
 //		AZSemiResponderWindowTab *t = (AZSemiResponderWindowTab*)[layer superlayerOfClass:[AZSemiResponderWindowTab class]];
 if ([t boolForKey:@"clicked"] || [t boolForKey:@"hovered"]){ NSRectFillWithColor(layer.frame, BLACK); return; }
 else [NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
 NSR bottomSquare = AZLowerEdge(layer.bounds, layer.boundsWidth);
 [[[[NSIMG randomIcon]scaledToMax:layer.boundsWidth]etched] drawInRect:AZInsetRect(bottomSquare, layer.boundsWidth*.2) operation:NSCompositeSourceOver fraction:1 method:AGImageResizeScale];
 [$(@"%f",[layer.superlayers[(layer.superlayers.count -3)]frame].origin.x) drawInRect:AZUpperEdge(layer.bounds,100) withFont:[AtoZ font:@"Ubuntu" size:24] andColor:WHITE];
 //AZCenterRectOnPoint(AZRectFromDim(.7*layer.boundsWidth), (NSPoint) {NSMidX(layer.bounds), layer.boundsWidth})];//// fraction:1];// operation:NSCompositeSourceOver fraction:1];
 }];
 }
 }	*/
/*
 - (void) endEvent:(NSEvent *)theEvent
 {
 [theEvent type] == NSLeftMouseDragged  ? ^{
 //		NSP newp = (NSP) {theEvent.locationInWindow.x, dragStart.y};
 //		newp = AZSubtractPoints(newp,dragDiff);
 //		NSLog(@"dragstart: %@   setting newp: %@ on %@", AZString(dragStart), AZString(newp), tab.debugDescription);
 //		[CATransaction immediately:^{ [tab setPosition:newp]; }];
 }():nil;

 [theEvent type] == NSMouseMoved ? ^{
 if (tab) [tab boolForKey:@"hovered"] ?: [_scrollLayer.sublayers do:^(CAL*l){ [l setBool:areSame(l, tab) forKey:@"hovered"]; }];
 }() : nil;

 if (([theEvent type] == NSScrollWheel) && theEvent.deltaX ) {

 //		self.scrollPoint = AZPointOffsetX(_scrollPoint, theEvent.deltaX);
 //		if (ABS(_scrollPoint.x) >= unit) {
 //			[CATransaction immediately:^{
 //
 //				BOOL neg = _scrollPoint.x < 0;
 //				CALayer *mover =  neg ?  [_scrollLayer.sublayers firstObject] : [_scrollLayer.sublayers lastObject];
 //				neg ? [_scrollLayer addSublayer:mover] : [_scrollLayer insertSublayer:mover	atIndex:0];
 //				self.scrollPoint = NSZeroPoint;
 //			}];
 }
 [_scrollLayer setNeedsLayout];

 if (([theEvent type] == NSScrollWheel) && ([NSEvent modifierFlags] == NSCommandKeyMask)) {

 [self setFrameTopLeftPoint:AZPointOffsetY(AZTopLeft(self.frame), theEvent.deltaY)];
 }
 if (([theEvent type] == NSScrollWheel) && ([NSEvent modifierFlags] == (NSCommandKeyMask |  NSAlternateKeyMask))) {
 [self extendVerticallyBy:(int)theEvent.deltaY];
 }
 if (([theEvent type] == NSLeftMouseDragged) && ([NSEvent modifierFlags] == NSCommandKeyMask) && self.isMovableByWindowBackground == NO) {
 NSLog(@"Setting to be moveable");
 [self setMovableByWindowBackground:YES];
 [self sendEvent:theEvent];
 return;
 }
 [super sendEvent:theEvent];
 }
 //			[[_scrollLayer sublayers] eachWithIndex:^(CAL* obj, NSInteger idx) {
 //				NSR nw = AZRectExceptOriginX(obj.frame, obj.frame.origin.x + theEvent.deltaX);
 //				if (nw.origin.x < -unit) nw.origin.x =  AZScreenWidth() + unit;
 //				else if (nw.origin.x > AZScreenWidth() ) nw.origin.x = -unit;

 //				obj.frame = nw;
 //				[obj.sublayers  each:^(CAL *l) { [l setNeedsDisplay]; }];
 //			}];
 //}
 // ^{		[self setIgnoresMouseEvents:YES];
 //			AZLeftClick(mouseLoc());
 //			[self setIgnoresMouseEvents:NO];
 //		}();
 //	}
 //	if ([theEvent type] == NSLeftMouseUp ) {
 //		[self setIgnoresMouseEvents:NO];
 //		[self setMovableByWindowBackground:NO];
 //	}

 //		((CABA*)theA).keyPath = @"position.y";
 //		CGF p = [(CAL*)[layer modelLayer]position].y;
 //		((CABA*)theA).removedOnCompletion = YES;
 //		((CABA*)theA).toValue = [layer[@"hovered"]boolValue] ? @(p) : @( p - 200);
 //	}() :
 //	areSame(kCAOnOrderIn, event) ? ^ {
 //		CABasicAnimation * fold = [CABA animationWithKeyPath:@"transform"];
 //		CATransform3D up = CATransform3DMakePerspective(0, -.003);
 //		theA.toValue = AZV3d(up);
 //		theA.fromValue =AZV3d(CATransform3DIdentity);
 //		fold.duration = 3;
 //		scale = CATransform3DMakeScale(0.1f, 0.1f, 1.0f);
 //		rotate = CATransform3DMakeRotation(0, 1.5, 1, 0);
 //		combine = CATransform3DConcat(rotate, scale);
 //		((CABA*)theA).toValue = AZV3d(combine);
 //		theA = [CAAnimation popInAnimation];// [CAAnimation flipDown:2 scaleFactor:.5];

 //		AZV3d(CATransform3DConcat(transform, CATransform3DMakeTranslation(0, [layer[@"hovered"]boolValue] ? 200 : -200, 0)))
 //CATransform3DRotate(transform, DEG2RAD(2*M_PI), 0, 1, 0); //180 * M_PI/180

 //	if ([key isEqualToString:@"clicked"]) {
 //		CATransform3D transform = CATransform3DMakeRotation(M_PI, 0.0f,1.0f, 0.0f);
 //		CABA *flip  = [CABA animationWithKeyPath:@"poop"];
 //		CATransform3D transform = CATransform3DIdentity;
 //		transform.m34 = 1.0/700.0;
 //		transform = CATransform3DRotate(transform, 180 * M_PI/180, 1, 0, 0);
 //		flip.fromValue = AZV3d(CATransform3DIdentity);
 //		flip.toValue = AZV3d(transform);
 //		[anObject addAnimation:rotateAnimation];

 //	AZConstRelSuperScaleOff(kCAConstraintMinY,1,( AZHeightUnderMenu()-tab.boundsWidth))]];
 //	AZConstAttrRelNameAttrScaleOff(kCAConstraintMinY, @"superlayer",kCAConstraintMaxY, 1, -tab.boundsWidth)]];
 //	AZConstAttrRelNameAttrScaleOff(kCAConstraintMinY, @"superlayer", kCAConstraintMaxY, -1, vRect.size.width)]];
 //	 AZHeightUnderMenu() - unit, unit, unit};
 //		layer.frame = (NSR){ 0, AZHeightUnderMenu() - unit, unit, unit};
 //	= AZRectExceptOriginY(AZRectExceptOriginX(AZRectFromSize(perfectRect.size), (idx-1) * unit + _scrollPoint.x),AZHeightUnderMenu() - obj.boundsWidth);
 //	r.size = AZSizeFromDim(unit);


 //- (void) addTabConstraintsToTab:(CAL*)l {
 //	[l addConstraintsSuperSize];
 //	[l addConstraints:@[		 AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 1), AZConstRelSuperScaleOff(kCAConstraintMaxY, 1.2, 0)]];
 //	 AZConstRelSuperScaleOff(kCAConstraintMinY,1, AZHeightUnderMenu()-l.boundsWidth)]];
 //}
 //	self.bar = [[NSView alloc]initWithFrame:[self.contentView frame]];
 //	_bar.wantsLayer = YES;   //AZUpperEdge([[self contentView]frame], 400)];
 //	self.drawerView = [[NSView alloc]initWithFrame:AZUpperEdge([[self contentView]frame], 22)];
 //	_drawerView.arMASK = NSSIZEABLE;

 //	[self.contentView setSubvie/ws :@[_bar]];
 // [self.contentView setAutoresizesSubviews:YES];
 //	[((NSV*)self.contentView).layer addSublayer:drawer];
 //		[_spots setValue:AZVrect(vRect) forKey:obj];
 //			AZSimpleView *s = [[AZSimpleView alloc]initWithFrame:vRect];

 //		[self.scrollLayer scrollBy:(NSP){theEvent.deltaX , 0 }];//
 //		[self.scrollLayer scrollToPoint:_scrollPoint];
 //		CGF regulator 	= ABS(_scrollPoint.x) - (ABS(_unitOffset) * unit);
 //		CGF off 		=  regulator / unit; //-1  scrolling left,  1 scrolling right
 //		NSLog(@"scrollX:%f unit:%f normalOff:%f multi:%ld  floater:%f ", _scrollPoint.x, unit, regulator, _unitOffset, off)
 //		if ( ABS(off) >= 1 ) {
 //			BOOL neg = (off*_unitOffset) < 0;  int now = _unitOffset += neg ? -1 : 1;
 //												if ( now == 0 )  now = neg ? -1 : 1;
 //												self.unitOffset = now;

 //			CAL *v = neg ? [_scrollLayer sublayers][0] : [[_scrollLayer sublayers] lastObject];
 //			[v blinkLayerWithColor:RANDOMCOLOR];
 //			[CATransaction immediately:^{
 //				NSLog(@"_scroll: %@", [_scrollLayer debugLayerTree]);
 //				[v removeFromSuperlayer];
 //				v.hidden = YES;
 //				NSR newF = AZRectFromSize(perfectRect.size);
 //				newF.origin.x = neg ? AZScreenWidth() + unit : -unit;
 //				v.position = AZCenterOfRect(newF);
 //				neg ? [self.scrollLayer addSublayer:v] : [self.s \crollLayer insertSublayer:v atIndex:0];
 //				[self addTabConstraintsToTab:v];

 //				[v setNeedsDisplay];
 //				v.hidden = NO;

 //			}];
 //			[_scrollLayer setNeedsDisplay];
 //			[_scrollLayer setNeedsLayout];
 //		}

 //		[_scrollLayer.sublayers each:^(CAL * obj) {
 //			NSR f = AZRectHorizontallyOffsetBy(obj.frame, theEvent.deltaX);
 //			if ( obj.frame.origin.x > AZScreenWidth()) {
 //				NSRect pminus = AZRectHorizontallyOffsetBy(perfectRect, -unit);
 //				[CATransaction immediately:^{
 //					obj.frame = pminus;
 //////					[obj.layer setHidden:YES];
 //				//					[obj addConstraint:AZConstScaleOff(kCAConstraintMinX,supersuper.name, 1, -obj.boundsWidth)];
 //////					[obj.layer setHidden:NO];
 //				}];
 //////			[self enableFlushWindow];
 //			}
 //
 //			else [obj setFrame:f];
 //		}];
 //	}
	*/


//		NSPoint aPoint = [_bar convertPoint:[theEvent locationInWindow] toView:nil];
//		id viewHit = [_bar hitTest:aPoint];
//		AZSimpleView *winner = [viewHit isKindOfClass:[AZSimpleView class]] ? viewHit :
//							   [viewHit subviewsOfKind:[AZSimpleView class]][0] ?: nil;
//			The initializeClickThrough method does basically the following:
//
//			// Don't let our events block local hardware events
//			CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateSupressionInterval);
//			CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateRemoteMouseDrag);


//			winner.backgroundColor = [[winner.backgroundColor brighter]brighter];
//			NSRect saved = [[winner associatedValueForKey:@"oldFrame"]rectValue];
//			NSRect 	newF = AZRectVerticallyOffsetBy(saved, -300);
//					newF = AZRectExceptHigh(newF, NSHeight(newF)+300);
//			[[winner animator]setFrame:saved];
//			NSRect d = _drawerView.frame;
//			d.origin.y = newF.origin.y + 40;
//			[[_drawerView animator]setFrame: d];
////					[winner.layer animate:@"bounds" toCGRect:newF time:2];
////					[winner.layer animate:@"frame" toCGRect:newF time:2];;
////					[winner.layer flipDown];
//			[[[_bar subviews]arrayWithoutObject:winner]each:^(AZSimpleView *obj) {
////				NSRect savedOther = [[obj associatedValueForKey:@"oldFrame"]rectValue];
////				[[obj animator] setFrame:savedOther];
//			}];

//@end
//
//@implementation NSWindow (BorderlessInit)
//
//-(void) bordlerlessInit{
//	//	((NSV*)self.contentView).wantsLayer = YES;
//#ifdef AZMOVABLE
//	//									= YES;
//#else
//	//									= NO;
//#endif
//	self.backgroundColor		 	= [RED alpha:.2];//CLEAR;
//	self.opaque					 	= NO;
//	self.canHide				 	= NO;
//	self.hidesOnDeactivate		 	= YES;
//	self.ignoresMouseEvents		 	= NO;
//	self.acceptsMouseMovedEvents 	= YES;
//	self.movableByWindowBackground  = YES;
//	self.level 					 	= NSScreenSaverWindowLevel;//CGWindowLevelForKey(kCGCursorWindowLevelKey)];
//	self.collectionBehavior		 	= NSWindowCollectionBehaviorCanJoinAllSpaces |
//	NSWindowCollectionBehaviorStationary;
//}
//@end

//	NSLog(@"event: %@", 	event);
//	// look for mouse down
//	if ([event type] == NSLeftMouseDown) {
//		// look for deepest subview
//		AZSimpleView *deepView = (AZSimpleView*)[_bar hitTest:[event locationInWindow]];
////		if (deepView) {
//			for (AZSimpleView *aClickView in _clickViews) {
//				if ([deepView isSubviewOfView:aClickView]) {
//					[(id)aClickView setBackgroundColor:RANDOMCOLOR];//subviewClicked:deepView];
//					break;
//				}
//			}
////		}
//	}


//		[_bar trackFullView];
//		[NSEvent addLocalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^NSEvent *(NSEvent *e) {
//
//			NSP p = [_bar convertPoint:e. fromView:nil];
//			AZSimpleView *v = [_bar hitTest:p forClass:[AZSimpleView class]];
//			AZLOG(AZString(p));AZLOG(v);
//			if (_hoveredView != v) {
//				v.backgroundColor = RANDOMCOLOR;
//				self.hoveredView = v;
//			}
////			NSLog(@"Went:%@ of Color: %@", e.type == NSMouseEntered ?@"Into":@"Out of", [obj nameOfColor]);
//			return e;
//		}];
//		[_bar setCheckerboard:YES];
//		[_bar setNeedsDisplay:YES];
//		[_bar trackFullView];
//		[NSEVENTLOCALMASK:(NSMouseEnteredMask | NSMouseExitedMask) handler:^NSEvent *(NSEvent *d) {
//			AZLOG(d);
//			if (NSPointInRect(mouseLoc(), _bar.frame))
//				_bar.isHidden ? [_bar fadeIn] : nil;
//			else  !_bar.isHidden ? [_bar fadeOut] : nil;
//				//			d.type == NSMouseExitedMask ? [_bar fadeOut] : [_bar fadeIn];
//			AZLOG(@"entered or ewxit");
//			return d;
//		}];

//		[self setLevel:kCGStatusWindowLevel + 1];
//	  if ( [self respondsToSelector:@selector(toggleFullScreen:)] ) {
//			[self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces |
//			 NSWindowCollectionBehaviorTransient];
//   	} else {

//- (void) setFilter:(NSString *)filterName{
//	if ( fid ){	CGSRemoveWindowFilter( cid, wid, fid );	CGSReleaseCIFilter( cid, fid );	}
//	if ( filterName ) {	CGError error = CGSNewCIFilterByName( cid, (CFStringRef)filterName, &fid );
//		if ( error == noErr ) 		{	CGSAddWindowFilter( cid, wid, fid, 0x00003001 );
//}	}	}
//
//-(void)setFilterValues:(NSDictionary *)filterValues{
//	if ( !fid ) {	return;		}
//	CGSSetCIFilterValuesFromDictionary( cid, fid, (CFDictionaryRef)filterValues );
//}

/*

 add a click view

 click view must be a sub view of the NSWindow contentView
	*/

//- (void) addClickView:(AZSimpleView *)aView
//{
//	if ([aView isDescendantOf:[self contentView]] && [aView respondsToSelector:@selector(subviewClicked:)])
// _clickViews will maintain a weak ref to aView so we don't need to remove it
//}


//@implementation Drawer
//
//-(void) registerLevers:(NSView*)leverView
//{
//	static NSArray *baseline = nil;
//	baseline = [leverView.subviews map:^id(AZSimpleView *obj) {
//		return [NSValue valueWithPoint:[obj frame].origin];
//	}];
//
//	_leverView = leverView;
//	NSTimer *timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimeInterval time) {
//		[_leverView.subviews eachWithIndex:^(AZSimpleView *obj, NSInteger idx) {
//			CGF diff = [baseline[idx]pointValue].y - [obj frame].origin.y;
//			if (diff != 0) { NSLog(@"diff with Lever # %ld", idx);
//				NSRect selfframe = self.frame;
//				selfframe.origin.y += diff;
//				[self setFrame:selfframe display:YES animate:YES];
//			}
//		}];
//	} repeats:YES];
//}
//- (id) init
//{
//	NSRect 	f = AZRectExceptHigh(AZMenuBarFrame(), AZScreenHeight());
////			f = AZRectVerticallyOffsetBy(f, -100);
//
//	if (!(self = [self initWithContentRect:f styleMask:NSBorderlessWindowMask
//								   backing:NSBackingStoreBuffered	defer:NO] )) return nil;
//
//	[self bordlerlessInit];
//	self.backgroundColor		 = [RED alpha:.4];
//
//	_root  	= [[self contentView] setupHostView];
//	CALayer *drawer = [CALayer layer];
//	CALayer *liner  = [CALayer layer];
//	_root.layoutManager = AZLAYOUTMGR;
//	[drawer addConstraintsSuperSize];
//	[liner addConstraintsSuperSize];
//	[liner addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintMinY, 1, 15), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)]];
//	liner.contents = [NSImage imageNamed:@"black.minimal.jpg"];
//	AddShadow(drawer);
//	drawer.borderWidth 	= 20;
//	drawer.borderColor 	= cgBLACK;
//
//	liner.cornerRadius = 10;
//	AddShadow(liner);
////	w.delegate	 	= self;
////	[w setNeedsDisplay];
////	w.shadowOffset 	= AZMultiplySize(w.shadowOffset, .5);
////	w.cornerRadius 	= 7;
////	w.bgC	 		= [[NSColor leatherTintedWithColor:obj] CGColor];
//	_root.sublayers 	= @[drawer, liner];
//
//
//	return self;
//}
//
//@end
// This action method dispatches mouse and keyboard events sent to the window by the NSApplication object.
// We intercept the sendEvent: method at the NSWindow level to inspect it.
// If the event type is a click ("NSLeftMouseDown") and the element that the mouse
// is hovering over is an input, then we do something
//
//
//@interface AZLayerTabWindow :NSWindow
//@end
//@implementation AZLayerTabWindow
//
//-(id) initPositioned:(AZPOS)pos againstRect:(NSRect)parent withFrame:(NSR)frame
//{
//	//	self addChildWindow:(NSWindow *)win ordered:<#(NSWindowOrderingMode)#>
//	if (!(self = [self initWithContentRect:frame styleMask:NSBorderlessWindowMask
//								   backing:NSBackingStoreBuffered	defer:NO] )) return nil;
//
//	[self bordlerlessInit];
//
//	CALayer *root  = [self.contentView setupHostView];
//	root.layoutManager = AZLAYOUTMGR;
//	CALayer *edge  = [CALayer layer];
//	CALayer *tab   = [CALayer layer];
//	root.sublayers = @[edge, tab];
//	[root.sublayers eachWithIndex:^(CAL *obj, NSInteger idx) {
//
//		[obj addConstraintsSuperSize];
//		obj.orient = pos;
//		AddShadow(obj);
//		obj.cornerRadius = idx == 0 ? AZMaxDim(obj.boundsSize) *.2 : AZMaxDim(obj.boundsSize) *.1;
//		obj.anchorPoint = AZAnchorPtAligned(pos);
//		obj.bgC = idx == 0 ? cgWHITE : [[NSColor leatherTintedWithColor:RANDOMCOLOR]CGColor];
//		//		[obj addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintHeight, .9, 0), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)]];
//		obj.delegate = self;
//		[obj setNeedsDisplay];
//	}];
//	//	w.anchorPoint 	= AZAnchorBottom;
//	//	w.position	 	= NSMakePoint(NSWidth(vRect)/2, 30);
//
//	//	w.shadowOffset 	= AZMultiplySize(w.shadowOffset, .5);
//	//	w.cornerRadius 	= 7;
//	//	w.bgC	 		= [[NSColor leatherTintedWithColor:obj] CGColor];
//	//	u.sublayers 	= @[uu, w];
//	//	u.name = [NSS randomWords:1];
//
//}
//
//@end

//@interface MenuBarWindowFrame : NSView
//@property (assign, nonatomic) NSR resizeRect;
//@end
//
//@implementation MenuBarWindowFrame
//
////
//// resizeRect
////
//// Returns the bounds of the resize box.
////
//- (NSRect)resizeRect
//{
//
//	return AZRectFromDim(100);
//	//	const CGF resizeBoxSize = 16.0;
//	//	const CGF contentViewPadding = 5.5;
//	//
//	//	NSRect contentViewRect = [[self window] contentRectForFrameRect:[[self window] frame]];
//	//	NSRect resizeRect = NSMakeRect(
//	//								   NSMaxX(contentViewRect) + contentViewPadding,
//	//								   NSMinY(contentViewRect) - resizeBoxSize - contentViewPadding,
//	//								   resizeBoxSize,
//	//								   resizeBoxSize);
//	//
//	//	return resizeRect;
//}

//
// mouseDown:
//
// Handles mouse clicks in our frame. Two actions:
//	- click in the resize box should resize the window
//	- click anywhere else will drag the window.
//
//- (void) mouseDown:(NSEvent *)event
//{
//	NSPoint pointInView = [self convertPoint:[event locationInWindow] fromView:nil];
//
//	BOOL resize = NO;
//	if (NSPointInRect(pointInView, [self resizeRect]))
//	{
//		NSBeep();
//
//		resize = YES;
//	}
//
//	NSWindow *window = [self window];
//	NSPoint originalMouseLocation = [window convertBaseToScreen:[event locationInWindow]];
//	NSRect originalFrame = [window frame];
//
//	while (YES)
//	{
//		[AZTalker say:@"dragging"];
//		//
//		// Lock focus and take all the dragged and mouse up events until we
//		// receive a mouse up.
//		//
//		NSEvent *newEvent = [window
//							 nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
//
//		if ([newEvent type] == NSLeftMouseUp)
//		{
//			break;
//		}
//
//		//
//		// Work out how much the mouse has moved
//		//
//		NSPoint newMouseLocation = [window convertBaseToScreen:[newEvent locationInWindow]];
//		NSPoint delta = NSMakePoint(
//									newMouseLocation.x - originalMouseLocation.x,
//									newMouseLocation.y - originalMouseLocation.y);
//
//		NSRect newFrame = originalFrame;
//
//		if (!resize)
//		{
//			//
//			// Alter the frame for a drag
//			//
//			newFrame.origin.x += delta.x;
//			newFrame.origin.y += delta.y;
//		}
//		else
//		{
//			//
//			// Alter the frame for a resize
//			//
//			newFrame.size.width += delta.x;
//			newFrame.size.height -= delta.y;
//			newFrame.origin.y += delta.y;
//
//			//
//			// Constrain to the window's min and max size
//			//
//			NSRect newContentRect = [window contentRectForFrameRect:newFrame];
//			NSSize maxSize = [window maxSize];
//			NSSize minSize = [window minSize];
//			if (newContentRect.size.width > maxSize.width)
//			{
//				newFrame.size.width -= newContentRect.size.width - maxSize.width;
//			}
//			else if (newContentRect.size.width < minSize.width)
//			{
//				newFrame.size.width += minSize.width - newContentRect.size.width;
//			}
//			if (newContentRect.size.height > maxSize.height)
//			{
//				newFrame.size.height -= newContentRect.size.height - maxSize.height;
//				newFrame.origin.y += newContentRect.size.height - maxSize.height;
//			}
//			else if (newContentRect.size.height < minSize.height)
//			{
//				newFrame.size.height += minSize.height - newContentRect.size.height;
//				newFrame.origin.y -= minSize.height - newContentRect.size.height;
//			}
//		}
//
//		[window setFrame:newFrame display:YES animate:NO];
//	}
//}
//
//
// drawRect:
//
// Draws the frame of the window.
//
//- (void) drawRect:(NSRect)rect
//{
//	[RED set];
//	NSRectFill(self.resizeRect);

//	NSBezierPath *circlePath = [NSBezierPath bezierPathWithOvalInRect:[self bounds]];
//
//	NSGradient* aGradient =
//	[[NSGradient.alloc //	  initWithColorsAndLocations:
//	  [NSColor whiteColor], (CGF)0.0,
//	  [NSColor lightGrayColor], (CGF)1.0,
//	  nil]
//	 autorelease];
//	[aGradient drawInBezierPath:circlePath angle:90];
//
//	[[NSColor whiteColor] set];
//	[circlePath stroke];
//
//	NSRect resizeRect = [self resizeRect];
//	NSBezierPath *resizePath = [NSBezierPath bezierPathWithRect:resizeRect];
//
//	[[NSColor lightGrayColor] set];
//	[resizePath fill];
//
//	[[NSColor darkGrayColor] set];
//	[resizePath stroke];
//
//	[[NSColor blackColor] set];
//	NSString *windowTitle = [[self window] title];
//	NSRect titleRect = [self bounds];
////	titleRect.origin.y = titleRect.size.height - (WINDOW_FRAME_PADDING - 7);
////	titleRect.size.height = (WINDOW_FRAME_PADDING - 7);
//	NSMutableParagraphStyle *paragraphStyle =
//	[[NSMutableParagraphStyle.alloc init] autorelease];
//	[paragraphStyle setAlignment:NSCenterTextAlignment];
//	[windowTitle
//	 drawWithRect:titleRect
//	 options:0
//	 attributes:[NSDictionary
//				 dictionaryWithObjectsAndKeys:
//				 paragraphStyle, NSParagraphStyleAttributeName,
//				 [NSFont systemFontOfSize:14], NSFontAttributeName,
//				 nil]];
//}

//@end
//@interface AZDrawerWindow : AZSemiResponderWindow
//@end
//@implementation AZDrawerWindow
//- (id) init { if (!(self = [self initWithContentRect:AZScreenFrameUnderMenu() styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO] )) return nil;
//	CASL *drawer 	 		= [CASL layerNamed:@"drawer"	 	];
//	CAL  *liner  	 		= [CAL  layerNamed:@"liner"		];
//	drawer.sublayers 		= @[liner];
//	[@[drawer, liner] do:^(CAL* obj) {	obj.zPosition = -10000; obj.cornerRadius = 20;	[obj addConstraintsSuperSize];
//		obj.opaque 	  = YES;   	AddShadow( obj );									}];
//
//	drawer.lineWidth		= 30;
//	drawer.strokeColor 		= cgBLACK;
//	drawer.frame 			= AZScreenFrameUnderMenu();//, AZHeightUnderMenu() );
//	drawer.path				= [[NSBezierPath bezierPathWithRect: drawer.frame] newQuartzPath];
//	//	liner.constraints 		= @[AZConstRelSuperScaleOff(kCAConstraintMinY, 1, 15), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)];
//	liner.contents 			= [NSImage imageNamed:@"background_folder.png"];//@"black.minimal.jpg"];
//	liner.contentsGravity 	= kCAGravityResize;
//	drawer.delegate			= self;
//	return self;
//}
//@end

//Then, if I want to run animation completion code after a CAAnimation finishes, I set myself as the delegate of the animation, and add a block of code to the animation using setValue:forKey:
//	animationCompletionBlock theBlock = ^void(void)	{	//Code to execute after the animation completes goes here		};

//	[theAnimation setValue: theBlock forKey: kAnimationCompletionBlock]

//	Then, I implement an animationDidStop:finished: method, that checks for a block at the specified key and executes it if found:

/*	 - (void) nimationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag	 {
 animationCompletionBlock theBlock = theAnimation[kAnimationCompletionBlock];
 theBlock ? theBlock() : nil;	 }	*/
