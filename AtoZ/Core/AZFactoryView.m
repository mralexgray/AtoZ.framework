#import "AtoZ.h"

#import "AZFactoryView.h"
#import "AtoZFunctions.h"

//JREnumDefine(AZOutlineCellStyle);

@implementation AZFactoryView 		{ NSA*palette_; NSTextField *matchField_; NSButton* rezhuzhButt_; NSView*UIView_; CAL *scrollBar_, *hostLayer_; } /* IVARS */

- (void) viewDidMoveToWindow 			{ [self.window setAcceptsMouseMovedEvents:YES]; } /* accept mousemoved events */

-   (id) initWithFrame:(NSR)fr
		        rootNode:(NSTreeNode*)n	{ 	if (!(self = [super initWithFrame:fr])) return (id)nil; _rootNode = n;

	self.layer 			 		= [CAL layerWithFrame:self.bounds];
//	[self.layer bind:@"sublayers" toObject:_rootNode  withKeyPath:@"mutableChildNodes"  withKeyPath transform:^id(NSMA* values) {
//
//		for ([[value vFKP:@"representedNode"] doesNotContainObject:])[AZOutlineLayer layerWithNode:_controller.pare inLayer:hostLayer_ withFrame:self.nodeRect]]; 			// nodes <- encapsulates all the OTHER nodes.
	self.wantsLayer		 	= YES;
	[self setupAppKitCrap];
  return self;
//	self.nodes.selectedNode = _controller.children[0]; return self;  // Jusr to start things off;
}
- (void) mouseMoved:  		(NSE*)e	{ static ReverseAnimationBlock colorSnap = NULL, pulseSnap = NULL;

	CAL* hit; if (!( hit = [[hostLayer_.presentationCALayer hitTest:e.locationInWindow]modelLayer])) return;

	if (!hit.hovered && SameString(NSStringFromClass(hit.class), @"ListLayerItem")) {
	
		if (colorSnap) colorSnap(); if (pulseSnap) pulseSnap();
		colorSnap 	= [hit.superlayer animateToColor:RANDOMCOLOR duration:5 withCallBack:YES];
		pulseSnap 	= [hit.superlayer pulse];
	}
}
- (void) mouseDown:  		(NSE*)e	{ // _nodes.selectedNode = nil;


//	if (SameString(NSStringFromClass([hit class]), @"ListLayerItem")) return [[hit superlayer]animateToColor:RANDOMCOLOR];
//	_nodes.selectedNode = [hit superlayer][@"node"];
	[CATransaction transactionWithLength:.6 actions:^{	// self.nodeRects;
	
/**	  __block CGR r; __block CAScrollLayer *scrlr; __block CAL* layer;

		[(NSA*)_controller.children eachWithIndex:^(AZNode*node, NSI idx) {		
			layer 			= 		[_nodes.sublayers objectWithValue:node forKey:@"node"]; 
			layer.frame		= r = [_nodes.nodeRects[idx]rectValue];  NSLog(@"resizing category idx: %ld : %@ r: %@", idx, node.key, NSStringFromRect(r));
			scrlr          =	 	[layer scanSubsForClass:CAScrollLayer.class];
			r.origin.y 		= 0;
			r.size.height 	= [node isEqualTo:_nodes.selectedNode] ? r.size.height - zKEYWORDS_V_UNIT : 0; //self.unitHeight : 0; 
			layer.frame 	= r;	//	[l.superlayer setNeedsDisplay];
		}];

	}];
		^{	NSLog(@"isanode: %@..  index..%@ of %@", _nodes.selectedNode.isaNode ? @"YES A NODE" : @"NoWAY NOT A NODE", @(_nodes.selectedNode.siblingIndex), @(_nodes.selectedNode.siblingIndexMax));
			NSLog(@"selected node:%@  %@ of %@", _nodes.selectedNode.key,@(_nodes.selectedNode.siblingIndex), @(_nodes.selectedNode.siblingIndexMax)); 
*/
	}];
}
- (void) scrollWheel:		(NSE*)e 	{ // [(CAScrollLayer*)[[_nodes.sublayers objectWithValue:_nodes.selectedNode forKey:@"node"] scanSubsForClass:CAScrollLayer.class] scrollBy:NSMakePoint(2*e.deltaX, 2* e.deltaY)];
}
-  (NSR) nodeRect 			{  return AZRectTrimmedOnTop(self.bounds, 100); }
- (void) setupAppKitCrap 	{

	NSRect upperRect, matchRect, buttRect, findRect, path1, path2;		
	upperRect   = AZUpperEdge(self.bounds, 100);
	matchRect 	= (NSRect) {  0, upperRect.size.height  -  25, 50, 25 }; 
	buttRect 	= (NSRect) {  0, upperRect.size.height  -  50, 50, 25 };
	findRect 	= (NSRect) { 60, upperRect.size.height  -  50, upperRect.size.width-70, 50 }; 
	path2			= (NSRect) {  0, upperRect.size.height  -  75, upperRect.size.width,    25 }; 
	path1			= (NSRect) {  0, upperRect.size.height  - 100, upperRect.size.width,    25 };
	
	self	 .postsBoundsChangedNotifications 	= self.postsFrameChangedNotifications = YES;
	self   .subviews = @[ UIView_ 				= [NSView       .alloc  initWithFrame:upperRect]];
	UIView_.subviews = @[ matchField_			= [NSTextField  .alloc 	initWithFrame:matchRect],
							    rezhuzhButt_			= [NSButton     .alloc 	initWithFrame:	buttRect],
								 _plistPathControl 	= [NSPathControl.alloc 	initWithFrame:		path2],
								 _headerPathControl 	= [NSPathControl.alloc 	initWithFrame:		path1],
								 _searchField 			= [NSSearchField.alloc 	initWithFrame:	findRect]];

/**	[_headerPathControl bind:@"backgroundColor" toObject:_controller withKeyPath:@"pList.outdated" transform:^id(id value){
		 return [value boolValue] ? NSColor.blueColor :[NSColor colorWithDeviceWhite:.2 alpha:.8];								}];
	[_plistPathControl bind:@"backgroundColor" toObject:_controller withKeyPath:@"pList.outdated" transform:^id(id  value){
		return [value boolValue] ? NSColor.orangeColor : [NSColor colorWithDeviceWhite:.6 alpha:.6];							   }];
	[_searchField		  setAction:@selector(search:)				 withTarget:_controller];
	[_headerPathControl setAction:@selector(setGeneratedHeader:) withTarget:_controller];
	[_plistPathControl  setAction:@selector(setPList:) 			 withTarget:_controller];
	[@[_searchField, _headerPathControl]					makeObjectsPerformSelector:@selector(setDelegate:) withObject:_controller];
*/
	[@[_plistPathControl.cell, _headerPathControl.cell]makeObjectsPerformSelector:@selector(setEditable:) withObject:			@YES];
	[_plistPathControl setFont:[NSFont fontWithName:@"UbuntuMono-Bold" size:14]];
	[_searchField.cell 											  setDrawsBackground:YES];
	[matchField_				 											   setEditable: NO];
	[_plistPathControl .cell setPlaceholderString: @"Plist Path"];
	[_headerPathControl.cell setPlaceholderString:@"Header Path"];
/**
	[matchField_ 			  bind:NSValueBinding toObject:_controller withKeyPath:@"root.allDescendants.@count" options:nil];
	[_plistPathControl  bind: @"URL" toObject:_controller withKeyPath:@"pList.URL"  			  options:@{@"NSContinuouslyUpdatesValue":@YES}];
	[_headerPathControl bind: @"URL" toObject:_controller withKeyPath:@"generatedHeader.URL" options:@{@"NSContinuouslyUpdatesValue":@YES}];
*/
	_plistPathControl	.pathStyle 			= _headerPathControl.pathStyle 			= NSPathStylePopUp;
	_plistPathControl	.autoresizingMask = _headerPathControl.autoresizingMask 	= NSViewWidthSizable | NSViewMinYMargin;
	_searchField		.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	UIView_				.autoresizingMask = NSViewMinYMargin 	| NSViewWidthSizable;
	matchField_			.autoresizingMask =
	rezhuzhButt_		.autoresizingMask	= NSViewMinYMargin;
	rezhuzhButt_ 	   .refusesFirstResponder = YES;
}				//	Setup AppKit crap.
@end

@implementation 		AZOutlineLayer

/*	[self bind:@"sublayers" toObject:self withKeyPath:@"representedNode"	transform:^id(id subs) {
+ (INST)  layerWithNode:AZNODEPRO node
					 inLayer:(CAL*)host
				  withFrame:(NSR)frame 		{	AZOutlineLayer *outline;
	[host addSublayer:outline = [AZOutlineLayer layerWithFrame:frame]];
//	outline.representedNode = node;
	outline.style =   @{	   @"borderColor" : (id)cgRANDOMCOLOR,
							  @"backgroundColor" : (id)PINK.CGColor,
							@"autoresizingMask"  : @(CASIZEABLE),
				@"needsDisplayOnBoundsChange" : @YES, 
								 @"masksToBounds" : @YES,
								 @"layoutManager" : outline,
								      @"delegate" : outline,
							       @"scrollMode" : kCAScrollVertically};
	[NSEVENTLOCALMASK:NSLeftMouseDownMask handler:^NSE*(NSE*e){
//		[self.nodeController addObject:AZNode.new];
		LOG_EXPR(outline.selectedNode);
		// = ((AZOutlineLayerNode*)[[outline.presentationCALayer hitTest:e.locationInWindow]modelLayer]).reprsentedNode;
//		LOG_EXPR(h.selected);	LOG_EXPR(self.sublayers);
//		IFKINDA(h, AZOutlineLayer, LOG_EXPR(((AZOutlineLayer*)h).rootNodes.count) );
		return e;
	}];
//	[outline setSublayers:[outline.representedNode.children cw_mapArray:^id(NSO<AtoZNodeProtocol>*x){ return [AZOutlineLayerNode layerForNode:x style:AZOutlineCellStyleToggleHeader];	}]];

	return outline;
}  / * designated */
-   (id) initWithLayer:		    (id)cal	{		return self = [super initWithLayer:cal] ?	// Copy custom property values between layers
	IFKINDA( cal, AZOL, [self setPropertiesWithDictionary:[cal dictionaryRepresentation]] ),	self : nil;
}

+ (BOOL) needsDisplayForKey: (NSS*)key	{
	return [@[@"frame", @"bounds", @"position", @"node"] containsObject:key] 
		 ?: [super needsDisplayForKey:key]; 
}

- IDCAA  actionForKey:		  (NSS*)key	{  NSLog(@"action for key: %@?", key);
	CABA *c = [CABasicAnimation animation];
	{ objswitch(key)
		objcase(kCAOnOrderIn) 	c.keyPath 	= @"opacity"; 
										c.duration 	= 2; 
									 	c.fromValue = @0; 
										c.toValue 	= @1; return c; 				
		objcase(@"_selected")   NSC* colore = RANDOMCOLOR; NSString *name = colore.name; [name log];
										CAA *coloreA = [CAA backgroundColorAnimationFrom:[self.presentationLayer backgroundNSColor] to:colore duration:2];
//										[coloreA setCompletion:^(CAA*a, BOOL finished) {
//											[CATRANNY immediately:^{
//											[self.modelLayer setBackgroundNSColor:colore];
											//}];
//											NSLog(@"completion for colore: %@",name);
//										}];
										[CAAnimationDelegate delegate:coloreA forLayer:self];
										return coloreA;
	endswitch
	}
	return [super actionForKey:key];
}
- (NSA*) nodeRects 							{	__block __unused NSR thisRect = (NSRect) { 0, 0, self.width, 0 };

	//vertical unit                 // if there is no selection it is evenly divided...  this is impossible, currently
//	CGF unit = //_nodes.selectedNode == nil 	? self.nodeRect.size.height / _controller.numberOfChildren.floatValue : zKEYWORDS_V_UNIT;
	
/**	return  [_representedNode.children nmap:^id(NSO<AtoZNodeProtocol>*node, NSUInteger idx){
	
		thisRect.origin.y += thisRect.size.height;
		thisRect.size.height = MAX( 0, idx != self.selectedNode.siblingIndex 	? zKEYWORDS_V_UNIT
																										: ^{
			NSUInteger leftOver 	= node.siblingIndexMax - self.selectedNode.siblingIndex - 1;
			CGFloat maxAfter 		= self.boundsHeight - thisRect.origin.y - (leftOver * zKEYWORDS_V_UNIT);
			return maxAfter; 
											}());
		//self.unitHeight; // this is the selected pane 
		//			bounds.size.height 	= self.nodeRect.size.height - leaveSpace - vOffset;
		//		thisRect.size.height;
		return AZVrect(thisRect);
	}];
  */
	return @[];

}
@end

EXTMixin			  (AZOutlineLayerNode, CAScrollLayer);
@implementation   AZOutlineLayerNode

//+ (instancetype) layerForNode:AZNODEPRO node style:(AZOutlineCellStyle)style{
//
//	AZOutlineLayerNode *nodeL = AZOutlineLayerNode.layer;
////	nodeL.reprsentedNode = node;
//	nodeL.style 		= @{  @"backgroundColor" : (id)GRAY5.CGColor, @"autoresizingMask" : @(CASIZEABLE),
//									  @"masksToBounds" : @YES,						    @"scrollMode" : kCAScrollVertically,
//																		   @"needsDisplayOnBoundsChange" : @YES };
//	nodeL.loM 			= nodeL; [nodeL  setNeedsLayout];
//	nodeL.delegate		= nodeL; [nodeL setNeedsDisplay];
//	nodeL.cellStyle 	= AZOutlineCellStyleToggleHeader;
//	return nodeL;
//}

- (void) setCellStyle:				(AZOutlineCellStyle)cellStyle 		{

	BOOL needsRezhuzh = _cellStyle != cellStyle;
			 _cellStyle = cellStyle;
	if (needsRezhuzh) [self removeSublayers];
	if (_cellStyle == AZOutlineCellStyleToggleHeader) {

		Class headerClass = objc_allocateClassPair(CAL.class, "ListHeader", 0);
		__unused CAL *tHost = [headerClass layer];
	}
	else if (_cellStyle == AZOutlineCellStyleScrollList) {
		
//		CAScrollLayer * scrl 	= CAScrollLayer.layer; 	scrl.needsDisplayOnBoundsChange	 = YES;	scrl.scrollMode = kCAScrollVertically;
		//	scrl.autoresizingMask 	= kCALayerWidthSizable| kCALayerHeightSizable;
/*		for (AZNode *keyword in _reprsentedNode.children) {  CATextLayer *kTxtL;
			[self addSublayer:kTxtL = CATextLayer.layer];
			Class listLayerItemClass = objc_allocateClassPair(CAL.class, "ListLayerItem", 0);
			CALayer *drawer;
			[kTxtL addSublayer:drawer = [listLayerItemClass layerWithFrame:kTxtL.bounds]];
			drawer.arMASK				= CASIZEABLE;//|kCALayerMaxYMargin|kCALayerMinYMargin;
			kTxtL.font					= (CFTypeRef)@"UbuntuMono-Bold";
			kTxtL.truncationMode    = kCATruncationMiddle;
			kTxtL.fontSize				= zKEYWORDS_FONTSIZE;
			kTxtL.string				= keyword.key;
			[CABD delegateFor:drawer ofType:CABlockTypeDrawBlock withBlock:^(CAL*dLay,CGContextRef r){
				[NSGraphicsContext drawInContext:r flipped:NO actions:^{
					[[RANDOMGRAY alpha:.7] set];
					NSRectFill(self.bounds);
				}];
			}];
		}
*/
//	[NSBP setDefaultLineWidth:4];	[NSBP strokeRect:self.bounds]; }];	NSRect r = self.bounds;	r.origin = dLay.boundsOrigin; r.size.height = zKEYWORDS_V_UNIT;	r.size.width = dLay.superlayer.superlayer.boundsWidth;[[NSBP bezierPathWithRect:r] strokeWithColor:BLACK andWidth:3 inside:r];NSLog(@"listelayeritemclass is: %@", NSStringFromClass(dLay.class)); // excessive logger

		
	}
//	[BlockDelegate delegateFor:scrl ofType:CABlockTypeLayoutBlock withBlock: ^(CALayer*layer){   // lays out each node, that we just made	
//	}];
/*
	list.frame  		= tHost.frame = zCATEGORY_RECT;
	list.anchorPoint  = (NSP){.5, 1};
	list.frameMinY 	= zCATEGORY_RECT.size.height;
	tHost.arMASK 		= kCALayerMaxYMargin|kCALayerWidthSizable;
	list.arMASK 		= kCALayerMinYMargin|kCALayerWidthSizable| kCALayerHeightSizable;
	tHost.needsDisplayOnBoundsChange = YES;
	static NSA* grads; grads = grads ?: RANDOMPAL;//[NSC gradientPalletteLooping:RANDOMPAL steps:_controller.numberOfChildren];
nl.backgroundColor = cgRANDOMCOLOR;// NSColor.redColor.CGColor;
[nl setValuesForKeysWithDictionary:@{@"node":n, @"list":list, @"title":tHost}];
nl.sublayers 			= @[tHost, list];
	return nl;
*/
}
- (void) drawLayer:					(CAL*)l inContext:(CGContextRef)x 	{ AZOutlineLayerNode*nL = (AZOutlineLayerNode*)l;

	if (nL.cellStyle == AZOutlineCellStyleToggleHeader) {
//	[BlockDelegate delegateFor:tHost ofType:CABlockTypeDrawBlock withBlock: ^(CALayer *l, CGContextRef x){ // draws category tiles
		[NSGraphicsContext drawInContext:x flipped:NO actions:^{
			NSRectFillWithColor(l.bounds,RANDOMCOLOR);//[grads normal:n.index.iV-1]); 
			NSLog(@"drawblock!! lbounds: %@", AZString(l.bounds));
			__unused NSMD* attrs = @{ 	NSFontSizeAttribute : @(zCATEGORY_FONTSIZE), NSForegroundColorAttributeName	: NSColor.whiteColor,
									NSFontAttributeName : [NSFont fontWithName:@"UbuntuMono-Bold" size:zCATEGORY_FONTSIZE]}.mutableCopy;
//			[[nL.reprsentedNode key] drawInRect:l.bounds withAttributes:attrs];
			__unused NSR badgeRect = (NSR){l.width - zCATEGORY_RECT.size.height, 0, l.height, l.height};
//			[[NSIMG badgeForRect:AZRectFromSize(badgeRect.size) 
//				withColor:RANDOMCOLOR stroked:BLACK withString:@(nL.reprsentedNode.siblingIndex).stringValue]	drawInRect:badgeRect];
		}];
	}
}
- (void) layoutSublayersOfLayer:	(CAL*)l 										{ AZOutlineLayerNode*nL = (AZOutlineLayerNode*)l;

	if ( nL.cellStyle == AZOutlineCellStyleScrollList) {
//		if (!_reprsentedNode.nodeState) return;
		NSRect			vis 		= nL.superlayer.bounds,		// 0 y is scrolled to bott;   // Lock scrolling to bounds
					  lineRect 		= (NSRect) { 10, 0, vis.size.width, zKEYWORDS_V_UNIT };
//		CGFloat maxPossible 		= zKEYWORDS_V_UNIT * nL.reprsentedNode.numberOfChildren,
//						 toobig 		= maxPossible - l.bounds.size.height;				//	NSLog(@"layout node: %@", node.properties);
//		[l scrollPoint: vis.origin.y < 0 ? NSZeroPoint
//								: vis.origin.y > toobig && maxPossible > vis.size.height ? (CGPoint){0,toobig + 10}
//								: vis.origin	];
		for (CALayer* sub in l.sublayers) {
			[sub setFrame:lineRect]; lineRect.origin.y += zKEYWORDS_V_UNIT;	
		}
	}

}
@end


CAGradientLayer* greyGradLayer() 	{	CAGradientLayer *gl = CAGradientLayer.layer;
	gl.colors 		= @[(id)[NSC white:.15 a:1].CGColor, (id)[NSC white:.19 a:1].CGColor,
							 (id)[NSC white:.20 a:1].CGColor, (id)[NSC white: .25 a:1].CGColor];
	gl.locations 	= @[@0,@.5, @.5, @1];  													return gl; 
}
//			NSInteger r = [cs allKeys].count, thisNodeIdx = [bSelf.controller.nodeChildren indexOfObject:node];
NSA				* RGBFlameArray(NSC*color, NSUI ct, CGF hueStepDeg, CGF satStepDeg, CGF briStepDeg, NSI align)	{

	CGFloat hue, saturation, brightness, alpha;
	[color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	NSUInteger midway						= align == 0 ? ct / 2 : ct;
	CGFloat hueStepDegrees 				= hueStepDeg / 360.0;
	CGFloat brightnessStepDegrees 	= briStepDeg / 100.0;
   CGFloat saturationStepDegrees 	= satStepDeg / 100.0;

	hue -= align == 1 ?  (hueStepDegrees * ((float) ct - 1.0)) : align == 0 ? (hueStepDegrees * (float) midway) : 0;

	if (hue < 0) hue += 1;	else if (hue > 1) hue -= 1;

	if (align== 1) {
		brightness -= (brightnessStepDegrees * (float) ct);
      saturation -= (saturationStepDegrees * (float) ct);
   }
	else if (align == 0) {
		brightness -= (brightnessStepDegrees * (float) midway);
      saturation -= (saturationStepDegrees * (float) midway);
   }

	brightness = brightness < 0 ? 0 : brightness > 1 ?  1 : brightness;
	saturation = saturation < 0 ? 0 : saturation > 1 ?  1 : saturation;
	
	int iterations;
	NSMutableArray * colors = NSMutableArray.new;

	for( iterations = 0; iterations < ct ; iterations++ ){
		[colors addObject:[NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha]];
		hue += hueStepDegrees;
		if(hue > 1) hue -= 1;

		if (align == -1 || (align == 0 && iterations >= midway)) {
			brightness -= brightnessStepDegrees;
         saturation -= saturationStepDegrees;
      }
		else if (align == 1 || (align == 0 && iterations < midway)) {
			brightness += brightnessStepDegrees;
         saturation += saturationStepDegrees;
      }
		brightness = brightness < 0 ? 0 : 1;
      saturation = saturation < 0 ? 0 : saturation > 1 ? 1 : saturation;

	}
	return colors;
}

/*
- (void) bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options
{
  if ([binding isEqualToString:@"observedObjects"]) {
    [observable addObserver:self forKeyPath:@"arrangedObjects" options:0 context:nil];
    [observable addObserver:self forKeyPath:@"arrangedObjects.name" options:0 context:nil];
  } else {
    [super bind:binding toObject:observable withKeyPath:keyPath options:options];
  }
}

	
	_catPal 						= [NSC gradientPalletteLooping:RANDOMPAL steps:_controller.numberOfChildren];//RGBFlameArray( BLUE, _controller.numberOfChildren, -1, -9, 10, 1);
	_nodes.sublayers 			= [ _controller.children map:^id(AZNode *n) { 
												return [self categoryLayerWith:n]; 
										}];
	[$(@"does it need displayonboundschange??  %@", StringFromBOOL(_nodes.needsDisplayOnBoundsChange)) log];

// NEWSECTION
	[CABD delegateFor:_nodes ofType:CABlockTypeLayoutBlock withBlock:^(CALayer*nodesDelegate){
		[CATransaction immediately:^{	
			[_nodes setFrame:self.nodeRect]; 
			NSLog(@"nodesdelegate set noderect: %@", AZString(self.nodeRect));
			[_controller.children each:^(AZNode *kid) {   [[_nodes.sublayers objectWithValue:kid forKey:@"node"]setFrame: [[self.nodeRects normal:kid.index.iV]rectValue]]; 
	}]; }]; }];

//NEWSECTION
- (CAL*) keywordListOf:		(AZN*)n 	{  	// Return a simple "category" table for a single set of a node shilds keypairs
	
	CAScrollLayer * scrl 	= CAScrollLayer.layer; 
	scrl.needsDisplayOnBoundsChange	 = YES;
	scrl.scrollMode 			= kCAScrollVertically;
//	scrl.autoresizingMask 	= kCALayerWidthSizable| kCALayerHeightSizable;
	for (AZNode *keyword in n.children) {  CATextLayer *kTxtL;
		[scrl addSublayer:kTxtL = CATextLayer.layer];
		
	   Class listLayerItemClass = objc_allocateClassPair(CAL.class, "ListLayerItem", 0);
		CALayer *drawer;
		[kTxtL addSublayer:drawer = [listLayerItemClass layerWithFrame:kTxtL.bounds]];
		drawer.arMASK				= CASIZEABLE;//|kCALayerMaxYMargin|kCALayerMinYMargin;
		kTxtL.font					= (CFTypeRef)@"UbuntuMono-Bold";
		kTxtL.truncationMode    = kCATruncationMiddle;
		kTxtL.fontSize				= zKEYWORDS_FONTSIZE;
		kTxtL.string				= keyword.key;
		[CABD delegateFor:drawer ofType:CABlockTypeDrawBlock withBlock:^(CAL*dLay,CGContextRef r){
			[NSGraphicsContext drawInContext:r flipped:NO actions:^{
//				[NSGraphicsContext state:^{
					[[RANDOMGRAY alpha:.7] set];
					NSRectFill(self.bounds);
//					[NSBP setDefaultLineWidth:4];
//					[NSBP strokeRect:self.bounds];
//				}];
				
//				NSRect r = self.bounds;
//				r.origin = dLay.boundsOrigin;
//				r.size.height = zKEYWORDS_V_UNIT;
////				r.size.width = dLay.superlayer.superlayer.boundsWidth;
//				[[NSBP bezierPathWithRect:r] strokeWithColor:BLACK andWidth:3 inside:r];
			}];
//			NSLog(@"listelayeritemclass is: %@", NSStringFromClass(dLay.class)); // excessive logger

		}];
		
	}
	[BlockDelegate delegateFor:scrl ofType:CABlockTypeLayoutBlock withBlock: ^(CALayer*layer){   // lays out each node, that we just made	
		NSRect 			vis 		= layer.visibleRect,  // 0 y is scrolled to bott;   // Lock scrolling to bounds
					  lineRect 		= (NSRect) { 10, 0, vis.size.width, zKEYWORDS_V_UNIT };
		CGFloat maxPossible 		= zKEYWORDS_V_UNIT * n.numberOfChildren.integerValue,
						 toobig 		= maxPossible - layer.bounds.size.height;				//	NSLog(@"layout node: %@", node.properties);
		[layer scrollPoint: vis.origin.y < 0 ? NSZeroPoint 
								: vis.origin.y > toobig && maxPossible > vis.size.height ? (CGPoint){0,toobig + 10} 
								: vis.origin	];
		for (CALayer* sub in layer.sublayers) {
			[sub setFrame:lineRect]; lineRect.origin.y += zKEYWORDS_V_UNIT;	
		}
	}];
	return scrl;
}	  	// Generate a list of keywords for each "category"
- (CAL*) categoryLayerWith:(AZN*)n	{
	
		CALayer *nl = CAL.new, *list = [self keywordListOf:n];  		//CAGradientLayer *nl = AZFactoryView.greyGradLayer; 
		Class headerClass = objc_allocateClassPair(CAL.class, "ListHeader", 0);
		CAL *tHost = [headerClass layer];
		nl.masksToBounds  = YES;
		list.frame  		= tHost.frame = zCATEGORY_RECT;
		list.anchorPoint  = (NSP){.5, 1};
		list.frameMinY 	= zCATEGORY_RECT.size.height;
		tHost.arMASK 		= kCALayerMaxYMargin|kCALayerWidthSizable;
		list.arMASK 		= kCALayerMinYMargin|kCALayerWidthSizable| kCALayerHeightSizable;
		tHost.needsDisplayOnBoundsChange = YES;
		static NSA* grads; grads = grads ?: RANDOMPAL;//[NSC gradientPalletteLooping:RANDOMPAL steps:_controller.numberOfChildren];
		[BlockDelegate delegateFor:tHost ofType:CABlockTypeDrawBlock withBlock: ^(CALayer *l, CGContextRef x){ // draws category tiles
			[NSGraphicsContext drawInContext:x flipped:NO actions:^{
				NSRectFillWithColor(l.bounds,[grads normal:n.index.iV-1]); 
				NSLog(@"drawblock!! lbounds: %@", AZString(l.bounds));
				NSMD* attrs = @{ 	NSFontSizeAttribute : @(zCATEGORY_FONTSIZE), NSForegroundColorAttributeName	: NSColor.whiteColor,
										NSFontAttributeName : [NSFont fontWithName:@"UbuntuMono-Bold" size:zCATEGORY_FONTSIZE]}.mutableCopy;
				[[n key] drawInRect:l.bounds withAttributes:attrs];
				NSR badgeRect = (NSR){l.boundsWidth - zCATEGORY_RECT.size.height, 0, l.boundsHeight, l.boundsHeight};
				[[NSIMG badgeForRect:AZRectFromSize(badgeRect.size) 
					withColor:RANDOMCOLOR stroked:BLACK withString:n.index.stringValue]
						drawInRect:badgeRect];
			}];
		}];
	nl.backgroundColor = cgRANDOMCOLOR;// NSColor.redColor.CGColor;
	[nl setValuesForKeysWithDictionary:@{@"node":n, @"list":list, @"title":tHost}];
	nl.sublayers 			= @[tHost, list];
	return nl;
}  	// Builds a node layer
		tHost.name = @"header";
		[tHost setValue:node forKey:@"node"];
		[tHost bind:@"frame" toObject:nl withKeyPath:@"bounds" options:nil];
		tHost.autoresizingMask = kCALayerWidthSizable|kCALayerHeightSizable;
		tHost.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
		tHost.backgroundColor = cgRANDOMCOLOR;
		tHost.backgroundColor   = [NSColor.redColor CGColor];

//	[BlockDelegate delegateFor:tHost ofType:CABlockTypeDrawBlock withBlock: ^(CALayer *l, CGContextRef x){ // draws category tiles
//	}];
//	NSLog(@"drawblock delegate???  %@, %@.", tHost, tHost.delegate);

//	nodesAreMovingUp = [_controller.nodeChildren indexOfObject:_nodes.selectedNode] > [_controller.nodeChildren indexOfObject:n];
//		static NSColorList *cs;  cs = cs ?: [NSColorList availableColorLists][9]; while (thisNodeIdx >= r) { thisNodeIdx -= r; } 
//		[[cs colorWithKey:[[cs allKeys]objectAtIndex:thisNodeIdx]]set];
//		[[NSColor colorWithCalibratedWhite:/(float)bSelf.controller.nodeChildren.count) alpha:1] set];
//		tHost.sublayers		= @[t = CATextLayer.layer];
//		t.fontSize 				= zCATEGORY_FONTSIZE;	// self.unitHeight * .8;
//		t.font 					= (__bridge CFStringRef) @"UbuntuMono-Bold";
//		t.autoresizingMask   =   kCALayerWidthSizable| kCALayerHeightSizable;// |kCALayerMinYMargin|kCALayerMaxYMargin;//
//		[t bind:@"string" toObject:nl withKeyPath:@"node.nodeKey" options:nil];
//		t.anchorPoint			= NSMakePoint(NSMidX(nl.bounds), 0);
//		t.bounds					= (NSRect){0,0,nl.bounds.size.width, zCATEGORY_FONTSIZE};
//		tHost.shadowOpacity 	= .9;
//		tHost.shadowColor		= NSColor.blackColor.CGColor;
//		tHost.shadowOffset	= NSMakeSize(0, 0);
//		tHost.shadowRadius	= 5;
//		tHost.masksToBounds 	= NO;
//		tHost.opacity			= .4;
//		tHost.shouldRasterize = YES;
//		tHost.backgroundColor = cgRANDOMCOLOR;//.CGColor;
//		[list overrideSelector:@selector(containsPoint:) withBlock:(__bridge void*)^BOOL(id _self, NSPoint p){ return NSBeep(), NO; }];

//		list.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
//		nl.layoutManager = [CAConstraintLayoutManager layoutManager];
//		[list addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY scale:1 offset: self.unitHeight]];
//		list.frame = nl.bounds;
//		[nl addSublayer:list];
//		[nl addSublayer:list = self.listLayerWithNodes(node.nodeChildren)];
//		nl.needsDisplayOnBoundsChange = YES;
//		t.autoresizingMask 	= kCALayerWidthSizable| kCALayerMaxYMargin;
//		nl.anchorPoint = (NSPoint){.5,0};// self.frame.size.width/2, 0};

//		if (obj == n && !([layer valueForKey:@"listLayer"])) { 
		
//			list.frame = layer.bounds;
//		}
//		NSLog(@"%@, %@\t\tFrame: %@",nodeLayer, [obj nodeKey], NSStringFromRect(bounds));
	
		
//		CABA *a = [CABA animationWithKeyPath:@"position"];
//		a.toValue 	= [NSValue valueWithPoint:(NSPoint){NSMidX(bounds), NSMidY(bounds)}];
//		a.fromValue = [nodeLayer valueForKey:@"position"];
//		[nodeLayer addAnimation:a forKey:nil];
//		nodeLayer.zPosition = -1000 * idx;
		
//		[list bind:NSValueBinding toObject:self withKeyPath:@"selectedNode" transform:^id(id value) { //sneaky bind to object and just animate there.
//		}];
//		bar.autoresizingMask = kCALayerMinXMargin;
//		scrollLayer.sublayerT[NSColor colorWithCalibratedRed:1.000 green:0.400 blue:0.800 alpha:1.000]er.frame = self.nodeRect;
//		[scrollLayer addSublayer:list = self.greyGradLayer()];
//		list.bounds = (NSRect){0,0, self.bounds.size.width, lineSize*array.count};
//		list.autoresizingMask  = kCALayerWidthSizable;//| kCALayerHeightSizable;
//			NSLog(@"inside layout delegate for :%@  subs: %ld", [[layer.superlayer valueForKey:@"node"]nodeKey], layer.sublayers.count);
//			layer.bounds = (NSRect){0,0, self.bounds.size.width, lineSize*array.count};
//			[layer setFrame:layer.superlayer.bounds];
//					CGFloat 	vUnit = layer.bounds.size.height/layer.sublayers.count;
//			NSRect unitRect 	= (NSRect){ 0,0, layer.bounds.size.width, vUnit};
//		return 	[key isEqualToString:@"opacity"] ? ^{ CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"]; animation.duration = 0.5f; return animation;
//		}(): [key isEqualToString:@"sublayers"] ?  (id<CAAction>)[NSNull null] : nil;
//	[NSNotificationCenter.defaultCenter addObserverForName:NSViewFrameDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
//	} bind:@"bounds" toObject:self withKeyPath:@"frame" transform:^id(id value) {	NSRect r = [note.object frame];	r.size.height -= 100;  [CATransaction immediately:^{ [_nodes setFrame:r];  [_nodes setNeedsDisplay]; }];	}];
//	[BlockDelegate delegateFor:l 		ofType:CABlockTypeLayerAction withBlock:^id<CAAction>(CALayer*l, NSString*k){ return (id<CAAction>)NSNull.null; }];
//	[BlockDelegate delegateFor:_nodes ofType:CABlockTypeLayerAction withBlock:^id<CAAction>(CALayer*l, NSString*k){	return (id<CAAction>)NSNull.null; }];
//		tHost.needsDisplayOnBoundsChange = YES;
//		[BlockDelegate delegateFor:tHost ofType:CABlockTypeLayerAction withBlock:^id<CAAction>(CALayer*l,NSString*k){
//			NSLog(@"actiondeleagte: layer:%@  key: %@ ", l, k);
//			CABasicAnimation *b = [CABasicAnimation animationWithKeyPath:@"frame"];
//			NSRect vRect 			 		= nl.bounds;
//					 vRect.origin.y 		= vRect.size.height - zKEYWORDS_V_UNIT;
//					 vRect.size.height 	= zKEYWORDS_V_UNIT;
//					 b.toValue =  [NSValue valueWithRect:vRect];
//			b.duration = 3;
//			return b;
//		}];
//		tHost.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
//		tHost.frame = nl.bounds;
//		[tHost bind:@"frame" 	toObject:nl withKeyPath:@"bounds" transform:^id(id value) { 
//			NSRect debug = tHost.frame;  
//			NSRect vRect 			 		= [value rectValue]; 
//					 vRect.origin.y 		= vRect.size.height - zKEYWORDS_V_UNIT;//bSelf.unitHeight; 
//					 vRect.size.height 	= zKEYWORDS_V_UNIT;//bSelf.unitHeight;  
//					 return NSLog(@"binding thost frame old: %@ new:(%@) to nl bounds..(%@)",NSStringFromRect(debug),NSStringFromRect(vRect),NSStringFromRect([value rectValue])), 
//					 			[tHost setNeedsLayout], [NSValue valueWithRect:vRect]; 
//		}];


- (void) drawLayer:(CALayer*)l inContext:(CGContextRef)x {
		NSLog(@"Inside drawblock.. %@", l.name);
		[NSGraphicsContext drawInContext:x flipped:NO actions:^{

		palette = palette (_controller.numberOfChildren.integerValue)'
//				[(NSColor*)self.palette[node.index.integerValue] set]; NSLog(@"DRAWING NODE: %@", node.properties);
			[NSColor.blackColor set];
			NSRectFill(l.bounds); NSLog(@"%@..%@", NSStringFromSelector(_cmd), NSStringFromRect(l.bounds));
		}];
}

+   (id) defaultValueForKey: (NSS*)key	{ 		NSLog(@"leyernode wants to know defaultfor key: %@", key); objswitch(key) 
	objcase(					     @"cellStyle") return @(AZOutlineCellStyleToggleHeader);
	objcase(				  @"backgroundColor") return (id)GRAY5.CGColor;
	objcase(	          @"autoresizingMask") return @(CASIZEABLE);
	objcase(	@"needsDisplayOnBoundsChange") return @YES; 
	objcase(					 @"masksToBounds") return @YES;
	objcase(					 @"layoutManager") return self;
	objcase(					      @"delegate") return self;
	objcase(				       @"scrollMode") return kCAScrollVertically;
	defaultcase 									 return [super defaultValueForKey:key];
	endswitch
}
				objcase(@"autoresizingMask") 										return @(CASIZEABLE);
	 [key isEqualToString:@"radius"] ? ^{
		CABA *c = [CABasicAnimation animationWithKeyPath:@"radius" andDuration:3];
		c.fromValue = self.permaPresentation[@"radius"];
		NSLog(@"%@", c.properties);
		return c;
		}()

@implementation AZOutlineLayerScrollableList : AZOutlineLayerNode
@end
//- (void) layoutSublayersOfLayer:(CAL*)layer {
//
//	[CATransaction immediately:^{	
//		[_nodeController.arrangedObjects each:^(AZNode *kid) {   
//			[self.sublayers objectWithValue:kid forKey:@"node"]setFrame:[[self.nodeRects normal:kid.index.iV]rectValue]]; 
//}
+   (id) defaultValueForKey: (NSS*)key	{ 		objswitch(key)

	objcase(					   @"borderColor",
							  @"backgroundColor") return (id)cgRANDOMCOLOR;
	objcase(	          @"autoresizingMask") return @(CASIZEABLE);
	objcase(	@"needsDisplayOnBoundsChange") return @YES; 
	objcase(					 @"masksToBounds") return @YES;
	objcase(					   @"borderWidth") return @5;
	objcase(					   @"debug") return @YES;
	defaultcase 									 return [super defaultValueForKey:key];
	endswitch
}*/
