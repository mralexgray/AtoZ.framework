//
//  SpiffyAppDelegate.m
//  Spiffy
//
//  Created by Dave Dribin on 11/14/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SpiffyAppDelegate.h"
#import <SpiffyKit/SpiffyKit.h>

@implementation SpiffyAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSLog(@"In appDidFinishLaunching");
	[SpiffyObject doSomething];
	[[window contentView]setLayer:[SpiffyObject makeLayer]];
	[[window contentView]setWantsLayer:YES];
	[[[window contentView]layer]setDelegate:self];
	[[[window contentView]layer]setNeedsDisplay];
	[NSEvent addLocalMonitorForEventsMatchingMask:(int)NSWindowDidEndLiveResizeNotification handler:^NSEvent *(NSEvent *e) {
		NSLog(@"did catch note!"); [[[window contentView]layer]setNeedsDisplay]; return e;
	}];
//	NSFNanoStore *nanoStore = [NSFNanoStore createAndOpenStoreWithType:NSFMemoryStoreType path:nil error:nil];

}

-(void) drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

   	NSGraphicsContext *nsGraphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:ctx flipped:NO];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext:nsGraphicsContext];
 	[[NSColor greenColor]set];
	NSRectFill(NSMakeRect(0,0,50,50));
	[[NSColor colorWithCalibratedRed:0.864 green:0.498 blue:0.191 alpha:1.000]set];
	[[VageenFactory vageen] fill];
	[NSGraphicsContext restoreGraphicsState];
}
@end
