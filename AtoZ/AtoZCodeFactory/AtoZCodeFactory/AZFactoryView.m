
#import "AZFactoryView.h"
static 	CALayer* _nodes = 	nil;

#define 	zCATEGORY_FONTSIZE 	20
#define 	zKEYWORDS_FONTSIZE  	14
#define 	zKEYWORDS_V_UNIT  	1.4 * zKEYWORDS_FONTSIZE

@implementation 			AZFactoryView { NSTextField *_matchCt; NSButton* _generateButt; NSView*_uiPanel; }

- (id) initWithFrame:(NSRect)f controller:(id)c { 		if (!(self = [super initWithFrame:f])) return nil;
					
//	self.postsBoundsChangedNotifications = self.postsFrameChangedNotifications = YES;
	_controller = c; // to communicate back with the main class
	
	^{																			
	NSRect upperRect, matchRect, buttRect, findRect, path1, path2;
	upperRect   = f;				  upperRect.origin.y  	 = f.size.height - 100;  
										  upperRect.size.height  = 100;
	_nodeRect 	= f;   			  _nodeRect.size.height -= 100;
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
	_searchField      .target		= _controller; 
	_searchField      .delegate	= _controller;
	_searchField      .action 	 	= @selector(search:);	
	_headerPathControl.action		= @selector(setGeneratedHeader:);
	_headerPathControl.target		= _controller;
	_plistPathControl .action		= @selector(setPList:);
	_plistPathControl .target		= _controller;
	_plistPathControl.font        = [NSFont fontWithName:@"UbuntuMono-Bold" size:14];
	_headerPathControl.delegate 	= _controller;
	[_matchCt 					 setEditable: 	 NO];
	[_plistPathControl .cell setEditable:  YES];
	[_headerPathControl.cell setEditable:  YES];
	[_plistPathControl .cell setPlaceholderString: @"Plist Path"];
	[_headerPathControl.cell setPlaceholderString:@"Header Path"];
	[_searchField.cell setDrawsBackground:YES];
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
}();	  													//	Setup AppKit crap.

	CALayer *l 					= CALayer.layer; 
	l.bounds 					= self.bounds;
	[CABlockDelegate delegateFor:l ofType:CABlockTypeLayerAction withBlock:^id<CAAction>(CALayer*l, NSString*e){ return (id<CAAction>)NSNull.null; }];
	l.sublayers 				= @[_nodes = self.class.greyGradLayer];
	_nodes.frame 				= self.nodeRect;
	_nodes.masksToBounds		= YES;
	_nodes.borderColor = cgRANDOMCOLOR; _nodes.borderWidth = 4;
	_nodes.autoresizingMask = kCALayerWidthSizable| kCALayerHeightSizable;
	[CABlockDelegate delegateFor:_nodes ofType:CABlockTypeLayerAction withBlock: ^id<CAAction>(CALayer*l, NSString*key) {
		return 		(id<CAAction>)[NSNull null];
		return [key isEqualToString:@"opacity"] ? ^{
			CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"]; animation.duration = 0.5f; return animation;
		}(): [key isEqualToString:@"sublayers"] ?  (id<CAAction>)[NSNull null] : nil;
	}];

//	[NSNotificationCenter.defaultCenter addObserverForName:NSViewFrameDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification *note) {
////			} bind:@"bounds" toObject:self withKeyPath:@"frame" transform:^id(id value) {
//		NSLog(@"ohh lala");
//		NSRect r = [note.object frame];	r.size.height -= 100;  [CATransaction immediately:^{ [_nodes setFrame:r];  [_nodes setNeedsDisplay]; }];
//	}];
	self.layer 					= l;	
	self.wantsLayer			= YES;	// Basic layer hierarchy.
	_nodeCatList   			= ^CALayer*(AZN*node) 	{  	// Return a simple "category" table for a single set of a node shilds keypairs

		CALayer 		  * bar;
		CAScrollLayer * scrl = CAScrollLayer.layer; 
		scrl.needsDisplayOnBoundsChange	 = YES;
		scrl.autoresizingMask = kCALayerWidthSizable| kCALayerHeightSizable;
		scrl.scrollMode 		= kCAScrollVertically;
		[scrl addSublayer:bar= CALayer.new];
		bar.cornerRadius 		= 6;
		bar.backgroundColor 	= NSColor.redColor.CGColor;
		bar.frame 				= (NSRect){_nodes.bounds.size.width - 20,0,20,40};
		
//		bar.autoresizingMask = kCALayerMinXMargin;
//		scrollLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
//		scrollLayer.layoutManager = self;
//		scrollLayer.sublayerT[NSColor colorWithCalibratedRed:1.000 green:0.400 blue:0.800 alpha:1.000]er.frame = self.nodeRect;
		
//		[scrollLayer addSublayer:list = self.greyGradLayer()];
//		list.bounds = (NSRect){0,0, self.bounds.size.width, lineSize*array.count};
//		list.autoresizingMask  = kCALayerWidthSizable;//| kCALayerHeightSizable;
//			NSLog(@"inside layout delegate for :%@  subs: %ld", [[layer.superlayer valueForKey:@"node"]nodeKey], layer.sublayers.count);
//			layer.bounds = (NSRect){0,0, self.bounds.size.width, lineSize*array.count};
//			[layer setFrame:layer.superlayer.bounds];
//					CGFloat 	vUnit = layer.bounds.size.height/layer.sublayers.count;
//			NSRect unitRect 	= (NSRect){ 0,0, layer.bounds.size.width, vUnit};
		for (AZNode *keyword in node.nodeChildren) {  CATextLayer *kTxtL;
			[scrl addSublayer:kTxtL = CATextLayer.layer];
			kTxtL.font					= (CFTypeRef)@"UbuntuMono-Bold";
			kTxtL.fontSize				= zKEYWORDS_FONTSIZE;
			kTxtL.string				= keyword.key;
			kTxtL.truncationMode    = kCATruncationMiddle;
		}
		//CABlockDelegate *layoutdelegate // lays out each node, that we just made	
		[CABlockDelegate delegateFor:scrl ofType:CABlockTypeLayoutBlock withBlock: ^(CALayer*layer){
			// Lock scrolling to bounds
			NSRect barRect,	v = layer.visibleRect,  // 0 y is scrolled to bott;
					     lineRect = (NSRect) { 10, 0, v.size.width, zKEYWORDS_V_UNIT };
			CGFloat maxPossible = zKEYWORDS_V_UNIT * node.nodeChildren.count,
							 toobig = maxPossible - layer.bounds.size.height;
//			NSLog(@"layout node: %@", node.properties);
			[layer scrollPoint: v.origin.y < 0 ? NSZeroPoint 
									: v.origin.y > toobig && maxPossible > v.size.height ? (CGPoint){0,toobig + 10} 
									: v.origin	];

			for (CALayer* sub in layer.sublayers) {
				if ([sub isEqualTo:bar]) {  NSLog(@"looking at you bar, %@", NSStringFromRect(bar.frame));
					barRect 				= (NSRect) { _nodes.bounds.size.width - 10, 0, 10, (v.size.height / maxPossible ) * v.size.height};
					barRect.origin.y 	=  MAX(0, (v.origin.y+ v.size.height/(maxPossible-v.size.height)));
					sub.frame 			= barRect;
//					NSLog(@"visible: %@", NSStringFromRect());// / (maxPossible - v.size.height)));//*maxPossible); 
//					CGFloat totes= array.count * lineSize;  sub.frame = (NSRect){self.bounds.size.width-bar.bounds.size.width,  
				} else {	[sub setFrame:lineRect]; lineRect.origin.y += zKEYWORDS_V_UNIT;	}
			}
		}];
//		scrl.layoutManager = layoutdelegate;
		return scrl;
	};	  	// Generate a list of keywords for each "category"
	__block AZFactoryView *bSelf = self;
	_makeNodeLayer = ^CALayer*(AZN*node)	{		
		
		CAGradientLayer *nl = AZFactoryView.greyGradLayer; CALayer *list, *tHost;
		[nl setValue:node forKey:@"node"];
		nl.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
		nl.sublayers 			= @[list = bSelf.nodeCatList(node), tHost = CALayer.layer];//self.greyGradLayer()];
		[nl setValue:list forKey:@"list"];
		static NSArray *cats = nil;
		if (!cats) {
//			NSInteger r = [cs allKeys].count, thisNodeIdx = [bSelf.controller.nodeChildren indexOfObject:node];
			cats = [AZFactoryView RGBFlameArray:[NSColor colorWithCalibratedRed:.100 green:.200 blue:.500 alpha:1.000] numberOfColorsInt:bSelf.controller.nodeChildren.count hueStepDegreesCGFloat:-1 saturationStepDegreesCGFloat:-9 brightnessStepDegreesCGFloat:10 alignmentInt:1];
		}
		// *categoryDrawer= CABlockDelegate.new;
		[CABlockDelegate delegateFor:tHost ofType:CABlockTypeDrawBlock withBlock: ^(CALayer *l, CGContextRef x){
			[NSGraphicsContext drawInContext:x flipped:NO actions:^{
				[(NSColor*)cats [[bSelf.controller.nodeChildren indexOfObject:node]]set];
				NSRectFill(l.bounds);
				[[node.nodeKey stringByAppendingFormat:@" - %@ of %@", node.index, node.of] drawInRect:l.bounds withAttributes:@{NSFontSizeAttribute:@(zCATEGORY_FONTSIZE),NSFontAttributeName:[NSFont fontWithName:@"UbuntuMono-Bold" size:zCATEGORY_FONTSIZE]}];
			}];
		}];
//		[tHost setValue:categoryDrawer forKey:@"delegateDrawer"];
//		tHost.delegate = categoryDrawer;
		tHost.needsDisplayOnBoundsChange = YES;
//		[tHost setNeedsDisplay];
		[tHost bind:@"frame" 	toObject:nl withKeyPath:@"bounds" transform:^id(id value) { NSLog(@"binding!");
			NSRect vRect 			 		= [value rectValue]; 
					 vRect.origin.y 		= vRect.size.height - bSelf.unitHeight; 
					 vRect.size.height 	= bSelf.unitHeight;  
					 return [tHost setNeedsLayout],
					 			[NSValue valueWithRect:vRect]; 
		}];
		return nl;
	};  	// Builds a node layer
	_findNodeLayer = ^CALayer*(AZN*node)	{ 		__block CALayer* l = nil;  
		return [_nodes.sublayers enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			if ([obj valueForKey:@"node"] != node) return; l = obj; *stop = YES;		}], l;
};   	// Method stored as block property.
	
	for (AZNode *n in _controller.nodeChildren) 		[_nodes addSublayer:self.makeNodeLayer(n)];
	self.selectedNode = [_controller.nodeChildren objectAtIndex:0];  // Jusr to start things off.					
	return self;
}

- (void) viewDidMoveToSuperview		{ NSLog(@"%@", [NSString stringWithUTF8String:__PRETTY_FUNCTION__]); 

	[self.layer.sublayers makeObjectsPerformSelector:@selector(setNeedsLayout)];
}
- (void) layoutNodes  					{	NSArray* rects = self.nodeRects;
	
	[CATransaction transactionWithLength:.6 actions:^{
		[_controller.nodeChildren enumerateObjectsUsingBlock:^(AZNode* node, NSUInteger idx, BOOL *stop) {
			
			CALayer* layer 	= self.findNodeLayer(node); CGRect r;
			layer.frame   = r = [rects[idx]rectValue]; NSLog(@"resizing category idx: %ld : %@ r: %@", idx, node.nodeKey, NSStringFromRect(r));
			CAScrollLayer *l  = [layer scanSubsForClass:CAScrollLayer.class];
			r.origin.y 			= 0;
			r.size.height 		= [node isEqualTo:_selectedNode] ? r.size.height - self.unitHeight : 0; 
			l.frame 				= r;
//			[l.superlayer setNeedsDisplay];
		}];
	}];

}
-    (NSA*) nodeRects 					{	__block NSMutableArray *rects = NSMA.new;	__block CGFloat vOffset = 0, leaveSpace;

	return [_controller.nodeChildren enumerateObjectsUsingBlock:^(AZNode* node, NSUInteger idx, BOOL *stop) {
		NSRect bounds 			 	= self.unitBounds;
				 bounds.origin.y 	= vOffset;
		if (idx != _selectedNode.index.integerValue) vOffset += self.unitHeight;
		else {
			leaveSpace 			 	= (node.of.integerValue - _selectedNode.index.integerValue - 1) * self.unitHeight; // this is the selected pane 
			bounds.size.height 	= self.nodeRect.size.height - leaveSpace - vOffset;
			vOffset 				  += bounds.size.height;
		}
		[rects addObject:[NSValue valueWithRect:bounds]];	
	}], _nodeRects = rects;
}
-    (void) setSelectedNode:(AZN*)n	{ 		_selectedNode 	= n; [self layoutNodes];	}
-    (void) mouseDown:  (NSEvent*)e	{ _selectedNode = nil;
	
	CALayer * l = [self.layer hitTest:e.locationInWindow];
	while (l != nil && !([l valueForKey:@"node"])) l = [l superlayer];
	if (l != self.layer) self.selectedNode = [l valueForKey:@"node"]; 
	NSLog(@"selected node:%@  %@ of %@", _selectedNode.key,_selectedNode.index, _selectedNode.of);
}
-    (void) scrollWheel:(NSEvent*)e { [(CAScrollLayer*)[_findNodeLayer(_selectedNode) scanSubsForClass:CAScrollLayer.class] scrollBy:NSMakePoint(2*e.deltaX, 2* e.deltaY)];}

- (CGFloat) unitHeight 					{ return  zCATEGORY_FONTSIZE; }
-  (NSRect) unitBounds 					{ return (NSRect){ 0, 0, self.bounds.size.width, self.unitHeight}; }

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
