
#import <WebKit/WebKit.h>
#import <AtoZ/AtoZ.h>
#import "NSView+AtoZ.h"

@implementation NSViewFlipped
- (BOOL) isFlipped { return YES; }
@end


@implementation NSView (IsFlipped)
- (void) setIsFlipped:(BOOL)f {  [self az_overrideBoolMethod:@selector(isFlipped) returning:f]; }
- (void)  setIsOpaque:(BOOL)f {  [self az_overrideBoolMethod:@selector(isOpaque)  returning:f]; }
@end

@implementation NSView (MoveAndResize)

- (void) setNewFrameFromMouseDrag:(NSR)newFrame {
  [[self window] setFrame:newFrame display:YES];
}
- (void) trackMouseDragsForEvent:(NSE*)theEvent clickType:(int)clickType{

  NSP point1 = NSEvent.mouseLocation;
	NSR frame = self.window.frame;		
	NSEvent *anotherEvent;
	while ((anotherEvent = [self.window nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask])
           && [anotherEvent type] != NSLeftMouseUp) {
			NSR newFrame;
			NSP point2 = NSEvent.mouseLocation;
			newFrame = clickType  ? AZRectResizedLikePointsInQuad(frame, point1, point2, clickType)
                            :        AZRectOffsetLikePoints(frame, point1, point2);
 	     [self setNewFrameFromMouseDrag:newFrame];
		}
}
- (void) dragBlock:(void(^)(NSP click,NSP delta,NSMD*context))block mouseUp:(void(^)(void))upBlock {

//	[self az_overrideSelector:@selector(mouseDown:) withBlock:(__bridge void *)^(id _self, NSE*e){
  [NSEVENTLOCALMASK:NSLeftMouseDownMask| NSLeftMouseUpMask |NSMouseMovedMask handler:^NSEvent *(NSEvent *e) {
    if (e.type != NSLeftMouseDownMask) return e;  //		void(^newB)(NSP,NSP,NSMD*) = [block copy];
    __block NSMD* contextual = NSMD.new;  //		__block NSEvent *eBlock = e;	__block void(^trackBlock)(void) = ^{
    NSP point1 = [self convertPoint:e.locationInWindow toView:nil]; //      NSP zeroP  = NSZeroPoint; NSP *reference = &zeroP;
    while (e.type != NSLeftMouseUp) {     //				e = [NSApp nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask
                                      //											  untilDate:FUTURE inMode:NSEventTrackingRunLoopMode dequeue:YES];	@autoreleasepool {
      NSP point2 = [self convertPoint:e.locationInWindow fromView:nil];
      NSP delta 	= AZSubtractPoints( point1, point2 );
      block (point1,delta,contextual);
    }
    upBlock();	NSLog(@"MouseUp.. PHEW!!");
    return e;
  }];
//      [[_self nextResponder] mouseUp:e];
//      SEL sel = @selector(mouseUp:);
//      void (*superIMP)(id, SEL, NSE*) = [[_self nextResponder] az_superForSelector:sel];
//      superIMP(_self, sel, e);

//			eBlock = nil; }; 		trackBlock();
//	}];
}
@end

                   NSTI AZDefaultAnimationDuration      = 1; // -1 makes the system provide a default duration
NSAnimationBlockingMode AZDefaultAnimationBlockingMode  = NSAnimationNonblocking;
       NSAnimationCurve AZDefaultAnimationCurve         = NSAnimationEaseInOut;

#define ifARGC(...) do { int x = metamacro_argcount(__VA_ARGS__); 

@implementation NSView (AtoZ) @dynamic onEndLiveResize;

- copyWithZone:(NSZone*)z {

  NSData * archivedView = [NSKeyedArchiver archivedDataWithRootObject:self];
  return [NSKeyedUnarchiver unarchiveObjectWithData:archivedView.copy];
}


- (void) setOnEndLiveResize:(ObjBlk)b { static dispatch_once_t onLive;

  dispatch_once(&onLive, ^{ [self az_overrideSelector:@selector(viewDidEndLiveResize) withBlock:(__bridge void *)^(id _self){

      VoidBlock xx; if ((xx = objc_getAssociatedObject(_self,@selector(viewDidEndLiveResize)))) xx(_self);

  }]; });

  [self triggerKVO:@"onEndLiveResize" block:^(id _self) {  objc_setAssociatedObject(_self, @selector(viewDidEndLiveResize), [b copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC); }];
}

- (void) setOpaque:(BOOL)x {  static dispatch_once_t uno;

  dispatch_once(&uno, ^{ [self az_overrideSelector:@selector(isOpaque) withBlock:(__bridge void *)^BOOL(id _self){

      return [objc_getAssociatedObject(self, @selector(isOpaque)) bV];

  }]; });

  [self triggerKVO:@"isOpaque" block:^(id _self) {  objc_setAssociatedObject(_self, @selector(isOpaque), @(x), OBJC_ASSOCIATION_RETAIN_NONATOMIC); }];

}

-  (void) setTag:(NSI)t { self.associatedDictionary[@"_AZViewTag"] = @(t);

  if (self.tag != t) 
    [self az_overrideSelector:@selector(tag) withBlock:(__bridge void *)^NSI(id _self) {
      return [[_self associatedDictionary] integerForKey:@"_AZViewTag"];
    }];
}
- (NSIMG*) captureFrame             {
	
	NSR originRect = [self.window convertRectToScreen:self.bounds]; // toView:[[self window] contentView]];
	
	NSR rect = originRect;
	rect.origin.y = 0;
	rect.origin.x += self.window.frame.origin.x;
	rect.origin.y += self.window.screen.frame.size.height - self.window.frame.origin.y - self.window.frame.size.height;
	rect.origin.y += self.window.frame.size.height - originRect.origin.y - originRect.size.height;
	
	CGImageRef cgimg = CGWindowListCreateImage(rect,
															 kCGWindowListOptionIncludingWindow,
															 (CGWindowID)[[self window] windowNumber],
															 kCGWindowImageDefault);
	NSIMG *img = [NSImage.alloc initWithCGImage:cgimg size:[self bounds].size];
	CFRelease(cgimg);
	return img;
}

SYNTHESIZE_ASC_OBJ_ASSIGN_BLOCK(needsDisplayForKeys, setNeedsDisplayForKeys, ^{}, ^{ AZBlockSelf(view);

  if ([self.needsDisplayForKeys isEqual:value]) return;
  if (self.needsDisplayForKeys.count) [self.needsDisplayForKeys do:^(id k){ [view unbind:k]; }];
	[self addObserverForKeyPaths:value task:^(id obj, NSS *keyPath) { 		  
    [view setNeedsDisplay:YES]; if (0) JATLog(@"displaying... because of key:{keyPath}",keyPath);
	}];
});

- (NSA*) visibleSubviews          { return [self.subviews filter:^BOOL(id object) { return ![object isHidden]; }]; }
//} objectsWithValue:@NO forKey:@"isHidden"]; }
-  (CGF) heightOfSubviews         { return [self.subviews sumFloatWithKey:@"height"]; }
-  (CGF) widthOfSubviews          { return [self.subviews sumFloatWithKey: @"width"]; } //return [[self.subviews reduce:@0 withBlock:^id(NSN* sum, NSV* sub) { return [sum plus:@(sub.width)]; }]fV]; }
-  (CGF) heightOfVisibleSubviews  { return [self.visibleSubviews sumFloatWithKey:@"height"]; } // reduce:@0 withBlock:^id(NSN*sum, NSV*sub) { return [sum plus:@(sub.height)]; }]fV]; }
-  (CGF) widthOfVisibleSubviews   { return [self.visibleSubviews sumFloatWithKey: @"width"]; } // reduce:@0 withBlock:^id(NSN*sum, NSV* sub) { return [sum plus:@(sub.width)]; }]fV]; }


+ (instancetype)        viewBy:(NSN*)dimOne, ... {

  NSParameterAssert(ISA(dimOne,NSN));
    azva_list_to_nsarray(dimOne,sizes);
    NSLog(@"sizes:%@", sizes);
    NSR fr = [NSN rectBy:sizes];
    NSLog(@"%@", AZString(fr));

    return [self viewWithFrame:fr];
}

+ (instancetype) viewWithFrame:(NSR)r mask:(NSUI)m { return [[self.class.alloc initWithFrame:r] objectBySettingValue:@(m) forKey:@"autoresizingMask"]; }
+ (instancetype) viewWithFrame:(NSR)r { return [self viewWithFrame:r mask:NSSIZEABLE]; }

//-   (id) background	{ id bg = nil;

//	if ( [self.class instancesRespondToSelector:]) {
//			bg = [(id)self background]; if (bg) return bg;
//	}
//	return objc_getAssociatedObject(self, _cmd); 
//}
//- (void) setBackground: bg 	{ 
//
//  IF_ICAN_THEN(background,({ 
//    
//    NSMethodSignature *s = [self methodSignatureForSelector:@selector(background)];
//		if (strcmp([bg objCType],[s getArgumentTypeAtIndex:2])) 
//      return [(id)self setBackground:bg];
//  }));

//	id existing = self.getBackground;  if ([existing isEqualTo:bg]) return;	
SYNTHESIZE_ASC_OBJ_BLOCK(background,setBackground,^{},^{
//	objc_setAssociatedObject(self, @selector(getBackground), bg, OBJC_ASSOCIATION_RETAIN_NONATOMIC); 
//	IF_RETURN(existing);
//  if ( 
  
    SEL dRectSelect = @selector(drawRect:);
    [self az_overrideSelector:dRectSelect withBlock:(__bridge void *)^(id _self, NSR dRect)	{ 
    
      ISA(value,NSC) ? NSRectFillWithColor(dRect,value) :
      ISA(value,NSG) ? [(NSG*)value drawInRect:dRect angle:-90] : nil;
      void (*superIMP)(id, SEL, NSR) = [_self az_superForSelector:dRectSelect];
      superIMP(_self, dRectSelect, dRect);
    }];
    
})

//SYNTHESIZE_ASC_OBJ_BLOCK( 	needsDisplayForKeys,
//									setNeedsDisplayForKeys,
//									^{
//									


- (NSV*) dragSubviewWihEvent:(NSE*)e { 
	
	NSBitmapImageRep     *rep;
	NSPasteboard 		*pboard;
	NSV 						  *x;
	NSR				sourceRect;
	NSImage 					*pic;
	
	x		 		= [self hitTest:e.locationInWindow];
	sourceRect 	= [x.superview convertRect:[x frame] toView:self];
	pic 			= [NSImage.alloc initWithSize:sourceRect.size];
	[self lockFocus];
	rep		 	= [NSBitmapImageRep.alloc initWithFocusedViewRect:sourceRect];
	[self unlockFocus];
	[pic addRepresentation:rep];
	pboard 		= [NSPasteboard pasteboardWithName:NSDragPboard];
	[self dragImage:pic at:sourceRect.origin offset:NSZeroSize event:e pasteboard:pboard source:self slideBack:YES];
	return x;	
}

- (void) handleDragForTypes:(NSA*)files withHandler:(void (^)(NSURL *URL))handler;
{
	[self registerForDraggedTypes:@[ (__bridge id)kUTTypeFileURL ]];
}
/*
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender	{
    NSDragOperation theMask = [sender draggingSourceOperationMask];
    if ([sender.draggingPasteboard.types containsObject:(__bridge id)kUTTypeFileURL]){
		self.layer.borderColor = [NSColor keyboardFocusIndicatorColor].CGColor;
		self.layer.borderWidth = 5.0;
      if (theMask & NSDragOperationLink) return(NSDragOperationLink);
		else if (theMask & NSDragOperationCopy)   return(NSDragOperationCopy);
	}
   return(NSDragOperationNone);
}
- (void)draggingExited:(id <NSDraggingInfo>)sender	{
	self.layer.borderColor = NULL;
	self.layer.borderWidth = 0.0;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender	{
	self.layer.borderColor = NULL;
	self.layer.borderWidth = 0.0;
	if (self.dragHandler)	{
		NSPasteboardItem *theItem = sender.draggingPasteboard.pasteboardItems[0];
		NSURL *theURL = [NSURL URLWithString:[theItem stringForType:(__bridge id)kUTTypeFileURL]];
		self.dragHandler(theURL);
	}
	return(YES);
}
//  self.window.contentView == self ? [self.window setContentView:newSplt] :
*/
- (CAL*) guaranteedLayer {  return self.layer ?: self.setupHostView; }

- (void) debug                      { [self debuginQuadrant:AZQuadBotLeft]; }
- (void) debuginQuadrant:(AZQuad)q  {
	
	NSD* attrs = @{	NSForegroundColorAttributeName:WHITE, 
							NSFontAttributeName:[NSFont fontWithName:@"UbuntuMono-Bold" size:18], 
							NSFontSizeAttribute:@18};
							
	__block NSUI resize; BLKVIEW *b;__block NSAS *title; __block NSR bnds; __block CAL* theL;
	resize = q == AZQuadBotLeft 	? kCALayerMaxXMargin| kCALayerMaxYMargin 
			 : q == AZQuadBotRight 	? kCALayerMinXMargin| kCALayerMaxYMargin
			 :	q == AZQuadTopLeft   ? kCALayerMaxXMargin| kCALayerMinYMargin
			 :                        kCALayerMinXMargin| kCALayerMinYMargin;
	
	void(^Class1Subs2Supers3)(NSUI)= ^(NSUI i){
		title  = [NSAS.alloc initWithString:
		i == 1 ? NSStringFromClass(self.class) :
		i == 2 ? [(NSA*)[self.subviews vFKP:@"class"]stringValue] : 
		i == 3 ? [[self.superviews vFKP:@"class"]stringValue] : @"" attributes:attrs];
		theL.frame = bnds = AZRectInsideRectOnEdge(AZRectFromSize([title.string sizeWithAttributes:attrs]), self.bounds, q);
	};
	Class1Subs2Supers3(1);
	[self addSubview:b = [BLKVIEW inView:self withFrame:bnds inContext:^(BNRBlockView *v, CALayer *l) {
		NSC*c = [l vFK:@"alexColor"];
		if (!c) [l setValue: c = RANDOMCOLOR forKey:@"alexColor"];
		NSRectFillWithColor(l.bounds,[c alpha:.8]);
		l.arMASK = resize;
//		l.anchorPoint = AZAnchorPtAligned(q);
		[title drawInRect:l.bounds];
		theL = l;
	}]];
	__block BOOL hidden = NO;
	[NSEVENTLOCALMASK:NSLeftMouseDownMask handler:^NSEvent *(NSEvent *e){
		if (!NSPointInRect([self convertPoint:e.locationInWindow fromView:nil], [self convertRectToBacking:self.frame])) return e;
		static NSArray *storage = nil;
//		if ((e.clickCount % 2) == 0) {
		   if (storage.count) { 
													[@"resetting old colors" log];
												 	[storage[0] setBackgroundColor:(id)[storage[1]CGColor]]; 
											}	CGColorRef rrr = theL.superlayer.bgC;  storage = @[theL,rrr != NULL ? [NSC colorWithCGColor:rrr] : CLEAR]; 
												LOGCOLORS(@"setting color on thesuperlayer:", theL.superlayer,GREEN, nil);	theL.superlayer.bgC = cgRANDOMCOLOR;  [theL.superlayer setNeedsDisplay];
//		}
		LOG_EXPR(theL.isGeometryFlipped);
		LOG_EXPR(self.isFlipped);
		LOG_EXPR([self convertPointFromBacking:e.locationInWindow]);
		LOG_EXPR(e.locationInWindow);
		LOG_EXPR([theL frame]);
		LOG_EXPR([self frame]);
		CAL* l = [self.layer hitTest:[self convertPoint:e.locationInWindow fromView:nil]];
		LOG_EXPR(l.debugDescription);
		if (l != theL) return e; else playTrumpet();
		NSUI ctr = 1;
		if (e.clickCount == 1) { ctr = ctr >= 3 ? 1 : ctr+1;  Class1Subs2Supers3(ctr); [theL setNeedsDisplay]; }
		if (e.clickCount == 2) { hidden =! hidden;   hidden ? [theL fadeOut] :[theL fadeIn]; }
		
			return e;
	}];

}

// this is a fun one.  we are going to make a new window and put ourselves into it (taking ourselves out of the old window)
- (void) goFullScreen {
	
	// get the screen that we want to go to
	__block CGF area = 0; __block NSUI x;
	[NSScreen.screens eachWithIndex:^(id obj, NSInteger idx) {
		CGF nArea = $AZR(NSUnionRect(self.frame,[obj frame])).area;
		if (nArea > area) { area = nArea;  x = idx; }
	}];
	NSScreen * chosenScreen = NSScreen.screens[x];
	// get the screen id from the screen description, and capture that display
  	CGDirectDisplayID displayID = [[[chosenScreen deviceDescription] objectForKey:@"NSScreenNumber"] intValue];
	if (CGDisplayCapture( displayID ) != kCGErrorSuccess) { NSLog( @"Couldn't capture the display!" );	}
	NSWindow *fullScreenWindow = [NSWindow.alloc initWithContentRect:[chosenScreen frame]
																			 styleMask:NSBorderlessWindowMask
																				backing:NSBackingStoreBuffered
																				  defer:NO
																			 	 screen:chosenScreen];
	[fullScreenWindow az_overrideSelector:@selector(canBecomeKeyWindow)
									 withBlock:(__bridge void *)^BOOL(id _self)	{ return  YES; }];
	// put this window above the shielding window
	[fullScreenWindow setAlphaValue:0];
	[fullScreenWindow setLevel:CGShieldingWindowLevel()];
	[fullScreenWindow setFrame:chosenScreen.frame display:NO];
//	[fullScreenWindow setBackgroundColor:[NSColor blackColor]];
	
	//remember the old settings before i move out
	NSW* ow = self.window;
	NSR oldF = self.frame;
//	[self setAssociatedValue:ow = self.window forKey:@"oldWindow" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
//	[self setAssociatedValue:AZVrect(self.window.frame) forKey:@"oldFrame" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	[self.window fadeOut];
	[self removeFromSuperview];
	// set my new frame size and insert myself into the new fullscreen window
	[fullScreenWindow setContentView:self];
	[self setFrame:fullScreenWindow.frame];
	[fullScreenWindow makeFirstResponder:self];
	[fullScreenWindow makeKeyAndOrderFront:nil];
	[self setNeedsDisplay:YES];
	[fullScreenWindow fadeIn];
	[NSEVENTLOCALMASK: NSKeyDownMask handler:^NSE*(NSE*e) {
		// this is the ESC key
		if (e.keyCode == 53) { 
			
			// dont do nuthin if we dont have a fullscreen window
			if (fullScreenWindow == nil) return e;
			// destroy the fullscreen window
			[fullScreenWindow fadeOut];
			[fullScreenWindow orderOut:nil];		// need to make this a bit more friendly
			if (CGReleaseAllDisplays() != kCGErrorSuccess) {NSLog( @"Couldn't release the display(s)!" ); }
			// re-expand my old window to its original size
//			NSR oldWindowFrame = [objc_getAssociatedObject(self, (__bridge const void*)@"oldFrame")rectValue];
//			[ow.animator setFrame:oldWindowFrame display:YES];
			// add myself back into the content view
			[[ow contentView] addSubview:self];
			[self setFrame:oldF];//ZRectFromSize(oldWindowFrame.size)];
			// reset the button back to it's original use
	//		[fullScreenButton setTitle:@"Go Fullscreen"];
	//	[fullScreenButton setAction:@selector(goFullScreen:)];
	//		[self closeFullScreenWindow:self];
			[ow fadeIn];
		}
		return e;		
	}];
	// now do some hocus pocus on the old window to squeeze it down
	// because taking myself out left a big hole
//	oldWindowFrame = [self.oldWindow frame];
//	NSR squished = oldWindowFrame;
//	squished.size.height -= NSHeight(oldFrame);
//	squished.origin.y += NSHeight(oldFrame);
//	[[self.oldWindow animator] setFrame:(NSR){{ display:YES];
	
	// now repurpose our GUI button to cancel the fulscreen
//	[fullScreenButton setTitle:@"Stop Fullscreen"];
//	[fullScreenButton setAction:@selector(closeFullScreenWindow:)];
}

- (AZWT*) preview	{ // [[[@"a" classProxy] vFK:AZCLSSTR]performSelector:@selector(preview)];

	AZWindowTab *w = AZWindowTab.new; w.View = self; [w makeKeyAndOrderFront:nil]; return w;
}

+ (AZWT*) preview	{ return [NSView previewOfClass:self.class];  }

+ (AZWT*) previewOfClass:(Class)klass { return [(NSV*)[klass.alloc initWithFrame:NSZeroRect] preview]; }

-  (CAL*) layerFromContents		{

	CALayer *newLayer = CALayer.layer;
	newLayer.bounds = NSRectToCGRect(self.bounds);
	NSBitmapImageRep *bitmapRep = [self bitmapImageRepForCachingDisplayInRect:self.bounds];
	[self cacheDisplayInRect:self.bounds toBitmapImageRep:bitmapRep];
	newLayer.contents =  [NSIMG.alloc initWithData:bitmapRep.TIFFRepresentation];
	return newLayer;
}
- (NSBP*) path {  return [NSBP bezierPathWithRect:self.bounds]; }
-   (CGF) maxDim { return AZMaxDim(self.size); }
-   (CGF) minDim { return AZMinDim(self.size); }

- (NSV*) autosizeable { self.arMASK = NSSIZEABLE; return self; }
// setup 3d transform
- (void) setZDistance:(NSUI)zDistance {
	CATransform3D aTransform = CATransform3DIdentity;
	aTransform.m34 = -1.0 / zDistance;
	if (!self.layer) [self setupHostView];
	self.layer.sublayerTransform = aTransform;
}

- (CGP)layerPoint:(NSE*)e                 { return [self convertPointToLayer:[self convertPoint:e.locationInWindow fromView:nil]]; }
- (CGP)layerPoint:(NSE*)e toLayer:(CAL*)l { return [self.layer convertPoint:[self layerPoint:e] toLayer:l];                        }

@dynamic postsRectChangedNotifications;

- (BOOL) postsRectChangedNotifications            { return self.postsBoundsChangedNotifications && self.postsFrameChangedNotifications; }
- (void) setPostsRectChangedNotifications:(BOOL)x { self.postsBoundsChangedNotifications = self.postsFrameChangedNotifications = x;     }

- (void) observeFrameChange: (void(^)(NSV*))block; { self.postsRectChangedNotifications = YES;

	[@[NSViewFrameDidChangeNotification, NSViewBoundsDidChangeNotification] each:^(NSS* name){
		[self observeName:name usingBlock:^(NSNOT*n) {	block(self); }]; }];
}
- (void) observeFrameChangeUsingBlock:(void(^)(void))block	{ self.postsRectChangedNotifications = YES;

	[@[NSViewFrameDidChangeNotification, NSViewBoundsDidChangeNotification] each:^(NSS* name){
										[self observeName:name usingBlock:^(NSNOT*n) {	block();	}]; }];
}
- (void) observeFrameNotifications:(void(^)(NSNOT*n))block  {  self.postsRectChangedNotifications = YES;

	for (id name in @[NSViewFrameDidChangeNotification, NSViewBoundsDidChangeNotification])
    [self observeName:name usingBlock:^(NSNOT*n) {	block(n);	}];

//	[@[NSViewFrameDidChangeNotification, NSViewBoundsDidChangeNotification] each:^(NSS* name){
//  [AZNOTCENTER addObserverForKeyPaths:@[NSViewFrameDidChangeNotification, NSViewBoundsDidChangeNotification] task:^(id obj, NSString *keyPath) {
//    [obj isEqual:self] ? block()
//									[self observeName:name usingBlock:^(NSNOT*n) {	 block(n);	}]; }];
}

- (BOOL) isSubviewOfView:(NSV*)theView  {
	__block BOOL isSubView = NO;
	[[theView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([self isEqualTo:(NSV*) obj]) {
			isSubView = YES;
			*stop = YES;
		}
	}];
	return isSubView;
}
- (BOOL) containsSubView:(NSV*)subview  {
	__block BOOL containsSubView = NO;
	[[self subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([subview isEqualTo:(NSV*) obj]) {
			containsSubView = YES;
			*stop = YES;
		}
	}];
	return containsSubView;
}

- (void) slideUp      {
	
	if (! [self valueForKeyPath:@"dictionary.visibleRect"] ) {
		NSLog(@"avaing cvisirect: %@", NSStringFromRect([self frame]));
		[self setValue:AZVrect([self frame]) forKeyPath:@"dictionary.visibleRect"];
	}
	NSR newViewFrame = [self frame];
	AZWindowPosition r = AZPositionOfQuadInRect([[self window]frame], AZScreenFrameUnderMenu());
	NSSize getOut = AZDirectionsOffScreenWithPosition(newViewFrame,r);
	newViewFrame.size.width  += getOut.width;
	newViewFrame.size.height += getOut.height;
	CABasicAnimation *framer = [CABasicAnimation animationWithKeyPath:@"frame"];
	[framer setFromValue:AZVrect([self frame])];
	[framer setToValue:	AZVrect(newViewFrame)];
	[self setAnimations:	@{ @"frame" : framer}];
	[[self animator] setFrame:newViewFrame];
}

- (NSA*) subviewsRecursive { return [self.subviews reduce:nil withBlock:^id(NSMA* sum, NSV* obj) {
    sum = sum ?: @[].mutableCopy;
    if (!obj.subviews.count) [sum addObject:obj];
    else [sum addObjectsFromArray:obj.subviewsRecursive];
		return [sum count] ? sum : nil;
	}];
}

- (id) lastLastSubview { NSA* x; return (x = self.subviewsRecursive).count ? x.last : nil; }

- (id) lastSplitPane { NSA *a = self.subviewsRecursive; return !a.count ? nil : (a = [a arrayOfClass:NSSPLTV.class]).count ? [a.last lastSubview] : nil; }

- (NSA*) allSubviews  {

	NSMA *allSubviews = [NSMutableArray arrayWithObject:self];
	NSArray *subviews = [self subviews];
	for (NSView *view in subviews) {
		[allSubviews addObjectsFromArray:[view allSubviews]];
	}
	return allSubviews;
}

static        NSS * ANIMATION_IDENTIFER   = @"animation";
static char const * const __unused ISANIMATED_KEY  = "ObjectRep";

- (void) setAnimationIdentifer:(NSS*)newAnimationIdentifer{
	objc_setAssociatedObject(self, &ANIMATION_IDENTIFER, newAnimationIdentifer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSS*) animationIdentifer { return objc_getAssociatedObject(self, &ANIMATION_IDENTIFER); }

- (void) replaceSubviewWithRandomTransition:(NSV*)oldView with:(NSV*)newView {
	BOOL hasLayer = (self.layer == nil);
	if (!hasLayer) [self setWantsLayer:YES];
	[self setAnimations:@{@"subviews":[CATransition randomTransition]}];
	[self replaceSubview:oldView with:newView];
	if (!hasLayer) [self setWantsLayer:NO];
}
- (void) swapSubs:(NSV*)view {
	NSS* firstID = [self.firstSubview vFK:@"identifier"];
	[self.firstSubview fadeOut];
	[self removeAllSubviews];
	
	[view setHidden:YES];
	[self addSubview:view];
	[view setFrame:self.bounds];
	[view fadeIn];
	NSLog(@"Swapped subview: %@ for %@", firstID, view);
}



//-(void)setCenter:(NSPoint)center {
//	objc_setAssociatedObject(self, &ISANIMATED_KEY, NSPoiu numberWithBool:animated], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//-(NSPoint)center {
//   return [objc_getAssociatedObject(self, &ISANIMATED_KEY) boolValue];
//}

/*** A "layer backed NSView"
 1. can have subviews.  it is a normal view after all
 2. it uses a layer as "pixel backing storage", instead of the kind of storage views otherwise use.
 3. the backing layer of a NSView cannot have sublayers (there is no support for "layer hierarchies").
 
 NSView *layerBacked = [NSView new];
 [layerBacked setWantsLayer:YES];
 
 A "layer hosting" view
 1. cannot have subviews
 2. its sole purpose is to "host a layer"
 3. the layer it hosts can have sublayers and a very complex layer-tree-hierarchy.
 
 NSView *layerHosting = [NSView new];
 CALayer *layer = [CALayer new];
 [layerHosting setLayer:layer];
 [layerHosting setWantsLayer:YES];
 */
-(CALayer*) azLayer {

	CAL*l = nil;
	if (l = self.layer) return l;
	else { l = CAL.new; l.frame = self.bounds; l.arMASK = CASIZEABLE; self.layer = l; self.wantsLayer = YES; [l setNeedsDisplay]; return l; }
}
-(CALayer*) setupHostViewNamed:(NSS*)name {
	CAL *i = [self setupHostView];
	i.name = name;
	return i;
}
-(CAL*) setupHostViewNoHit {

	CAL *layer = [[CAL noHitLayer] objectBySettingValue:@"root" forKey:@"name"];
	[self setLayer:layer];
	[self setWantsLayer:YES];
	NSLog(@"setup NOHIT hosting layer:%@ in view: %@.  do not addsubviews to this view.  go crazy with layers.", layer.debugDescription, self);
	return layer;
}
//@synthesize  zLayer;

- (CAL*) zLayer {return self.setupHostView; }

-(CAL*) setupHostView { IF_RETURNIT(self.layer);

  CAL *l          = CAL.layer;
  self.layer      = l;
  self.wantsLayer = YES;
	return l;
//  XX(self.description);
//  XX(self.superviews);
//  XX(self.layer);
////	CALayer *layer = [CALayer layerNamed:@"root"];
//	layer.hostView = self;
//	layer.frame = [self bounds];
//	layer.position = [self center];
//	layer.bounds = [self bounds];
//	layer.needsDisplayOnBoundsChange = YES;
//	layer.backgroundColor = cgRANDOMCOLOR;
//	layer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
//	self.layer 			= layer;
//	self.wantsLayer 	= YES;
	//	NSLog(@"setup hosting layer:%@ in view: %@.  do not addsubviews to this view.  go crazy with layers.", layer.debugDescription, self);
}
- (id)firstSubview { return self.subviews.count ? self.subviews.first : nil; }
- (void) setFirstSubview: firstSubview {
  NSParameterAssert(ISA(firstSubview,NSV));
  self.subviews = [@[firstSubview] arrayByAddingAbsentObjectsFromArray:self.subviews];
}
- (id) lastSubview { return self.subviews.count ? self.subviews.last  : nil; }

- (void) setLastSubview:(NSV*)view { if ([self.subviews doesNotContainObject:view]) [self addSubview:view];

}

//Remove all the subviews from a view
- (void)removeAllSubviews;
{
  while (self.subviews.count) {
    id x = self.lastSubview;
    NSLog(@"%@: trying to remove subview (%@) %lu of %lu", self, [x className],
    [self.subviews indexOfObject:x], self.subviews.count);

    [x performSelectorOnMainThread:@selector(removeFromSuperview)];

  }
//  for (id v in self.subviews.reversed)
//	NSEnumerator* enumerator = [[self subviews] reverseObjectEnumerator];
//	NSV* view;

//	while (view = [enumerator nextObject])
//		[v removeFromSuperview];

}

//NSArray 	*subviews;  int		loop;
//subviews = [[self subviews] copy];
//for (loop = 0;loop < [subviews count]; loop++) {
//	[[subviews objectAtIndex:loop] removeFromSuperview];
//}
-(NSTrackingArea *)trackFullView {
	NSTrackingAreaOptions options =
	NSTrackingMouseEnteredAndExited
	| NSTrackingMouseMoved
	| NSTrackingActiveInKeyWindow
	| NSTrackingInVisibleRect ;
	NSTrackingArea *area = [NSTrackingArea.alloc initWithRect:NSMakeRect(0, 0, 0, 0)
																		 options:options
																			owner:self
																		userInfo:nil];
	[self addTrackingArea:area];
	return area;
}

-(NSTrackingArea *)trackAreaWithRect:(NSR)rect {
	return [self trackAreaWithRect:rect userInfo:nil];
}

-(NSTrackingArea *)trackAreaWithRect:(NSR)rect
									 userInfo:(NSD*)context
{
	NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited
	| NSTrackingMouseMoved
	| NSTrackingActiveInKeyWindow;
	NSTrackingArea *area = [NSTrackingArea.alloc initWithRect:rect
																		 options:options
																			owner:self
																		userInfo:context];
	[self addTrackingArea:area];
	return area;
}

-(BOOL)requestFocus {
	return [[self window] makeFirstResponder:self];
}

-(void)animate:(AZViewAnimationType)type {
	
	CALayer *touchedLayer;
	if  (self.layer) touchedLayer = self.layer;
	else { touchedLayer = [CALayer layer]; [self setLayer: touchedLayer]; [self setWantsLayer:YES];}
	touchedLayer.masksToBounds = NO;
	//	touchedLayer.anchorPoint = CGPointMake(.5,.5);
	// here is an example wiggle
	CABasicAnimation *wiggle = [CABasicAnimation animationWithKeyPath:@"transform"];
	wiggle.duration = 3;
	wiggle.timeOffset = RAND_FLOAT_VAL(0, 1);
	wiggle.repeatCount = HUGE_VALF;
	wiggle.autoreverses = YES;
	//	Rotate 't' by 'angle' radians about the vector '(x, y, z)' and return the result. If the vector has zero length the behavior is undefined: t' = rotation(angle, x, y, z) * t.
	//  Original signature is 'CATransform3D CATransform3DRotate (CATransform3D t, CGFloat angle, CGFloat x, CGFloat y, CGFloat z)'
	switch (type) {
		case AZViewAnimationTypeJiggle:
			wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(touchedLayer.transform,0.1, 0.0 ,1.0 ,2.0)];
			break;
		case AZViewAnimationTypeFlipHorizontally:
			wiggle.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(touchedLayer.transform,DEG2RAD(180), 1,0,0)];
		default:
			break;
	}
	// doing the wiggle
	[touchedLayer addAnimation:wiggle forKey:@"jiggle"];
	
	// setting a timer to remove the layer
	//	NSTimer *wiggleTimer = [NSTimer scheduledTimerWithTimeInterval:(2) target:self selector:@selector(endWiggle:) userInfo:touchedLayer repeats:NO];
	
}

-(void)stopAnimating{
	//:(NSTimer*)timer {
	// stopping the wiggle now
	[self.layer removeAllAnimations];
}
- (void)resizeFrameBy:(int)value {
	NSR frame = [self frame];
	[[self animator]setFrame:CGRectMake(frame.origin.x,
													frame.origin.x,
													frame.size.width + value,
													frame.size.height + value
													)];
}


- (NSA*)animationArrayForParameters:(NSD*)params
{
	NSMutableDictionary *animationDetails = [NSMutableDictionary
														  dictionaryWithDictionary:params];
	animationDetails[NSViewAnimationTargetKey] = self;
	return @[animationDetails];
}
+ (NSViewAnimation*) animationWithDefaultsWithAnimations:(NSA*)anis {

	NSVA *ani                   = [NSVA.alloc initWithViewAnimations:anis];
	ani.animationBlockingMode 	= AZDefaultAnimationBlockingMode;
	ani.duration                = AZDefaultAnimationDuration;
	ani.animationCurve          = AZDefaultAnimationCurve;
	return ani;
}
- (void)playAnimationWithParameters:(NSD*)params	{

	NSViewAnimation *animation = [self.class animationWithDefaultsWithAnimations:[self animationArrayForParameters:params]];
	[animation setDelegate:(id)self];
	[animation startAnimation];
}
- (void) fadeOutAndThen:(void(^)(NSAnimation*))block {
	NSViewAnimation *animation = [self.class animationWithDefaultsWithAnimations: [self animationArrayForParameters:
																	 @{ NSViewAnimationEffectKey: NSViewAnimationFadeOutEffect}]];
	A2DynamicDelegate *d  		= [A2DynamicDelegate.alloc initWithProtocol:@protocol(NSAnimationDelegate)];
//	 animation.dynamicDelegate;
	[d implementMethod:@selector(animationDidEnd:) withBlock:block];
	animation.delegate 			= (id<NSAnimationDelegate>)d;
	objc_setAssociatedObject(self, _cmd, d, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	[animation startAnimation];
}

- (void)fadeWithEffect:effect	{ [self playAnimationWithParameters:@{	NSViewAnimationEffectKey: effect}];	}
- (void)fadeOut               {

  self.layer ? [self.layer fadeOut] : [self fadeWithEffect:NSViewAnimationFadeOutEffect];
}
- (void)fadeIn                {

  //[self.subviews makeObjectsPerformSelector:_cmd];
  self.layer ? [self.layer fadeIn] : [self fadeWithEffect:NSViewAnimationFadeInEffect];
}

- (void)animateToFrame:(NSR)n	{ [self playAnimationWithParameters:@{	NSViewAnimationEndFrameKey: AZVrect(n)}];	}
- (void)fadeToFrame:(NSR)n		{ [self playAnimationWithParameters:@{	NSViewAnimationEndFrameKey: AZVrect(n),
																						 	NSViewAnimationEffectKey  : self.isHidden ?
		  																				 NSViewAnimationFadeInEffect : NSViewAnimationFadeOutEffect}];
}
+ (void)setDefaultDuration:(NSTimeInterval)duration				{	AZDefaultAnimationDuration = duration;	}
+ (void)setDefaultBlockingMode:(NSAnimationBlockingMode)mode	{	AZDefaultAnimationBlockingMode = mode;	}
+ (void)setDefaultAnimationCurve:(NSAnimationCurve)curve			{	AZDefaultAnimationCurve = curve;			}

- (NSImage *) snapshot { return [self snapshotFromRect:[self frame]]; }

//  This method creates a new image from a portion of the receiveing view.
- (NSImage *) snapshotFromRect:(NSR) sourceRect; {
	NSImage *snapshot = [NSImage.alloc initWithSize:sourceRect.size];
	[self lockFocus];
	NSBitmapImageRep *rep = [NSBitmapImageRep.alloc initWithFocusedViewRect:sourceRect];
	[self unlockFocus];
	[snapshot addRepresentation:rep];
	return snapshot;
}
+ (void)animateWithDuration:(NSTI)duration
						animation:(void(^)(void))animationBlock	{ [self animateWithDuration:duration animation:animationBlock completion:nil];	}
+ (void)animateWithDuration:(NSTI)duration
						animation:(void(^)(void))animationBlock
					  completion:(void(^)(void))completionBlock
{
	[NSAnimationContext beginGrouping];
	NSAnimationContext.currentContext.duration = duration;
	animationBlock();
	[NSAnimationContext endGrouping];
	if(completionBlock)	{
		id completionBlockCopy = [completionBlock copy];
		[self performSelector:@selector(runEndBlock:) withObject:completionBlockCopy afterDelay:duration];
	}
}
+ (void)runEndBlock:(void (^)(void))completionBlock	{	completionBlock();	}

/////[i convertPoint: [[i window] convertScreenToBase:[NSEvent mouseLocation]] fromView: nil ]
- (NSP) windowPoint 	{
	NSP globalLocation 	= NSE.mouseLocation;
	NSP windowLocation 	= [self.window convertScreenToBase:globalLocation];
	NSP viewLocation 		= [self convertPoint: windowLocation fromView: nil];
	return viewLocation;
}
- (NSP) localPoint	{ return [self convertPoint: [self.window convertScreenToBase:mouseLoc()] fromView:nil];
	//								[NSEvent mouseLocation]] fromView: nil ]
}

- (void) handleMouseEvent:(NSEventType)type withBlock:(void (^)())block  {
	[NSEVENTLOCALMASK:NSEventMaskFromType(type) handler:^NSE*(NSE *e) {
		NSP __unused localP = self.localPoint;
//		[self setNeedsDisplay:YES];		NSLog(@"oh my god.. point %@", NSStringFromPoint(localP));
		if (e.type == type ) {//if ( NSPointInRect(localP, view.frame) ){
			NSLog(@"oh my god.. point is local to view: %@! Localpoint: %@...  about to run block !!". self.description, [self localPoint]);
			[NSThread.mainThread performBlock:block waitUntilDone:YES]; // [NSThread performBlockInBackground:block];
		}
		return e;
	}];
	return;
}


- (CAL*) hitTestLayer { return [self.layer hitTest:self.windowPoint]; }

@end
void AZMoveView(NSV* view, CGF dX, CGF dY) {
	NSR frame = [view frame] ;
	frame.origin.x += dX ;
	frame.origin.y += dY ;
	[view setFrame:frame] ;
}
void AZResizeView(NSV* view, CGF dX, CGF dY) {
	NSR frame = [view frame] ;
	frame.size.width += dX ;
	frame.size.height += dY ;
	[view setFrame:frame] ;
}
void AZResizeViewMovingSubviews(NSV* view, CGF dXLeft, CGF dXRight, CGF dYTop, CGF dYBottom) {
	AZResizeView(view, dXLeft + dXRight, dYTop + dYBottom) ;
	
	NSArray* subviews = [view subviews] ;
	NSEnumerator* e ;
	NSV* subview ;
	
	// If we wanted to change the "left", move all existing subviews to the right
	if (dXLeft != 0.0) {
		e = [subviews objectEnumerator] ;
		while ((subview = [e nextObject])) {
			AZMoveView(subview, dXLeft, 0.0) ;
		}
	}
	
	// If we wanted to change the "bottom", move all existing subviews up
	if (dYBottom != 0.0) {
		e = [subviews objectEnumerator] ;
		while ((subview = [e nextObject])) {
			AZMoveView(subview, 0.0, dYBottom) ;
		}
	}
	[view display] ;
}

NSV* AZResizeWindowAndContent(NSWindow* window, CGF dXLeft, CGF dXRight, CGF dYTop, CGF dYBottom, BOOL moveSubviews) {
	NSV* view = [window contentView] ;
	if (moveSubviews)
		AZResizeViewMovingSubviews(view, dXLeft, dXRight, dYTop, dYBottom) ;
	else
		AZResizeView(view, dXLeft + dXRight, dYTop + dYBottom) ;
	NSR frame = [window frame] ;
	frame.size.width += (dXLeft + dXRight) ;
	frame.size.height += (dYTop + dYBottom) ;
	// Since window origin is at the bottom, and we want  the bottom to move instead of the top, we also adjust the origin.y
	frame.origin.y -= (dYTop + dYBottom) ;
	// since screen y is measured from the top, we have to	subtract instead of add
	[window setFrame:frame display:YES] ;
	return view ;  // because often this is handy
}

@implementation NSView (Layout)


- (void) setBottom:(CGF)t duration:(NSTI)time
{
	[NSAnimationContext runAnimationBlock:^{	NSR frame = self.frame;	frame.origin.y = t;
		[[self animator] setFrame:frame]; }
							  completionHandler:nil	duration: time];
}

- (void) setTop:(CGF)t duration:(NSTI)time; {
	
}
- (void) setCenterY:(CGF)t duration:(NSTI)time {}

- (void)deltaX:(CGF)dX
		  deltaW:(CGF)dW {
	NSR frame = [self frame] ;
	frame.origin.x += dX ;
	frame.size.width += dW ;
	[self setFrame:frame] ;
}

- (void)deltaY:(CGF)dY
		  deltaH:(CGF)dH {
	NSR frame = [self frame] ;
	frame.origin.y += dY ;
	frame.size.height += dH ;
	[self setFrame:frame] ;
}

- (void)deltaX:(CGF)dX {
	[self deltaX:dX
			deltaW:0.0] ;
}

- (void)deltaY:(CGF)dY {
	[self deltaY:dY
			deltaH:0.0] ;
}

- (void)deltaW:(CGF)dW {
	[self deltaX:0.0
			deltaW:dW] ;
}

- (void)deltaH:(CGF)dH {
	[self deltaY:0.0
			deltaH:dH] ;
}
- (void)sizeHeightToFitAllowShrinking:(BOOL)allowShrinking {
	float oldHeight = [self height] ;
	float width = [self width] ;
	float height ;
	if ([self isKindOfClass:[NSTextView class]]) {
		NSAttributedString* attributedString = [(NSTextView*)self textStorage] ;
		if (attributedString != nil) {
			height = [attributedString heightForWidth:width] ;
		}
		else {
			NSFont* font = [(NSTextView*)self font] ;
			/* According to Douglas Davidson, http://www.cocoabuilder.com/archive/message/cocoa/2002/2/13/66379,
			 "The default font for text that has no font attribute set is 12-pt Helvetica."
			 So, we make that interpretation... */
			if (font == nil)				font = [NSFont fontWithName:@"Helvetica" size:12] ;
			height = [[(NSTextView*)self string] heightForWidth:width	font:font] ;
		}
		NSR frame = [self frame] ;
		frame.size.height = allowShrinking ? height : MAX(height, oldHeight) ;
		[self setFrame:frame] ;
	}
	else if ([self isKindOfClass:[NSTextField class]]) {
		gNSStringGeometricsTypesetterBehavior = NSTypesetterBehavior_10_2_WithCompatibility ;
		height = [[(NSTextField*)self stringValue] heightForWidth:width	font:[(NSTextView*)self font]] ;
		NSR frame = [self frame] ;
		frame.size.height = allowShrinking ? height : MAX(height, oldHeight) ;
		[self setFrame:frame] ;
	}
	else {
		// Subclass should have set height to fit
	}
	// Clip if taller than screen
	float screenHeight = [[NSScreen mainScreen] frame].size.height ;
	if ([self height] > screenHeight) {	NSR frame = [self frame] ;	frame.size.height = screenHeight ;	[self setFrame:frame] ;	}
}

- (NSComparisonResult)compareLeftEdges:(NSV*)otherView {
	float myLeftEdge = [self x] ;
	float otherLeftEdge = [otherView x] ;
  return myLeftEdge < otherLeftEdge ? NSOrderedAscending  : myLeftEdge > otherLeftEdge ? NSOrderedDescending  : NSOrderedSame;
}

// The normal margin of "whitespace" that one leaves at the bottom of a window

#define BOTTOM_MARGIN 20.0

- (void)sizeHeightToFit {
	CGFloat minY = 0.0 ;
	for (NSV* subview in [self subviews]) {
		minY = MIN([subview frame].origin.y - BOTTOM_MARGIN, minY) ;
	}
	
	// Set height so that minHeight is the normal window edge margin of 20
	CGFloat deltaH = -minY ;
	NSR frame = [self frame] ;
	frame.size.height += deltaH ;
	[self setFrame:frame] ;
	
	// Todo: Set width similarly
}

@end

@implementation  NSScrollView (Notifications)

- (void) performBlockOnScroll:(void (^)(void))block {
	[self setPostsBoundsChangedNotifications:YES];
	
	[AZNOTCENTER addObserver:self keyPath:NSViewBoundsDidChangeNotification options:0 block:^(MAKVONotification *notification) {
		block();
	}];
	//	addObserver:self selector:@selector(boundsDidChange:) name:NSViewBoundsDidChangeNotification object:contentView];
}
- (BOOL) autoScrollToBottom {  return [self associatedValueForKey:@"autoScroll"]; }

#define AUTOSCROLL_CATCH_SIZE 	20	//The distance (in pixels) that the scrollview must be within (from the bottom) for auto-scroll to kick in.
- (void)setAutoScrollToBottom:(BOOL)inValue
{
	[self setAssociatedValue:@(inValue) forKey:@"autoScroll" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
	//Observe the document view's frame changes
   if (inValue) [AZNOTCENTER removeObserver:self name:NSViewFrameDidChangeNotification object:nil];
	else  [AZNOTCENTER observeTarget:self.documentView keyPath:NSViewFrameDidChangeNotification options:nil block:^(MAKVONotification *notification) {
		//	:self.documentView keyPath:NSViewFrameDidChangeNotification options:nil block:^(MAKVONotification *notification) {
					 [self scrollToBottom];
	}];
}

//When our document resizes
//- (void)documentFrameDidChange:(NSNotification *)notification
//{
//	//We guard against a recursive call to this method, which may occur if the user is resizing the view at the same time
//	//content is being modified
//    if (autoScrollToBottom && !inAutoScrollToBottom) {
//        NSRect	documentVisibleRect =  [self documentVisibleRect];
//        NSRect	   newDocumentFrame = [[self documentView] frame];
//        
//        //We autoscroll if the height of the document frame changed AND (Using the old frame to calculate) we're scrolled close to the bottom.
//        if ((newDocumentFrame.size.height != oldDocumentFrame.size.height) && 
//		   ((documentVisibleRect.origin.y + documentVisibleRect.size.height) > (oldDocumentFrame.size.height - AUTOSCROLL_CATCH_SIZE))) {
//			inAutoScrollToBottom = YES;
//            [self scrollToBottom];
//			inAutoScrollToBottom = NO;
//        }
//    
//        //Remember the new frame
//        oldDocumentFrame = newDocumentFrame;
//    }
//}

- (void) scrollToTop    { [self.documentView scrollPoint:NSZeroPoint]; } //Scroll to the top of our Doc view
- (void) scrollToBottom { [self.documentView scrollPoint:NSMakePoint(0, 1000000)]; } //Scroll to the bottom of our Doc view

@end

@implementation NSTableView (Scrolling)

- (void)scrollRowToTop:(NSInteger)row {
	if ((row != NSNotFound) && (row >=0)) {
		CGFloat rowPitch = [self rowHeight] + [self intercellSpacing].height ;
		CGFloat y = row * rowPitch ;
		[self scrollPoint:NSMakePoint(0, y)] ;
	}
}
@end
@implementation NSView (findSubview)

- (NSA*)  findSubviewsOfKind:(Class)kind withTag:(NSI)tag inView:(NSV*)v {

  return [v.subviews reduce:!kind || ISA(v,kind) && (tag==NSNotFound || v.tag==tag) ?  @[v] : @[] withBlock:^id(id sum, id obj) {
		return [sum arrayByAddingObjectsFromArray:[self findSubviewsOfKind:kind withTag:tag inView:obj]];
  }];
}

- (id) firstSubviewOfClass:(Class)k                     {
	__block NSV* v;
	[self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		 id x = [obj isKindOfClass:k] ? obj : [obj firstSubviewOfClass:k];
		 if (!x) return; v = x; *stop = YES;
	}];
	return v;
}
- (NSA*)     subviewsOfClass:(Class)k                     {
	return [self.subviews filter:^BOOL(id object) {
		return [object isKindOfClass:k];
	}];
}
- (NSA*)      subviewsOfKind:(Class)kind withTag:(NSI)tag {
	return [self findSubviewsOfKind:kind withTag:tag inView:self];
}
- (NSA*)      subviewsOfKind:(Class)kind                  {
	return [self findSubviewsOfKind:kind withTag:NSNotFound inView:self];
}
- (id)  firstSubviewOfKind:(Class)kind withTag:(NSI)tag {
	return [self findSubviewsOfKind:kind withTag:tag inView:self][0];
}
- (id)  firstSubviewOfKind:(Class)kind                  {
	return [self firstSubviewOfKind:kind withTag:NSNotFound];
}
@end

@implementation NSAnimationContext (AtoZ)

+ (void)runAnimationBlock:(dispatch_block_t)group
        completionHandler:(dispatch_block_t)completionHandler
					       duration:(NSTI)time
                    eased:(CAMTF*)timing {
	// run animation
	[NSAnimationContext beginGrouping];
	NSAnimationContext.currentContext.duration = time;
	NSAnimationContext.currentContext.timingFunction = timing;
	group();
	[NSAnimationContext endGrouping];
	
	if (completionHandler)
	{// block delay
		dispatch_time_t popTime = dispatch_time( DISPATCH_TIME_NOW, (double)time * NSEC_PER_SEC);
		dispatch_after( popTime, dispatch_get_main_queue(), completionHandler );
	}
}

+ (void)runAnimationBlock:(dispatch_block_t)group
		    completionHandler:(dispatch_block_t)completionHandler
					       duration:(NSTI)time     {
	// run animation
	
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:time];
	group();
	[NSAnimationContext endGrouping];
	
	if (completionHandler) {
		// block delay
		dispatch_time_t popTime = dispatch_time( DISPATCH_TIME_NOW, (double)time * NSEC_PER_SEC);
		dispatch_after( popTime, dispatch_get_main_queue(), completionHandler );
	}
}
@end

@interface      COICOPopoverView : AZSimpleView @end
@implementation COICOPopoverView
- (void)drawRect:(NSR)aRect {
	self.backgroundColor = self.backgroundColor ?: [NSColor controlBackgroundColor];
	NSG *gradient = [NSG.alloc initWithStartingColor:self.backgroundColor  endingColor:NSC.controlBackgroundColor];
	[gradient drawInBezierPath:[NSBP bezierPathWithRoundedRect:self.bounds xRadius:5 yRadius:6] angle:270.0];
	[super drawRect:aRect];
}
@end

@implementation NSPopover (Message)

+ (void) showRelativeToRect:(NSR)rect ofView:(NSV*)view preferredEdge:(NSRectEdge)edge string:(NSS*)string maxWidth:(float)width {
	
	[NSPopover showRelativeToRect:rect ofView:view preferredEdge:edge string:string backgroundColor:NSC.controlBackgroundColor maxWidth:width];
}
+ (void) showRelativeToRect:(NSR)rect ofView:(NSV*)view preferredEdge:(NSRectEdge)edge string:(NSS*)string backgroundColor:(NSC*)bg maxWidth:(float)width {
	
	[NSPopover showRelativeToRect:rect ofView:view  preferredEdge:edge string:string backgroundColor:bg
					  foregroundColor:NSColor.controlTextColor	font:[NSFont systemFontOfSize:NSFont.systemFontSize] maxWidth:width];
}
+ (void) showRelativeToRect:(NSR)rect ofView:(NSV*)view preferredEdge:(NSRectEdge)edge
                                                               string:(NSS*)string
                                                      backgroundColor:(NSC*)bg
                                                      foregroundColor:(NSC*)fg
                                                                 font:(NSFont*)font
                                                             maxWidth:(float)width {
  [NSPopover showRelativeToRect:rect ofView:view preferredEdge:edge
               attributedString:[NSMAS.alloc initWithString:string attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName:fg}]
                backgroundColor:bg
                       maxWidth:width];
}
+ (void) showRelativeToRect:(NSR)rect ofView:(NSV*)view preferredEdge:(NSRectEdge)edge
                                                     attributedString:(NSAS*)attributedString
                                                      backgroundColor:(NSC*)backgroundColor
                                                             maxWidth:(float)width {
	
	float padding = 15;
	
	NSR containerRect = [attributedString boundingRectWithSize:NSMakeSize(width, 0) options:NSStringDrawingUsesLineFragmentOrigin];
	containerRect.size.width = containerRect.size.width *= (25/(containerRect.size.width+2)+1);
	NSSize size = containerRect.size;
	NSSize popoverSize = NSMakeSize(containerRect.size.width + (padding * 2), containerRect.size.height + (padding * 2));
	
	containerRect = NSMakeRect(0, 0, popoverSize.width, popoverSize.height);
	
	NSTXTF *label = [NSTXTF.alloc initWithFrame:(NSR){padding, padding, size.width, size.height}];
	label.bezeled 					 = NO;
	label.drawsBackground  		 = NO;
	label.editable					 = NO;
	label.selectable				 = NO;
	label.attributedStringValue = attributedString;
	[(NSTextFieldCell*)label.cell setLineBreakMode: NSLineBreakByWordWrapping];
	
	COICOPopoverView *container = [COICOPopoverView.alloc initWithFrame:containerRect];
	
	container.bgC					 = backgroundColor;
	container.subviews 			 = @[label];
	label.bounds					 = NSMakeRect(padding, padding, size.width, size.height);
	[container awakeFromNib];
	NSVC *controller 				 = NSViewController.new;
	controller.view 				 = container;
	NSPopover *popover 			 	= NSPopover.new;
	popover.contentSize				= popoverSize;
	popover.contentViewController = controller;
	popover.animates					= YES;
	popover.behavior					= NSPopoverBehaviorTransient;
	[popover showRelativeToRect:rect ofView:view preferredEdge:edge];
}
@end

@interface AZRBLPopBack :RBLPopoverBackgroundView @end
@implementation AZRBLPopBack
- (CGPathRef)newPopoverPathForEdge:(CGRectEdge)popoverEdge inFrame:(CGRect)frame {
	CGF tailArea = .4 * AZMaxDim( frame.size );
	CGR box 	= popoverEdge == CGRectMaxXEdge ? AZRectTrimmedOnLeft  (	frame, tailArea) 
				: popoverEdge == CGRectMaxYEdge ? AZRectTrimmedOnTop   (	frame, tailArea)
				: popoverEdge == CGRectMinYEdge ? AZRectTrimmedOnBottom( frame, tailArea)
				: 											 AZRectTrimmedOnRight  (	frame, tailArea);
	NSR edgeRect = AZRectInsideRectOnEdge(AZRectFromDim(tailArea), frame, AZPosAtCGRectEdge(popoverEdge));
	NSBP * tail = [NSBezierPath bezierPathWithTriangleInRect:edgeRect orientation:popoverEdge];
	NSBP * Boxpath = [NSBezierPath bezierPathWithRect:box];
	NSBP * __unused unionp = [Boxpath az_intersect:tail];
	NSBP *pp = [DKShapeFactory arrowTailFeatherWithRake:.4];
	pp = [pp scaledToFrame:box];
	return  pp.quartzPath;

}
@end
@implementation RBLPopover (AtoZ)
+ (void) showRelativeTo:(NSR)r ofView:(NSV*)v edge:(NSRectEdge)edge string:(NSS*)s bg:(NSC*)bg size:(NSSZ)sz {

	
	float padding = 15;
	
	NSAS *as = 	[NSAS.alloc initWithString:s attributes:@{NSFontAttributeName: AtoZ.controlFont, NSForegroundColorAttributeName: bg.contrastingForegroundColor }];

	NSR containerRect = [as boundingRectWithSize:NSMakeSize(sz.width, 0) options:NSStringDrawingUsesLineFragmentOrigin];
	containerRect.size.width = containerRect.size.width *= (25/(containerRect.size.width+2)+1);
	NSSize size = containerRect.size;
	NSSize popoverSize = NSMakeSize(containerRect.size.width + (padding * 2), containerRect.size.height + (padding * 2));
	
	containerRect = NSMakeRect(0, 0, popoverSize.width, popoverSize.height);
	
	NSTXTF *label = [NSTXTF.alloc initWithFrame:(NSR){padding, padding, size.width, size.height}];
	label.bezeled 					 = NO;
	label.drawsBackground  		 = NO;
	label.editable					 = NO;
	label.selectable				 = NO;
	label.attributedStringValue = as;
	[(NSTextFieldCell*)label.cell setLineBreakMode: NSLineBreakByWordWrapping];
	
	COICOPopoverView *container = [COICOPopoverView.alloc initWithFrame:containerRect];
	
	container.bgC					 = bg;
	container.subviews 			 = @[label];
	label.bounds					 = NSMakeRect(padding, padding, size.width, size.height);
	[container awakeFromNib];
	NSVC *controller 				 = NSViewController.new;
	controller.view 				 = container;
	
	RBLPopover *popover = [RBLPopover.alloc initWithContentViewController:controller];
//	popover.backgroundViewClass   = AZRBLPopBack.class;
//	popover.backgroundView = [AZRBLPopBack.alloc initWithFrame:
//    AZRectFromSize(popoverSize)];

//  popoverEdge:edge
//                                                 originScreenRect:AZScreenFrame()];
	popover.contentSize				= popoverSize;
	popover.contentViewController = controller;
	popover.animates					= YES;
	popover.behavior					= RBLPopoverBehaviorTransient;
	[popover showRelativeToRect:r ofView:v preferredEdge:edge];

//	[popover showRelativeToRect:rect ofView:view preferredEdge:edge];
}
@end

//#import <DrawKit/DKShapeFactory.h>
//@interface NSView ()+ (void)runEndBlock:(void (^)(void))completionBlock;@end
//		SEL sel = @selector(mouseDown:);void (*superIMP)(id, SEL, NSE*) = [_self az_superForSelector:sel];superIMP(_self, sel, e);


//  NSR r             = self.frame;                   // establish frame
//  NSView *oldSuper  = self.superview ?: self;       // if superview doesnt exist, use self.
//  BOOL selfIsSuper  = [oldSuper isEqual:self];      // are we super?
//  id firstSub = oldSuper == self ? self : ;
//  XX(firstSub);
//  XX(newSplt);
//  XX(oldSuper.superviews);
//  XX(oldSuper.subviews);
//  XX(oldSuper.layer);
//  [firstSub swa];
//	[newSplt performSelector:@selector(addSubview:) withObject:];
//  [newSplt performSelector:@selector(addSubview:) withObject:];
//	newSplt.autoresizingMask 	= NSSIZEABLE;// ((NSV*)newSplt.subviews[0]).arMASK = ((NSV*)newSplt.subviews[1]).arMASK = NSSIZEABLE;
//  [oldSuper performSelectorOnMainThread:@selector(addSubview:) withObject:newSplt waitUntilDone:YES];

//- (NSManagedObjectContext*)managedObjectContext { return [((NSObject*)[[self.window windowController] document]) managedObjectContext]; }
//#import "CALayer+AtoZ.h"
//#import "AtoZGeometry.h"

