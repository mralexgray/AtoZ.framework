//
//  SDIntroWindow.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDInstructionsWindow.h"
@implementation SDInstructionsWindow

- (void) swipeWithEvent:(NSEvent*)event {
	NSInteger dir = (NSInteger)[event deltaX];
	if (dir > 0)
		[self tryToPerform:@selector(navigateInDirection:) with:@-1];
	if (dir < 0)
		[self tryToPerform:@selector(navigateInDirection:) with:@+1];
}

@end
