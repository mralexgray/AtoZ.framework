
//  AZBorderlessResizeWindow.m
//  AtoZ
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZBorderlessResizeWindow.h"
#import "AtoZUmbrella.h"

@interface AZHandlebarWindow : NSWindow
@end
@implementation AZHandlebarWindow

- (id)init; {

	if (( self = [super initWithContentRect:NSZeroRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO] ))
	{
		self.animationBehavior = NSWindowAnimationBehaviorNone;
		self.acceptsMouseMovedEvents = NO;
		self.movableByWindowBackground = NO;
		self.ignoresMouseEvents = YES;
		self.backgroundColor = RANDOMCOLOR;
//		self.contentView = [AZSimpleView withFrame:NSZeroRect color:RANDOMCOLOR];
//		[((AZSimpleView*)self.contentView) setAutoresizingMask:NSSIZEABLE];
	}
	return self;
}
- (BOOL) acceptsFirstResponder { return  NO; }

@end


@interface AZBorderlessResizeWindow  ()
{
	BOOL shouldDrag,shouldRedoInitials;
	NSPoint initialLocation, initialLocationOnScreen, currentLocation,  newOrigin;
	NSRect windowFrame, screenFrame, initialFrame;
	float minY;
}
@property (ASS, NATOM) NSP initialMouseLocation;
@property (ASS, NATOM) NSR initialWindowFrame;
@property (ASS, NATOM) BOOL isResizeOperation;
@property (nonatomic, strong) AZHandlebarWindow *handle;
@end


@implementation AZBorderlessResizeWindow
@synthesize  initialMouseLocation, initialWindowFrame, isResizeOperation ;

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {

    if (self != [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag] ) return nil;


	self.opaque		= NO;
	self.bgC		= [NSColor clearColor];
	self.level		= NSNormalWindowLevel; //NSPopUpMenuWindowLevel];
	self.styleMask	= NSBorderlessWindowMask;
	self.isVisible 	= YES;
	self.minSize 	= self.frame.size;
	self.animationBehavior = NSWindowAnimationBehaviorNone;
	self.acceptsMouseMovedEvents = YES;
	self.movableByWindowBackground = YES;
	self.showsResizeIndicator = YES;
	self.resizeIncrements = NSMakeSize(100, 100);
	return self;
}

- (BOOL)canBecomeKeyWindow	{	return YES;	}

- (BOOL)canBecomeMainWindow	{	return YES;	}

- (void)mouseDragged:(NSEvent *)theEvent
{
	if (shouldRedoInitials)
	{
		initialLocation = [theEvent locationInWindow];
		initialLocationOnScreen = [self convertBaseToScreen:[theEvent locationInWindow]];
		initialFrame = [self frame];
		shouldRedoInitials = NO;
 
		shouldDrag =! initialLocation.x > initialFrame.size.width - 20 && initialLocation.y < 20;

		screenFrame = AZScreenFrame();
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
 
- (void)mouseUp:(NSEvent*)e 	{	shouldRedoInitials = YES; }



-(void) mouseMoved:(NSEvent *)theEvent
{

	NSPoint p = [self.contentView convertPoint:[theEvent locationInWindow]fromView:nil];
	NSR 	r = [self.contentView bounds];
	NSSZ 	i = AZSizeFromDimension(30);
	if ( AZPointIsInInsetRects(p, r, i) ) {
		AZPOS d = AZPosOfPointInInsetRects(p, r, i);
		NSLog(@"%@   %@", NSStringFromPoint(p), stringForPosition(d));
		NSR new = AZInsetRectInPosition(r, i, d);
		NSR rel = AZOffsetRect(new, self.frame.origin);

//		NSR flp = AZRectFlippedOnEdge(rel, d);
		_handle = _handle ?: [AZHandlebarWindow.alloc init];
		if (![_handle isVisible]) [self addChildWindow:_handle ordered:NSWindowAbove];
    	[_handle setFrame:rel display:YES animate:YES];
	}
}

-(void) scrollWheel:(NSEvent *)theEvent
{

	//	CGF off = theEvent.deltaY < 0 ? - 10 : 10;
	NSR new = self.frame;
	new.size.width += theEvent.deltaX /10;//NSOffsetRect(self.frame,off, 0);
	new.size.height += theEvent.deltaY/10 ;
	new.size.height = new.size.height < 100? 100 : new.size.height;
	new.size.width = new.size.width < 100 ? 100  : new.size.width;
	[[self animator] setFrame:new display:YES animate:YES];
	[[[self contentView]subviews]each:^(id obj) {
		[[obj animator] setFrame:new];
	}];
}

- (void)setIsVisible:(BOOL)flag
{
	[[self animator] setAlphaValue:flag ? 1.0 : 0.0];
	[super setIsVisible:flag];
}

- (void)toggleVisibility
{
	[self setIsVisible:![self isVisible]];
}

static NSP currentLocation, newOrigin, initialLocation;
static NSR screenFrame, windowFrame;


/*
- (void)mouseDragged:(NSEvent *)theEvent
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

- (void)mouseDown:(NSEvent *)theEvent
{
	// Get mouse location in global coordinates
	initialLocation = [self convertBaseToScreen:[theEvent locationInWindow]];
	initialLocation.x -= windowFrame.origin.x;
	initialLocation.y -= windowFrame.origin.y;
	NSLog(@"initial: %@", AZString(initialLocation));
}
*/

//- (void)mouseMoved:(NSEvent *)event
//{
//	//set movableByWindowBackground to YES **ONLY** when the mouse is on the title bar
//	NSPoint mouseLocation = [event locationInWindow];
//	if (NSPointInRect(mouseLocation, AZUpperEdge([self frame], 40)))
//		[self setMovableByWindowBackground:YES];
//	else
//		[self setMovableByWindowBackground:NO];
//
//	//This is a good place to set the appropriate cursor too
//}
//
//- (void)mouseDown:(NSEvent *)event
//{
//	//Just in case there was no mouse movement before the click AND
//	//is inside the title bar frame then setMovableByWindowBackground:YES
//	NSPoint mouseLocation = [event locationInWindow];
//	if (NSPointInRect(mouseLocation, AZUpperEdge([self frame], 40)))
//		[self setMovableByWindowBackground:YES];
//	else //if (NSPointInRect(mouseLocation, bottomRightResizingCornerRect))
//		[self doBottomRightResize:event];
//	//... do all other resizings here. There are 6 more in OSX 10.7!
//}
//
//- (void)mouseUp:(NSEvent *)event
//{
//	//movableByBackground must be set to YES **ONLY**
//	//when the mouse is inside the titlebar.
//	//Disable it here :)
//	[self setMovableByWindowBackground:NO];
//}
////All my resizing methods start in mouseDown:
//
//- (void)doBottomRightResize:(NSEvent *)event {
//	//This is a good place to push the appropriate cursor
//
//	NSRect r = [self frame];
//	while ([event type] != NSLeftMouseUp) {
//		event = [self nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
//		//do a little bit of maths and adjust rect r
//		[self setFrame:r display:YES];
//	}
//
//	//This is a good place to pop the cursor :)
//
//	//Dispatch unused NSLeftMouseUp event object
//	if ([event type] == NSLeftMouseUp) {
//		[self mouseUp:event];
//	}
//}

@end
