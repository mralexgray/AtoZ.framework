
#import "AtoZ.h"
#import "CAScrollView.h"

JREnum(ScrollFix, LayerInsertFront,	LayerInsertEnd, LayerRemoveFront, LayerRemoveEnd, LayerStateOK,	LayerStateUnresolved,	LayerStateUnset);
JREnum(StateStyle, LassoStyle, InnerShadow, DarkenOthers)

@interface CAScrollView ()
@property (NATOM) 	CAL *hostlayer;
@property (NATOM) 	NSA 	*shroudedLayers, *originalQueue;
@property (NATOM) ScrollFix fixState;
@property (NATOM)	 CGF 		offset;
@property (NATOM) NSUI 		normalizedCopyIndex;
@property (NATOM) BOOL 		recursiveFix, scrolling;
@prop_RO	CAL	*lastLayer, *firstLayer;
@prop_RO NSA 	*scrollLayersByAscendingPosition, *sSubs;
@prop_RO 	BOOL 	isVRT;
@property (STRNG) CWStack *stack;
@property (STRNG) CAScrollLayer *sclr;
@property (NATOM)		StateStyle 	hoverStyle, selectedStyle;
@end

#define WATCHDOGMAX  100
#define WATCHDOG_STOP _fixWatchdog > WATCHDOGMAX

@implementation CAScrollView
@synthesize layerQueue, scrollLayer,	oreo, fixState = _fixState, isVRT, hoverStyle, selectedStyle, stack;

- (id) initWithFrame:(NSRect)frameRect
{
	if (self != [super initWithFrame:frameRect]) return nil;
	oreo			 	 = HRZ;
	selectedStyle 		 = LassoStyle;				/* StateStyle(s) Lasso, 	InnerShadow, DarkenOthers,	None */
	hoverStyle 		 	 = DarkenOthers;
	_hostlayer 			 = [[[self setupHostViewNoHit] named:@"hostLayer"]colored:GREEN];
	_hostlayer.sblrs 	 = @[scrollLayer = [_hostlayer copyLayer]];
	scrollLayer.loM 	 = self;
	[scrollLayer addConstraintsSuperSize];
	_hostlayer.arMASK 	 = scrollLayer.arMASK = CASIZEABLE;
	[self awakeFromNib];
	return self;
}
-(void) awakeFromNib 
{
	self.frame 									= self.superview.bounds;
	self.arMASK									= NSSIZEABLE;
	self.window.acceptsMouseMovedEvents = YES;
	[self.window 		makeFirstResponder:self];
	[self   observeFrameChangeUsingBlock:^{ self.fixState = LayerStateUnset; }];
	self.needsDisplay							= YES;
}
- (void) setLayerQueue:(NSMA*)lQ
{
	[scrollLayer removeSublayers];
	layerQueue = lQ;
//	CGF qNativeWidth 	= [lQ sumFloatWithKey: isVRT ? @"boundsHeight" : @"boundsWidth"];
//	CGF vMinWidth 		= self.superBounds;
//	CGF qNativeUnit 	= [layerQueue[0] boundsWidth];
//	BOOL isWiderThanView = vMinWidth < qNativeWidth;
//	NSUI ct = 0;
//	if (isWiderThanView) {
//		CGF nativeVisible = 0; while (nativeVisible < vMinWidth) { ct++; nativeVisible += qNativeWidth; }
//	}
//	else 
	__unused NSUI ct = lQ.count;
	__unused CGF unitPercent = .4;
//	int normalI = 0;
//	while ( f < ( )  {		CAL*copy = [[lQ normal:normalI]copyLayer];
//																		  [layerQueue addObject:copy];
//													 normalI++; f += [self aLayerSpan:copy]; 
//	}
//	LOGWARN(@"donewithcopy:  had:%i  have:%i", lQ.count, layerQueue.count);
//	[layerQueue each:^(id obj) { [obj addConstraintsRelSuper:kCAConstraintHeight, AZConstRelSuperScaleOff( kCAConstraintWidth, unitPercent, 0), nil]; }];
	CAL *starter = layerQueue[0];  
	[scrollLayer addSublayerImmediately:starter];
//	[starter setFloat:-100 forKey:$(@"frameMin%@", isVRT ? @"Y" : @"X")];
	_recursiveFix = YES;	self.fixState = LayerStateUnset;
}

-(NSSZ) unit { return _unit = NSMakeSize(	isVRT ? self.width 	: self.width / self.allLayers.count , 
													isVRT ? self.height /self.allLayers.count : self.height); 
					
}
- (void) layoutSublayersOfLayer: (CAL*)layer
{	
	static int loslols = 0; loslols++; LOGWARN(@"loslols:%i", loslols);
	_unit = self.unit;
	[CATransaction immediately:^{	 __block CGF off = _offset;
		
		[scrollLayer.sublayers each:^(CAL *obj) { NSP o = (NSP) { isVRT ? 0 : off, isVRT ?	off : 0  };
																obj.frame = AZMakeRect(o, _unit);
																off += isVRT ? obj.height : obj.width;
		}];
	}];
		_scrolling 		= NO;
		_recursiveFix 	? [self setFixState :self.fixState] : nil;
}

#define QAINTEMPTY && layerQueue.count > 0
#define SCRLHASSUB && scrollLayer.sublayers

- (ScrollFix) fixState
{								
																								 return  	
	self.sublayerOrig 	> 0							 	? LayerInsertFront 	:
//	self.lastLayOrig  < self.superBounds  				? LayerInsertEnd	 :	 	
//	self.lastLayOrig 	< self.superBounds 		 		&& !layerQueue.count ? LayerCopyInsertEnd :
//	self.sublayerOrig 	< NEG(self.firstLaySpan) 					SCRLHASSUB 	? LayerRemoveFront	:
//	self.lastLayOrig 	> self.superBounds + self.lastLaySpan	SCRLHASSUB	? LayerRemoveEnd	   : 
	LayerStateOK;
	
}
-(void) setFixState:(ScrollFix)f
{
	LOGWARN(@"Fix:%@ dog:%ld subs:%ld q:%ld",ScrollFixToString(f),_fixWatchdog,self.sublayerCt,layerQueue.count);
	
	if (f == LayerStateOK || f == LayerStateUnresolved) { 	_fixWatchdog = 0; _recursiveFix = NO; 
																				[scrollLayer setNeedsLayout]; return; }
	
	f == LayerInsertFront	 ? ^{	 layerQueue.count ? ^{	CAL *newFirst = layerQueue.shift;
																				_offset -=  [self aLayerSpan:newFirst];
													[scrollLayer insertSublayerImmediately:newFirst  atIndex:0]; }(): ^{
													LOGWARN(@"%@",@"copying in front!");
											[scrollLayer addSublayerImmediately: [scrollLayer.sublayers[0]copyLayer]];
				}();
																	}():
	f == LayerRemoveFront	 ? ^{		 						  CAL *front = self.firstLayer; 	
												  [layerQueue  shove: front];	 
									   _offset += [self aLayerSpan:front];		
																			 [front  removeImmediately];		}():
	f == LayerRemoveEnd  	 ? ^{							CAL *end = self.lastLayer;
												 [layerQueue addObject:end];
																			 [end removeImmediately];		   }():	
	f == LayerInsertEnd 	 ? ^{  layerQueue.count ? [scrollLayer addSublayerImmediately:layerQueue.pop]  
																: ^{   LOGWARN(@"%@",@"copying in back!");
																			 [scrollLayer addSublayerImmediately:
																					[scrollLayer.sublayers[0]copyLayer]]; }();
									}():
	f == LayerStateUnset 	 ? [self setFixState:			  self.fixState]: nil;  	
	[scrollLayer  setNeedsLayout]; 
//	[self setFixState:self.fixState];
	
}

//f == LayerCopyInsertEnd  ? ^{ 
//
//	NSR lastFrame = self.lastLayer.frame;
//	 	 lastFrame = isVRT ? AZRectVerticallyOffsetBy   ( lastFrame, lastFrame.size.height )
//								 : AZRectHorizontallyOffsetBy ( lastFrame, lastFrame.size.width  );
//	CAL *l = [_originalQueue[_normalizedCopyIndex] copyLayer];			
//	[scrollLayer addSublayerImmediately:l];
//	l.frame = lastFrame; 
//	NSLog(@"NeedMoreLayers! Displaying %i. Making copy %ld / %ld [normal: %ld] New lastFrame:%@ in superb: %0.1f",
//	self.sublayerCt	, copyIndex, _originalQueue.count, _normalizedCopyIndex, AZString(lastFrame), self.superBounds);
//	copyIndex++; 
//	_normalizedCopyIndex = _normalizedCopyIndex < _originalQueue.count - 1 ? _normalizedCopyIndex + 1 : 0;  
//}() :
//f == LayerCopyInsertFront ? ^{

//	lastFrame = isVRT ? AZRectVerticallyOffsetBy   ( lastFrame, lastFrame.size.height )
//	: AZRectHorizontallyOffsetBy ( lastFrame, lastFrame.size.width  );
//	CAL *newFirst = [_originalQueue[_normalizedCopyIndex] copyLayer];			
//	[scrollLayer insertSublayer:newFirst atIndex:0];
//	_offset -= [self aLayerSpan:newFirst];															
//	NSLog(@"CopyFront! Displaying %i. Making copy %ld / %ld [normal: %ld] superb: %0.1f",
//			self.sublayerCt	, copyIndex, _originalQueue.count, _normalizedCopyIndex, self.superBounds);
//	copyIndex++; 
//	_normalizedCopyIndex = _normalizedCopyIndex < _originalQueue.count - 1 ? _normalizedCopyIndex + 1 : 0;  

/*	[scrollLayer insertSublayerImmediately:l atIndex:scrollLayer.sublayers.count];	*/


//	if (_fixState == LayerStateOK){  [scrollLayer setNeedsLayout]; _fixWatchdog = 0;  return; }
	//map:^id(CAL*l){ return [l copyLayer]; }]].mutableCopy;  }() : nil;

- (NSA*) sSubs 		{ return scrollLayer.sublayers; } 
- (NSA*) scrollLayersByAscendingPosition { return [self.sSubs sortedWithKey:isVRT ? @"frameMinY" : @"frameMinX" ascending:YES]; }
- (NSA*) allLayers	 	{

	return scrollLayer.sublayers  && layerQueue.count 			? [NSA arrayWithArrays:@[scrollLayer.sublayers, layerQueue]] :
			 scrollLayer.sublayers  && layerQueue.count == 0 	? scrollLayer.sublayers :
			 !scrollLayer.sublayers && layerQueue.count 			? layerQueue  : nil;
}
- (CAL*) lastLayer 	{ return  self.scrollLayersByAscendingPosition.last; 	}
- (CAL*) firstLayer 	{ return  self.scrollLayersByAscendingPosition.first;	}
- (NSUI) sublayerCt  { return  self.sSubs.count; }
- (CGF) sublayerOrig	{ return [self.firstLayer.modelLayer fKey: isVRT ? @"frameY" 		: @"frameX"  ]; }
- (CGF) lastLaySpan	{ return [self aLayerSpan:self.lastLayer.modelLayer]; }
- (CGF) firstLaySpan	{ return [self aLayerSpan:self.firstLayer.modelLayer]; }
- (CGF) lastLayOrig	{ return [self.lastLayer.modelLayer  fKey: isVRT ? @"frameY"		: @"frameX"  ]; }
- (CGF) superBounds	{ return isVRT ? scrollLayer.height : scrollLayer.width;			 }
- (CGF) sublayerSpan	{
	return ((NSN*)[self.	sSubs reduce:^id(NSN*memo,CAL*cur) {
		return @(memo.fV + [self aLayerSpan:cur]); } withInitialMemo:@0]).fV;
}																														// Sizing getters
- (CGF) aLayerSpan:(CAL*)l { return  isVRT ? [(CAL*)l.modelLayer height] : [(CAL*)l.modelLayer width]; }


- (void) scrollWheel:(NSE*)e																								//	Event Handling
{
	_offset += (isVRT ? e.deltaY : e.deltaX) * 5 ;
	_recursiveFix = NO; // NSLog(@"Offset:%f", _offset);
	[self setFixState:self.fixState];
	[(NSObject*)_delegate respondsToStringThenDo:@"scrollView:isScrolling:" withObject:self withObject:e];
}
- (void) mouseDown:  (NSE*)e
{
	NSP hitPoint = [self convertPoint:e.locationInWindow fromView:nil];
	CAL* i = [scrollLayer hitTestSubs:hitPoint];
	 if (i) self.selectedLayer 	= i;
	NSLog(@"hittest %@, found:%@ F:%@  B:%@", AZString(hitPoint), i.name, AZStringFromRect(i.frame), AZStringFromRect([i.modelLayer bounds]));// [[NSC colorWithCGColor:i.bgC]nameOfColor]);
}
- (void) mouseMoved: (NSE*)e
{
	self.hoveredLayer = [scrollLayer hitTestSubs:e.locationInWindow];//[self convertPoint:e.locationInWindow fromView:nil]] ?: nil; /*NSLog(@"scrollview mousemoved: %@", AZString(e.locationInWindow));*/
}
- (void) setHoveredLayer:(CAL*)hoveredLayer																																				//	Selection States
{
	if (hoveredLayer == _hoveredLayer) return;
	if (hoveredLayer) { 
		_hoveredLayer = hoveredLayer;
//		_hoveredLayer.hovered = YES;
		[_hoveredLayer setNeedsDisplay];
	}
	switch (hoverStyle) {
  	case DarkenOthers:
		self.shroudedLayers = nil;	 	self.shroudedLayers = hoveredLayer ? nil : @[_hoveredLayer]; break;
	case LassoStyle:
		_hoveredLayer ? [self lasso:_hoveredLayer dymamicStroke:.05] : [self deLasso];	 break;
	default:	  	
		NSLog(@"no hover style set");		break;
	}
}
- (void) setSelectedLayer:(CAL*)selectedLayer
{
	if ( selectedLayer == _selectedLayer ){
		_selectedLayer.selected = NO;
		selectedStyle 	 == LassoStyle 			? [self deLasso]	: selectedStyle == DarkenOthers 	? [self setShroudedLayers:nil]		 : nil;
		[_selectedLayer setNeedsDisplay];
		_selectedLayer = nil;
		return;
	}
	_selectedLayer.selected = NO;
	selectedStyle == LassoStyle			? [self deLasso]
: 	selectedStyle == DarkenOthers ? [self setShroudedLayers:nil]					 : nil;
	[_selectedLayer setNeedsDisplay];
	_selectedLayer = nil;
	_selectedLayer = selectedLayer;
	selectedLayer.selected = @YES;
	selectedStyle == DarkenOthers ? [self setShroudedLayers: @[_selectedLayer]]
:	selectedStyle == LassoStyle 			? [self lasso:_selectedLayer dymamicStroke:.05] : nil;
//:	selectedStyle == None 			? nil :nil;
//NSLog(@"no selection style: %@", AZString(selectedStyle)) : [self autoDescribe];

	[_selectedLayer setNeedsDisplay];
	[(NSO*)_delegate respondsToStringThenDo:@"scrollView:didSelectLayer:" withObject:self withObject:_selectedLayer];
//	CAL* l = _hoverStyle == LassoStyle ? [self lassoLayerWithFrame:_hoveredLayer.bounds dymamicStroke:.03] :
//	[_hoveredLayer addSublayer:];
}
- (void) setShroudedLayers:(NSA*)actuallyAllLayersExcept
{
	if (!actuallyAllLayersExcept) { [_shroudedLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
												return;
	}
	NSA* all = [self.allLayers arrayWithoutObject:actuallyAllLayersExcept[0]];
	_shroudedLayers = [all map:^id(CAL* obj) {  CAL* l = [CAL noHitLayerWithFrame:obj.bounds]; l.bgC = cgBLACK; l.opacity = .7; l.arMASK = CASIZEABLE; [obj addSublayer:l]; return l; }];
}
- (void) lasso:(CAL*)layer dymamicStroke:(CGF)percent
{
	[self deLasso];
	CGF dynamicStroke 	= AZMinDim(layer.size) * percent;
	CASHL *blk 			= [CASHL noHitLayerWithFrame:layer.bounds];
	CASHL *wht 			= [CASHL noHitLayerWithFrame:layer.bounds];
	CAL  *root 			= [CAL   noHitLayerWithFrame:layer.bounds];
	root.name			= @"lasso";
	root.sublayers		= @[wht, blk];
	root.zPosition 		= 1000;
	blk.fillColor		= wht.fillColor	= cgCLEARCOLOR;
	blk.lineWidth		= wht.lineWidth	= dynamicStroke;
	blk.lineJoin		= wht.lineJoin 	= kCALineJoinMiter;
	blk.strokeColor		= cgBLACK;			// [[[layer valueForKey:@"azfile"]valueForKey:@"color"]CGColor]];
	wht.strokeColor		= cgWHITE;

	blk.lineDashPattern	= @[ @(15), @(15) ];
	blk.path = wht.path	= [NSBP bezierPathWithRect:NSInsetRect( layer.bounds, dynamicStroke/2, dynamicStroke/2)].quartzPath;
	CABA *dashAnimation = [CABA animationWithKeyPath:@"lineDashPhase"];
	dashAnimation.fromValue		= @0;
	dashAnimation.toValue		= @30;
	dashAnimation.duration 		= .75;
	dashAnimation.repeatCount 	= 10000;
	[blk addAnimation:dashAnimation forKey:@"linePhase"];
	[layer addSublayer:root];
}
- (void) deLasso { 	[self.allLayers each:^(CAL*l){ [[l sublayerWithName:@"lasso"]removeImmediately]; }]; }


- (IBAction) toggleOreo:			 (id)sender { self.oreo = ((NSBUTT*)sender).state == NSOnState ? VRT : HRZ; }
- (IBAction) toggleOrientation:(id)sender;{
	self.oreo = HRZ ? VRT : HRZ;
}
- (BOOL) acceptsFirstResponder 	{ 	return YES;		}
- (BOOL) isVRT { return  self.isVRT; }
@end
