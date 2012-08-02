#import "AZMouser.h"

CGPoint MousePoint() {
	CGEventRef event = CGEventCreate(NULL);
	CGPoint cursor = CGEventGetLocation(event);
	CFRelease(event);
	return cursor;
}
//kCGHIDEventTap
//Specifies that an event tap is placed at the point where HID system events enter the window server.

//kCGSessionEventTap
//Specifies that an event tap is placed at the point where HID system and remote control events enter a login session.

//kCGAnnotatedSessionEventTap
//Specifies that an event tap is placed at the point where session events have been annotated to flow to an application.

void PostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point) {
	CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
	CGEventSetType(theEvent, type);
	CGEventPost(kCGHIDEventTap, theEvent);
	if (theEvent) CFRelease(theEvent);
}

void LeftClick(const CGPoint point)  {
	PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, point);
	NSLog(@"Click!");
	PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point);
	PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, point);
}

void DragBetwixt(const CGPoint a, const CGPoint b) {
	PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, a);
	PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, a);
	/*	CGEventRef dragTime = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDragged, b, kCGMouseButtonLeft);
	 CGEventPost(kCGHIDEventTap, dragTime);
	 */
	//	theEvent = CGEventCreateMouseEvent(None, type, (posx,posy), kCGMouseButtonLeft)
	//	CGEventPost(kCGHIDEventTap, theEvent)
	//	CGEventSetType(theEvent, type);
	CGPoint next = a;
	CGFloat range = distanceFromPoint(a,b);
	CGEventRef dragTime;
	for (int i = 0; i < 50; i++) {
		next = AZMovePointAbs (next, b, .02 * range);
		NSLog(@"Mext: %@", NSStringFromPoint(next));
		CGEventSourceRef eventSource = NULL;
		dragTime = CGEventCreateMouseEvent(eventSource, kCGEventLeftMouseDragged, next, kCGMouseButtonLeft);
//		CGEventPost//(kCGAnnotatedSessionEventTap, dragTime);
//		CGEventPost(kCGHIDEventTap. dragTime);
		CGEventPost(kCGSessionEventTap, dragTime);
		usleep(19999);
//		CFRelease(dragTime);

		//		PostMouseEvent(kCGEventLeftMouseDragged, kCGMouseButtonLeft, next);
	}
	PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, b);
}
void DragBetwixtOnFancyPath(const CGPoint a, const CGPoint b) {
	NSPoint AZMovePoint(NSPoint origin, NSPoint target, CGFloat relativeDistance);
	
	NSBezierPath *path = [NSBezierPath bezierPath];
		// Move to the first control point
	[path moveToPoint:a];
		// Add a line from the control point to the first point of the curve
	[path lineToPoint:b];
		// Create the curve
		//	[path curveToPoint:a controlPoint1:ControlPt1 controlPoint2:ControlPt2];
		// Draw a line from the end of the curve to the second control point
		//	[path lineToPoint:ControlPt2];
}
void Click(const CGPoint point)  {
    PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, point);
    NSLog(@"Click!");
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point);
    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, point);
}

void RightClick(const CGPoint point) 
{
	PostMouseEvent(kCGMouseButtonRight, kCGEventMouseMoved, point);
	NSLog(@"Click Right");
	PostMouseEvent(kCGMouseButtonRight, kCGEventRightMouseDown, point);
	PostMouseEvent(kCGMouseButtonRight, kCGEventRightMouseUp, point);
}

void doubleClick(CGPoint point) {
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, point, kCGMouseButtonLeft);
    CGEventSetIntegerValueField
	(theEvent, kCGMouseEventClickState, 2);
    CGEventPost(kCGHIDEventTap, theEvent);  
    CGEventSetType(theEvent, kCGEventLeftMouseUp);  
    CGEventPost(kCGHIDEventTap, theEvent);  
    CGEventSetType(theEvent, kCGEventLeftMouseDown);  
    CGEventPost(kCGHIDEventTap, theEvent);  
    CGEventSetType(theEvent, kCGEventLeftMouseUp); 
    CGEventPost(kCGHIDEventTap, theEvent); 
    CFRelease(theEvent); 
}
void MoveTo(const CGPoint point) {
	PostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, point);
}
	//void DragTo(const CGPoint where) {
	////    PostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point);
	////	Click(a);
	//	PostMouseEvent(kCGEventLeftMouseDragged, kCGMouseButtonLeft, where);
	//}


/*	CGEventRef event = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDragged, point, kCGMouseButtonLeft);
 CGEventPost(kCGHIDEventTap, event);
 CFRelease(event);
 
 CGEventRef mouseDownEv = CGEventCreateMouseEvent (NULL,kCGEventLeftMouseDown,pt,kCGMouseButtonLeft);
 CGEventPost (kCGHIDEventTap, mouseDownEv);
 
 CGEventRef mouseUpEv = CGEventCreateMouseEvent (NULL,kCGEventLeftMouseUp,pt,kCGMouseButtonLeft);
 CGEventPost (kCGHIDEventTap, mouseUpEv );
 
 CGEventRef CGEventCreateMouseEvent(
 CGEventSourceRef source,        // The event source may be taken from another event, or may be NULL.
 CGEventType mouseType,          // `mouseType' should be one of the mouse event types.
 CGPoint mouseCursorPosition,    // `mouseCursorPosition'  should be the position of the mouse cursor in global coordinates.
 CGMouseButton mouseButton);     // `mouseButton' should be the button that's changing state;
 // `mouseButton'  is ignored unless `mouseType' is one of
 // `kCGEventOtherMouseDown', `kCGEventOtherMouseDragged', or `kCGEventOtherMouseUp'.
 //Mouse button 0 is the primary button on the mouse. Mouse button 1 is the secondary mouse button (right). Mouse button 2 is the center button, and the remaining buttons are in USB device order.
 
 //kCGEventLeftMouseDown
 //kCGEventLeftMouseUp
 //kCGEventRightMouseDown
 //kCGEventRightMouseUp
 //kCGEventMouseMoved
 //kCGEventLeftMouseDragged
 //kCGEventRightMouseDragged
 */
@implementation AZMouserIndicator
@synthesize indicatorImage;
/* This routine is called at app launch time when this class is unpacked from the nib.*/
- (void)awakeFromNib {
    self.indicatorImage = [NSImage imageInFrameworkWithFileName:@"circle2.tif"];
	[[self window] setHasShadow:NO];
	[self setFrameSize:indicatorImage.size];
}
/*	When it's time to draw, this routine is called. This view is inside the window, the window's opaqueness has been turned off, and the window's styleMask has been set to NSBorderlessWindowMask on creation, so this view draws the all the visible content. The first two lines below fill the view with "clear" color, so that any images drawn also define the custom shape of the window.  Furthermore, if the window's alphaValue is less than 1.0, drawing will use transparency.
 */
- (void)drawRect:(NSRect)rect {
		// Clear the drawing rect.
    [[NSColor clearColor] set];
    NSRectFill([self frame]);
		// A boolean tracks the previous shape of the window. If the shape changes, it's necessary for the
	[indicatorImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
}
@end
@implementation AZMouserWindow
@synthesize initialLocation, indicatorView;


- (id)init
{
    self = [super init];
    if (self) {
		
    }
    return self;
}
/* In Interface Builder, the class for the window is set to this subclass. Overriding the initializer provides a mechanism for controlling how objects of this class are created. */

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
		// Using NSBorderlessWindowMask results in a window without a title bar.
    self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    if (self != nil)
		{
			// Start with no transparency for all drawing into the window
        [self setAlphaValue:1.0];
			// Turn off opacity so that the parts of the window that are not drawn into are transparent.
        [self setOpaque:NO];
		[self setIgnoresMouseEvents:YES];
		[self setLevel:NSScreenSaverWindowLevel];
		NSSize size;
		size.width = 128;
		size.height = 128;
		[self setContentSize:size];
		[self setAlphaValue:0.0f];
		}
    return self;
}
- (void) awakeFromNib { [self setIsVisible:NO]; }
/*	 Custom windows that use the NSBorderlessWindowMask can't become key by default. Override this method so that controls in this window will be enabled.	 */
- (BOOL)canBecomeKeyWindow  {   return NO;  }
- (BOOL)canBecomeMainWindow {	return NO;	}
@end


@implementation AZMouser
@synthesize window;
- (void) setUp {
	self.window = [[AZMouserWindow alloc]init];
	
	
}

+ (AZMouser*) sharedInstance { return [super sharedInstance]; }
/*
 - (void)from:(NSPoint)xy to:(NSPoint)zw {
 // CGPostMouseEvent( CGPoint        mouseCursorPosition,
 //                   boolean_t      updateMouseCursorPosition,
 //                   CGButtonCount  buttonCount,
 //                   boolean_t      mouseButtonDown, ... )
 CGEventRef ourEvent = CGEventCreate(NULL);
 CGPoint ourLoc = CGEventGetLocation(ourEvent);
 //	[args setObject:[NSNumber numberWithInteger:temp] forKey:@"x"];
 //	[args setObject:[NSNumber numberWithInteger:temp] forKey:@"y"];
 //	int x = [((NSNumber*) [args valueForKey:@"x"])intValue];
 //	int y = [((NSNumber*) [args valueForKey:@"y"])intValue];
 // The data structure CGPoint represents a point in a two-dimensional coordinate system.  Here, X and Y distance from upper left, in pixels.
 
 CGPoint startPoint = xy;
 CGPoint endPoint = zw;
 
 CGPostMouseEvent( startPoint, TRUE, 1, FALSE ); //Move to new position
 usleep(100000);
 CGPostMouseEvent( startPoint, FALSE, 1, TRUE );
 usleep(100000);
 
 // End drag by moving to new location
 CGPostMouseEvent( endPoint, TRUE, 1, TRUE );
 usleep(100000);
 CGPostMouseEvent( endPoint, FALSE, 1, FALSE );
 usleep(100000);
 // Possible sleep routines
 //sleep(2);
 }
 */
@end


@implementation AUWindowExtend

static CFMachPortRef AUWE_portRef = NULL;
static CFRunLoopSourceRef AUWE_loopSourceRef = NULL;
static CGEventRef AUWE_OnMouseMovedFactory (
											CGEventTapProxy proxy,
											CGEventType type,
											CGEventRef event,
											void *refcon)
{
	if (kCGEventMouseMoved == type) { // paranoic
									  //		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		if (refcon) {
			id obj = (__bridge id)refcon;
			if ([[obj class] instancesRespondToSelector:@selector(mouseMoved:)]) {
				[obj performSelector:@selector(mouseMoved:) withObject:[NSEvent eventWithCGEvent:event]];
			}
		}
			//		[pool drain];
	}
	return event;
}

- (void)dealloc
{
	if (AUWE_portRef) {
		CGEventTapEnable(AUWE_portRef, false);
		if (CFRunLoopContainsSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes)) {
			CFRunLoopRemoveSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes);
		}
		CFRelease(AUWE_portRef);
		CFRelease(AUWE_loopSourceRef);
		AUWE_portRef = NULL;
		AUWE_loopSourceRef = NULL;
	}
		//	[super dealloc];
}

- (void)setAcceptsMouseMovedEvents:(BOOL)acceptMouseMovedEvents screen:(BOOL)anyWhere
{
	if (anyWhere) {
		[super setAcceptsMouseMovedEvents:NO];
		if (!AUWE_portRef) {
			if ((AUWE_portRef = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, kCGEventTapOptionListenOnly,
												 CGEventMaskBit(kCGEventMouseMoved), AUWE_OnMouseMovedFactory, (__bridge void *)(self)))) {
				if ((AUWE_loopSourceRef = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, AUWE_portRef, 0))) {
					CFRunLoopAddSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes);
					CGEventTapEnable(AUWE_portRef, true);
				} else { // else error
					CFRelease(AUWE_portRef);
					AUWE_portRef = NULL;
				}
			}// else error
		}
	} else {
		if (AUWE_portRef) {
			CGEventTapEnable(AUWE_portRef, false);
			if (CFRunLoopContainsSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes)) {
				CFRunLoopRemoveSource(CFRunLoopGetCurrent(), AUWE_loopSourceRef, kCFRunLoopCommonModes);
			}
			CFRelease(AUWE_portRef);
			CFRelease(AUWE_loopSourceRef);
			AUWE_portRef = NULL;
			AUWE_loopSourceRef = NULL;
		}
		[super setAcceptsMouseMovedEvents:acceptMouseMovedEvents];
	}
}

@end

/* EOF */
