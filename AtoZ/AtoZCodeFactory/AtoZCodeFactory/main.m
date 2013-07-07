
//#import <AtoZNodeProtocol.h>								/** AtoZCodeFactory *//* main.m */
#import <AppKit/NSAttributedString.h>
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>

//#import "AZFactoryView.h"
//#import "DefinitionController.h"
#import <AtoZ/AtoZ.h>

int main(int argc, const char * argv[])		{	@autoreleasepool {

	__block DefinitionController *v 	= DefinitionController.new; 

	void (^setUpApp)(void) = ^{
		[NSApplication sharedApplication];	
		id appMenu, menuBar, appMenuItem, quitString;
		[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
		[NSApp setMainMenu:  menuBar    =	  NSMenu.new];
		[menuBar addItem:appMenuItem 	  = NSMenuItem.new];
		[appMenuItem setSubmenu:appMenu =     NSMenu.new];
		quitString = [@"Quit "stringByAppendingString:NSProcessInfo.processInfo.processName];
		[appMenu addItem:[NSMenuItem.alloc initWithTitle:quitString action:@selector(terminate:) keyEquivalent:@"q"]];
		[NSApp setDelegate:v];
	};
	if (PINFO.arguments.count > 1) {
		[v saveKeyPairsWithSeperator:nil toFile:@"/Users/localadmin/.st2_multiple_find_replace_alt"];
	}
	else {
		setUpApp();
		if ([v generatedHeader].outdated) [v saveGeneratedHeader];
		playTrumpet();
		[NSApp run];
	}
//	else [v hasFileChanged] ? [v setHeaderOutdated:YES] :nil;

}
	return 0;
}


/*-   (void) addItem:(id)x	{	AZNode *item; 	[item.children addObject: item = [_view.nodeView itemAtRow:_view.nodeView.selectedRow] ?: self.root];
																							[_view.nodeView reloadItem:item reloadChildren:YES];
}

	for (AZNode *n in _controller.nodeChildren) { 
		NSPoint inV = [self convertPoint:theEvent.locationInWindow fromView:nil];
		self.selectedSelction = NSPointInRect(inV,  [objc_getAssociatedObject(n, (__bridge const void*)@"rect") rectValue]) ? n : _selectedSelction;
	}
	if (_selectedSelction) NSLog(@"found selection: %@", _selectedSelction), [self setAnimating:YES];

- (void) layoutSublayersOfLayer:(CALayer *)layer {	if (layer != self.layer) return;	NSLog(@"laying out layers! ct: %ld", layer.sublayers.count);	}	
- (void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {


   [NSGraphicsContext saveGraphicsState];
	[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO]];
		NSColor *c = [NSColor colorWithCalibratedRed:(float)random()/RAND_MAX green:(float) random()/RAND_MAX blue:(float) random()/RAND_MAX alpha:1.0f];
		[c set];
		NSRectFill(layer.bounds);
		AZNode* m;    
	 	if ((m = [layer valueForKey:@"node"]) && !([[layer valueForKey:@"isAnimating"]boolValue])) {
			[[NSAttributedString.alloc initWithString:[m nodeKey] attributes:@{NSFontAttributeName:[NSFont fontWithName:@"UbuntuMono-Bold" size:18.0f], NSForegroundColorAttributeName:NSColor.whiteColor}] drawInRect:(NSRect){5,5, layer.bounds.size.width, 30}];
		}
	[NSGraphicsContext restoreGraphicsState];
}

@interface AZExpandingOutlineView : NSOutlineView 
@end
@implementation AZExpandingOutlineView
//- (void) viewDidMoveToSuperview {	[self.enclosingScrollView.documentView}
@end


//-  			(BOOL) outlineView:(NSOV*)v shouldExpandItem:			  (id)x  {  return  ([((AZNode*)x).children count]);}//expanded boolValue] ?: x == _root; }
//	if (![_searchField.stringValue isEqualToString:@""]) return  YES;	NSString *key = [(AZNode*)x key]; NSUserDefaults *d = NSUserDefaults.standardUserDefaults;
//	return  [d objectForKey:key]  ? [d boolForKey:key] : YES; 

//		 [NSString stringWithFormat:@"%@/../Include/%@",srcRoot, @"AZGenerated.h"]

+         (NSSet*) keyPathsForValuesAffectingExpansions					{	return [NSSet setWithArray:@[@"plistPath"]]; }
+         (NSSet*) keyPathsForValuesAffectingGeneratedHeader 			{	return [NSSet setWithArray:@[@"root"]]; }


@implementation AZNode 
- (NSMutableArray*)children	{ return _children = _children ?: NSMutableArray.new; }	
- (NSMutableArray*)children	{ return _children = _children ?: NSMutableArray.new; }	
- (NSMutableArray*)children	{ return _children = _children ?: NSMutableArray.new; }	
- (NSMutableArray*)children	{ return _children = _children ?: NSMutableArray.new; }	
- (void) forwardInvocation:(NSInvocation*)inv 		{  // FIERCE
// Forward the message to the surrogate object if the surrogate object understands the message, otherwise just pass the invocation up the inheritance chain, eventually hitting the default -forwardInvocation: which will throw an unknown selector exception.
	SEL sel = inv.selector; NSMethodSignature *sig;
	if ((sig = [self methodSignatureForSelector:sel]))  [inv invokeWithTarget:self];
	else if ( class_conformsToProtococol(self.class, @protocol(AtoZNodeProtocol)) )  
		if ([inv selector] == @"children")
	
	[self methodSignatureForSelector:sel] 					?
		[invocation invokeWithTarget:self.allObjects] 	: 	
	[@{} methodSignatureForSelector:sel]					?
		[invocation invokeWithTarget:(NSD*)self]			:
	[super forwardInvocation:invocation];
//
//
//	self.defaultCollection && [self.defaultCollection respondsToSelector:[invocation selector]]
//									?				   [invocation invokeWithTarget:self.defaultCollection]:nil;
//									:										 [super forwardInvocation:invocation];
}
- (SIG*) methodSignatureForSelector:(SEL)sel			{
	// To build up the invocation passed to -forwardInvocation properly, the object must provide the types for parameters and return values for the NSInvocation through -methodSignatureForSelector:

 return 	[self methodSignatureForSelector:sel] 
 ?:		[@[] methodSignatureForSelector:sel] 
 ?: 		[@{} methodSignatureForSelector:sel] 
 ?: 		nil;
//    return [self respondsToSelector:sel]  resolveInstanceMethod:selector] || [NSDictionary resolveInstanceMethod:selector];
//    return [super methodSignatureForSelector:sel] ?: [self.defaultCollection methodSignatureForSelector:sel];
}
- (BOOL) respondsToSelector:(SEL)selector 				{
	// Claim to respond to any selector that our surrogate object also responds to.
    return ([self methodSignatureForSelector:selector]) 
	 || 		[NSA resolveInstanceMethod:selector] 
	 || 		[NSD resolveInstanceMethod:selector] 
	 || 		[super  respondsToSelector:selector];
//	 [super respondsToSelector:selector] || [self.defaultCollection respondsToSelector:selector];
}	* // * All methods above are fierce Posing classes  * /

+ (BOOL) resolveInstanceMethod:(SEL)sel {  
@end
typedef void(^allRootsBlock)(AZNode*);
typedef void(^allReplacementsBlock)(AZNode*);
typedef void(^allKeysBlock)(AZNode*);

@property (readonly) allKeysBlock keyEnumeratorBlock;
@property (readonly) allRootsBlock rootEnumeratorBlock;
@property (readonly) allReplacementsBlock replacementsyEnumeratorBlock;
- 		  (NSArray*) allKeywords 						{ return NSArray.new;
	[self.expansions.allValues enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
		[obj  enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {	[keys addObject:key]; }];	}], keys;
}
- 		  (NSArray*) allReplacements 					{  					NSMutableArray *values = NSMutableArray.new; return 
	[self.expansions.allValues enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
		[obj enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {	[values addObject:obj]; }];	}], values;
}
- (NSURL*) plistURL {  return [NSURL URLWithString:NSProcessInfo.processInfo.environment[@"PLIST_FILE"]  ?: @"/Volumes/2T/ServiceData/AtoZ.framework/AtoZMacroDefines.plist"]; }
- (NSURL*) generatedHeaderURL { NSString * outPath = NSProcessInfo.processInfo.environment[@"INCLUDE_OUT"];

	if (outPath && ![[outPath pathExtension] isEqualToString:@"plist"]) outPath = [outPath stringByAppendingPathComponent:@"AtoZMacroDefines.h"];
	if (!outPath) outPath = @"/Volumes/2T/ServiceData/AtoZ.framework/AtoZMacroDefines.h";
	return  [NSURL URLWithString:outPath];
}


	l.delegate = self;	[self addSubview:	_sv = [NSScrollView.alloc initWithFrame:outlineRect]];	_sv.documentView = _nodeView = [NSOutlineView.alloc initWithFrame:outlineRect]; 	_sv.hasVerticalScroller = YES;	_nodeView.usesAlternatingRowBackgroundColors = YES;	_nodeView.gridStyleMask 		= NSTableViewSolidVerticalGridLineMask | NSTableViewSolidHorizontalGridLineMask;	_nodeView.gridColor = NSColor.lightGrayColor; 	_sv.autoresizingMask 			= NSViewWidthSizable | NSViewHeightSizable; 	_nodeView.selectionHighlightStyle = 1; 	key	= [NSTableColumn.alloc initWithIdentifier:  @"key"];	value = [NSTableColumn.alloc initWithIdentifier:@"value"];	[key.headerCell 	setStringValue :@"Keys"];	[value.headerCell setStringValue:@"Values"];	value.width = key.width = 130;	[_nodeView addTableColumn:  key];	[_nodeView addTableColumn:value];/	_nodeView.outlineTableColumn = key;	_nodeView.dataSource = _controller;	_nodeView.delegate = _controller;	[l setNeedsDisplay];	[l setLayoutManager:self];	[l setNeedsLayout];


- (BOOL) outlineView:(NSOV*)v 				 			 		   isGroupItem:(id)x { 

	NSLog(@"Is group?  Item:%@  Class:%@", x, NSStringFromClass([x class]));
	if ([x implementsProtocol:@protocol(AtoZNodeProtocol)])
		return [(AZNODEPRO x) nodeChildren] == nil; 
	else return NO;
		// if value is nil, it must be a key, aka a root 
}
- (BOOL) outlineView:(NSOV*)v 		                   isItemExpandable:(id)x	{ 

	NSLog(@"is item: %@ expandable?  (class: %@", x, NSStringFromClass([x class]));
	return !x ?: [(AZNODEPRO x) nodeChildren].count;	// root items (nil) exp., also if there are childrenseses 
}
-  (NSI) outlineView:(NSOV*)v                    numberOfChildrenOfItem:(id)x	{ NSInteger ct = !x ? 1 : [[(AZNODEPRO x) nodeChildren]count];	
																																				  return NSLog(@"Item: %@ children ct: %ld", x, ct),ct;
}
- 	 (id) outlineView:(NSOV*)v               child:(NSInteger)idx ofItem:(id)x	{	return !x ? self.root : [(AZNODEPRO x) nodeChildren][idx];	}  
-   (id) outlineView:(NSOV*)v objectValueForTableColumn:(NSTC*)c byItem:(id)x {	

	if ([c.identifier isEqualToString:@"value"]) { 	if ((AZNODEPRO x).nodeChildren.count) return nil; else return (AZNODEPRO x).nodeValue; }
	if ([c.identifier isEqualToString:  @"key"]) { 	return (AZNODEPRO x).nodeKey; 																			}
	return nil;
	// returns child count in "Value", ie. columns 2, or nil, for root, akak "key" columns" 												  ;
}

- (void) outlineView:(NSOV*)v willDisplayCell:(id)cell forTableColumn:(NSTC*)c item:(id)x	{

    NSUInteger rowNo = [v rowForItem:x];
//    NSColor *backgroundColor;
//	backgroundColor = // Normal background color;
//   [[v selectedRowIndexes] containsIndex:rowNo] ?  NSColor.yellowColor : NSColor.greenColor;  // Highlighted color;
	[(NSTextFieldCell*)cell setDrawsBackground:YES];
	[(NSTextFieldCell*)cell setBackgroundColor:NSColor.blueColor];
}


//- (NSCell*)outlineView:(NSOV*)v    dataCellForTableColumn:(NSTC*)c item:(id)x {  }
- (void) outlineViewItemDidCollapse:							  (NSNotification*)n	{	if (![n.object isKindOfClass:AZNode.class]) return;
	[NSUserDefaults.standardUserDefaults setBool:YES forKey:[(AZNode*)n.object key]];	
} 							// saving collapse state 

	/ * NSRect v = self.nodeRect;
//	[CAAnimationGroup animation];
//	
//	[CATransaction setAnimationDuration:.4];
//	[CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		NSRect unit = (NSRect){0,0, v.size.width, 0};
		NSRect newUnit = unit;
		for (AZNode *n in _controller.nodeChildren)  {
runCommand([NSString stringWithFormat:@"/usr/bin/say OnChild.%@ &",n.nodeKey]);
		newUnit.size.height += 25;
		CABasicAnimation *unitA = [CABasicAnimation animationWithKeyPath:@"bounds"];
		unitA.duration = 2.;
		unitA.fromValue = [NSValue valueWithRect:unit];
		unitA.toValue = [NSValue valueWithRect:newUnit];
		unitA.fillMode = kCAFillModeForwards;
		
		CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		pulseAnimation.duration = 2.;
		pulseAnimation.toValue = @(1.15);

		CABasicAnimation *pulseColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
		pulseColorAnimation.duration = 1.;
		pulseColorAnimation.fillMode = kCAFillModeForwards;
		pulseColorAnimation.toValue = (id)[NSColor colorWithCalibratedRed:(float)random()/RAND_MAX green:(float) random()/RAND_MAX blue:(float) random()/RAND_MAX alpha:1.0f].CGColor;

		CABasicAnimation *rotateLayerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
		rotateLayerAnimation.duration = .5;
		rotateLayerAnimation.beginTime = .5;
		rotateLayerAnimation.fillMode = kCAFillModeBoth;
		rotateLayerAnimation.toValue = @(0.78539816339745);//:DEGREES_TO_RADIANS(45.)];

		CAAnimationGroup *group = [CAAnimationGroup animation];
		group.animations = @[unitA, pulseColorAnimation];
		group.duration = 2.;
		group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//		group.autoreverses = YES;
//		group.repeatCount = FLT_MAX;
  		[[self layerForNode:n] setFrame:newUnit];
	  [[self layerForNode:n] addAnimation:group forKey:nil];
	  		unit.size.height += 25;

	}
*
			
					
							
											if (n == _selectedSelction) {
				NSLog(@"matched node!: %@", _selectedSelction);
				NSInteger indexOf = [_controller.nodeChildren indexOfObject:n], 
							 totalCt = _controller.nodeChildren.count, 
					   	  remain = totalCt - indexOf;
				
				unit.size.height = v.size.height - (remain *25);
			}
			else unit.size.height     += 25;// = (NSRect){0,unit.origin.y +unit.size.height, v.size.width, 25};
			CALayer *l 					 	= [self layerForNode:n];
  			CABasicAnimation *bounds 	= [CABasicAnimation animationWithKeyPath:@"bounds"];
			bounds.fromValue 				= [l valueForKey:@"bounds"];
			bounds.toValue	 				= [NSValue valueWithRect:unit];
			
			[l setValue:[NSValue valueWithRect:unit] forKey:@"completionRect"];
		   NSLog(@"setting rect %@", NSStringFromRect(unit));
			[l addAnimation:bounds forKey:@"bounds"];			
		}
	[CATransaction setCompletionBlock:^{
		for (AZNode *n in _controller.nodeChildren)  {
			CALayer *l = [self layerForNode:n];
			[l setFrame:[[l valueForKey:@"completionRect"]rectValue]];
//		}
	}];
	[CATransaction commit];
			
			
			else l.zPosition = 0;
			CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
 Prepare the animation from the current position to the new position
		   CAAnimationBlockDelegate *d1 = CAAnimationBlockDelegate.new, *d2 = CAAnimationBlockDelegate.new;
     		animation.delegate = d1;
     		bounds.delegate = d2;
			animation.fillMode = bounds.fillMode = kCAFillModeBoth;
			animation.removedOnCompletion = bounds.removedOnCompletion = NO;
			animation.fromValue = [l valueForKey:@"position"];
			NSPoint p = (NSPoint){ unit.origin.x + (.5 * unit.size.width), unit.origin.y + (.5 * unit.size.height)};
			d1.blockOnAnimationSucceeded = ^() { l.position = p;  };
			animation.toValue = [NSValue valueWithPoint:p];
			NSRect newRect = (NSRect){0,0, unit.size.width, unit.size.height};
			@"completionRect"newRect];
			[l setValue:@YES forKey:@"isAnimating"];
			d2.blockOnAnimationSucceeded = ^() { l.bounds = newRect; };
		   [l addAnimation:animation forKey:@"position"];
		[l setFrame:unit];
		[l setNeedsDisplay];
objc_setAssociatedObject(n, (__bridge const void*)(@"rect"), [NSValue valueWithRect:unit],OBJC_ASSOCIATION_RETAIN_NONATOMIC);
			[nl addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintHeight relativeTo:@"superlayer" attribute:kCAConstraintHeight scale:scale offset:0]];
			[nl addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintWidth relativeTo:@"superlayer" attribute:kCAConstraintWidth]];
			if (idx == 0 )
				[nl addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:@"superlayer" attribute:kCAConstraintMinY]];
			else if (idx == _controller.nodeChildren.count -1 )
				[nl addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:@"superlayer" attribute:kCAConstraintMaxY]];
			else {
				NSString* plusone =[_controller.nodeChildren[idx+1] nodeKey], *minusone = [_controller.nodeChildren[idx-1] nodeKey];
				NSLog(@"plusone: %@, minusone: %@", plusone, minusone);
				[nl addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMinY relativeTo:minusone attribute:kCAConstraintMinY]];
				[nl addConstraint:[CAConstraint constraintWithAttribute:kCAConstraintMaxY relativeTo:plusone attribute:kCAConstraintMaxY]];
			}			
		t.foregroundColor = NSColor.whiteColor.CGColor;
		t.autoresizingMask = kCALayerMaxYMargin;
		t.frame = (NSRect){0,0,self.frame.size.width, 25};
		t.layoutManager = [CAConstraintLayoutManager layoutManager];
	
*/

