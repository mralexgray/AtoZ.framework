//
//  AZMouser.m
//  AtoZ
//
//  Created by Alex Gray on 7/15/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

// File:
// clickdrag.m
//
// clickdrag will drag the "mouse" from the current cursor position to
// the given coordinates.
//
// derived from:
//  http://www.macosxhints.com/article.php?story=2008051406323031
//    &
//  http://davehope.co.uk/Blog/osx-click-the-mouse-via-code/

// Compile with: 
// gcc -o clickdrag clickdrag.m -framework ApplicationServices -framework Foundation
// Usage:
// ./clickdrag -x pixels -y pixels

//int main(int argc, char *argv[]) {
//	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//	NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
//	


#import "AZMouser.h"

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
