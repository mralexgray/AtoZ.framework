/*
 * StickyNoteView.m
 *
 * Created by Jim McGowan on 04/10/2007.
 * Updated 05/09/2012 for Reference Tracker 2
 *
 * This code uses ARC
 *
 * Copyright (c) Jim McGowan
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * The name Jim McGowan may not be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY JIM MCGOWAN ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL JIM MCGOWAN BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "StickyNoteView.h"

enum {
	MWDraggingModeMove = 0,
	MWDraggingModeResize,
	MWDraggingModeNone
};

static void *FlippedTopLeftPointBindingContext = (void *)@"FlippedTopLeftPointBindingContext";

// Geometry Functions
NSSize sizeConstrainedToMinimumSize(NSSize size, NSSize minimums);
NSSize sizeConstrainedToMaximumSize(NSSize size, NSSize maximums);
NSRect constrainRectToInsideRect(NSRect internalRect, NSRect enclosingRect, BOOL *internalRectExceedsBounds);
NSPoint constrainPointToInsideRect(NSPoint point, NSRect rect);
NSPoint pointInFlippedCoords(NSPoint point, NSRect enclosingBounds);
NSRect nonNegativeRect(NSRect aRect);


#pragma mark -


@implementation StickyNoteView
{
	NSPoint mouseEventSequenceStartPointInSuperCoords;
	NSPoint lastDragPoint;
	NSUInteger draggingOp;
	NSTrackingArea *mouseTrackingArea;
	NSDictionary *flippedTopLeftPointBindingInfo;
}


+ (void)initialize
{
	[self exposeBinding:@"flippedTopLeftPoint"];
}


+ (Class)cellClass
{
    return [NSTextFieldCell class];
}


- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	if(self != nil)
	{
		self.noteColor = [NSColor colorWithCalibratedRed:0.99 green:0.96 blue:0.55 alpha:1.0];
		self.textColor = [NSColor colorWithCalibratedWhite:0.25 alpha:1.0];
		self.minSize = NSMakeSize(75,75);
		self.maxSize = NSMakeSize(300,300);
		flippedTopLeftPointBindingInfo = nil;
        
        [self setFont:[NSFont fontWithName:[[NSUserDefaults standardUserDefaults] valueForKey:@"StickyNoteFontName"]
                                      size:[[[NSUserDefaults standardUserDefaults] valueForKey:@"StickyNoteFontSize"] floatValue]]];
        
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"defaults.StickyNoteFontName" options:0 context:NULL];
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"defaults.StickyNoteFontSize" options:0 context:NULL];
        
        mouseTrackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                         options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow)
                                                           owner:self userInfo:nil];
        [self addTrackingArea:mouseTrackingArea];
        
        [[self cell] setEditable:NO];
    }
    return self;
}


- (void)dealloc
{
    [self unbind:@"flippedTopLeftPoint"];
}


- (void)updateTrackingAreas
{
    [self removeTrackingArea:mouseTrackingArea];
    mouseTrackingArea = [[NSTrackingArea alloc] initWithRect:[self bounds]
                                                     options:(NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow)
                                                       owner:self userInfo:nil];
    [self addTrackingArea:mouseTrackingArea];
}






#pragma mark -
#pragma mark Properties

- (NSColor *)textColor
{
    return [[self cell] textColor];
}


- (void)setTextColor:(NSColor *)textColor
{
    [[self cell] setTextColor:textColor];
}






#pragma mark -
#pragma mark Bindings & Observations

- (void)bind:(NSString *)binding toObject:(id)observable withKeyPath:(NSString *)keyPath options:(NSDictionary *)options
{
    if ([binding isEqualToString:@"flippedTopLeftPoint"])
    {
        flippedTopLeftPointBindingInfo = nil;
        flippedTopLeftPointBindingInfo = @{NSObservedObjectKey : observable, NSObservedKeyPathKey : keyPath, NSOptionsKey : options};
        self.flippedTopLeftPoint = [[observable valueForKeyPath:keyPath] pointValue];
        
        [observable addObserver:self forKeyPath:keyPath options:0 context:FlippedTopLeftPointBindingContext];
    }
    else
    {
        [super bind:binding toObject:observable withKeyPath:keyPath options:options];
    }
}


- (NSDictionary *)infoForBinding:(NSString *)binding
{
    if ([binding isEqualToString:@"flippedTopLeftPoint"])
    {
        return flippedTopLeftPointBindingInfo;
    }
    else
    {
        return [super infoForBinding:binding];
    }
}


- (void)unbind:(NSString *)binding
{
    if ([binding isEqualToString:@"flippedTopLeftPoint"] && (flippedTopLeftPointBindingInfo != nil))
    {
        [flippedTopLeftPointBindingInfo[NSObservedObjectKey] removeObserver:self forKeyPath:flippedTopLeftPointBindingInfo[NSObservedKeyPathKey] context:FlippedTopLeftPointBindingContext];
        flippedTopLeftPointBindingInfo = nil;
    }
    else
    {
        [super unbind:binding];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == FlippedTopLeftPointBindingContext)
    {
        self.flippedTopLeftPoint = [[object valueForKeyPath:keyPath] pointValue];
    }
    
    else if (object == [NSUserDefaultsController sharedUserDefaultsController] && ([keyPath isEqualToString:@"defaults.StickyNoteFontName"] || [keyPath isEqualToString:@"defaults.StickyNoteFontSize"] ))
    {
        [self setFont:[NSFont fontWithName:[[NSUserDefaults standardUserDefaults] valueForKey:@"StickyNoteFontName"]
                                      size:[[[NSUserDefaults standardUserDefaults] valueForKey:@"StickyNoteFontSize"] floatValue]]];
    }
    
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    
}









#pragma mark -
#pragma mark Mouse Actions

- (void)resetCursorRects
{
    [self discardCursorRects];
    
    switch (draggingOp)
    {
        case MWDraggingModeMove:
            [self addCursorRect:[self bounds] cursor:[NSCursor closedHandCursor]];
            break;
        case MWDraggingModeResize:
            [self addCursorRect:[self bounds] cursor:[[NSCursor alloc] initWithImage:[NSImage imageNamed:@"DiagonalResizeCursor"] hotSpot:NSMakePoint(8.0, 8.0)]];
            break;
        default:
        {
            [self addCursorRect:[self bounds] cursor:[NSCursor openHandCursor]];
            [self addCursorRect:[self resizeHandleRectForCurrentFrame] cursor:[[NSCursor alloc] initWithImage:[NSImage imageNamed:@"DiagonalResizeCursor"] hotSpot:NSMakePoint(8.0, 8.0)]];
            [self addCursorRect:[self closeButtonRectForCurrentFrame] cursor:[NSCursor arrowCursor]];
            break;
        }
    }
}



- (void)mouseEntered:(NSEvent *)theEvent
{
    [self setNeedsDisplay:YES];
}


- (void)mouseExited:(NSEvent *)theEvent
{
    [self setNeedsDisplay:YES];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    if([theEvent clickCount] == 2)
    {
        [self doubleMouse:theEvent];
        return;
    }
    
    [[self window] makeFirstResponder:self]; // resign any other active key views
    
    mouseEventSequenceStartPointInSuperCoords = [[self superview] convertPoint:[theEvent locationInWindow] fromView:nil];
    NSPoint startPointInLocalCoords = [self convertPoint:mouseEventSequenceStartPointInSuperCoords fromView:[self superview]];
    
    if([self mouse:startPointInLocalCoords inRect:[self resizeHandleRectForCurrentFrame]])
    {
        draggingOp = MWDraggingModeResize;
    }
    else if ([self mouse:startPointInLocalCoords inRect:[self closeButtonRectForCurrentFrame]])
    {
        draggingOp = MWDraggingModeNone;
    }
    else
    {
        draggingOp = MWDraggingModeMove;
    }
    
    lastDragPoint = mouseEventSequenceStartPointInSuperCoords;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    [self autoscroll:theEvent];
    
    NSRect origFrame = [self frame];
    NSRect newFrame = [self frame];
    NSPoint newDragPoint = [[self superview] convertPoint:[theEvent locationInWindow] fromView:nil];
    NSPoint delta = NSMakePoint(newDragPoint.x - lastDragPoint.x, newDragPoint.y - lastDragPoint.y);
    
    if(draggingOp == MWDraggingModeMove)
    {
        newFrame.origin.x += delta.x;
        newFrame.origin.y += delta.y;
    }
    
    if(draggingOp == MWDraggingModeResize)
    {
        newFrame.size.width += delta.x;
        newFrame.size.height += delta.y;
    }
    
    [self setFrame:newFrame];
    [[self superview] setNeedsDisplayInRect:NSUnionRect(origFrame, newFrame)];
    
    if (!(NSMaxX([self frame]) == NSMaxX([[self superview] bounds])) &&
        !(NSMinX([self frame]) == NSMinX([[self superview] bounds])))
    {
        lastDragPoint.x = newDragPoint.x;
    }
    
    if (!(NSMaxY([self frame]) == NSMaxY([[self superview] bounds])) &&
        !(NSMinY([self frame]) == NSMinY([[self superview] bounds])))
    {
        lastDragPoint.y = newDragPoint.y;
    }
}


- (void)mouseUp:(NSEvent *)theEvent
{
    NSPoint startingMouseLoc = [self convertPoint:mouseEventSequenceStartPointInSuperCoords fromView:[self superview]];
    NSPoint currentMouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    // Remove the note if the close button was clicked
    if( (draggingOp == MWDraggingModeNone) &&
       ([self mouse:startingMouseLoc inRect:[self closeButtonRectForCurrentFrame]] ) &&
       ([self mouse:currentMouseLoc inRect:[self closeButtonRectForCurrentFrame]]) )
    {
        if( ([self delegate] != nil) && ([[self delegate] respondsToSelector:@selector(stickyNoteViewShouldBeDismissed:)]) )
        {
            [[self delegate] stickyNoteViewShouldBeDismissed:self];
        }
        else
        {
            NSLog(@"Trying to close a sticky note view without a delegate");
        }
        return;
    }
    
    
    // update any model bound to flippedTopLeftPoint
    if (flippedTopLeftPointBindingInfo != nil)
    {
        [flippedTopLeftPointBindingInfo[NSObservedObjectKey] setValue:[NSValue valueWithPoint:self.flippedTopLeftPoint] forKeyPath:flippedTopLeftPointBindingInfo[NSObservedKeyPathKey]];
    }
    
    
    // move self to front
    NSMutableArray *allSubviews = [[[self superview] subviews] mutableCopy];
    [allSubviews removeObject:self];
    [allSubviews addObject:self];
    [[self superview] setSubviews:allSubviews];
    
    
    // Clean up
    draggingOp = MWDraggingModeNone;
    lastDragPoint = NSZeroPoint;
    [NSCursor pop];
    [[self window] invalidateCursorRectsForView:self];
}


- (void)doubleMouse:(NSEvent *)theEvent
{
    NSRect cellFrame = [self cellRectForCurrentFrame];
    NSText *editor = [[self window] fieldEditor:YES forObject:self];
    [[self cell] setEditable:YES];
    [[self cell] editWithFrame:cellFrame inView:self editor:editor delegate:self event:theEvent];
}




#pragma mark -
#pragma mark Editor Delegate Methods

- (void)textDidBeginEditing:(NSNotification *)aNotification
{
}


- (void)textDidChange:(NSNotification *)aNotification
{
    NSDictionary *valueBindingInfo = [self infoForBinding:@"value"];
    if ((valueBindingInfo != nil) && ([valueBindingInfo[NSOptionsKey][NSValidatesImmediatelyBindingOption] boolValue] == YES))
    {
        [valueBindingInfo[NSObservedObjectKey] setValue:[self stringValue] forKeyPath:valueBindingInfo[NSObservedKeyPathKey]];
    }
}


- (void)textDidEndEditing:(NSNotification *)aNotification
{
    [self validateEditing];
    [[self window] endEditingFor:self];
    [[self cell] setEditable:NO];
    
    NSDictionary *valueBindingInfo = [self infoForBinding:@"value"];
    if (valueBindingInfo != nil)
    {
        [valueBindingInfo[NSObservedObjectKey] setValue:[self stringValue] forKeyPath:valueBindingInfo[NSObservedKeyPathKey]];
    }
}

- (BOOL)textShouldBeginEditing:(NSText *)aTextObject
{
    return YES;
}

- (BOOL)textShouldEndEditing:(NSText *)aTextObject
{
    return YES;
}




#pragma mark -
#pragma mark Drawing

- (void)drawRect:(NSRect)rect
{
    NSRect fillRect = [self fillRectForCurrentFrame];
    
    /* draw background */
    
    NSColor *baseColor = [self.noteColor colorUsingColorSpaceName:NSDeviceRGBColorSpace];
    
    NSColor *hiColor =[NSColor colorWithCalibratedHue:[baseColor hueComponent]
                                           saturation:[baseColor saturationComponent]
                                           brightness:[baseColor brightnessComponent] + 0.075
                                                alpha:[baseColor alphaComponent]];
    
    NSColor *loColor = [NSColor colorWithCalibratedHue:[baseColor hueComponent] - 0.02
                                            saturation:[baseColor saturationComponent] + 0.2
                                            brightness:[baseColor brightnessComponent]
                                                 alpha:[baseColor alphaComponent]];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    [self lockFocus];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:NSMakeSize(0.0,-2.0)];
    [shadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.3]];
    [shadow setShadowBlurRadius:3.0];
    [shadow set];
    
    [loColor set];
    [NSBezierPath fillRect:fillRect];
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:loColor endingColor:hiColor];
    [gradient drawInRect:fillRect angle:90.0];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
    [self unlockFocus];
    
    
    /* draw cell */
    
    if([self currentEditor] == nil)
    {
        NSRect cellFrame = [self cellRectForCurrentFrame];
        [[self cell] drawWithFrame:cellFrame inView:self];
    }
    
    
    /* draw controls */
    
    NSPoint mouseLoc = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
    if([self mouse:mouseLoc inRect:[self fillRectForCurrentFrame]])
    {
        [[NSColor colorWithCalibratedWhite:0.0 alpha:0.5] set];
        NSRect closeRect = NSInsetRect([self closeButtonRectForCurrentFrame], 3.0, 3.0);
        NSBezierPath *path = [NSBezierPath bezierPath];
        [path setLineWidth:1];
        [path moveToPoint:NSMakePoint(closeRect.origin.x, closeRect.origin.y)];
        [path lineToPoint:NSMakePoint(closeRect.origin.x + closeRect.size.width, closeRect.origin.y + closeRect.size.height)];
        [path moveToPoint:NSMakePoint(closeRect.origin.x, closeRect.origin.y + closeRect.size.height)];
        [path lineToPoint:NSMakePoint(closeRect.origin.x + closeRect.size.width, closeRect.origin.y)];
        [path stroke];
        
        NSRect resizeRect = NSInsetRect([self resizeHandleRectForCurrentFrame], 3.0, 3.0);
        path = [NSBezierPath bezierPath];
        [path setLineWidth:1];
        [path moveToPoint:NSMakePoint(resizeRect.origin.x, resizeRect.origin.y)];
        [path lineToPoint:NSMakePoint(resizeRect.origin.x + resizeRect.size.width, resizeRect.origin.y + resizeRect.size.height)];
        [path moveToPoint:NSMakePoint(resizeRect.origin.x +3.0, resizeRect.origin.y)];
        [path lineToPoint:NSMakePoint(resizeRect.origin.x + resizeRect.size.width, resizeRect.origin.y + (resizeRect.size.height -3.0))];
        [path stroke];
    }
}


- (void)drawFocusRingMask
{
    NSRectFill([self fillRectForCurrentFrame]);
}







#pragma mark -
#pragma mark Geometry


- (void)setFrame:(NSRect)frameRect
{
    if (NSEqualRects(frameRect, [self frame]))
    {
        return;
    }
    
    frameRect.size = sizeConstrainedToMinimumSize(frameRect.size, self.minSize);
    frameRect.size = sizeConstrainedToMaximumSize(frameRect.size, self.maxSize);
    
    if ([self superview] != nil)
    {
        frameRect = constrainRectToInsideRect(frameRect, [[self superview] bounds], NULL);
    }
    
    [super setFrame:frameRect];  // calls setFrameOrigin: and setFrameSize:, will/didChangeValueForKey:@"flippedTopLeftPoint" are called in those methods
}


- (void)setFrameSize:(NSSize)newSize
{
    if (NSEqualSizes(newSize, [self frame].size))
    {
        return;
    }
    
    newSize = sizeConstrainedToMinimumSize(newSize, self.minSize);
    newSize = sizeConstrainedToMaximumSize(newSize, self.maxSize);
    
    if ([self superview] != nil)
    {
        [self willChangeValueForKey:@"flippedTopLeftPoint"];
    }
    
    [super setFrameSize:newSize];
    
    if ([self superview] != nil)
    {
        [self didChangeValueForKey:@"flippedTopLeftPoint"];
    }
}


- (void)setFrameOrigin:(NSPoint)newOrigin
{
    if (NSEqualPoints(newOrigin, [self frame].origin))
    {
        return;
    }
    
    if ([self superview] != nil)
    {
        [self willChangeValueForKey:@"flippedTopLeftPoint"];
        newOrigin = constrainPointToInsideRect(newOrigin, [[self superview] bounds]);
    }
    
    [super setFrameOrigin:newOrigin];
    
    if ([self superview] != nil)
    {
        [self didChangeValueForKey:@"flippedTopLeftPoint"];
    }
}


- (NSPoint)flippedTopLeftPoint
{
    if ([self superview] == nil)
    {
        NSLog(@"-flippedTopLeftPoint called when view has no superview. Return value is meaningless");
        return NSMakePoint(CGFLOAT_MIN, CGFLOAT_MIN);
    }
    
    if ([[self superview] isFlipped])
    {
        return [self frame].origin;
    }
    else
    {
        return pointInFlippedCoords(NSMakePoint(NSMinX([self frame]), NSMaxY([self frame])), [[self superview] bounds]);
    }
}


- (void)setFlippedTopLeftPoint:(NSPoint)newFlippedTopLeftPoint
{
    if ([self superview] == nil)
    {
        NSLog(@"-setFlippedTopLeftPoint: called when view has no superview. Frame cannot be updated");
        return;
    }
    
    NSRect newFrame = [self frame];
    if ([[self superview] isFlipped])
    {
        newFrame.origin = newFlippedTopLeftPoint;
    }
    else
    {
        NSPoint newUnflippedTopLeftPoint = pointInFlippedCoords(newFlippedTopLeftPoint, [[self superview] bounds]);
        newFrame.origin = newUnflippedTopLeftPoint;
    }
    [self setFrame:newFrame];
}


- (NSRect) fillRectForCurrentFrame
{
    NSRect noteRect = [self bounds];
    noteRect.size.height -= 4.0;
    noteRect.size.width -= 6.0;
    noteRect.origin.y += 3.0;
    noteRect.origin.x += 3.0;
    
    return noteRect;
}


- (NSRect) cellRectForCurrentFrame
{
    return NSInsetRect([self fillRectForCurrentFrame], 10.0, 10.0);
}


- (NSRect) closeButtonRectForCurrentFrame
{
    NSRect bRect = [self fillRectForCurrentFrame];
    
    bRect.origin.y = (NSMaxY(bRect) - 12.0);
    bRect.size.height = 12.0;
    bRect.size.width = 12.0;
    
    return bRect;
}

- (NSRect) resizeHandleRectForCurrentFrame
{
    NSRect rRect = [self fillRectForCurrentFrame];
    
    rRect.origin.x = (NSMaxX(rRect) - 12.0);
    rRect.size.width = 12.0;
    rRect.size.height = 12.0;
    
    return rRect;
}

@end







#pragma mark -
#pragma mark Geometry Functions

NSSize sizeConstrainedToMinimumSize(NSSize size, NSSize minimums)
{
	NSSize constrainedSize;
	constrainedSize.width = (size.width > minimums.width) ? size.width : minimums.width;
	constrainedSize.height = (size.height > minimums.height) ? size.height : minimums.height;
	
	return constrainedSize;
}


NSSize sizeConstrainedToMaximumSize(NSSize size, NSSize maximums)
{
	NSSize constrainedSize;
	constrainedSize.width = (size.width < maximums.width) ? size.width : maximums.width;
	constrainedSize.height = (size.height < maximums.height) ? size.height : maximums.height;
	
	return constrainedSize;
}

NSRect constrainRectToInsideRect(NSRect internalRect, NSRect enclosingRect, BOOL *internalRectExceedsBounds)
{
	NSRect constrainedRect = nonNegativeRect(internalRect);
	enclosingRect = nonNegativeRect(enclosingRect);
	
	if (NSMaxX(constrainedRect) > NSMaxX(enclosingRect))
	{
		constrainedRect.origin.x -= (NSMaxX(internalRect) - NSMaxX(enclosingRect));
	}
	
	if (NSMaxY(constrainedRect) > NSMaxY(enclosingRect))
	{
		constrainedRect.origin.y -= (NSMaxY(internalRect) - NSMaxY(enclosingRect));
	}
	
	if (NSMinX(constrainedRect) < NSMinX(enclosingRect))
	{
		constrainedRect.origin.x += (NSMinX(enclosingRect) - NSMinX(constrainedRect));
	}
	
	if (NSMinY(constrainedRect) < NSMinY(enclosingRect))
	{
		constrainedRect.origin.y += (NSMinY(enclosingRect) - NSMinY(constrainedRect));
	}
	
	if (internalRectExceedsBounds != NULL)
	{
		if((NSMaxX(constrainedRect) > NSMaxX(enclosingRect)) ||
		   (NSMaxY(constrainedRect) > NSMaxY(enclosingRect)) ||
		   (NSMinX(constrainedRect) < NSMinX(enclosingRect)) ||
		   (NSMinY(constrainedRect) < NSMinY(enclosingRect)))
		{
			*internalRectExceedsBounds = YES;
		}
		else
		{
			*internalRectExceedsBounds = NO;
		}
	}
	
	return constrainedRect;
}

NSPoint constrainPointToInsideRect(NSPoint point, NSRect rect)
{
	rect = nonNegativeRect(rect);
	
	if (!NSPointInRect(point, rect))
	{
		point.x = (point.x > NSMinX(rect)) ? point.x : NSMinX(rect);
		point.x = (point.x < NSMaxX(rect)) ? point.x : NSMaxX(rect);
		point.y = (point.y > NSMinY(rect)) ? point.y : NSMinY(rect);
		point.y = (point.y < NSMaxY(rect)) ? point.y : NSMaxY(rect);
	}
	return point;
}

NSPoint pointInFlippedCoords(NSPoint point, NSRect enclosingBounds)
{
	NSPoint flippedPoint = point;
	flippedPoint.y = NSMaxY(nonNegativeRect(enclosingBounds)) - point.y;
	
	return flippedPoint;
}

NSRect nonNegativeRect(NSRect aRect)
{
	NSRect nonNegativeRect = aRect;
	
	if (aRect.size.width < 0.0)
	{
		nonNegativeRect.origin.x += nonNegativeRect.size.width;
		nonNegativeRect.size.width = -nonNegativeRect.size.width;
	}
	
	if (aRect.size.height < 0.0)
	{
		nonNegativeRect.origin.y += nonNegativeRect.size.height;
		nonNegativeRect.size.height = -nonNegativeRect.size.height;
	}
	
	return nonNegativeRect;
}
