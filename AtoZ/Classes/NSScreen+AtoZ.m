
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


+ (NSPoint)convertAndFlipEventPoint:(NSEvent*)event relativeToView:(NSView *)view {
	NSScreen *now = [NSScreen currentScreenForMouseLocation];
	return [now flipPoint:[now convertToScreenFromLocalPoint:event.locationInWindow relativeToView:view]];

//	return [[[self class] mainScreen] flipPoint:touchPoint];
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
 
	CGSetLocalEventsSuppressionInterval(0.0);
	CGWarpMouseCursorPosition(cgPoint);
	CGSetLocalEventsSuppressionInterval(0.25);
}
@end