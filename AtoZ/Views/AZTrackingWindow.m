	//
	//  AZTrackingDelegateView.m
	//  AtoZ
	//
	//  Created by Alex Gray on 8/24/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import "AZTrackingWindow.h"
#import "AtoZ.h"


@implementation AZTrackingWindow
{

	BOOL shouldDrag;
	BOOL shouldRedoInitials;
	NSPoint initialLocation;
	NSPoint initialLocationOnScreen;
	NSRect initialFrame;
	NSPoint currentLocation;
	NSPoint newOrigin;
	NSRect screenFrame;
	NSRect windowFrame;
	float minY;
}
	//	 key values for dictionary in NSTrackingAreas's userInfo,
	//	 which tracking area is being tracked
//@synthesize workingFrame = _workingFrame;


+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance inRect:(NSRect)frame{


	AZTrackingWindow *w = [[AZTrackingWindow alloc] initWithContentRect:frame styleMask:NSResizableWindowMask
																backing:NSBackingStoreBuffered defer:NO];
	w.position 			= orient;
	w.intrusion 		= distance;
	w.slideState 		= AZIn;
	w.workingFrame = frame;
	[w setFrameOrigin:frame.origin];
		//	NSLog(@"Class method factory result: %@", w.propertiesPlease);
	return w;
}

+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance{
	return [AZTrackingWindow oriented:orient intruding:distance withDelegate:nil];
}

+ (AZTrackingWindow*) oriented:(AZWindowPosition)orient intruding:(CGFloat)distance withDelegate:(id)del{


	AZTrackingWindow *w = [[AZTrackingWindow alloc] initWithContentRect:AZScreenFrame() styleMask:NSResizableWindowMask
																backing:NSBackingStoreBuffered	defer:NO];

	w.position 			= orient;		w.workingFrame = AZScreenFrameUnderMenu();
	w.intrusion 		= distance;		if (del) w.delegate = del;
	w.slideState 		= AZIn;
	NSLog(@"Class method factory result: %@", w.propertiesPlease);
	return w;
}


- (NSRect) outFrame {
	_visibleFrame = self.visibleFrame;		NSSize delters = _visibleFrame.size;	return _outFrame =

	_position == AZPositionLeft	  ?  NSOffsetRect(_visibleFrame, NEG(delters.width), (-delters.height/2))

	:	_position == AZPositionTop	  ?  AZRectHorizontallyOffsetBy(
																	AZRectTrimmedOnBottom( _visibleFrame, delters.height), (-delters.width/2))

	:	_position == AZPositionRight  ?  NSOffsetRect(_visibleFrame, delters.width, delters.height/2	)

	:					(NSRect) { delters.width/2 , -delters.height, delters.width, delters.height};
		//NSOffsetRect( _visibleFrame, -delters.height, delters.width/2 ) ;
}




- (NSRect) triggerFrame {  _visibleFrame = self.visibleFrame; if (!_triggerWidth) self.triggerWidth = 6;

	return _triggerFrame =
	self.position == AZPositionLeft		?	AZLeftEdge( _visibleFrame, _triggerWidth)
	:	self.position == AZPositionTop		?	AZUpperEdge(_visibleFrame, _triggerWidth)
	:	self.position == AZPositionRight	?	AZRightEdge( _visibleFrame, _triggerWidth)
	: 											AZLowerEdge(_visibleFrame, _triggerWidth);
}



- (NSRect) visibleFrame { _workingFrame = self.workingFrame; _intrusion = self.intrusion; return _visibleFrame =

	self.position == AZPositionLeft
	?	AZRectTrimmedOnTop(		AZLeftEdge(_workingFrame, _intrusion), _intrusion)

	:	self.position == AZPositionTop
	? 	AZRectTrimmedOnRight( AZUpperEdge(_workingFrame,_intrusion), _intrusion)
		//
		//	AZRectTrimmedOnRight( AZMakeRectMaxXUnderMenuBarY (self.intrusion), self.intrusion)

	:	self.position == AZPositionRight
	?	AZRectTrimmedOnBottom( 		AZRightEdge( _workingFrame, _intrusion), _intrusion)

	: 	(NSRect) {_intrusion, 0, _workingFrame.size.width - _intrusion, _intrusion}  ;

}

- (AZOrient)orientation		{
	switch (self.position) {
		case AZPositionBottom:
		case AZPositionTop:
			return AZOrientHorizontal;
		default:
			return AZOrientVertical;
	}
}

- (NSUInteger) capacity {
	if (!_capacity) {
		_capacity = floor ( AZMaxEdge(self.visibleFrame) / _intrusion );
		NSLog(@"window:%@ setCapacity:%ld", self.identifier, _capacity);
	}
	return _capacity;
}
- (id) initWithContentRect:(NSRect)contentRect
			     styleMask:(NSUInteger)aStyle
				   backing:(NSBackingStoreType)bufferingType
				     defer:(BOOL)flag {							if (self = [super initWithContentRect:contentRect
																		  styleMask:NSBorderlessWindowMask
																			backing:NSBackingStoreBuffered
																			  defer:NO]) {
		
		//		self.level 			 			= NSStatusWindowLevel;
		//		self.backgroundColor 			= CLEAR;
		//		self.alphaValue      			= 1.0;
		//		self.opaque				 		= NO;
		//		self.hasShadow		 			= YES;
		//		self.movable		 			= YES;
		//		self s		 			= YES;
		//		[self setMovableByWindowBackground:YES];
		//		self.hidesOnDeactivate			= YES;
	self.acceptsMouseMovedEvents	= YES;
		//		self.ignoresMouseEvents 		= NO;
		//		[self setExcludedFromWindowsMenu:NO];
	self.showsHandle				= NO;
//	self.intrusion 					= 100;
		//		self.slideState					= AZOut;
		//		self.position 					= AZPositionTop;


	self.view =[[AZSimpleView alloc]initWithFrame:[[self contentView]bounds]];
	_view.backgroundColor = RANDOMCOLOR;
		//		_view.wantsLayer = YES;
	[[self contentView] addSubview:_view ];
		// positioned:NSWindowBelow relativeTo:self.contentView];
		//		_view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
		//		[[self contentView ] addSubview:_view];
		//		[_view setNeedsDisplay:YES];
	[@{ NSApplicationWillBecomeActiveNotification	:	@"slideIn",
	 //		NSApplicationDidBecomeActiveNotification	:	@"applicationDidBecomeActive:",
	 //		NSApplicationWillResignActiveNotification	:	@"applicationWillResignActive:"}
	 NSApplicationDidResignActiveNotification 	:	@"slideOut" 	}

	 enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		 [self observeObject:NSApp forName:key calling:NSSelectorFromString(obj)];
	 }];
	NSLog(@"AZtrackingWIndow Init done;");
//	[self orderFrontRegardless];

		//	[NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *w) {
		//		NSLog(@"Mouserenyertr");
		//	}];

		//		AZMakeRectFromSize(contentRect.size)]/
		//AZCenteredRect(contentRect.size)		AZSizeFromDimension(AZMinDim([self frame].size)), [self frame])];
		//		_handle.
		//		imageInFrameworkWithFileName:@"tab.png"];
		//		NSLog(@"handleimage %@", _handle.image);
		//		[NSEvent  addLocalMonitorForEventsMatchingMask:NSMouseEnteredMask | NSMouseExitedMask handler:^NSEvent *(NSEvent *ff) {
		//			NSLog(@"lcoal event: %@", ff);
		//			return ff;
		//		 }];
		//		self.clippy = [CornerClipView initInWindow:self];
		//		//		_clippy.wantsLayer = YES;
		//		[[self contentView] addSubview:_clippy];
		//		[_clippy setNeedsDisplay:YES];
}
	return self;
}


-(void) setShowsHandle:(BOOL)showsHandle {

	if ( (showsHandle == NO) && (_handle)) [[_handle animator] setAlphaValue:0];
	else {	 [[self contentView] addSubview:self.handle];
		[[self.handle animator] setAlphaValue:1 ];
	}
	_showsHandle = showsHandle;
}

- (NSImageView*) handle {

	if ( !_handle) {
		NSImage* i = [NSImage imageInFrameworkWithFileName:@"bullseye.png"];
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


	[self setFrame:_outFrame display:NO animate:NO];
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setTimingFunction:
	 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[NSAnimationContext currentContext] setDuration:1.0f];

	[[self animator] setFrame:self.visibleFrame display:YES animate:YES];
	[NSAnimationContext endGrouping];
		//	[AtoZ shakeWindow:self];


		//		[AtoZ flipDown:self];
		//	CALayer *snap = [CALayer veilForView:[[self contentView] layer]];
		//	[snap flipOver];
		//	[AtoZ flipDown:self];

	_slideState = AZIn;
}
-(void) slideOut {

		//	[AtoZ flipDown:self];
		//	[AtoZ shakeWindow:self];
		//	[self setFrame:self.visibleFrame display:YES animate:NO];
		//	CALayer *snap = [CALayer veilForView:[[self contentView] layer]];
		//	[snap flipOver];
	[NSAnimationContext beginGrouping];
	[[NSAnimationContext currentContext] setTimingFunction:
	 [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[NSAnimationContext currentContext] setDuration:1.0f];
	[[self animator] setFrame:self.outFrame display:YES animate:YES];
	[NSAnimationContext endGrouping];

		//	[AtoZ flipDown:self];
	_slideState = AZOut;
}

-(void) setPosition:(AZWindowPosition)position
{
	_position = position;
	switch (position) {
		case AZPositionBottom:
			_view.backgroundColor = WHITE;
			_view.checkerboard = NO;
				//			_view.glossy = YES;
			break;
		case AZPositionRight:
			_view.backgroundColor = BLACK;
				//			_view.glossy = YES;
			_view.checkerboard = NO;
			break;
		case AZPositionLeft:
			_view.backgroundColor = GREY;
				//			_view.glossy = YES;
			_view.checkerboard = NO;
			break;
		default:
			_view.backgroundColor = ORANGE;
			_view.checkerboard = NO;
			break;
	}

		//	self.slideState = _slideState;
	_visibleFrame = self.visibleFrame;
	_outFrame = self.outFrame;
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


- (void)setSlideState:(AZSlideState)slideState {}



@end

@class AZTrackingWindow;
@implementation AtoZ (Animations)


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
	theGroup.animations=[NSArray arrayWithObjects:bounceAnimation,mainAnimation,nil];

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

+ (void)shakeWindow:(NSWindow*)window
{
	[window setAnimations:[NSDictionary dictionaryWithObject:[CAKeyframeAnimation shakeAnimation:[window frame]] forKey:@"frameOrigin"]];
	[[window animator] setFrameOrigin:[window frame].origin];
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

 //go ahead and move the window to the new location
 [self setFrameOrigin:newOrigin];

 }
 }

 - (void)mouseUp:(NSEvent*)theEvent
 {
 shouldRedoInitials = YES;
 }
 */
	//BOOL shouldDrag;
	//BOOL shouldRedoInitials;
	//[[NSPoint]] initialLocation;
	//[[NSPoint]] initialLocationOnScreen;
	//[[NSRect]] initialFrame;
	//[[NSPoint]] currentLocation;
	//[[NSPoint]] newOrigin;
	//[[NSRect]] screenFrame;
	//[[NSRect]] windowFrame;
	//float minY;



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

