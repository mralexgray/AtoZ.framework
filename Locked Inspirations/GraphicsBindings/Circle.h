/*
 
 File: Circle.h
 
 Abstract: Class that represents a circle object.
 
 Version: 2.0
 

 */

#import <Foundation/Foundation.h>
#import "Graphic.h"


/*
 Circle class, adopts Graphic protocol
 Adds radius and color, and support for drawing a shadow
 */

@interface Circle : NSObject <Graphic>
{
	CGFloat xLoc;
	CGFloat yLoc;
	
	CGFloat radius;
	NSColor *color;
	CGFloat shadowOffset;
	CGFloat shadowAngle;
}

@property CGFloat radius;
@property CGFloat shadowOffset;
@property CGFloat shadowAngle;

@property (copy) NSColor *color;

@end

