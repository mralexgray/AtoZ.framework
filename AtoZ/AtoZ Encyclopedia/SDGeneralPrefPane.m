//
//  SDPreferencesController.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDGeneralPrefPane.h"


@implementation SDGeneralPrefPane

- (id) init {
	if (self = [super initWithNibName:@"GeneralPrefPane" bundle:nil]) {
		[self setTitle:@"General"];
	}
	return self;
}

- (NSImage*) image {
	return [NSImage imageNamed:@"NSPreferencesGeneral"];
}

- (IBAction) changeAppearance:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:SDNoteAppearanceDidChangeNotification object:nil];
}

- (NSString*) tooltip {
	return nil;
}

@end
