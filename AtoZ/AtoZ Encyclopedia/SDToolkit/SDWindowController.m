//
//  SDWindowController.m
//  SDToolkit
//
//  Created by Steven Degutis on 7/23/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import "SDWindowController.h"


@implementation SDWindowController

- (id)initWithWindowNibName:(NSString *)windowNibName {
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	
	NSString *windowNibPath = nil;
	windowNibPath = [bundle pathForResource:windowNibName ofType:@"xib"];
	if (windowNibPath == nil)
		windowNibPath = [bundle pathForResource:windowNibName ofType:@"nib"];
	
	if (windowNibPath == nil) {
		[self release];
		return nil;
	}
	
	if (self = [super initWithWindowNibPath:windowNibPath owner:self]) {
	}
	return self;
}

@end
