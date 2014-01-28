//
//  SDMainWindow.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/27/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDNoteWindow.h"
#import <AtoZ/AtoZ.h>
#import "SDEditTitleController.h"

@implementation SDNoteWindow

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
	if ([super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:bufferingType defer:flag]) {
		[self setBackgroundColor:[NSColor clearColor]];
		[self setOpaque:NO];
		[self setLevel:NSScreenSaverWindowLevel];
	}
	return self;
}

- (void) mouseDown:(NSEvent*)event {
	if ([event clickCount] == 2)
		[self tryToPerform:@selector(editTitle) with:nil];
}

@end
