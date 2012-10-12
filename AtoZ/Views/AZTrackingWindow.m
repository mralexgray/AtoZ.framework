
typedef struct AZTri {		CGPoint a;	CGPoint b;	CGPoint c;	}AZTri;
typedef struct AZTriPair {	AZTri uno;	AZTri duo;  				}AZTriPair;

#import "AZTrackingWindow.h"

@interface NSWindow (Animations)
- (void) shake;
@end



@interface  AZTrackingWindow ()
@property (nonatomic, strong) NSImageView* 		handle;
@property (nonatomic, assign) BOOL 				showsHandle;
//@property (nonatomic, strong) CornerClipView 	*clippy;
- (void) mouseHandler:(NSEvent *)theEvent;
@end

@implementation AZTrackingWindow

+ (AZTrackingWindow *) standardInit {
   AZTrackingWindow *w = [[[self class] alloc] initWithContentRect:AZScreenFrame()
														 styleMask:NSBorderlessWindowMask
														   backing:NSBackingStoreBuffered defer:NO];
	w.slideState 	= AZIn;
	w.level 		= NSStatusWindowLevel;				   w.movableByWindowBackground 		= NO;
	w.hasShadow		= NO;								   w.backgroundColor 				= CLEAR;
	[w setOpaque:NO];
	w.contentView	= [[AZSimpleView alloc]initWithFrame: [w.contentView bounds]];	w.view 	= w.contentView;
	w.view.backgroundColor = CLEAR;
	[ @{   	NSApplicationWillBecomeActiveNotification 	:	@"slideIn",
	 		NSApplicationDidResignActiveNotification 	: 	@"slideOut" }	each:^( id key, id obj ) {
			[w observeObject:NSApp forName:obj calling: NSSelectorFromString ( obj ) ];	}];
//	[NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseDownMask handler:^NSEvent *(NSEvent *e) {
//		[w shake];
//		return e;
//	}];
	return w;
}

+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance inRect:(NSRect)frame withDelegate: (id) del
{
	AZTrackingWindow *w  = [[self class] standardInit];		w.position = orient;	w.intrusion = distance;
	w.workingFrame 		 = NSEqualRects(frame, NSZeroRect) ?  AZScreenFrameUnderMenu() : frame;		//	[w setFrameOrigin:frame.origin];
	if (del) w.delegate = del;		// NSLog(@"Class method factory result: %@", w.propertiesPlease);
	[w setFrame: w.visibleFrame display:YES];
	return w;
}

+ (AZTrackingWindow*) oriented:(AZWindowPosition)o intruding:(CGFloat)d inRect:(NSRect)frame {
	return [[self class] oriented:o intruding:d inRect:frame withDelegate:nil]; 			 }

+ (AZTrackingWindow*) oriented:(AZWindowPosition)o intruding:(CGFloat)d 					 {
	return [[self class] oriented:o intruding:d inRect:NSZeroRect withDelegate:nil]; 		 }

+ (AZTrackingWindow*) oriented:(AZWindowPosition)o intruding:(CGFloat)d withDelegate:(id)del {
	return [[self class] oriented:o intruding:d inRect:NSZeroRect withDelegate:del];		 }


- (NSRect) outFrame {	NSSize w = self.visibleFrame.size;

	return 	_position == AZPositionLeft
		  ? NSOffsetRect(_visibleFrame,  NEG(w.width), -w.height / 2 )
		  : _position == AZPositionTop
		  ? AZRectHorizontallyOffsetBy( AZRectTrimmedOnBottom( _visibleFrame, 	w.height),  -w.width / 2 )
		  :	_position == AZPositionRight
		  ? NSOffsetRect(_visibleFrame, w.width, w.height / 2 )  : (NSRect) {  w.width/2,  NEG(w.height),  w.width,  w.height  };
}

- (NSRect) triggerFrame {	   _visibleFrame = self.visibleFrame;
															  if (!_triggerWidth) self.triggerWidth = 6;
														    return _triggerFrame =
	self.position == AZPositionLeft  ? AZLeftEdge ( _visibleFrame, _triggerWidth)
  :	    _position == AZPositionTop	 ? AZUpperEdge( _visibleFrame, _triggerWidth)
  :     _position == AZPositionRight ? AZRightEdge( _visibleFrame, _triggerWidth)
  :	                                   AZLowerEdge( _visibleFrame, _triggerWidth);
}
- (NSRect) visibleFrame { 		 return _visibleFrame =

	_position == AZPositionLeft  ? AZRectTrimmedOnTop(    AZLeftEdge  ( _workingFrame, _intrusion), _intrusion)
  :	_position == AZPositionTop   ? AZRectTrimmedOnRight(  AZUpperEdge ( _workingFrame, _intrusion), _intrusion)
	//	AZRectTrimmedOnRight( AZMakeRectMaxXUnderMenuBarY (self.intrusion), self.intrusion)
  :	_position == AZPositionRight ?	AZRectTrimmedOnBottom( AZRightEdge( _workingFrame, _intrusion), _intrusion)
  : 									(NSRect) {_intrusion, 0, _workingFrame.size.width - _intrusion, _intrusion};
}


- (AZOrient)orientation { return _position == AZPositionBottom || _position == AZPositionTop ? AZOrientHorizontal : AZOrientVertical; }

- (NSUInteger) capacity { return floor ( AZMaxEdge(self.visibleFrame) / _intrusion ); }


//  NSLog(@"window:%@ setCapacity:%ld", self.identifier, _capacity);
/*  NSApplicationWillResignActiveNotification	:	@"applicationWillResignActive:"} */
/*  NSApplicationDidBecomeActiveNotification	:	@"applicationDidBecomeActive:",  */
//	self.opaque				 		= NO;
//	self.movable		 			= NO;
//	self.hidesOnDeactivate			= YES;
//	self.ignoresMouseEvents 			= NO;
//  self.excludedFromWindowsMenu	= NO;
//	self.showsHandle				= NO;
//	self.intrusion 					= 100;
//  self.slideState					= AZOut;
//  self.position 					= AZPositionTop;

//  positioned:NSWindowBelow relativeTo:self.contentView];
//	_view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
//	[[self contentView ] addSubview:_view];  [_view setNeedsDisplay:YES];
//	[self orderFrontRegardless];

		//	[NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *w) {
		//		NSLog(@"Mouserenyertr");
		//	}];

		//		AZMakeRectFromSize(contentRect.size)]/
		//AZCenteredRect(contentRect.size)		AZSizeFromDimension(AZMinDim([self frame].size)), [self frame])];
		//		_handle.
		//		az_imageNamed:@"tab.png"];
		//		NSLog(@"handleimage %@", _handle.image);
		//		[NSEvent  addLocalMonitorForEventsMatchingMask:NSMouseEnteredMask | NSMouseExitedMask handler:^NSEvent *(NSEvent *ff) {
		//			NSLog(@"lcoal event: %@", ff);
		//			return ff;
		//		 }];
		//		self.clippy = [CornerClipView initInWindow:self];
		//		//		_clippy.wantsLayer = YES;
		//		[[self contentView] addSubview:_clippy];
		//		[_clippy setNeedsDisplay:YES];


-(void) setShowsHandle:(BOOL)showsHandle {

	if ( (showsHandle == NO) && (_handle)) [[_handle animator] setAlphaValue:0];
	else {	 [[self contentView] addSubview:self.handle];
		[[self.handle animator] setAlphaValue:1 ];
	}
	_showsHandle = showsHandle;
}

- (NSImageView*) handle {

	if ( !_handle) {
		NSImage* i = [NSImage az_imageNamed:@"bullseye.png"];
		self.handle = [[NSImageView alloc]initWithFrame:AZMakeRectFromSize(i.size)];
		_handle.image 	=  i;
//		_handle.center 	=  [[self contentView] center]((_position == AZPositionTop) || (_position == AZPositionBottom) ? NSMidX(_visibleFrame)?
		_handle.alphaValue = 0;
	}
	return _handle;
}

- (void) awakeFromNib {

	[NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *e) {

//		[AtoZ shakeWindow:self];
		NSLog(@"Mouse moved: %@", NSStringFromPoint([e locationInWindow]));
			//		return e;
	}];

	NSLog(@"im awake.  position: %@. origin:%f.0x%f.0 size:%f.0x%f.0", $(@"%ud",_position), self.frame.origin.x, self.frame.origin.y,self.frame.size.width, self.frame.size.height);
}
-(void) slideIn {
	NSRect o = self.outFrame;
	if ( ! NSEqualRects(self.frame, o) ) { [self setFrame:o display:NO animate:NO];	}
	[CATransaction transactionWithLength:1 easing:CAMEDIAEASY actions:^{
	[[self animator] setFrame:_visibleFrame display:YES animate:YES];
			self.slideState = AZIn;
	}];

		//	[AtoZ shakeWindow:self]
		//		[AtoZ flipDown:self];
		//	CALayer *snap = [CALayer veilForView:[[self contentView] layer]];
		//	[snap flipOver];
		//	[AtoZ flipDown:self];
}
-(void) slideOut {

//	[AtoZ flipDown:self];	[AtoZ shakeWindow:self];
//	[self setFrame:self.visibleFrame display:YES animate:NO];	CALayer *snap = [CALayer veilForView:[[self contentView] layer]]; [snap flipOver];

	[CATransaction transactionWithLength:1 easing:CAMEDIAEASY actions:^{
		[[self animator] setFrame:self.outFrame display:YES animate:YES];
		self.slideState = AZOut;
	}];
}

-(void) setPosition:(AZWindowPosition)position
{
	_position = position;
	switch (position) {
		case AZPositionBottom:
//			_view.backgroundColor = WHITE;
//			_view.checkerboard = NO;
//			_view.glossy = YES;
			break;
		case AZPositionRight:
//			_view.backgroundColor = BLACK;
//			_view.glossy = YES;
//			_view.checkerboard = NO;
			break;
		case AZPositionLeft:
//			_view.backgroundColor = GREY;
//			_view.glossy = YES;
//			_view.checkerboard = NO;
			break;
		default:
//			_view.backgroundColor = ORANGE;
//			_view.checkerboard = NO;
			break;
	}

		//	self.slideState = _slideState;
//	_visibleFrame 	= self.visibleFrame;
//	_outFrame 		= self.outFrame;
}

- (BOOL) acceptsFirstResponder {
	return YES;
}


- (void) mouseHandler:(NSEvent *)theEvent {
	NSPoint mousePoint = [theEvent locationInWindow];
	BOOL isHit = (NSPointInRect(mousePoint, [self frame]));
	NSLog(@"Mouse:  %@", theEvent);
		//  NSStringFromPoint(mousePoint));// [theEvent description]);//NSStringFromPoint( mousePoint));
		//	isHit ? [_view slideUp] : [_view slideDown];
		//	[[self animator]setAlphaValue: isHit ? 1 : 0 ];
	[self setIgnoresMouseEvents: isHit];
		//	}
}

@end

@class AZTrackingWindow;
@implementation NSWindow (Animations)


-(void) anmateOnPath:(id)something {
	NSTimeInterval timeForAnimation = 1;
	CAKeyframeAnimation *bounceAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
	bounceAnimation.duration=timeForAnimation;
	CGMutablePathRef thePath=CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, 160, 514);
	CGPathAddLineToPoint(thePath, NULL, 160, 350);
	CGPathAddLineToPoint(thePath, NULL, 160, 406);
	bounceAnimation.path=thePath;
	CGPathRelease(thePath);
	CABasicAnimation *mainAnimation=[CABasicAnimation animationWithKeyPath:@"transform"];
	mainAnimation.removedOnCompletion=YES;
	mainAnimation.duration=timeForAnimation;
	mainAnimation.toValue=[NSValue valueWithCATransform3D:CATransform3DIdentity];

	CAAnimationGroup *theGroup=[CAAnimationGroup animation];
	theGroup.delegate=self;
	theGroup.duration=timeForAnimation;
	theGroup.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	theGroup.animations=@[bounceAnimation,mainAnimation];

	CALayer *target = ([something isKindOfClass:[NSWindow class]]) ? [[something contentView]layer] : [(NSView*)something layer];

	[target addAnimation:theGroup forKey:@"sagar"];
	[something setFrame:AZCenterRectOnPoint([something frame], (NSPoint){160, 406})];//)]imgV.center=CGPointMake(160, 406);
	[target setTransform: CATransform3DIdentity];//CGAffineTransformIdentity];

}

+ (void)flipDown:(id)window
{
		//	[window setClass:[AZTrackingWindow class]];
	if ([(id)window respondsToSelector:@selector(setAnimations:)]) {
		[window setAnimations:@{ @"frame":  [CAAnimation flipDown:2 scaleFactor:.8]} ];// shakeAnimation:[window frame]] }];
																				//		[[window animator] setFrame: (window.slideState == AZOut ? window.visibleFrame : window.outFrame ) display:YES animate:YES];
	}
}
- (void)shake;
//+ (void)shakeWindow:(NSWindow*)window
{
	[self setAnimations:@{ @"frameOrigin" : [CAKeyframeAnimation shakeAnimation:[self frame]] }];
	[[self animator] setFrameOrigin:[self frame].origin];
}

@end


	/**
	 if 	((_slideState == AZOut) && (slideState == AZIn))	{

	 [self setFrame:self.outFrame display:NO animate:NO];
	 [self orderFrontRegardless];
	 [[self animator] setFrame:_visibleFrame display:YES animate:YES];
	 } else if (slideState == AZIn) {
	 [[self animator] setFrame:_visibleFrame display:YES animate:YES];
	 } else 	if (slideState == AZOut) {
	 [[self animator] setFrame:_outFrame display:YES animate:YES];
	 }
	 */
		//	( (_slideState == AZOut) && ( [[self frame] v] ) {
		//		[[self animator] setFrame:self.visibleFrame display:YES animate:YES];
		//	 	 [[_handle animator] setAlphaValue:0];
		//	}
		//	else {	 [[self contentView] addSubview:self.handle];
		//		[[self.handle animator] setAlphaValue:1 ];
		//	}
		//
		//	if (sestate == AZUp)
		//		[w setFrame:w.outFrame display:NO animate:NO];
		//	_state = slideState;

	//
	//
	//	[NSEvent addGlobalMonitorForEventsMatchingMask: NSMouseMovedMask | NSMouseExitedMask |NSMouseEnteredMask  handler:^(NSEvent *e) {
	//
	//		[_view setBackgroundColor:RANDOMCOLOR];
	//		NSLog(@"event: %@", e.type);
	//	//			[self mouseHandler:e];
	//	//			return e;
	//	}];


	//
	//- (void) makeTrackers {
	//		[obj setBackgroundColor:RANDOMCOLOR];
	//		NSTrackingArea *t = AZTAreaInfo(
	//			[obj frame],  @{  kTrackerKey: [NSNumber numberWithUnsignedInt: idx] } );
	//		[self addTrackingArea:t];
	//		return  t;
	//	}];
	//
	//}
	//-(void)updateTrackingAreas
	//{
	//	[trackers each:^(id obj, NSUInteger index, BOOL *stop) {
	//		[self removeTrackingArea:obj];
	//		obj = nil;
	//	}];
	//	[self makeTrackers];
	//}
	//
	//- (void) mouseMoved:(NSEvent *)theEvent
	// {
	//	 NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	////	 NSLog(@"%@@", NSStringFromPoint( mousePoint));
	//	[self.subviews each:^(id obj, NSUInteger index, BOOL *stop) {
	//		if (NSPointInRect(mousePoint, [obj frame])) {
	//			 self.isHit = YES;
	//			 self.needsDisplay = YES;
	//			[self.delegate trackerDidReceiveEvent:theEvent inRect:[obj
	//			frame]];
	//		}
	//		else [[self nextResponder] mouseMoved:theEvent];
	//	}];
	// }
	//- (void) mouseDown:(NSEvent *)theEvent {
	//	[[self delegate] ignoreMouseDown:theEvent];
	//}

/*- (void)mouseDragged:(NSEvent*)theEvent
 {
 if (shouldRedoInitials)
 {
 initialLocation = [theEvent locationInWindow];
 initialLocationOnScreen = [self convertBaseToScreen:[theEvent locationInWindow]];

 initialFrame = [self frame];
 shouldRedoInitials = NO;

 if (initialLocation.x > initialFrame.size.width - 20 && initialLocation.y < 20) {
 shouldDrag = NO;
 }
 else {
 //mouseDownType = PALMOUSEDRAGSHOULDMOVE;
 shouldDrag = YES;
 }

 screenFrame = [[NSScreen mainScreen] frame];
 windowFrame = [self frame];

 minY = windowFrame.origin.y+(windowFrame.size.height-288);
 }


 // 1. Is the Event a resize drag (test for bottom right-hand corner)?
 if (shouldDrag == FALSE)
 {
 // i. Remember the current downpoint
 NSPoint currentLocationOnScreen = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
 currentLocation = [theEvent locationInWindow];

 // ii. Adjust the frame size accordingly
 float heightDelta = (currentLocationOnScreen.y - initialLocationOnScreen.y);

 if ((initialFrame.size.height - heightDelta) < 289)
 {
 windowFrame.size.height = 288;
 //windowFrame.origin.y = initialLocation.y-(initialLocation.y - windowFrame.origin.y)+heightDelta;
 windowFrame.origin.y = minY;
 } else
 {
 windowFrame.size.height = (initialFrame.size.height - heightDelta);
 windowFrame.origin.y = (initialFrame.origin.y + heightDelta);
 }

 windowFrame.size.width = initialFrame.size.width + (currentLocation.x - initialLocation.x);
 if (windowFrame.size.width < 323)
 {
 windowFrame.size.width = 323;
 }

 // iii. Set
 [self setFrame:windowFrame display:YES animate:NO];
 }
 else
 {
 //grab the current global mouse location; we could just as easily get the mouse location
 //in the same way as we do in -mouseDown:
 currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
 newOrigin.x = currentLocation.x - initialLocation.x;
 newOrigin.y = currentLocation.y - initialLocation.y;

 // Don't let window get dragged up under the menu bar
 if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) )
 {
 newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
 }
*/
 //  go ahead and move the window to the new location	 [self setFrameOrigin:newOrigin];

//	BOOL 	shouldDrag, 	 shouldRedoInitials;
//	NSPoint initialLocation, initialLocationOnScreen, 	currentLocation, 	newOrigin;
//	NSRect 	screenFrame, 	 windowFrame, 				initialFrame;
//	float 	minY;

//	 key values for dictionary in NSTrackingAreas's userInfo, which tracking area is being tracked


@interface CornerClipView : NSView
@property (assign, nonatomic, getter = getPair) AZTriPair t;
@property (weak) AZTrackingWindow *windy;
+ initInWindow:(AZTrackingWindow*)windy;
@end

@implementation CornerClipView


+ initInWindow:(AZTrackingWindow*)windy; {

	CornerClipView *e = [[[self class] alloc]initWithFrame:[[windy contentView]bounds]];
	e.windy 		  	= windy;
		//	windy.contentView 	= e;
		//	e.needsDisplay	  	= YES;
	return e;
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setupHostView];
		self.autoresizingMask  = NSViewWidthSizable | NSViewHeightSizable;
		self.postsBoundsChangedNotifications = YES;
		NSLog(@"ready to clip.  frame: %@", NSStringFromRect(frame));
		NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / 60.0 target: self
														selector: @selector(drawRect:)
														userInfo:nil
														 repeats: YES];

		[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSDefaultRunLoopMode];
		[[NSRunLoop currentRunLoop] addTimer: timer forMode: NSEventTrackingRunLoopMode];


			//		[self setWantsLayer:YES];
    }
    return self;
}

- (void) viewWillDraw{

		//	NSLog(@"thaey says im bouts to framedraw. %@  @: %@", self.allSubviews, NSStringFromRect(_frame));
}

- (void) drawRect:(NSRect)dirtyRect {

		//	[NSGraphicsContext saveGraphicsState];
	NSLog(@"gitem gitl:  win: $%@", _windy.identifier);
	/*	_t = self.t;
	 NSBezierPath *path = [[NSBezierPath alloc] init];
	 [path moveToPoint: _t.uno.a];		[path lineToPoint: _t.uno.b];	[path lineToPoint: _t.uno.c];
	 [path closePath];		//			[RED set];						[path fill];
	 [path addClip];

	 [path moveToPoint: _t.duo.a];		[path lineToPoint: _t.duo.b];	[path lineToPoint: _t.duo.c];
	 [path closePath];		//			[RANDOMCOLOR set];				[path fill]; //
	 [path addClip];*/
	[RANDOMCOLOR set];
	NSRectFill([self bounds]);

		//	[path setClip];
		//	[NSGraphicsContext restoreGraphicsState];
}


- (AZTriPair) getPair {			CGFloat i = _windy.intrusion;

	if ( _windy.position == AZPositionTop ) {
		_t.uno.a = (CGPoint) { 0, NSMaxY(_bounds) };
		_t.uno.b = (CGPoint) { 0, 0 };
		_t.uno.c = (CGPoint) { i, 0 };
		_t.duo.a = (CGPoint) { NSMaxX(_bounds) - i, 0 };
		_t.duo.b = (CGPoint) { NSMaxX(_bounds), 0 };
		_t.duo.c = (CGPoint) { NSMaxX(_bounds) - i, NSMaxY(_bounds) };
	} else if  ( _windy.position == AZPositionRight ) {
		_t.uno.a = (CGPoint) { NSMaxX(_bounds), 	NSMaxY(_bounds) };
		_t.uno.b = (CGPoint) { NSMaxX(_bounds) - i, 	NSMaxY(_bounds)-i };
		_t.uno.c = (CGPoint) { NSMaxX(_bounds), 	NSMaxY(_bounds) - i };
		_t.duo.a = (CGPoint) { i, 0 };
		_t.duo.b = (CGPoint) { i, i };
		_t.duo.c = (CGPoint) { 0, 0 };
	} else if ( _windy.position == AZPositionBottom ) {
		_t.uno.a = (CGPoint) { NSMaxX(_bounds), 		0 };
		_t.uno.b = (CGPoint) { NSMaxX(_bounds) - i, 	0 };
		_t.uno.c = (CGPoint) { NSMaxX(_bounds) - i, 	i };
		_t.duo.a = (CGPoint) { 0, 0 };
		_t.duo.b = (CGPoint) { i, i };
		_t.duo.c = (CGPoint) { i, 0 };
	} else {
		_t.uno.a = (CGPoint) { 0, 0 };
		_t.uno.b = (CGPoint) { 0, i };
		_t.uno.c = (CGPoint) { i, 0 };
		_t.duo.a = (CGPoint) { 0, NSMaxY(_bounds) };
		_t.duo.b = (CGPoint) { i, NSMaxY(_bounds) };
		_t.duo.c = (CGPoint) { i, NSMaxY(_bounds) - i };
	}
	return _t;
}

@end

