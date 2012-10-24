/*
 
 File: MyDocument.m
 
 Abstract: Class that represents a document.
 
 Version: 2.0
 

 */

#import "MyDocument.h"

#import "GraphicsView.h"
#import "JoystickView.h"

@implementation MyDocument
@synthesize  graphicsController, graphicsView, shadowInspector;

@synthesize graphics;
- (id)init
{
    if (self = [super init])
	{
		graphics = [NSMutableArray new];
    }
    return self;
}
- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
	
	// we can't do these in IB at the moment, as we don't have palette items for them
	[graphicsView bind: @"graphics" 		toObject: graphicsController withKeyPath:@"arrangedObjects" options:nil];
	[graphicsView bind: @"selectionIndexes" toObject: graphicsController withKeyPath:@"selectionIndexes" options:nil];
	
	
	// allow the shadow inspector (joystick) to handle multiple selections
	NSDictionary *options =
		@{@"NSAllowsEditingMultipleValuesSelection": @(YES)};
	
	[shadowInspector bind: @"angle" toObject: graphicsController
			  withKeyPath:@"selection.shadowAngle" options:options];
	[shadowInspector bind: @"offset" toObject: graphicsController
			  withKeyPath:@"selection.shadowOffset" options:options];
	
	// "fake" what should be set in IB if we had a palette...
	[shadowInspector setMaxOffset:15];
}


- (NSString *)windowNibName{return @"MyDocument";}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{
    return [NSKeyedArchiver archivedDataWithRootObject:graphics];
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
	[self setGraphics:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
    return YES;
}


/*
 Accessors for the graphics array
 Impement a set accessor to make a mutable copy.
 */

- (void)setGraphics:(NSMutableArray *)aGraphics
{
    if (graphics != aGraphics) {
        graphics = [aGraphics mutableCopy];
    }
}

- (unsigned int)countOfGraphics 
{
    return [graphics count];
}

- (id)objectInGraphicsAtIndex:(unsigned int)index 
{
    return graphics[index];
}

- (void)insertObject:(id)anObject inGraphicsAtIndex:(unsigned int)index 
{
    [graphics insertObject:anObject atIndex:index];
}

- (void)removeObjectFromGraphicsAtIndex:(unsigned int)index 
{
    [graphics removeObjectAtIndex:index];
}

- (void)replaceObjectInGraphicsAtIndex:(unsigned int)index withObject:(id)anObject 
{
    graphics[index] = anObject;
}


@end

