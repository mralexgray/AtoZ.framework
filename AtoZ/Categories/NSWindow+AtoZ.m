
#import "AtoZ.h"
#import "NSWindow+AtoZ.h"

@interface NSApplication (Undocumented) - (NSA*)_orderedWindowsWithPanels:(BOOL)panels; @end

JREnumDefine(NSWindowResize);
id(^findWin)(NSP) = ^id(NSP p){	NSA* windows; 

	return windows = [[NSApp _orderedWindowsWithPanels:YES] filter:^BOOL(id o){ 
		return NSPointInRect(p, [o frame]); 	}] ? windows[0] : (id)nil; 										
};

@implementation NSAnimationContext (Blocks)
+ (void)groupWithDuration:(NSTI)dur
   timingFunctionWithName:(NSS*)timing
        completionHandler:(VBlk)handler
           animationBlock:(VBlk)aniBlock        {
	[NSACTX beginGrouping];
  //	currently supported names are `linear', `easeIn', `easeOut' and`easeInEaseOut' and `default' (the curve used by implicit animations
	CAMTF *d = ISA(timing,NSS) ? [CAMTF functionWithName:timing] : CAMEDIAEASY;
	[NSACTX.currentContext setDuration:dur];
	[NSACTX.currentContext setCompletionHandler:handler];
	[NSACTX.currentContext setTimingFunction:d];	aniBlock();
	[NSACTX endGrouping];
}
+ (void)groupWithDuration:(NSTI)dur
        completionHandler:(VBlk)handler
           animationBlock:(VBlk)aniBlock        { [self groupWithDuration:dur timingFunctionWithName:nil completionHandler:handler animationBlock:aniBlock]; }
+ (void)groupWithDuration:(NSTI)duration
           animationBlock:(VBlk)animationBlock  {
	[self groupWithDuration:duration completionHandler:nil animationBlock:animationBlock];
}
@end

@implementation NSWindow (SBSWindowAdditions)	

static BOOL	gWindowTrackingEnabled = NO, gWindowTracking = NO;
static  NSP gWindowTrackingEventOrigin, 	gWindowTrackingCurrentWindowOrigin;

+ (BOOL) isLiveFrameTracking              {	return gWindowTrackingEnabled;	}
+ (void) setLiveFrameTracking:(BOOL) bol	{	gWindowTrackingEnabled = bol;	// we have to use global variables (polluting global namespace)
	bol ? [AZNOTCENTER addObserver:self selector:@selector(willMove:) name:NSWindowWillMoveNotification object:nil] 
		: ^{ gWindowTracking = NO;	// getting informed as soon as any window is dragged
	 		[AZNOTCENTER removeObserver:self name:NSWindowWillMoveNotification object:nil]; // like this, applications can interrupt even ongoing frame tracking
		}();			
}
+ (void) willMove:   (id)note		{
	gWindowTracking = YES;                                // the loop condition during tracking
	gWindowTrackingEventOrigin = NSEvent.mouseLocation;		// most accurate (somethings wrong with NSLeftMouseDragged events and their deltaX)
	[NSThread detachNewThreadSelector:@selector(windowMoves:) toTarget:(NSWindow*)((NSNotification*)note).object withObject:note];
	// creating a new thread that is doing the monitoring of mouse movement
}
- (void) windowMoves: note		{   @autoreleasepool {        // remember, we are in a new thread!
		NSRect startFrame = self.frame;                           // where was the window prior to dragging
		gWindowTrackingCurrentWindowOrigin = startFrame.origin;		// where is it now
		while (gWindowTracking) {                                 // polling for the mouse position until gWindowTracking is NO (see windowMoved:)
			gWindowTrackingCurrentWindowOrigin.x = startFrame.origin.x + NSEvent.mouseLocation.x - gWindowTrackingEventOrigin.x;
			gWindowTrackingCurrentWindowOrigin.y = startFrame.origin.y + NSEvent.mouseLocation.y - gWindowTrackingEventOrigin.y;
			// calculating the current window frame accordingly (size won't change)
			[self performSelectorOnMainThread:@selector(windowMoved:) withObject:note waitUntilDone:YES];
      /*! @note lets do the main job on the main thread, particularly important for querying the event stack 
          for the mouseUp event signaling the end of the dragging and posting the new event */
		}
	}	// thread is dying, so we clean up
}
- (void) windowMoved: note		{						// to be performed on the main thread

	if (!NSEqualPoints(gWindowTrackingCurrentWindowOrigin, _frame.origin)) {
		// _frame is the private variable of an NSWindow, we have full access (category!)
		_frame.origin = gWindowTrackingCurrentWindowOrigin;		// setting the private instance variable so obersers of the windowDidMove notification
		// can retrieve the current position by calling [[notification object] frame].
		// The REAL setting of the frame will be done by the window server at the end of the drag
		[AZNOTCENTER postNotificationName:NSWindowDidMoveNotification object:self];
		// post the NSWindowDidMoveNotification (only if a move actually occured)
	}
	if ([NSApp nextEventMatchingMask:NSLeftMouseUpMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:NO]) {
  /*! checking for an NSLeftMouseUp event that would indicate the end of the dragging and set the looping condition accordingly.
      @warning MUY IMPORTANTE: we have to do this on the main thread!!! */
      
      gWindowTracking = NO; 
	}
}
@end	  
@implementation NSWindow (Resize)
- (void) resizeToWidth:(CGF)wide height:(CGF)high 														{
	[self resizeToWidth:wide height:high origin:NSWindowResizeBottomLeftCorner];
}
- (void) resizeToWidth:(CGF)wide height:(CGF)high origin:(NSWindowResize)ori 					{
	[self resizeToWidth:wide height:high origin:ori duration:0.5];
}
- (void) resizeToWidth:(CGF)wide height:(CGF)high origin:(NSWindowResize)ori duration:(NSTI)dur {

	float currentWidth    = self.width;
	float currentHeight 	= self.height;
	float originX         = self.x;
	float originY         = self.y;

	switch (ori) {
		case NSWindowResizeTopLeftCorner:   originY = originY + currentHeight - high;		break;
		case NSWindowResizeTopRightCorner:	originY = originY + currentHeight - high;
													originX = originX + currentWidth - wide;		break;
		case NSWindowResizeBottomRightCorner:	originX = originX + currentWidth - wide;		break;
		case NSWindowResizeBottomLeftCorner:														break; default: break;//	Does nothing
	}
	NSVA *viewAnimation = [NSVA.alloc initWithViewAnimations: @[@{NSViewAnimationTargetKey:self, NSViewAnimationEndFrameKey:AZVrect(NSMakeRect( originX, originY,wide,high))}]];
	[viewAnimation setAnimationBlockingMode:NSAnimationBlocking];
	[viewAnimation setDuration:dur];
	[viewAnimation startAnimation];
}
@end 	  

@implementation NSWindow (NoodleEffects)
- (void) animateToFrame:(NSR)f duration:(NSTI)d	{

	NSVA	 *animation = 
	[NSViewAnimation.alloc initWithViewAnimations: @[@{NSViewAnimationTargetKey: self,NSViewAnimationEndFrameKey: AZVrect(f)}]];
	[animation setDuration:d];
	[animation setAnimationBlockingMode:NSAnimationBlocking];
	[animation setAnimationCurve:NSAnimationLinear];
	[animation startAnimation];
}
- (NSW*)      _createZoomWindowWithRect:(NSR)r  {	NSWindow		*zoomWindow;	NSImageView	*imageView;

	NSR frame = self.frame; BOOL isOneShot = self.isOneShot; isOneShot ? [self setOneShot:NO] : nil;

	[self windowNumber] <= 0 ? ^{
		// Force creation of window device by putting it on-screen. We make it transparent to minimize the chance of visible flicker.
		CGFloat alpha = self.alphaValue;
		[self setAlphaValue:0.0];
		[self orderBack:self];
		[self orderOut:self];
		[self setAlphaValue:alpha];
	}() : nil;
	NSImage *image = [NSImage.alloc initWithSize:frame.size];
	[image lockFocus];	// Grab the window's pixels
	NSCopyBits(self.gState, NSMakeRect(0.0, 0.0, frame.size.width, frame.size.height), NSZeroPoint);
	[image unlockFocus];
	[image setDataRetained:YES];
	[image setCacheMode:NSImageCacheNever];
	zoomWindow = [NSW.alloc initWithContentRect:r styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	[zoomWindow setBackgroundColor:[NSColor colorWithDeviceWhite:0.0 alpha:0.0]];
	[zoomWindow setHasShadow:[self hasShadow]];
	[zoomWindow setLevel:[self level]];
	[zoomWindow setOpaque:NO];
	[zoomWindow setReleasedWhenClosed:YES];
	[zoomWindow useOptimizedDrawing:YES];
	imageView = [NSImageView.alloc initWithFrame:[zoomWindow contentRectForFrameRect:frame]];
	[imageView setImage:image];
	[imageView setImageFrameStyle:NSImageFrameNone];
	[imageView setImageScaling:NSScaleToFit];
	[imageView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	[zoomWindow setContentView:imageView];

	[self setOneShot:isOneShot];	// Reset one shot flag
	return zoomWindow;
}
- (void) zoomOnFromRect:(NSR)startRect								{
	NSRect			  frame;
	NSWindow			*zoomWindow;
	if ([self isVisible])	return;
	frame = [self frame];
	zoomWindow = [self _createZoomWindowWithRect:startRect];
	[zoomWindow orderFront:self];
	[zoomWindow animateToFrame:frame duration:[zoomWindow animationResizeTime:frame] * 0.4];
	[self makeKeyAndOrderFront:self];
	[zoomWindow close];
}
- (void)  zoomOffToRect:(NSR)endRect								{
	NSRect  frame = [self frame];
	if (![self isVisible]) return;
	NSWindow *zoomWindow = [self _createZoomWindowWithRect:frame];
	[zoomWindow orderFront:self];
	[self orderOut:self];
	[zoomWindow animateToFrame:endRect duration:[zoomWindow animationResizeTime:endRect] * 0.4];
	[zoomWindow close];
}	
@end

@implementation NSResponder (AtoZ) // @dynamic performKeyEquivalent;

- (void) overrideResponder:(SEL)sel withBool:(BOOL)acc  { AZSTATIC_OBJ(NSMA,alreadyDone,NSMA.new);

  NSString *selString = NSStringFromSelector(sel); [self triggerKVO:selString block:^(id _self) {

    [alreadyDone doesNotContainObject:selString] ?
    [self az_overrideSelector:sel withBlock:(__bridge void *)^BOOL(id z){ return [objc_getAssociatedObject(z, sel) bV]; }],
    [alreadyDone addObject:selString] : nil;

    objc_setAssociatedObject(_self, sel, @(acc), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }];
}
- (void)            setAcceptsFirstResponder:(BOOL)x    { [self overrideResponder:@selector(acceptsFirstResponder) withBool:x]; }
- (void)             setPerformKeyEquivalent:(BOOL)x    { [self overrideResponder:@selector(performKeyEquivalent:) withBool:x]; }

- (void) animateWithDuration:(NSTI)d block:(IDBlk)stuff {

//  if ([self.class conformsToProtocol:@protocol(NSAnimatablePropertyContainer)])
  //  return XX(@"You dont coform to NSAnimatablePropertyContainer>!");
  [NSACTX beginGrouping];
  NSACTX.currentContext.duration = d;
  stuff([(id<NSAnimatablePropertyContainer>)self animator]);
  [NSACTX endGrouping];
}
@end

@implementation NSWindow (AtoZ) @dynamic childWindows;

- (void) activate {  [self makeKeyAndOrderFront:nil]; [NSApp activateIgnoringOtherApps:YES]; !self.isVisible ?: [self.animator setAlphaValue:1];
}
+ (INST) withFrame:(NSR)r mask:(NSUI)m {

  return [self.class.alloc initWithContentRect:r styleMask:m backing:NSBackingStoreBuffered defer:NO];
}
//  - initWithContentRect:(NSR)r styleMask:(NSUI)m backing:(NSBackingStoreType)b defer:(BOOL)d {
//  return self = [super initWithContentRect:r styleMask:m backing:b defer:d] ? ({

+ desktopWindow  { NSW *x; return x = [super.alloc initWithContentRect:NSZeroRect styleMask:0|1|2|8 backing:2 defer:NO] ? ({
		[x setOpaque:NO];
		[x setBackgroundColor:[NSColor clearColor]];
		[x setMovableByWindowBackground:NO];
		[x setLevel:NSNormalWindowLevel - 1];
		[x setStyleMask:NSBorderlessWindowMask];
		[x setCollectionBehavior:NSWindowCollectionBehaviorStationary];
		[x setCanHide:NO];
		[x setIgnoresMouseEvents:YES];  NSR vFrame = NSScreen.mainScreen.visibleFrame;
		[x setFrameTopLeftPoint:(NSP){NSMinX(vFrame) + 20, NSMaxY(vFrame) - 20}];       x; }) : nil;
}

- (void) toggleVisibility                         { [self toggleBoolForKey:@"isVisible"];  }
- (void) setChildWindows:(NSA*)xyz                { for (NSW*w in xyz) [self addChildWindow:w ordered:NSWindowAbove]; }

- (void)  overrideCanBecomeKeyWindow:(BOOL)canI   { [self overrideResponder:@selector(canBecomeKeyWindow)  withBool:canI]; }
- (void) overrideCanBecomeMainWindow:(BOOL)canI   { [self overrideResponder:@selector(canBecomeMainWindow) withBool:canI]; }


+ (instancetype) windowWithFrame:(NSR)r view:(NSV*)v mask:(NSUI)m {  NSW* x;

  return ({ x = [self.class.alloc initWithContentRect:r styleMask:m backing:2 defer:NO]; [x setLevel:NSNormalWindowLevel];

  [x objectBySettingValue:v forKey:@"contentView"]; });
}
+ (instancetype) windowWithFrame:(NSR)r              mask:(NSUI)m { return [self windowWithFrame:r view:nil mask:m]; }

- (void) delegateBlock: (void(^)(NSNOT*))block {

	[@[NSWindowDidBecomeKeyNotification, NSWindowDidBecomeMainNotification, NSWindowDidChangeScreenNotification, NSWindowDidDeminiaturizeNotification, NSWindowDidExposeNotification, NSWindowDidMiniaturizeNotification, NSWindowDidMoveNotification, NSWindowDidResignKeyNotification, NSWindowDidResignMainNotification, NSWindowDidResizeNotification, NSWindowDidUpdateNotification, NSWindowWillCloseNotification, NSWindowWillMiniaturizeNotification, NSWindowWillMoveNotification, NSWindowWillBeginSheetNotification, NSWindowDidEndSheetNotification, NSWindowDidChangeScreenProfileNotification,NSWindowWillStartLiveResizeNotification,NSWindowDidEndLiveResizeNotification]each:^(NSS* name){
			[self observeName:name usingBlock:^(NSNOT*n) {	 block(n);	}]; }];
}

+    (id) hitTest:     (NSE*)e 	{ return (id)(findWin([NSScreen.currentScreenForMouseLocation convertPointToScreenCoordinates:e.locationInWindow])); }
+    (id) hitTestPoint:(NSP)loc { return findWin([NSScreen.currentScreenForMouseLocation convertPointToScreenCoordinates:loc]); }
+  (NSA*) appWindows            { return [NSApp _orderedWindowsWithPanels:YES]; } /* FIERCE  Undocumented...  but tells us all of this apps windows...*/
-  (NSA*) windowAndChildren 			{
	return [@[self] arrayByAddingObjectsFromArray:self.childWindows];
}
+  (NSA*) allWindows 						{

	return (__bridge_transfer id)CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
}	
/* prevent any "offscreen action"

//  Not sure why this is here.
//	[AZNOTCENTER addObserverForName:BaseModelSharedInstanceUpdatedNotification object:nil block:^(NSNOT *n) { AZLOG(n);	}];
//	if (w && [[w window] sticksToEdge]){windowOrigin= dragWin.frame.origin;
//	LOGCOLORS($(@"dragstart:%@ windowO:%@",AZString(w.dragStart), w.window), zNL, RANDOMPAL, nil);

	__block id observer1, observer2;
(observer1 = 	[AZNOTCENTER addObserverForName:NSWindowDidUpdateNotification 	object:nil queue:nil usingBlock:^(NSNOT *n) { 
					[self setInsideEdge:99];  [AZNOTCENTER removeObserver:observer1];	}]),
	(observer2 = 	[AZNOTCENTER addObserverForName:NSWindowDidMoveNotification 	object:nil queue:nil usingBlock:^(NSNOT *n) { 
					[self setInsideEdge:99];  [AZNOTCENTER removeObserver:observer2];	}]),
	AZPOS pos = AZOutsideEdgeOfRectInRect(self.frame, AZScreenFrameUnderMenu()); 
	NSLog(@"gotInsideEdge:%@", AZPositionToString(pos));

		zR.center = (NSP){zR.origin.x, NSE.mouseLocation.y} : (NSP){NSE.mouseLocation.x, zR.origin.y};
		[zR setOrigin:NSMakePoint( MAX( 0, zR.origin.x ), MAX( 0, zR.origin.y ))];
		[zR setOrigin:NSMakePoint( MIN( screenFrameUnderMenu.width - zR.width, zR.origin.x ), MIN( screenFrameUnderMenu.height - zR.height, zR.origin.y ))];
		if (constrained.origin.y + constrained.height > screenFrameUnderMenu.height ) [constrained setOrigin:(NSP) { constrained.origin.x, screenFrameUnderMenu.height - constrained.height}];
		if (constrained.origin.x + constrained.width  > AZScreenWidth() ) [constrained setOrigin: (NSP){ AZScreenWidth() - constrained.width, constrained.origin.y}];

	[AZNOTCENTER addobser :NSWindowDidUpdateNotification usingBlock:^(NSNotification *m) {
		if (m.object == self) [self setInsideEdge:99]; }];
	LOGCOLORS(AZString(self.frame), @" on edge: ", AZPositionToString(edge),  BLUE, GREEN, YELLOW,nil);
	LOGCOLORS(@"WINDOWSHOULDSBE:", AZString(windowShouldBe), zTAB,@"offset", AZString(distanceFromStart), zTAB,$(@"%3.fx  %3.f", e.deltaX, e.deltaY), zTAB, @"WIND setTo:", r.description,zNL,zNL,NSC.randomPalette, nil);
 LOGCOLORS(@"MOUSEDRAGGED:", RED,zNL, $(@"%3.fx  %3.f", e.deltaX, e.deltaY),YELLOW,zNL, nil);


typedef void (^notificationObserver_block)(NSNotification *);
- (void) addEdgeObserver {
 our observer block needs to reference itself, which means we need a variable to hold it which is defined up front. For
   // clarity and safety (and sanity) we'll make it a __block variable:
   __block notificationObserver_block observer_block;// = (notificationObserver_block);
   // the observer needs to be assigned by the observer block when it  signs up again, which means another __block variable:	
	__block id tmpObserver = nil;
   // the observer block gets defined and assigned to its variable  here:
   observer_block = ^(NSNotification * note) {
        if ( [note object] == self )
        {   [self setInsideEdge:99]; }
	  // remove the existing observer
	  [AZNOTCENTER removeObserver: tmpObserver];
	  // signup again, because we want to keep receiving this notification
	  tmpObserver = [[NSNotificationCenter defaultCenter]
						  addObserverForName: NSWindowDidMoveNotification
										  object: self
											queue: [NSOperationQueue mainQueue]
									 usingBlock: observer_block]; // references currently-executing block
	};
	// now we need to repeat the last line of our defined block to start the ball rolling:
	tmpObserver = [[NSNotificationCenter defaultCenter]
					 addObserverForName: @"TheNotification"
									 object: nil
									  queue: [NSOperationQueue mainQueue]
								usingBlock: observer_block];
//}

		NSP windowShouldBe	= AZPointOffset(windowOrigin, AZSubtractPoints(NSE.mouseLocation, dragStart));
		NSLog(@"setting pos from Drag: %@", AZPositionToString(loc));
		dragWin.insideEdge = loc;
		if (!NSEqualPoints(dragWin.frame.origin, windowShouldBe))  {
		AZRect *newRect		= [AZRect rectWithOrigin:windowShouldBe andSize:dragWin.size];
		AZPOS     edgeSide	= self.insideEdge;//AZOutsideEdgeOfRectInRect (newRect.rect, screenFrameUnderMenu.rect );
		// find rect on edge of screen
		AZRect *constrained 	= [AZRect rectWithRect: AZRectInsideRectOnEdge(newRect.rect, screenFrameUnderMenu.rect, edgeSide)];
		// prevent any "offscreen action"
		[constrained setOrigin:NSMakePoint( MAX( 0, constrained.origin.x ), MAX( 0, constrained.origin.y ))];
		if (constrained.origin.y + constrained.height > screenFrameUnderMenu.height ) [constrained setOrigin:(NSP) { constrained.origin.x, screenFrameUnderMenu.height - constrained.height}];
		if (constrained.origin.x + constrained.width  > AZScreenWidth() ) [constrained setOrigin: (NSP){ AZScreenWidth() - constrained.width, constrained.origin.y}];
		[dragWin setFrame:constrained.rect display:YES];
*/
- (void) setView:(NSV*)v  { self.contentView = v;       }
- (NSV*) view             { return self.contentView;    }
- (NSV*) frameView        { return self.view.superview; }
- (CAL*) contentLayer     { return [self.contentView setupHostView]; }
- (CAL*) windowLayer      {  return [(NSV*)self.contentView layer] ?: [self.contentView setupHostView]; }
- (void) setFrameSize:(NSSZ)size 			{ NSR f = self.frame;	f.size.width 	= size.width; f.size.height = size.height ;
																											[self setFrame:f display:YES animate:YES] ;	}
// works  is  good;
- (CAL*) veilLayer						{
	return  [self veilLayerForView:self.contentView];
}
- (CAL*) veilLayerForView: (NSV*)v 	{

	CAL *lace 	= CAL.new;
	lace.frame 	= v.bounds;
	lace.borderWidth = 10; 
	lace.borderColor = cgRANDOMCOLOR;
	CGContextRef	context = NULL;
	CGColorSpaceRef colorSpace;
	int bitmapByteCount;				int bitmapBytesPerRow;
	int pixelsHigh = (int) v.layer.height;
	int pixelsWide = (int) v.layer.width;
	bitmapBytesPerRow   = (pixelsWide * 4);			bitmapByteCount	 = (bitmapBytesPerRow * pixelsHigh);
	colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	context = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh,	8, bitmapBytesPerRow,	colorSpace,	kCGImageAlphaPremultipliedLast);
	if (context== NULL)	{	NSLog(@"Failed to create context."); return nil;	}
	CGColorSpaceRelease( colorSpace );
	[v.layer.presentationLayer renderInContext:context];
	//	[[[view layer] presentationLayer] recursivelyRenderInContext:context];
	lace.contents = [NSImage imageFromCGImageRef:CGBitmapContextCreateImage(context)];
	lace.contentsGravity = kCAGravityCenter;
	return lace;
	//	CGImageRef img =	NSBitmapImageRep *bitmap = [NSBitmapImageRep.alloc initWithCGImage:img];	CFRelease(img);	return bitmap;
}
- (void) veil:					(NSV*)v	{

	CALayer* rooot = self.windowLayer  ?: CAL.new;
	CAL *veil = [CAL veilForView:rooot];
	veil.zPosition = 2000;
	veil.borderColor = cgRED;
	veil.borderWidth = 10;
	[rooot addSublayer:veil];
	[rooot display];
}
- (void) addViewToTitleBar:(NSV*)viewToAdd 
               atXPosition:(CGF)x 	{

	viewToAdd.frame = NSMakeRect(x, [[self contentView] frame].size.height, viewToAdd.frame.size.width, [self heightOfTitleBar]);
	NSUInteger mask = 0;
	mask |= x > self.frame.size.width / 2.0 ? NSViewMinXMargin : NSViewMaxXMargin;
	[viewToAdd setAutoresizingMask:mask | NSViewMinYMargin];
	[[(NSV*)self.contentView superview] addSubview:viewToAdd];
}
- (CGF) heightOfTitleBar 				{
	NSRect outerFrame = [[(NSView*)[self contentView] superview] frame];
	NSRect innerFrame = [[self contentView] frame];
	
	
	return outerFrame.size.height - innerFrame.size.height;
}
- (CGR) contentRect 						{  return (NSR){{0,0},[(id<BoundingObject>)self.contentView size]}; }

/** @brief Set content size with animation	*/
- (void)setContentSize:(NSSize)aSize display:(BOOL)displayFlag animate:(BOOL)animateFlag	{
	NSRect  frame = [self frame];
	NSSize  desiredSize;
	
	desiredSize = [self frameRectForContentRect:NSMakeRect(0, 0, aSize.width, aSize.height)].size;
	frame.origin.y += frame.size.height - desiredSize.height;
	frame.size = desiredSize;
	
	[self setFrame:frame display:displayFlag animate:animateFlag];
}
/** @brief 	The method 'center' puts the window really close to the top of the screen.  
 This method puts it not so close. */
- (void) betterCenter 					{
	NSRect	frame = [self frame];
	NSRect	screen = [[self screen] visibleFrame];
	
	[self setFrame:(NSR){screen.origin.x + (screen.size.width  - frame.size.width)  / 2.,
                      screen.origin.y  + (screen.size.height - frame.size.height) / 1.2,
                      frame.size} display:NO];
}
/** @brief 	Height of the toolbar @result The height of the toolbar, or 0 if no toolbar exists or is visible */
- (CGF)toolbarHeight 					{
	NSToolbar 	*toolbar = [self toolbar];
	CGFloat 		toolbarHeight = 0.0f;
	
	if (toolbar && [toolbar isVisible]) {
		NSRect 		windowFrame = [NSWindow contentRectForFrameRect:[self frame]
																	  styleMask:[self styleMask]];
		toolbarHeight = NSHeight(windowFrame) - NSHeight([[self contentView] frame]);
	}
	
	return toolbarHeight;
}
+ (NSW*) borderlessWindowWithContentRect: (NSR)aRect  {

	NSW *new = [self.class.alloc initWithContentRect:aRect 					     styleMask:NSBorderlessWindowMask
                                           backing:NSBackingStoreBuffered	 defer:NO];
	new.backgroundColor = CLEAR;
	new.opaque = NO;
	[new setMovable: YES];
	return new;
}

- (void) fadeIn	 				{

	[self setAlphaValue:0.f];
	[self makeKeyAndOrderFront:nil];
	[NSAnimationContext groupWithDuration:.6 animationBlock:^{
		[self.animator setAlphaValue:1.f];
  }];
}
- (void) fadeOut 					{

	[NSAnimationContext groupWithDuration:.6 animationBlock:^{
    __block __unsafe_unretained NSWindow *bself = self;
		[NSAnimationContext.currentContext setCompletionHandler:^{
			[bself orderOut:nil];
			[bself setAlphaValue:1.f];
		}];
		[self.animator setAlphaValue:0.f];
  }];
}
- (void) slideTo:(NSS*)rect 	{

	[NSAnimationContext beginGrouping];
		[NSAnimationContext.currentContext setKey:kCAMediaTimingFunctionEaseInEaseOut ];
		if (@"visibleRect") {
			[self setAlphaValue:0.f];
			[self makeKeyAndOrderFront:self];
			[self setFrame:[[self valueForKeyPath:@"dictionary.hiddenRect"]rectValue]display:YES animate:NO];
	}
}  //GHETTO, prolly nonfuntional  FIX
- (void) slideDown				{
	NSRect newViewFrame = [[self valueForKeyPath:@"dictionary.visibleRect"]rectValue];
	CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"frame"];
	[animation setFromValue:AZVrect([self frame])];
	[animation setToValue:	AZVrect(newViewFrame)];
	CABasicAnimation *fader = [CABasicAnimation animationWithKeyPath:@"alphaValue"];
	[fader setFromValue:@0.f];
	[fader setToValue:@1.f];
	[self setAnimations:	@{ @"frame" : animation}];
	[[self animator] setFrame:newViewFrame display:YES];
}

- (void) animateInsetTo:(CGF)f anchored:(AZA)edge  					{

  NSR newR = AZRectExceptSpanAnchored(self.r, f, edge);
  [self animateToFrame:newR duration:1];
//  [self setAnimations:	@{ @"frame" : [CABA animationWithKeyPath:@"frame"
//                                                            from:AZVrect(self.r)
//                                                              to:AZVrect(newR)
//                                                        duration:1. repeat:NO]}];
//  [self.animator setFrame:newR];
}

- (void) slideUp 					{
	NSRect newViewFrame       = self.frame;
	newViewFrame.origin.y    += self.height;
	newViewFrame.size.height  = 0;
  [self setAnimations:	@{ @"frame" : [CABA animationWithKeyPath:@"frame" from:AZVrect(self.frame) to:AZVrect(newViewFrame) duration:1.5 repeat:NO]}];
  [self.animator setFrame:newViewFrame];

	//	[[self animator] setFrame:newViewFrame display:YES];
	//	NSViewAnimation *theAnim = [NSViewAnimation.alloc initWithViewAnimations: $array($map(
	//		self, NSViewAnimationTargetKey,
	//		AZVrect(firstViewFrame), NSViewAnimationStartFrameKey,
	//		AZVrect(newViewFrame), NSViewAnimationEndFrameKey))];
	//	[theAnim setValue:self forKeyPath:@"dictionary.slideUpNowFoldUpWindow"];
	//	[theAnim setDuration:.3];
	//	[theAnim setDelegate:self];
	//	[theAnim startAnimation];
	
	//	[self makeKeyAndOrderFront:self];
	//	[NSAnimationContext beginGrouping];
	//	__block __unsafe_unretained NSWindow *bself = self;
	//
	//	[[NSAnimationContext currentContext] setDuration:.6];
	//	NSPoint up = NSMakePoint(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
	//	[[self animator] setFrameOrigin:up];
	//	[NSAnimationContext endGrouping];
}
- (void) animationDidEnd:(NSAnimation*)theAnimation {
	NSLog(@"Yes, indeed, animation did end!");
	NSWindow *windy = [theAnimation valueForKeyPath:@"dictionary.slideUpNowFoldUpWindow"];
	if (windy)  {
		CGFloat extendo = -[windy frame].size.height;
		NSLog(@"Extending vetically by %f", extendo);
		[windy extendVerticallyBy:extendo];
	}
}
- (void) extendVerticallyBy:(CGF) amount 	{ // extends the window vertically by the amount (which can be negative).
	
	//This doesn't disturb the positioning orsize of any of the views, whatever their autosizing parameters are set to.
	NSView	 *cv = [self contentView];
	//	[cv setAutoresizesSubviews:NO];
	//	[self disableFlushWindow];
	NSR fr = cv.frame;
	fr.size.height += amount;
	cv.frame = fr;
	//	[cv.subviews each:^(NSView *view) {
	//		NSRect	 fr; NSPoint	 fro;
	//		fro = [view frame].origin;
	//		fro.y += amount;
	//		[view setFrameOrigin:fro];
	//	}
	fr = [self frame];
	fr.size.height += amount;
	//	fr.origin.y -= amount;
	[self setFrame:fr display:YES];
	//	[self enableFlushWindow];
	//	[cv setAutoresizesSubviews:YES];
}
// NSCopying protocol  added to be compatible with the beginSheet hack in NTApplication.m taken from OmniAppKit
-  (id) copyWithZone:(NSZone *)zone;		 	{
	return self;// retain];
}
//	This is the core of it - it just extends or shrinks the window's bottom edge by the given amount, leaving all the current subviews undisturbed. It could probably most usefully be a catego
-(void) setIgnoresEventsButAcceptsMoved	{
	[self setIgnoresMouseEvents: YES];
	[self setAcceptsMouseMovedEvents: YES];
}

@end

@implementation NSWindow (UKFade) static NSMD*	 pendingFades = nil;

-(void)  fadeInWithDuration:(NSTI)duration	{
	if( !pendingFades )
		pendingFades = NSMutableDictionary.new;
	NSString*	   key = [NSString stringWithFormat: @"%@", self];
	NSDictionary*   fade = pendingFades[key];
	if( fade )	  // Currently fading that window? Abort that fade:
		[fade[@"timer"] invalidate];  // No need to remove from pendingFades, we'll replace it in a moment.
	[self setAlphaValue: 0];
	[self orderFront: nil];
	NSTimeInterval  interval = duration / 0.1;
	float		   stepSize = 1 / interval;
	NSTimer*		timer = [NSTimer scheduledTimerWithTimeInterval: 0.1				// scheduled since we also want "normal" run loop mode.
																		target: self selector: @selector(fadeInOneStep:)
																	 userInfo: nil repeats: YES];
	[AZRUNLOOP addTimer: timer forMode: NSModalPanelRunLoopMode];
	[AZRUNLOOP addTimer: timer forMode: NSEventTrackingRunLoopMode];
	pendingFades[key] = @{@"timer":timer,@"stepSize":	@(stepSize)}.mC; // Releases of any old fades.
}

-(void)       fadeInOneStep:(TMR*)timer     {
	NSString*   key = self.description;
	float	   newAlpha = self.alphaValue + [pendingFades[key][@"stepSize"] fV];
	if( newAlpha >= 1.0 )
	{
		newAlpha = 1;
		[timer invalidate];
		[pendingFades removeObjectForKey: key];
	}
	//NSLog(@"Fading in: %f", newAlpha);		// DEBUG ONLY!
	[self setAlphaValue: newAlpha];
}
-(void) fadeOutWithDuration:(NSTI)duration	{
	if( !pendingFades )
		pendingFades = NSMutableDictionary.new;
	NSString*	   key = [NSString stringWithFormat: @"%@", self];
	NSDictionary*   fade = pendingFades[key];
	if( fade )	  // Currently fading that window? Abort that fade:
		[fade[@"timer"] invalidate];  // No need to remove from pendingFades, we'll replace it in a moment.
	[self setAlphaValue: 1.0];
	NSTimeInterval  interval = duration / 0.1;
	float		   stepSize = 1 / interval;
	NSTimer*		timer = [NSTimer scheduledTimerWithTimeInterval: 0.1				// scheduled since we also want "normal" run loop mode.
																		target: self selector: @selector(fadeOutOneStep:)
																	 userInfo: nil repeats: YES];
	pendingFades[key] = @{@"timer":timer,@"stepSize":	@(stepSize)}.mC;	// Releases of any old fades.
	[AZRUNLOOP addTimer: timer forMode: NSModalPanelRunLoopMode];
	[AZRUNLOOP addTimer: timer forMode: NSEventTrackingRunLoopMode];
}
-(void)      fadeOutOneStep:(TMR*)timer     {
	NSString*				key = [NSString stringWithFormat: @"%@", self];
	NSMutableDictionary*	currFadeDict = pendingFades[key];//retain] autorelease];	// Make sure it doesn't go away in case we're cross-fading layers.
	float					newAlpha = [self alphaValue] - [currFadeDict[@"stepSize"] floatValue];
	if( newAlpha <= 0 )
	{
		[timer invalidate];
		[pendingFades removeObjectForKey: key];
		NSNumber*	newLevel = currFadeDict[@"newLevel"];
		if( newLevel )
		{
			timer = [NSTimer scheduledTimerWithTimeInterval: 0.1				// scheduled since we also want "normal" run loop mode.
																  target: self selector: @selector(fadeInOneStep:)
																userInfo: nil repeats: YES];
			currFadeDict[@"timer"] = timer;
			pendingFades[key] = currFadeDict;
			[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSModalPanelRunLoopMode];
			[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSEventTrackingRunLoopMode];
			[self setLevel: [newLevel intValue]];
			//NSLog(@"Changing level to %u", [newLevel unsignedIntValue]);		// DEBUG ONLY!
			newAlpha = 0;
		}
		else
		{
			newAlpha = 1;		   // Make opaque again so non-fading showing of window doesn't look unsuccessful.
			[self orderOut: nil];   // Hide so setAlphaValue below doesn't cause window to fade out, then pop in again.
		}
	}
	//NSLog(@"Fading out: %f", newAlpha);		// DEBUG ONLY!
	[self setAlphaValue: newAlpha];
}
-(void)         fadeToLevel:(int)lev 
               withDuration:(NSTI)duration	{
	if( !pendingFades )
		pendingFades = NSMutableDictionary.new;
	NSString*	   key = [NSString stringWithFormat: @"%@", self];
	NSDictionary*   fade = pendingFades[key];
	if( fade )	  // Currently fading that window? Abort that fade:
		[fade[@"timer"] invalidate];  // No need to remove from pendingFades, we'll replace it in a moment.
	[self setAlphaValue: 1.0];
	NSTimeInterval  interval = (duration /2) / 0.1;
	float		   stepSize = 1 / interval;
	NSTimer*		timer = [NSTimer scheduledTimerWithTimeInterval: 0.1				// scheduled since we also want "normal" run loop mode.
																		target: self selector: @selector(fadeOutOneStep:)
																	 userInfo: nil repeats: YES];
	pendingFades[key] = @{@"timer":timer,@"stepSize":	@(stepSize), @"newLevel":@(lev)}.mC; // Releases of any old fades.
	[AZRUNLOOP addTimer: timer forMode: NSModalPanelRunLoopMode];
	[AZRUNLOOP addTimer: timer forMode: NSEventTrackingRunLoopMode];
}

@end


@implementation NSWindow (SDResizableWindow)
- (void) setContentViewSize:(NSSZ)newSize display:(BOOL)display animate:(BOOL)animate {
	[self setFrame:[self windowFrameForNewContentViewSize:newSize] display:display animate:animate];
}
-  (NSR) windowFrameForNewContentViewSize:(NSSZ)newSize {
	NSRect windowFrame = [self frame];
	
	windowFrame.size.width = newSize.width;
	
	float titlebarAreaHeight = windowFrame.size.height - [[self contentView] frame].size.height;
	float newHeight = newSize.height + titlebarAreaHeight;
	float heightDifference = windowFrame.size.height - newHeight;
	windowFrame.size.height = newHeight;
	windowFrame.origin.y += heightDifference;
	
	return windowFrame;
}

@end

//
//  NSWindow+Transforms.m
//  Rotated Windows
//
//  Created by Wade Tregaskis on Fri May 21 2004.
//
//  Copyright (c) 2004 Wade Tregaskis. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//    * Redistributions of source code must retain the above copyright notice, this
//      list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright notice, this
//      list of conditions and the following disclaimer in the documentation and/or
//      other materials provided with the distribution.
//    * Neither the name of Wade Tregaskis nor the names of its contributors may be
//      used to endorse or promote products derived from this software without specific
//      prior written permission.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
//  SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
//  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
//  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
// ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



#import "CoreGraphicsServices.h"

@implementation NSWindow (Transforms)

- (NSPoint) windowToScreenCoordinates:(NSPoint)point {
        NSPoint result;
        NSRect screenFrame = [[[NSScreen screens] objectAtIndex:0] frame];

        // Doesn't work... it looks like the y co-ordinate is not inverted as necessary
        //result = [self convertBaseToScreen:point];

        result.x = _frame.origin.x + point.x;
        result.y = screenFrame.origin.y + screenFrame.size.height - (_frame.origin.y + point.y);

        return result;
}

- (NSPoint) screenToWindowCoordinates:(NSPoint)point { // Untested
        NSPoint result;
        NSRect screenFrame = [[[NSScreen screens] objectAtIndex:0] frame];

        result.x = point.x - (screenFrame.origin.x + _frame.origin.x);
        result.y = screenFrame.origin.y + screenFrame.size.height - _frame.origin.y - point.y;

        return point; // To be completed
}

- (void) rotate:(double)radians {
        [self rotate:radians about:NSMakePoint(_frame.size.width * 0.5, _frame.size.height * 0.5)];
}

- (void) rotate:(double)radians about:(NSPoint)point {
        CGAffineTransform original;
        CGSConnectionID connection;
        NSPoint rotatePoint = [self windowToScreenCoordinates:point];

        connection = _CGSDefaultConnection();
        CGSGetWindowTransform(connection, _windowNum, &original);

        original = CGAffineTransformTranslate(original, rotatePoint.x, rotatePoint.y);
        original = CGAffineTransformRotate(original, -radians);
        original = CGAffineTransformTranslate(original, -rotatePoint.x, -rotatePoint.y);

        CGSSetWindowTransform(connection, _windowNum, original);
}

- (void) scaleBy:(double)scaleFactor {
        [self scaleX:scaleFactor Y:scaleFactor];
}

- (void) scaleX:(double)x Y:(double)y {
        [self scaleX:x Y:y about:NSMakePoint(_frame.size.width * 0.5, _frame.size.height * 0.5) concat:YES];
}

- (void) setScaleX:(double)x Y:(double)y {
        [self scaleX:x Y:y about:NSMakePoint(_frame.size.width * 0.5, _frame.size.height * 0.5) concat:NO];
}

- (void) scaleX:(double)x Y:(double)y about:(NSPoint)point concat:(BOOL)concat {
        CGAffineTransform original;
        CGSConnectionID connection;
        NSPoint scalePoint = [self windowToScreenCoordinates:point];

        connection = _CGSDefaultConnection();

        if (concat) {
                CGSGetWindowTransform(connection, _windowNum, &original);
        } else {
                // Get the screen position of the top left corner, by which our window is positioned
                NSPoint p = [self windowToScreenCoordinates:NSMakePoint(0.0, _frame.size.height)];
                original = CGAffineTransformMakeTranslation(-p.x, -p.y);
        }
        original = CGAffineTransformTranslate(original, scalePoint.x, scalePoint.y);
        original = CGAffineTransformScale(original, 1.0 / x, 1.0 / y);
        original = CGAffineTransformTranslate(original, -scalePoint.x, -scalePoint.y);

        CGSSetWindowTransform(connection, _windowNum, original);
}

- (void) reset {
        // Note that this is not quite perfect... if you transform the window enough it may end up anywhere on the screen, but resetting it plonks it back where it started, which may correspond to it's most-logical position at that point in time.  Really what needs to be done is to reset the current transform matrix, in all places except it's translation, such that it stays roughly where it currently is.

        // Get the screen position of the top left corner, by which our window is positioned
        NSPoint point = [self windowToScreenCoordinates:NSMakePoint(0.0, _frame.size.height)];

        CGSSetWindowTransform(_CGSDefaultConnection(), _windowNum, CGAffineTransformMakeTranslation(-point.x, -point.y));
}

/*! Thanks to Alcor for the following. This allows us to tell the window manager that the window should be sticky. A sticky window will stay around when the
 Expose sweep-all-windows-away event happens. Additionally, if a window is not sticky while it fades in (see FadingWindowController for an example of fading
 in), and simultaneously the desktop is switched via DesktopManager, the window may end up getting left on the previous desktop, even if that window's level
 set to NSStatusWindowLevel. See http://www.cocoadev.com/index.pl?DontExposeMe for more information.
*/
- (void) setSticky:(BOOL)flag {
        CGSConnectionID cid;
        CGSWindowID wid;

        wid = [self windowNumber];
        if (wid > 0) {
                cid = _CGSDefaultConnection();
                int tags[2] = { 0, 0 };
                
                if (!CGSGetWindowTags(cid, wid, (enum _CGSWindowTag*)tags, 32)) {
                        tags[0] = flag ? (tags[0] | 0x00000800) : (tags[0] & ~0x00000800);
                        CGSSetWindowTags(cid, wid,(enum _CGSWindowTag*)tags, 32);
                }
        }
}

@end


/**	   NSButton *button = [NSButton.alloc initWithFrame:NSMakeRect(0, 0, 100, 100)];
 [button setBezelStyle:NSRecessedBezelStyle]; NSButton *closeButton = [NSWindow standardWindowButton:NSWindowZoomButton forStyleMask:self.window.styleMask]; [self.window addViewToTitleBar:button atXPosition:self.window.frame.size.width - button.frame.size.width - 10]; [self.window addViewToTitleBar:closeButton atXPosition:70];

------- in cocoatechcore
 //  CocoatechCore
 @interface NSWindow (NSDrawerWindowUndocumented)
 - (NSWindow*)_parentWindow;
 @end
 @interface NSApplication (Undocumented)
 - (NSA*)_orderedWindowsWithPanels:(BOOL)panels;
 @end
 @implementation NSWindow (Utilities)
 + (void)cascadeWindow:(NSWindow*)inWindow;
 {
 // find the topmost window with the same class
 NSEnumerator *enumerator = [[self visibleWindows:YES] objectEnumerator];
 NSWindow* window;
 
 while (window = [enumerator nextObject])
 {
 // class must match exactly, but don't cascade it off itself
 if (window != inWindow)
 {
 if ([window isMemberOfClass:[inWindow class]] && [[window delegate] isMemberOfClass:[[inWindow delegate] class]])
 {
 // cascade new window off this window we found
 NSRect windowFrame = [window frame];
 NSPoint topLeftPoint = NSMakePoint(windowFrame.origin.x, NSMaxY(windowFrame));
 NSPoint cascadedPoint;
 
 cascadedPoint = [inWindow cascadeTopLeftFromPoint:topLeftPoint];
 windowFrame.origin = NSMakePoint(cascadedPoint.x, cascadedPoint.y - NSHeight(windowFrame));
 
 [inWindow setFrame:windowFrame display:NO];
 break;
 }
 }
 }
 }
 + (BOOL)isAnyWindowVisibleWithDelegateClass:(Class)klass;
 {
 NSArray* windows = [self visibleWindows:NO];
 NSWindow* window;
 
 for (window in windows)
 {
 
 id delegate = [window delegate];
 
 if ([delegate isKindOfClass:class])
 return YES;
 }
 
 return NO;	
 }
 + (BOOL)isAnyWindowVisible;
 {
 NSArray* windows = [self visibleWindows:NO];
 NSWindow* window;
 
 for (window in windows)
 {
 
 // this should elliminate drawers and floating windows
 if ([window styleMask] & (NSTitledWindowMask | NSClosableWindowMask))
 return YES;
 }
 
 return NO;
 }
 - (NSWindow*)topWindowWithDelegateClass:(Class)klass;
 {
 NSArray* arr = [NSWindow visibleWindows:YES delegateClass:class];
 
 if ([arr count])
 return arr[0];
 
 return nil;
 }
 + (NSA*)visibleWindows:(BOOL)ordered;
 {
 return [self visibleWindows:ordered delegateClass:nil];
 }
 + (NSA*)visibleWindows:(BOOL)ordered delegateClass:(Class)delegateClass;
 {
 NSArray* windows;
 NSMutableArray* visibles = [NSMutableArray array];
 
 if (ordered)
 windows = [NSApp _orderedWindowsWithPanels:YES];
 else
 windows = [NSApp windows];
 
 if (windows && [windows count])
 {
 NSWindow* window;
 BOOL visible;
 BOOL appHidden = [NSApp isHidden];
 
 for (window in windows)
 {
 
 // hack: if app is hidden, all windows are not visible
 visible = [window isVisible];
 if (!visible && appHidden)
 visible = YES;
 
 if ([window canBecomeKeyWindow] && visible)  
 {
 // filter by delegates class if not nil
 if (delegateClass)
 {
 if (![[window delegate] isKindOfClass:delegateClass])
 window = nil;
 }
 
 if (window)
 [visibles addObject:window];
 }
 }
 }
 
 return visibles;	
 }
 + (NSA*)miniaturizedWindows;
 {
 NSArray* windows;
 NSMutableArray* minaturized = [NSMutableArray array];
 
 windows = [NSApp windows];
 
 if (windows && [windows count])
 {
 NSWindow* window;
 
 for (window in windows)
 {
 
 if ([window canBecomeKeyWindow] && [window isMiniaturized])
 {
 // this should elliminate drawers and floating windows
 if ([window styleMask] & (NSTitledWindowMask | NSClosableWindowMask))
 [minaturized addObject:window];
 }
 }
 }
 
 return minaturized;
 }
 - (void)setFloating:(BOOL)set;
 {
 if (set)
 [self setLevel:NSFloatingWindowLevel];
 else
 [self setLevel:NSNormalWindowLevel];
 }
 - (BOOL)isFloating;
 {
 return ([self level] == NSFloatingWindowLevel);
 }
 - (BOOL)isMetallic;
 {
 // under 10.5 drawers don't adopt the styleMask, must check parent
 NSWindow* win = [self parentWindowIfDrawerWindow];
 return NSTexturedBackgroundWindowMaskSet([win styleMask]);
 }
 - (BOOL)isBorderless;
 {
 return NSBorderlessWindowMaskSet([self styleMask]);
 }
 // returns parentWindow if an NSDrawerWindow, otherwise returns self
 - (NSWindow*)parentWindowIfDrawerWindow;
 {
 if ([self respondsToSelector:(@selector(_parentWindow))])
 return [self _parentWindow];
 
 return self;
 }
 - (void)setDefaultFirstResponder;
 {
 // send this out to ask our window to set the defaul first responder
 [[NSNotificationCenter defaultCenter] postNotificationName:kNTSetDefaultFirstResponderNotification object:self];
 }
 - (BOOL)dimControls;
 {
 if ([self isFloating])
 return NO;
 
 return ![[self parentWindowIfDrawerWindow] isMainWindow];
 }
 - (BOOL)dimControlsKey;
 {
 // if key window is a menu, just call plain dimControls
 return[self keyWindowIsMenu] ? [self dimControls] : [self isFloating] ? NO : ![[self parentWindowIfDrawerWindow] isKeyWindow];
 }
 - (BOOL)keyWindowIsMenu;
 {
 static Class sCarbonMenuWindowClass=nil;
 if (!sCarbonMenuWindowClass)
 sCarbonMenuWindowClass = NSClassFromString(@"NSCarbonMenuWindow");
 
 return [[NSApp keyWindow] isKindOfClass:sCarbonMenuWindowClass];
 }
 - (void)flushActiveTextFields;
 {
 // flush the current editor
 id fr = [self firstResponder];
 if (fr)
 {
 [self makeFirstResponder:nil];
 [self makeFirstResponder:fr];
 }
 }		
 - (NSRect)setContentViewAndResizeWindow:(NSView*)view display:(BOOL)display;
 {
 NSRect frame = [self frame];
 frame.size = [self frameRectForContentRect:[view bounds]].size;
 [self setContentView:view];
 
 frame.origin.y += (NSHeight([self frame]) - NSHeight(frame));
 
 [self setFrame:frame display:display animate:YES];
 
 return frame;
 }
 - (NSRect)windowFrameForContentSize:(NSSize)contentSize;
 {
 NSRect frame = [self frame];
 frame.size = [self frameRectForContentRect:NSMakeRect(0,0,contentSize.width, contentSize.height)].size;
 
 frame.origin.y += (NSHeight([self frame]) - NSHeight(frame));
 
 return frame;
 }
 - (NSRect)resizeWindowToContentSize:(NSSize)contentSize display:(BOOL)display;
 {
 NSRect result = [self windowFrameForContentSize:contentSize];		
 [self setFrame:result display:display animate:YES];
 
 return result;
 }
 + (BOOL)windowRectIsOnScreen:(NSRect)windowRect;
 {	
 // make sure window is visible
 NSEnumerator* enumerator = [[NSScreen screens] objectEnumerator];
 NSScreen *screen;
 
 while (screen = [enumerator nextObject])
 {
 if (NSIntersectsRect(windowRect, [screen frame]))
 {
 // someone reported that a detacted monitor was keeping windows off screen?  Didn't verify
 // not sure if this hack works since I can't test it, but seems reasonable
 if (!NSIsEmptyRect([screen visibleFrame]))
 return YES;
 }
 }
 
 return NO;
 }
 
 @end
 
  	__block __unsafe_unretained NSWindow *bself = self;
	[[NSAnimationContext currentContext] setCompletionHandler:^{
		if (fadeIn) {			[[self animator] setAlphaValue:1.f];			[bself setFrameOrigin:frame.origin];
			[bself orderFront:self];
		} else {
			[bself orderOut:nil];
			[bself setAlphaValue:1.f];
			[[self animator] setAlphaValue:0.f];
		}
	}];
	[[self animator] setContentSize:frame.size display:YES animate:YES];
	[NSAnimationContext endGrouping];
}
	NSViewAnimation *animation = [NSViewAnimation.alloc 	initWithViewAnimations: @[
	@{ 	NSViewAnimationTargetKey: self,
	NSViewAnimationEffectKey: (fade ?NSViewAnimationFadeInEffect :NSViewAnimationFadeOutEffect) },
	@{ 	NSViewAnimationTargetKey:self,
	NSViewAnimationEndFrameKey:AZVrect(frame)} ]];
	[animation setAnimationBlockingMode: NSAnimationBlocking];
	[animation setDuration: 0.5]; // or however long you want it for
	[animation startAnimation]; // because it's blocking, once it returns, we're done
}

- (void)slideDown {
	 //	if ([[self contentView] isHidden]) [[self main] setHidden:YES];
	 NSRect firstViewFrame = [[self contentView] frame];
	 NSRect screen =  [[NSScreen mainScreen]frame];
	 firstViewFrame.origin.y = screen.size.height - 22;
	 firstViewFrame.origin.x = 0;
	 NSRect destinationRect = firstViewFrame;
	 destinationRect.origin.y -= firstViewFrame.size.height;
	 NSViewAnimation *theAnim = [NSViewAnimation.alloc initWithViewAnimations: $array($map(
	 self, NSViewAnimationTargetKey,
	 AZVrect(firstViewFrame), NSViewAnimationStartFrameKey,
	 AZVrect(destinationRect), NSViewAnimationEndFrameKey))];
	 [theAnim setAnimationCurve:NSAnimationEaseInOut];
	 [theAnim setDuration:.4];
	 [theAnim startAnimation];
	[self makeKeyAndOrderFront:self];
	NSRect newViewFrame = firstViewFrame;
	newViewFrame.origin.y -= self.frame.size.height;
	newViewFrame.origin.y -= 22;
						  forKey:NSViewAnimationEndFrameKey];
	[theAnim setAnimationCurve:NSAnimationEaseInOut];
	[theAnim setDuration:.4];
	[theAnim setDelegate:self]; 

	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setDuration:.6];
	NSPoint down = NSMakePoint(self.frame.origin.x, self.frame.origin.y - self.frame.size.height);
	[[self animator] setFrameOrigin:down];
	[NSAnimationContext endGrouping];	 }

//-  (CGF) width { return  self.frame.size.width;		} -  (CGF) height	{ return  self.frame.size.height;	} - (NSSZ) frameSize	{ return  self.frame.size;				}

//  [self az_overrideSelector:@selector(canBecomeKeyWindow) withBlock:(__bridge void *)^BOOL(id _self){ return canI; }]; }
// [self az_overrideSelector:@selector(canBecomeMainWindow) withBlock:(__bridge void *)^BOOL(id _self){ return canI; }]; }
//- (void)animation:(NSAnimation *)animation didReachProgressMark:(NSAnimationProgress)progress {	if ([animation valueForKeyPath:@"dictionary.preSlideUpExtendView"] == theAnim)		}	}

//- (BOOL) hasLayer							{ return [self.contentView layer] != nil;		}
//-  (CGF) originX          { return  self.frame.origin.x; 		}
//-  (CGF) originY					{ return  self.frame.origin.y; 		}
// : [self.contentView setupHostView]; }
//- (void) setLayer: (CAL*) layer		{ BOOL hasit = self.hasLayer; [(NSV*)self.contentView setLayer:layer]; if (!hasit) [self.contentView setWantsLayer:YES]; }
*/