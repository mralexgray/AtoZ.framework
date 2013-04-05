
#import "TestBedDelegate.h"

@interface TestBedDelegate ()
//@property (STRNG) CATransition *transition;
//@property (STRNG) NSA *transitions;
@end

// Constants used by the Scroll layer to setup its contents and to scroll.
#define kScrollContentRect CGRectMake(  0.0,   0.0, 3000.0, 300.0)
#define kScrollContentRect CGRectMake(  0.0,   0.0, 100, _targetView.height )

@implementation TestBedDelegate

- (void) awakeFromNib
{
	AtoZ* o = AtoZ.sharedInstance;
	[self createScrollLayer]; 
	[((BGHUDView*)_contentView).theme.baseColor bind:@"value" toObject:_colorWell withKeyPath:@"color" options:nil];

//	[self.window setAcceptsMouseMovedEvents:YES];
//	[self.window makeFirstResponder:_targetView];
}
//	[NotificationCenterSpy toggleSpyingAllNotificationsIgnoring:nil ignoreOverlyVerbose:YES];
//	[AtoZ sharedInstance];
//	window.delegate = self;
//- (void) logString:(NSS*)s { 	self.semiLog = s; }

- (IBAction)setViewFromPopUp:(id)sender
{
	// allSubviews]makeObjectsPerformSelector:@selector(fadeOut)]; //[_targetView removeAllSubviews];
	NSS *selecto = [sender titleOfSelectedItem];
	id view = 	areSame(selecto,  @"General") ? _genVC.	view :
			   	areSame(selecto, 	     @"UI") ? _uiVC.		view :
					areSame(selecto,   @"Colors") ? _colorVC.	view :
					areSame(selecto, @"Facebook") ? _fbV.		view : 
					areSame(selecto, 	   @"TUIV") ? _tuiVC.		view : nil;
	if (view) {
		NSLog(@"selecto:%@  view:%@", [selecto debugDescription],[view subviews]);
		[view setFrame:_targetView.bounds];
		[_targetView swapSubs:view];
//		if (_targetView.subviews) [_targetView removeAllSubviews];	//	[_targetView.subviews.first fadeOut];

//		[_targetView addSubview: view];						//		[(NSV*)view setAutoresizingMask: NSSIZEABLE];
//		[view fadeIn];
	} else if ( areSame(@"CAScrollLayer", selecto)) [self createScrollLayer];
}

- (NSMD*) model {  return _model = _model ?:  ^{
		NSA* icons = [NSIMG.monoIcons withMaxItems:30];
		return  @{ @"icons" :  icons, @"colors" :[NSC gradientPalletteLooping:NSC.randomPalette steps:icons.count] }.mutableCopy;
	}();
}

@synthesize  host, off, scrlr;
- (void) createScrollLayer	{

//	_scrollTest = [CAScrollView.alloc initWithFrame: _targetView.bounds];
	_scrollTest.hoverStyle 		= Lasso;
	_scrollTest.selectedStyle 	= DarkenOthers;
	_scrollTest.layerQueue 		= 
	[NSC.randomPalette nmap:^id(NSC* c, NSUI idx) {
		CAL *l = [CAL layerNamed:$(@"%ld",idx)];
		l.frame = AZRectBy(50, _targetView.height);//RAND_FLOAT_VAL(40, 100),_scrollTest.height);
		l.bgC = c.brighter.cgColor;
//		l.loM = AZLAYOUTMGR;
//		l.constraints = @[AZConstAttrRelNameAttrScaleOff(kCAConstraintWidth, @"superlayer", kCAConstraintHeight, 1, 0), AZConstRelSuper(kCAConstraintHeight)];
//		l.arMASK = CASIZEABLE;
//		[l addConstraintsRelSuper: kCAConstraintMidY];//kCAConstraintHeight, kCAConstraintMaxY, kCAConstraintMidY, kCAConstraintMinY, nil];
		l.borderColor = c.darker.cgColor;
//		l.delegate = self;
//		[l setNeedsDisplay]; 
		return l;
	}].mutableCopy;


//	[_targetView addSubview:_scrollTest];
//	[_targetView removeAllSubviews];
//	_targetView.subviews = @[self.scrollTest = [CAScrollView new]];
//	_scrollTest.layerQueue = 	[self.model [@"icons"] nmap:^id(NSIMG*o, NSUI idx){
//		CAGL *g 	= [CAL gradientWithColor:self.model[@"colors"][idx]];
//		//				 	g.sublayers = @[gImg = [CAL layerNamed:o.name]];
//		g.name = o.name;
//		[g setInt:idx forKey:@"index"];
//		//				 gImg.contents = o;
//		//				gImg.transform = CATransform3DMakeScale(.65, 1, 1);
//		g.delegate = self;
//		[g setNeedsDisplay];
//		return g;	}].mutableCopy;
//	_scrollTest.frame = _scrollTest.bounds;
}

- (void) drawLayer:(CAL*)layer inContext:(CGContextRef)ctx			{
	
//	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
//		NSIMG* icon = self.model[@"icons"][[layer integerForKey:@"index"]];
//		NSR bottomSquare = AZRectTrimmedOnTop(layer.bounds,layer.boundsHeight - layer.boundsWidth);
//		[icon drawInRect:AZInsetRect(bottomSquare, 15) fraction:1];
//		NSString *pos = AZString(layer.position);
//		[pos drawInRect:AZSquareInRect(layer.bounds) withFontNamed:@"UbuntuMono-Bold" andColor:WHITE];
//	}];
}


- (void) alternate {

	_targetView.subviews = @[host = [BLKVIEW inView:_targetView withBlock:^(BLKVIEW *v, CAL *l) {	 }]];
   host.layer.sublayers = @[scrlr = [CASCRLL layerWithFrame:host.layer.bounds]];		            
				  scrlr.bgC = [[GREEN alpha:.4] CGColor];
			  scrlr.arMASK = CASIZEABLE;
			scrlr.delegate = self;
			
  self.model[@"layers"]	= scrlr.sublayers = [self.model [@"icons"] nmap:^id(NSIMG*o, NSUI idx){
			CAL*gImg; CAGL *g 	= [CAL gradientWithColor:self.model[@"colors"][idx]];
//				 	g.sublayers = @[gImg = [CAL layerNamed:o.name]];
						  g.name = o.name;
				  [g setInt:idx forKey:@"index"];
//				 gImg.contents = o;
//				gImg.transform = CATransform3DMakeScale(.65, 1, 1);
					 g.delegate = self;
						[g setNeedsDisplay];
						  return g;	}];
						  
	[NSEVENTLOCALMASK:NSScrollWheelMask handler:^(NSE*e){
		self.off += e.deltaX * ABS(e.deltaX);	[scrlr scrollToPoint:(NSP){off, 0}];		return e; }];
		
	[NSEVENTLOCALMASK:NSLeftMouseUpMask handler:^(NSE*e){	CAGL* c = self.hit; 	if (c) [c setFrameMinX:c.frameMinX - c.boundsWidth]; return e; }];
		
	[_targetView.window setAcceptsMouseMovedEvents:YES];
	[NSEVENTLOCALMASK:NSMouseMovedMask handler:^(NSE*e){ static id hovered;	CAGL* c = self.hit; 
																			if(c && ![c[@"spinning"]boolValue] && c != hovered) { 
																			[hovered setBool:NO forKey:@"hover"]; 
																			[c setBool:YES forKey:@"hover"]; } 				return  e; }];
}
- (CAGL*) hit 					{ NSP hit = host.windowPoint;  hit.x += off;	return _hit = (CAGL*)[scrlr hitTestSubs:hit]; }
- (NSA*) visibleSubs	 		{ return _visibleSubs = scrlr.visibleSublayers; }
- (NSA*) subsAscending		{ return _subsAscending = scrlr.sublayersAscending; }
- (NSUI) indexLastVisible 	{ NSA *visi = self.visibleSubs;  return visi ? [self.subsAscending indexOfObject:visi.last]   : NSNotFound; }
- (NSUI) indexFirstVisible { NSA *visi = self.visibleSubs;  return visi ? [self.subsAscending indexOfObject:visi[0]] : NSNotFound; }
- (NSS*) visibleSubsString { NSA* vs = [self.visibleSubs valueForKeyPath:@"name"]; 
									  return $(@"%@ [%ld] Offset:%.1f", [NSS stringFromArray:vs], vs.count, self.off); 
}
- (NSRNG) front 	{ return NSMakeRange( 						    0, self.visible.location); }
- (NSRNG) back  	{ return NSMakeRange(    self.visible.length, scrlr.sublayers.count); }
- (NSRNG) visible { return NSMakeRange(self.indexFirstVisible, self.indexLastVisible ); }

- (NSString *)fixState 	{ return stringForScrollFix(self.scrollFix); }
- (ScrollFix) scrollFix { 	ScrollFix aFix 		= 	self.front.location == 0  && [self indexLastVisible] < self.subsAscending.count 
															? 	LayerInsertFront
															:	self.visible.length 	== scrlr.sublayers.count
															?	LayerInsertEnd
															:	LayerStateOK; // self.back.length - _visible.length 	
	static NSUI fixCt = 0;  fixCt++;	
	if (aFix != LayerStateOK) 
	{ 
		NSLog(@"fix:%@ x %ld", MAKEWARN(stringForScrollFix(aFix)), fixCt);	
		NSA *locsort = self.subsAscending;
		CAL* toMove	 	= aFix == LayerInsertFront ? locsort.last : locsort.first;
		CAL* toWhere 	= aFix == LayerInsertFront ? locsort.first : locsort.last;
		CGF relOff 		= aFix == LayerInsertFront ? -toMove.boundsWidth : toMove.boundsWidth;
		CGR originR		= AZRectHorizontallyOffsetBy(toWhere.frame, relOff);  
		[CATransaction immediately:^{ toMove.frame = originR; }];
		[self visible];
	}
	return aFix;
}
/*		  
+ (NSSet*) keyPathsForValuesAffectingValueForKey:(NSS*)key			{
 
	NSSet*s = [[super keyPathsForValuesAffectingValueForKey:key] setByAddingObjectsFromArray:

	[key isEqualToAnyOf:@[	@"visible"					]] ? @[@"scrlr.onLayout", @"off"] :
	
	[key isEqualToAnyOf:@[	@"visibleSubsString", 
									   @"front", @"back", 
									        @"scrollFix", 
									         @"fixState"		]] ? @[@"visible"]  
	  															      : @[]];
	
	LOGWARN(@"kpVsAVfK: %@ \t[%ld]\t %@",key, s.allObjects.count,AZStringFromSet(s));
	return s;
}

- (id<CAAction>) actionForLayer:(CAL*)layer forKey:(NSS*)event 	{		static NSMA *actions = nil; actions = actions ?: NSMA.new;
	
	[actions addObject:$(@"%@ on %@",event,layer)]; [self performBlock:^{	 self.actionStatus = actions[0]; [actions removeFirstObject];
																																																											                                    } afterDelay:actions.count];

	return 	 layer == scrlr && [@[@"bounds", @"position",@"contents"] containsObject:event] ?	 AZIDCAA AZNULL : 
//											    		 	         [@[@"onLayout"] containsObject:event] ? nil : 
											 	layer == scrlr && [@[@"sublayers"]containsObject:event] ? AZIDCAA self :
												                               [event loMismo:@"hover"] ? AZIDCAA self : nil;
}
//			:  [layer isKindOfClass:CAGL.class] 
//			?  [CABA animationWithKeyPath:@"position" andDuration:4]

- (void) runActionForKey:(NSS*)k object:(id)o arguments:(NSD*)d  	{

	NSLog(@"Its asking about %@ for %@", MAKEWARN(k), MAKEWARN(o));
	
	o == scrlr  && [k loMismo:@"sublayers"] ? ^{    													      // setup layout and size

		[scrlr.sublayers eachWithIndex:^(CAL* obj, NSI idx) { 
			[obj setFrame:(NSR) { idx * 100, 0, 100, _targetView.height }];
			    AddTextLayer( obj, obj.name, AtoZ.controlFont, CASIZEABLE);
		}];																	  self.off = 0;		

	}() :	[o boolForKey:@"spinning"] ? ^{																      // Hover Action

		CAA* a = CAA.shakeAnimation;	 a.duration = 3; a.repeatCount 	= 10;
		a.completion = ^(BOOL d) {	[o setBool:NO forKey:@"spinning"]; [o setBool:NO forKey:@"hover"]; };
		[(CAL*)o addAnimation:a  forKey:k]; 

	}() : ![o boolForKey:@"spinning"] ? ^{																      // Hover Action
		
		CAA* a = [CAKA dockBounceAnimationWithIconHeight:100];
		a.duration = .5; a.repeatCount 	= 1;
		a.completion = ^(BOOL d) {		WARN(@"shaking has subsided");
			[o setBool:NO forKey:@"spinning"]; };
		[(CAL*)o addAnimation:a  forKey:k]; 
		
	}() : nil;
}
*/
//	NSLog(@"drawLinCTX called on: %@...  vageen?:%@", layer, StringFromBOOL([layer boolForKey:@"clicked"]));
//		!layer.hovered ?: ^{
//			NSRectFillWithColor(layer.bounds, [NSC checkerboardWithFirstColor:BLACK secondColor:CLEAR squareWidth:20]);
//			NSBP *b = [NSBP bezierPathWithRect:layer.bounds];
//			[b fillWithInnerShadow:[NSSHDW shadowWithColor:BLACK offset:NSMakeSize(4, -4) radius:10]];
//		}();
//		[NSSHDW setShadowWithOffset:(NSSZ){5,-3} blurRadius:7 color:BLACK];

//		[[layer associatedValueForKey:@"icon" 
//									 orSetTo:((NSIMG*)NSIMG.monoIcons[RAND_INT_VAL(0, NSIMG.monoIcons.count)]).etched policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]
//		 drawInRect:AZMakeSquare((NSP){NSMidX(layer.bounds), (.5 * layer.boundsWidth)}, .5 * layer.boundsWidth) fraction:1];
//:[NSInsetRect(layer.bounds, 0, 10) fraction:1];// operation:NSCompositePlusDarker fraction:1];
//		[layer.name drawInRect:layer.bounds withFontNamed:@"Helvetica" andColor: WHITE];




// Creates a rect that is a fraction of the original rect
CGR MakeSubrect(CGR r, CGF x, CGF y, CGF w, CGF h)	 {
	return CGRectMake(	
							r.origin.x + r.size.width * x,
							r.origin.y + r.size.height * y,
							r.size.width * w,
							r.size.height * h);
}
- (IBAction)scrollFromSegment:(id)sender; {
	
	NSSegmentedControl *s = sender;
	NSUI i = [sender selectedSegment];
	NSArray *action = @[	^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect,.25, .5,  1, .5)]; },
							  ^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect, .5,.25,  1, .5)]; },
							  ^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect,.25,  0,  1, .5)]; }, 
							  ^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect,  0,.25,  1, .5)]; },
							  ^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect,  0, .5, .5, .5)]; },
							  ^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect, .5, .5, .5, .5)]; },
							  ^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect,  0,  0, .5, .5)]; },
							  ^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect,  0,  0, .5, .5)]; },
							  ^{ [scrlr scrollToRect:MakeSubrect(kScrollContentRect, .5,  0, .5, .5)]; }];
	
	((void (^)()) [action objectAtIndex:i] )();
}
@end


/*	[obj setTransform:CATransform3DConcat(CATransform3DMakeScale(100, scrlr.boundsHeight, 1), 	
 CATransform3DMakeTranslation(idx *100, 1, 1))];
 }() : 	anObject == scrlr && areSame(key, @"onLayout") ? ^{ */
 
//	if ( !areSame(fixState, stringForScrollFix(LayerStateOK)) )	[self performBlock:^{ static NSUI j; j++; 		[self setFixState:stringForScrollFix(LayerStateOK)]; } afterDelay:2];
//		[numbers makeObjectsPerformSelector:@selector(fadeOut)];
//		[toMove animate:@"frame" toRect:originR time:0.001 completion:^{

//	static ScrollFix f; f = f != theFix && theFix != LayerStateOK ? theFix : f;
//	if (f != LayerStateOK ) { 
//		if (theFix == LayerInsertFront) [self fixState];
//		if (_visible.length < self.back.length && ) [self fixState]; 
//	}
//	 self.fixState = stringForScrollFix(_scrollFix);

//]last setFrame:AZRectExceptOriginX(scrlr.sublayers[0], CGFloat x)scrlr.sublayers.first; ? 
//	int toIndex = l == LayerInsertFront
//	NSLog(@"%.1f %@  %.1f",first.frameMinX, first.name, first.frameX);






			
//[CAA rotateAnimationForLayer:layer  start:0 end:180];
//	if ( layer.superlayer == scrlr && 
//		[layer pulse];
//	[ _targetView inLiveResize ] ) {
//	if ( /*layer == _t &&*/ [ _targetView inLiveResize ] ) {
		// disable implicit animations for scrolllayer in live resize
//		return (id<CAAction>)[ NSNull null ];
//	}


	
//	_scrollTest.hoverStyle 		= Lasso;
//	_scrollTest.selectedStyle 	= DarkenOthers;
//	_scrollTest.layerQueue 		= [NSC.randomPalette nmap:^id(NSC* c, NSUI idx) {
		
//		CAL *l = [CAL layerNamed:$(@"%ld",idx)];
//		l.frame = AZRectBy(50, 30);//RAND_FLOAT_VAL(40, 100),_scrollTest.height);
//		l.bgC = c.brighter.cgColor;
//		l.loM = AZLAYOUTMGR;
		//		l.constraints = @[AZConstAttrRelNameAttrScaleOff(kCAConstraintWidth, @"superlayer", kCAConstraintHeight, 1, 0), AZConstRelSuper(kCAConstraintHeight)];
		//		l.arMASK = CASIZEABLE;
		//		[l addConstraintsRelSuper: kCAConstraintMidY];//kCAConstraintHeight, kCAConstraintMaxY, kCAConstraintMidY, kCAConstraintMinY, nil];
		//		l.borderColor = c.darker.cgColor;
		//		l.delegate = self;
		//		[l setNeedsDisplay]; 
//		return l;
//	}].mutableCopy;

/*

	CASCRLL *trck = [CAScrollLayer layerWithFrame:_targetView.bounds];
	trck.scrollMode = kCAScrollHorizontally;
	trck.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
	trck.layoutManager = self;
	CATransform3D perspTransform = CATransform3DIdentity;
	perspTransform.m34 = 1. / -900;
	trck.sublayerTransform = perspTransform;
	trck.masksToBounds = NO;
	trck.delegate = self;
	trck.sublayers = [NSIMG.systemIcons nmap:^id(id obj, NSUInteger index) {
			
		return ReturnImageLayer(trck, obj, 1);							
	}];
	CAL *l = 	_targetView.setupHostView;
	[l addSublayer: trck];
}
*/
#pragma mark -
#pragma mark CALayerDelegate protocol
//- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
//{
//	if ( layer == _t && [ _targetView inLiveResize ] ) {
//		// disable implicit animations for scrolllayer in live resize
//		return (id<CAAction>)[ NSNull null ];
//	}
//	return nil;
//}

#pragma mark - CALayoutManager protocol
/*
- (void)layoutSublayersOfLayer:(CALayer *)flowViewLayer
{
	if ( ( flowViewLayer != self.scrollLayer ) ||
		 ( self.selectedIndex == NSNotFound ) ) {
		return;
	}
	[ CATransaction begin ];
	[ CATransaction setDisableActions:[ self inLiveResize ] ];
	[ CATransaction setAnimationDuration:self.scrollDuration ];
	[ CATransaction setAnimationTimingFunction:[ CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut ] ];
	[ CATransaction setCompletionBlock:^{
		[ self updateImages ];
		[ self setupTrackingAreas ];
	} ];
	// layout
	[ self layoutItemLayersInRange:NSMakeRange( 0, self.numberOfItems ) ];
	[ self.scrollLayer scrollToPoint:[ self selectedScrollPoint ] ];
	[ CATransaction commit ];
	[ self calculateVisibleItems ];
	[ self updateScrollKnob ];
}
- (void)layoutItemLayersInRange:(NSRange)layoutRange
{
	CGSize itemSize = [ self itemSizeForRect:self.scrollLayer.bounds ];
	NSIndexSet *updatedIndexes = [ NSIndexSet indexSetWithIndexesInRange:NSIntersectionRange( layoutRange, NSMakeRange( 0, self.numberOfItems ) ) ];
	[ updatedIndexes enumerateIndexesUsingBlock:^(NSUInteger itemIndex, BOOL *stop) {
		[ self setFrameForLayer:(CAReplicatorLayer*)[ self itemLayerAtIndex:itemIndex ]
							 atIndex:itemIndex
					  withItemSize:itemSize ];
	} ];
}
- (void)calculateVisibleItems
{
	NSInteger firstVisibleItem = NSNotFound;
	NSUInteger numberOfVisibleItems = 0;
	// visibility test
	for ( CAReplicatorLayer *itemLayer in self.scrollLayer.sublayers )	{
		NSUInteger itemIndex = [ [ itemLayer valueForKey:kMMFlowViewItemIndexKey ] unsignedIntegerValue ];
		
		if ( !CGRectIsEmpty( itemLayer.visibleRect ) ) {
			if ( firstVisibleItem == NSNotFound ) {
				firstVisibleItem = itemIndex;
			}
			numberOfVisibleItems++;
		}
	}
	self.visibleItemIndexes = ( firstVisibleItem != NSNotFound ) ? [ NSIndexSet indexSetWithIndexesInRange:NSMakeRange( firstVisibleItem, numberOfVisibleItems ) ] : [ NSIndexSet indexSet ];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	
	selectedCover = (int) roundf((self.contentOffset.y/SCROLL_PIXELS));
	if (selectedCover > [ _covers count ] -1) {
		selectedCover = [ _covers count ] - 1;
	}
	[ self layoutLayer: trck ];
}

- (void)setSelectedCover:(int)index {
	
	if (index != selectedCover) {
		selectedCover  = index;
		[ self layoutLayer: trck ];
		self.contentOffset = CGPointMake(self.contentOffset.x, selectedCover *
													SCROLL_PIXELS);
	}
}

- (int) getSelectedCover {
	return selectedCover;
}

-(void) layoutLayer:(CAScrollLayer *)layer
{
	CALayer *sublayer;
	NSArray *array;
	size_t i, count;
	CGRect rect, cfImageRect;
	CGSize cellSize, spacing, margin, size;
	CATransform3D leftTransform, rightTransform, sublayerTransform;
	float zCenterPosition, zSidePosition;
	float sideSpacingFactor, rowScaleFactor;
	float angle = 1.39;
	int x;
	
	size = [ layer bounds ].size;
*/	
//	zCenterPosition = 60;      /* Z-Position of selected cover */
//	zSidePosition = 0;         /* Default Z-Position for other covers */
//	sideSpacingFactor = .85;   /* How close should slide covers be */
//	rowScaleFactor = .55;      /* Distance between main cover and side covers */
/*	
	leftTransform = CATransform3DMakeRotation(angle, -1, 0, 0);
	rightTransform = CATransform3DMakeRotation(-angle, -1, 0, 0);
	
	margin   = CGSizeMake(5.0, 5.0);
	spacing  = CGSizeMake(5.0, 5.0);
	cellSize = CGSizeMake (COVER_WIDTH_HEIGHT, COVER_WIDTH_HEIGHT);
	
	margin.width += (size.width - cellSize.width * [ _covers count ]
						  -  spacing.width * ([ _covers count ] - 1)) * .5;
	margin.width = floor (margin.width);
	
//	 Build an array of covers 
	array = [ layer sublayers ];
	count = [ array count ];
	sublayerTransform = CATransform3DIdentity;
	
//	 Set perspective 
	sublayerTransform.m34 = -0.006;
	
//	 Begin a CATransaction so that all animations happen simultaneously 
	[ CATransaction begin ];
	[ CATransaction setValue: [ NSNumber numberWithFloat: 0.3f ]
							forKey:@"animationDuration" ];
	
	for (i = 0; i < count; i++)
	{
		sublayer = [ array objectAtIndex:i ];
		x = i;
		
		rect.size = *(CGSize *)&cellSize;
		rect.origin = CGPointZero;
		cfImageRect = rect;
		
//	 Base position 
		rect.origin.x = size.width / 2 - cellSize.width / 2;
		rect.origin.y = margin.height + x * (cellSize.height + spacing.height);
		
		[ [ sublayer superlayer ] setSublayerTransform: sublayerTransform ];
		
		if (x < selectedCover)        // Left side 
		{
			rect.origin.y += cellSize.height * sideSpacingFactor
			* (float) (selectedCover - x - rowScaleFactor);
			sublayer.zPosition = zSidePosition - 2.0 * (selectedCover - x);
			sublayer.transform = leftTransform;
		}
		else if (x > selectedCover)  // Right side 
		{
			rect.origin.y -= cellSize.height * sideSpacingFactor
			* (float) (x - selectedCover - rowScaleFactor);
			sublayer.zPosition = zSidePosition - 2.0 * (x - selectedCover);
			sublayer.transform = rightTransform;
		}
		else                      // Selected cover 
		{
			sublayer.transform = CATransform3DIdentity;
			sublayer.zPosition = zCenterPosition;
			
//		Position in the middle of the scroll layer 
			[ layer scrollToPoint: CGPointMake(0, rect.origin.y
														  - (([ layer bounds ].size.height - cellSize.width)/2.0))
			 ];
			
//		Position the scroll layer in the center of the view 
			layer.position =
			CGPointMake(160.0f, 240.0f + (selectedCover * SCROLL_PIXELS));
		}
		[ sublayer setFrame: rect ];
		
	}
	[ CATransaction commit ];
}

*/
//	if ( _targetView.subviews.count > 0) [_targetView.subviews.first fadeOut];		//		[_targetView.subviews[0] removeFromSuperview];
//	if ([_targetView.subviews doesNotContainObject:_scrollTest])
//		[_targetView swapSubs:_scrollTest];
////	[_scrollTestHost setFrame:_targetView.frame];
//	[self reZhuzhScrollLayer:nil];
//}




//	vcs 		= [WeakMutableArray new];

//	genVC 		= [[AZGeneralViewController  alloc] initWithNibName: @"AZGeneralViewController"  bundle:nil];
//	[vcs addObject:genVC.view];
//	geoVC 		= [[AZGeometryViewController alloc] initWithNibName: @"AZGeometryViewController" bundle:nil];
//	[vcs addObject:geoVC.view];
//	uiVC  		= [[AZUIViewController	     alloc] initWithNibName: @"AZUIViewController"	     bundle:nil];
//	[vcs addObject:uiVC.view];
//	fileGrid 	= [[AZFileGridView 			 alloc]   initWithFrame: _targetView.bounds];
//	[vcs addObject:fileGrid];

//	 @{  @"General" : genVC.view, @"Geometry": geoVC.view, @"fileGridView" : fileGrid, @"UI" : uiVC.view }.mutableCopy;

//	for ( NSV* view in vcs) {
//		view.frame  = [_targetView bounds];		view.arMASK = NSSIZEABLE;
//		view.hidden = YES;						[_targetView addSubview:view];
//	}

//	[fileGrid setHidden:NO];

//	holdOntoViews.actionBlock = ^(id inSender){		semiWindow = [AZSemiResponderWindow new];
//		semiWindow.semiResponder = self;			[semiWindow   makeKeyAndOrderFront:self];
//	};

//	self.genVC = [[AZGeneralViewController alloc]initWithNibName:@"AZGeneralViewController" bundle:nil];
//	[__targetView addSubview: _genVC.view];
//	_genVC.view.frame	= [__targetView frame];
//	[[_targetView animator]swapSubs:newView];
//	[[activeView animator] setHidden:YES];
//	activeView = vcs[[sender titleOfSelectedItem]];
//	[_targetView addSubview:activeView positioned:NSWindowAbove relativeTo:_targetView];
//	[activeView setHidden:NO];
//	[_activeView setNeedsDisplay:YES];
//}



	// A scroll layer by itself is rather uninteresting
	// so we'll create a regular layer to provide content.
//	self.scrollLayerContent = [CALayer layer];
//	_scrollLayerContent.frame = kScrollContentRect;
//	NSIMG *pony = [NSIMG imageFromURL:@"http://apod.nasa.gov/apod/image/1001/almosttrees_mro_big.jpg"];//:NSImageNameDotMac];
//	LOG_EXPR(pony);
//	scrollLayerContent.contents = pony;

//	CGColorRef ref = [[NSC colorWithPatternImage:pony] CGColor];
//	scrollLayerContent.bgC = ref;
	
//	_scrollLayer = [CAScrollLayer layer];
//	_scrollLayer.arMASK = CASIZEABLE;
//	_scrollLayerContent.delegate = self;
//	_scrollLayerContent.needsDisplayOnBoundsChange = YES;
//	_scrollLayer.frame = _targetView.bounds;
//	_scrollLayer.arMASK = CASIZEABLE;
	// Since its handy, we'll use the same content as our basic CALayer example
	// This also shows that you can use the same delegate for multiple layers :)
//	scrollLayerContent.delegate = delegateCALayer;

	// Layers start life validated (unlike views).
	// We request that the layer have its contents drawn so that it can display something.
//	[_scrollLayerContent setNeedsDisplay];

	// We set a frame for this layer. Sublayers coordinates are always in terms of the
	// parent layer's bounds.
//	scrollLayerContent.frame = _targetView.bounds;

	// Now we add the configured layer to the scroll layer.
//	[_scrollLayer addSublayer:_scrollLayerContent];

//	[l addSublayer:_scrollLayer];
	//.layer = exampleCAScrollLayer;

//}
//- (NSS*)visiRect {
//	NSR vR = _scrollLayerContent.visibleRect;
//	return AZStringFromRect(vR);
//}
//
//-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
//{
//	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
//		[[NSA from:0 to:10] eachWithIndex:^(id obj, NSInteger idx) {
//			NSR r = (NSR){idx* 300, 0, 300, 300};
//			NSRectFillWithColor(r, RANDOMCOLOR);
//		}];
//
//		
//		[self.visiRect drawInRect:AZMakeRect(_scrollLayerContent.visibleRect.origin, NSMakeSize(200, 50)) withFontNamed:@"Helvetica" andColor:WHITE];
//	}];
//}
// Creates a rect that is a fraction of the original rect



//-(CATransition*)transition
//{
//	// Construct a new CATransition that describes the transition effect we want.
//	CATransition *transition = [CATransition animation];
//	// We want to build a CIFilter-based CATransition.  When CATransition's "filter" is set, "type" and "subtype" properties are ignored.
//	CATransition* tranny = [CATransition transitionsFor:_targetView].randomElement; 		NSLog(@"New tranny: %@", tranny);
//	return [tranny isKindOfClass:[CIFilter class]] 	? 	   ^{
//		transition.filter 	= tranny; return transition;	 }() : ^{  //itsa filter
//		transition.type		= tranny;
//		transition.subtype	= @[ kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom].randomElement;
//		transition.duration	= 1.0;	  return transition; }();
//}


//- (void) windowDidEndLiveResize:(NSNotification *)notification
//{
//	[_targetView.subviews each:^(NSV* obj) { [[obj animator] setFrame:_targetView.bounds]; }];
//}

//- (IBAction)loadSecondNib:(id)sender
//{
//	NSWindowController* awc = [[NSWindowController alloc] initWithWindowNibName:@"TestBed"];
//	[[awc window] makeKeyAndOrderFront:nil];
//	[[NSApplication sharedApplication] arrangeInFront:nil];
//}
//	NSWindowController* awc = [[NSWindowController alloc] initWithWindowNibName:@"TestBed" owner:self];
//	[awc showWindow:self];
//	[[awc window] makeKeyAndOrderFront:nil];
//	[[NSApplication sharedApplication] arrangeInFront:nil];
//
//	// Load with NSBundle
//	NSLog(@"Loading NIB …");
//
//	if (![NSBundle loadNibNamed:@"TestBed" owner:self])
//		{
//		NSLog(@"Warning! Could not load myNib file.\n");
//		}



//		id newV = self[[sender segmentLabel]]; newV[@"hidden"] = @(YES); if ([_targetView.subviews doesNotContainObject:newV]) [_targetView addSubview:newV]; [self.targetView setAnimations:@{@"subviews":self.transition}];
//			   ? [NASpinSeque animateTo:self[[sender segmentLabel]] inSuperView:_targetView]
//								[self.targetView  swapSubs:self[[sender segmentLabel]]] : nil;	}
//- (void)setDebugLayers:(BNRBlockView*)debugLayers {

//			applyPerspective(new);
//			NSUI ii = (NSUI)idx;
//			NSRect r = quadrant(_targetView.frame, 1);
//			[new addSublayer:ReturnImageLayer(dL, obj, 1)];

//			[v.layer addSublayer:[(NSIMG*)obj imageLayerForRect:quadrant(_targetView.frame, ii+1)]];

////	AZLOG(_debugLayers);
//	__block __typeof(self) blockSelf = self;
//	_debugLayers = [AZBlockView viewWithFrame:_window.frame opaque:NO drawnUsingBlock: ^(AZBlockView *view, NSRect dirtyRect) {
//			view.autoresizingMask = NSViewHeightSizable| NSViewWidthSizable;
////			NSLog(@"drawignRect: %@  blockself: %@", AZStringFromRect(dirtyRect), blockSelf);
//			[[NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:5 yRadius:5] drawWithFill:RED andStroke:RANDOMCOLOR];
//		}];
//	return _debugLayers;
////		[AZBlockView ne][[NSView alloc]initWithFrame:_targetView.frame];
////		[v setupHostView];
////		v.layer.backgroundColor = cgPURPLE;
////		AZDebugLayer *layer = [AZDebugLayer layer];
////		layer.backgroundColor = cgGREEN;
////		v.layer.sublayers = @[layer];
//
//}


//
//@interface NSObject (getLayer)
//- (CAL*)	getLayer;
//+ (NSView*) viewInView:(NSView*)view;
//@end
//@implementation NSObject (getLayer)
//+ (NSView*)viewInView:(NSView*)view;
//{
//	NSView* v = [[NSView alloc]initWithFrame:[view frame]];
//	[view addSubview:v positioned:NSWindowAbove relativeTo:view.lastSubview];
//	return v;
//}
//- (CAL*)getLayer { //__block NSView* me = (NSView*)self;
//	return  [(NSView*)self layer] ?: [(NSView*)self setupHostView];//(CAL*)^{ [me setWantsLayer:YES];  me.layer.anchorPoint = (CGP){.5, .5}; [me.layer setAnchorPointRelative:me.center]; return me.layer; }();
//}
//@end
/*

const CGFloat dash[2] = {100, 60};


#define SPINS			  3.0f
#define DURATION		   2.5f
#define TRANSITION_OUT_KEY @"transition out"
#define TRANSITION_IN_KEY  @"transition in"
#define TRANSITION_IDENT   @"transition type"

@implementation NASpinSeque

+ (id)animateTo:(id)v inSuperView:(id)sV
{
	NASpinSeque *n = [NASpinSeque new];// = [super init];
	//	if (self) {

	n.sV = sV ?: [[[NSApplication sharedApplication]mainWindow]contentView];
	n.v1 = [sV subviews][0] ?: [NSObject viewInView:sV];
	n.v2 = v;
	//		[[NSThread mainThread]performBlock:^{
	[n perform];
	//		} waitUntilDone:YES];
	return n;
}
- (void)perform{
	CABA *rotation = [CABA animationWithKeyPath:@"transform.rotation"];
	rotation.fromValue = @0.0;
	rotation.toValue   = @(M_PI * SPINS);

	CABA *scaleDown = [CABA animationWithKeyPath:@"transform.scale"];
	scaleDown.fromValue = @1.0;
	scaleDown.toValue   = @0.0;

	CABA *fadeOut = [CABA animationWithKeyPath:@"opacity"];
	fadeOut.fromValue = @1.0;
	fadeOut.toValue   = @0.0;

	CAAG *transitionOut = [CAAG animation];
	transitionOut.animations		  = @[rotation, scaleDown, fadeOut];
	transitionOut.duration			= DURATION;
	transitionOut.delegate			= self;
	transitionOut.removedOnCompletion = NO;
	transitionOut.fillMode			= kCAFillModeForwards;
	[transitionOut setValue:TRANSITION_OUT_KEY forKey:TRANSITION_IDENT];
	self.l1 = [_v1 getLayer];
	_l1.frame = _sV.bounds;
	_l1.anchorPoint = (CGPoint){.5,.5};
	//	_l1.frame  = [_sV bounds];//anchorPoint = NSMakePoint(.5,.5);
	[_l1 addAnimation:transitionOut forKey:TRANSITION_OUT_KEY];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

	NSString *type = [anim valueForKey:TRANSITION_IDENT];

	if ([type isEqualToString:TRANSITION_OUT_KEY]) {
		[_sV subviewsBlockSkippingSelf:^(id view) {
			[view setHidden:YES];
		}];
		//		[self.v2 setHidden:YES];
		if ([_sV.subviews doesNotContainObject:_v2]) [_sV addSubview:_v2];
		[_v2 setFrame:_sV.bounds];
		//		[_v2 setNeedsDisplay:YES];
		self.l2 =[_v2 getLayer];

		_l2.frame = [_sV bounds];
		//		_l2.frame = [self.sV bounds];//NSMakePoint(.5,.5);
		_l2.anchorPoint = (CGPoint){.5,.5};
		CABA *rotation = [CABA animationWithKeyPath:@"transform.rotation"];
		rotation.fromValue = @0.0;
		rotation.toValue   = @(M_PI * SPINS);

		CABA *scaleUp = [CABA animationWithKeyPath:@"transform.scale"];
		scaleUp.fromValue = @0.0;
		scaleUp.toValue   = @1.0;

		CAAG *transitionIn = [CAAG animation];
		transitionIn.animations = [NSArray arrayWithObjects:rotation, scaleUp, nil];
		transitionIn.duration   = DURATION;
		transitionIn.delegate   = self;
		[transitionIn setValue:TRANSITION_IN_KEY forKey:TRANSITION_IDENT];

		//		[self.l1 presentModalViewController:self.destinationViewController animated:NO];
		//		[self.v2 fadeIn];
		[self.l2 addAnimation:transitionIn forKey:TRANSITION_IN_KEY];

		return;//destinationLayer
	}

	if ([type isEqualToString:TRANSITION_IN_KEY]) {
		[self.v1 removeFromSuperview];
		[self.l1 removeAnimationForKey:TRANSITION_OUT_KEY];
	}




}
*/

/*
 - (IBAction)changeViewController:(id)sender
 {

 if ([myCurrentViewController view] != nil)
 [[myCurrentViewController view] removeFromSuperview];	// remove the current view

 if (myCurrentViewController != nil)
 [myCurrentViewController release];		// remove the current view controller

 switch (whichViewTag)
 {
 case 0:	// swap in the "CustomImageViewController - NSImageView"
 {
 CustomImageViewController* imageViewController =
 [[CustomImageViewController alloc] initWithNibName:kViewTitle bundle:nil];
 if (imageViewController != nil)
 {

 myCurrentViewController = imageViewController;	// keep track of the current view controller
 [myCurrentViewController setTitle:kViewTitle];
 }
 break;
 }

 case 1:	// swap in the "CustomTableViewController - NSTableView"
 {
 CustomTableViewController* tableViewController =
 [[CustomTableViewController alloc] initWithNibName:kTableTitle bundle:nil];
 if (tableViewController != nil)
 {
 myCurrentViewController = tableViewController;	// keep track of the current view controller
 [myCurrentViewController setTitle:kTableTitle];
 }
 break;
 }

 case 2:	// swap in the "CustomVideoViewController - QTMovieView"
 {
 CustomVideoViewController* videoViewController =
 [[CustomVideoViewController alloc] initWithNibName:kVideoTitle bundle:nil];
 if (videoViewController != nil)
 {
 myCurrentViewController = videoViewController;	// keep track of the current view controller
 [myCurrentViewController setTitle:kVideoTitle];
 }
 break;
 }

 case 3:	// swap in the "NSViewController - Quartz Composer iSight Camera"
 {
 NSViewController* cameraViewController =
 [[NSViewController alloc] initWithNibName:kCameraTitle bundle:nil];
 if (cameraViewController != nil)
 {
 myCurrentViewController = cameraViewController;	// keep track of the current view controller
 [myCurrentViewController setTitle:kCameraTitle];
 }
 break;
 }
 }

 // embed the current view to our host view
 [myTargetView addSubview: [myCurrentViewController view]];

 // make sure we automatically resize the controller's view to the current window size
 [[myCurrentViewController view] setFrame: [myTargetView bounds]];

 // set the view controller's represented object to the number of subviews in that controller
 // (our NSTextField's value binding will reflect this value)
 [myCurrentViewController setRepresentedObject: [NSNumber numberWithUnsignedInt: [[[myCurrentViewController view] subviews] count]]];

 [self didChangeValueForKey:@"viewController"];	// this will trigger the NSTextField's value binding to change
 }

@end
*/




//self.sublayerOrig + self.sublayerSpan  < self.superBounds  - self.lastLaySpan
// || offset < NEG(self.firstLayerSpan))
//__block CGF spanner = 0;	[scrollLayer.sublayers each:^(CAL* cur) {  spanner += oreo == VRT ? cur.boundsHeight : cur.boundsWidth; }]; return spanner;	}

//		NSLog(@"fix:%@ superbounds:%0.0f off: %0.0f origin: %0.0f  span:%0.0f  first:%0.0f  last:%0.0f", stringForScrollFix(fixState), self.superBounds, _offset, self.sublayerOrig, self.sublayerSpan, self.firstLaySpan, self.lastLaySpan );
//	fixState == LayerStateOK  		? [scrollLayer setNeedsLayout] : nil;
//	if (fixState != LayerStateOK)
//	if (fixState != LayerStateOK  && tries < 4) [self fixLayerState];

//	NSLog(@"layer:%@", scrollLayer.debugLayerTree);
//			obj.frame = AZMakeRect( (NSP){ oreo == VRT ? 0 : off, oreo == VRT ? off : 0 }, obj.boundsSize );
//	_offset = 0;
//	if (fixState != LayerStateOK)	self.fixState;
//	[self fixLayerState];	// offset = 0;// [scrollLayer.sublayers each:^(CAL* obj) {	if (oreo == VRT) obj.frameMinY += offset; else obj.frameMinX += offset; }]; }]; if (_sublayerOrigin == 1) offset = 0;
//- (void) setOffset:(CGF)o 			{ if ( offset 	   != o) { offset		= o; [scrollLayer setNeedsLayout]; }	 } //[scrollLayer performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:YES]; } }// [self fixLayerState]; } }
//- (void) setOrientation:(AZOrient)o	{ if ( oreo        != o) { oreo      	= o; [scrollLayer setNeedsLayout]; }	 }
//- (void) setLayerQueue:(NSMA*)q		{ if ( layerQueue  != q) { layerQueue 	= q; [self 		   fixLayerState]; }	 }

//+ (NSSet*) keyPathsForValuesAffectingFixState { return [NSSet setWithObjects:@"layerQueue", @"offset", nil]; }

//	if (oreo == VRT) 	newFirst.frameMinY =  _sublayerOrigin - newFirst.boundsHeight; else 	newFirst.frameMinX =  _sublayerOrigin - newFirst.boundsWidth;
//	if (oreo == VRT)	newFirst.frameMinY = _sublayerOrigin + _sublayerSpan;	else	newFirst.frameMinX = _sublayerOrigin + _sublayerSpan;
//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//	if (areSame(keyPath, @"") ) [scrollLayer setNeedsLayout];
//	else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//}
