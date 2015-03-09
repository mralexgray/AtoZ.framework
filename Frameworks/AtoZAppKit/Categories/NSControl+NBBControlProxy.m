/* Neon Boom Box - In-car entertainment front-end
 * Copyright (C) 2012 Brad Allred
 *

 */

#import "NSControl+NBBControlProxy.h"
#import "NBBThemeEngine.h"

@implementation NSControl (NBBControlProxy)

+ allocWithZone:(NSZone *)zone
{
	NBBThemeEngine* themeEngine = [NBBThemeEngine sharedThemeEngine];
	((NSProxy*)self) = [themeEngine classReplacementForThemableClass:self];
	return [super allocWithZone:zone];
}

// use this method over awakeFromNib because we need to catch controls that are created dynamically too
- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
	if (newWindow && [self conformsToProtocol:@protocol(NBBThemable)]) {
		[self setWantsLayer:YES]; // nbb uses CA for many control animations
		NBBThemeEngine* themeEngine = [NBBThemeEngine sharedThemeEngine];
		[themeEngine themeObject:(id <NBBThemable>)self];
	}
	//[self setTranslatesAutoresizingMaskIntoConstraints:YES];
	[super viewWillMoveToWindow:newWindow]; // shouldnt do anything (default implementation is noop)
}

- (NBBTheme*) theme
{
	if ([self conformsToProtocol:@protocol(NBBThemable)]) {
		return [NBBThemeEngine sharedThemeEngine].theme;
	}
	return nil;
}

- (NSDraggingSession*)beginDraggingSessionWithDraggingCell:(NSCell <NSDraggingSource> *)cell event:(NSEvent*) theEvent
{
	NSImage* image = [self imageForCell:cell];

	NSDraggingItem* di = [[NSDraggingItem alloc] initWithPasteboardWriter:image];// autorelease];
	NSRect dragFrame = [self frameForCell:cell];
	dragFrame.size = image.size;
	[di setDraggingFrame:dragFrame contents:image];

	NSArray* items = [NSArray arrayWithObject:di];

	return [self beginDraggingSessionWithItems:items event:theEvent source:cell];
}

- (NSRect)frameForCell:(NSCell*)cell
{
	// override in multi-cell cubclasses!
	return self.bounds;
}

- (NSImage*)imageForCell:(NSCell*)cell
{
	return [self imageForCell:cell highlighted:[cell isHighlighted]];
}

- (NSImage*)imageForCell:(NSCell*)cell highlighted:(BOOL) highlight
{
	// override in multicell cubclasses to just get an image of the dragged cell.
	// for any single cell control we can just make sure that cell is the controls cell
	
	if (cell == self.cell || cell == nil) { // nil signifies entire control
		// basically a bitmap of the control
		// NOTE: the cell is irrelevant when dealing with a single cell control
		BOOL isHighlighted = [cell isHighlighted];
		[cell setHighlighted:highlight];

		NSRect cellFrame = [self frameForCell:cell];

		// We COULD just draw the cell, to an NSImage, but button cells draw their content
		// in a special way that would complicate that implementation (ex text alignment).
		// subclasses that have multiple cells may wish to override this to only draw the cell
		NSBitmapImageRep* rep = [self bitmapImageRepForCachingDisplayInRect:cellFrame];
		NSImage* image = [[NSImage alloc] initWithSize:rep.size];
		if([self needsToDrawRect:cellFrame]) {
			[self drawRect:cellFrame];
		}
		[self cacheDisplayInRect:cellFrame toBitmapImageRep:rep];
		[image addRepresentation:rep];
		// reset the original cell state
		[cell setHighlighted:isHighlighted];
		return image;// autorelease];
	}
	// cell doesnt belong to this control!
	return nil;
}

#pragma mark NSDraggingDestination
// message forwarding doesnt work for NSDraggingDestination methods
// because NSView implements empty methods for the protocol

- (NSDragOperation)draggingEntered:(id < NSDraggingInfo >)sender
{
	return [self.cell draggingEntered:sender];
}

- (void)draggingExited:(id < NSDraggingInfo >)sender
{
	[self.cell draggingExited:sender];
}

- (void)draggingEnded:(id < NSDraggingInfo >)sender
{
	// this method is optional in the protocol
	// but we need all controls to respond to it
	// even if they do nothing
}

- (BOOL)prepareForDragOperation:(id < NSDraggingInfo >)sender
{
	return [self.cell prepareForDragOperation:sender];
}

- (BOOL)performDragOperation:(id < NSDraggingInfo >)sender
{
	return [self.cell performDragOperation:sender];
}

- (void)concludeDragOperation:(id < NSDraggingInfo >)sender
{
	return [self.cell concludeDragOperation:sender];
}

@end
