
//  AZBorderlessResizeWindow.m
//  AtoZ
//
//  Created by Alex Gray on 10/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZBorderlessResizeWindow.h"

@interface AZBorderlessResizeWindow  ()
@property (ASSGN, NATOM) NSP initialMouseLocation;
@property (ASSGN, NATOM) NSR initialWindowFrame;
@property (ASSGN, NATOM) BOOL isResizeOperation;
@end
@implementation AZBorderlessResizeWindow
@synthesize  initialMouseLocation, initialWindowFrame, isResizeOperation ;

- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)aStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)flag
{
	if (( self = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask
									backing:bufferingType   defer:flag] ))
		{
        [self setOpaque:NO];
        [self setBackgroundColor:[NSColor clearColor]];
        [self setMovableByWindowBackground:YES];
        [self setLevel:NSPopUpMenuWindowLevel];
        [self setStyleMask:NSBorderlessWindowMask];
        [self setIsVisible:YES];
		[self setMinSize:self.frame.size];

		}

    return self;
}
- (BOOL)canBecomeKeyWindow
{
    return YES;
}

- (BOOL)canBecomeMainWindow
{
    return YES;
}

//- (void)mouseMoved:(NSEvent *)event
//{
//    //set movableByWindowBackground to YES **ONLY** when the mouse is on the title bar
//    NSPoint mouseLocation = [event locationInWindow];
//    if (NSPointInRect(mouseLocation, AZUpperEdge([self frame], 40)))
//        [self setMovableByWindowBackground:YES];
//    else
//        [self setMovableByWindowBackground:NO];
//
//    //This is a good place to set the appropriate cursor too
//}
//
//- (void)mouseDown:(NSEvent *)event
//{
//    //Just in case there was no mouse movement before the click AND
//    //is inside the title bar frame then setMovableByWindowBackground:YES
//    NSPoint mouseLocation = [event locationInWindow];
//    if (NSPointInRect(mouseLocation, AZUpperEdge([self frame], 40)))
//        [self setMovableByWindowBackground:YES];
//    else //if (NSPointInRect(mouseLocation, bottomRightResizingCornerRect))
//        [self doBottomRightResize:event];
//    //... do all other resizings here. There are 6 more in OSX 10.7!
//}
//
//- (void)mouseUp:(NSEvent *)event
//{
//    //movableByBackground must be set to YES **ONLY**
//    //when the mouse is inside the titlebar.
//    //Disable it here :)
//    [self setMovableByWindowBackground:NO];
//}
////All my resizing methods start in mouseDown:
//
//- (void)doBottomRightResize:(NSEvent *)event {
//    //This is a good place to push the appropriate cursor
//
//    NSRect r = [self frame];
//    while ([event type] != NSLeftMouseUp) {
//        event = [self nextEventMatchingMask:(NSLeftMouseDraggedMask | NSLeftMouseUpMask)];
//        //do a little bit of maths and adjust rect r
//        [self setFrame:r display:YES];
//    }
//
//    //This is a good place to pop the cursor :)
//
//    //Dispatch unused NSLeftMouseUp event object
//    if ([event type] == NSLeftMouseUp) {
//        [self mouseUp:event];
//    }
//}

-(void) scrollWheel:(NSEvent *)theEvent {

	//	CGF off = theEvent.deltaY < 0 ? - 10 : 10;
	NSR new = self.frame;
	new.size.width += theEvent.deltaX /10;//NSOffsetRect(self.frame,off, 0);
	new.size.height += theEvent.deltaY/10 ;
	new.size.height = new.size.height < 100? 100 : new.size.height;
	new.size.width = new.size.width < 100 ? 100  : new.size.width;
	[[self animator] setFrame:new display:YES animate:YES];
	[[[self contentView]subviews]each:^(id obj) {
		[[obj animator] setFrame:new];
	}];
}

- (void)setIsVisible:(BOOL)flag
{
    [[self animator] setAlphaValue:flag ? 1.0 : 0.0];

    [super setIsVisible:flag];
}

- (void)toggleVisibility
{
    [self setIsVisible:![self isVisible]];
}
@end
