
#import "NSWindow+AtoZ.h"

@interface NSApplication (Undocumented)	
- (NSA*)_orderedWindowsWithPanels:(BOOL)panels;	
@end
static 	 NSPoint 	gWindowTrackingEventOrigin, 	gWindowTrackingCurrentWindowOrigin;
static 	 CGR 		inFrame, 							outFrame;  	
id(^findWin)(NSP) = ^id(NSP p){	NSA* windows;return windows = [[NSApp _orderedWindowsWithPanels:YES] filter:^BOOL(id o){ 
																				return NSPointInRect(p, [o frame]); 
																		}] ? windows[0] : (id)nil; 										};
JREnumDefine(NSWindowResize);
@implementation NSWindow (SBSWindowAdditions)	static BOOL	gWindowTrackingEnabled = NO, gWindowTracking = NO;
+ (BOOL) isLiveFrameTracking 				{
	return gWindowTrackingEnabled;
}
+ (void) setLiveFrameTracking:(BOOL) bol	{	gWindowTrackingEnabled = bol;	// we have to use global variables (polluting global namespace)
	bol ? [AZNOTCENTER addObserver:self selector:@selector(willMove:) name:NSWindowWillMoveNotification object:nil] 
		: ^{ gWindowTracking = NO;	// getting informed as soon as any window is dragged
	 		[AZNOTCENTER removeObserver:self name:NSWindowWillMoveNotification object:nil]; // like this, applications can interrupt even ongoing frame tracking
		}();			
}
+ (void) willMove:   (id) notification	{
	gWindowTracking = YES;										// the loop condition during tracking
	gWindowTrackingEventOrigin = [NSEvent mouseLocation];		// most accurate (somethings wrong with NSLeftMouseDragged events and their deltaX)
	[NSThread detachNewThreadSelector:@selector(windowMoves:) toTarget:(NSWindow*)[(NSNotification*)notification object] withObject:notification];
	// creating a new thread that is doing the monitoring of mouse movement
}
- (void) windowMoves:(id) notification	{
	@autoreleasepool {											// remember, we are in a new thread!
		NSRect startFrame = self.frame;							// where was the window prior to dragging
		gWindowTrackingCurrentWindowOrigin = startFrame.origin;		// where is it now
		while (gWindowTracking) {									// polling for the mouse position until gWindowTracking is NO (see windowMoved:)
			gWindowTrackingCurrentWindowOrigin.x = startFrame.origin.x + NSEvent.mouseLocation.x - gWindowTrackingEventOrigin.x;
			gWindowTrackingCurrentWindowOrigin.y = startFrame.origin.y + NSEvent.mouseLocation.y - gWindowTrackingEventOrigin.y;
			// calculating the current window frame accordingly (size won't change)
			[self performSelectorOnMainThread:@selector(windowMoved:) withObject:notification waitUntilDone:YES];
			// lets do the main job on the main thread, particularly important for
			// querying the event stack for the mouseUp event signaling the end of the dragging
			// and posting the new event
		}
	}												// thread is dying, so we clean up
}
- (void) windowMoved:(id) notification	{						// to be performed on the main thread
	if (!NSEqualPoints(gWindowTrackingCurrentWindowOrigin, _frame.origin)) {
		// _frame is the private variable of an NSWindow, we have full access (category!)
		_frame.origin = gWindowTrackingCurrentWindowOrigin;		// setting the private instance variable so obersers of the windowDidMove notification
		// can retrieve the current position by calling [[notification object] frame].
		// The REAL setting of the frame will be done by the window server at the end of the drag
		[AZNOTCENTER postNotificationName:NSWindowDidMoveNotification object:self];
		// post the NSWindowDidMoveNotification (only if a move actually occured)
	}
	if ([NSApp nextEventMatchingMask:NSLeftMouseUpMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:NO]) {
		gWindowTracking = NO;									// checking for an NSLeftMouseUp event that would indicate the end
		// of the dragging and set the looping condition accordingly.
		// MUY IMPORTANTE: we have to do this on the main thread!!!
	}
}
@end	  
@implementation NSWindow (Resize)
- (void) resizeToWidth:(CGF)wide height:(CGF)high 														{
	[self resizeToWidth:wide height:high origin:NSWindowResizeBottomLeftCorner];
}
- (void) resizeToWidth:(CGF)wide height:(CGF)high origin:(NSWindowResize)ori 						{
	[self resizeToWidth:wide height:high origin:ori duration:0.5];
}
- (void) resizeToWidth:(CGF)wide height:(CGF)high origin:(NSWindowResize)ori duration:(NSTI)dur {
	float currentWidth 	= self.width;
	float currentHeight 	= self.height;
	float originX 		= self.frame.origin.x;
	float originY 		= self.frame.origin.y;
	switch (ori) {
		case NSWindowResizeTopLeftCorner:		originY = originY + currentHeight - high;		break;
		case NSWindowResizeTopRightCorner:		originY = originY + currentHeight - high;
													originX = originX + currentWidth - wide;		break;
		case NSWindowResizeBottomRightCorner:	originX = originX + currentWidth - wide;		break;
		case NSWindowResizeBottomLeftCorner:														break; default: break;//	Does nothing
	}
	NSViewAnimation *viewAnimation = [NSViewAnimation.alloc initWithViewAnimations: @[@{NSViewAnimationTargetKey:self, NSViewAnimationEndFrameKey:AZVrect(NSMakeRect( originX, originY,wide,high))}]];
	[viewAnimation setAnimationBlockingMode:NSAnimationBlocking];
	[viewAnimation setDuration:dur];
	[viewAnimation startAnimation];
}
@end 	  
@implementation NSWindow (NoodleEffects)
- (void) animateToFrame:				(NSR)frameRect duration:(NSTI)dur	{
	NSViewAnimation	 *animation = 
	[NSViewAnimation.alloc initWithViewAnimations: @[@{NSViewAnimationTargetKey: self,NSViewAnimationEndFrameKey: AZVrect(frameRect)}]];
	[animation setDuration:dur];
	[animation setAnimationBlockingMode:NSAnimationBlocking];
	[animation setAnimationCurve:NSAnimationLinear];
	[animation startAnimation];
}
- (NSW*) _createZoomWindowWithRect:	(NSR)rect								{
	NSWindow		*zoomWindow;
	NSImageView	*imageView;
	NSRect			frame 		= self.frame;
	BOOL			isOneShot = self.isOneShot;
	isOneShot ? [self setOneShot:NO] : nil;
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
	zoomWindow = [NSW.alloc initWithContentRect:rect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
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
	[image release];
	[imageView release];
	[self setOneShot:isOneShot];	// Reset one shot flag
	return zoomWindow;
}
- (void) zoomOnFromRect:				(NSR)startRect						{
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
- (void) zoomOffToRect:					(NSR)endRect									{
	NSRect  frame = [self frame];
	if (![self isVisible]) return;
	NSWindow *zoomWindow = [self _createZoomWindowWithRect:frame];
	[zoomWindow orderFront:self];
	[self orderOut:self];
	[zoomWindow animateToFrame:endRect duration:[zoomWindow animationResizeTime:endRect] * 0.4];
	[zoomWindow close];
}	
@end
static CAL* indicator;
@interface  ClickedWindow : NSObject
@property (assign) CGP dragStart, windowOrigin;
@property (atomic, readonly, weak) NSW* window; 		// The weak reference to the actual object
@end
static ClickedWindow *clickclack = nil;
@implementation  ClickedWindow 							// Singlton window that is our "Active window", aka, being dragged.
- (instancetype) initWithWindow:(NSW*)w	{			
//	if (!w) [self.class setSharedInstance:nil]; return; 
	// if the object window is already the shared instance's window.. then this is redundant, return the shared instance.
//	if (w == [self.class.sharedInstance window]) return self.class.sharedInstance;
//	else  [self.class setSharedInstance: self = self.class.new]; // or make it so.
	if (w == clickclack.window) return clickclack;
	if (indicator)  [indicator fadeOut];	// [v setFrame:AZRectExtendedOnBottom(v.frame, 1) display:YES]; }
	if (self != super.init) return nil;
	clickclack = self;
	_window 			= w;// Store the weak reference.  This will become nil automatically when this object is disposed of.
	LOGCOLORS(@"made clicked widnow with ", w, GREEN, PINK, nil);  //  log it.
	_dragStart 		= NSE.mouseLocation;  		// note our starting point.
	_windowOrigin  = w.frame.origin;  	// save initial origin.
	indicator = [CAL layerWithFrame:AZRectInsideRectOnEdge(AZRectFromDim(50), AZRectFromSize(_window.size), _window.insideEdge)];
	indicator.contents = [[NSIMG imageNamed:@"1"]scaledToMax:AZMaxDim(indicator.bounds.size)];
	CAL *host; NSView *vvv;
	if (!( vvv = [[w.contentView subviews] filterOne:^BOOL(id ob) {	return [[ob layer].name isEqualToString:@"layerHostXYZ"]; 	}] )) {
		[_window.contentView addSubview:vvv = [NSView.alloc initWithFrame:[_window.contentView frame]]]; vvv.arMASK = NSSIZEABLE; 	host = [vvv setupHostView];
	} else host = vvv.layer;
	CAL *grab = [CAL layerWithFrame:self.window.sticksToEdgeGrabRect];
	grab.backgroundColor = cgBLACK;
	[grab bind:@"bounds" toObject:_window withKeyPath:@"insideEdge" transform:^id(id value) {
		return AZVrect(self.window.sticksToEdgeGrabRect);
	}];
	[grab bind:@"position" toObject:_window withKeyPath:@"insideEdge" transform:^id(id value) {
		AZPOS pos = [value unsignedIntegerValue];
		NSP calced = AZAnchorPointOfActualRect( grab.bounds,pos );
		NSLog(@"calced Point: %@ ofrect:%@ atPos: %ld", AZString(calced), AZString(grab.bounds), AZWindowPositionToString(pos));
		return AZVpoint(calced);
	}];
	
	[indicator bind:@"position" toObject:_window withKeyPath:@"insideEdge" transform:^id(id value) {
		NSLog(@"Got inside edge as... %@", value);
		return AZVpoint(AZCenter(AZRectInsideRectOnEdge(AZCenterRectInRect(AZRectFromDim(50), AZRectFromSize(_window.size)), AZRectFromSize(_window.size), _window.insideEdge)));
	}];
	[host addSublayer:indicator];
	[host addSublayer:grab];
   return clickclack;
}
//- (BOOL) respondsToSelector:(SEL)s			{ 	return [_window respondsToSelector:s] ?: [super respondsToSelector:s];  

// [self respondsToSelector:s] ?:
//- (id) valueForUndefinedKey:(NSS*)key { id value;if ([_window respondsToString:key])value = [_window valueForKey:key];if (value == nil) value = [super valueForUndefinedKey: key];	}
//} 
@end
@implementation NSWindow (AtoZStickyWindows)

-  (void) setOutsideEdgeRect:(NSRect)frame  	{ 

	[self setAssociatedValue:AZVrect(frame) forKey:@"outsideEdgeRect" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]; 
}
-   (NSR) outsideEdgeRect					 	{

	return [self hasAssociatedValueForKey:@"outsideEdgeRect"] ? [[self associatedValueForKey:@"outsideEdgeRect"]rectValue] : AZScreenFrameUnderMenu();
}
static NSMA    *nonStickies = nil; 
-  (void) setSticksToEdge:(BOOL)sticky 	{  
	// Sets associated value for sticky bit
	sticky ? [self setAssociatedValue:@YES forKey:@"sticksToEdge" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC] 
			 : [self removeAssociatedValueForKey:@"sticksToEdge"];
	// static referenced
	
	nonStickies = nonStickies ?: ^{ nonStickies  = [NSMA mutableArrayUsingWeakReferences];
								  								  [NSW.appWindows each:^(id w) { if (![w sticksToEdge]) [nonStickies addObject:w]; }]; return nonStickies;		}();
	
	if (!sticky) { [nonStickies addObject:self]; 			 if ([self hasAssociatedValueForKey:@"WASMOVEABLE"]) {
						[self setMovableByWindowBackground:YES]; [self removeAssociatedValueForKey:@"WASMOVEABLE"]; } 	return; }

	id (^findEdgeEnabledWin)(NSP) = ^id(NSP p){  
		NSA* all = NSW.appWindows;
		NSA* win = [all arrayByRemovingObjectsFromArray:nonStickies];
		
		NSA *winners = [win filter:^BOOL(NSW*o){ return o.sticksToEdge && NSPointInRect(p, o.frame); 	}];
		NSLog(@"allCT: %ld thestickiesct:%ld  winnersCt: %ld", all.count, win.count, winners.count);
		return !winners.count ? nil : [winners.first isEqualTo:clickclack.window] ? clickclack.window  : winners.first; 		
	};
 
	// OK, we're gonna be sticky, let's do it.  Remove oneself from the list of nonsticky windows.
	[nonStickies containsObject:self] ?	[nonStickies removeObjectIdenticalTo:self] : nil;
	//  if can be moved by...  turn off, and save value for restore if made non-sticky again.
	self.isMovableByWindowBackground  ? ^{ [self setMovableByWindowBackground:NO], 
														[self setAssociatedValue:@(YES) forKey:@"WASMOVEABLE" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]; }() : nil;
	//  THIS window's click handler.
	id handler = [NSEVENTLOCALMASK: NSLeftMouseDraggedMask | NSLeftMouseDownMask | NSLeftMouseUpMask handler:^NSE*(NSE*e) {
		VoidBlock defineClickedWindow, dragAction, doubleClick;
		
		defineClickedWindow = ^{ 
			id win = findEdgeEnabledWin(NSE.mouseLocation); 
			if (!win) return;
			if (!clickclack || win != clickclack.window) {
			
				clickclack =  [ClickedWindow.alloc initWithWindow:win];
				NSLog(@"found the clicked victim: %@", clickclack.window);
				[nonStickies removeObject:clickclack.window];
			}
//			ClickedWindow *w = [ClickedWindow.alloc initWithWindow:windy];
			  // find and set "shared" "clicked" window
		};
		
		dragAction = ^{ 	//ClickedWindow *win = 
			//		if (win != ClickedWindow.sharedInstance.window) return;//findEdgeEnabledWin(NSE.mouseLocation);
//			ClickedWindow *target = [ClickedWindow sharedInstance]; 	// Convenience accessors
			AZPOS          ptEdge = AZOutsideEdgeOfPointInRect ( NSE.mouseLocation, AZScreenFrameUnderMenu());
			NSP            offset = AZSubtractPoints ( NSE.mouseLocation, AZSubtractPoints ( clickclack.dragStart, clickclack.windowOrigin));
			AZRect *newRect = [clickclack.window frameInRect:AZScreenFrameUnderMenu() offset:offset insideEdge:ptEdge];
			LOGCOLORS(@"newframe:",newRect, @"newloc ",AZPositionToString(newRect.orient),  zNL, RANDOMPAL, nil);
			[clickclack.window setInsideEdge:newRect.orient];
			[clickclack.window setFrame:newRect.rect display:YES animate:YES];
			NSLog(@"finished dragging clicked window!");
		};
	
		doubleClick = ^{ 
			if (clickclack
//			.window == findWin(NSE.mouseLocation) 
			&& NSPointInRect(e.locationInWindow, clickclack.window.sticksToEdgeGrabRect)) {
				NSLog(@"doubleCLICKwindow:%@!");
				LOG_EXPR(clickclack.window);
				AZSlideState dClickSlideState = clickclack.window.slideState;
				LOG_EXPR(dClickSlideState);
				[clickclack.window setSlideState:dClickSlideState == AZIn ? AZOut : AZIn];
//				NSR out = [[self associatedValueForKey:@"normalRectMemory" 
//														 orSetTo:AZVrect(self.frame) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]rectValue];
//				[self setFrame:NSEqualRects(out, self.frame) 
//				?	AZRectInsideRectOnEdge( self.sticksToEdgeGrabRect, AZRECTUNDERMENU.rect, self.insideEdge) 
//				: 	out display:YES	animate:YES];
			}
		};	
		//  Mouse clicked, NOT dragged... setup.
		if		 	( e.clickCount == 2 && self == clickclack.window) 																					doubleClick();
		else if 	( e.type == NSLeftMouseDown && e.type != NSLeftMouseDragged && e.clickCount != 2 ) 	defineClickedWindow();
		// Mouse WAS dragged..  could add && !(e.deltaX == 0 && e.deltaY ==0)) 	
		else if  ( e.type == NSLeftMouseDragged && self == clickclack.window ) 																	dragAction();
		//mouse up
		else if  ( e.type == NSLeftMouseUp && self == clickclack.window )		{ clickclack = nil;  NSLog(@"clcick should be nil: %@", clickclack); }
		//  Double Click handler for windowshade action.
		return e;
	}];	
}
-  (BOOL) sticksToEdge 						{ 		
	
	BOOL hasa = NO; hasa = [[self associatedValueForKey:@"sticksToEdge" orSetTo:@NO policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]boolValue];
	NSLog(@"%@ thinks it is Sticky:%@", self,StringFromBOOL(hasa)); return hasa; 
}

-  (AZRect*) frameInRect:(NSR)f 
					offset:(NSP)off 
			  insideEdge:(AZPOS)pos 		{
	
	__block NSR newRect 	= AZRectInsideRectOnEdge ( self.frame, f, pos);
	pos == AZPositionRight | pos == AZPositionLeft	?  ^{	newRect.origin.y = off.y; }()
															:  ^{ newRect.origin.x 	= off.x; }();
	newRect.origin.x = MAX(newRect.origin.x, 0);	
	newRect.origin.y = MAX(newRect.origin.y, 0); 														
	newRect.origin.x = MIN(newRect.origin.x, f.size.width  - newRect.size.width );
	newRect.origin.y = MIN(newRect.origin.y, f.size.height - newRect.size.height);

	NSP topleft 	= (NSP){0, f.size.height-newRect.size.height};
	NSP topRight 	= (NSP){f.size.width-newRect.size.width,f.size.height-newRect.size.height};
	NSP bottomRight = (NSP){f.size.width  - newRect.size.width, 0};
	AZPOS newpos =	NSEqualPoints(newRect.origin, NSZeroPoint)  	? AZPositionBottomLeft :
			NSEqualPoints(newRect.origin,     topleft)	? AZPositionTopLeft :
			NSEqualPoints(newRect.origin,    topRight) 	? AZPositionTopRight :
			NSEqualPoints(newRect.origin, bottomRight) 	? AZPositionBottomRight : (AZPOS)pos;
	AZRect *newaz =  [AZRect.alloc initWithRect:newRect];
	 newaz.orient =newpos;
	return newaz;
} 
- (AZPOS) insideEdge 						{ 	
	return [[self associatedValueForKey:@"insideEdge" orSetTo:@(AZPositionAutomatic) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC] unsignedIntegerValue];	
} /* AssociatedGetter */
-  (void) setInsideEdge:(AZPOS)posi		{ 
		[self setAssociatedValue:@(posi) forKey:@"insideEdge" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];	
//	[self setFrame:AZRectInsideRectOnEdge(self.frame, AZScreenFrameUnderMenu(), position) display:YES animate:YES];
} /* AssociatedSettrer */
-  (CRNR) sticksToEdgeOutsideCorners 							{ AZPOS o = AZPositionOpposite(self.insideEdge);
	return 	o == AZPositionTop  	 ? (OSBottomLeftCorner 	| OSBottomRightCorner) 	:
				o == AZPositionLeft 	 ? (OSTopRightCorner   	| OSBottomRightCorner) 	: 
				o == AZPositionBottom ? (OSTopLeftCorner 		| OSTopRightCorner) 		:	//	o == AZPositionRight  ? 
												(OSTopLeftCorner 		| OSBottomLeftCorner) 	;
}
-  (void) setGrabInset:(CGF)grabInset 	{ [self setAssociatedValue:@(grabInset) forKey:@"grabInset" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]; }
-   (CGF) grabInset 							{ 

	return [[self associatedValueForKey:@"grabInset" orSetTo:@(25) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]floatValue]; }
-   (NSR) sticksToEdgeGrabRect 							{  AZPOS o = AZPositionOpposite(self.insideEdge);

	return 	o == AZPositionTop  	 ? AZLowerEdge(self.frame, self.grabInset) 	:
				o == AZPositionLeft 	 ? AZRightEdge(self.frame, self.grabInset) 	: 
				o == AZPositionBottom ? AZUpperEdge(self.frame, self.grabInset)	:
//				o == AZPositionRight  ? 
				AZLeftEdge(self.frame, self.grabInset);
}

- (AZSlideState) slideState { return [[self associatedValueForKey:@"slideState"]unsignedIntegerValue]; }// inOut = AZToggle;	
- (void) setSlideState:(AZSlideState)ss	{  
	
	[self setAssociatedValue:@(ss) forKey:@"slideState" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
//	if (ss == AZIn) self.inFrame = 
 	[self setFrame: ss == AZIn ? self.inFrame : self.outFrame display:YES animate:YES];
}
- (void) setInFrame:(CGRect)inFrame		{ 	

	[self setAssociatedValue:AZVrect(inFrame) forKey:@"inFrame" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];	
}
- (void) setOutFrame:(CGRect)outFrame		{

	[self setAssociatedValue:AZVrect(inFrame) forKey:@"outFrame" policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];	
}
-   (CGR) inFrame 							{  
	if ([self hasAssociatedValueForKey:@"inFrame"]) return [[self associatedValueForKey:@"inFrame"]rectValue];
	BOOL stcky = self.sticksToEdge;  
	NSRect  theStart = stcky ? self.outFrame : self.frame;
	AZPOS inEdge = self.insideEdge;
	return 
	inEdge == AZPositionLeft	?  	AZRectExceptOriginX(theStart, self.width - self.grabInset) 									:
 	inEdge == AZPositionTop 	? 	AZRectExceptOriginY(theStart, theStart.origin.y + theStart.size.height - self.grabInset)	:
 	inEdge == AZPositionRight	? 	AZRectExceptOriginX(theStart, theStart.origin.x + theStart.size.width - self.grabInset)	:												
	inEdge == AZPositionBottom	?	AZRectExceptOriginY(theStart, theStart.origin.y - theStart.size.height + self.grabInset) : theStart;
 	//		return inFrame  = CGRectIsNull(inFrame)  ? self.frame : inFrame;  } 
}
-   (CGR) outFrame 							{ 

	if ([self hasAssociatedValueForKey:@"outFrame"]) return [[self associatedValueForKey:@"outFrame"]rectValue];
	BOOL stcky; if (!(stcky = self.sticksToEdge )) return self.frame;  
	AZRect *r =  [self frameInRect:AZScreenFrameUnderMenu() offset:NSZeroPoint  insideEdge:self.insideEdge];
//	[self setInsideEdge:r.orient];
	return r.rect;
}
			  // outFrame = CGRectIsNull(outFrame) ? self.frame : outFrame; } 

+    (id) hitTest:     (NSE*)event 	{ return findWin([[NSScreen currentScreenForMouseLocation] convertPointToScreenCoordinates:event.locationInWindow]); }
+    (id) hitTestPoint:(NSP)location 	{ findWin([[NSScreen currentScreenForMouseLocation] convertPointToScreenCoordinates:location]); }
+  (NSA*) appWindows 					{ return [NSApp _orderedWindowsWithPanels:YES]; } /* FIERCE  Undocumented...  but tells us all of this apps windows...*/

@end

@implementation NSWindow (AtoZ)
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
- (CAL*) layer								{	return [(NSV*)self.contentView          layer];	}
- (void) setLayer: (CAL*) layer		{		    [(NSV*)self.contentView setLayer:layer];	}
-  (CGF) originX 							{ return  self.frame.origin.x; 		}
-  (CGF) originY							{ return  self.frame.origin.y; 		}
-  (CGF) width 							{ return  self.frame.size.width;		}
-  (CGF) height 							{ return  self.frame.size.height;	}
- (NSSZ) size								{ return  self.frame.size;				}
- (void) setWidth: (CGF)t 				{ NSR f = self.frame;	f.size.width  	= t; 	[self setFrame:f display:YES animate:YES] ;	}
- (void) setHeight:(CGF)t				{ NSR f = self.frame;	f.size.height 	= t; 	[self setFrame:f display:YES animate:YES] ; 	}
- (void) setSize:(NSSZ)size 			{ NSR f = self.frame;	f.size.width 	= size.width; f.size.height = size.height ;
																											[self setFrame:f display:YES animate:YES] ;	}
-  (NSP) midpoint 						{

	NSRect frame = [self frame];
	NSPoint midpoint = NSMakePoint(frame.origin.x + (frame.size.width/2),
											 frame.origin.y + (frame.size.height/2));
	return midpoint;
}
- (void) setMidpoint:(NSP)midpoint 	{

	NSRect frame = [self frame];
	frame.origin = NSMakePoint(midpoint.x - (frame.size.width/2),
										midpoint.y - (frame.size.height/2));
	[self setFrame:frame display:YES];
}
- (NSA*) windowAndChildren 			{
	return [@[self] arrayByAddingObjectsFromArray:self.childWindows];
}
+ (NSA*) allWindows 						{
	return (__bridge_transfer id)CGWindowListCopyWindowInfo(kCGWindowListOptionAll, kCGNullWindowID);
}	
// works  is  good;
- (CAL*) veilLayer						{
	return  [self veilLayerForView:[self contentView]];
}
- (CAL*) veilLayerForView: (NSV*)v 	{

	CAL *lace 	= CAL.new;
	lace.frame 	= v.bounds;
	lace.borderWidth = 10; 
	lace.borderColor = cgRANDOMCOLOR;
	CGContextRef	context = NULL;
	CGColorSpaceRef colorSpace;
	int bitmapByteCount;				int bitmapBytesPerRow;
	int pixelsHigh = (int) v.layer.boundsHeight;
	int pixelsWide = (int) v.layer.boundsWidth;
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
	//	CGImageRef img =	NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithCGImage:img];	CFRelease(img);	return bitmap;
}
- (void) veil:					(NSV*)v	{

	CALayer* rooot = self.layer ? [[self contentView]layer] : CAL.new;
	CAL *veil = [CAL veilForView:rooot];
	veil.zPosition = 2000;
	veil.borderColor = cgRED;
	veil.borderWidth = 10;
	[rooot addSublayer:veil];
	[rooot display];
}
-(void) addViewToTitleBar: (NSV*)viewToAdd 
				  atXPosition: (CGF)x 	{

	viewToAdd.frame = NSMakeRect(x, [[self contentView] frame].size.height, viewToAdd.frame.size.width, [self heightOfTitleBar]);
	NSUInteger mask = 0;
	mask |= x > self.frame.size.width / 2.0 ? NSViewMinXMargin : NSViewMaxXMargin;
	[viewToAdd setAutoresizingMask:mask | NSViewMinYMargin];
	[[(NSV*)self.contentView superview] addSubview:viewToAdd];
}
- (CGF) heightOfTitleBar 				{
	NSRect outerFrame = [[[self contentView] superview] frame];
	NSRect innerFrame = [[self contentView] frame];
	
	
	return outerFrame.size.height - innerFrame.size.height;
}
- (CGR) contentRect 						{  return [self.contentView bounds]; }
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
- (void)betterCenter 					{
	NSRect	frame = [self frame];
	NSRect	screen = [[self screen] visibleFrame];
	
	[self setFrame:NSMakeRect(screen.origin.x + (screen.size.width - frame.size.width) / 2.0f,
									  screen.origin.y + (screen.size.height - frame.size.height) / 1.2f,
									  frame.size.width,
									  frame.size.height)
			 display:NO];
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

	NSWindow *new = [self.alloc initWithContentRect:aRect 					styleMask: NSBorderlessWindowMask
														 backing: NSBackingStoreBuffered	 defer: NO];
	[new setBackgroundColor: CLEAR];							
	[new setOpaque:NO];
	[new setMovable: YES];
	return new;
}
- (void) fadeIn	 				{

	[self setAlphaValue:0.f];
	[self makeKeyAndOrderFront:nil];
	[NSAnimationContext beginGrouping];
		[NSAnimationContext.currentContext setDuration:.6];
		[self.animator setAlphaValue:1.f];
	[NSAnimationContext endGrouping];
}
- (void) fadeOut 					{

	[NSAnimationContext beginGrouping];
		[NSAnimationContext.currentContext setDuration:.6];
		__block __unsafe_unretained NSWindow *bself = self;
		[NSAnimationContext.currentContext setCompletionHandler:^{
			[bself orderOut:nil];
			[bself setAlphaValue:1.f];
		}];
		[self.animator setAlphaValue:0.f];
	[NSAnimationContext endGrouping];
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
- (void) slideUp 					{
	NSRect newViewFrame = [self frame];
	newViewFrame.origin.y += [self frame].size.height;
	newViewFrame.size.height = 0;
	CABasicAnimation *framer = [CABasicAnimation animationWithKeyPath:@"frame"];
	[framer setFromValue:AZVrect([self frame])];
	[framer setToValue:	AZVrect(newViewFrame)];
	[self setAnimations:	@{ @"frame" : framer}];
	//	[[self animator] setFrame:newViewFrame display:YES];
	//	NSViewAnimation *theAnim = [[NSViewAnimation alloc] initWithViewAnimations: $array($map(
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
//- (void)animation:(NSAnimation *)animation didReachProgressMark:(NSAnimationProgress)progress {	if ([animation valueForKeyPath:@"dictionary.preSlideUpExtendView"] == theAnim)		}	}
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
- (id)copyWithZone:(NSZone *)zone;		 	{
	return self;// retain];
}
//	This is the core of it - it just extends or shrinks the window's bottom edge by the given amount, leaving all the current subviews undisturbed. It could probably most usefully be a catego
-(void) setIgnoresEventsButAcceptsMoved	{
	[self setIgnoresMouseEvents: YES];
	[self setAcceptsMouseMovedEvents: YES];
}

@end

static NSMD*	 pendingFades = nil;

@implementation NSWindow (UKFade)

-(void) fadeInWithDuration:  					 (NSTI)duration	{
	if( !pendingFades )
		pendingFades = [[NSMutableDictionary alloc] init];
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
	[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSModalPanelRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSEventTrackingRunLoopMode];
	pendingFades[key] = [NSMutableDictionary dictionaryWithObjectsAndKeys: timer, @"timer",
								@(stepSize), @"stepSize",
								nil];	// Releases of any old fades.
}
-(void) fadeInOneStep:	   					 (NSTimer*)timer	{
	NSString*   key = [NSString stringWithFormat: @"%@", self];
	float	   newAlpha = [self alphaValue] + [pendingFades[key][@"stepSize"] floatValue];
	if( newAlpha >= 1.0 )
	{
		newAlpha = 1;
		[timer invalidate];
		[pendingFades removeObjectForKey: key];
	}
	//NSLog(@"Fading in: %f", newAlpha);		// DEBUG ONLY!
	[self setAlphaValue: newAlpha];
}
-(void) fadeOutWithDuration: 					 (NSTI)duration	{
	if( !pendingFades )
		pendingFades = [[NSMutableDictionary alloc] init];
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
	pendingFades[key] = [NSMutableDictionary dictionaryWithObjectsAndKeys: timer, @"timer",
								@(stepSize), @"stepSize",
								nil];	// Releases of any old fades.
	[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSModalPanelRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSEventTrackingRunLoopMode];
}
-(void) fadeOutOneStep:	  					 (NSTimer*)timer	{
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
-(void) fadeToLevel: (int)lev withDuration:(NSTI)duration	{
	if( !pendingFades )
		pendingFades = [[NSMutableDictionary alloc] init];
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
	pendingFades[key] = [NSMutableDictionary dictionaryWithObjectsAndKeys: timer, @"timer",
								@(stepSize), @"stepSize",
								@(lev), @"newLevel",
								nil];	// Releases of any old fades.
	[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSModalPanelRunLoopMode];
	[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSEventTrackingRunLoopMode];
}

@end

@implementation DesktopWindow

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(NSUInteger)aStyle
				  backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)flag								{
	self = [super initWithContentRect:contentRect
									styleMask:aStyle
									  backing:bufferingType
										 defer:flag];
	
	if (self) {
		[self setOpaque:NO];
		[self setBackgroundColor:[NSColor clearColor]];
		[self setMovableByWindowBackground:NO];
		[self setLevel:NSNormalWindowLevel - 1];
		[self setStyleMask:NSBorderlessWindowMask];
		[self setCollectionBehavior:NSWindowCollectionBehaviorStationary];
		[self setCanHide:NO];
		[self setIgnoresMouseEvents:YES];
		
		NSRect visibleFrame = [[NSScreen mainScreen] visibleFrame];
		[self setFrameTopLeftPoint:NSMakePoint(NSMinX(visibleFrame) + 20, NSMaxY(visibleFrame) - 20)];
		
	}
	
	return self;
}
@end

/**	   NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 100, 100)];
 [button setBezelStyle:NSRecessedBezelStyle]; NSButton *closeButton = [NSWindow standardWindowButton:NSWindowZoomButton forStyleMask:self.window.styleMask]; [self.window addViewToTitleBar:button atXPosition:self.window.frame.size.width - button.frame.size.width - 10]; [self.window addViewToTitleBar:closeButton atXPosition:70]; */

/**  in cocoatechcore
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
 + (BOOL)isAnyWindowVisibleWithDelegateClass:(Class)class;
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
 - (NSWindow*)topWindowWithDelegateClass:(Class)class;
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
 */



/*	__block __unsafe_unretained NSWindow *bself = self;
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
	NSViewAnimation *animation = [[NSViewAnimation alloc]
	initWithViewAnimations: @[
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
	 NSViewAnimation *theAnim = [[NSViewAnimation alloc] initWithViewAnimations: $array($map(
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
*/
