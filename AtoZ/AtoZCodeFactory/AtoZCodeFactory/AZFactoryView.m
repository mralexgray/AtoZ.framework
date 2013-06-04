
#import "AZFactoryView.h"
static 	CALayer* _nodes = 	nil;

#define 	zCATEGORY_FONTSIZE 	20
#define 	zKEYWORDS_FONTSIZE  	14
#define 	zKEYWORDS_V_UNIT  	2 * zKEYWORDS_FONTSIZE
#define  zCATEGORY_RECT			(NSRect){ 0, 0, _nodes.bounds.size.width, zKEYWORDS_V_UNIT }

@implementation AZFactoryView 		{ NSTextField *_matchCt; NSButton* _generateButt; NSView*_uiPanel; CALayer*scrollBar; }

-      (id) initWithFrame:   (NSRect)frme 
               controller:       (id)ctlr	{ 		if (!(self = [super initWithFrame:frme])) return nil;	_controller = ctlr; 	// to communicate back with the main class

	CALayer *hostl 		= CALayer.layer;
	CALayer *layer			= CALayer.layer;
	hostl.frame				= self.bounds;
	self.layer 				= hostl;
	self.wantsLayer		= YES;																														// Basic layer hierarchy.
	layer.sublayers 		= @[_nodes = self.class.greyGradLayer];
	hostl.sublayers 		= @[layer];																													[self setupAppKitCrap];
	
	[CABD delegateFor:_nodes ofType:CABlockTypeLayoutBlock withBlock:^(CALayer*l){ [CATransaction immediately:^{
		[l setFrame:self.nodeRect]; NSA* a = self.nodeRects;
		[_controller.children enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(NSObject* obj, NSUInteger idx, BOOL *stop) {
				NSInteger i = obj.index.integerValue; [[self layerForNode:obj] setFrame:[a[i]rectValue]];
		}];
	}];
	}];
	_nodes.masksToBounds		= YES;
	_nodes.borderColor 		= cgRANDOMCOLOR; _nodes.borderWidth = 4;
	_nodes.autoresizingMask = kCALayerWidthSizable| kCALayerHeightSizable;
//	[CABlockDelegate delegateFor:l 		ofType:CABlockTypeLayerAction withBlock:^id<CAAction>(CALayer*l, NSString*k){ return (id<CAAction>)NSNull.null; }];
//	[CABlockDelegate delegateFor:_nodes ofType:CABlockTypeLayerAction withBlock:^id<CAAction>(CALayer*l, NSString*k){	return (id<CAAction>)NSNull.null; }];
	layer.autoresizingMask		= kCALayerWidthSizable | kCALayerHeightSizable;
	layer.frame						= hostl.bounds;
	for (AZNode *n in _controller.children) 		[_nodes addSublayer:[self categoryLayerWith:n]];
	return self.selectedNode = _controller.children[0], self;  // Jusr to start things off;
}
- (CALayer*) keywordListOf:	 (AZN*)node {  	// Return a simple "category" table for a single set of a node shilds keypairs
	CAScrollLayer * scrl 	= CAScrollLayer.layer; 
	scrl.needsDisplayOnBoundsChange	 = YES;
	scrl.scrollMode 			= kCAScrollVertically;
	scrl.autoresizingMask 	= kCALayerWidthSizable| kCALayerHeightSizable;
	for (AZNode *keyword in node.children) {  CATextLayer *kTxtL;
		[scrl addSublayer:kTxtL = CATextLayer.layer];
		kTxtL.font					= (CFTypeRef)@"UbuntuMono-Bold";
		kTxtL.truncationMode    = kCATruncationMiddle;
		kTxtL.fontSize				= zKEYWORDS_FONTSIZE;
		kTxtL.string				= keyword.key;
	}
	[CABlockDelegate delegateFor:scrl ofType:CABlockTypeLayoutBlock withBlock: ^(CALayer*layer){   // lays out each node, that we just made	
		NSRect 			vis 		= layer.visibleRect,  // 0 y is scrolled to bott;   // Lock scrolling to bounds
					  lineRect 		= (NSRect) { 10, 0, vis.size.width, zKEYWORDS_V_UNIT };
		CGFloat maxPossible 		= zKEYWORDS_V_UNIT * node.numberOfChildren.integerValue,
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
- (CALayer*) categoryLayerWith:(AZN*)node	{		
	
		CALayer *nl = CALayer.layer, *list = [self keywordListOf:node], *tHost = CALayer.layer;  		//CAGradientLayer *nl = AZFactoryView.greyGradLayer; 

//		nl.autoresizingMask 	= //tHost.autoresizingMask = 
//										kCALayerWidthSizable | kCALayerHeightSizable;
		nl.borderColor = cgRANDOMCOLOR;
		nl.borderWidth = 2;
//	tHost.frame = nl.bounds;
//	tHost.autoresizingMask = kCALayerWidthSizable| kCALayerHeightSizable;\
//	tHost.needsDisplayOnBoundsChange = YES;
//		self.postsBoundsChangedNotifications = YES;
//		[tHost bind:@"frame" toObjectsAndKeys:self withKeyPath:@"selectedNode" transform:^id(id cal) {
//			return [NSValue valueWithRect:zCATEGORY_RECT];
//		}];
		CABlockDelegate * n = [CABlockDelegate delegateFor:tHost ofType:CABlockTypeDrawBlock withBlock: ^(CALayer *l, CGContextRef x){ // draws category tiles
			[NSGraphicsContext drawInContext:x flipped:NO actions:^{
				[NSColor.redColor set];
				NSRectFill(l.bounds);
			NSObject* node = [l valueForKey:@"node"];
			[[[node key] stringByAppendingFormat:@" - %@ of %@", @([node.index integerValue]+1), [node of]] drawInRect:l.bounds 
			withAttributes:@{	NSFontSizeAttribute					: @(zCATEGORY_FONTSIZE), 
									NSForegroundColorAttributeName	: NSColor.whiteColor,
									NSFontAttributeName					: [NSFont fontWithName:@"UbuntuMono-Bold" size:zCATEGORY_FONTSIZE]}];
			}];
		}];

		tHost.name = @"header";
		[tHost setValue:node forKey:@"node"];
//		[tHost bind:@"frame" toObject:nl withKeyPath:@"bounds" options:nil];
//		tHost.autoresizingMask = kCALayerWidthSizable|kCALayerHeightSizable;
//		tHost.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
//		tHost.backgroundColor = cgRANDOMCOLOR;
//		tHost.backgroundColor   = [NSColor.redColor CGColor];

	nl.backgroundColor = cgRANDOMCOLOR;// NSColor.redColor.CGColor;
	[nl setValuesForKeysWithDictionary:@{@"node":node, @"list":list, @"title":tHost}];
//	[CABlockDelegate delegateFor:tHost ofType:CABlockTypeDrawBlock withBlock: ^(CALayer *l, CGContextRef x){ // draws category tiles
//	}];
//	NSLog(@"drawblock delegate???  %@, %@.", tHost, tHost.delegate);
	nl.sublayers 			= @[tHost, list];
	return nl;
}  	// Builds a node layer
- (void) drawLayer:(CALayer*)l inContext:(CGContextRef)x {

		NSLog(@"Inside drawblock.. %@", l.name);
		[NSGraphicsContext drawInContext:x flipped:NO actions:^{
//				[(NSColor*)self.palette[node.index.integerValue] set]; NSLog(@"DRAWING NODE: %@", node.properties);
			[NSColor.blackColor set];
			NSRectFill(l.bounds); NSLog(@"%@..%@", NSStringFromSelector(_cmd), NSStringFromRect(l.bounds));
		}];
}
//		tHost.needsDisplayOnBoundsChange = YES;
//		[CABlockDelegate delegateFor:tHost ofType:CABlockTypeLayerAction withBlock:^id<CAAction>(CALayer*l,NSString*k){
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
- (CALayer*) layerForNode:			(id)node {
	__block CALayer* l = nil;  
	return [_nodes.sublayers enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if ([obj valueForKey:@"node"] != node) return; l = obj; *stop = YES;		}], l;
}   	// Method stored as block property.

-    (void) setupAppKitCrap 			{
	NSRect upperRect, matchRect, buttRect, findRect, path1, path2;				//	self.postsBoundsChangedNotifications = self.postsFrameChangedNotifications = YES;
	upperRect   = self.nodeRect; upperRect.origin.y  	 = upperRect.size.height;
										  upperRect.size.height  = 100; 
	matchRect 	= (NSRect) {  0, upperRect.size.height  -  25, 50, 25 }; 
	buttRect 	= (NSRect) {  0, upperRect.size.height  -  50, 50, 25 };
	findRect 	= (NSRect) { 60, upperRect.size.height  -  50, upperRect.size.width-70, 50 }; 
	path2			= (NSRect) {  0, upperRect.size.height  -  75, upperRect.size.width,    25 }; 
	path1			= (NSRect) {  0, upperRect.size.height  - 100, upperRect.size.width,    25 };
	
	self    .subviews = @[  _uiPanel 				= [NSView       .alloc  initWithFrame:upperRect]];
	_uiPanel.subviews = @[	_matchCt 				= [NSTextField  .alloc 	initWithFrame:matchRect], 
									_generateButt 			= [NSButton     .alloc 	initWithFrame:	buttRect], 
									_plistPathControl 	= [NSPathControl.alloc 	initWithFrame:		path2],
									_headerPathControl 	= [NSPathControl.alloc 	initWithFrame:		path1],
									_searchField 			= [NSSearchField.alloc 	initWithFrame:	findRect]];

	[_headerPathControl bind:@"backgroundColor" toObject:_controller withKeyPath:@"pList.outdated" transform:^id(id value) {
		 return [value boolValue] ? NSColor.blueColor :[NSColor colorWithDeviceWhite:.2 alpha:.8];																		}];
	[_plistPathControl bind:@"backgroundColor" toObject:_controller withKeyPath:@"pList.outdated" transform:^id(id value) {
		return [value boolValue] ? NSColor.orangeColor : [NSColor colorWithDeviceWhite:.6 alpha:.6];																		}];
	_searchField      .action 	 	= @selector(search:);	
	_headerPathControl.action		= @selector(setGeneratedHeader:);
	_plistPathControl .action		= @selector(setPList:);
	_searchField      .delegate	= _controller;
	_headerPathControl.delegate 	= _controller;
	_searchField      .target		= _controller; 
	_headerPathControl.target		= _controller;
	_plistPathControl .target		= _controller;
	_plistPathControl.font        = [NSFont fontWithName:@"UbuntuMono-Bold" size:14];
	[_searchField.cell setDrawsBackground:YES];
	[_matchCt 					 setEditable: 	 NO];
	[_plistPathControl .cell setEditable:  YES];
	[_headerPathControl.cell setEditable:  YES];
	[_plistPathControl .cell setPlaceholderString: @"Plist Path"];
	[_headerPathControl.cell setPlaceholderString:@"Header Path"];
	[_matchCt 			  bind:NSValueBinding toObject:_controller withKeyPath:@"root.allDescendants.@count" options:nil];
	[_plistPathControl  bind: @"URL"   		 toObject:_controller withKeyPath:@"pList.URL"          	options:@{@"NSContinuouslyUpdatesValue":@YES}];
	[_headerPathControl bind: @"URL"        toObject:_controller withKeyPath:@"generatedHeader.URL" options:@{@"NSContinuouslyUpdatesValue":@YES}];
	_plistPathControl	.pathStyle 			= _headerPathControl.pathStyle 			= NSPathStylePopUp;
	_plistPathControl	.autoresizingMask = _headerPathControl.autoresizingMask 	= NSViewWidthSizable | NSViewMinYMargin;
	_searchField		.autoresizingMask = NSViewWidthSizable | NSViewMinYMargin;
	_uiPanel				.autoresizingMask = NSViewMinYMargin 	| NSViewWidthSizable;
	_matchCt				.autoresizingMask = NSViewMinYMargin;
	_generateButt		.autoresizingMask	= NSViewMinYMargin; 
	_generateButt     .refusesFirstResponder = YES;
}//	Setup AppKit crap.
-    (void) viewDidMoveToSuperview	{ NSLog(@"%@", [NSString stringWithUTF8String:__PRETTY_FUNCTION__]); 

//	[self.layer.sublayers makeObjectsPerformSelector:@selector(setNeedsLayout)];
}
-    (void) layoutNodes  				{	NSArray* rects = self.nodeRects;
	
	[CATransaction transactionWithLength:.6 actions:^{	[_controller.children enumerateObjectsUsingBlock:^(AZNode* node, NSUInteger idx, BOOL *stop) {
			
			CALayer* layer 	= [self layerForNode:node]; CGRect r;
			layer.frame   = r = [rects[idx]rectValue]; 			NSLog(@"resizing category idx: %ld : %@ r: %@", idx, node.key, NSStringFromRect(r));
			CAScrollLayer *l  = [layer scanSubsForClass:CAScrollLayer.class];
			r.origin.y 			= 0;
			r.size.height 		= [node isEqualTo:_selectedNode] ? r.size.height - zKEYWORDS_V_UNIT : 0; //self.unitHeight : 0; 
			l.frame 				= r;	//	[l.superlayer setNeedsDisplay];
		}];
	}];

}
-  (NSRect) nodeRect 					{  NSRect r = self.bounds;  r.size.height -= 100;  return _nodeRect = r; }
-    (NSA*) nodeRects 					{	__block NSMutableArray *rects = NSMA.new;	__block CGFloat vOffset = 0,

	unit = (_selectedNode == nil) ? (self.nodeRect.size.height / _controller.numberOfChildren.floatValue) : zKEYWORDS_V_UNIT;
	return [_controller.children enumerateObjectsUsingBlock:^(AZNode* node, NSUInteger idx, BOOL *stop) {
		NSRect thisRect =  (NSRect){0, vOffset, _nodes.bounds.size.width, 0};
		thisRect.size.height = MAX( idx != _selectedNode.index.integerValue ? unit : ^{
			NSUInteger leftOver = node.of.integerValue - _selectedNode.index.integerValue-1;
			CGFloat maxAfter = _nodes.bounds.size.height - vOffset - (leftOver * zKEYWORDS_V_UNIT);
			return maxAfter; }(), 0);
			vOffset += thisRect.size.height;
	//self.unitHeight; // this is the selected pane 
//			bounds.size.height 	= self.nodeRect.size.height - leaveSpace - vOffset;
//		thisRect.size.height;
		[rects addObject:[NSValue valueWithRect:thisRect]];
	}], _nodeRects = rects;
}
-    (void) setSelectedNode:(AZN*)n	{ 		_selectedNode 	= n; [self layoutNodes];	}

-    (void) mouseDown:  (NSEvent*)e	{ _selectedNode = nil;
	
	CALayer * l = [self.layer hitTest:e.locationInWindow];
	while (l != nil && !([l valueForKey:@"node"])) l = [l superlayer];
	if (l != self.layer) self.selectedNode = [l valueForKey:@"node"];   NSLog(@"isanode: %@..  index..%@ of %@", _selectedNode.isaNode ? @"YES A NODE" : @"NoWAY NOT A NODE", _selectedNode.index, _selectedNode.of);
	NSLog(@"selected node:%@  %@ of %@", _selectedNode.key,_selectedNode.index, _selectedNode.of);
}
-    (void) scrollWheel:(NSEvent*)e { [(CAScrollLayer*)[[self layerForNode:_selectedNode] scanSubsForClass:CAScrollLayer.class] scrollBy:NSMakePoint(2*e.deltaX, 2* e.deltaY)];}

-    (NSA*) palette 						{ static NSArray *cats = nil;  return cats = cats ?: 

	[self.class RGBFlameArray:[NSColor colorWithCalibratedRed:.100 green:.200 blue:.500 alpha:1.000] numberOfColorsInt:_controller.numberOfChildren.integerValue hueStepDegreesCGFloat:-1 saturationStepDegreesCGFloat:-9 brightnessStepDegreesCGFloat:10 alignmentInt:1];
//			NSInteger r = [cs allKeys].count, thisNodeIdx = [bSelf.controller.nodeChildren indexOfObject:node];
}
+ (CAGradientLayer*) greyGradLayer 																			{
		CAGradientLayer *gl = CAGradientLayer.layer;
			gl.colors = @[(id)WHITE(.15,1).CGColor,(id)WHITE(.19,1).CGColor,(id)WHITE(.20,1).CGColor,(id)WHITE(.25,1).CGColor];
			gl.locations = @[@0,@.5, @.5, @1];  return gl; 
}
+         (NSArray*) RGBFlameArray:(NSColor*)c           numberOfColorsInt:(NSUInteger)n 
				 hueStepDegreesCGFloat:(CGFloat)d saturationStepDegreesCGFloat:(CGFloat)s 
		brightnessStepDegreesCGFloat:(CGFloat)b                 alignmentInt:(NSInteger)a	{
	CGFloat hue, saturation, brightness, alpha;
	[c getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

	NSUInteger midway						= a == 0 ? n / 2 : n;
	CGFloat hueStepDegrees 				= d / 360.0;
	CGFloat brightnessStepDegrees 	= b / 100.0;
   CGFloat saturationStepDegrees 	= s / 100.0;

	hue -= a == 1 ?  (hueStepDegrees * ((float) n - 1.0)) : a == 0 ? (hueStepDegrees * (float) midway) : 0;

	if (hue < 0) hue += 1;	else if (hue > 1) hue -= 1;

	if (a== 1) {
		brightness -= (brightnessStepDegrees * (float) n);
      saturation -= (saturationStepDegrees * (float) n);
   }
	else if (a == 0) {
		brightness -= (brightnessStepDegrees * (float) midway);
      saturation -= (saturationStepDegrees * (float) midway);
   }

	brightness = brightness < 0 ? 0 : brightness > 1 ?  1 : brightness;
	saturation = saturation < 0 ? 0 : saturation > 1 ?  1 : saturation;
	
	int iterations;
	NSMutableArray * colors = NSMutableArray.new;

	for( iterations = 0; iterations < n ; iterations++ ){
		[colors addObject:[NSColor colorWithCalibratedHue:hue saturation:saturation brightness:brightness alpha:alpha]];

		hue += hueStepDegrees;
		if(hue > 1) hue -= 1;

		if (a == -1 || (a == 0 && iterations >= midway)) {
			brightness -= brightnessStepDegrees;
         saturation -= saturationStepDegrees;
      }
		else if (a == 1 || (a == 0 && iterations < midway)) {
			brightness += brightnessStepDegrees;
         saturation += saturationStepDegrees;
      }
		brightness = brightness < 0 ? 0 : 1;
      saturation = saturation < 0 ? 0 : saturation > 1 ? 1 : saturation;

	}
	return colors;
}

@end

//	nodesAreMovingUp = [_controller.nodeChildren indexOfObject:_selectedNode] > [_controller.nodeChildren indexOfObject:n];
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
