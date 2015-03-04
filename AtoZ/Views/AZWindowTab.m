//@interface AZWindowTab () { CGP	_drgStrt, _wOrig, _offset; NSView *_view, *_handle; }
//
//@property AZWindowTabViewPrivate *tab;
//@property (NATOM)		       AZR * inFrame, * outFrame, * grabRect, * outerRect;
//
////@property (NATOM) AZSlideState 	slideState; // !!!
//@prop_RO OSCornerType 	outsideCorners;
//@end

#import <AtoZ/AtoZ.h>
#import "BoundingObject.h"
#import "AZWindowTab.h"

@implementation AZWindowTab  static NSMA *allTabs = nil; static NSPoint mDragOffset;

- (id)initWithView:(NSV *)v orClass:(Class)k frame:(NSR)r {

  self = [super initWithContentRect:r styleMask:0|1|2|8 backing:0 defer:NO];
	if (NSEqualRects(NSZeroRect, r) && v) r = v.frame; // if there's a view, use its frame, but check for nanRect.
	if (NSEqualRects(NSZeroRect, r)) r = AZRectFromDim(400);
	NSR tabFrame = AZRectBy(r.size.width + 100, r.size.height + 200); self.frame = tabFrame;
	return self;
}


- (void) sendEvent:(NSEvent*)e {

  CGRect b = [self convertRectFromScreen:self.r];

  e.type == NSLeftMouseDown ? ({

    mDragOffset = AZSubtractPoints(b.origin,e.locationInWindow);

  }) : e.type == NSLeftMouseDragged ? ({

//    b = AZRectOffsetByPt(b, AZAddPoints(e.locationInWindow, mDragOffset));
//    b.origin.x = p.x + mDragOffset.x;
//    b.origin.y = p.y + mDragOffset.y;

    b = [self convertRectToScreen:AZRectOffsetByPt(b, AZAddPoints(e.locationInWindow, mDragOffset))];
    XX(b);
    NSR newB = AZRectInsideRectOnEdge(b, self.superframe,self.insideEdge);
    XX(newB);
    XX(AZAlignToString(self.insideEdge));
    [self setFrame:newB display:YES];

//AZOutsideEdgeOfPointInRect ( NSE.mouseLocation, AZScreenFrameUnderMenu());
//		_offset         = AZSubtractPoints ( NSE.mouseLocation, AZSubtractPoints ( _drgStrt, _wOrig));
//		self.frame = _slideState == AZIn ? self.inFrame.frame : self.outFrame.frame;


  }) : e.type == NSLeftMouseUp ? ({

    //  Nothing really needs be done here
    if (e.clickCount == 2) {
//      if (self.expanded) self[@"savedOutset"] = _insidedge
    CABA* a = [CAA rotationAt:self.maxXminY center:self.centerPt by:90];
    a.delegate = self;
    [self.layer addAnimation:a forKey:nil];
//      [self animateInsetTo:30 anchored:self.insideEdge];
//    }
//    if (e.clickCount == 3) {

//      [self rotate:DEG2RAD(90) about:NSZeroPoint];//self.maxXminY];// AZAnchorPointOfActualRect(self.r, AZTopLft)];
    }
  }) : nil;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag   { NSBeep();
//[self destroyTransformingWindow];
}

- (instancetype) init {

	if (!(self = [super initWithContentRect:self.defaultFrame styleMask:NSBorderlessWindowMask|NSResizableWindowMask
											 backing:NSBackingStoreBuffered defer:NO])) return nil;

  self.acceptsMouseMovedEvents = YES;
  [self overrideCanBecomeKeyWindow:YES];

  [self overrideResponder:@selector(acceptsFirstResponder)   withBool:YES];
  
  self.expanded = YES;
  self.superframe = AZScreenFrameUnderMenu();
	self.contentView  = [BLKVIEW viewWithFrame:self.contentRect drawBlock:^(BNRBlockView *v, NSRect r) {
    AZWT *tab = (id)v.window;
    NSRectFillWithColor(r, GREEN);
    NSString *s = AZAlignToString(tab.insideEdge);
    [s drawAtPoint:r.origin withAttributes:NSAS.defaults];
  }];

	self.level        = NSScreenSaverWindowLevel; // NSFloatingWindowLevel;

  [self addKVOBlockForKeyPath:@"insideEdge" options:NSKeyValueObservingOptionNew handler:^(NSString *keyPath, id object, NSDictionary *change) {
    NSBeep();
     [[object contentView] setNeedsDisplay:YES];
  }];

//  self.tab = [AZWindowTabViewPrivate.alloc initInWindow:self withContent:nil andTab:nil];
//	self.delegate     = (id<NSWindowDelegate>)self;
//	[self  addObserverForKeyPaths:@[NSWindowDidBecomeKeyNotification,NSWindowDidResignKeyNotification] task:^(id obj, NSString *keyPath) {
//		[obj setSlideState:SameString(NSWindowDidResignKeyNotification, keyPath) ? AZOut : AZIn];
//		NSLog(keyPath);
//	}];
//	[self makeKeyAndOrderFront:nil];	
//	[self overrideViewResponder];
//	[allTabs = allTabs ? :NSMA.mutableArrayUsingWeakReferences addObject:self];
//	XX(allTabs.count);
//	XX(self.frame);
//	self.slideState = AZIn;
	return self;
}
- (void) setView:  (NSView*)view { 
	
//	if (_view && [self.contentView subviews].count && [[self.contentView subviews]containsObject:_view]) [_view removeFromSuperview];
  [view setFrame:AZInsetRect(self.contentRect, 14)];
  [self.contentView addSubview:view];
}

- (NSR) defaultFrame { return  (NSR){ NSMidX(AZScreenFrameUnderMenu())-100, NSMaxY(AZScreenFrameUnderMenu())-100, 200, 100}; }

//- (void) setInsideEdge:(AZAlign)i {	_insideEdge = i;  	}

//- (void) setSlideState:(AZSLDST)s	{ if(_slideState == s) return;

//	if (self.slideState == AZOut) 
	//[self setAssociatedValue:@YES forKey:@"restore" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
//	NSR newR  = s == AZIn ? self.inFrame.r : self.outFrame.r; _slideState = s;

//	[self animateToFrame:newR duration:1];// timing:CAMEDIAEASEOUT];
//}

- (AZR *)grabRect                {	AZA o = self.insideEdge; //self.grabInset * 2)));

	return 	o == AZTop ?  $AZR(AZLowerEdge(self.bounds, self.inSize.height))
			: 	o == AZLft ?  $AZR(AZRightEdge(self.bounds, self.inSize.width))
			:   o == AZBtm ?  $AZR(AZUpperEdge(self.bounds, self.inSize.height))
			: 	o == AZRgt ?  $AZR(AZLeftEdge (self.bounds, self.inSize.width))
			:                 $AZR(AZCornerRectPositionedWithSize(self.bounds, AZPositionOpposite(o), AZSizeFromDim(AZMaxDim(self.inSize)*2)));
}

- (AZR*) inFrame                 {
	AZRect *theStart        = self.outFrame;        AZA inE = self.insideEdge;

	return 	inE == AZLft ? $AZR(AZRectExceptOriginX( theStart.r,  					  - self.width  + AZMinDim(self.inSize)*2)) //self.grabInset * 2))
			: 	inE == AZTop ? $AZR(AZRectExceptOriginY( theStart.r, theStart.y + theStart.height - AZMinDim(self.inSize)))//self.grabInset))
			: 	inE == AZRgt ? $AZR(AZRectExceptOriginX( theStart.r, theStart.x + theStart.width  - AZMinDim(self.inSize)))//self.grabInset))
			: 	inE == AZBtm ? $AZR(AZRectExceptOriginY( theStart.r, theStart.y - theStart.height + AZMinDim(self.inSize))) : theStart;
		//		return inFrame  = CGRectIsNull(inFrame)  ? self.frame : inFrame;  }
}

- (AZR *)outFrame                {	_outFrame      = $AZR( AZRectInsideRectOnEdge ( self.frame, _outerRect.r, self.insideEdge));

	self.insideEdge == AZRgt | self.insideEdge == AZLft ? [_outFrame setY:_offset.y] : [_outFrame setX:_offset.x];
	_outFrame.x = MAX( _outFrame.x, 0);
	_outFrame.y= MAX( _outFrame.y, 0);
	_outFrame.x = MIN( _outFrame.x, _outerRect.width  -  _outFrame.width );
	_outFrame.y = MIN( _outFrame.y, _outerRect.height -  _outFrame.height);       return _outFrame;
}

- (CRNR)outsideCorners           {	 AZPOS o = AZPositionOpposite(self.insideEdge);
	return 	o == AZTop ? ( OSBottomLeftCorner | OSBottomRightCorner )
			: 	o == AZLft ? (   OSTopRightCorner | OSBottomRightCorner )
			: 	o == AZBtm ? (    OSTopLeftCorner | OSTopRightCorner    )
			: 					 (    OSTopLeftCorner | OSBottomLeftCorner  );                                              //	o == AZRgt  ?
}

#pragma mark - NSResponder

@end

@interface AZWindowTabViewPrivate : NSView
@property           CAL * contentLayer,
                        * tabLayer;
@prop_RO NSIMG * indicator;
@prop_RO 	NSR	  tabRect;
@property (CP) void(^closedTabDrawBlock)(NSRect tabRect);
@end

@implementation AZWindowTabViewPrivate

-      (id) initInWindow:(NSW*)w withContent:(CAL*)cnt andTab:(CAL*)tab {

	if (self != [super initWithFrame:w.contentRect]) return nil;
  self.layerUsesCoreImageFilters = YES;
	CAL *l 				= CAL.new;
	self.layer  		= l;
	self.wantsLayer 	= YES;
	l.loM 				= self;
	l.backgroundColor = LINEN.CGColor;
	[l addSublayer:self.contentLayer  = cnt ?: [CAL layerWithFrame:self.bounds]];
	[l addSublayer:self.tabLayer      = tab ?: [CAL layerWithFrame:self.bounds]];
	[@[self.contentLayer, self.tabLayer] each:^(CAL* obj) {
		obj.borderWidth = 5;
		obj.delegate 	= self;
		obj.borderColor = cgRANDOMCOLOR;
		CIFilter *blurFilter = [CIFilter filterWithName:@"CIDiscBlur"];
		[blurFilter setDefaults];
		[blurFilter setValue:@(5) forKey:@"inputRadius"];
		obj.filters = @[blurFilter];

//		obj.compositingFilter = [CIFilter filterWithName:@"CIDifferenceBlendMode"];;
		if (!tab && obj == self.tabLayer) 		obj.bgC   = cgRANDOMGRAY;
		if (!cnt && obj == self.contentLayer) obj.bgC 	= cgRANDOMCOLOR;
	}];	//v ?: (NSV*)[AZGrid.alloc initWithFrame:AZInsetRect(w.contentRect, 10)]];
	[self observeFrameChangeUsingBlock:^{	[l setNeedsLayout];  }];

	[self bind:@"indicator" toObject:w withKeyPath:@"insideEdge" transform:^id (id edge) {

    [AZTalker sayFormat:@"Inside edge:%@", AZAlignToString([edge unsignedIntegerValue])];
		return [l setNeedsDisplay], [l setNeedsLayout], [NSIMG imageForSize:AZSizeFromDim(25) withDrawingBlock:^{
			[[NSBP bezierPathWithTriangleInRect:AZRectFromDim(25)
											orientation:(AZCompass)AZAlignToNormalBitmask([edge unsignedIntegerValue])]
										 fillWithColor:RANDOMCOLOR];
		}];
	}];
	l.delegate = self;
	[l setNeedsDisplay];
	[l setNeedsLayout];
  return self;
//	tab.contentView.arMASK =   NSViewWidthSizable	|	NSViewHeightSizable	|	NSViewMinXMargin	|
//										NSViewMaxXMargin		|	NSViewMaxYMargin		|	NSViewMinYMargin;
//	id (^ frameTransform)(id) = ^id (id edge) {
//		CGF hot = w.grabInset.fV * 2;
//		AZA align = w.insideEdge;
//		NSR cr = AZInsetRect(tab.bounds, w.grabInset.fV * 2);
//		NSR p = align == AZAlignTop ? AZRectExtendedOnBottom(cr, hot)
//		: align == AZAlignBottom ? AZRectExtendedOnTop(cr, hot)
//		: align == AZAlignLeft ? AZRectExtendedOnRight(cr, hot)
//		: AZRectExtendedOnLeft(cr, hot); return AZVrect(p);
//	};
		//	id(^originTransform)(id) = ^id(id edge){
		//		NSP p = align == AZAlignTop         ? (NSP){hot, 2*hot}
		//			    : align == AZAlignBottom    ? (NSP){ hot, 0}
		//				: align == AZAlignLeft      ? (NSP) { 0, hot}
		//				: (NSP) {2*hot, hot}; return AZVpoint(p);
		//	};
		//	id(^sizeTransform)(id) = ^id(id edge){
		//		NSR p = align == AZAlignTop	? AZRectExtendedOnBottom(cr,hot)
		//				: align == AZAlignBottom ?AZRectExtendedOnTop(cr,hot)
		//				: align == AZAlignLeft      ? AZRectExtendedOnRight(cr,hot)
		//			: AZRectExtendedOnLeft(cr,hot); return AZVsize(p.size);
		//	};
		//	AZBindTransf(tab.contentView,@"frame",w,@"insideEdge", frameTransform);

		//	AZBindTransf(tab.contentView,@"frameOrigin",w,@"insideEdge", originTransform);
		//	AZBindTransf(tab.contentView,@"frameSize",w,@"insideEdge", sizeTransform);
		//	[tab.contentView setFrameOrigin:NSZeroPoint];
		//			tab.contentView.originX = o.x; tab.contentView.originY = o.y;

		//	[tab.contentView bind:@"frame" toObject:w withKeyPath:@"grabInset" transform:^id(id inset) {
		//	}];
		//		tab.contentView.frame = [frameTransform(@(w.insideEdge)) rV];
	//	[tab bind:@"tabRect" toObject:w withKeyPath:@"slideState" transform:^id(id state) {		}];
		//	return tab;
}
- (NSMenu*) menuForEvent:          (NSE*)e {	NSMenu *m = [NSMenu.alloc initWithTitle:@"Process"];	m.dark = YES;

	[m addItems:[NSA arrayWithArrays:
		@[@[[	NSMenuI.alloc initWithTitle:@"HugeVageen" action:@selector(terminate:) keyEquivalent:@"q"],
				NSMenuI.separatorItem],
			[@[ @"NSNormalWindowLevel",             @"NSFloatingWindowLevel",       @"NSMainMenuWindowLevel",       @"NSStatusWindowLevel",
				 @"NSModalPanelWindowLevel",    @"NSPopUpMenuWindowLevel", @"NSScreenSaverWindowLevel"] cw_mapArray : ^id (id obj) {

				NSMenuI *n = [NSMenuI.alloc initWithTitle:obj action:NSSelectorFromString(@"setWindowLevel:") keyEquivalent:@""];
						   n.representedObject     = self;
					 		n.tag = [obj intValue];
				return n; }],
			@[[NSMenuItem.alloc initWithTitle:@"Close Window" target:self action:@selector(closeWindow:) keyEquivalent:@"" representedObject:self],
				NSMenuI.separatorItem,]
	]]];
	[m.itemArray each:^(NSMenuItem *mm) { 	//Use the function setAttributedTitle to set the title of the list item with the attributes you specified
		[mm setAttributedTitle:[NSAS.alloc initWithString:mm.title attributes:@{	NSFontAttributeName : [NSFont fontWithName:@"UbuntuMono-Bold" size:12],
																									NSForegroundColorAttributeName : WHITE}]];
	}];
	return m;
}
//-    (void) layoutSublayersOfLayer:(CALayer *)layer {
//
//	CGF hot = 20; //((AZWT*)self.window).AZMinDim(_inSize)((AZWindowTab*)self.window).inSize)*2)//grabInset*2;
//	AZA align = ((AZWT *)self.window).insideEdge;
//	AZRect *cR = $AZR(self.bounds);
//	[CATRANNY immediately:^{
//		NSR tabR =
//		self.tabLayer.frame =  align == AZAlignTop 		? 	(NSR) { hot, 		hot / 2, 		cR.w, 		hot / 2}
//									: align == AZAlignBottom 	? 	(NSR) { hot, 		cR.maxY, 		cR.w, 		hot / 2}
//									: align == AZAlignLeft 		?	(NSR) { cR.maxX, 	hot, 				hot / 2, 	cR.h}
//																		: 	(NSR)	{ 0, 			hot, 				hot / 2, 	cR.h};
//		AZRect *t = $AZR(self.bounds);
//		self.contentLayer.frame = [align == AZAlignTop 		?	[t shiftedX:hot y:hot w:-2 * hot 	h:-hot]
//										  :align == AZAlignBottom 	? 	[t shiftedX:hot y:0   w:-2 * hot 	h:-hot]
//										  :align == AZAlignLeft 	? 	[t shiftedX:0   y:hot w:-hot 		h:-2 * hot]
//																			: 	[t shiftedX:hot y:hot w:-hot h:-2 * hot] frame];
//	}];
//		//	]if () { [t moveByX:0 andY:t.h]; t.h = self.height -hot; }
//		//	if (align == AZAlignBottom) { [t moveByX:0 andY:-t.h]; t.h = self.height -hot; }
//		//	if (align == AZAlignLeft) { [t moveByX:-t.w andY:0]; t.w = self.width -hot; }
//		//	if (align == AZAlignRight) { [t moveByX:t.w andY:0]; t.w = self.width -hot; }
//		//	self.contentView.frame = t.rect;
//
//}

- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

	[NSGC drawInContext:ctx flipped:NO actions:^{
//		NSRectFillWithColor(r, [NSC colorWithPatternImage:[NSIMG imageNamed:@"wall"]]);
		[(NSSHDW *)[NSSHDW shadowWithBlurRadius:20 offset:NSZeroSize color:WHITE] set];
//		NSBP *p = [NSBP bezierPathWithRect:self.contentView.frame];
//	p.dashPattern = @[@15, @15];
//	[p strokeWithColor:BLACK andWidth:5];

//	NSRectFillWithColor(self.tabRect, PINK);

//	[RED set]; NSFrameRect(r);
		[self.indicator drawAtPoint:NSZeroPoint];
	}];
}
- (BOOL) acceptsFirstMouse:(NSEvent *)theEvent { return YES; }
@end




@implementation AZWindowTabController
@end


/*

//+ (id) tabWithViewClass:(Class)k		{
//
//	id retVal = [self.alloc initWithFrame:NSZeroRect];
//	[k.alloc initWithFrame:AZRectFromDim(200)] 
//												  orClass:NULL frame:NSZeroRect];
//	[retVal overrideViewResponder];	return retVal;
//}


//- (void) setContentView:(NSView*)aView { if !aView || self.contentView return;
//
//
//
//	self.contentView = aView; 
//	objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


//	[_view bind:@"bounds]
		


//- (id) contentView { return  [AZSimpleView withFrame:self.contentRect color:YELLOW]; }

//- (void) crollWheel:(NSEvent *)e {	self.grabInset = _grabInset + e.deltaY; [self.contentView setNeedsDisplay:YES]; }

- (void) mouseDown:(NSE *)e   		{ 	// Mask out everything but the key flags

	NSUInteger flags = e.modifierFlags & NSDeviceIndependentModifierFlagsMask;
	if ( flags == NSCommandKeyMask )	[self menu];
	
	if ( e.clickCount == 2 ) {          /// && NSPointInRect(e.locationInWindow, self.grabRect.r)) {
		[AZTalker say:@"toggling"];
		self.slideState = _slideState == AZIn ? AZOut : AZIn;
		return;
	}
	_drgStrt        = NSE.mouseLocation;	// save initial mouse Location point.
	_wOrig          = self.frame.origin;   // save initial origin.
	while (e.type != NSLeftMouseUp) {
		e = [self nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask];
		self.insideEdge = AZOutsideEdgeOfPointInRect ( NSE.mouseLocation, _outerRect.frame);
		_offset         = AZSubtractPoints ( NSE.mouseLocation, AZSubtractPoints ( _drgStrt, _wOrig));
		self.frame = _slideState == AZIn ? self.inFrame.frame : self.outFrame.frame;
	}
}


- (void) overrideViewResponder	{

//  NSA *views = @[self.contentView];// arrayByAddingObjectsFromArray:[self.contentView allSubviews]];
	[[self.contentView allSubviews] each:^(id obj) {
		if ([obj acceptsFirstMouse:nil] != YES)
			[obj az_overrideSelector:@selector(acceptsFirstMouse:) withBlock:(__bridge void *)^BOOL (id _self, NSE *e) {
				return NSLog(@"i am azframeworks' bitch.. i will acceptfirstMouse! %@ %@", e, [_self class]), YES;
		}];
	}];
} // Set acceptsFirstMouse: in all subviews.

								 //instanceInWindow:self withView:v ?: [BLKV viewWithFrame:self.contentRect opaque:NO drawnUsingBlock:^(BNRBlockView *v, NSRect r) {
						NSRectFillWithColor( quadrant(r,2), RED );
					[[NSIMG badgeForRect:quadrant(r, 1) withColor:RANDOMCOLOR stroked:BLACK withString:$(@"%ld", [allTabs indexOfObject:self])] drawAtPoint:AZCenter(r)];
				//[$(@"%ld", [allTabs indexOfObject:self]) drawInRect:quadrant(r, 1) withFont:[AtoZ.controlFont fontWithSize:29] andColor:GRAY5];
				[(NSIMG*)[NSIMG imageNamed:@"1"]drawAtPoint:NSZeroPoint];
							[[NSBP bezierPathWithCappedBoxInRect:AZRectInsideRectOnEdge(AZCenterRectInRect(AZRectFromDim(49),self.bounds),self.bounds,self.insideEdge)]fillWithColor:PURPLE];
			}]];
	if (v) {
		[tab.contentView addSubview:v];
//		[tab.contentView removeFromSuperview];
//		tab.contentView = v;
		v.arMASK = NSSIZEABLE;
		[v log];
		LOG_EXPR(v.frame);
		[AZTalker say:@"found the view"];
	}
	else [AZTalker say:@"danger...missing view"];
	if (0) {
	[self.contentView addSubview: [BLKV viewWithFrame:self.contentRect opaque:NO drawnUsingBlock:^(BNRBlockView *v, NSRect r) {

		NSRectFillWithColor( quadrant(r,2), RED );
		[[NSIMG badgeForRect:quadrant(r, 1) withColor:RANDOMCOLOR stroked:BLACK withString:$(@"%ld", [allTabs indexOfObject:self])] drawAtPoint:AZCenter(r)];
		//[$(@"%ld", [allTabs indexOfObject:self]) drawInRect:quadrant(r, 1) withFont:[AtoZ.controlFont fontWithSize:29] andColor:GRAY5];
		[(NSIMG*)[NSIMG imageNamed:@"1"]drawAtPoint:NSZeroPoint];

		[[NSBP bezierPathWithCappedBoxInRect:AZRectInsideRectOnEdge(AZCenterRectInRect(AZRectFromDim(49),self.bounds),self.bounds,self.insideEdge)]fillWithColor:PURPLE];

	}]];
x	}

 CAT3D transform      = CATransform3DIdentity;
 transform.m34            = -1.f / 700.f;	// Apply a perspective transform onto the layer.
 self.layer.transform = transform;
 CABA *animation      = [CABA animationWithKeyPath:@"transform.rotation.x"];              // Do a barrel roll.
 animation.duration   = 3;
 animation.toValue        = @(2*M_PI);
 //   animation.timing		= CAMEDIAEASY;
 [BlockDelegate delegateFor:self.layer ofType:CABlockTypeAniComplete withBlock:^(CAA*a, BOOL c){
 [self destroyTransformingWindow];
 playTrumpet();
 }];
 //	animatio    = self;											// Set the delegate on the animation so we know when to remove the fake window.
 [self.layer addAnimation:animation forKey:nil];
 [self animateToFrame:newR duration:1];


-  (AZP) insideEdge               {  return _insideEdge =  AZOutsideEdgeOfRectInRect(self.frame, _outerRect.r);	}
			AZOutsideEdgeOfPointInRect(AZCenter(self.frame), _outerRect.r);

	if ([event type] == NSLeftMouseUp) {	[self mouseUp:event];	}

		[NSAnimationContext begin:YES duration:5];
		_grab.bgC = cgRANDOMCOLOR;
		self.slideState     = _slideState == AZIn ? AZOut : AZIn;

}(): e.type == NSLeftMouseDown  && e.clickCount != 2  ? ^{  //&& e.type != NSLeftMouseDragged

//	if (_view)  [_view.layer animate:@"opacity" to:0 time:.5 completion:^{ / * [_view removeFromSuperview]; x.marquee.strokeEnd = 0; * / }];
	_drgStrt    = NSE.mouseLocation;		// note our starting point.
	_wOrig      = self.frame.origin;        // save initial origin.
	}(): nil;

[WindowTabController setWindow:self] }(): nil;

- (void) mouseDragged:(NSE*)e	{

	self.insideEdge     = AZOutsideEdgeOfPointInRect ( NSE.mouseLocation, _outerRect.r);
	self.offset         = AZSubtractPoints ( NSE.mouseLocation, AZSubtractPoints ( _drgStrt, _wOrig));
//	self.frame          = self.rectForState;
//	self.slideState     = _slideState;
//	AZRect * _outFrame  = [self frameInRect:AZScreenFrameUnderMenu() offset:offset insideEdge:ptEdge];	self.insideEdge =  _outFrame .orient; self.frame =  _outFrame .r;	LOGCOLORS(@"newframe:", _outFrame , @"newloc ",AZPositionToString( _outFrame .orient),  zNL, RANDOMPAL, nil);
}


 outFrame = CGRectIsNull(outFrame) ? self.frame : outFrame; }
- (AZR*) outFrame                         { return $AZR(self.frame);} //[self frameInRect:_outerRect offset:_offset  insideEdge:self.insideEdge];	}



 //	[self addObserverForKeyPaths:@[@"offset"] task:^(id obj, NSDictionary *change) {	[self setFrame:self.outFrame.r display:YES];	}];
 //	__block AZWindowTab* blockSelf = self;
 //	[self bind:@"frame" toObject:self withKeyPath:@"offset" transform:^id(id value) {	return AZVrect(blockSelf.outFrame.r);			}];
 //	CATransition* transition = [CATransition animation]; [transition setType:kCATransitionPush];  [transition setSubtype:kCATransitionFromLeft]; NSDictionary *ani = [NSDictionary dictionaryWithObject:transition  forKey:@"frame"];[self setAnimations:ani];
 //quartzPath	//	[AZNOTCENTER observeName:NSApplicationDidBecomeActiveNotification usingBlock:^(NSNOT*n) {
 //			[NSApp activateIgnoringOtherApps:YES];	[self makeKeyAndOrderFront:nil];                }];

 + (instancetype) sharedInstance			{	@synchronized(self) { x = x ?: [self.alloc init]; }  return x;
 1. alloc 2. store pointer 3. call init.
 Why ? if init is calling sharedController, the pointer won't have been set and it will call itself over and over again.
 NSLog(@"JSCocoa : allocating shared instance %x", JSCocoaSingleton);
 //}

 AZRectInsideRectOnEdge(AZRectFromDim(50),_window.bounds, _window.insideEdge) [grab bind:@"bounds" toObject:_window withKeyPath:@"insideEdge" transform:^id(id value) { return AZVrect();	}];	[_window observeName:@"insideEdge" usingBlock:^(NSNotification *n) {- (id) valueForUndefinedKey:(NSS*)key { id value;if ([_window respondsToString:key])value = [_window valueForKey:key];if (value == nil) value = [super valueForUndefinedKey: key];	}}


 .window == findWin(NSE.mouseLocation)
 NSR out = [[self associatedValueForKey:@"normalRectMemory"
 orSetTo:AZVrect(self.frame) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]rectValue];
 [self setFrame:NSEqualRects(out, self.frame)
 ?	AZRectInsideRectOnEdge( self.sticksToEdgeGrabRect, AZRECTUNDERMENU.rect, self.insideEdge)
 //				:   out display:YES	animate:YES];

 // Mouse WAS dragged..  could add && !(e.deltaX == 0 && e.deltaY ==0))
 else if  ( e.type == NSLeftMouseDragged && self == x.window )                   dragAction();
 //mouse up
 else if  ( e.type == NSLeftMouseUp && self == x.window )		{ x = nil;  NSLog(@"clcick should be nil: %@", x); }
 //  Double Click handler for windowshade action.

 nonStickies = nonStickies ?: ^{ nonStickies  = [NSMA mutableArrayUsingWeakReferences];
 [[NSW.appWindows objectsWithValue:@NO forKey:@"sticksToEdge"] each:^(id w) {
 [nonStickies addObject:w]; }];              return nonStickies; }();
 id (^findEdgeEnabledWin)(NSP) = ^id(NSP p){
 //		NSA* all = NSW.appWindows;
 NSA* win = [NSW.appWindows objectsWithValue:@YES forKey:@"sticksToEdge"];
 NSA *winners = [win filter:^BOOL(NSW*o){ return NSPointInRect(p, o.frame);  }];
 //		NSLog(@"allCT: %ld thestickiesct:%ld  winnersCt: %ld", all.count, win.count, winners.count);
 return !winners.count ? nil : [winners.first isEqualTo:x.window] ? x.window  : winners.first;
 };

 //  THIS window's click handler.
 //	id handler = [NSEVENTLOCALMASK: NSLeftMouseDraggedMask | NSLeftMouseDownMask | NSLeftMouseUpMask handler:^NSE*(NSE*e) {
 VoidBlock defineClickedWindow, dragAction, doubleClick;

 defineClickedWindow = ^{
 id win = findEdgeEnabledWin(NSE.mouseLocation);
 if (!win) return;
 if (!x || win != x.window) {

 x =
 [ClickedWindow.alloc initWithWindow:win];
 NSLog(@"found the clicked victim: %@", x.window);
 [nonStickies removeObject:x.window];
 ClickedWindow *w = [ClickedWindow.alloc initWithWindow:windy];
 find and set "shared" "clicked" window


 @interface  WindowTabController : NSObject
 @property  (CP) void (^fixPaths) (void);
 @property  (WK) AZWindowTab *window;         // The weak reference to the actual object
 @property (ASS) CGP drgStrt, wOrig;
 @property  NSMA	*allTabs;
 @property    CAL	*indi,  *grab, *host;	@property CASL *marquee;
 @property	NSV	*view;
 + (instancetype)sharedInstance;
 @end
 @implementation  WindowTabController
 static WindowTabController *x = NULL;
 static dispatch_once_t _p;
 + (instancetype) sharedInstance			{  dispatch_once(&_p,^{ x = [self.alloc init]; x.allTabs = NSMA.new; }); return x;	}
 + (BOOL) hasSharedInstance					{	return !!x;	}
 + (void) setWindow:(AZWindowTab*)w		{			// Singlton window that is our "Active window", aka, being dragged.

 if (w == x.window) return;
 NSLog(@"initwithwindow:%@ called", AZString(w.frame));
 if (x.view)  [x.view.layer animate:@"opacity" to:0 time:.5 completion:^{ [x.view removeFromSuperview]; x.marquee.strokeEnd = 0; }];
 if (!self.hasSharedInstance) { x	= self.class.sharedInstance;
 x.view                      = [NSV.alloc initWithFrame:w.contentRect];
 x.view.arMASK               = NSSIZEABLE;
 x.host                      = [x.view setupHostView];
 x.host.sublayers            = @[ x.grab     = [CAL  layerWithFrame:w.grabRect.r],
 x.indi    = [CAL  layerWithFrame:AZRectFromDim(50)],
 x.marquee = [CASL layerWithFrame:w.bounds]];
 CATXTL *t = AddTextLayer(x.host, @(x.allTabs.count).stringValue, AtoZ.controlFont,kCAConstraintWidth);
 //		[host addsubl]
 x.grab.backgroundColor  = cgRED;
 x.indi.contents             = [NSIMG imageNamed:@"1"];//scaledToMax: AZMaxDim(x.indi.boundsSize)];
 x.marquee.path          = [NSBP bezierPathWithRect:w.bounds].quartzPath;	// (__bridge CGPathRef)
 x.marquee.strokeColor   = [NSColor colorWithCalibratedRed:0.594 green:0.927 blue:0.143 alpha:1.000].CGColor;
 x.marquee.fillColor         = nil;
 x.marquee.lineWidth         = 6.0f;
 x.marquee.lineJoin      = kCALineJoinBevel;
 x.fixPaths					= ^{ LOGCOLORS(@"KVOFIXPATHBLOCK", RED, nil); x.marquee.path = [NSBP bezierPathWithRect:x.window.bounds].qP; };
 [x.view observeFrameChangeUsingBlock:^{[x.grab setValueImmediately:AZVrect(x.window.grabRect.r)forKey:@"frame"]; x.fixPaths();}];
 }
 x.window    = w;	// Store the weak reference.  This will become nil automatically when this object is disposed of.
 x.drgStrt   = NSE.mouseLocation;		// note our starting point.
 x.wOrig         = w.frame.origin;       // save initial origin.

 [x.window.contentView addSubview:x.view];
 //	[x.grab unbind:[NSColor colorWithCalibratedRed:0.416 green:0.535 blue:0.927 alpha:1.000]sform:^id(id v){	return AZVrect(x.window.grabRect.r);            }];
 //	[x.indi unbind:@"position"];
 [x.indi bind:@"position" toObject:w withKeyPath:@"insideEdge" transform:^id(id value) {
 return AZVpoint(AZCenter(AZRectInsideRectOnEdge(AZCenterRectInRect(x.indi.bounds,w.bounds),w.bounds,w.insideEdge)));		}];
 //	[x.marquee bind:@"path" toObject:w withKeyPath:@"frame" transform:^id(id value) {
 //		return (id)[NSBP bezierPathWithRect:w.bounds].quartzPath;
 //	}];
 [x.view.layer animate:@"opacity" to:@1 time:.5 completion:^{                                                                                    }];
 [x.marquee animate:@"strokeEnd" from:@0 to:@1 time:2 completion:^{                                                                              }];

 }
 @end


@interface AZWindowTab ()
@property  (CP) void (^fixPaths) (void);
@property  NSMA	*allTabs;
@property     CAL	*indi,  *grab, *host;	@property CASL *marquee;

@property dispatch_object_t token;
@end

	observeName:NSWindowDidResignKeyNotification usingBlock:^(NSNOT*m) {  [m.object setSlideState:AZIn]; }];
	[self observeName:NSWindowDidBecomeKeyNotification usingBlock:^(NSNoT*m) {
		if ([self hasAssociatedValueForKey:@"restore"]) [self removeAssociatedValueForKey:@"restore"], [self setSlideState:AZIn];
	}];
	id last = self.tabRects.last; NSR thRect = last ? [last rectValue] :
+ (INST) instanceInWindow:(AZWT*)w withView:(NSV*)v {		return [self.alloc initInWindow:w withView:v]; }
@property (NATOM)             CGF	grabInset;

*/