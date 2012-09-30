
//  NSScreen+AG.m
//  AGFoundation

//  Created by Alex Gray on 6/14/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "NSScreen+AtoZ.h"

@implementation NSScreen (PointConversion)

+ (NSScreen *)currentScreenForMouseLocation
{
    NSPoint mouseLocation = [NSEvent mouseLocation];
    
    NSEnumerator *screenEnumerator = [[NSScreen screens] objectEnumerator];
    NSScreen *screen;
    while ((screen = [screenEnumerator nextObject]) && !NSMouseInRect(mouseLocation, screen.frame, NO))
        ;
    
    return screen;
}

- (NSPoint)convertPointToScreenCoordinates:(NSPoint)aPoint
{
    float normalizedX = fabs(fabs(self.frame.origin.x) - fabs(aPoint.x));
    float normalizedY = aPoint.y - self.frame.origin.y;
    
    return NSMakePoint(normalizedX, normalizedY);
}

- (NSPoint)flipPoint:(NSPoint)aPoint
{
    return NSMakePoint(aPoint.x, self.frame.size.height - aPoint.y);
}

+ (NSPoint)convertAndFlipMousePointInView:(NSView *)view {
	NSScreen *now = [NSScreen currentScreenForMouseLocation];
	NSPoint mp = mouseLoc();
	NSPoint j = [now flipPoint:[now convertToScreenFromLocalPoint:mp relativeToView:view]];
	return [view isFlipped] ? [[self mainScreen]flipPoint:j] :j;

}

+ (NSPoint)convertAndFlipEventPoint:(NSEvent*)event relativeToView:(NSView *)view {

		return [[self class] convertAndFlipMousePointInView:view];
}

- (NSPoint)convertToScreenFromLocalPoint:(NSPoint)point relativeToView:(NSView *)view {
	//	NSScreen *currentScreen = [NSScreen currentScreenForMouseLocation];
	if(self)	{
		NSPoint windowPoint = [view convertPoint:point toView:nil];
		NSPoint screenPoint = [[view window] convertBaseToScreen:windowPoint];
		NSPoint flippedScreenPoint = [self flipPoint:screenPoint];
		flippedScreenPoint.y += [self frame].origin.y;
 		return flippedScreenPoint;
	}
 	return NSZeroPoint;
}
 
- (void)moveMouseToScreenPoint:(NSPoint)point
{
	CGPoint cgPoint = NSPointToCGPoint(point);
	/* Set the interval that local hardware events may be suppressed following the posting of a Quartz event. This function sets the period of time in seconds that local hardware events may be suppressed after posting a Quartz event created with the specified event source. The default suppression interval is 0.25 seconds. */

	CGEventSourceSetLocalEventsSuppressionInterval(nil,0);
//	CGSetLocalEventsSuppressionInterval(0.0);
	CGWarpMouseCursorPosition(cgPoint);
	CGEventSourceSetLocalEventsSuppressionInterval(nil,.25);
//	CGSetLocalEventsSuppressionInterval(0.25);
}
@end