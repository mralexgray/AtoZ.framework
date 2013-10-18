
#import "TestBedDelegate.h"

@interface TestBedDelegate ()
//@property (STRNG) CATransition *transition;
//@property (STRNG) NSA *transitions;
@end

// Constants used by the Scroll layer to setup its contents and to scroll.
//#define kScrollContentRect CGRectMake(  0.0,   0.0, 3000.0, 300.0)
#define kScrollContentRect CGRectMake(  0.0,   0.0, 100, _targetView.height )

@implementation TestBedDelegate
- (IBAction)newTab:(id)sender{


	[AZSimpleView preview];
	
}
#define NEWVC(_x_) ^{  \
	NSB *bun = [NSB bundleForClass:[_x_ class]]; \
	return (_x_*)[[[_x_ class] alloc] initWithNibName:NSStringFromClass([_x_ class]) bundle:bun]; \
}()

-  (void) awakeFromNib						{

//	_windowControllers = [[AZFILEMANAGER filesInDirectoryAtPath:AZAPPRESOURCES includeInvisible:NO includeSymlinks:NO]filter:^BOOL(NSS* f) { return f.pathExtension
//	} 
	[_menu   loadStatusMenu];
	[((BGHUDView*)_contentView).theme bind:@"baseColor" toObject:_colorWell withKeyPath:@"color" options:nil];
//	[self.window setAcceptsMouseMovedEvents:YES];
//	[self.window makeFirstResponder:_targetView];
	[NSC randomPaletteAnimationBlock:^(NSColor *c) {
		_colorWell.color = c;
	}];
//		NSLog(@"Color: %@", c.nameOfColor); _colorWell.color = c; 	}];
//	[self createScrollLayer];
}
-   (IBA) setViewFromPopUp:(id)sender	{	NSS *selecto = [sender titleOfSelectedItem];

	id view = 	SameString(selecto,     @"General") ? [_genVC 	= _genVC 	?: NEWVC(GeneralVC) view] :
			   	SameString(selecto, 		     @"UI") ? [_uiVC 	= _uiVC 		?: NEWVC(UIVC) 	  view] :
					SameString(selecto,      @"Colors") ? [_colorVC = _colorVC 	?: NEWVC(ColorVC)   view] :
					SameString(selecto, 	  @"Facebook") ? [_fbV 		= _fbV 		?: NEWVC(FBVC)  	  view] :
					SameString(selecto, 		   @"TUIV") ? [_tuiVC 	= _tuiVC 	?: NEWVC(TUIVVC)    view] :
					SameString(selecto, @"BPODialTest") ? BPODialTest.new : nil;

	if (view && [view ISKINDA:NSView.class]) {	
		NSLog(@"selecto:%@  view:%@", selecto,[view subviews]);
												[view setFrame:_targetView.bounds];
												[_targetView swapSubs:view];
	} else [view ISKINDA:[NSWindowController class]] ? ^{
		_windowControllers = _windowControllers ?: NSMA.new;
		[_windowControllers addObject:view];
		[[view window]display];
		[[view window]makeKeyAndOrderFront:nil];
		
			NSLog(@"View: %@, etc %@", view, [view window]);
		}():
	
	areSame(@"CAScrollLayer", selecto) ? [self createScrollLayer] : nil;
}
- (NSMD*) model 								{  return _model = _model ?:  ^{
		NSA* icons = [NSIMG.monoIcons withMaxItems:30];
		return  @{ @"icons" :  icons, @"colors" :[NSC gradientPalletteLooping:NSC.randomPalette steps:icons.count] }.mutableCopy;
	}();
}
-  (void) createScrollLayer				{

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
- (void) alternate 			{

	_targetView.subviews = @[_host = [BLKVIEW inView:_targetView withBlock:^(BLKVIEW *v, CAL *l) {	 }]];
   _host.layer.sublayers = @[_scrlr = [CASCRLL layerWithFrame:_host.layer.bounds]];					
				  _scrlr.bgC = [[GREEN alpha:.4] CGColor];
			  _scrlr.arMASK = CASIZEABLE;
			_scrlr.delegate = self;
			
  self.model[@"layers"]	= _scrlr.sublayers = [self.model [@"icons"] nmap:^id(NSIMG*o, NSUI idx){
//			CAL*gImg;
			CAGL *g 	= [CAL gradientWithColor:self.model[@"colors"][idx]];
//				 	g.sublayers = @[gImg = [CAL layerNamed:o.name]];
						  g.name = o.name;
				  [g setInt:idx forKey:@"index"];
//				 gImg.contents = o;
//				gImg.transform = CATransform3DMakeScale(.65, 1, 1);
					 g.delegate = self;
						[g setNeedsDisplay];
						  return g;	}];
						  
	[NSEVENTLOCALMASK:NSScrollWheelMask handler:^(NSE*e){
		self.off += e.deltaX * ABS(e.deltaX);	[_scrlr scrollToPoint:(NSP){_off, 0}];		return e; }];
		
	[NSEVENTLOCALMASK:NSLeftMouseUpMask handler:^(NSE*e){	CAGL* c = self.hit; 	if (c) [c setFrameMinX:c.frameMinX - c.boundsWidth]; return e; }];
		
	[_targetView.window setAcceptsMouseMovedEvents:YES];
	[NSEVENTLOCALMASK:NSMouseMovedMask handler:^(NSE*e){ static id hovered;	CAGL* c = self.hit; 
																			if(c && ![c[@"spinning"]boolValue] && c != hovered) { 
																			[hovered setBool:NO forKey:@"hover"]; 
																			[c setBool:YES forKey:@"hover"]; } 				return  e; }];
}
- (CAGL*) hit 					{ NSP hit = _host.windowPoint;  hit.x += _off;	return _hit = (CAGL*)[_scrlr hitTestSubs:hit]; }
- (NSA*) visibleSubs	 		{ return _visibleSubs = _scrlr.visibleSublayers; }
- (NSA*) subsAscending		{ return _subsAscending = _scrlr.sublayersAscending; }
- (NSUI) indexLastVisible 	{ NSA *visi = self.visibleSubs;  return visi ? [self.subsAscending indexOfObject:visi.last]   : NSNotFound; }
- (NSUI) indexFirstVisible { NSA *visi = self.visibleSubs;  return visi ? [self.subsAscending indexOfObject:visi[0]] : NSNotFound; }
- (NSS*) visibleSubsString { NSA* vs = [self.visibleSubs valueForKeyPath:@"name"]; 
									  return $(@"%@ [%ld] Offset:%.1f", [NSS stringFromArray:vs], vs.count, self.off); 
}
- (NSRNG) front 				{ return NSMakeRange( 							0, self.visible.location); }
- (NSRNG) back 			 	{ return NSMakeRange(	self.visible.length, _scrlr.sublayers.count); }
- (NSRNG) visible 			{ return NSMakeRange(self.indexFirstVisible, self.indexLastVisible ); }

- (NSString *)fixState 	{ return stringForScrollFix(self.scrollFix); }
- (ScrollFix) scrollFix { 	ScrollFix aFix 		= 	self.front.location == 0  && [self indexLastVisible] < self.subsAscending.count 
															? 	LayerInsertFront
															:	self.visible.length 	== _scrlr.sublayers.count
															?	LayerInsertEnd
															:	LayerStateOK; // self.back.length - _visible.length 	
	static NSUI fixCt = 0;  fixCt++;	
	if (aFix != LayerStateOK) 
	{ 
		NSLog(@"fix:%@ x %ld",stringForScrollFix(aFix), fixCt);	
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
	NSArray *action = @[	^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect,.25, .5,  1, .5)]; },
							  ^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect, .5,.25,  1, .5)]; },
							  ^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect,.25,  0,  1, .5)]; },
							  ^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect,  0,.25,  1, .5)]; },
							  ^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect,  0, .5, .5, .5)]; },
							  ^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect, .5, .5, .5, .5)]; },
							  ^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect,  0,  0, .5, .5)]; },
							  ^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect,  0,  0, .5, .5)]; },
							  ^{ [_scrlr scrollToRect:MakeSubrect(kScrollContentRect, .5,  0, .5, .5)]; }];

	((void (^)()) [action objectAtIndex:i] )();
}
@end

