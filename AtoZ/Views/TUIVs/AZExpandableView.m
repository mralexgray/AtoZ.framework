
#import "AZExpandableView.h"

@interface AZExpandableView ()
@property NSI objectIndex;
@property TUITextRenderer *textRenderer;
@property NSAS *attributedString;
@property CGSZ originalSize;
@end

@implementation AZExpandableView
@synthesize expanded, selected, textRenderer, originalSize;

- (id)initWithFrame: (CGR)frame 	{	if (self != [super initWithFrame:frame]) return nil;
	self.opaque 		 	= YES;
	self.textRenderers 	= @[textRenderer = TUITextRenderer.new];
	self.clipsToBounds 	= YES;
	self.dictionary		= NSMD.new;
	return self;
}
- (void) setDictionary:(NSMD*)d 	{  _dictionary = nil;

	if (!NSEqualRects(self.frame, NSZeroRect)) {	NSLog(@"setting dictionary: %@ in frame %@", d, NSStringFromRect(self.frame)); }
	  _dictionary = d;
//	 [d each:^(id key, id value) { [self setValue:value forKey:key]; }];
}
- (NSAS*) attrString	 				{	NSS* s = _dictionary[@"string"]	?: self.url.host.stringValue;
												return [s attributedWithFont:[AtoZ.controlFont fontWithSize:22] andColor:WHITE];
}
//
//- (NSIMG*)favicon 	{
//
//	return [_dictionary objectForKey:@"favicon"] ?:
//		[AZFavIconManager iconForURL:[_dictionary[@"url"]urlified] downloadHandler:^(NSImage *icon) {
//			if (icon && _dictionary) [_dictionary setValue:icon forKey:@"favicon"];
////							[self redraw];
//															}];
//
//			[AZFavIconManager iconForURL:_url downloadHandler:^(NSIMG *i) { 
//				_favicon = dictionary[@"favicon"] =  [[i imageScaledToFitSize:self.size] named:_name]; 
//				[self redraw];
//			}];
//	[TUIView animateWithDuration:0.5 animations:^{ 			[self redraw]; 		}];
//}
//- (BOOL) faviconOK  					{  return [_dictionary objectForKey:@"favicon"] != nil
//												  ? [[(NSIMG*)_dictionary[@"favicon"] name] endsWith:self.string] : NO;
//}
- (void) drawRect:	 (CGR)rect {
	if ( NSEqualRects( NSUnionRect(self.bounds, rect), NSZeroRect) ) return;
	NSC* c =  RANDOMCOLOR;//_dictionary[@"color"] ? [NSC linenTintedWithColor: _dictionary[@"color"]] :
//		self.favicon ?	self.favicon.quantized : RED;
//	NSLog(@"Name of color for %@: %@", _dictionary[@"url"], [c nameOfColor]);
	[self.path fillWithColor: c];//self.selected ? c.darker.darker : c.brighter];

																	 //self.color] : self.color];self.selected
	NSRect l, r;  	l = AZRectTrimmedOnRight(self.bounds, self.height);
						r = AZRectTrimmedOnLeft(self.bounds, l.size.width);
						r = quadrant(r, AZQuadBotRight);
//	[self.favicon drawInRect:r];
//	[self.favicon drawInRect:r];
	textRenderer.attributedString = self.attrString;
	textRenderer.frame = l;
	[textRenderer draw];
}
- (void) mouseDown:	  (NSE*)e	{  // always call super when overriding mouseXXX: methods - lots of plumbing happens in TUIView

		[super mouseDown:e];
}
- (void) mouseUp:		  (NSE*)e	{	[super mouseUp:e];

	LOGWARN(@"selected dict:%@  tag:  %ld", self.propertiesPlease, self.tag);

// only perform the action if the mouse up happened inside our bounds - ignores mouse down, drag-out, mouse up
	if([self eventInside:e]) {
		[TUIView animateWithDuration:0.5 animations:^{		// rather than a simple -setNeedsDisplay, let's fade it back out
			self.selected = !selected;
			/* -redraw forces a .contents update immediately based on drawRect,
			and it happens inside an animation block, so CoreAnimation gives us a cross-fade for free */
			[self redraw];
		}];
	}
//		NSLog(@"did seleted %@", self);
//		[[self tabBar].delegate tabBar:[self tabBar] didSelectTab:self.tag];

}
- (void) toggleExpanded 	{	__block CGSZ tSize; __block CGF w, h; 
										BOOL isVRT = !self.parentLayout.typeOfLayout == AZOrientHorizontal;

	!isVRT ? ^{ w	= expanded ? originalSize.width  :  self.parentLayout.width;	tSize = (CGS)   { w, self.height }; }()
			 : ^{	h 	= expanded ? originalSize.height : self.parentLayout.height;	tSize = (CGS)   { self.width, h  }; }();
	[self.parentLayout beginUpdates];
	[self.parentLayout resizeViewAtIndex:self.tag toSize:tSize aniBlock:nil  completion:^{ 	 expanded = !expanded;	 }];
	[self.parentLayout endUpdates];
}
- (void) insertObject		{	/*[_objects addObject:NSMD.new];*/

	[self.parentLayout insertViewAtIndex:self.tag];
}
- (void) insertObjectBelow {	/*[_objects addObject:NSMD.new];*/

	[self.parentLayout insertViewAtIndex:self.tag-1];
}
- (void) prepend 				{ /*[_objects addObject:NSMD.new];*/

	[self.parentLayout prependNumOfViews:1 aniBlock:nil completion:nil];
}
- (void) remove: (id)s 		{ 	/*[_objects removeObjectAtIndex:self.tag];*/

	[self.parentLayout removeViewsAtIndexes:[NSIS indexSetWithIndex:self.tag] aniBlock:nil completion:nil ];
}
- (void) reset					{ 	[self initWithFrame:self.bounds];  	}
- (AHLayout*) parentLayout	{ 	return (AHLayout*) self.superview;	}
- (NSM*) menuForEvent: (NSE*)e	{

	__block NSM *menu = NSMenu.new;	[@{	@"Insert Above" : @"insertObject", @"Insert Below":@"insertObjectBelow",
												 @"Insert at top": @"prepend",		  		 @"Remove" : @"remove:",
												 @"Toggle Expand To Fill" : @"toggleExpanded" } each:^(id k, id v)  {
													 NSMI *i = [NSMI.alloc initWithTitle:NSLocalizedString(k, nil)
																							action:NSSelectorFromString(v)
																				  keyEquivalent:@""];  i.target = self;  [menu addItem:i];	 }]; return menu;
}
- (void) setTag: (NSI)tag 	{ 	[super setTag:tag];						}
@end



/*	CGCREF ctx 		= TUIGraphicsGetCurrentContext();
	originalSize 	= CGSizeEqualToSize(CGSizeZero, originalSize) ? b.size : originalSize;
 selected background CGContextSetRGBFillColor(ctx, .87, .87, .87, 1);	CGContextFillRect(ctx, b);
		self.path.dashPattern 		= @[@15, @15];
		LOGWARN(@"dashPattern: %@", self.path.dashPattern);
		[self.path strokeWithColor:BLACK andWidth:10];
		[self.layer addAnimation:[CAA shakeAnimation]];	} else { light gray background
	CGContextSetRGBFillColor(ctx,.7,.7,.7,1); CGContextFillRect(ctx, b);
		if ([self.dictionary[@"colorState"]boolValue] == 1)		
 emboss
		CGContextSetRGBFillColor(ctx, 1, 1, 1, 0.9); // light at the top
		CGContextFillRect(ctx, CGRectMake(0, b.size.height-1, b.size.width, 1));
		CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.08); // dark at the bottom
		CGContextFillRect(ctx, CGRectMake(0, 0, b.size.width, 1))
	if (self.faviconOK)
	NSR quad = quadrant(self.bounds,1);
 imageScaledToFitSize:quad.size] drawAtPoint:NSZeroPoint inRect:quadrant(self.bounds,1)];//]AZMakeSquare((NSP){self.height/2, self.height/2}, self.height)];
 text
	CGRect textRect = CGRectOffset(b, 15, -15);
	textRenderer.frame = b;  //textRect; // set the frame so it knows where to draw itself
	[textRenderer draw];
	NSBP *p = [NSBP bezierPathWithRect: (NSR) { self.width -20, 0, 20, 20 }];
	NSC  *x = [self.favicon isKindOfClass:NSIMG.class] ? GREEN : RED;
	[p  fillWithColor:x];
+ (NSSet*) keyPathsForValuesAffectingValueForKey:(NSS*) key { NSSet *kps = [[super keyPathsForValuesAffectingValueForKey:key] setByAddingObjectsFromArray:
																					 areSame(key, @"dictionary") ? @[@"name", @"color", @"url", @"favicon", @"attrString"] 
																					 :	areSame(key, @"favicon") ? @[@"color"] : @[]];   LOGWARN(@"kps:%@ affecting:%@", kps, key); return kps;
																					 }*/

