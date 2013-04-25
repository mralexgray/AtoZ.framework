#import "StickyNoteView.h"

@implementation StickyNoteView
static NSW* fullScreenWindow = nil;
+  (void) initialize 										{
	NSRect frame = NSZeroRect;
	for(NSScreen *screen in [NSScreen screens]) frame = NSUnionRect(frame, screen.frame);

	fullScreenWindow = [NSWindow.alloc initWithContentRect:frame styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
	[fullScreenWindow setOpaque:NO];
	[fullScreenWindow setMovableByWindowBackground:NO];
	fullScreenWindow.hasShadow = NO;
	fullScreenWindow.backgroundColor = CLEAR;
	[fullScreenWindow orderFrontRegardless];
}
+ (Class) cellClass     		 							{	return NSTextFieldCell.class;	}
-    (id) initWithFrame:(NSR)frame 						{	if (self != [super initWithFrame:frame]) return nil;

	_noteColor = [NSColor colorWithCalibratedRed:0.524 green:0.644 blue:0.559 alpha:1.000];
	[self setStringValue:@""];
	[self setTextColor:GRAY2];
	[self setFont:[NSFont fontWithName:@"UbuntuMono-Bold" size:15.5]];
	[self setPlaceholderString:@"Double Click to Edit"];
	[self setMinSize:NSMakeSize(75, 75)];
	[self setMaxSize:AZScreenSize()];
	[self.cell setEditable:NO];
	[fullScreenWindow overrideSEL:@selector(mouseDown:) withBlock:(__bridge void*)^(id _self, NSE *e)	{
		BOOL inframe = NSPointInRect(e.locationInWindow, [self frame]);
		NSLog(@"mousemoved:  %@  shouldignore: %@", AZStringFromPoint(e.locationInWindow), StringFromBOOL(inframe));
	}];
	//		[fullScreenWindow setIgnoresMouseEvents:!inframe];	[fullScreenWindow sendEvent:e];
	//	[NSEVENTLOCALMASK:NSMouseMovedMask handler:^NSEvent *(NSEvent *e) {	BOOL inframe = NSPointInRect(e.locationInWindow, [self frame]);
	////		NSLog(@"mousemoved:  %@  shouldignore: %@", AZStringFromPoint(e.locationInWindow), StringFromBOOL(inframe));
	//		[fullScreenWindow setIgnoresMouseEvents:!inframe];		return e;	}];
	[[fullScreenWindow contentView] addSubview:self];
	[fullScreenWindow makeKeyAndOrderFront:self];
	return self;
}
-  (void) viewDidMoveToWindow								{
	if (self.window != nil) _trackingRectTag = [self addTrackingRect:[self _fillRectForCurrentFrame] owner:self userData:nil assumeInside:NO];
}
-  (void) viewWillMoveToWindow:(NSW*)newWindow 		{	if ( (self.window != nil) && _trackingRectTag)	[self removeTrackingRect:_trackingRectTag];	}
-  (void) setFrame:(NSR)frame 							{
	[super setFrame:frame];
	[self removeTrackingRect:_trackingRectTag];
	_trackingRectTag = [self addTrackingRect:[self _fillRectForCurrentFrame] owner:self userData:nil assumeInside:YES];
}
#pragma mark -Note Controls
- (void)mouseEntered:(NSE*)theEvent 					{
	[self setNeedsDisplay:YES];
}
- (void)mouseExited:	(NSE*)theEvent 					{	[self setNeedsDisplay:YES]; }
- (void)mouseDown:	(NSE*)theEvent 					{			if ([theEvent clickCount] == 2) { [self _doubleMouse:theEvent]; return; }

	_eventStartPoint 	=  [self 			  convertPoint:theEvent.locationInWindow fromView:nil];
	_lastDragPoint 	= [[self superview] convertPoint:theEvent.locationInWindow fromView:nil];
	_draggingMode 		=  [self mouse:_eventStartPoint inRect:[self _resizeHandleRectForCurrentFrame]]
							?	MWDraggingModeResize
							:	[self mouse:_eventStartPoint inRect:[self _closeButtonRectForCurrentFrame]]
							? 	MWDraggingModeNone :	MWDraggingModeMove;
	_edge = self.edge;
}
- (AZPOS) edge										{
	_edge =  AZOutsideEdgeOfRectInRect (self.window.frame	,self.frame );
	NSLog(@"newEdge: %@", stringForPosition(_edge));
	return _edge;
}
- (void)mouseDragged:(NSE*)theEvent 					{


	NSRect origFrame, newFrame = self.frame;
	NSPoint newLocation = [[self superview] convertPoint:theEvent.locationInWindow fromView:nil];
	float x_amount = _lastDragPoint.x - newLocation.x;
	float y_amount = _lastDragPoint.y - newLocation.y;
	if (_draggingMode == MWDraggingModeMove) {
		if (_edge == AZPositionBottom || _edge == AZPositionTop)
			newFrame.origin.x -= x_amount;
		else if (self.edge == AZPositionRight || _edge == AZPositionLeft)
			newFrame.origin.y -= y_amount;
		else {
			newFrame.origin.x -= x_amount;
			newFrame.origin.y -= y_amount;
		}
	}
	if (_draggingMode == MWDraggingModeResize) {
		newFrame.size.width -= x_amount;
		newFrame.origin.y -= y_amount;
		newFrame.size.height += y_amount;
		newFrame = [self _constrainRectSize:newFrame];
	}
	if (NSContainsRect([[self superview] bounds], newFrame)) {
		[self setFrame:newFrame];
		_lastDragPoint = newLocation;
		[[self superview] setNeedsDisplayInRect:NSUnionRect(origFrame, newFrame)];
	}
}
- (void)mouseUp:(NSEvent *)theEvent {
	NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	if ( (_draggingMode == MWDraggingModeNone) &&
		 ([self mouse:_eventStartPoint inRect:[self _closeButtonRectForCurrentFrame]]) &&
		 ([self mouse:mousePoint inRect:[self _closeButtonRectForCurrentFrame]]) )
		[self removeFromSuperview];
}
- (void)_doubleMouse:(NSEvent *)theEvent {
	NSRect cellFrame = [self _cellRectForCurrentFrame];
	NSText *editor = [self.window fieldEditor:YES forObject:self];
	[[self cell] setEditable:YES];
	[[self cell] editWithFrame:cellFrame inView:self editor:editor delegate:self event:theEvent];
}
#pragma mark -Editor Delegate Methods
- (void)textDidBeginEditing:(NSNotification *)aNotification {
}
- (void)textDidChange:(NSNotification *)aNotification {
}
- (void)textDidEndEditing:(NSNotification *)aNotification {
	[self validateEditing];
	[self.window endEditingFor:self];
	[[self cell] setEditable:NO];
}
- (BOOL)textShouldBeginEditing:(NSText *)aTextObject {
	return YES;
}
- (BOOL)textShouldEndEditing:(NSText *)aTextObject {
	return YES;
}
#pragma mark -Drawing
- (void)drawRect:(NSR)rect {
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
	 [[NSGraphicsContext currentContext] saveGraphicsState];
	 */
	[[NSSHDW shadowWithOffset:NSMakeSize(0.0, -1.0) blurRadius:3.0 color:[BLACK alpha:.3]] set];
	//	CIContext *context = [[NSGraphicsContext currentContext] CIContext];
	[[NSGradient gradientFrom:_noteColor.brighter to:_noteColor.darker.darker]drawInRect:rect angle:270];
	[NSSHDW clearShadow];
	//	[context drawImage:grad atPoint:CGPointMake(fillRect.origin.x, fillRect.origin.y) fromRect:CGRectMake(0.0, 0.0, fillRect.size.width, fillRect.size.height)];
	//	[[NSGraphicsContext currentContext] restoreGraphicsState];
	//	[shadow release];
	/* draw cell */
	if ([self currentEditor] == nil) {
		NSRect cellFrame = [self _cellRectForCurrentFrame];
		[self.cell drawWithFrame:cellFrame inView:self];
	}
	/* draw controls */
	NSPoint mouseLoc = [self convertPoint:[self.window mouseLocationOutsideOfEventStream] fromView:nil];
	NSRect fillerRect = [self _fillRectForCurrentFrame];
	if ([self mouse:mouseLoc inRect:fillRect]) {
		AZPOS edgeD = self.edge;
		CGF inset = 20;
		NSRect edger = edgeD == AZPositionTop || edgeD == AZPositionBottom ? AZRectBy(fillerRect.size.width, inset)
				:			edgeD == AZPositionLeft || edgeD == AZPositionRight ? AZRectBy(inset, fillerRect.size.height)
				:	AZRectFromDim(inset);
		NSR edgeRect = AZRectInsideRectOnEdge(edger, fillerRect, edgeD);
		[[NSBP bezierPathWithRect:edgeRect] strokeWithColor:RED andWidth:2];

		[[NSBP bezierPathWithRect:[self _fillRectForCurrentFrame]] strokeWithColor:
		 [[_noteColor colorWithBrightnessMultiplier:2]alpha:.4] andWidth:4];
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
#pragma mark -Geometry
- (NSR)_fillRectForCurrentFrame {
	NSRect noteRect = [self bounds];
	noteRect.size.height -= 4.0;
	noteRect.size.width -= 6.0;
	noteRect.origin.y += 3.0;
	noteRect.origin.x += 3.0;
	return noteRect;
}
- (NSR)_cellRectForCurrentFrame {
	return NSInsetRect([self _fillRectForCurrentFrame], 10.0, 10.0);
}
- (NSR)_closeButtonRectForCurrentFrame {
	NSRect bRect = [self _fillRectForCurrentFrame];
	CGF baseDim = 16;
	bRect.origin.y = (NSMaxY(bRect) - baseDim);
	bRect.size.height = baseDim;
	bRect.size.width = baseDim;
	return bRect;
}
- (NSR)_resizeHandleRectForCurrentFrame {
	NSRect rRect = [self _fillRectForCurrentFrame];
	rRect.origin.x = (NSMaxX(rRect) - 12.0);
	rRect.size.width = 12.0;
	rRect.size.height = 12.0;
	return rRect;
}
- (NSR)_constrainRectSize:(NSR)rect {
	NSRect r = rect;
	NSSize max = [self maxSize];
	NSSize min = [self minSize];
	r.size.width = (r.size.width < max.width) ? r.size.width : max.width;
	r.size.width = (r.size.width > min.width) ? r.size.width : min.width;
	r.size.height = (r.size.height < max.height) ? r.size.height : max.height;
	r.size.height = (r.size.height > min.height) ? r.size.height : min.height;
	if (r.size.height != rect.size.height)
		r.origin.y += (rect.size.height - r.size.height);
	return r;
}
@end
