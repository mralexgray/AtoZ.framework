#import "AZMenuBarWindow.h"

@interface AZLayerTabWindow :NSWindow
@end
@implementation AZLayerTabWindow

-(id) initPositioned:(AZPOS)pos againstRect:(NSRect)parent withFrame:(NSR)frame
{
//	self addChildWindow:(NSWindow *)win ordered:<#(NSWindowOrderingMode)#>
	if (!(self = [self initWithContentRect:frame styleMask:NSBorderlessWindowMask
								   backing:NSBackingStoreBuffered	defer:NO] )) return nil;

	[self bordlerlessInit];

	CALayer *root  = [self.contentView setupHostView];
	root.layoutManager = AZLAYOUTMGR;
	CALayer *edge  = [CALayer layer];
	CALayer *tab   = [CALayer layer];
	root.sublayers = @[edge, tab];
	[root.sublayers eachWithIndex:^(CAL *obj, NSInteger idx) {

		[obj addConstraintsSuperSize];
		obj.orient = pos;
		AddShadow(obj);
		obj.cornerRadius = idx == 0 ? AZMaxDim(obj.boundsSize) *.2 : AZMaxDim(obj.boundsSize) *.1;
		obj.anchorPoint = AZAnchorPointForPosition(pos);
		obj.bgC = idx == 0 ? cgWHITE : [[NSColor leatherTintedWithColor:RANDOMCOLOR]CGColor];
//		[obj addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintHeight, .9, 0), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)]];
		obj.delegate = self;
		[obj setNeedsDisplay];
	}];
//	w.anchorPoint 	= AZAnchorBottom;
//	w.position	 	= NSMakePoint(NSWidth(vRect)/2, 30);

//	w.shadowOffset 	= AZMultiplySize(w.shadowOffset, .5);
//	w.cornerRadius 	= 7;
//	w.bgC	 		= [[NSColor leatherTintedWithColor:obj] CGColor];
//	u.sublayers 	= @[uu, w];
//	u.name = [NSS randomWords:1];

}

@end


@implementation AZMenuBarWindow
- (id) init
{
//	NSRect 	f = AZRectExceptHigh(AZMenuBarFrame(), 222);
//			f = AZRectVerticallyOffsetBy(f, -200);

	if (!(self = [self initWithContentRect:AZScreenFrameUnderMenu() styleMask:NSBorderlessWindowMask
				       backing:NSBackingStoreBuffered	defer:NO] )) return nil;

	[self bordlerlessInit];

	self.bar = [[NSView alloc]initWithFrame:AZUpperEdge([[self contentView]frame], 400)];
	self.drawerView = [[NSView alloc]initWithFrame:AZUpperEdge([[self contentView]frame], 22)];//[[self contentView]frame]];// AZScreenFrameUnderMenu().size.height)];
	[self.contentView setSubviews :@[_drawerView,_bar]];
//	CALayer *drawer = [_drawerView setupHostView];
//	CALayer *liner  = [CALayer layer];
//	drawer.layoutManager = AZLAYOUTMGR;
//	drawer.borderWidth 	= 20;
//	drawer.borderColor 	= cgBLACK;
//	[liner addConstraintsSuperSize];
//	[liner addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintMinY, 1, 15), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)]];
//	liner.contents = [NSImage imageNamed:@"black.minimal.jpg"];
//	liner.contentsGravity = kCAGravityResizeAspect;
//	liner.cornerRadius = 10;
//	AddShadow(drawer);
//	AddShadow(liner);
//	[drawer addSublayer:liner];

	NSArray *r = [NSColor randomPalette]; r = r.count > 60 ? [r subarrayToIndex:30] : r;

	CGF unit	= (AZMenuBarFrame().size.width / r.count);
	_bar.subviews = [r nmap:^id(id obj, NSUInteger index) {
		NSRect vRect = AZRectFromDim(AZMenuBarThickness());
		vRect = AZRectExceptWide(vRect, unit);
		vRect = AZRectExceptHigh(vRect, _bar.height);
		vRect = AZRectExceptOriginX(vRect, unit * index);
		vRect = AZRectExceptOriginY(vRect, 0);// NSHeight([self.contentView frame]));
		NSRect h = AZRectFromDim((unit/1.5));
			   h = AZRectExceptHigh(h, ScreenHighness());
			   h = AZRectExceptOriginY(h, _bar.height - 100);
		NSRect g = AZInsetRect(h, 6);
			   g.origin.y += 40;//(g, 35);

			AZSimpleView *s = [[AZSimpleView alloc]initWithFrame:vRect];
			CALayer *u  = [s setupHostView];
			u.name = @"root";
			CALayer *uu = [CALayer layer];
			CALayer *w  = [CALayer layer];
			uu.bounds 		= h;
			uu.anchorPoint 	= AZAnchorBottom;
			uu.position	 	= NSMakePoint(NSWidth(vRect)/2, u.boundsHeight -100);
			w.bounds 		= g;
			w.anchorPoint 	= AZAnchorBottom;
			w.position	 	= NSMakePoint(NSWidth(vRect)/2, u.boundsHeight -95);
//			AddShadow(uu);
			uu.borderWidth 	= .1 * uu.boundsWidth;
			uu.borderColor 	= cgWHITE;
			uu.cornerRadius = .1 * uu.boundsWidth;
			AddShadow(w);
			w.delegate	 	= self;
			[w setNeedsDisplay];
			w.shadowOffset 	= AZMultiplySize(w.shadowOffset, .1);
			w.cornerRadius 	= .05 * uu.boundsWidth;
			w.bgC	 		= [[NSColor leatherTintedWithColor:obj] CGColor];
			u.sublayers 	= @[uu, w];
			u.name = [NSS randomWords:1];
//			[drawer addConstraint:AZConstraint(kCAConstraintMinY, u.name)];
			[s setAssociatedValue:u 			 forKey:@"hostLayer" policy:OBJC_ASSOCIATION_RETAIN];
			[s setAssociatedValue:[NSValue valueWithRect:vRect] forKey:@"oldFrame"  policy:OBJC_ASSOCIATION_RETAIN];
//			[s setAnimations:@{@"frame": [CATransition randomTransition]}];
//			s.backgroundColor = obj;//[NSC linenTintedWithColor:obj];
		
		return s;
	}];
	[self makeKeyAndOrderFront:nil];
	return self;
}

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
	AZLOG(@"d in c");
	[NSGraphicsContext drawInContext:ctx flipped:NO actions:^{
		[[NSIMG randomIcon] drawEtchedInRect:AZCenterRectOnPoint(AZRectFromDim(.7*layer.boundsWidth), (NSPoint) {NSMidX(layer.bounds), layer.boundsWidth})];//// fraction:1];// operation:NSCompositeSourceOver fraction:1];
	}];
}

- (void)sendEvent:(NSEvent *)theEvent
{
	if ([theEvent type] == NSLeftMouseDown ) {
		NSPoint aPoint = [theEvent locationInWindow];
		id viewHit = [_bar hitTest:aPoint];
		AZSimpleView *winner = [viewHit isKindOfClass:[AZSimpleView class]] ? viewHit :
							   [viewHit subviewsOfKind:[AZSimpleView class]][0] ?: nil;
		if (winner) {
			AZLOG($(@"winner: %@", winner));
			CABasicAnimation *a = [CABA animationWithKeyPath:@"position.y"];
			a.toValue = @(-300);
//			a.duration = 2;
			a.autoreverses = YES;
//			a.timingFunction = CAMEDIAEASY;
			[winner.layer addAnimation:a];
		}  else 			[self setIgnoresMouseEvents:TRUE];
			// [self initializeClickThrough];
//			CGEnableEventStateCombining(TRUE);
//			AZLeftClick(aPoint);
			// Disable click-through windows (runs [self setIgnoresMouseEvents:FALSE] asynchronously)
//			[self performSelector: @selector(disableIgnoreMouseEvents) withObject:NULL afterDelay: 0.1];
	}
	if ([theEvent type] == NSLeftMouseUp ) {
		[self setIgnoresMouseEvents:NO];
	}
	//			The initializeClickThrough method does basically the following:
	//
	//			// Don't let our events block local hardware events
	//			CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateSupressionInterval);
	//			CGSetLocalEventsFilterDuringSupressionState(kCGEventFilterMaskPermitAllEvents,kCGEventSupressionStateRemoteMouseDrag);




//			winner.backgroundColor = [[winner.backgroundColor brighter]brighter];
//			NSRect saved = [[winner associatedValueForKey:@"oldFrame"]rectValue];
//			NSRect 	newF = AZRectVerticallyOffsetBy(saved, -300);
//					newF = AZRectExceptHigh(newF, NSHeight(newF)+300);
//			[[winner animator]setFrame:saved];
//			NSRect d = _drawerView.frame;
//			d.origin.y = newF.origin.y + 40;
//			[[_drawerView animator]setFrame: d];
////					[winner.layer animate:@"bounds" toCGRect:newF time:2];
////					[winner.layer animate:@"frame" toCGRect:newF time:2];;
////					[winner.layer flipDown];
//			[[[_bar subviews]arrayWithoutObject:winner]each:^(AZSimpleView *obj) {
////				NSRect savedOther = [[obj associatedValueForKey:@"oldFrame"]rectValue];
////				[[obj animator] setFrame:savedOther];
//			}];

	[super sendEvent:theEvent];
}
@end

@implementation NSWindow (BorderlessInit)

-(void) bordlerlessInit{
	self.backgroundColor		 	= CLEAR;
	self.opaque					 	= NO;
	self.canHide				 	= NO;
	self.hidesOnDeactivate		 	= YES;
	self.ignoresMouseEvents		 	= NO;
	self.acceptsMouseMovedEvents 	= YES;
	self.movableByWindowBackground
#ifdef AZMOVABLE
									= YES;
#else 
									= NO;
#endif
	self.level 					 	= NSScreenSaverWindowLevel;//CGWindowLevelForKey(kCGCursorWindowLevelKey)];
	self.collectionBehavior	     	= NSWindowCollectionBehaviorCanJoinAllSpaces |
										NSWindowCollectionBehaviorStationary;
}
@end

//	NSLog(@"event: %@", 	event);
//	// look for mouse down
//	if ([event type] == NSLeftMouseDown) {
//		// look for deepest subview
//		AZSimpleView *deepView = (AZSimpleView*)[_bar hitTest:[event locationInWindow]];
////		if (deepView) {
//			for (AZSimpleView *aClickView in _clickViews) {
//				if ([deepView isSubviewOfView:aClickView]) {
//					[(id)aClickView setBackgroundColor:RANDOMCOLOR];//subviewClicked:deepView];
//					break;
//				}
//			}
////		}
//	}




//		[_bar trackFullView];
//		[NSEvent addLocalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^NSEvent *(NSEvent *e) {
//
//			NSP p = [_bar convertPoint:e. fromView:nil];
//			AZSimpleView *v = [_bar hitTest:p forClass:[AZSimpleView class]];
//			AZLOG(AZString(p));AZLOG(v);
//			if (_hoveredView != v) {
//				v.backgroundColor = RANDOMCOLOR;
//				self.hoveredView = v;
//			}
////			NSLog(@"Went:%@ of Color: %@", e.type == NSMouseEntered ?@"Into":@"Out of", [obj nameOfColor]);
//			return e;
//		}];
//		[_bar setCheckerboard:YES];
//		[_bar setNeedsDisplay:YES];
//		[_bar trackFullView];
//		[NSEVENTLOCALMASK:(NSMouseEnteredMask | NSMouseExitedMask) handler:^NSEvent *(NSEvent *d) {
//			AZLOG(d);
//			if (NSPointInRect(mouseLoc(), _bar.frame))
//				_bar.isHidden ? [_bar fadeIn] : nil;
//			else  !_bar.isHidden ? [_bar fadeOut] : nil;
//				//			d.type == NSMouseExitedMask ? [_bar fadeOut] : [_bar fadeIn];
//			AZLOG(@"entered or ewxit");
//			return d;
//		}];

//        [self setLevel:kCGStatusWindowLevel + 1];
//      if ( [self respondsToSelector:@selector(toggleFullScreen:)] ) {
//            [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces |
//             NSWindowCollectionBehaviorTransient];
//   	} else {

//- (void)setFilter:(NSString *)filterName{
//    if ( fid ){	CGSRemoveWindowFilter( cid, wid, fid );	CGSReleaseCIFilter( cid, fid );	}
//    if ( filterName ) {	CGError error = CGSNewCIFilterByName( cid, (CFStringRef)filterName, &fid );
//        if ( error == noErr ) 		{	CGSAddWindowFilter( cid, wid, fid, 0x00003001 );
//}	}	}
//
//-(void)setFilterValues:(NSDictionary *)filterValues{
//    if ( !fid ) {	return;		}
//    CGSSetCIFilterValuesFromDictionary( cid, fid, (CFDictionaryRef)filterValues );
//}



/*

 add a click view

 click view must be a sub view of the NSWindow contentView

 */

//- (void)addClickView:(AZSimpleView *)aView
//{
	//	if ([aView isDescendantOf:[self contentView]] && [aView respondsToSelector:@selector(subviewClicked:)])
	// _clickViews will maintain a weak ref to aView so we don't need to remove it
//}


//@implementation Drawer
//
//-(void) registerLevers:(NSView*)leverView
//{
//	static NSArray *baseline = nil;
//	baseline = [leverView.subviews map:^id(AZSimpleView *obj) {
//		return [NSValue valueWithPoint:[obj frame].origin];
//	}];
//
//	_leverView = leverView;
//	NSTimer *timer = [NSTimer timerWithTimeInterval:1 block:^(NSTimeInterval time) {
//		[_leverView.subviews eachWithIndex:^(AZSimpleView *obj, NSInteger idx) {
//			CGF diff = [baseline[idx]pointValue].y - [obj frame].origin.y;
//			if (diff != 0) { NSLog(@"diff with Lever # %ld", idx);
//				NSRect selfframe = self.frame;
//				selfframe.origin.y += diff;
//				[self setFrame:selfframe display:YES animate:YES];
//			}
//		}];
//	} repeats:YES];
//}
//- (id) init
//{
//	NSRect 	f = AZRectExceptHigh(AZMenuBarFrame(), ScreenHighness());
////			f = AZRectVerticallyOffsetBy(f, -100);
//
//	if (!(self = [self initWithContentRect:f styleMask:NSBorderlessWindowMask
//								   backing:NSBackingStoreBuffered	defer:NO] )) return nil;
//
//	[self bordlerlessInit];
//	self.backgroundColor		 = [RED alpha:.4];
//
//	_root  	= [[self contentView] setupHostView];
//	CALayer *drawer = [CALayer layer];
//	CALayer *liner  = [CALayer layer];
//	_root.layoutManager = AZLAYOUTMGR;
//	[drawer addConstraintsSuperSize];
//	[liner addConstraintsSuperSize];
//	[liner addConstraints:@[AZConstRelSuperScaleOff(kCAConstraintMinY, 1, 15), AZConstRelSuperScaleOff(kCAConstraintWidth, .9, 0)]];
//	liner.contents = [NSImage imageNamed:@"black.minimal.jpg"];
//	AddShadow(drawer);
//	drawer.borderWidth 	= 20;
//	drawer.borderColor 	= cgBLACK;
//
//	liner.cornerRadius = 10;
//	AddShadow(liner);
////	w.delegate	 	= self;
////	[w setNeedsDisplay];
////	w.shadowOffset 	= AZMultiplySize(w.shadowOffset, .5);
////	w.cornerRadius 	= 7;
////	w.bgC	 		= [[NSColor leatherTintedWithColor:obj] CGColor];
//	_root.sublayers 	= @[drawer, liner];
//
//
//	return self;
//}
//
//@end
// This action method dispatches mouse and keyboard events sent to the window by the NSApplication object.
// We intercept the sendEvent: method at the NSWindow level to inspect it.
// If the event type is a click ("NSLeftMouseDown") and the element that the mouse
// is hovering over is an input, then we do something
