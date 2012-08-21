//
//  NSInsetTextField.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/5/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDInsetTextField.h"


@implementation SDInsetTextField

- (id) initWithCoder:(NSCoder*)coder {
	if (self = [super initWithCoder:coder]) {
		[[self cell] setBackgroundStyle:NSBackgroundStyleRaised];
	}
	return self;
}

@end
