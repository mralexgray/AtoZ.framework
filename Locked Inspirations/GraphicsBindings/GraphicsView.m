//	File: GraphicsView.m
//	Abstract: View that displays a collection of graphic objects.
#import "GraphicsView.h"
#import "Graphic.h"
#import <AtoZ/AtoZ.h>


static NSString *PropertyObservationContext;
static NSString *GraphicsObservationContext;
static NSString *SelectionIndexesObservationContext;

NSString *GRAPHICS_BINDING_NAME = @"graphics";
NSString *SELECTIONINDEXES_BINDING_NAME = @"selectionIndexes";



@implementation GraphicsView

@synthesize oldGraphics, bindingInfo;


/*
 Since the view is not put on an IB palette, it's not really necessary to expose the bindings
 */
+ (void)initialize
{
	[self exposeBinding:GRAPHICS_BINDING_NAME];
	[self exposeBinding:SELECTIONINDEXES_BINDING_NAME];
}


/*
 designated initializer; set up bindingInfo dictionary
 */
- (id)initWithFrame:(NSRect)frameRect
{
	if (self = [super initWithFrame:frameRect])
	{
		bindingInfo = [NSMutableDictionary dictionary];
	}
	return self;
}


/*
 For every binding except "graphics" and "selectionIndexes" just use NSObject's default implementation. It will start observing the bound-to property. When a KVO notification is sent for the bound-to property, this object will be sent a [self setValue:theNewValue forKey:theBindingName] message, so this class just has to be KVC-compliant for a key that is the same as the binding name.  Also, NSView supports a few simple bindings of its own, and there's no reason to get in the way of those.
 */
- (void)bind:(NSString *)bindingName
	toObject:(id)observableObject
 withKeyPath:(NSString *)observableKeyPath
	 options:(NSDictionary *)options
{
	
    if ([bindingName isEqualToString:GRAPHICS_BINDING_NAME])
	{
		if (bindingInfo[GRAPHICS_BINDING_NAME] != nil)
		{
			[self unbind:GRAPHICS_BINDING_NAME];	
		}
		/*
		 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
		 */
		
		NSDictionary *bindingsData = @{NSObservedObjectKey: observableObject,
									  NSObservedKeyPathKey: [observableKeyPath copy],
									  NSOptionsKey: [options copy]};
		bindingInfo[GRAPHICS_BINDING_NAME] = bindingsData;
		
		[observableObject addObserver:self
						   forKeyPath:observableKeyPath
							  options:(NSKeyValueObservingOptionNew |
									   NSKeyValueObservingOptionOld)
							  context:&GraphicsObservationContext];
		[self startObservingGraphics:[observableObject valueForKeyPath:observableKeyPath]];
		
    }
	else
		if ([bindingName isEqualToString:SELECTIONINDEXES_BINDING_NAME])
		{
			if (bindingInfo[SELECTIONINDEXES_BINDING_NAME] != nil)
			{
				[self unbind:SELECTIONINDEXES_BINDING_NAME];	
			}
			/*
			 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
			 */
			
			NSDictionary *bindingsData = @{NSObservedObjectKey: observableObject,
										  NSObservedKeyPathKey: [observableKeyPath copy],
										  NSOptionsKey: [options copy]};
			bindingInfo[SELECTIONINDEXES_BINDING_NAME] = bindingsData;
			
			
			[observableObject addObserver:self
							   forKeyPath:observableKeyPath
								  options:0
								  context:&SelectionIndexesObservationContext];
		}
		else
		{
			[super bind:bindingName toObject:observableObject withKeyPath:observableKeyPath options:options];
		}
    [self setNeedsDisplay:YES];
}


/*
 Unbind: remove self as observer of bound-to object
 */
- (void)unbind:(NSString *)bindingName
{
	
    if ([bindingName isEqualToString:GRAPHICS_BINDING_NAME])
	{
		id graphicsContainer = [self graphicsContainer];
		NSString *graphicsKeyPath = [self graphicsKeyPath];
		
		[graphicsContainer removeObserver:self forKeyPath:graphicsKeyPath];
		[bindingInfo removeObjectForKey:GRAPHICS_BINDING_NAME];
 		[self setOldGraphics:nil];
	}
	else
		if ([bindingName isEqualToString:SELECTIONINDEXES_BINDING_NAME])
		{
			id selectionIndexesContainer = [self selectionIndexesContainer];
			NSString *selectionIndexesKeyPath = [self selectionIndexesKeyPath];
			
			[selectionIndexesContainer removeObserver:self forKeyPath:selectionIndexesKeyPath];
			[bindingInfo removeObjectForKey:SELECTIONINDEXES_BINDING_NAME];
		}
		else
		{
			[super unbind:bindingName];
		}
    [self setNeedsDisplay:YES];
}


/*
 Respond to KVO change notifications
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	
    if (context == &GraphicsObservationContext)
	{
		/*
		 Should be able to use
		 NSArray *oldGraphics = [change objectForKey:NSKeyValueChangeOldKey];
		 etc. but the dictionary doesn't contain old and new arrays.
		 */
		NSArray *newGraphics = [object valueForKeyPath:[self graphicsKeyPath]];
		
		NSMutableArray *onlyNew = [newGraphics mutableCopy];
		[onlyNew removeObjectsInArray:oldGraphics];
		[self startObservingGraphics:onlyNew];
		
		NSMutableArray *removed = [oldGraphics mutableCopy];
		[removed removeObjectsInArray:newGraphics];
		[self stopObservingGraphics:removed];
		
		[self setOldGraphics:newGraphics];
		
		// could check drawingBounds of old and new, but...
		[self setNeedsDisplay:YES];
		return;
    }
	
	if (context == &PropertyObservationContext)
	{
		/*
		 An observed object's property has changed:
		 - If it's the drawing bounds, mark the union of its old and new bounds as dirty;
		 - If it's another property, mark its drawing bounds as dirty
		*/
		NSRect updateRect;
		
		if ([keyPath isEqualToString:@"drawingBounds"])
		{
			NSRect newBounds = [change[NSKeyValueChangeNewKey] rectValue];
			NSRect oldBounds = [change[NSKeyValueChangeOldKey] rectValue];
			updateRect = NSUnionRect(newBounds,oldBounds);
		}
		else
		{
			updateRect = [(NSObject <Graphic> *)object drawingBounds];
		}
		updateRect = NSMakeRect(updateRect.origin.x-1.0,
								updateRect.origin.y-1.0,
								updateRect.size.width+2.0,
								updateRect.size.height+2.0);
		[self setNeedsDisplayInRect:updateRect];
		return;
	}
	
	if (context == &SelectionIndexesObservationContext)
	{
		[self setNeedsDisplay:YES];
		return;
	}
}



/*
 Register to observe each of the new graphics, and each of their observable properties -- we need old and new values for drawingBounds to figure out what our dirty rect
 */	
- (void)startObservingGraphics:(NSArray *)graphics
{
	if ([graphics isEqual:[NSNull null]])
	{
		return;
	}
	
	/*
	 Declare newGraphic as NSObject * to get key value observing methods
	 Add Graphic protocol for drawing
	 */
    for (NSObject <Graphic> *newGraphic in graphics)
	{
		[newGraphic addObserver:self
					 forKeyPath:GraphicDrawingBoundsKey
						options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
						context:&PropertyObservationContext];
		
		[newGraphic addObserver:self
					 forKeyPath:GraphicDrawingContentsKey
						options:0
						context:&PropertyObservationContext];
	}
}


- (void)stopObservingGraphics:(NSArray *)graphics
{
	if ([graphics isEqual:[NSNull null]])
	{
		return;
	}
	
    for (id oldGraphic in graphics)
	{
		[oldGraphic removeObserver:self forKeyPath:GraphicDrawingBoundsKey];
		[oldGraphic removeObserver:self forKeyPath:GraphicDrawingContentsKey];
	}
}



/*
 Draw content
 */
- (void)drawRect:(NSRect)rect
{
	NSRect myBounds = [self bounds];
	NSDrawLightBezel(myBounds,myBounds);
	
	NSBezierPath *clipRect =
	[NSBezierPath bezierPathWithRect:NSInsetRect(myBounds,2.0,2.0)];
	[clipRect addClip];
	
	/*
	 Draw graphics
	 */
	NSArray *graphicsArray = self.graphics;
	NSObject <Graphic> *graphic;
    for (graphic in graphicsArray)
	{
        NSRect graphicDrawingBounds = [graphic drawingBounds];
        if (NSIntersectsRect(rect, graphicDrawingBounds))
		{
			[graphic drawInView:self];
        }
    }
	
	/*
	 Draw a red box around items in the current selection.
	 Selection should be handled by the graphic, but this is a shortcut simply for display.
	 */
	NSIndexSet *currentSelectionIndexes = [self selectionIndexes];
	if (currentSelectionIndexes != nil)
	{
		NSBezierPath *path = [NSBezierPath bezierPath];
		unsigned int index = [currentSelectionIndexes firstIndex];
		while (index != NSNotFound)
		{
			graphic = graphicsArray[index];
			NSRect graphicDrawingBounds = [graphic drawingBounds];
			if (NSIntersectsRect(rect, graphicDrawingBounds))
			{
				[path appendBezierPathWithRect:graphicDrawingBounds];
			}
			index = [currentSelectionIndexes indexGreaterThanIndex:index];
		}
		[[NSColor redColor] set];
		[path setLineWidth:1.0];
		[path stroke];
	}
}


/*
 Simple mouseDown: method; the most important aspect is updating the selection indexes
 */
- (void)mouseDown:(NSEvent *)event
{
	
	// find out if we hit anything
	NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];
	NSEnumerator *gEnum = [[self graphics] reverseObjectEnumerator];
	id aGraphic;
	for (aGraphic in gEnum)
    {
		if ([aGraphic hitTest:p isSelected:NO])
		{
			break;
		}
	}
	
	/*
	 if no graphic hit, then if extending selection do nothing else set selection to nil
	 */
	if (aGraphic == nil)
	{
		if (!([event modifierFlags] & NSShiftKeyMask))
		{
			[[self selectionIndexesContainer] setValue:nil forKeyPath:[self selectionIndexesKeyPath]];
		}
		return;
	}
	
	/*
	 graphic hit
	 if not extending selection (Shift key down) then set selection to this graphic
	 if extending selection, then:
	 - if graphic in selection remove it
	 - if not in selection add it
	 */
	NSIndexSet *selection = nil;
	unsigned int graphicIndex = [[self graphics] indexOfObject:aGraphic];
	
	if (!([event modifierFlags] & NSShiftKeyMask))
	{
		selection = [NSIndexSet indexSetWithIndex:graphicIndex];
	}
	else
	{
		if ([[self selectionIndexes] containsIndex:graphicIndex])
		{
			selection = [[self selectionIndexes] mutableCopy];
			[(NSMutableIndexSet *)selection removeIndex:graphicIndex];
		}
		else
		{
			selection = [[self selectionIndexes] mutableCopy];
			[(NSMutableIndexSet *)selection addIndex:graphicIndex];
		}
	}
	[[self selectionIndexesContainer] setValue:selection forKeyPath:[self selectionIndexesKeyPath]];
}



/*
 If view is moved to another superview, unbind all bindings
 */
- (void)viewWillMoveToSuperview:(NSView *)newSuperview
{
	[super viewWillMoveToSuperview:newSuperview];
	if (newSuperview == nil)
	{
		[self stopObservingGraphics:[self graphics]];
		[self unbind:GRAPHICS_BINDING_NAME];
		[self unbind:SELECTIONINDEXES_BINDING_NAME];
	}
}




/*
 Convenience methods to retrieve values from the binding info dictionary
 */

- (NSDictionary *)infoForBinding:(NSString *)bindingName
{
	/*
	 Retrieve from the binding info dictionary the value for the given binding name
	 If there's no value for our info dictionary, get it from super.
	 */
	NSDictionary *info = bindingInfo[bindingName];
	if (info == nil)
	{
		info = [super infoForBinding:bindingName];
	}
	return info;
}

- (id)graphicsContainer
{
	return [self infoForBinding:GRAPHICS_BINDING_NAME][NSObservedObjectKey];
}

- (NSString *)graphicsKeyPath
{
	return [self infoForBinding:GRAPHICS_BINDING_NAME][NSObservedKeyPathKey];
}

- (id)selectionIndexesContainer
{
	return [self infoForBinding:SELECTIONINDEXES_BINDING_NAME][NSObservedObjectKey];
}

- (NSString *)selectionIndexesKeyPath
{
	return [self infoForBinding:SELECTIONINDEXES_BINDING_NAME][NSObservedKeyPathKey];
}

- (NSArray *)graphics
{	
    return [[self graphicsContainer] valueForKeyPath:[self graphicsKeyPath]];	
}

- (NSIndexSet *)selectionIndexes
{
	return [[self selectionIndexesContainer] valueForKeyPath:[self selectionIndexesKeyPath]];
}


@end

