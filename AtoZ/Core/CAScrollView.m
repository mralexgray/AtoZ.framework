
#import "CAScrollView.h"

@interface CAScrollView ()
@property (UNSFE, RONLY)	NSA			*allLayers;
@property (NATOM, STRNG) 	NSA 		*shroudedLayers;
@property (NATOM, STRNG) 	CAL 		*scrollLayer;
@property (NATOM, STRNG) 	CALNH 		*hostlayer;
@property 	  				CGF 		offset;
@property (RONLY)  		 	CGF 		firstLaySpan, sublayerOrig, sublayerSpan, lastLaySpan, superBounds, lastLayOrig;
@property (NATOM)			BOOL 		needsLayout;
@end

@implementation CAScrollView
@synthesize 	layerQueue, 		hostlayer, 	scrollLayer, 	orientation = oreo, needsLayout, offset = _offset;

- (void) awakeFromNib
{
	_selectedStyle = _hoverStyle = None;
	oreo         		= HRZ;
	hostlayer 			= [self setupHostViewNoHit];
	hostlayer.name		= @"hostLayer";
	scrollLayer 		= [CAL layerWithFrame:self.bounds];
	scrollLayer.name	= @"scrollLayer";
	scrollLayer.arMASK 	= CASIZEABLE;
	hostlayer.sublayers = @[scrollLayer];
	scrollLayer.loM 	= self;
//	[self observeFrameChangeUsingBlock:^{ [self setFixState:LayerStateUnset]; }];
//	[self addObserver:self keyPath:@[@"offset",@"orientation",@"layerQueue"] selector:@selector(fixState	) userInfo:nil options:NSKeyValueObservingOptionNew];
}

- (void)setLayerQueue:(NSMA*)lQ
{
	if (scrollLayer.sublayers.count > 0) [scrollLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
	layerQueue = lQ;
	__block CGF scrollWide = 0;  [lQ each:^(CAL*l) {  scrollWide += oreo == VRT ? l.boundsHeight : l.boundsWidth; }];
	NSI i = 0;
	while ( scrollWide < self.superBounds ) { CAL* l = [[layerQueue normal:i] copyLayer]; [layerQueue addObject:l]; i++; scrollWide += oreo == VRT ? l.boundsHeight : l.boundsWidth; }
	[self fixStateRecursively:YES];
}

- (void) viewDidMoveToSuperview
{
	self.window.acceptsMouseMovedEvents = YES;
	[self.window makeFirstResponder: self];
}

- (void) layoutSublayersOfLayer: (CAL*)layer
{
	[CATransaction immediately:^{
		__block CGF off = _offset;
		[scrollLayer.sublayers each:^(CAL* obj) {
			obj.frameMinX = oreo == VRT ? 0 : off;
			obj.frameMinY = oreo == VRT ? off : 0;
			off += oreo == VRT ? obj.boundsHeight : obj.boundsWidth;
		}];
	}];
}

- (CGF) sublayerSpan { return ((NSN*)[scrollLayer.sublayers reduce:^id(NSN*memo,CAL*cur) { return @(memo.floatValue + oreo == VRT ? cur.boundsHeight : cur.boundsWidth); } withInitialMemo:@0]).floatValue; }
- (CGF) sublayerOrig { return [scrollLayer.sublayers.first floatForKey: oreo == VRT ? @"frameMinY"    : @"frameMinX"  ]; }
- (CGF) lastLaySpan  { return [scrollLayer.sublayers.last  floatForKey: oreo == VRT ? @"boundsHeight" : @"boundsWidth"]; }
- (CGF) firstLaySpan { return [scrollLayer.sublayers.first floatForKey: oreo == VRT ? @"boundsHeight" : @"boundsWidth"]; }
- (CGF) lastLayOrig  { return [scrollLayer.sublayers.last  floatForKey: oreo == VRT ? @"frameMinY"    : @"frameMinX"  ]; }
- (CGF) superBounds  { return oreo == VRT ?  scrollLayer.boundsHeight : scrollLayer.boundsWidth; 					}
- (NSA*) allLayers 	 { return layerQueue.count > 0 ? [NSA arrayWithArrays:@[scrollLayer.sublayers, layerQueue]] : scrollLayer.sublayers; }

#define QAINTEMPTY && layerQueue.count > 0
#define SCRLHASSUB && scrollLayer.sublayers

- (void) fixStateRecursively:(BOOL)recurse
{
	ScrollFix theState =

		self.sublayerOrig 	> 0 					 				QAINTEMPTY 	? LayerInsertFront 	 :
		self.lastLayOrig 	< self.superBounds 		 				QAINTEMPTY	? LayerInsertEnd	 :
//		self.lastLayOrig 	< self.superBounds 		 							? LayerCopyInsertEnd :
		self.sublayerOrig 	< NEG(self.firstLaySpan) 				SCRLHASSUB 	? LayerRemoveFront	 :
		self.lastLayOrig 	> self.superBounds + self.lastLaySpan	SCRLHASSUB	? LayerRemoveEnd	 : LayerStateOK;
		
	if ( theState != LayerStateOK)	{
		[self fixLayerState:theState];
		[scrollLayer setNeedsLayout];
		if (recurse) [self fixStateRecursively:YES];
	}
	[scrollLayer setNeedsLayout];

}

- (void) fixLayerState:(ScrollFix)state { NSLog(@"reason:  %@", stringForScrollFix(state));

	state == LayerInsertFront 	? ^{	CAL *newFirst = layerQueue.shift;
										[scrollLayer insertSublayerImmediately:newFirst atIndex:0];
										_offset = oreo == VRT ? -newFirst.boundsHeight : -newFirst.boundsWidth;	}():
	state == LayerRemoveFront 	? ^{	[layerQueue shove: scrollLayer.sublayers.first];
										RemoveImmediately( scrollLayer.sublayers.first );
										_offset = 0;																}():
	state == LayerRemoveEnd    	? ^{	[layerQueue addObject:scrollLayer.sublayers.last];
										RemoveImmediately( scrollLayer.sublayers.last );						}():
	state == LayerInsertEnd		? 		[scrollLayer addSublayerImmediately:layerQueue.pop] :
	state == LayerCopyInsertEnd ? ^{ 	  }() : nil;
	//map:^id(CAL*l){ return [l copyLayer]; }]].mutableCopy;  }() : nil;

}

- (BOOL) acceptsFirstResponder 	{ 	return YES;		}
- (void) scrollWheel:(NSE*)e	{	self.offset += oreo == VRT ? e.deltaY : e.deltaX;	[self fixStateRecursively:NO]; }
- (void) mouseUp:    (NSE*)e	{	CAL* i = [scrollLayer hitTestSubs:[self convertPoint:e.locationInWindow fromView:nil]]; if (i) self.selectedLayer 	= i; }
- (void) mouseMoved: (NSE*)e 	{	self.hoveredLayer = [scrollLayer hitTestSubs:[self convertPoint:e.locationInWindow fromView:nil]] ?: nil; }

- (void) setHoveredLayer:(CAL*)hoveredLayer
{
	AZLOG(hoveredLayer.debugLayerTree);
	if (hoveredLayer == _hoveredLayer) return;
	!_hoveredLayer ?: ^{			_hoveredLayer.hovered = NO;	 	[_hoveredLayer setNeedsDisplay]; }();
	_hoveredLayer = hoveredLayer;	if (hoveredLayer) { _hoveredLayer.hovered = YES;	[_hoveredLayer setNeedsDisplay]; }
	_hoverStyle 	== DarkenOthers ? ^{ self.shroudedLayers = nil; self.shroudedLayers = hoveredLayer ? nil : @[_hoveredLayer]; }() :
	_hoverStyle 	== Lasso 		? hoveredLayer ? [self lasso:_hoveredLayer dymamicStroke:.05] : [self deLasso] : nil;
}
- (void) setSelectedLayer:(CAL*)selectedLayer
{
	if ( selectedLayer == _selectedLayer ) { _selectedLayer.selected = NO;	[_selectedLayer setNeedsDisplay];  _selectedStyle == Lasso ? [self deLasso] : _selectedStyle == DarkenOthers ? [self setShroudedLayers:nil] : nil; _selectedLayer = nil;  return; }
	_selectedLayer = selectedLayer;	_selectedLayer.selected = YES;	[_selectedLayer setNeedsDisplay];
	_selectedStyle == None ?: ^{
		_selectedStyle == DarkenOthers 	? ^{ self.shroudedLayers = nil; self.shroudedLayers = @[_selectedLayer]; }() 	:
		_selectedStyle == Lasso 		? [self lasso:_selectedLayer dymamicStroke:.05] 	: nil;
	}();

//		CAL* l = _hoverStyle == Lasso ? [self lassoLayerWithFrame:_hoveredLayer.bounds dymamicStroke:.03] :
//		
//		[_hoveredLayer addSublayer:];
}

- (IBAction) toggleOrientation:(id)sender { self.orientation = ((NSBUTT*)sender).state == NSOnState ? VRT : HRZ; }

- (void) setShroudedLayers:(NSA*)actuallyAllLayersExcept
{
	if (!actuallyAllLayersExcept) { [_shroudedLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)]; return; }
	NSA* all = [self.allLayers arrayWithoutObject:actuallyAllLayersExcept[0]];
	_shroudedLayers = [all map:^id(CAL* obj) {  CALNH* l = [CALNH layerWithFrame:obj.bounds]; l.bgC = cgBLACK; l.opacity = .7; [obj addSublayer:l]; return l; }];
}

- (void) deLasso { 	[self.allLayers each:^(CAL* l) { RemoveImmediately([l sublayerWithName:@"lasso"]); }]; }

- (void) lasso:(CAL*)layer dymamicStroke:(CGF)percent
{
	[self deLasso];
	CGF dynamicStroke 	= AZMinDim(layer.boundsSize) * percent;
	CASLNH *blk 			= [CASLNH layerWithFrame:layer.bounds];
	CASLNH *wht 			= [CASLNH layerWithFrame:layer.bounds];
	CALNH  *root 			= [CALNH  layerWithFrame:layer.bounds];
	root.name			= @"lasso";
	root.sublayers		= @[wht, blk];
	root.zPosition 		= 1000;
	blk.fillColor		= wht.fillColor	= cgCLEARCOLOR;
	blk.lineWidth		= wht.lineWidth	= dynamicStroke;
	blk.lineJoin		= wht.lineJoin 	= kCALineJoinMiter;
	blk.strokeColor		= cgBLACK;			// [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
	wht.strokeColor		= cgWHITE;

	blk.lineDashPattern	= @[ @(15), @(15) ];
	blk.path = wht.path	= [NSBP bezierPathWithRect:NSInsetRect( layer.bounds, dynamicStroke/2, dynamicStroke/2)].newQuartzPath;
	CABA *dashAnimation = [CABA animationWithKeyPath:@"lineDashPhase"];
	dashAnimation.fromValue		= @0;
	dashAnimation.toValue		= @30;
	dashAnimation.duration 		= .75;
	dashAnimation.repeatCount 	= 10000;
	[blk addAnimation:dashAnimation forKey:@"linePhase"];
	[layer addSublayer:root];
}
@end
