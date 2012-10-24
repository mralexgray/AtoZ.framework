/*
 
 File: JoystickView.m
 
 Abstract: View that represents a joystick allowing angle and offset to be manipulated graphically.
 
 This class may be used with garbage collection or in a managed memory environment.
 Memory management methods (retain, release, autorelease) are include where necessary,
 and a dealloc method provided.  These are no-ops/not used under garbage collection.
 
 Version: 2.0
 
 
 */


static void *AngleObservationContext = (void *)2091;
static void *OffsetObservationContext = (void *)2092;


#define ANGLE_BINDING_NAME @"angle"
#define OFFSET_BINDING_NAME @"offset"



#import "JoystickView.h"

@implementation JoystickView


@synthesize offset, badSelectionForAngle, badSelectionForOffset;
@synthesize angle, allowsMultipleSelectionForAngle, allowsMultipleSelectionForOffset, angleValueTransformerName;
@synthesize maxOffset, multipleSelectionForAngle, mouseDown, multipleSelectionForOffset, bindingInfo;


- (id)initWithFrame:(NSRect)frameRect
{
	if (self = [super initWithFrame:frameRect])
	{
		maxOffset = 15.0;
		offset = 0.0;
		angle = 28.0;
		multipleSelectionForAngle = NO;
		multipleSelectionForOffset = NO;
		
		bindingInfo = [[NSMutableDictionary alloc] init];
	}
	return self;
}


- (void)bind:(NSString *)bindingName
	toObject:(id)observableController
 withKeyPath:(NSString *)keyPath
	 options:(NSDictionary *)options
{	
	if ([bindingName isEqualToString:ANGLE_BINDING_NAME])
	{
		if (bindingInfo[ANGLE_BINDING_NAME] != nil) {
			[self unbind:ANGLE_BINDING_NAME];	
		}
		/*
		 observe the controller for changes -- note, pass binding identifier as the context, so we get that back in observeValueForKeyPath:... -- that way we can determine what needs to be updated
		 */
		[observableController addObserver:self
							   forKeyPath:keyPath 
								  options:0
								  context:AngleObservationContext];
		
		NSDictionary *bindingsData = @{NSObservedObjectKey: observableController,
									  NSObservedKeyPathKey: [keyPath copy],
									  NSOptionsKey: [options copy]};
		bindingInfo[ANGLE_BINDING_NAME] = bindingsData;
	}
	else
	{
		if ([bindingName isEqualToString:OFFSET_BINDING_NAME])
		{
			if (bindingInfo[OFFSET_BINDING_NAME] != nil) {
				[self unbind:OFFSET_BINDING_NAME];	
			}
			[observableController addObserver:self
								   forKeyPath:keyPath 
									  options:0
									  context:OffsetObservationContext];
			
			NSDictionary *bindingsData = @{NSObservedObjectKey: observableController,
										  NSObservedKeyPathKey: [keyPath copy],
										  NSOptionsKey: [options copy]};
			bindingInfo[OFFSET_BINDING_NAME] = bindingsData;
		}
		else
		{
			[super bind:bindingName
			   toObject:observableController
			withKeyPath:keyPath
				options:options];
		}
	}
	[self setNeedsDisplay:YES];
}



- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	/*
	 we passed a context when we added ourselves as an observer -- use that to decide what to update... should ask the dictionary for the value...
	 */
	if (context == AngleObservationContext)
	{
		// angle changed
		/*
		 if we got a NSNoSelectionMarker or NSNotApplicableMarker, or if we got a NSMultipleValuesMarker and we don't allow multiple selections then note we have a bad angle
		 */
		id newAngle = [object valueForKeyPath:keyPath];
		
		if ((newAngle == NSNoSelectionMarker) || (newAngle == NSNotApplicableMarker)
			|| ((newAngle == NSMultipleValuesMarker) && ![self allowsMultipleSelectionForAngle]))
		{
			badSelectionForAngle = YES;
		}
		else
		{
			/*
			 note we have a good selection
			 if we got a NSMultipleValuesMarker, note it but don't update value
			 */
			badSelectionForAngle = NO;
			if (newAngle == NSMultipleValuesMarker)
			{
				multipleSelectionForAngle = YES;
			}
			else
			{
				multipleSelectionForAngle = NO;
				
				NSString *angleValueTransformerName = [self angleValueTransformerName];
				
				if (angleValueTransformerName != nil)
				{
					NSValueTransformer *valueTransformer =
					[NSValueTransformer valueTransformerForName:angleValueTransformerName];
					newAngle = [valueTransformer transformedValue:newAngle]; 
				}	
				[self setValue:newAngle forKey:ANGLE_BINDING_NAME];
			}
		}
	}
	if (context == OffsetObservationContext)
	{
		// offset changed
		/*
		 if we got a NSNoSelectionMarker or NSNotApplicableMarker, or if we got a NSMultipleValuesMarker and we don't allow multiple selections then note we have a bad selection
		 */
		id newOffset = [object valueForKeyPath:keyPath];
		
		if ((newOffset == NSNoSelectionMarker) || (newOffset == NSNotApplicableMarker)
			|| ((newOffset == NSMultipleValuesMarker) && ![self allowsMultipleSelectionForOffset]))
		{
			badSelectionForOffset = YES;
		}
		else
		{
			/*
			 note we have a good selection
			 
			 if we got a NSMultipleValuesMarker, note it but don't update value
			 */
			badSelectionForOffset = NO;
			if (newOffset == NSMultipleValuesMarker)
			{
				multipleSelectionForOffset = YES;
			}
			else
			{
				[self setValue:newOffset forKey:OFFSET_BINDING_NAME];
				multipleSelectionForOffset = NO;
			}
		}
	}
	[self setNeedsDisplay:YES];
}


- (void)unbind:bindingName
{
	if ([bindingName isEqualToString:ANGLE_BINDING_NAME])
	{
		id observedObjectForAngle = [self observedObjectForAngle];
		NSString *observedKeyPathForAngle = [self observedKeyPathForAngle];
		
		[observedObjectForAngle removeObserver:self forKeyPath:observedKeyPathForAngle];
		[bindingInfo removeObjectForKey:ANGLE_BINDING_NAME];
	}
	else
	{
		if ([bindingName isEqualToString:OFFSET_BINDING_NAME])
		{
			id observedObjectForOffset = [self observedObjectForOffset];
			NSString *observedKeyPathForOffset = [self observedKeyPathForOffset];
			
			[observedObjectForOffset removeObserver:self forKeyPath:observedKeyPathForOffset];
			[bindingInfo removeObjectForKey:OFFSET_BINDING_NAME];
		}
		else
		{
			[super unbind:bindingName];	
		}
	}
	[self setNeedsDisplay:YES];
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

/*
 Convenience methods to retrieve values from the binding info dictionary
 */
- (id)observedObjectForAngle
{
	return [self infoForBinding:ANGLE_BINDING_NAME][NSObservedObjectKey];
}

- (NSString *)observedKeyPathForAngle
{
	return [self infoForBinding:ANGLE_BINDING_NAME][NSObservedKeyPathKey];
}


- (id)observedObjectForOffset
{
	return [self infoForBinding:OFFSET_BINDING_NAME][NSObservedObjectKey];
}

- (NSString *)observedKeyPathForOffset
{
	return [self infoForBinding:OFFSET_BINDING_NAME][NSObservedKeyPathKey];
}


- (NSString *)angleValueTransformerName
{
	NSDictionary *infoDictionary = [self infoForBinding:ANGLE_BINDING_NAME];
	NSDictionary *optionsDictionary = infoDictionary[NSOptionsKey];
	id name = optionsDictionary[NSValueTransformerNameBindingOption];
	if ((name == [NSNull null]) || (name == nil))
	{
		return nil;
	}
	return (NSString *)name;
}


- (BOOL)allowsMultipleSelectionForAngle
{
	NSDictionary *options = [self infoForBinding:ANGLE_BINDING_NAME][NSOptionsKey];
	NSNumber *allows = options[NSAllowsEditingMultipleValuesSelectionBindingOption];
	return [allows boolValue];
}

- (BOOL)allowsMultipleSelectionForOffset
{
	NSDictionary *options = [self infoForBinding:OFFSET_BINDING_NAME][NSOptionsKey];
	NSNumber *allows = options[NSAllowsEditingMultipleValuesSelectionBindingOption];
	return [allows boolValue];
}





-(void)updateForMouseEvent:(NSEvent *)event
{
	/*
	 update based on event location and selection state behavior based on modifier key
	 */
	if (badSelectionForAngle || badSelectionForOffset)
	{
		// don't do anything
		return;
	}
	
	// find out where the event is, offset from the view center
	
	NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];	
	
	NSRect myBounds = [self bounds];	
	float xOffset = (p.x - (myBounds.size.width/2));
	float yOffset = (p.y - (myBounds.size.height/2));
	
	float newOffset = sqrt(xOffset*xOffset + yOffset*yOffset);
	if (newOffset > maxOffset)
	{
		newOffset = maxOffset;
	}
	else 
	{
		if (newOffset < -maxOffset)
		{ 
			newOffset = -maxOffset;
		}
	}
	
	/*
	 if we have a multiple selection for offset and Shift key is pressed then don't update the offset -- this allows offsets to remain constant, but change angle
	 */
	if (!(multipleSelectionForOffset &&
		  ([event modifierFlags] & NSShiftKeyMask)))
	{
		[self setOffset:newOffset];
		
		id observedObjectForOffset = [self observedObjectForOffset];
		// update observed controller if set
		if (observedObjectForOffset != nil)
		{
			NSString *observedKeyPathForOffset = [self observedKeyPathForOffset];
			
			[observedObjectForOffset setValue: @(newOffset)
								   forKeyPath: observedKeyPathForOffset];
		}	
	}
	
	/*
	 if we have a multiple selection for angle and Shift key is pressed then don't update the angle this allows angles to remain constant, but change offset
	 */
	
	if (!(multipleSelectionForAngle &&
		  ([event modifierFlags] & NSShiftKeyMask)))
	{
		float newAngle = atan2(xOffset, yOffset);
		
		float newAngleDegrees = newAngle / (3.1415927/180.0);
		if (newAngleDegrees < 0)
		{
			newAngleDegrees += 360;	
		}
		[self setAngle:newAngleDegrees];
		
		if (fabs(newAngle - angle) > 0.00001)
		{
			
			id observedObjectForAngle = [self observedObjectForAngle];
			
			// update observed controller if set
			if (observedObjectForAngle != nil)
			{
				NSNumber *newControllerAngle = nil;
				
				NSString *angleValueTransformerName = [self angleValueTransformerName];
				
				if (angleValueTransformerName != nil)
				{
					NSValueTransformer *valueTransformer =
					[NSValueTransformer valueTransformerForName:angleValueTransformerName];
					newControllerAngle = (NSNumber *)[valueTransformer reverseTransformedValue:
													  @(newAngleDegrees)]; 
				}
				else
				{
					newControllerAngle = @(angle);
				}
				
				NSString *observedKeyPathForAngle = [self observedKeyPathForAngle];
				
				[observedObjectForAngle setValue: newControllerAngle
									  forKeyPath: observedKeyPathForAngle];
			}
		}
	}
	
	[self setNeedsDisplay:YES];
}


-(void)mouseDown:(NSEvent *)event
{
	mouseDown = YES;
	[self updateForMouseEvent:event];
}
-(void)mouseDragged:(NSEvent *)event
{
	[self updateForMouseEvent:event];
}
-(void)mouseUp:(NSEvent *)event
{
	mouseDown = NO;
	[self updateForMouseEvent:event];
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;
}
- (BOOL)acceptsFirstResponder
{
	return YES;
}


- (void)drawRect:(NSRect)rect
{
	/*
	 Basic goals:
	 If either the angle or the offset has a "bad selection", then draw a gray rectangle, and that's it.
	 Note: bad selection is set if there's a multiple selection but the "allows multiple selection" binding is NO.
	 
	 If there's a multiple selection for either angle or offset: then what you draw depends on what's multiple.
	 
	 - First, draw a white background to show all's OK.
	 
	 - If both are multiple, then draw a special symbol.
	 
	 - If offset is multiple, draw a line from the center of the view to the edge at the shared angle.
	 
	 - If angle is multiple, draw a circle of radius the shared offset centered in the view.
	 
	 If neither is multiple, draw a cross at the center of the view and a cross at distance 'offset' from the center at angle 'angle'
	 
	 */
	NSRect myBounds = [self bounds];	
	
	if (badSelectionForAngle || badSelectionForOffset)
	{
		// "disable" and exit
		NSDrawDarkBezel(myBounds,myBounds);
		return;
	}
	
	/*
	 user can do something, so draw white background and clip in anticipation of future drawing
	 */
	NSDrawLightBezel(myBounds,myBounds);
	
	NSBezierPath *clipRect =
	[NSBezierPath bezierPathWithRect:NSInsetRect(myBounds,2.0,2.0)];
	[clipRect addClip];
	
	if (multipleSelectionForAngle || multipleSelectionForOffset)
	{
		
		float originOffsetX = myBounds.size.width/2 + 0.5;
		float originOffsetY = myBounds.size.height/2 + 0.5;
		
		if (multipleSelectionForAngle && multipleSelectionForOffset)
		{
			/*
			 draw a diagonal line and circle to denote multiple selections for angle and offset
			 */
			[NSBezierPath strokeLineFromPoint:NSMakePoint(0, 0)
									  toPoint:NSMakePoint(myBounds.size.width, myBounds.size.height)];
			NSRect circleBounds = NSMakeRect(originOffsetX-5,
											 originOffsetY-5,
											 10, 10);
			NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:circleBounds];
			[path stroke];
			return;
		}
		
		
		if (multipleSelectionForOffset)
		{
			/*
			 draw a line from center to a point outside bounds in the direction specified by angle
			 */
			float angleRadians = angle * (3.1415927/180.0);
			float x = sin(angleRadians) * myBounds.size.width + originOffsetX;
			float y = cos(angleRadians) * myBounds.size.height + originOffsetX;
			[NSBezierPath strokeLineFromPoint:NSMakePoint(originOffsetX, originOffsetY)
									  toPoint:NSMakePoint(x, y)];
			return;
		}
		
		// 
		if (multipleSelectionForAngle)
		{
			/*
			 draw a circle with radius the shared offset don't draw radius < 1.0, else invisible
			 */
			float drawRadius = offset;
			if (drawRadius < 1.0) { drawRadius = 1.0; }
			NSRect offsetBounds = NSMakeRect(originOffsetX-drawRadius,
											 originOffsetY-drawRadius,
											 drawRadius*2, drawRadius*2);
			NSBezierPath *path = [NSBezierPath bezierPathWithOvalInRect:offsetBounds];
			[path stroke];
			return;
		}
		// shouldn't get here
		return;
	}
	
	NSAffineTransform *transform = [NSAffineTransform transform];
	[transform translateXBy:(myBounds.size.width/2 + 0.5)
						yBy:(myBounds.size.height/2 + 0.5)];
	[transform concat];
	
	NSBezierPath *path = [NSBezierPath bezierPath];
	
	// draw + where shadow extends
	float angleRadians = angle * (3.1415927/180.0);
	
	float xOffset = sin(angleRadians) * offset;
	float yOffset = cos(angleRadians) * offset;	
	
	[path moveToPoint:NSMakePoint(xOffset,yOffset-5)];
	[path lineToPoint:NSMakePoint(xOffset,yOffset+5)];
	[path moveToPoint:NSMakePoint(xOffset-5,yOffset)];
	[path lineToPoint:NSMakePoint(xOffset+5,yOffset)];
	
	[[NSColor lightGrayColor] set];
	[path setLineWidth:1.5];
	[path stroke];
	
	
	// draw + in center of view
	path = [NSBezierPath bezierPath];
	
	[path moveToPoint:NSMakePoint(0,-5)];
	[path lineToPoint:NSMakePoint(0,5)];
	[path moveToPoint:NSMakePoint(-5,0)];
	[path lineToPoint:NSMakePoint(5,0)];
	
	[[NSColor blackColor] set];
	[path setLineWidth:1.0];
	[path stroke];
}


- (void)setNilValueForKey:(NSString *)key
{
	/*
	 We may get passed nil for angle or offset; Just use 0
	 */
	[self setValue:[NSDecimalNumber zero] forKey:key];	
}



-(BOOL)validateMaxOffset:(id *)ioValue error:(NSError **)outError

{
	if (*ioValue == nil)
	{
		/*
		 trap this in setNilValueForKey
		 alternative might be to create new NSNumber with value 0 here
		 */
		return YES;
	}
	
	if ([*ioValue floatValue] <= 0.0)
	{
		NSString *errorString =
		NSLocalizedStringFromTable(@"Maximum Offset must be greater than zero",
								   @"Joystick",
								   @"validation: zero maxOffset error");
		
		NSDictionary *userInfoDict =
		@{NSLocalizedDescriptionKey: errorString};
		NSError *error = [[NSError alloc] initWithDomain:@"JoystickView"
													 code:1
												 userInfo:userInfoDict];
		*outError = error;
		return NO;
	}
	return YES;
}


- (void)viewWillMoveToSuperview:(NSView *)newSuperview
{
	[super viewWillMoveToSuperview:newSuperview];
	if (newSuperview == nil)
	{
		[self unbind:ANGLE_BINDING_NAME];
		[self unbind:OFFSET_BINDING_NAME];
	}
}




@end


