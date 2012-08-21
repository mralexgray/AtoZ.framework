//
//  SDTitleFieldEditor.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/30/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDTitleFieldEditor.h"


@implementation SDTitleFieldEditor

- (id) init {
	if (self = [super init]) {
		[self setFieldEditor:YES];
	}
	return self;
}

- (void)cancelOperation:(id)sender {
	[[[self window] windowController] cancel:self];
}

@end
