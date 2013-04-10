//  NSWindow+AtoZ.m
//  AtoZ

#import "NSWindow+AtoZ.h"

@implementation NSWindow (SBSWindowAdditions)

+ (void) setLiveFrameTracking:(BOOL) bol	{
	gWindowTrackingEnabled = bol;								// we have to use global variables (polluting global namespace)
	if (bol) {
		[AZNOTCENTER addObserver:self selector:@selector(willMove:) name:NSWindowWillMoveNotification object:nil];
		// getting informed as soon as any window is dragged
	}
	else {		gWindowTracking = NO;									// like this, applications can interrupt even ongoing frame tracking
		[AZNOTCENTER removeObserver:self name:NSWindowWillMoveNotification object:nil];
	}
}
+ (BOOL) isLiveFrameTracking 					{
	return gWindowTrackingEnabled;
}
+ (void) willMove:	(id) notification		{
	gWindowTracking = YES;										// the loop condition during tracking
	gWindowTrackingEventOrigin = [NSEvent mouseLocation];		// most accurate (somethings wrong with NSLeftMouseDragged events and their deltaX)
	[NSThread detachNewThreadSelector:@selector(windowMoves:) toTarget:(NSWindow*)[(NSNotification*)notification object] withObject:notification];
	// creating a new thread that is doing the monitoring of mouse movement
}
- (void) windowMoves:(id) notification		{
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
- (void) windowMoved:(id) notification		{						// to be performed on the main thread
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

- (void) resizeToWidth:(float)theWidth height:(float)theHeight 																	{
	[self resizeToWidth:theWidth height:theHeight origin:NSWindowResizeBottomLeftCorner];
}
- (void) resizeToWidth:(float)theWidth height:(float)theHeight origin:(int)theOrigin 										{
	[self resizeToWidth:theWidth height:theHeight origin:theOrigin duration:0.5];
}
- (void) resizeToWidth:(float)theWidth height:(float)theHeight origin:(int)theOrigin duration:(float)theDuration 	{
	float currentWidth = self.frame.size.width;
	float currentHeight = self.frame.size.height;
	float originX = self.frame.origin.x;
	float originY = self.frame.origin.y;
	switch (theOrigin) {
		case NSWindowResizeTopLeftCorner:
			originY = originY + currentHeight - theHeight;
			break;
		case NSWindowResizeTopRightCorner:
			originY = originY + currentHeight - theHeight;
			originX = originX + currentWidth - theWidth;
			break;
		case NSWindowResizeBottomRightCorner:
			originX = originX + currentWidth - theWidth;
			break;
		case NSWindowResizeBottomLeftCorner:
			//	Does nothing
			break;
		default:
			break;
	}
	NSViewAnimation *viewAnimation = [[NSViewAnimation alloc] initWithViewAnimations: [NSArray arrayWithObjects:
																												  [NSDictionary dictionaryWithObjectsAndKeys:
																													self,
																													NSViewAnimationTargetKey,
																													[NSValue valueWithRect:NSMakeRect(
																																								 originX,
																																								 originY,
																																								 theWidth, 
																																								 theHeight
																																								 
																																								 )], 
																													
																													NSViewAnimationEndFrameKey, 
																													
																													nil],
																												  
																												  nil]];
	
	[viewAnimation setAnimationBlockingMode:NSAnimationBlocking];
	[viewAnimation setDuration:theDuration];
	
	[viewAnimation startAnimation];
	[viewAnimation release];
	
}
@end

@implementation NSWindow (NoodleEffects)

- (void) animateToFrame:				(NSR)frameRect duration:(NSTI)duration	{
	NSViewAnimation	 *animation;
	animation = [[NSViewAnimation alloc] initWithViewAnimations:
					 @[@{NSViewAnimationTargetKey: self,
												NSViewAnimationEndFrameKey: AZVrect(frameRect)}]];
	[animation setDuration:duration];
	[animation setAnimationBlockingMode:NSAnimationBlocking];
	[animation setAnimationCurve:NSAnimationLinear];
	[animation startAnimation];
	[animation release];
}
- (NSW*) _createZoomWindowWithRect:	(NSR)rect										{
	NSWindow		*zoomWindow;
	NSImageView	 *imageView;
	NSImage		 *image;
	NSRect		  frame;
	BOOL			isOneShot;
	frame = [self frame];
	isOneShot = [self isOneShot];
	if (isOneShot)
	{
		[self setOneShot:NO];
	}
	if ([self windowNumber] <= 0)
	{
		CGFloat		alpha;
		// Force creation of window device by putting it on-screen. We make it transparent to minimize the chance of
		// visible flicker.
		alpha = [self alphaValue];
		[self setAlphaValue:0.0];
		[self orderBack:self];
		[self orderOut:self];
		[self setAlphaValue:alpha];
	}
	image = [[NSImage alloc] initWithSize:frame.size];
	[image lockFocus];
	// Grab the window's pixels
	NSCopyBits([self gState], NSMakeRect(0.0, 0.0, frame.size.width, frame.size.height), NSZeroPoint);
	[image unlockFocus];
	[image setDataRetained:YES];
	[image setCacheMode:NSImageCacheNever];
	zoomWindow = [[NSWindow alloc] initWithContentRect:rect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	[zoomWindow setBackgroundColor:[NSColor colorWithDeviceWhite:0.0 alpha:0.0]];
	[zoomWindow setHasShadow:[self hasShadow]];
	[zoomWindow setLevel:[self level]];
	[zoomWindow setOpaque:NO];
	[zoomWindow setReleasedWhenClosed:YES];
	[zoomWindow useOptimizedDrawing:YES];
	imageView = [[NSImageView alloc] initWithFrame:[zoomWindow contentRectForFrameRect:frame]];
	[imageView setImage:image];
	[imageView setImageFrameStyle:NSImageFrameNone];
	[imageView setImageScaling:NSScaleToFit];
	[imageView setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	[zoomWindow setContentView:imageView];
	[image release];
	[imageView release];
	// Reset one shot flag
	[self setOneShot:isOneShot];
	return zoomWindow;
}
- (void) zoomOnFromRect:			   (NSR)startRect									{
	NSRect			  frame;
	NSWindow			*zoomWindow;
	if ([self isVisible])
	{
		return;
	}
	frame = [self frame];
	zoomWindow = [self _createZoomWindowWithRect:startRect];
	[zoomWindow orderFront:self];
	[zoomWindow animateToFrame:frame duration:[zoomWindow animationResizeTime:frame] * 0.4];
	[self makeKeyAndOrderFront:self];
	[zoomWindow close];
}
- (void) zoomOffToRect:					(NSR)endRect									{
	NSRect			  frame;
	NSWindow			*zoomWindow;
	frame = [self frame];
	if (![self isVisible])
	{
		return;
	}
	zoomWindow = [self _createZoomWindowWithRect:frame];
	[zoomWindow orderFront:self];
	[self orderOut:self];
	[zoomWindow animateToFrame:endRect duration:[zoomWindow animationResizeTime:endRect] * 0.4];
	[zoomWindow close];
}

@end

@implementation NSWindow (AtoZ)

static CGR inFrame, outFrame;  
static AZSlideState inOut = AZToggle;

- (CGR) inFrame 							{ return inFrame  = CGRectIsNull(inFrame)  ? self.frame : inFrame;  } 
- (CGR) outFrame 							{ return outFrame = CGRectIsNull(outFrame) ? self.frame : outFrame; } 
- (AZSlideState) inOut 					{ return inOut; }
- (void) setInFrame: (CGR)inF; 		{ inFrame = inF;   }
- (void) setOutFrame:(CGR)outF;		{ outFrame = outF; }
- (void) setInOut:(AZSlideState)iO;	{  LOGWARN(@"%@ setting slideState: %ld",self, iO);
	
 	if ( inOut != iO ) { 
 		[self setFrame: iO == AZIn ? self.inFrame : self.outFrame display:YES];  inOut = iO ; 
	}
}

- (CAL*) layer								{
	return [self.contentView layer];
}
- (void) setLayer: (CAL*) layer		{		[self.contentView setLayer:layer];	}

-  (CGF) originX 							{	return [self frame].origin.x; }
-  (CGF) originY							{	return [self frame].origin.y; }
-  (CGF) width 							{	return [self frame].size.width ;		}
-  (CGF) height 							{	return [self frame].size.height ;	}
- (void) setWidth: (CGF)t 				{
	NSRect frame = [self frame] ;
	frame.size.width = t ;
	[self setFrame:frame display:YES animate:YES] ;
}
- (void) setHeight:(CGF)t				{
	NSRect frame = [self frame] ;
	frame.size.height = t ;
	[self setFrame:frame display:YES animate:YES] ;
}
- (NSSZ) size								{
	return self.frame.size;
}
- (void) setSize:(NSSZ)size 			{
	NSRect frame = [self frame] ;
	frame.size.width = size.width ;
	frame.size.height = size.height ;
	[self setFrame:frame display:YES animate:YES] ;
}
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

-(void) addViewToTitleBar:(NSView*)viewToAdd atXPosition:(CGFloat)x {
	viewToAdd.frame = NSMakeRect(x, [[self contentView] frame].size.height, viewToAdd.frame.size.width, [self heightOfTitleBar]);
	
	NSUInteger mask = 0;
	if( x > self.frame.size.width / 2.0 )
	{
		mask |= NSViewMinXMargin;
	}
	else
	{
		mask |= NSViewMaxXMargin;
	}
	[viewToAdd setAutoresizingMask:mask | NSViewMinYMargin];
	
	[[[self contentView] superview] addSubview:viewToAdd];
}
- (CGF) heightOfTitleBar {
	NSRect outerFrame = [[[self contentView] superview] frame];
	NSRect innerFrame = [[self contentView] frame];
	
	
	return outerFrame.size.height - innerFrame.size.height;
}
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
- (void)betterCenter {
	NSRect	frame = [self frame];
	NSRect	screen = [[self screen] visibleFrame];
	
	[self setFrame:NSMakeRect(screen.origin.x + (screen.size.width - frame.size.width) / 2.0f,
									  screen.origin.y + (screen.size.height - frame.size.height) / 1.2f,
									  frame.size.width,
									  frame.size.height)
			 display:NO];
}
/** @brief 	Height of the toolbar @result The height of the toolbar, or 0 if no toolbar exists or is visible */
- (CGF)toolbarHeight {
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
