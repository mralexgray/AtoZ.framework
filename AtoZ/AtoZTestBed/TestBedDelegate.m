
#import "TestBedDelegate.h"



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



@interface TestBedDelegate ()
//@property (STRNG) CATransition *transition;
//@property (STRNG) NSA *transitions;
@end


// Constants used by the Scroll layer to setup its contents and to scroll.
#define kScrollContentRect CGRectMake(  0.0,   0.0, 3000.0, 300.0)


@implementation TestBedDelegate
//@synthesize holdOntoViews;//, activeView, semiLog, semiWindow;
@synthesize window, genVC, uiVC, colorVC, mainView, colorWell;//, geoVC, , fileGrid, vcs, , colorWell;

- (void) awakeFromNib
{
	[self.window setAcceptsMouseMovedEvents:YES];
	[self.window makeFirstResponder:mainView];
	[self createScrollLayer];
//	[NotificationCenterSpy toggleSpyingAllNotificationsIgnoring:nil ignoreOverlyVerbose:YES];
//	[AtoZ sharedInstance];
//	window.delegate = self;

	[((BGHUDView*)window.contentView).theme bind:@"baseColor" toObject:colorWell withKeyPath:@"color" options:nil];

//	vcs 		= [WeakMutableArray new];

//	genVC 		= [[AZGeneralViewController  alloc] initWithNibName: @"AZGeneralViewController"  bundle:nil];
//	[vcs addObject:genVC.view];
//	geoVC 		= [[AZGeometryViewController alloc] initWithNibName: @"AZGeometryViewController" bundle:nil];
//	[vcs addObject:geoVC.view];
//	uiVC  		= [[AZUIViewController	     alloc] initWithNibName: @"AZUIViewController"	     bundle:nil];
//	[vcs addObject:uiVC.view];
//	fileGrid 	= [[AZFileGridView 			 alloc]   initWithFrame: mainView.bounds];
//	[vcs addObject:fileGrid];

//	 @{  @"General" : genVC.view, @"Geometry": geoVC.view, @"fileGridView" : fileGrid, @"UI" : uiVC.view }.mutableCopy;

//	for ( NSV* view in vcs) {
//		view.frame  = [mainView bounds];		view.arMASK = NSSIZEABLE;
//		view.hidden = YES;						[mainView addSubview:view];
//	}

//	[fileGrid setHidden:NO];

//	holdOntoViews.actionBlock = ^(id inSender){		semiWindow = [AZSemiResponderWindow new];
//		semiWindow.semiResponder = self;			[semiWindow   makeKeyAndOrderFront:self];
//	};

//	self.genVC = [[AZGeneralViewController alloc]initWithNibName:@"AZGeneralViewController" bundle:nil];
//	[_mainView addSubview: _genVC.view];
//	_genVC.view.frame	= [_mainView frame];
}

//- (void) logString:(NSS*)s { 	self.semiLog = s; }

- (IBAction)setViewFromPopUp:(id)sender
{
//	[[mainView allSubviews]makeObjectsPerformSelector:@selector(fadeOut)];
//	[mainView removeAllSubviews];
	NSS *selecto = [sender titleOfSelectedItem];
	id view = areSame(selecto, @"General") ? genVC.view :
				   areSame(selecto, @"UI") ? uiVC.view :
					areSame(selecto, @"Colors") ? colorVC.view :
						areSame(selecto, @"Facebook") ? _fbV.view : nil;
	if (view) {
		NSLog(@"selecto:%@  view:%@", [selecto debugDescription],[view subviews]);
		if (mainView.subviews.count != 0) {
			[mainView.subviews.first fadeOut];
//			[mainView removeAllSubviews];
	}
		mainView.subviews = @[view];
		[view setFrame:mainView.bounds];
//		[(NSV*)view setAutoresizingMask: NSSIZEABLE];
		[view fadeIn];
	}
	if ( areSame(@"CAScrollLayer", selecto))
	{
		[self createScrollLayer];
	}
//	[[mainView animator]swapSubs:newView];
//	[[activeView animator] setHidden:YES];
//	activeView = vcs[[sender titleOfSelectedItem]];
//	[mainView addSubview:activeView positioned:NSWindowAbove relativeTo:mainView];
//	[activeView setHidden:NO];
//	[_activeView setNeedsDisplay:YES];
}


- (void) createScrollLayer
{
	if ( mainView.subviews.count > 0) [mainView.subviews.first fadeOut];		//		[mainView.subviews[0] removeFromSuperview];
	if ([mainView.subviews doesNotContainObject:_scrollTestHost])		[mainView addSubview:_scrollTestHost];
	[_scrollTestHost setFrame:mainView.frame];
	 _scrollTestHost.arMASK = NSSIZEABLE;			//	[_scrollTestHost fadeIn];  [_scrollTestHost setFrame:mainView.bounds];
	[self reZhuzhScrollLayer:nil];
}

- (IBAction)reZhuzhScrollLayer:(id)sender
{
	_scrollTest.hoverStyle = Lasso;
	_scrollTest.selectedStyle = DarkenOthers;
	_scrollTest.layerQueue =
 	[[NSC randomPalette] nmap:^id(NSC* c, NSUI idx) {

		CAL *l = [CAL layerNamed:$(@"%ld",idx)];
		l.bounds = AZRectBy(40,40);
		l.bgC = c.brighter.cgColor;
//		l.loM = AZLAYOUTMGR;
//		l.constraints = @[AZConstAttrRelNameAttrScaleOff(kCAConstraintWidth, @"superlayer", kCAConstraintHeight, 1, 0), AZConstRelSuper(kCAConstraintHeight)];
//		l.arMASK = CASIZEABLE;
//		[l addConstraintsRelSuper: kCAConstraintMidY];//kCAConstraintHeight, kCAConstraintMaxY, kCAConstraintMidY, kCAConstraintMinY, nil];
//		l.borderColor = c.darker.cgColor;
		l.delegate = self;
		[l setNeedsDisplay];
		return l;
	}].mutableCopy;

}

- (void)drawLayer:(CAL*)layer inContext:(CGContextRef)ctx
{
//	NSLog(@"drawLinCTX called on: %@...  vageen?:%@", layer, StringFromBOOL([layer boolForKey:@"clicked"]));

	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
//		!layer.hovered ?: ^{
//			NSRectFillWithColor(layer.bounds, [NSC checkerboardWithFirstColor:BLACK secondColor:CLEAR squareWidth:20]);
//			NSBP *b = [NSBP bezierPathWithRect:layer.bounds];
//			[b fillWithInnerShadow:[NSSHDW shadowWithColor:BLACK offset:NSMakeSize(4, -4) radius:10]];
//		}();
//		[NSSHDW setShadowWithOffset:(NSSZ){5,-3} blurRadius:7 color:BLACK];
		NSIMG * icon;// = [NSIMG randomMonoIcon];
		if ( [layer hasAssociatedValueForKey:@"icon"] ) icon = [layer associatedValueForKey:@"icon"];
		else { icon = [[NSIMG randomMonoIcon]etched]; [layer setAssociatedValue:icon forKey:@"icon" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]; }
		[icon drawInRect:AZMakeSquare((NSP){NSMidX(layer.bounds), (.5 * layer.boundsWidth)}, .5 * layer.boundsWidth) fraction:1];//:[NSInsetRect(layer.bounds, 0, 10) fraction:1];// operation:NSCompositePlusDarker fraction:1];
//		[layer.name drawInRect:layer.bounds withFontNamed:@"Helvetica" andColor: WHITE];
	}];

}
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
//	_scrollLayer.frame = mainView.bounds;
//	_scrollLayer.arMASK = CASIZEABLE;
	// Since its handy, we'll use the same content as our basic CALayer example
	// This also shows that you can use the same delegate for multiple layers :)
//	scrollLayerContent.delegate = delegateCALayer;

	// Layers start life validated (unlike views).
	// We request that the layer have its contents drawn so that it can display something.
//	[_scrollLayerContent setNeedsDisplay];

	// We set a frame for this layer. Sublayers coordinates are always in terms of the
	// parent layer's bounds.
//	scrollLayerContent.frame = mainView.bounds;

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
//	[mainView.subviews each:^(NSV* obj) { [[obj animator] setFrame:mainView.bounds]; }];
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

@end

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