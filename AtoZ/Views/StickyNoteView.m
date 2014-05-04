#import "AtoZ.h"
#import "StickyNoteView.h"
#import <QuartzCore/QuartzCore.h>

JREnumDefine(AZDraggingMode)

@interface StickyNoteView ()
- (void) _doubleMouse:(NSE*)theEvent;
-  (NSR) _fillRectForCurrentFrame;
-  (NSR) _cellRectForCurrentFrame;
-  (NSR) _closeButtonRectForCurrentFrame;
-  (NSR) _resizeHandleRectForCurrentFrame;
-  (NSR) _constrainRectSize:(NSR)rect;
@end

@implementation StickyNote		static NSRect screens;	static NSMA* notes = nil;  static NSW* fullScreenWindow = nil;
#pragma mark - fix
+  (void) window /* was initialize, turned off because of breakpoint */ 			{	 screens = NSZeroRect;   notes = NSMA.new;

	for (NSScreen *s in NSScreen.screens) screens = NSUnionRect(screens, [s frame]); // Union the entirety of the frame (not just the visible area)
	fullScreenWindow = [NSWindow.alloc initWithContentRect:screens styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	[fullScreenWindow    setOpaque:NO];		[fullScreenWindow setMovableByWindowBackground:NO];   [fullScreenWindow setBackgroundColor:CLEAR];	
	[fullScreenWindow setHasShadow:NO];	 	[fullScreenWindow orderFrontRegardless];
	
//	[fullScreenWindow overrideSEL:@selector(sendEvent:) withBlock:(__bridge void*)^(id _self, NSE *e)	{
//		StickyNoteView *v = [notes filterOne:^BOOL(id obj) {
//			BOOL inframe = NSPointInRect(e.locationInWindow, [obj frame]);
//			NSLog(@"mousemoved:%@  inNote:%@  shouldignore:%@", AZStringFromPoint(e.locationInWindow), obj, StringFromBOOL(inframe));
//			return inframe;			
//		}];
//		[v ]
//	}];
	[self redirectStdErr];
}
+ (NSFileHandle*) redirectStdErr 				{ 			NSFileHandle *file = [NSFileHandle fileHandleWithStandardOutput];

		int err = dup2([file fileDescriptor], STDERR_FILENO); if (!err)	
		return	NSLog(@"Couldn't redirect stderr"), NO;  
      return file;
}
+(instancetype)instanceWithFrame:(NSR)frame 				{	   				//	[NSEVENTLOCALMASK:NSMouseMovedMask handler:^NSEvent *(NSEvent *e) {	BOOL inframe = NSPointInRect(e.locationInWindow, [self frame]); NSLog(@"mousemoved:  %@  shouldignore: %@", AZStringFromPoint(e.locationInWindow), StringFromBOOL(inframe));	[fullScreenWindow setIgnoresMouseEvents:!inframe];		return e;	}];

	StickyNote *s = self.instance;
	[notes addObject:s.sticky = [StickyNoteView.alloc initWithFrame:frame]];
	s.sticky.proxy = s;
	s.noteColor = [NSC r:0.524 g:0.644 b:0.559 a:1.000];	
	[(NSView*)fullScreenWindow.contentView addSubview:s.sticky]; 		
//	[s.sticky setStringValue:NSS.randomDicksonism];
//	[s.sticky.cell setPlaceholderString:@"Double Click to Edit"];
	[s.sticky setMaxSize:AZScreenSize()];					
	[s.sticky setMinSize:NSMakeSize(75, 75)];
//	[s.sticky.cell setTextColor:GRAY1];					
//	[s.sticky.cell setEditable:NO];								
//	[s.sticky setFont:[NSFont fontWithName:@"UbuntuMono-Bold" size:22.5]];			
//	[self addSubview:u = [AZSimpleView withFrame:frame color:BLACK]];
	CAL *l = [CAL layerWithFrame:s.sticky.bounds]; l.arMASK=CASIZEABLE; l.noHit = YES; [s.sticky.layer addSublayer:s.sticky.glowBar = CAL.new];
	[fullScreenWindow makeKeyAndOrderFront:self];
	return s;
}
-  (NSW*) window 										{  return fullScreenWindow; }

@end
@implementation StickyNoteView

-  (void) viewDidMoveToWindow						{	if (fullScreenWindow) _trackingRectTag = [self addTrackingRect:[self _fillRectForCurrentFrame] owner:self userData:nil assumeInside:NO];	}
-  (void) viewWillMoveToWindow:(NSW*)newW		{	_trackingRectTag && self.window 	?	[self removeTrackingRect:_trackingRectTag] : nil;	}
-  (void) setFrame:		(NSR)frame 				{	super.frame 		= frame;						[self removeTrackingRect:_trackingRectTag];	
																_trackingRectTag	= [self addTrackingRect:[self _fillRectForCurrentFrame] owner:self userData:nil assumeInside:YES];	}
																																										#pragma mark -Note Controls
-  (void) mouseEntered: (NSE*)theEvent 		{	[self setNeedsDisplay:YES];	}
-  (void) mouseExited:	(NSE*)theEvent 		{	[self setNeedsDisplay:YES]; 	}
-  (void) mouseDown:	   (NSE*)theEvent 		{			if ([theEvent clickCount] == 2) { [self _doubleMouse:theEvent]; return; }

	_eventStartPoint 	=  [self 			  convertPoint:theEvent.locationInWindow fromView:nil];
	_lastDragPoint 	= [[[self window]contentView] convertPoint:theEvent.locationInWindow fromView:nil];
//	_draggingMode 		=  [self mouse:_eventStartPoint inRect:[self _resizeHandleRectForCurrentFrame]]
//							?	AZDraggingModeResize
//							:	[self mouse:_eventStartPoint inRect:[self _closeButtonRectForCurrentFrame]]
//							? 	AZDraggingModeNone :	AZDraggingModeMove;
//	NSLog(@"DRAGMODE:%@", AZDraggingModeToString(_draggingMode));
}		
- (void) setAlign:(AZWindowPosition)align{	CGF inset = 20;	NSRect normalRect, edger;
	
	AZPOS newpos = AZOutsideEdgeOfRectInRect(self.frame,self.window.frame);
	if (newpos != _align) {
		
		normalRect = AZRectInsideRectOnEdge(_frame, self.window.frame, newpos);
		
		edger = AZInsetRectInPosition(AZRectFromSize(normalRect.size), (NSSZ) {	_align == AZTop 	|| _align == AZBtm ? self.width : inset ,
																										_align == AZLft 	|| _align == AZRgt 	? self.height : inset}, inset);
		
	//		NSR edgeRect = AZRectInsideRectOnEdge(edger, fillerRect, edgeD);
		[_glowBar animate:@"frame" toRect:edger time:.8]; _glowBar.backgroundColor = cgRANDOMGRAY;
		[_glowBar pulse];
		NSLog(@"Align:%@ in:%@", AZWindowPositionToString(_align), AZStringFromRect(normalRect));
		[self setFrame: normalRect];
		[self.superview setNeedsDisplayInRect:normalRect];// NSUnionRect(origFrame, newFrame)];
		_align = newpos;
	}

}
-  (void) mouseDragged: (NSE*)theEvent 		{

/*
	_lastDragPoint 	= [[self window]contentView] convertPoint:theEvent.locationInWindow fromView:nil];
	NSSZ s = AZDistanceFromPoint(self localPoint, _eventStartPoint);
	
//	_dragThreshold = AZSizeFromPoint(AZPointOffset(NSMakePoint(_dragThreshold.width, _dragThreshold.height), NSMakePoint(theEvent.deltaX, theEvent.deltaY)));
//	if ( AZMaxDim(_dragThreshold) > AZMaxDim(quadrant( AZScreenFrameUnderMenu(), 1).size) ) {
//		self.alignment |=  AZMaxDim(_dragThreshold) < 0 ?  << 1 :  << -1;
//		return;
	}			
//		[[NSBP bezierPathWithRect:edgeRect] strokeWithColor:RED andWidth:2];
//	[[NSBP bezierPathWithRect:[self _fillRectForCurrentFrame]] strokeWithColor:
//		 [[_noteColor colorWithBrightnessMultiplier:2]alpha:.4] andWidth:4];
//	_alignment = self.alignment;
	__block NSRect origFrame, newFrame = self.frame;
	NSPoint newLocation = [self convertPoint:theEvent.locationInWindow fromView:nil];
	float x_amount = _lastDragPoint.x - newLocation.x;
	float y_amount = _lastDragPoint.y - newLocation.y;
	newFrame = _draggingMode == AZDraggingModeMove 	? 	_align == AZBtm || _align == AZTop ? 	AZRectExceptOriginX(newFrame,-x_amount) 
																	:	_align == AZLft || _align == AZRgt ?	AZRectExceptOriginY(newFrame, -y_amount)
																	: AZRectOffset(newFrame, NSMakePoint(-x_amount, y_amount)) : newFrame;
																	
	_draggingMode == AZDraggingModeResize 				? ^{	newFrame.size.width -= x_amount;		newFrame.origin.y -= y_amount;
																			newFrame.size.height += y_amount;	newFrame = [self _constrainRectSize:newFrame]; }() : nil;
	
	_lastDragPoint = newLocation;
	_frame = newFrame;
	
	*/
//	[self setAlign:AZPositionAutomatic];
//	[self setFrame: newFrame];
//	NSR constrained =	AZConstrainRectToRect(self.frame, [[self.window contentView] frame]);
//	if (NSContainsRect([[self superview] bounds], constrained)){  //newFrame)) {
//		[self setFrame:newFrame];

//		[[self superview] setNeedsDisplayInRect:NSUnionRect(origFrame, newFrame)];
//	}
}
-  (void) mouseUp:	   (NSE*)theEvent 		{
	NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	if ( (_draggingMode == AZDraggingModeNone) &&
		 ([self mouse:_eventStartPoint inRect:[self _closeButtonRectForCurrentFrame]]) &&
		 ([self mouse:mousePoint inRect:[self _closeButtonRectForCurrentFrame]]) )
		[self removeFromSuperview];
}
-  (void) _doubleMouse: (NSE*)theEvent			{
	NSRect cellFrame = [self _cellRectForCurrentFrame];
	NSText *editor = [self.window fieldEditor:YES forObject:self];
//	[[self cell] setEditable:YES];
//	[[self cell] editWithFrame:cellFrame inView:self editor:editor delegate:self event:theEvent];
}
																																								#pragma mark -Editor Delegate Methods
-  (void)    textDidBeginEditing: (NSNOT*)n 	{  [AZTalker say:@"editing textfield"]; }
-  (void) textDidChange:	     	 (NSNOT*)n 	{	}
-  (void) textDidEndEditing:	    (NSNOT*)n 	{
//	[self validateEditing];
	[self.window endEditingFor:self];
//	[[self cell] setEditable:NO];
}
-  (BOOL) textShouldBeginEditing:(NSText*)t	{
	return YES;
}
-  (BOOL) textShouldEndEditing:	(NSText*)t	{
	return YES;
}
																																													#pragma mark -Drawing
-  (void) drawRect:					(NSR)rect	{
	NSRect fillRect = [self _fillRectForCurrentFrame];
	/* draw background
	 NSColor *baseColor = [_noteColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	 NSColor *hiColor = [NSColor colorWithCalibratedHue:[baseColor hueComponent] - 0.02
	 saturation:[baseColor saturationComponent] - 0.1
	 brightness:[baseColor brightnessComponent] + 0.1
	 alpha:[baseColor alphaComponent]];
	 NSColor *loColor = [NSColor colorWithCalibratedHue:[baseColor hueComponent]
	 saturation:[baseColor saturationComponent] + 0.05
	 brightness:[baseColor brightnessComponent] - 0.05
	 alpha:[baseColor alphaComponent]];
	 NSColor *topColor = ([self isFlipped]) ? loColor : hiColor;
	 NSColor *bottomColor = ([self isFlipped]) ? hiColor : loColor;
	 CIColor *ciTopColor = [CIColor colorWithRed:[topColor redComponent] green:[topColor greenComponent] blue:[topColor blueComponent] alpha:[topColor alphaComponent]];
	 CIColor *ciBottomColor = [CIColor colorWithRed:[bottomColor redComponent] green:[bottomColor greenComponent] blue:[bottomColor blueComponent] alpha:[bottomColor alphaComponent]];
	 CIVector *startVector = [CIVector vectorWithX:0.0 Y:0.0];
	 CIVector *endVector = [CIVector vectorWithX:0.0 Y:fillRect.size.height];
	 CIFilter *gradFilter = [CIFilter filterWithName:@"CILinearGradient"];
	 [gradFilter setDefaults];
	 [gradFilter setValue:ciTopColor forKey:@"inputColor0"];
	 [gradFilter setValue:ciBottomColor forKey:@"inputColor1"];
	 [gradFilter setValue:startVector forKey:@"inputPoint0"];
	 [gradFilter setValue:endVector forKey:@"inputPoint1"];
	 CIImage *grad = [gradFilter valueForKey:@"outputImage"];
	 [AZGRAPHICSCTX saveGraphicsState];
	 */
	[[NSSHDW shadowWithOffset:NSMakeSize(0.0, -1.0) blurRadius:3.0 color:[BLACK alpha:.3]] set];
	//	CIContext *context = [AZGRAPHICSCTX CIContext];
	[[NSGradient gradientFrom:[[self.proxy vFK:@"noteColor"]brighter] to:[[self.proxy vFK:@"noteColor"]darker].darker]drawInRect:rect angle:270];
	[NSSHDW clearShadow];
	//	[context drawImage:grad atPoint:CGPointMake(fillRect.origin.x, fillRect.origin.y) fromRect:CGRectMake(0.0, 0.0, fillRect.size.width, fillRect.size.height)];
	//	[AZGRAPHICSCTX restoreGraphicsState];
	//	[shadow release];
	/* draw cell */
//	if ([self currentEditor] == nil) {
		NSRect cellFrame = [self _cellRectForCurrentFrame];
//		[self.cell drawWithFrame:cellFrame inView:self];
//	}
	/* draw controls */
	NSPoint mouseLoc = [self convertPoint:[self.window mouseLocationOutsideOfEventStream] fromView:nil];
	NSRect fillerRect = [self _fillRectForCurrentFrame];
	if ([self mouse:mouseLoc inRect:fillRect]) {
			[[GRAY2 alpha:0.8] set];
		NSRect closeRect = NSInsetRect([self _closeButtonRectForCurrentFrame], 3.0, 3.0);
		NSBP *path = NSBP.bezierPath;
		[path setLineWidth:1];
		[path moveToPoint:NSMakePoint(closeRect.origin.x, closeRect.origin.y)];
		[path lineToPoint:NSMakePoint(closeRect.origin.x + closeRect.size.width, closeRect.origin.y + closeRect.size.height)];
		[path moveToPoint:NSMakePoint(closeRect.origin.x, closeRect.origin.y + closeRect.size.height)];
		[path lineToPoint:NSMakePoint(closeRect.origin.x + closeRect.size.width, closeRect.origin.y)];
		[path stroke];
		NSR resizeRect = NSInsetRect([self _resizeHandleRectForCurrentFrame], 3.0, 3.0);
		path = NSBP.bezierPath;
		[path setLineWidth:1];
		[path moveToPoint:NSMakePoint(resizeRect.origin.x, resizeRect.origin.y)];
		[path lineToPoint:NSMakePoint(resizeRect.origin.x + resizeRect.size.width, resizeRect.origin.y + resizeRect.size.height)];
		[path moveToPoint:NSMakePoint(resizeRect.origin.x + 3.0, resizeRect.origin.y)];
		[path lineToPoint:NSMakePoint(resizeRect.origin.x + resizeRect.size.width, resizeRect.origin.y + (resizeRect.size.height - 3.0))];
		[path stroke];
	}
}
+ (Class) cellClass     		 					{	return NSTextFieldCell.class;	}
																																												#pragma mark -Geometry
-  (NSR) _fillRectForCurrentFrame			 	{
	NSRect noteRect = [self bounds];
	noteRect.size.height -= 4.0;
	noteRect.size.width -= 6.0;
	noteRect.origin.y += 3.0;
	noteRect.origin.x += 3.0;
	return noteRect;
}
-  (NSR) _cellRectForCurrentFrame 				{
	return NSInsetRect([self _fillRectForCurrentFrame], 10.0, 10.0);
}
-  (NSR) _closeButtonRectForCurrentFrame	 	{
	NSRect bRect = [self _fillRectForCurrentFrame];
	CGF baseDim = 16;
	bRect.origin.y = (NSMaxY(bRect) - baseDim);
	bRect.size.height = baseDim;
	bRect.size.width = baseDim;
	return bRect;
}
-  (NSR) _resizeHandleRectForCurrentFrame 	{
	NSRect rRect = [self _fillRectForCurrentFrame];
	rRect.origin.x = (NSMaxX(rRect) - 12.0);
	rRect.size.width = 12.0;
	rRect.size.height = 12.0;
	return rRect;
}
-  (NSR) _constrainRectSize:     (NSR)rect	{
	NSRect r = rect;
	NSSize max = self.maxSize;
	NSSize min = self.minSize;
	r.size.width = (r.size.width < max.width) ? r.size.width : max.width;
	r.size.width = (r.size.width > min.width) ? r.size.width : min.width;
	r.size.height = (r.size.height < max.height) ? r.size.height : max.height;
	r.size.height = (r.size.height > min.height) ? r.size.height : min.height;
	if (r.size.height != rect.size.height)
		r.origin.y += (rect.size.height - r.size.height);
	return r;
}
@end
/*
-   (NSR) frame:			(NSR)windowFrame		{
	NSRect newR = self.bounds; NSR screenFrame = AZScreenFrameUnderMenu();
	//Left
	if (ABS(NSMinX(self.frame) - NSMinX(screenFrame)) < NSMaxX(screenFrame)/2)
		newR.origin.x = screenFrame.origin.x;
	//Bottom
	if (ABS(NSMinY(self.frame) - NSMinY(screenFrame)) < NSMaxY(screenFrame)/2)
		newR.origin.y = screenFrame.origin.y;
	//Right
	if (ABS(NSMaxX(self.frame) - NSMaxX(screenFrame)) < NSMaxY(screenFrame)/2)
		newR.origin.x -= NSMaxX(self.frame) - NSMaxX(screenFrame);
	//Top
	if (ABS(NSMaxY(self.frame) - NSMaxY(screenFrame)) < NSMaxY(screenFrame)/2)
		newR.origin.y -= NSMaxY(self.frame) - NSMaxY(screenFrame);
	
	return newR;
}

*/

@interface AZStickyNoteView (PrivateMethods)

- (void) _doubleMouse:(NSEvent *)theEvent;
- (NSRect) _fillRectForCurrentFrame;
- (NSRect) _cellRectForCurrentFrame;
- (NSRect) _closeButtonRectForCurrentFrame;
- (NSRect) _resizeHandleRectForCurrentFrame;
- (NSRect) _constrainRectSize:(NSRect)rect;

@end


@implementation AZStickyNoteView

+ (Class)cellClass										{    return NSTextFieldCell.class;	}
- (id)initWithFrame:(NSRect)frame 					{
    if (self != [super initWithFrame:frame]) return nil;
	 _noteColor = [NSC r:0.99 g:0.96 b:0.61 a:1.0];
	
	[self setStringValue:@""];
	[self setTextColor:[NSColor colorWithCalibratedWhite:0.25 alpha:1.0]];
	[self setFont:[NSFont fontWithName:@"Marker Felt" size:12.5]];
	[self setPlaceholderString:@"Double Click to Edit"];
	[self setMinSize:NSMakeSize(75,75)];
	[self setMaxSize:NSMakeSize(200,200)];
	
	[[self cell] setEditable:NO];
	return self;
}
- (void) iewDidMoveToWindow							{	
		_trackingRectTag = (self.window) ? [self addTrackingRect:[self _fillRectForCurrentFrame] owner:self userData:nil assumeInside:NO] : _trackingRectTag;
}
- (void) iewWillMoveToWindow:(NSWindow*)w			{
	if ( (self.window) && _trackingRectTag ) [self removeTrackingRect:_trackingRectTag];
}
- (void) setFrame:(NSRect)frame 						{
    [super setFrame:frame];
    [self removeTrackingRect:_trackingRectTag];
    _trackingRectTag = [self addTrackingRect:[self _fillRectForCurrentFrame] owner:self userData:nil assumeInside:YES];
}

#pragma mark Note Properties
- (void) setTextColor:(NSColor *)col					{	[[self cell] setTextColor:col];	}
- (NSColor *)textColor									{	return [[self cell] textColor];	}
- (void) setPlaceholderString:(NSString *)string	{	[[self cell] setPlaceholderString:string];	}
- (NSString *)placeholderString						{	return [[self cell] placeholderString];		}
#pragma mark Note Controls
- (void) mouseEntered:(NSE*)e	{		[self setNeedsDisplay:YES];	}
- (void) mouseExited: (NSE*)e	{	[self setNeedsDisplay:YES];	}
- (void) mouseDown:	(NSE*)e	{
	if(e.clickCount == 2)		{		[self _doubleMouse:e];	return;		}
	_eventStartPoint 	= [self convertPoint:e.locationInWindow fromView:nil];
	_lastDragPoint 	= [self.superview convertPoint:e.locationInWindow fromView:nil];
	_draggingMode 		= [self mouse:_eventStartPoint inRect:self._resizeHandleRectForCurrentFrame] ? AZDraggingModeResize:
							  [self mouse:_eventStartPoint inRect:self._closeButtonRectForCurrentFrame]  ? AZDraggingModeNone  : 
																																	 AZDraggingModeMove  ;
}
- (void) mouseDragged:(NSE*)e	{
	NSRect origFrame = self.frame, newFrame = self.frame;
	NSPoint newLocation = [[self superview] convertPoint:e.locationInWindow fromView:nil];
	
	float x_amount=_lastDragPoint.x-newLocation.x;
	float y_amount=_lastDragPoint.y-newLocation.y;
	
	if(_draggingMode == AZDraggingModeMove)
	{
		newFrame.origin.x -= x_amount;
		newFrame.origin.y -= y_amount;
	}
	
	if(_draggingMode == AZDraggingModeResize)
	{
		newFrame.size.width -= x_amount;
		newFrame.origin.y -= y_amount;
		newFrame.size.height += y_amount;
		
		newFrame = [self _constrainRectSize:newFrame];
	}
	
	if(NSContainsRect([[self superview] bounds], newFrame))
	{
		[self setFrame:newFrame];
		_lastDragPoint = newLocation;
		[[self superview] setNeedsDisplayInRect:NSUnionRect(origFrame, newFrame)];
	}
}
- (void) mouseUp:		(NSE*)e	{

	NSPoint mousePoint = [self convertPoint:e.locationInWindow fromView:nil];

	(_draggingMode == AZDraggingModeNone && [self mouse:_eventStartPoint inRect:self._closeButtonRectForCurrentFrame])  
													 && [self mouse:mousePoint inRect:self._closeButtonRectForCurrentFrame]
	? ^{ if (self == [self.window contentView]) [self.window orderOut:nil]; else [self removeFromSuperview];	}() : nil;
		
}
- (void)_doubleMouse:(NSE*)e	{
	NSRect cellFrame 	= [self _cellRectForCurrentFrame];
	NSText *editor 	= [self.window fieldEditor:YES forObject:self];
	[self.cell setEditable:YES];
	[self.cell editWithFrame:cellFrame inView:self editor:editor delegate:self event:e];
}
#pragma mark Editor Delegate Methods
- (void) textDidBeginEditing:	  (NSNOT*)n		{}
- (void) textDidChange:		 	  (NSNOT*)n		{}
- (void) textDidEndEditing:	  (NSNOT*)n		{
	[self validateEditing];
	[[self window] endEditingFor:self];
	[[self cell] setEditable:NO];
}
- (BOOL) textShouldBeginEditing:(NSText*)txt	{	return YES;}
- (BOOL) textShouldEndEditing:  (NSText*)txt	{	return YES;	}
#pragma mark Drawing
- (void) drawRect:			  	  (NSR)rect		{
	NSRect fillRect = [self _fillRectForCurrentFrame];
	/* draw background */
	NSColor *baseColor = [_noteColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
	NSColor *hiColor = [NSColor colorWithCalibratedHue:baseColor.hueComponent-0.02
											saturation:baseColor.saturationComponent-0.1 
											brightness:baseColor.brightnessComponent+0.1 
												 alpha:baseColor.alphaComponent];
	NSColor *loColor = [NSColor colorWithCalibratedHue:baseColor.hueComponent 
											saturation:baseColor.saturationComponent+0.05 
											brightness:baseColor.brightnessComponent-0.05
												 alpha:baseColor.alphaComponent];
	
	NSColor *topColor = ([self isFlipped]) ? loColor : hiColor;
	NSColor *bottomColor =([self isFlipped]) ? hiColor : loColor;
	CIColor* ciTopColor = [CIColor colorWithRed:[topColor redComponent] green:[topColor greenComponent] blue:[topColor blueComponent] alpha:[topColor alphaComponent]];
	CIColor* ciBottomColor = [CIColor colorWithRed:[bottomColor redComponent] green:[bottomColor greenComponent] blue:[bottomColor blueComponent] alpha:[bottomColor alphaComponent]];
	
	CIVector *startVector = [CIVector vectorWithX:0.0 Y:0.0];
	CIVector *endVector = [CIVector vectorWithX:0.0 Y:fillRect.size.height];
	
	CIFilter* gradFilter = [CIFilter filterWithName:@"CILinearGradient"];
	[gradFilter setDefaults];
	[gradFilter setValue:ciTopColor forKey:@"inputColor0"];
	[gradFilter setValue:ciBottomColor forKey:@"inputColor1"];
	[gradFilter setValue:startVector forKey:@"inputPoint0"];
	[gradFilter setValue:endVector forKey:@"inputPoint1"];
	
	CIImage *grad = [gradFilter valueForKey:@"outputImage"];
	
	[NSGraphicsContext state:^{
			
		NSShadow *shadow=NSShadow.new;
		[shadow setShadowOffset:NSMakeSize(0.0,-1.0)];
		[shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.3]];
		[shadow setShadowBlurRadius:3.0];
		[shadow set];
		
		CIContext *context = [NSGraphicsContext.currentContext CIContext];	
		[context drawImage:grad atPoint:CGPointMake(fillRect.origin.x, fillRect.origin.y) fromRect:CGRectMake(0.0, 0.0, fillRect.size.width, fillRect.size.height)];
	}];
	/* draw cell */
	if([self currentEditor] == nil)
	{
		NSRect cellFrame = [self _cellRectForCurrentFrame];
		[[self cell] drawWithFrame:cellFrame inView:self];
	}
	/* draw controls */
	NSPoint mouseLoc = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
	if([self mouse:mouseLoc inRect:[self _fillRectForCurrentFrame]])
	{
		[[NSColor colorWithCalibratedWhite:0.5 alpha:0.5] set];
		NSRect closeRect = NSInsetRect([self _closeButtonRectForCurrentFrame], 3.0, 3.0);
		NSBezierPath *path = [NSBezierPath bezierPath];
		[path setLineWidth:1];
		[path moveToPoint:NSMakePoint(closeRect.origin.x, closeRect.origin.y)];
		[path lineToPoint:NSMakePoint(closeRect.origin.x + closeRect.size.width, closeRect.origin.y + closeRect.size.height)];
		[path moveToPoint:NSMakePoint(closeRect.origin.x, closeRect.origin.y + closeRect.size.height)];
		[path lineToPoint:NSMakePoint(closeRect.origin.x + closeRect.size.width, closeRect.origin.y)];
		[path stroke];
		
		NSRect resizeRect = NSInsetRect([self _resizeHandleRectForCurrentFrame], 3.0, 3.0);
		path = [NSBezierPath bezierPath];
		[path setLineWidth:1];
		[path moveToPoint:NSMakePoint(resizeRect.origin.x, resizeRect.origin.y)];
		[path lineToPoint:NSMakePoint(resizeRect.origin.x + resizeRect.size.width, resizeRect.origin.y + resizeRect.size.height)];
		[path moveToPoint:NSMakePoint(resizeRect.origin.x +3.0, resizeRect.origin.y)];
		[path lineToPoint:NSMakePoint(resizeRect.origin.x + resizeRect.size.width, resizeRect.origin.y + (resizeRect.size.height -3.0))];
		[path stroke];
	}
}
#pragma mark Geometry
-  (NSR) _fillRectForCurrentFrame				{
	NSRect noteRect = [self bounds];
	noteRect.size.height -= 4.0;
	noteRect.size.width -= 6.0;
	noteRect.origin.y += 3.0;
	noteRect.origin.x += 3.0;
	return noteRect;
}
-  (NSR) _cellRectForCurrentFrame				{
	return NSInsetRect([self _fillRectForCurrentFrame], 10.0, 10.0);
}
-  (NSR) _closeButtonRectForCurrentFrame		{

	NSRect bRect = [self _fillRectForCurrentFrame];
	bRect.origin.y = (NSMaxY(bRect) - 12.0);
	bRect.size.height = 12.0;
	bRect.size.width = 12.0;

	return bRect;
}
-  (NSR) _resizeHandleRectForCurrentFrame		{
	NSRect rRect = [self _fillRectForCurrentFrame];
	rRect.origin.x = (NSMaxX(rRect) - 12.0);
	rRect.size.width = 12.0;
	rRect.size.height = 12.0;
	return rRect;
}
-  (NSR) _constrainRectSize:	  (NSR)rect		{

	NSRect r = rect;	NSSize max = [self maxSize], min = [self minSize];
	r.size.width = (r.size.width < max.width) ? r.size.width : max.width;
	r.size.width = (r.size.width > min.width) ? r.size.width : min.width;
	r.size.height = (r.size.height < max.height) ? r.size.height : max.height;
	r.size.height = (r.size.height > min.height) ? r.size.height : min.height;
	if (r.size.height != rect.size.height) r.origin.y += (rect.size.height - r.size.height);	
	return r;
}
@end
