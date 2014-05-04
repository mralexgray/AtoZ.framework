//
//  SDEditTitleController.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/30/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDEditTitleController.h"

#import "SDTitleFieldEditor.h"

@implementation SDEditTitleController

@synthesize title, fieldEditor, titleTextField;

- (id) init {
	if (self = [super initWithWindowNibName:@"EditTitlePanel"]) {
		self.fieldEditor = SDTitleFieldEditor.new;
	}
	return self;
}

//- (void) dealloc {
//	[newTitle release];
//	[fieldEditor release];
//	[super dealloc];
//}

- (IBAction) accept:(id)sender {
	self.title = [self.titleTextField stringValue];
	[[self window] setDelegate:nil];
	[NSApp endSheet:[self window] returnCode:YES];
}

- (IBAction) cancel:(id)sender {
	[[self window] setDelegate:nil];
	[NSApp endSheet:[self window] returnCode:NO];
}

- (void) indowDidResignKey:(NSNotification *)notification {
	[self cancel:self];
}

- (id)windowWillReturnFieldEditor:(NSWindow *)window toObject:(id)anObject {
	if (anObject == titleTextField)
		return fieldEditor;
	else
		return nil;
}

- (void) setTitle:(NSString*)aTitle {
	if (title) title = nil;
	title = aTitle;
	[self.titleTextField setStringValue:title];
}

- (void) setTitleFieldWidth:(float)width {
	NSSize size = [self.titleTextField frame].size;
	size.width = width;
	[self.titleTextField setFrameSize:size];
	
	NSRect frame = [[self window] frame];
	frame.size.width = width;
	[[self window] setFrame:frame display:NO];
}

@end
