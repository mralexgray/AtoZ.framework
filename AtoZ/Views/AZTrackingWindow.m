	//
	//  AZTrackingDelegateView.m
	//  AtoZ
	//
	//  Created by Alex Gray on 8/24/12.
	//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
	//

#import "AZTrackingWindow.h"
#import "Atoz.h"

@implementation AZTrackingWindow

	// key values for dictionary in NSTrackingAreas's userInfo,
	// which tracking area is being tracked



+ (AZTrackingWindow*) oriented:(AZOrient)orient intruding:(CGFloat)distance{
	return [AZTrackingWindow oriented:orient intruding:distance withDelegate:nil];
}

+ (AZTrackingWindow*) oriented:(AZOrient)orient intruding:(CGFloat)distance withDelegate:(id)del{

	NSRect screenRect = AZScreenFrame();
	NSRect thisRect   =
		orient == AZOrientLeft   ? AZLowerEdge( AZLeftEdge(screenRect, distance), AZHeightUnderMenu() )
	  :	orient == AZOrientTop	 ? AZMakeRectMaxXUnderMenuBarY (distance)
	  :	orient == AZOrientRight  ? AZLowerEdge (  AZRightEdge (screenRect, distance), AZHeightUnderMenu())
	  : orient == AZOrientBottom ? AZLowerEdge(screenRect, distance)	:  NSZeroRect;

	AZTrackingWindow *w = [[[self class] alloc] initWithContentRect:thisRect styleMask:NSBorderlessWindowMask
																			   backing:NSBackingStoreBuffered
																				 defer:NO];
	w.orientation 		= orient;
	w.intrusion 		= distance;
	if (del) w.delegate = del;													return w;
}

- (id) initWithContentRect:(NSRect)contentRect
			     styleMask:(NSUInteger)aStyle
				   backing:(NSBackingStoreType)bufferingType
				     defer:(BOOL)flag {							if (self = [super initWithContentRect:contentRect
																							styleMask:NSBorderlessWindowMask
																							  backing:NSBackingStoreBuffered
																							    defer:NO]) {
		self.level 			 			= NSStatusWindowLevel;
		self.backgroundColor 			= CLEAR;
		self.alphaValue      			= 1.0;
		self.opaque				 		= YES;
		self.hasShadow		 			= NO;
		self.movable		 			= NO;
		self.hidesOnDeactivate			= NO;
		self.acceptsMouseMovedEvents	= NO;
		self.ignoresMouseEvents 		= YES;

		self.view = [[AZSimpleView alloc]initWithFrame:contentRect];
		_view.backgroundColor = RANDOMCOLOR;									[[self contentView] addSubview : _view];

		self.handle = [[NSImageView alloc]initWithFrame:contentRect];
		_handle.image =  [[	NSImage systemImages]randomElement];				[[self contentView] addSubview:_handle];
//		[_view setNeedsDisplay:YES];

//		AZMakeRectFromSize(contentRect.size)]/
		//AZCenteredRect(contentRect.size)		AZSizeFromDimension(AZMinDim([self frame].size)), [self frame])];
//		_handle.
		//
	[self setShowsHandle:YES];

//		imageInFrameworkWithFileName:@"tab.png"];
//		NSLog(@"handleimage %@", _handle.image);
//`
//		[NSEvent  addLocalMonitorForEventsMatchingMask:NSMouseEnteredMask | NSMouseExitedMask handler:^NSEvent *(NSEvent *ff) {
//			NSLog(@"lcoal event: %@", ff);
//			return ff;
//		 }];
	}
	return self;
}

- (void) awakeFromNib {

		 [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent *e) {

		NSLog(@"Mouse moved: %@", NSStringFromPoint([e locationInWindow]));
//		return e;
	}];


//
//
//	[NSEvent addGlobalMonitorForEventsMatchingMask: NSMouseMovedMask | NSMouseExitedMask |NSMouseEnteredMask  handler:^(NSEvent *e) {
//
//		[_view setBackgroundColor:RANDOMCOLOR];
//		NSLog(@"event: %@", e.type);
//	//			[self mouseHandler:e];
//	//			return e;
//	}];
}

- (BOOL) acceptsFirstResponder {
	return YES;
}

- (void) setShowsHandle:(BOOL)showsHandle {

	if (!_handle){
	}
}

- (void) mouseHandler:(NSEvent *)theEvent {

	NSPoint mousePoint = [theEvent locationInWindow];
	BOOL isHit = (NSPointInRect(mousePoint, [self frame]));
	NSLog(@"Mouse:  %@", theEvent);


//	   NSStringFromPoint(mousePoint));// [theEvent description]);//NSStringFromPoint( mousePoint));

//	isHit ? [_view slideUp] : [_view slideDown];
//	[[self animator]setAlphaValue: isHit ? 1 : 0 ];
	[self setIgnoresMouseEvents: isHit];
		//	}
}


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


@end


