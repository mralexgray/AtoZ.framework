//
//  SDCloseButton.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/30/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDCloseButtonCell.h"


@implementation SDCloseButtonCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSString *imageName = ([self isHighlighted] ? @"closebox_pressed" : @"closebox");
	NSImage *image = [NSImage imageNamed:imageName];
	
	[image setFlipped:YES];
	[image drawInRect:cellFrame
			 fromRect:NSZeroRect
			operation:NSCompositeSourceOver
			 fraction:1.0];
}

@end
