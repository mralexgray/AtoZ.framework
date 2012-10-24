/*
 
 File: Circle.m
 
 Abstract: Class that represents a circle object.
 
 Version: 2.0
 

 */

#import "Circle.h"

@implementation Circle

@synthesize xLoc, yLoc, shadowAngle, shadowOffset, radius, color;



/*
 Set up use of the KVO dependency mechanism for the receiving class.
 The use of +keysForValuesAffectingDrawingBounds and +keysForValuesAffectingDrawingContents allows subclasses to easily customize this when they define new properties that affect how they draw.
 */
+ (void)initialize
{
    // This method gets invoked for every subclass of Circle that's instantiated. That's a good thing, in this case. In most other cases it means you have to check self to protect against redundant invocations.
    	
	NSArray *boundsChangingKeys = [[self keysForValuesAffectingDrawingBounds] allObjects];
	[self setKeys:boundsChangingKeys triggerChangeNotificationsForDependentKey:@"drawingBounds"];
	[self setKeys:[[self keysForValuesAffectingDrawingContents] allObjects] triggerChangeNotificationsForDependentKey:@"drawingContents"];
	
}


/*
 Returns a set of the  properties managed by Circle that affect the drawing bounds.
 */
+ (NSSet *)keysForValuesAffectingDrawingBounds
{    
	static NSSet *keysForValuesAffectingDrawingBounds = nil;
	if (!keysForValuesAffectingDrawingBounds)
	{
		keysForValuesAffectingDrawingBounds =
		[[NSSet alloc] initWithObjects:
		 @"xLoc", @"yLoc", @"shadowOffset", @"shadowAngle", @"radius", nil];
	}
    return keysForValuesAffectingDrawingBounds;
}


/*
 Returns a set of the  properties managed by Circle that affect the drawing contents.
 */
+ (NSSet *)keysForValuesAffectingDrawingContents
{    
	static NSSet *keysForValuesAffectingDrawingContents = nil;
	if (!keysForValuesAffectingDrawingContents)
	{
		keysForValuesAffectingDrawingContents =
		[[NSSet alloc] initWithObjects:
		 @"xLoc", @"yLoc", @"shadowOffset", @"shadowAngle", @"color", @"radius", nil];
	}
	return keysForValuesAffectingDrawingContents;
}


/*
 Returns the rectangle that encompasses the shape and any associated shadow
 */
- (NSRect)drawingBounds
{
	float shadowAngleRadians = shadowAngle * (3.141592654/180.0);
	float shadowXOffset = sin(shadowAngleRadians)*shadowOffset * 2.0; // allow for blur
	float shadowYOffset = cos(shadowAngleRadians)*shadowOffset * 2.0;
	
	NSRect circleBounds = NSMakeRect(xLoc-radius, yLoc-radius,
									 radius*2, radius*2);
	NSRect shadowBounds =
	NSOffsetRect(circleBounds, shadowXOffset, shadowYOffset);
	
	return NSUnionRect(shadowBounds, circleBounds);
}


/*
 Draw the circle and any assoiated shadow
 */
-(void)drawInView:(NSView *)aView
{
	// ignore aView here for simplicity...
	
	NSRect circleBounds = 
	NSMakeRect(xLoc-radius, yLoc-radius, radius*2, radius*2);
	NSBezierPath *circle;
	NSShadow *shadow = nil;
	
	// draw shadow if we'll see it
	if (shadowOffset > 0.00001)
	{
		float shadowAngleRadians = shadowAngle * (3.141592654/180.0);
		
		float shadowXOffset = sin(shadowAngleRadians) * shadowOffset; 
		float shadowYOffset = cos(shadowAngleRadians) * shadowOffset;
		shadow = [[NSShadow alloc] init];
		[shadow setShadowOffset:(NSMakeSize(shadowXOffset, shadowYOffset))];
		[shadow setShadowBlurRadius:shadowOffset];
		[shadow set];
	}
	
	// draw circle
	circle = [NSBezierPath bezierPathWithOvalInRect:circleBounds];
	NSColor *myColor = self.color;
	if (myColor == nil)
	{
		myColor = [NSColor redColor];
	}
	[myColor set];
	[circle fill];
	
	[shadow setShadowColor:nil];
	[shadow set];
}


/*
 Determine whether a given point is within the bounds of the circle
 */
- (BOOL)hitTest:(NSPoint)point isSelected:(BOOL)isSelected
{
	// ignore isSelected here for simplicity...
	// don't count shadow for selection
	NSRect circleBounds = NSMakeRect(xLoc-radius, yLoc-radius, radius*2, radius*2);
	NSBezierPath *circle = [NSBezierPath bezierPathWithOvalInRect:circleBounds];
	
	return [circle containsPoint:point];
}


/*
 Set up some default values
 */
- init
{
	if (self = [super init])
	{
		self.color = [NSColor redColor];
		self.xLoc = 15.0;
		self.yLoc = 15.0;
		self.radius = 15.0;
	}
	return self;
}


@end

