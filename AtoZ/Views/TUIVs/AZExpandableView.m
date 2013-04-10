
#import "AZExpandableView.h"

@interface AZExpandableView ()
@property NSI objectIndex;
@property TUITextRenderer *textRenderer;
@property NSAS *attributedString;
@property CGSZ originalSize;
@end

@implementation AZExpandableView
@synthesize expanded, dictionary, selected, textRenderer, originalSize;

- (id)initWithFrame: (CGR)frame 	{
	if (self != [super initWithFrame:frame]) return nil;
	self.opaque 		 	= YES;
	self.textRenderers 	= @[textRenderer = TUITextRenderer.new];
	self.clipsToBounds 	= YES;
//	self.backgroundColor = WHITE;
	return self;
}
- (void) setDictionary:(NSMD*)d 	{	dictionary = d;   [d each:^(id key, id value) { [self setValue:value forKey:key]; }]; }
- (NSAS*) attrString	 				{	NSS*s = _name 	?: _url.host.stringValue 
																	?: NSS.randomDicksonism; 
												return [s attributedWithFont:AtoZ.controlFont andColor:WHITE];	
}
- (NSC*) color 						{  return _color ?: dictionary[@"color"] ?: self.favicon.quantized;  }
- (NSURL*) url 						{ 	return _url ?: [dictionary[@"url"] urlified]; }
- (NSIMG*)favicon 					{  return _favicon ?: dictionary[@"favicon"] ?: AZFavIconManager.sharedInstance.placehoder;
//	
//			[AZFavIconManager iconForURL:_url downloadHandler:^(NSIMG *i) { 
//				_favicon = dictionary[@"favicon"] =  [[i imageScaledToFitSize:self.size] named:_name]; 
//				[self redraw];
//			}];
//	[TUIView animateWithDuration:0.5 animations:^{ 			[self redraw]; 		}];
}
- (NSM*) menuForEvent: (NSE*)e	{

	__block NSM *menu = NSMenu.new;	[@{	@"Insert Above" : @"insertObject", @"Insert Below":@"insertObjectBelow", 
														@"Insert at top": @"prepend",		  		 @"Remove" : @"remove:", 
  										   @"Toggle Expand To Fill" : @"toggleExpanded" } each:^(id k, id v)  {
		NSMI *i = [NSMI.alloc initWithTitle:NSLocalizedString(k, nil) 	
											  action:NSSelectorFromString(v) 
									 keyEquivalent:@""];  i.target = self;  [menu addItem:i];	 }]; return menu;
}
- (BOOL) faviconOK  					{  return [dictionary objectForKey:@"favicon"] != nil 
												  ? [[(NSIMG*)dictionary[@"favicon"] name] endsWith:self.name] : NO; 
}
- (void) drawRect:	 (CGR)rect {

	[self.path fillWithColor: self.selected  ? [NSC linenTintedWithColor:self.color] : self.color];
	NSRect l, r;  l = AZRectTrimmedOnRight(self.bounds, self.height); r = AZRectTrimmedOnLeft(self.bounds, l.size.width);
	[self.favicon drawInRect:r];
	textRenderer.attributedString = self.attrString;
	textRenderer.frame = l;
	[textRenderer draw];
}
- (void) mouseDown:	  (NSE*)e	{	[super mouseDown:e]; // always call super when overriding mouseXXX: methods - lots of plumbing happens in TUIView
}
- (void) mouseUp:		  (NSE*)e	{

	LOGWARN(@"selected %@", self.dictionary);			
	[TUIView animateWithDuration:0.5 animations:^{		// rather than a simple -setNeedsDisplay, let's fade it back out
		self.selected = !selected;
//		[self setNeedsDisplay];
//		self.selected = NO;
		[self redraw]; // -redraw forces a .contents update immediately based on drawRect, and it happens inside an animation block, so CoreAnimation gives us a cross-fade for free
	}];
	if([self eventInside:e]) { 
// only perform the action if the mouse up happened inside our bounds - ignores mouse down, drag-out, mouse up
//		NSLog(@"did seleted %@", self);
//		[[self tabBar].delegate tabBar:[self tabBar] didSelectTab:self.tag];
	}
	[super mouseUp:e]; // moved from top
}
- (void) toggleExpanded 	{	__block CGSZ tSize; __block CGF w, h; 
										BOOL isVRT = !self.parentLayout.typeOfLayout == AHLayoutHorizontal;

	!isVRT ? ^{ w	= expanded ? originalSize.width  :  self.parentLayout.width;	tSize = (CGS)   { w, self.height }; }()
			 : ^{	h 	= expanded ? originalSize.height : self.parentLayout.height;	tSize = (CGS)   { self.width, h  }; }();
	[self.parentLayout beginUpdates];
	[self.parentLayout resizeViewAtIndex:self.tag toSize:tSize aniBlock:nil  completion:^{ 	 expanded = !expanded;	 }];
	[self.parentLayout endUpdates];
}
- (void) insertObject		{	[_objects addObject:NSMD.new]; [self.parentLayout insertViewAtIndex:self.tag];
}
- (void) insertObjectBelow {	[_objects addObject:NSMD.new]; [self.parentLayout insertViewAtIndex:self.tag-1];	
}
- (void) prepend 				{	[_objects addObject:NSMD.new]; [self.parentLayout prependNumOfViews:1 aniBlock:nil completion:nil];			
}
- (void) remove: (id)s 		{ 	[_objects removeObjectAtIndex:self.tag];
										[self.parentLayout removeViewsAtIndexes:[NSIS indexSetWithIndex:self.tag] aniBlock:nil completion:nil ];	
}
- (void) reset					{ 	[self initWithFrame:self.bounds];  }
- (AHLayout*) parentLayout	{ 	return (AHLayout*) self.superview;	}
- (void) setTag: (NSI)tag 	{ 	[super setTag:tag]; }		
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

