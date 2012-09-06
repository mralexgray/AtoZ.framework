#import "AZMouser.h"
#import "AtoZ.h"
#include <string.h>

bool bDragging = false;		int bMouseSpeed = 4;			/* MOUSE MOVEMENT */



CGPoint mouseLoc() {
	CGEventRef event = CGEventCreate(NULL);
	CGPoint cursor = CGEventGetLocation(event);
	CFRelease(event);
	return cursor;
}

void warpTo ( CGPoint dest ) {
	CGWarpMouseCursorPosition(dest);
	if (bDragging) mouseEvent(LEFT_MOUSE, MOUSE_DRAGGED, 0);
	else mouseEvent(NO_MOUSE_BUTTON, MOUSE_MOVED, 0);
}

void mouseMove(int posX, int posY) {
	CGPoint dest = { .x = posX, .y = posY };
	CGWarpMouseCursorPosition(dest);
	if (bDragging) {
		mouseEvent(LEFT_MOUSE, MOUSE_DRAGGED, 0);
	} else {
		mouseEvent(NO_MOUSE_BUTTON, MOUSE_MOVED, 0);
	}
}

void moveVia( int x, int y ) {	moveTo(CGPointMake(x,y)); }
void moveTo ( CGPoint dest ) {
	CGPoint currLoc = mouseLoc();
	CGPoint destLoc = dest;
	float x = currLoc.x;
	float y = currLoc.y;
	float xrat, yrat;

	int diffX = abs(currLoc.x - destLoc.x);
	int diffY = abs(currLoc.y - destLoc.y);
	int dirX = currLoc.x > destLoc.x ? -1 : 1;
	int dirY = currLoc.y > destLoc.y ? -1 : 1;

	if (diffX == 0 && diffY == 0) {
		return;
	}

	if (diffX > diffY) {
		xrat = MOUSE_RESOLUTION * dirX;
		if (diffY == 0) {
			yrat = 0;
		} else {
			yrat = (((float)diffY / diffX) * dirY) * MOUSE_RESOLUTION;
		}
	} else {
		yrat = MOUSE_RESOLUTION * dirY;
		if (diffX == 0) {
			xrat = 0;
		} else {
			xrat = (((float)diffX / diffY) * dirX) * MOUSE_RESOLUTION;
		}
	}

	int xArrived = 0, yArrived = 0, diff;
	float accelerant;
	while (!xArrived && !yArrived) {
		diffX = abs(destLoc.x - x);
		diffY = abs(destLoc.y - y);
		diff = diffX > diffY ? diffX : diffY;
		accelerant = diff > 70 ? diff / 40 : (diff > 40 ? diff / 20 : 1);

		if (!xArrived && diffX < abs(xrat)) {
			xArrived = 1;
			x = destLoc.x;
		} else {
			x += xrat * accelerant;
		}

		if (!yArrived && diffY < abs(yrat)) {
			yArrived = 1;
			y = destLoc.y;
		} else {
			y += yrat * accelerant;
		}

		mouseMove((int)x, (int)y);
		usleep((int)(bMouseSpeed * (MOUSE_SPEED * MOUSE_RESOLUTION)));
	}
}
void dragTo ( CGPoint dest ) {
	bDragging = true;
	mouseEvent  ( 1, MOUSE_DOWN, SINGLE_CLICK);	usleep(50000);
	moveTo ( dest );					usleep(50000);
	mouseEvent  ( 1, MOUSE_UP, SINGLE_CLICK);
}

//nullEvent                     = 0,
//mouseDown                     = 1,
//mouseUp                       = 2,
//keyDown                       = 3,
//keyUp                         = 4,
//autoKey                       = 5,
//updateEvt                     = 6,
//diskEvt                       = 7,    /* Not sent in Carbon. See kEventClassVolume in CarbonEvents.h*/
//activateEvt                   = 8,
//osEvt                         = 15,
//kHighLevelEvent               = 23									/* MOUSE CLICKING */

//void mouseDown(   EventKind btn,  EventMask clickType ) 		{
//	mouseEvent(btn, MOUSE_DOWN, clickType);
//}

//void mouseDownUp(    EventKind btn,  EventMask clickType){ //int btn,  int clickType ) 		{
//	mouseDown(btn, clickType);
//	usleep(400000);
//	mouseUp(btn, clickType);
//}

//void mouseUp(	     EventKind btn,  EventMask clickType){//int btn,  int clickType ) 		{
//	mouseEvent(btn, MOUSE_UP, clickType);
//}


@interface AZMouser ()

@property (retain) NSUserDefaults *defaults;
@end

@implementation AZMouser

- (void) setUp 				{

	_defaults = [NSUserDefaults standardUserDefaults];
	[self listenForCancel];
}

- (void)listenForCancel {

	[NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask /*NSScrollWheelMask*/ handler:^(NSEvent *event) {
		NSLog(@"%d",event.keyCode);
		[AZMouser reloadSharedInstance];
//		NSUInteger key = 44; // 44 is forward slash

//		NSUInteger modifier = NSCommandKeyMask;// NSControlKeyMask | NSAlternateKeyMask;
//		if ([event keyCode] == key && [NSEvent modifierFlags] == modifier)
//			NSRunCriticalAlertPanel(nil,@"Commmand / was detected",nil,nil,nil);

		// Activate app when pressing cmd+ctrl+alt+T
//		if([event modifierFlags] == 1835305 && [[event charactersIgnoringModifiers] compare:@"t"] == 0) {

//		}

	}];
}

- (float) largeValue 		{
	return [[[_defaults persistentDomainForName:@"com.apple.dock"] valueForKey:@"largesize"]floatValue];
}
- (NSSize) screenSize 		{
	return [[NSScreen mainScreen] frame].size;
}
- (CGPoint) mouseLocation	{
	return mouseLoc();
}
- (AZDockOrientation) orientation 	{
	NSString   *dockPinning = [[_defaults persistentDomainForName:@"com.apple.dock"] valueForKey:@"orientation"];
	NSLog(@"Dock is on the %@", dockPinning);
	return ([dockPinning isEqualTo:@"left"]) ? AZDockOrientLeft :
	([dockPinning isEqualTo:@"bottom"] ? AZDockOrientBottom : AZDockOrientRight);
}

- (void) moveTo:(CGPoint)point {

	[NSApp activateIgnoringOtherApps:YES];
	moveTo(point);
}
- (void) dragFrom:(CGPoint)a 		to:(CGPoint)z {
	[NSApp activateIgnoringOtherApps:YES];
	moveTo ( a );
	sleep(3);					// start at A
//	float delta = AZDistanceFromPoint(a, z);
//	switch (self.orientation)
//		{case AZDockOrientBottom: {
//			moveVia( a.x, self.screenSize.height ); 		// Coax to edge (bottom)
//			moveTo ( a );									// start at A
			dragTo ( z );
//			$points( (point.x - a.x), large),
//			$point(z) ];
//			break;
/*		}
		case AZDockOrientLeft:
//			return @[$points(0, point.y)];
			break;
		case AZDockOrientRight:
//			return @[ $points(_screenSize.width, point.y)];
			break;
		default:
			break;
	}
*/
}




- (NSArray*) coaxPointsForPoints:(CGPoint)point to:(CGPoint)dest {
	float dist = AZDistanceFromPoint(point, dest);
	float large = [self largeValue];
	switch (self.orientation) {
		case AZDockOrientBottom: {
		return @[	$point(	 point),							// start at A
					$points(	 point.x, _screenSize.height), 		// Coax to edge (bottom)
					$point(  point ),
					$points( (point.x - dest.x), large),
			$point(dest) ];
			break;
		}
		case AZDockOrientLeft:
			return @[$points(0, point.y)];
			break;
		case AZDockOrientRight:
			return @[ $points(_screenSize.width, point.y)];
			break;
		default:
			break;
	}
}

- (NSArray*) arcPointsBetween:(CGPoint)a and:(CGPoint)b
{
	float distance = distanceFromPoint(a,b);
	float radius = 25;
	//	return [[@0 to:@20]arrayUsingIndexedBlock:^id(id obj, NSUInteger idx) {
	NSBezierPath *originalPath = [NSBezierPath bezierPath];
	[originalPath appendBezierPathWithArcFromPoint:a toPoint:b radius:radius];
	NSBezierPath *flatPath = [originalPath bezierPathByFlatteningPath];
	NSInteger count = [flatPath elementCount];
	NSLog(@"$%ld", count);
	NSPoint prev, curr;
	[flatPath setLineWidth:10];
	[RED set];
	NSImage *image = [[NSImage alloc]initWithSize:NSMakeSize(512,512)];
	[image lockFocus];
	[[NSColor blackColor]set];
	[flatPath stroke];
	[image unlockFocus];
	[image saveAs:@"/Users/localadmin/Desktop/curve.png"];

	NSInteger i;
	for(i = 0; i < count; ++i) {
		// Since we are using a flattened path, no element will contain more than one point
		NSBezierPathElement type = [flatPath elementAtIndex:i associatedPoints:&curr];
		if(type == NSLineToBezierPathElement) {
			NSLog(@"Line from %@ to %@",NSStringFromPoint(prev),NSStringFromPoint(curr));
		} else if(type == NSClosePathBezierPathElement) {
			// Get the first point in the path as the line's end. The first element in a path is a move to operation
			[flatPath elementAtIndex:0 associatedPoints:&curr];
			NSLog(@"Close line from %@ to %@",NSStringFromPoint(prev),NSStringFromPoint(curr));
		}
	}
	return @[@22];
}


@end

/* MOUSE INPUT */

//CGPoint mouseLoc() {
//	Point currLoc;
//	currLoc = AZMousePoint();
//	GetGlobalMouse(&currLoc);
//	CGPoint cgLoc = {.x = currLoc.h, .y = currLoc.v};
//	return AZMousePoint();// cgLoc;
//}

// btn: 0 = none, 1 = left, 2 = right, etc
CGEventType mouseEventType(int btn, int btnState) {
	switch(btn) {
		case NO_MOUSE_BUTTON:
			return kCGEventMouseMoved;
		case LEFT_MOUSE:
			switch(btnState) {
				case MOUSE_UP:
					return kCGEventLeftMouseUp;
				case MOUSE_DRAGGED:
					return kCGEventLeftMouseDragged;
				default:
					return kCGEventLeftMouseDown;
			}
		case RIGHT_MOUSE:
			switch(btnState) {
				case MOUSE_UP:
					return kCGEventRightMouseUp;
				case MOUSE_DRAGGED:
					return kCGEventRightMouseDragged;
				default:
					return kCGEventRightMouseDown;
			}
		default:
			switch(btnState) {
				case MOUSE_UP:
					return kCGEventOtherMouseUp;
				case MOUSE_DRAGGED:
					return kCGEventOtherMouseDragged;
				default:
					return kCGEventOtherMouseDown;
			}
	}
}

void mouseEvent(int btn, int btnState, int clickType) {
	CGPoint currLoc;
	currLoc = mouseLoc();
	CGEventType mouseType = mouseEventType(btn, btnState);

	CGMouseButton mb = (btn == LEFT_MOUSE) ?
    kCGMouseButtonLeft :
    (btn == RIGHT_MOUSE) ?
	kCGMouseButtonRight :
	kCGMouseButtonCenter;

	CGEventRef theEvent = CGEventCreateMouseEvent(NULL, mouseType, currLoc, mb);

	if (clickType) {
		CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, clickType);
	}

	CGEventPost(kCGHIDEventTap, theEvent);
	CFRelease(theEvent);
}


//void mouseMoveToPtMK(CGPoint xy) {

/* KEYBOARD INPUT */
/*
void typeString(char *str) {
	Ascii2KeyCodeTable ttable;
	InitAscii2KeyCodeTable(&ttable);

	int i;
	char chr;
	for (i = 0; i < strlen(str); i++) {
		chr = str[i];
		UInt32 kc = AsciiToKeyCode(&ttable, (int)chr);

		// if the kc doesn't match the char when we convert it back, assume Shift
		CGEventFlags flags = NULL;
		if (KeyCodeToAscii(kc) != chr) {
			flags = kCGEventFlagMaskShift;
		}
		keyHit((CGKeyCode)kc, flags);
	}
}

void keyHit(CGKeyCode kc, CGEventFlags flags) {
	keyPress(kc, flags);
	usleep(TYPOMATIC_RATE);
	keyRelease(kc, flags);
}

void keyPress(CGKeyCode kc, CGEventFlags flags) {
	toKey(kc, flags, true);
}

void keyRelease(CGKeyCode kc, CGEventFlags flags) {
	toKey(kc, flags, false);
}

void toKey(CGKeyCode kc, CGEventFlags flags, bool upOrDown) {
	CGEventRef theEvent = CGEventCreateKeyboardEvent(NULL, kc, upOrDown);
	if (flags) {
		CGEventSetFlags(theEvent, flags);
	}
	CGEventPost(kCGAnnotatedSessionEventTap, theEvent);
	CFRelease(theEvent);
}
*/
/*================
 * iGetKey
 *--------------*/

/**
 * initAscii2KeyCodeTable initializes the ascii to key code
 * look up table using the currently active KCHR resource. This
 * routine calls GetResource so it cannot be called at interrupt time.
 */

 /*
static OSStatus InitAscii2KeyCodeTable(Ascii2KeyCodeTable* ttable) {
	unsigned char* theCurrentKCHR, *ithKeyTable;
	short count, i, j, resID;
	Handle theKCHRRsrc;
	ResType rType;

	// set up our table to all minus ones
	for (i = 0; i < 256; i++)
		ttable->transtable[i] = -1;

	// find the current kchr resource ID
	ttable->kchrID = (short)GetScriptVariable(smCurrentScript, smScriptKeys);

	// get the current KCHR resource
	theKCHRRsrc = GetResource('KCHR', ttable->kchrID);
	if (theKCHRRsrc == NULL)
		return resNotFound;
	GetResInfo(theKCHRRsrc, &resID, &rType, ttable->KCHRname);

	// dereference the resource
	theCurrentKCHR = (unsigned char *)(*theKCHRRsrc);

	// get the count from the resource
	count = *(short*)(theCurrentKCHR + kTableCountOffset);

	// build inverse table by merging all key tables
	for (i = 0; i < count; i++) {
		ithKeyTable = theCurrentKCHR + kFirstTableOffset + (i * kTableSize);
		for (j = 0; j < kTableSize; j++) {
			if (ttable->transtable[ ithKeyTable[j] ] == -1)
				ttable->transtable[ ithKeyTable[j] ] = j;
		}
	}

	return noErr;
}
*/
/**
 * asciiToKeyCode looks up the ascii character in the key
 * code look up table and returns the virtual key code for that
 * letter. If there is no virtual key code for that letter, then
 * the value -1 will be returned.
 */
/*static short AsciiToKeyCode(Ascii2KeyCodeTable* ttable, short asciiCode) {
	if (asciiCode >= 0 && asciiCode <= 255) {
		return ttable->transtable[asciiCode];
	} else {
		return false;
	}
}

static char KeyCodeToAscii(short virtualKeyCode) {
	unsigned long state;
	long keyTrans;
	char charCode;
	Ptr kchr;
	state = 0;
	kchr = (Ptr)GetScriptVariable(smCurrentScript, smKCHRCache);
	keyTrans = KeyTranslate(kchr, virtualKeyCode, &state);
	charCode = keyTrans;
	if (!charCode) {
		charCode = (keyTrans >> 16);
	}
	return charCode;
}
*/

//kCGHIDEventTap
//Specifies that an event tap is placed at the point where HID system events enter the window server.

//kCGSessionEventTap
//Specifies that an event tap is placed at the point where HID system and remote control events enter a login session.

//kCGAnnotatedSessionEventTap
//Specifies that an event tap is placed at the point where session events have been annotated to flow to an application.

void AZPostMouseEvent(CGMouseButton button, CGEventType type, const CGPoint point) {
	CGEventRef theEvent = CGEventCreateMouseEvent(NULL, type, point, button);
	CGEventSetType(theEvent, type);
	CGEventPost(kCGHIDEventTap, theEvent);
	if (theEvent) CFRelease(theEvent);
}

void AZLeftClick(const CGPoint point)  {
	AZPostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, point);
	NSLog(@"Click!");
	AZPostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point);
	AZPostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, point);
}

void AZDragBetwixt(const CGPoint a, const CGPoint b) {
	AZPostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, a);
	AZPostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, a);
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
	AZPostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, b);
}
void AZDragBetwixtOnFancyPath(const CGPoint a, const CGPoint b) {
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
void AZClick(const CGPoint point)  {
    AZPostMouseEvent(kCGMouseButtonLeft, kCGEventMouseMoved, point);
    NSLog(@"Click!");
    AZPostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseDown, point);
    AZPostMouseEvent(kCGMouseButtonLeft, kCGEventLeftMouseUp, point);
}

void AZRightClick(const CGPoint point)
{
	AZPostMouseEvent(kCGMouseButtonRight, kCGEventMouseMoved, point);
	NSLog(@"Click Right");
	AZPostMouseEvent(kCGMouseButtonRight, kCGEventRightMouseDown, point);
	AZPostMouseEvent(kCGMouseButtonRight, kCGEventRightMouseUp, point);
}

void AZDoubleClick(CGPoint point) {
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


//@implementation AZMouserIndicator
//@synthesize indicatorImage;
/* This routine is called at app launch time when this class is unpacked from the nib.*/
/*- (void)awakeFromNib {
    self.indicatorImage = [NSImage imageInFrameworkWithFileName:@"circle2.tif"];
	[[self window] setHasShadow:NO];
	[self setFrameSize:indicatorImage.size];
}*/
/*	When it's time to draw, this routine is called. This view is inside the window, the window's opaqueness has been turned off, and the window's styleMask has been set to NSBorderlessWindowMask on creation, so this view draws the all the visible content. The first two lines below fill the view with "clear" color, so that any images drawn also define the custom shape of the window.  Furthermore, if the window's alphaValue is less than 1.0, drawing will use transparency.
 */
/*
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
}*/
/* In Interface Builder, the class for the window is set to this subclass. Overriding the initializer provides a mechanism for controlling how objects of this class are created. */
/*
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

*/
/*	 Custom windows that use the NSBorderlessWindowMask can't become key by default. Override this method so that controls in this window will be enabled.	 */
/*- (BOOL)canBecomeKeyWindow  {   return NO;  }
- (BOOL)canBecomeMainWindow {	return NO;	}
@end
*/


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
//@end

/*
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
*/
/* void processCommand(const char *cmd) {
	int tmpx, tmpy, btn;
	float tmpInterval;
	UInt32 tmpkc;
	char str[CMD_STRING_MAXLEN];

	bzero(str, CMD_STRING_MAXLEN);
	if (IS_CMD(cmd, "mouselocation")) {

		CGPoint cgLoc = mouseLoc();
		printf("%.f %.f\n", cgLoc.x, cgLoc.y);

	} else if (IS_CMD(cmd, "mousewarp ")) {

		print_msg("Warping mouse to location.");
		sscanf(cmd, "mousewarp %d %d", &tmpx, &tmpy);
		mouseMove(tmpx, tmpy);

	} else if (IS_CMD(cmd, "mousemove ")) {

		print_msg("Moving mouse.");
		sscanf(cmd, "mousemove %d %d", &tmpx, &tmpy);
		mouseMoveTo(tmpx, tmpy, 1);

	} else if (IS_CMD(cmd, "mousedown")) {

		print_msg("Pressing mouse button.");
		sscanf(cmd, "mousedown %d", &btn);
		mousePress(btn, SINGLE_CLICK);

	} else if (IS_CMD(cmd, "mouseup")) {

		print_msg("Releasing mouse button.");
		sscanf(cmd, "mouseup %d", &btn);
		mouseRelease(btn, SINGLE_CLICK);

	} else if (IS_CMD(cmd, "mouseclick")) {

		print_msg("Clicking mouse.");
		sscanf(cmd, "mouseclick %d", &btn);
		mouseClick(btn, SINGLE_CLICK);

	} else if (IS_CMD(cmd, "mousedoubleclick")) {

		print_msg("Double-clicking mouse.");
		sscanf(cmd, "mousedoubleclick %d", &btn);
		mouseClick(btn, DOUBLE_CLICK);

	} else if (IS_CMD(cmd, "mousetripleclick")) {

		print_msg("Triple-clicking mouse.");
		sscanf(cmd, "mousetripleclick %d", &btn);
		mouseClick(btn, TRIPLE_CLICK);

	} else if (IS_CMD(cmd, "mousedrag ")) {

		print_msg("Dragging mouse.");
		sscanf(cmd, "mousedrag %d %d", &tmpx, &tmpy);
		mouseDrag(LEFT_MOUSE, tmpx, tmpy);

	}
	/
	 else if (IS_CMD(cmd, "press ")) {

	 print_msg("Pressing key.");
	 sscanf(cmd, "press %x", &tmpkc);
	 keyPress((CGKeyCode)tmpkc, NULL);

	 } else if (IS_CMD(cmd, "release ")) {

	 print_msg("Releasing key.");
	 sscanf(cmd, "release %x", &tmpkc);
	 keyRelease((CGKeyCode)tmpkc, NULL);

	 } else if (IS_CMD(cmd, "hit ")) {

	 print_msg("Hitting key.");
	 sscanf(cmd, "hit %x", &tmpkc);
	 keyHit((CGKeyCode)tmpkc, NULL);

	 } else if (IS_CMD(cmd, "type ")) {

	 print_msg("Typing.");
	 strncpy(str, &cmd[5], CMD_STRING_MAXLEN);
	 typeString(str);

	 }

	 else if (IS_CMD(cmd, "wait")) {

		 print_msg("Waiting.");
		 sscanf(cmd, "wait %f", &tmpInterval);
		 usleep(1000000 * tmpInterval);

	 }	  else {

		 print_msg("I don't know what you want to do.");
		 
	 }
}
EOF */


void print_msg(const char *msg) {
	printf("%s\n", msg);
}

#define TYPOMATIC_RATE 100000
#define IS_CMD( x, y ) strncmp( x, y, strlen( y ) ) == 0
#define CMD_STRING_MAXLEN 256


void pathForArc(CGContextRef context, CGRect r, int startAngle, int arcAngle)
{
    float start, end;
    CGAffineTransform matrix;

    // Save the context's state because we are going to scale it
    CGContextSaveGState(context);

    // Create a transform to scale the context so that a radius of 1 maps to the bounds
    // of the rectangle, and transform the origin of the context to the center of
    // the bounding rectangle.
    matrix = CGAffineTransformMake(r.size.width/2, 0,
                                   0, r.size.height/2,
                                   r.origin.x + r.size.width/2,
                                   r.origin.y + r.size.height/2);

    // Apply the transform to the context
    CGContextConcatCTM(context, matrix);

    // Calculate the start and ending angles
    if (arcAngle > 0) {
        start = (90 - startAngle - arcAngle) * M_PI / 180;
        end = (90 - startAngle) * M_PI / 180;
    } else {
        start = (90 - startAngle) * M_PI / 180;
        end = (90 - startAngle - arcAngle) * M_PI / 180;
    }

    // Add the Arc to the path
    CGContextAddArc(context, 0, 0, 1, start, end, false);

    // Restore the context's state. This removes the translation and scaling
    // but leaves the path, since the path is not part of the graphics state.
    CGContextRestoreGState(context);
}
//void mouseWarp(	int posX, int posY ) 		{
//	CGPoint dest = { .x = posX, .y = posY };
//	CGWarpMouseCursorPosition(dest);
//	if (bDragging) {
//		mouseEvent(LEFT_MOUSE, MOUSE_DRAGGED, 0);
//	} else {
//		mouseEvent(NO_MOUSE_BUTTON, MOUSE_MOVED, 0);
//	}
//}

//#include <stdio.h>
//#include <string.h>
//#include <Carbon/Carbon.h>

