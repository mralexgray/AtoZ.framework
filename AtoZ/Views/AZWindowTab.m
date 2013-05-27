
#import "AZWindowTab.h"

#define AZR AZRect
#define AZP AZPOS
#define qP quartzPath

@implementation AZWindowTab			static NSMA* allTabs = nil;
+   (id) tabWithViewClass:(Class)k 										{	//	id last = self.tabRects.last; NSR thRect = last ? [last rectValue] : 
	return [self.alloc initWithView:[k.alloc initWithFrame:AZRectFromDim(200)] orClass:NULL frame:NSZeroRect];
}
-   (id) initWithView:(NSView*)c orClass:(Class)k frame:(NSR)r	{

	if (self!=[super initWithContentRect:c?c.frame:r styleMask:NSBorderlessWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO]) return nil;
	allTabs 		= allTabs ?: NSMA.mutableArrayUsingWeakReferences;
	_outerRect = $AZR(AZScreenFrameUnderMenu());
	[allTabs addObject:self]; [allTabs log];
	self.contentView  = c ?: [k.alloc initWithFrame:r];
	[self.contentView addSubview: _view = [BLKV viewWithFrame:self.contentRect opaque:NO drawnUsingBlock:^(BNRBlockView *v, NSRect r) {

		NSRectFillWithColor(quadrant(r,2), RED);
		[$(@"%ld", [allTabs indexOfObject:self]) drawInRect:quadrant(r, 1) withFont:[AtoZ.controlFont fontWithSize:29] andColor:GRAY5];
		[(NSIMG*)[NSIMG imageNamed:@"1"]drawAtPoint:NSZeroPoint];
		
		[[NSBP bezierPathWithCappedBoxInRect:AZRectInsideRectOnEdge(AZCenterRectInRect(AZRectFromDim(49),self.bounds),self.bounds,self.insideEdge)]fillWithColor:PURPLE];
		
	}]];
	_grabInset = @25;
	_view.arMASK = NSSIZEABLE; 
	_slideState = AZOut;
	return self;
}
- (void) setInsideEdge:(AZAlign)insideEdge { _insideEdge = insideEdge;  _view.needsDisplay = YES; }
- (void) mouseDown:	 (NSE*)e {
	if (e.clickCount == 2){/// && NSPointInRect(e.locationInWindow, self.grabRect.r)) {
		[AZTalker say: @"toggling"];
		_slideState = _slideState == AZIn ? AZOut : AZIn;
		self.frame = _slideState == AZIn ? self.inFrame.r : self.outFrame.r;
		return;
	}
	_drgStrt 	= NSE.mouseLocation;		// note our starting point.
	_wOrig 		= self.frame.origin;  	// save initial origin.
	while (e.type != NSLeftMouseUp) {
 		e = [self nextEventMatchingMask:NSLeftMouseDraggedMask | NSLeftMouseUpMask];
		self.insideEdge 	= AZOutsideEdgeOfPointInRect ( NSE.mouseLocation, _outerRect.r);
		self.offset 		= AZSubtractPoints ( NSE.mouseLocation, AZSubtractPoints ( _drgStrt, _wOrig));
		self.frame = _slideState == AZIn ? self.inFrame.r : self.outFrame.r;
	
	}
}
//-  (AZP) insideEdge 				{  return _insideEdge =  AZOutsideEdgeOfRectInRect(self.frame, _outerRect.r);	} 
- (AZR*) grabRect 				{  AZA o = self.insideEdge;

return 	o == AZTop ? $AZR(AZLowerEdge(self.bounds, self.grabInset.fV))
		:	o == AZLft ? $AZR(AZRightEdge(self.bounds, self.grabInset.fV)) 	
		:	o == AZBot ? $AZR(AZUpperEdge(self.bounds, self.grabInset.fV))	
		:	o == AZRgt ? $AZR(AZLeftEdge (self.bounds, self.grabInset.fV))   
		:	$AZR( AZCornerRectPositionedWithSize(self.bounds, AZPositionOpposite(o), AZSizeFromDimension(self.grabInset.fV)));
}
- (AZR*) inFrame 					{	AZRect *theStart 	= self.outFrame;	AZPOS inE = self.insideEdge; 

return	inE == AZLft ? $AZR(AZRectExceptOriginX( theStart.r, 							 -self.width + self.grabInset.fV))
		: 	inE == AZTop ? $AZR(AZRectExceptOriginY( theStart.r, theStart.minY + theStart.height - self.grabInset.fV))	
		: 	inE == AZRgt ? $AZR(AZRectExceptOriginX( theStart.r, theStart.minX + theStart.width  - self.grabInset.fV))
		:	inE == AZBot ?	$AZR(AZRectExceptOriginY( theStart.r, theStart.minY - theStart.height + self.grabInset.fV)) : theStart;
 	//		return inFrame  = CGRectIsNull(inFrame)  ? self.frame : inFrame;  } 
}
- (AZR*) outFrame 				{	 _outFrame 	= $AZR( AZRectInsideRectOnEdge ( self.frame, _outerRect.r, self.insideEdge));
	_insideEdge == AZRgt | _insideEdge == AZLft 	? [_outFrame setMinY:_offset.y] : [_outFrame setMinX:_offset.x];
	 _outFrame .minX = MAX( _outFrame .minX, 0);	
	 _outFrame .minY = MAX( _outFrame .minY, 0); 														
	 _outFrame .minX = MIN( _outFrame .minX, _outerRect.width  -  _outFrame .width );
	 _outFrame .minY = MIN( _outFrame .minY, _outerRect.height -  _outFrame .height);	return  _outFrame ;
} 
- (CRNR) outsideCorners 		{ AZPOS o = AZPositionOpposite(self.insideEdge);
return 	o == AZTop ? ( OSBottomLeftCorner | OSBottomRightCorner ) 	
		:	o == AZLft ? (   OSTopRightCorner | OSBottomRightCorner ) 	
		:	o == AZBot ? (    OSTopLeftCorner | OSTopRightCorner    ) 		
		:					 (    OSTopLeftCorner | OSBottomLeftCorner  );	//	o == AZPositionRight  ? 							 
}

- (BOOL) canBecomeKeyWindow  		{ return  YES;    }
- (BOOL) acceptsMouseMovedEvents {return YES;  }
- (BOOL) acceptsFirstResponder 	{ return YES; }
@end


//			AZOutsideEdgeOfPointInRect(AZCenter(self.frame), _outerRect.r);

//	if ([event type] == NSLeftMouseUp) {	[self mouseUp:event];	}

//		[NSAnimationContext begin:YES duration:5];
//		_grab.bgC = cgRANDOMCOLOR;
//		self.slideState 	= _slideState == AZIn ? AZOut : AZIn;
//
//}(): e.type == NSLeftMouseDown  && e.clickCount != 2  ? ^{  //&& e.type != NSLeftMouseDragged
//
////	if (_view)  [_view.layer animate:@"opacity" to:0 time:.5 completion:^{ /*[_view removeFromSuperview]; x.marquee.strokeEnd = 0;*/ }];
//	_drgStrt 	= NSE.mouseLocation;		// note our starting point.
//	_wOrig 		= self.frame.origin;  		// save initial origin.
//	}(): nil;

//[WindowTabController setWindow:self] }(): nil;

//}
//- (void) mouseDragged:(NSE*)e	{

//	self.insideEdge 	= AZOutsideEdgeOfPointInRect ( NSE.mouseLocation, _outerRect.r);
//	self.offset 		= AZSubtractPoints ( NSE.mouseLocation, AZSubtractPoints ( _drgStrt, _wOrig));
////	self.frame 			= self.rectForState;
////	self.slideState  	= _slideState;
////	AZRect * _outFrame  = [self frameInRect:AZScreenFrameUnderMenu() offset:offset insideEdge:ptEdge];	self.insideEdge =  _outFrame .orient; self.frame =  _outFrame .r;	LOGCOLORS(@"newframe:", _outFrame , @"newloc ",AZPositionToString( _outFrame .orient),  zNL, RANDOMPAL, nil);
//}


// outFrame = CGRectIsNull(outFrame) ? self.frame : outFrame; } 
//- (AZR*) outFrame 						{ return $AZR(self.frame);} //[self frameInRect:_outerRect offset:_offset  insideEdge:self.insideEdge];	}
/*


//	[self addObserverForKeyPaths:@[@"offset"] task:^(id obj, NSDictionary *change) {	[self setFrame:self.outFrame.r display:YES];	}];
//	__block AZWindowTab* blockSelf = self;
//	[self bind:@"frame" toObject:self withKeyPath:@"offset" transform:^id(id value) {	return AZVrect(blockSelf.outFrame.r);			}];
	//	CATransition* transition = [CATransition animation]; [transition setType:kCATransitionPush];  [transition setSubtype:kCATransitionFromLeft]; NSDictionary *ani = [NSDictionary dictionaryWithObject:transition  forKey:@"frame"];[self setAnimations:ani];
//quartzPath	//	[AZNOTCENTER observeName:NSApplicationDidBecomeActiveNotification usingBlock:^(NSNOT*n) {	
//			[NSApp activateIgnoringOtherApps:YES];	[self makeKeyAndOrderFront:nil]; 		     	}];

+ (instancetype) sharedInstance			{	@synchronized(self) { x = x ?: [self.alloc init]; }  return x;	
1. alloc 2. store pointer 3. call init. 	
	Why ? if init is calling sharedController, the pointer won't have been set and it will call itself over and over again.
	NSLog(@"JSCocoa : allocating shared instance %x", JSCocoaSingleton);
//}

	AZRectInsideRectOnEdge(AZRectFromDim(50),_window.bounds, _window.insideEdge) [grab bind:@"bounds" toObject:_window withKeyPath:@"insideEdge" transform:^id(id value) { return AZVrect();	}];	[_window observeName:@"insideEdge" usingBlock:^(NSNotification *n) {- (id) valueForUndefinedKey:(NSS*)key { id value;if ([_window respondsToString:key])value = [_window valueForKey:key];if (value == nil) value = [super valueForUndefinedKey: key];	}} 


			.window == findWin(NSE.mouseLocation) 
				NSR out = [[self associatedValueForKey:@"normalRectMemory" 
														 orSetTo:AZVrect(self.frame) policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC]rectValue];
				[self setFrame:NSEqualRects(out, self.frame) 
				?	AZRectInsideRectOnEdge( self.sticksToEdgeGrabRect, AZRECTUNDERMENU.rect, self.insideEdge) 
//				: 	out display:YES	animate:YES];

	// Mouse WAS dragged..  could add && !(e.deltaX == 0 && e.deltaY ==0)) 	
	else if  ( e.type == NSLeftMouseDragged && self == x.window ) 					dragAction();
		//mouse up
		else if  ( e.type == NSLeftMouseUp && self == x.window )		{ x = nil;  NSLog(@"clcick should be nil: %@", x); }
		//  Double Click handler for windowshade action.

	nonStickies = nonStickies ?: ^{ nonStickies  = [NSMA mutableArrayUsingWeakReferences];
								  								  [[NSW.appWindows objectsWithValue:@NO forKey:@"sticksToEdge"] each:^(id w) { 
																  [nonStickies addObject:w]; }]; 			  return nonStickies; }();
	id (^findEdgeEnabledWin)(NSP) = ^id(NSP p){  
//		NSA* all = NSW.appWindows;
		NSA* win = [NSW.appWindows objectsWithValue:@YES forKey:@"sticksToEdge"];
		NSA *winners = [win filter:^BOOL(NSW*o){ return NSPointInRect(p, o.frame); 	}];
//		NSLog(@"allCT: %ld thestickiesct:%ld  winnersCt: %ld", all.count, win.count, winners.count);
		return !winners.count ? nil : [winners.first isEqualTo:x.window] ? x.window  : winners.first; 		
	};
 
	//  THIS window's click handler.
//	id handler = [NSEVENTLOCALMASK: NSLeftMouseDraggedMask | NSLeftMouseDownMask | NSLeftMouseUpMask handler:^NSE*(NSE*e) {
		VoidBlock defineClickedWindow, dragAction, doubleClick;
		
		defineClickedWindow = ^{ 
			id win = findEdgeEnabledWin(NSE.mouseLocation); 
			if (!win) return;
			if (!x || win != x.window) {
			
				x =  
				[ClickedWindow.alloc initWithWindow:win];
				NSLog(@"found the clicked victim: %@", x.window);
				[nonStickies removeObject:x.window];
			ClickedWindow *w = [ClickedWindow.alloc initWithWindow:windy];
	 find and set "shared" "clicked" window
	

@interface  WindowTabController : NSObject
@property  (CP) void (^fixPaths) (void); 
@property  (WK) AZWindowTab *window; 		// The weak reference to the actual object
@property (ASS) CGP drgStrt, wOrig;
@property  NSMA	*allTabs;
@property 	CAL	*indi, 	*grab, *host;	@property CASL *marquee;
@property	NSV	*view;
+ (instancetype)sharedInstance;
@end
@implementation  WindowTabController
static WindowTabController *x = NULL;
static dispatch_once_t _p;
+ (instancetype) sharedInstance			{  dispatch_once(&_p,^{ x = [self.alloc init]; x.allTabs = NSMA.new; }); return x;	}
+ (BOOL) hasSharedInstance					{	return !!x;	}
+ (void) setWindow:(AZWindowTab*)w		{			// Singlton window that is our "Active window", aka, being dragged.

	if (w == x.window) return;
	NSLog(@"initwithwindow:%@ called", AZString(w.frame));
	if (x.view)  [x.view.layer animate:@"opacity" to:0 time:.5 completion:^{ [x.view removeFromSuperview]; x.marquee.strokeEnd = 0; }];
	if (!self.hasSharedInstance) { x	= self.class.sharedInstance;
		x.view 						= [NSV.alloc initWithFrame:w.contentRect];
		x.view.arMASK 				= NSSIZEABLE; 
		x.host 						= [x.view setupHostView];
		x.host.sublayers 			= @[ x.grab 	= [CAL  layerWithFrame:w.grabRect.r],
											  x.indi 	= [CAL  layerWithFrame:AZRectFromDim(50)],
											  x.marquee = [CASL layerWithFrame:w.bounds]];
		CATXTL *t = AddTextLayer(x.host, @(x.allTabs.count).stringValue, AtoZ.controlFont,kCAConstraintWidth);
//		[host addsubl]
		x.grab.backgroundColor 	= cgRED;
		x.indi.contents 			= [NSIMG imageNamed:@"1"];//scaledToMax: AZMaxDim(x.indi.boundsSize)];
		x.marquee.path 			= [NSBP bezierPathWithRect:w.bounds].quartzPath;	// (__bridge CGPathRef)
		x.marquee.strokeColor 	= [NSColor colorWithCalibratedRed:0.594 green:0.927 blue:0.143 alpha:1.000].CGColor;
		x.marquee.fillColor 		= nil;
		x.marquee.lineWidth 		= 6.0f;
		x.marquee.lineJoin 		= kCALineJoinBevel;
		x.fixPaths					= ^{ LOGCOLORS(@"KVOFIXPATHBLOCK", RED, nil); x.marquee.path = [NSBP bezierPathWithRect:x.window.bounds].qP; };
		[x.view observeFrameChangeUsingBlock:^{[x.grab setValueImmediately:AZVrect(x.window.grabRect.r)forKey:@"frame"]; x.fixPaths();}];
	}  
	x.window 	= w;	// Store the weak reference.  This will become nil automatically when this object is disposed of.
	x.drgStrt 	= NSE.mouseLocation;		// note our starting point.
	x.wOrig 		= w.frame.origin;  		// save initial origin.
	
	[x.window.contentView addSubview:x.view];
//	[x.grab unbind:[NSColor colorWithCalibratedRed:0.416 green:0.535 blue:0.927 alpha:1.000]sform:^id(id v){	return AZVrect(x.window.grabRect.r); 			}];
//	[x.indi unbind:@"position"];
	[x.indi bind:@"position" toObject:w withKeyPath:@"insideEdge" transform:^id(id value) {
		return AZVpoint(AZCenter(AZRectInsideRectOnEdge(AZCenterRectInRect(x.indi.bounds,w.bounds),w.bounds,w.insideEdge)));		}];
//	[x.marquee bind:@"path" toObject:w withKeyPath:@"frame" transform:^id(id value) {
//		return (id)[NSBP bezierPathWithRect:w.bounds].quartzPath;
//	}];
	[x.view.layer animate:@"opacity" to:@1 time:.5 completion:^{  																					}];
	[x.marquee animate:@"strokeEnd" from:@0 to:@1 time:2 completion:^{  																			}];
	
}
@end
*/

//@interface AZWindowTab ()
//@property  (CP) void (^fixPaths) (void); 
//@property  NSMA	*allTabs;
//@property 	CAL	*indi, 	*grab, *host;	@property CASL *marquee;

//@property dispatch_object_t token;
//@end


