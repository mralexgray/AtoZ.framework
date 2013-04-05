
#import "AZExpandableView.h"

@interface AZExpandableView ()
@property NSI objectIndex;
@property TUITextRenderer *textRenderer;
@property NSAS *attributedString;
@property CGSZ originalSize;
@end

@implementation AZExpandableView
@synthesize expanded, dictionary, selected, textRenderer, originalSize;

- (id)initWithFrame:(CGR)frame 	{
	if (self != [super initWithFrame:frame]) return nil;
	self.opaque 		 	= YES;
	self.textRenderers 	= @[textRenderer = TUITextRenderer.new];
//	self.clipsToBounds 	= YES;
//	self.backgroundColor = [NSColor lightGrayColor];
	return self;
}
- (AHLayout*) parentLayout 		 	{ return (AHLayout*) self.superview;	}
- (void) setTag:(NSI) tag 	 		{	[super setTag:tag]; }

- (void) setDictionary:(NSMD*)d {
	
	dictionary = d;
	textRenderer.attributedString = [self.name ?: NSS.randomDicksonism attributedWithFont:AtoZ.controlFont andColor:WHITE];
}
- (NSS*) name { return self.dictionary [@"color"][@"name"]; //	NSS* name = self.objects[tag][@"color"][@"name"];
//	textRenderer.attributedString = [NSAS.alloc initWithString: name ?: 
//																					NSS.randomDicksonism];
//	self.objects[@"color"]];// $(@"%ld", self.tag)];
}
- (NSC*) color {  return self.dictionary[@"color"][@"color"] ?: RANDOMCOLOR; }
- (NSIMG*) favicon { return _favicon = _favicon ?: [NSIMG faviconForDomain:dictionary[@"color"][@"url"]]; }

- (NSM*) menuForEvent:(NSE*)event{
	__block NSM *menu = NSMenu.new;
	[@{ @"Insert Above" : @"insertObject",	@"Insert Below":@"insertObjectBelow", 
	 		@"Insert at top": @"prepend", 		@"Remove" : @"remove:", 
	 		@"Toggle Expand To Fill" : @"toggleExpanded" } each:^(id k, id v)  {
		 NSMI *i = [NSMI.alloc  initWithTitle:NSLocalizedString(k, nil) 
						action:NSSelectorFromString(v) keyEquivalent:@""];  
		 i.target = self; 							 
		 [menu addItem:i];
	 }]; 																 return menu;
}
- (void) toggleExpanded 				{

	__block CGSize tSize; __block CGF w, h;
	self.parentLayout.typeOfLayout == AHLayoutHorizontal ? ^{
		w = expanded  ? originalSize.width : self.parentLayout.width;
		tSize = 	   (CGS)  { w, self.height };
	}() : ^{		  h = expanded  ? originalSize.height : self.parentLayout.height;
		tSize = 		(CGS)  { self.width, h  };
	}();
	[self.parentLayout beginUpdates];
	[self.parentLayout resizeViewAtIndex:self.tag toSize:tSize animationBlock:nil  completionBlock:^{ 	expanded = !expanded;	 }];
	[self.parentLayout endUpdates];
}

- (void) insertObject			{	[_objects addObject:NSMD.new];
											[self.parentLayout insertViewAtIndex:self.tag];
}
- (void) insertObjectBelow 	{	[_objects addObject:NSMD.new];
											[self.parentLayout insertViewAtIndex:self.tag-1];
}
- (void) prepend 				{	[_objects addObject:NSMD.new];
											[self.parentLayout prependNumOfViews:1 animationBlock:nil completionBlock:nil];
}
- (void) remove:(id)sender 	{	[_objects removeObjectAtIndex:self.tag];
											[self.parentLayout removeViewsAtIndexes:[NSIndexSet indexSetWithIndex:self.tag ] animationBlock:nil           completionBlock:nil ];
}

- (void) drawRect:(CGR)rect		{

	 CGR b 		  = self.bounds;
	CGCREF ctx = TUIGraphicsGetCurrentContext();
	originalSize = CGSizeEqualToSize(CGSizeZero, originalSize) ? b.size : originalSize;
//	LOGWARN(@"DRAWRECT: %@", self.properties);//AZString(b));
	if(self.selected) {
		// selected background		CGContextSetRGBFillColor(ctx, .87, .87, .87, 1);		CGContextFillRect(ctx, b);
		NSBP *path = [NSBP bezierPathWithRect:b];
		[path fillWithColor:[NSC leatherTintedWithColor:self.color]];// CHECKERS];
		[path strokeWithColor:BLACK andWidth:10];
//		[self.layer addAnimation:[CAA shakeAnimation]];
	} else {
		// light gray background
		//	CGContextSetRGBFillColor(ctx,.7,.7,.7,1); CGContextFillRect(ctx, b);
		NSRectFillWithColor(b, self.color);
		// emboss
		CGContextSetRGBFillColor(ctx, 1, 1, 1, 0.9); // light at the top
		CGContextFillRect(ctx, CGRectMake(0, b.size.height-1, b.size.width, 1));
		CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.08); // dark at the bottom
		CGContextFillRect(ctx, CGRectMake(0, 0, b.size.width, 1));
	}
	[self.favicon drawAtPoint:NSZeroPoint];
	// text
	CGRect textRect = CGRectOffset(b, 15, -15);
	textRenderer.frame = textRect; // set the frame so it knows where to draw itself
	[textRenderer draw];
	
}
- (void) mouseDown:(NSE*)event{
	[super mouseDown:event]; // always call super when overriding mouseXXX: methods - lots of plumbing happens in TUIView
}
- (void) mouseUp:(NSE*)event	{
// rather than a simple -setNeedsDisplay, let's fade it back out
//	[TUIView animateWithDuration:0.5 animations:^{
		self.selected = !selected;
//		[self setNeedsDisplay];
//		self.selected = NO;
		[self redraw]; // -redraw forces a .contents update immediately based on drawRect, and it happens inside an animation block, so CoreAnimation gives us a cross-fade for free
//	}];
	if([self eventInside:event]) { 
// only perform the action if the mouse up happened inside our bounds - ignores mouse down, drag-out, mouse up
//		NSLog(@"did seleted %@", self);
//		[[self tabBar].delegate tabBar:[self tabBar] didSelectTab:self.tag];
	}
	[super mouseUp:event]; // moved from top
}
@end
