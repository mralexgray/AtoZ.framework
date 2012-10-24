/*
 
 File: GraphicsArrayController.h
 
 Abstract: Array controller to customize creation of new objects and filter using color.
 
 Version: 2.0
 

 */

#import <Cocoa/Cocoa.h>

@class Circle;

@interface GraphicsArrayController : NSArrayController
{
	// we only need to reference the graphicsView for newObject to place circles within its bounds
IBOutlet NSView *graphicsView;
//	IBOutlet NSView *graphicsView;
//NSColor *filterColor;
//	BOOL shouldFilter;

}
@property (nonatomic, retain) Circle *circle;
//@property (nonatomic, assign) IBOutlet NSView *graphicsView;
@property (nonatomic, assign) BOOL shouldFilter;
@property (nonatomic, copy) NSColor *filterColor;


@end

