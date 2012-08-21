//
//  SDPrefPanel.m
//  Chatter
//
//  Created by Steven on 12/5/08.
//  Copyright 2008 Giant Robot Software. All rights reserved.
//

#import "NSWindow+Geometry.h"

@implementation NSWindow (SDResizableWindow)

- (void) setContentViewSize:(NSSize)newSize display:(BOOL)display animate:(BOOL)animate {
	[self setFrame:[self windowFrameForNewContentViewSize:newSize] display:display animate:animate];
}

- (NSRect) windowFrameForNewContentViewSize:(NSSize)newSize {
	NSRect windowFrame = [self frame];
	
	windowFrame.size.width = newSize.width;
	
	float titlebarAreaHeight = windowFrame.size.height - [[self contentView] frame].size.height;
	float newHeight = newSize.height + titlebarAreaHeight;
	float heightDifference = windowFrame.size.height - newHeight;
	windowFrame.size.height = newHeight;
	windowFrame.origin.y += heightDifference;
	
	return windowFrame;
}

@end
