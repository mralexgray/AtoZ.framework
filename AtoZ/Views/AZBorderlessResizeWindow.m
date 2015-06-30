
#import <AtoZ/AtoZ.h>
#import "AZBorderlessResizeWindow.h"

@implementation  AZHandlebarWindow

-   (id) init {  if (!(self = [super initWithContentRect:NSZeroRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO])) return nil;

  self.acceptsFirstResponder = NO; [self overrideCanBecomeKeyWindow:NO];  [self overrideCanBecomeMainWindow:NO];

  _color = [RED alpha:.5];  self.view = [BLKV viewWithFrame:self.contentRect drawBlock:^(NSV*v,NSR r) {

    AZHandlebarWindow        * handle = (id)v.window;
    AZBorderlessResizeWindow * parent = (id)handle.parentWindow;
    [AZGRAPHICSCTX setCompositingOperation:NSCompositePlusDarker];

    NSBP * pth  = [NSBP bezierPathWithRoundedRect:r cornerRadius:parent.cornerRadius aligned:parent.mouseEdge];

    if      (parent.mouseEdge == AZPositionCenter)    [pth fillWithColor:[BLACK alpha:.3]];

    else if (parent.mouseEdge == AZPositionOutside
                && ISA(parent,AZMagneticEdgeWindow))  [pth fillWithColor:PINK];// NSFrameRectWithWidthWithColor(mag.inFrame.r, 4, BLACK);

    else [pth fillGradientFrom:handle.color to:CLEAR startAlign:parent.mouseEdge];

  }]; self.ignoresMouseEvents = YES;   // self.animationBehavior = NSWindowAnimationBehaviorNone;

  self.movable = self.acceptsMouseMovedEvents = self.movableByWindowBackground = NO; return self;
}
//- (void) sendEvent:(NSE*)e { [self.parentWindow sendEvent:e]; }
@end

//@interface      EdgeIndicatorLayer   : CAL @property AZPOS pos; @end
//@implementation EdgeIndicatorLayer
//+ (BOOL) needsDisplayForKey:(NSString *)key { XX(key); return SameString(key, @"pos"); }
//- (void) drawInContext:(CGContextRef)ctx {
//  [NSGC drawInContext:ctx flipped:NO actions:^{
//    [[NSBP bezierPathWithTriangleInRect:self.bounds orientation:self.pos] fillWithColor:PURPLE];
//  }];
//}
//@end


@implementation ClearWin /* ROOT CLASS */

+ (INST) withFrame:(NSR)r { return [self.class.alloc initWithFrame:r];  }
- initWithFrame:(NSR)r    { return self = [super initWithContentRect:r styleMask:0|2|4|8 backing:NSBackingStoreBuffered defer:NO] ? self.title = @"poop", self : nil; }
- (NSC*) backgroundColor  { return CLEAR; } /* CLEAR  */
- (BOOL) isOpaque         { return NO;    } /* NO     */
@end


@implementation AZBorderlessResizeWindow //@property (NA)  NSP   mouseLocation, dragStart;  @property (NA) BOOL   dragging, resizing, mouseDown; @property (NA)  NSR   dragFrame;

+ (NSD*) codableProperties {

  return [[NSD dictionaryWithValue:@"NSNumber"
                           forKeys:SPLIT(handleInset|cornerRadius|mouseEdge|screenEdge|isOnEdge|isDragging|isHovered|isResizing|isClicked)]
               dictionaryWithValue:@"NSValue"
                           forKeys:SPLIT(snappedRect|contentRect|mouseLocation|mouseEdgeRect|bounds)];
}
- initWithFrame:(NSR)r {

  if (!(self = [super initWithFrame:r])) return nil;  //   styleMask:0|NSResizableWindowMask backing:b > 2 ? 2 : b defer:d] ))

  [self  overrideCanBecomeKeyWindow:YES]; [self overrideCanBecomeMainWindow:YES];

  self.level = NSNormalWindowLevel;      self.delegate = (id)self;
  self.movableByWindowBackground  = YES; self.isVisible = self.acceptsMouseMovedEvents = YES;

  _cornerRadius       = 5;
  _handleInset        = 30;  // Size of handlebar
  self.childWindows   = @[_handle = AZHandlebarWindow.new];
  self.view = [BLKVIEW viewWithFrame:self.contentRect drawBlock:^(NSV*v,NSR rect) {

    NSBP *winPth = [NSBP bezierPathWithRoundedRect:rect cornerRadius:_cornerRadius];
    [winPth fillWithColor:LINEN];
    [GREEN set];
    NSRectFillUsingOperation(self.mouseEdgeRect, NSCompositePlusDarker);
    NSR r = AZCornerRectPositionedWithSize(rect, self.screenEdge, AZSizeFromDim(60));
    [[NSBP bezierPathWithTriangleInRect:r orientation:self.screenEdge] fillWithColor:PURPLE];
    [winPth bezel];
//    [self.codableProperties .attributedWithDefaults drawInRect:rect];
  }];
//  EdgeIndicatorLayer *indi;
//  [self.view.layer addSublayer:indi = [EdgeIndicatorLayer layerWithFrame:AZCornerRectPositionedWithSize(self.contentRect, AZPositionTopRight, AZSizeFromDim(60))]];

//  [indi    b:@"pos"   tO:self wKP:@"screenEdge"  o:nil]; [indi setNeedsDisplay];

//  [_handle b:@"faded" tO:self wKP:@"mouseEdge"    t:^id(id mE) { return  @([mE uIV] == AZPositionOutside); }];
//  [self    b:@"frame" tO:self wKP:@"snappedRect"  o:nil];

//  [_handle b:@"frame" tO:self wKP:@"mouseEdgeRect"    o:nil]; /* update _handle's frame when our active edge rect changes */
//  [self observeNotificationsUsingBlocks:
//  NSWindowWillStartLiveResizeNotification,  ^(NSNOT*n) { self.mouseDown = self.dragging = YES; }, nil];
//  NSWindowDidMoveNotification,              ^(NSNOT*n) {
//      [n.object triggerChangeForKeys:@[@"frame"]]; }, nil];  //screenEdge"]]; }, nil];//self.dragFrame = [n.object frame]; XX(@"didMoveNote"); }, nil];
//  [self b:@"dragStart" tO:self wKP:@"dragging" t:^id(id value) { return AZVpoint([value bV] ? NSE.mouseLocation : NSZeroPoint); /* save initial mouse Location point */ }];
  return self;
}
//+ (NSSet*) kPfVAVfK:(NSS*)k {  objswitch(k)
//
//    objcase     (@"isHovered") RET_SPLIT_SET(mouseLocation);          // can change anytime mouse moves
//    objcase      (@"isOnEdge") RET_SPLIT_SET(mouseLocation);          // can change anytime mouse moves
//    objcase     (@"mouseEdge") RET_SPLIT_SET(mouseLocation);//|isOnEdge);
//    objcase (@"mouseEdgeRect") RET_SPLIT_SET(mouseEdge|frame);
//    objcase    (@"screenEdge") RET_SPLIT_SET(dragFrame|frame);
//    objcase      (@"dragging") RET_SPLIT_SET(mouseDown);
//
//    defaultcase return  [super kPfVAVfK:k]; endswitch
//}
-  (void) setNeedsDisplay:(BOOL)x { [self.view setNeedsDisplay:x]; }

-  (BOOL) isHovered         { return NSPointInRect(NSE.mouseLocation,self.frame);                              }
-  (BOOL) isOnEdge          { return AZPointIsInInsetRects(_mouseLocation, self.contentRect, AZSizeFromDim(_handleInset)); }
- (AZPOS) mouseEdge         { /* update mouseOnEdgeBool whenever mouse moves. */

  return !self.isOnEdge ? NSPointInRect(_mouseLocation,self.contentRect) ? AZCntr : AZOtsd
                           : AZPosOfPointInInsetRects(_mouseLocation, self.contentRect, AZSizeFromDim(_handleInset));
}
- (AZPOS) screenEdge        { return [self.view setNeedsDisplay:YES], AZOutsideEdgeOfRectInRect ( /*self.isDragging ? self.dragFrame :*/ self.frame, AZScreenFrameUnderMenu()); }
-   (NSR) mouseEdgeRect     {

 //self.activeEdge == AZPositionOutside && [self respondsToString:@"inFrame"] ? [[self vFK:@"inFrame"]r] :

  NSR r = AZRectOffset(AZInsetRectInPosition(self.contentRect, AZSizeFromDim(_handleInset), self.mouseEdge), self.frame.origin);
  [_handle setFrame:r display:YES animate:YES];
  return r;
//  [_handle bwResizeToSize:AZSizeFromRect(eRect) animate:YES];
}
-   (NSR) snappedRect       { AZR *r = $AZR(self.frame);

  switch (self.screenEdge) {
    case AZAlignLeft:   r.x = 0;                 break;
    case AZAlignTop:    r.maxY = AZScreenHeight();  break;
    case AZAlignRight:  r.maxX = AZScreenWidth();   break;
    case AZAlignBottom: r.y = 0;                 break;
  }
  return r.frame;
}
-  (void) sendEvent:(NSE*)e {

//  AZLOG([NSThread  callStackSymbols]);

  XX(AZEvent2Text(e.type));

  switch (e.type) {
    case NSMouseMoved:    if (self.isHovered || self.isOnEdge) [self setPoint:self.view.windowPoint forKey:@"mouseLocation"]; break;
    case NSLeftMouseDown :
      [self setBool:YES forKey:@"isClicked"];
      [self setBool:self.isOnEdge forKey:@"isResizing"];
      if (!_isResizing) return;
      NSP dragStart = NSE.mouseLocation;
      NSR wOrig     = self.frame;   // save initial origin.
    //  NSPoint dragOffset = AZSubtractPoints(_dragStart, wOrig);
    //  NSR dragFrameStart = self.frame;
      [self setBool:YES forKey:@"isDragging"];

      while (e.type != NSLeftMouseUp) {

        e = [self nextEventMatchingMask:NSLeftMouseDraggedMask|NSLeftMouseUpMask];
    //		self.insideEdge = AZOutsideEdgeOfPointInRect ( NSE.mouseLocation, _outerRect.r);
        NSP p  = AZSubtractPoints (NSE.mouseLocation, dragStart);// AZSubtractPoints(_dragStart, dragFrameStart.origin));
        [self setFrame:AZRectOffset(wOrig, p) display:YES animate:NO];//     _slideState == AZIn ? self.inFrame.r : self.outFrame.r;
      }
    //  [self setBool:NO forKey:@"isDragging"];
      [self setValue:@NO forKeys:@[@"isResizing",@"isClicked",@"isDragging"]];
    break;
  }

}

//- (void) setFrame:(NSR)r display:(BOOL)f {
//  NSR rct = AZInsetRectInPosition(AZScreenFrameUnderMenu(), AZSizeFromRect(r), self.insideEdge);
//  [super setFrame:rct display:f];
//}//descriptionForKey:k]); //}].joinedByNewlines;

@end


@implementation AZMagneticEdgeWindow

#pragma mark - FIX - this looks clean, what happened?

+ (NSD*) codableProperties { return [super.codableProperties dictionaryWithValue:@"AZRect" forKeys:@[@"outFrame", @"inFrame"]]; }
+ (NSSet*) keyPathsForValuesAffectingValueForKey:(NSS*)k {

  objswitch(k)
    objcase(@"inFrame")   return [NSSet setWithArray:@[@"edgeInset",@"outFrame"]];
    objcase(@"outFrame")  return [NSSet setWithArray:@[@"fullSize", @"dragFrame"]];
    defaultcase           return [super keyPathsForValuesAffectingValueForKey:k];
  endswitch
}
- (AZRect*) inFrame { return

  self.screenEdge == AZTop ? $AZR(AZLowerEdge(self.bounds, self.handleInset))
: self.screenEdge == AZLft ? $AZR(AZRightEdge(self.bounds, self.handleInset))
:	self.screenEdge == AZBtm ? $AZR(AZUpperEdge(self.bounds, self.handleInset))
: self.screenEdge == AZRgt ? $AZR(AZLeftEdge (self.bounds, self.handleInset))
: $AZR( AZCornerRectPositionedWithSize(	self.bounds,	AZPositionOpposite(self.screenEdge), AZSizeFromDim(self.handleInset*2)));

}
//self.grabInset * 2))); //AZRect *theStart = self.outFrame; NSR startR = theStart.r;

//    return $AZR(NSZeroRect);
//    self.insideEdge == AZLft ? [self.outFrame   AZRectExceptOriginX(startR,   		  	     - self.width  + AZMinDim(_fullSize) * 2) //self.grabInset * 2))
//  : self.insideEdge == AZTop ? AZRectExceptOriginY(startR, theStart.minY + theStart.height - AZMinDim(_fullSize))//self.grabInset))
//  : self.insideEdge == AZRgt ? AZRectExceptOriginX(startR, theStart.minX + theStart.width  - AZMinDim(_fullSize))//self.grabInset))
//  : self.insideEdge == AZBtm ? AZRectExceptOriginY(startR, theStart.minY - theStart.height + AZMinDim(_fullSize)) : startR);

- (AZRect*) outFrame { return $AZR(AZRectInsideRectOnEdge(AZRectFromSize(self.fullSize), AZScreenFrameUnderMenu(), self.insideEdge)); }

-      (id) initWithContentRect:(NSR)r styleMask:(NSUI)m backing:(NSBackingStoreType)b defer:(BOOL)d {

  if (!(self = [super initWithContentRect:r styleMask:m backing:b defer:d])) return nil;
  [self b:@"fullSize" tO:self wKP:@"frame" t:^id(id value) { return AZVsize( AZSizeFromRect([value rV])); }];
  BLKVIEW *corners;
  [self.view addSubview:corners = [BLKVIEW viewWithFrame:self.contentRect drawBlock:^(BLKV *bv, NSR rr) {

  }]];
  return self;
}
- (CRNR)outsideCorners           {	 AZPOS o = AZPositionOpposite(self.insideEdge);
	return 	o == AZTop ? (OSBottomLeftCorner|OSBottomRightCorner)
			: 	o == AZLft ? (  OSTopRightCorner|OSBottomRightCorner)
			: 	o == AZBtm ? (   OSTopLeftCorner|OSTopRightCorner   )
			:      (   OSTopLeftCorner|OSBottomLeftCorner ); // AZRght
}

@end

/**********/

@implementation AZEdgeAwareWindow

- initWithFrame:(NSR)r { if (!(self = [super initWithFrame:r]))return nil;
	self.opaque                     = NO;
	self.bgC                        = CHECKERS;
	self.minSize                    = self.frame.size;
	self.resizeIncrements           = AZSizeFromDim(100);
	self.movableByWindowBackground  = self.acceptsMouseMovedEvents = self.showsResizeIndicator = self.isVisible = YES;
	self.level                      = NSNormalWindowLevel; //NSPopUpMenuWindowLevel];
	self.animationBehavior          = NSWindowAnimationBehaviorNone;
  self.collectionBehavior         = NSWindowCollectionBehaviorDefault;
	return self;
}

- (void)        resizeBy:(NSSZ)sz { if (NSEqualSizes(NSZeroSize, sz)) return;

  [self setSize:AZAddSizes(self.size, sz)];
//	[self setFrame: AZCenterRectOnPoint(AZRectResizedBySize(self.frame,sz), self.center)];
}
- (void)     scrollWheel:(NSE*)e  { [self resizeBy:e.deltaSizeAZ];  }
- (void) setFrameChanged:(WindowFrameChange)blk { [self.contentView observeFrameChange:^(NSV*v){ (_frameChanged = [blk copy])(_owner,self); }]; }
@end

#pragma mark -  THIS STUFF BELOWLOOKS GOOD TOO

/*
	if (!_dragging) {
		_initialLocation          = e.locationInWindow;
		_initialLocationOnScreen  = [self convertBaseToScreen:e.locationInWindow];
		_initialFrame             = self.frame;
		_shouldDrag               = ! _initialLocation.x > _initialFrame.size.width - 20 && _initialLocation.y < 20;
		_windowFrame             = self.frame;
 		_minY                    = _windowFrame.origin.y + (_windowFrame.size.height-288);


	if (!_shouldDrag)	{ // 1. Is the Event a resize drag (test for bottom right-hand corner)?

		// i. Remember the current downpoint
		NSP currentLocationOnScreen = [self convertBaseToScreen:self.mouseLocationOutsideOfEventStream];
		_currentLocation = e.locationInWindow;
 		// ii. Adjust the frame size accordingly
		CGF heightDelta = currentLocationOnScreen.y - _initialLocationOnScreen.y;
 
		if ((_initialFrame.size.height - heightDelta) < 289)
		{
			_windowFrame.size.height = 288;      //windowFrame.origin.y = initialLocation.y-(initialLocation.y - windowFrame.origin.y)+heightDelta;
			_windowFrame.origin.y = _minY;
		} else {
			_windowFrame.size.height = (_initialFrame.size.height - heightDelta);
			_windowFrame.origin.y = (_initialFrame.origin.y + heightDelta);
		}
		_windowFrame.size.width = _initialFrame.size.width + (_currentLocation.x - _initialLocation.x);
		if (_windowFrame.size.width < 323) _windowFrame.size.width = 323;
		// iii. Set
		[self setFrame:_windowFrame display:YES animate:NO];

  }	else {
		//grab the current global mouse location; we could just as easily get the mouse location 
		//in the same way as we do in -mouseDown:
		_currentLocation = [self convertBaseToScreen:self.mouseLocationOutsideOfEventStream];
		_newOrigin.x = _currentLocation.x - _initialLocation.x;
		_newOrigin.y = _currentLocation.y - _initialLocation.y;
 
		// Don't let window get dragged up under the menu bar
		if( (_newOrigin.y+_windowFrame.size.height) > (_screenFrame.origin.y+_screenFrame.size.height) )
		{
			_newOrigin.y=_screenFrame.origin.y + (_screenFrame.size.height-_windowFrame.size.height);
		}
 
		//go ahead and move the window to the new location
		[self setFrameOrigin:_newOrigin];
 
	}

- (void) scrollWheel: (NSE*)e {

	//	CGF off = theEvent.deltaY < 0 ? - 10 : 10;
	NSR new          = self.frame;
	new.size.width  += e.deltaX /10;//NSOffsetRect(self.frame,off, 0);
	new.size.height += e.deltaY/10 ;
	new.size.height = MIN(new.size.height,100);
	new.size.width  = MIN(new.size.width, 100);
  [self.animator setFrame:new display:YES animate:YES];
	[[self.contentView subviews] do:^(id obj) { [[obj animator] setFrame:new]; }];
}

static NSP currentLocation, newOrigin, initialLocation;
static NSR screenFrame, windowFrame;

- (void) mouseDragged:(NSEvent *)theEvent
{
	static dispatch_once_t onceToken;	dispatch_once(&onceToken, ^{	screenFrame = AZScreenFrame();
																		windowFrame	= self.frame;	});

	currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
	newOrigin.x = currentLocation.x - initialLocation.x;
	newOrigin.y = currentLocation.y - initialLocation.y;
	
	newOrigin.y = newOrigin.y + windowFrame.size.height > NSMaxY(screenFrame) - 22 ? NSMaxY(screenFrame) - windowFrame.size.height - 22 : newOrigin.y;
	// Prevent dragging into the menu bar area
	newOrigin.y = newOrigin.y < NSMinY(screenFrame) ? NSMinY(screenFrame) : newOrigin.y;
	// 	Prevent dragging off bottom of screen
	newOrigin.x = newOrigin.x < NSMinX(screenFrame) ? NSMinX(screenFrame)  : newOrigin.x;
	// Prevent dragging off left of screen
	newOrigin.x = newOrigin.x > NSMaxX(screenFrame) - windowFrame.size.width ?  NSMaxX(screenFrame) - windowFrame.size.width : newOrigin.x;
	// Prevent dragging off right of screen

	[self setFrameOrigin:newOrigin]; LOG_EXPR(newOrigin);
}

- (void) mouseDown:(NSEvent *)theEvent
{
	// Get mouse location in global coordinates
	initialLocation = [self convertBaseToScreen:[theEvent locationInWindow]];
	initialLocation.x -= windowFrame.origin.x;
	initialLocation.y -= windowFrame.origin.y;
	NSLog(@"initial: %@", AZString(initialLocation));
}


- (void) mouseMoved:(NSEvent *)event
{
	//set movableByWindowBackground to YES **ONLY** when the mouse is on the title bar
	NSPoint mouseLocation = [event locationInWindow];
	if (NSPointInRect(mouseLocation, AZUpperEdge([self frame], 40)))
		[self setMovableByWindowBackground:YES];
	else
		[self setMovableByWindowBackground:NO];

	//This is a good place to set the appropriate cursor too
}

- (void) mouseDown:(NSEvent *)event
{
	//Just in case there was no mouse movement before the click AND
	//is inside the title bar frame then setMovableByWindowBackground:YES
	NSPoint mouseLocation = [event locationInWindow];
	if (NSPointInRect(mouseLocation, AZUpperEdge([self frame], 40)))
		[self setMovableByWindowBackground:YES];
	else //if (NSPointInRect(mouseLocation, bottomRightResizingCornerRect))
		[self doBottomRightResize:event];
	//... do all other resizings here. There are 6 more in OSX 10.7!
}

- (void) mouseUp:(NSEvent *)event
{
	//movableByBackground must be set to YES **ONLY**
	//when the mouse is inside the titlebar.
	//Disable it here :)
	[self setMovableByWindowBackground:NO];
}
//All my resizing methods start in mouseDown:

- (void) oBottomRightResize:(NSEvent *)event {
	//This is a good place to push the appropriate cursor

	NSRect r = [self frame];
	while ([event type] != NSLeftMouseUp) {
		event = [self nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
		//do a little bit of maths and adjust rect r
		[self setFrame:r display:YES];
	}

	//This is a good place to pop the cursor :)

	//Dispatch unused NSLeftMouseUp event object
	if ([event type] == NSLeftMouseUp) {
		[self mouseUp:event];
	}
}

@property (NA)  NSP initialMouseLocation, initialLocationOnScreen, initialLocation,  currentLocation,  newOrigin;
@property (NA)  NSR initialWindowFrame,   windowFrame,             screenFrame,      initialFrame;
@property (NA) BOOL isResizeOperation,    shouldRedoInitials,      shouldDrag;
@property CGF minY;

@property (NA) NSP initialMouseLocation;
@property (NA) NSR initialWindowFrame;
@property (NA) BOOL isResizeOperation;

@synthesize  initialMouseLocation, initialWindowFrame, isResizeOperation ;


+ (NSSet*) keyPathsForValuesAffectingMouseOnEdge { return [NSSet setWithObjects:@"mouseLocation",@"edgeInset",nil]; }

- (BOOL) mouseOnEdge { return AZPointIsInInsetRects(_mouseLocation,self.contentRect,AZSizeFromDim(_edgeInset)); }

+ (NSSet*) keyPathsForValuesAffectingActiveEdge {
    NSLog(@"keyPathsForValuesAffectingAffectedValue called");
  return [NSSet setWithObjects:@"mouseLocation",@"mouseOnEdge",nil]; }

- (AZPOS) activeEdge { AZPOS edge = AZPosOfPointInInsetRects(_mouseLocation,self.contentRect,AZSizeFromDim(_edgeInset));
  NSLog(@"%@ %@", NSStringFromPoint(_mouseLocation), AZWindowPosition2Text(edge));
  return edge;
}

//  [_handle.animator b:@"isVisible"  tO:self wKP:@"mouseOnEdge"   o:nil];
//- (BOOL)canBecomeKeyWindow  { return YES; }
//- (BOOL)canBecomeMainWindow { return YES; }
- (void) mouseMoved:(NSEvent*)e {
  //set movableByWindowBackground to
 YES **ONLY** when the mouse is on the title bar
  NSPoint mouseLocation = e.locationInWindow;
  [self setMovableByWindowBackground:NSPointInRect(mouseLocation, AZUpperEdge([self frame], 40))];
  //This is a good place to set the appropriate cursor too
}
- (void) mouseDown:(NSEvent *)event{
    //Just in case there was no mouse movement before the click AND
    //is inside the title bar frame then setMovableByWindowBackground:YES
    NSPoint mouseLocation = [event locationInWindow];
    if (NSPointInRect(mouseLocation, AZUpperEdge([self frame], 40)))
        [self setMovableByWindowBackground:YES];
    else //if (NSPointInRect(mouseLocation, bottomRightResizingCornerRect))
        [self doBottomRightResize:event];
    //... do all other resizings here. There are 6 more in OSX 10.7!
}
- (void) mouseUp:(NSEvent *)event{
    //movableByBackground must be set to YES **ONLY**
    //when the mouse is inside the titlebar.
    //Disable it here :)
    [self setMovableByWindowBackground:NO];
}
//All my resizing methods start in mouseDown:
- (void) oBottomRightResize:(NSEvent *)event {
    //This is a good place to push the appropriate cursor

    NSRect r = [self frame];
    while ([event type] != NSLeftMouseUp) {
        event = [self nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
        //do a little bit of maths and adjust rect r
        [self setFrame:r display:YES];
    }

    //This is a good place to pop the cursor :)

    //Dispatch unused NSLeftMouseUp event object
    if ([event type] == NSLeftMouseUp) {
        [self mouseUp:event];
    }
}

//  [self   b:@"edgeRect"    tO:self wKP:@"activeEdge"   t:^id(NSN* edge){
//    return AZVrect(AZRectOffset(AZInsetRectInPosition(self.contentRect, AZSizeFromDim(_edgeInset), edge.uIV), self.frame.origin));       //		NSR flp = AZRectFlippedOnEdge(rel, d);
//  }];

//  return JATExpand(
//  @"loc:{0} \n\
//  edgeRect:{1}\n\
//  activeEdge:{2} insideEdge:{8}\n\
//  mOver:{3|if:YES;NO}   mDown:{4|if:YES;NO}\n\
//  onEdge:{5|if:YES;NO}  dragging:{6|if:YES;NO}\n\
//  resizing:{7|if:YES;NO}",
//
//  AZString(self.mouseLocation),         /  0 * /   AZString(self.edgeRect),  / * 1 * /
//  AZPosition2Text(self.activeEdge),  / * 2 * /   self.mouseOver,           / * 3 * /
//  self.mouseDown,                       / * 4 * /   self.mouseOnEdge,         / * 5 * /
//  self.dragging,                        / * 6 * /   self.resizing,             / * 7 * /
//  AZPosition2Text(self.insideEdge)   / * 8 * /   );

//- (void) setIsVisible:(BOOL)v { self.animator.alphaValue = (super.isVisible = v) ? 1. : 0.; }

//{
//  CGF _cornerRadius,   // Round corners by this amount.  Defaults to 5.
//      _handleInset;      // How big are the "hot" edges?   Defaults to 30.
//  AZPOS _screenEdge,
//         _mouseEdge;
//  NSP _mouseLocation;  // Updates whenever mouse moves in window.
//  NSR _mouseEdgeRect;
//  BOOL _isOnEdge,  _isDragging, _isResizing, _isClicked, _isHovered;
//}

*/



