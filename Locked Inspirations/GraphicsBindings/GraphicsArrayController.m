/*
 
 File: GraphicsArrayController.m
 
 Abstract: Array controller to customize creation of new objects and filter using color.
 
 Version: 2.0
 

 */

#import "GraphicsArrayController.h"
#import "Circle.h"

@implementation GraphicsArrayController

@synthesize shouldFilter;
@synthesize filterColor, circle;//, graphicsView;



/*
 Allow filtering by color, just for the fun of it
 */
- (NSArray *)arrangeObjects:(NSArray *)objects
{
	if (!shouldFilter)
	{
		return [super arrangeObjects:objects];
	}
	
	float filterHue = [filterColor hueComponent];
	NSMutableArray *filteredObjects = [NSMutableArray arrayWithCapacity:[objects count]];
	
	/*
	 From the input array of objects, create an array of those whose hue is within a
	 few degrees of the hue of the filter color.
	 Always also include any newly-created item so the user sees it.
	*/
	for (id item in objects)
	{
		float hue = [[item color] hueComponent];
		if ((fabs(hue - filterHue) < 0.05) ||
			(fabs(hue - filterHue) > 0.95) ||
			(item == circle))
		{
			[filteredObjects addObject:item];
			circle = nil;
		}
	}
	return [super arrangeObjects:filteredObjects];
}



/*
 Randomize attributes of new circles so we get a pretty display
 */
- newObject
{	
	/*
	 Keep track of newCircle:
	 We want to make sure that it's always displayed when created, even if
	 it should be filtered out on the basis of the hue filter (see arrangeObjects:).
	*/
	circle = (Circle *)[super newObject];
	
	float radius = 5.0 + 15.0 * random() / LONG_MAX;
	circle.radius = radius;


	float height = [graphicsView bounds].size.height;
	float width = [graphicsView bounds].size.width;
	
	float xOffset = 10.0 + (height - 20.0) * random() / LONG_MAX;
	float yOffset = 10.0 + (width - 20.0) * random() / LONG_MAX;
	
	circle.xLoc = xOffset;
	circle.yLoc = height - yOffset;

	NSColor *color = [NSColor colorWithCalibratedHue:random() / (LONG_MAX-1.0)
										  saturation:(0.5 + (random() / (LONG_MAX-1.0)) / 2.0)
										  brightness:(0.333 + (random() / (LONG_MAX-1.0)) / 3.0)
											   alpha:1.0];
	circle.color = color;
	
	return circle;
}


+ (void)initialize
{
	srandom([[NSDate date] timeIntervalSince1970]);
}


/*
 Implement set accessor methods to rearrange content if necessary
 */
- (void)setFilterColor:(NSColor *)aFilterColor
{
    if (filterColor != aFilterColor)
	{
        filterColor = aFilterColor;
		[self rearrangeObjects];
    }
}

- (void)setShouldFilter:(BOOL)flag
{
    if (shouldFilter != flag)
	{
		shouldFilter = flag;
		[self rearrangeObjects];
    }
}


@end


