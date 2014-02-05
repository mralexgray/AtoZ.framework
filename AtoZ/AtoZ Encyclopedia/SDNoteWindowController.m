//
//  SDNoteViewController.m
//  DeskNotation
//
//  Created by Steven Degutis on 6/30/09.
//  Copyright 2009 8th Light. All rights reserved.
//

#import "SDNoteWindowController.h"

#import "SDEditTitleController.h"
#import "SDGeneralPrefPane.h"
@interface SDNoteWindowController (Private)
@end
@implementation SDNoteWindowController

- (id) init {
	return [self initWithDictionary:nil];
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
	if (self = [super initWithWindowNibName:@"NoteWindow"]) {
		dictionaryToLoadFrom = dictionary;// retain];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(noteAppearanceDidChange:)
													 name:SDNoteAppearanceDidChangeNotification
												   object:nil];
		[self showWindow:self];
	}
	return self;
}

- (void) updateNoteAppearance {
	switch ([SDDefaults integerForKey:@"appearance"]) {
		case 0: // dark
//			NSColor *d = [[[AtoZ fengShui]randomElement] colorWithAlphaComponent:0.8];
			[backgroundBox setFillColor:RANDOMCOLOR];
			[titleLabel setTextColor:RANDOMCOLOR.contrastingForegroundColor];//[NSColor whiteColor]];
			[[titleLabel cell] setBackgroundStyle:NSBackgroundStyleLowered];
			break;
		case 1: // light
			[backgroundBox setFillColor:[[NSColor whiteColor] colorWithAlphaComponent:0.5]];
			[[titleLabel cell] setBackgroundStyle:NSBackgroundStyleRaised];
			[titleLabel setTextColor:[NSColor blackColor]];
			break;
	}
}

- (void) noteAppearanceDidChange:(NSNotification*)notification {
	[self updateNoteAppearance];
}

- (void) showWindowWithAnimation:(BOOL)animate {
	if (animate) {
		[[self window] setAlphaValue:0.0];
		[[self window] orderFront:self];
		[[[self window] animator] setAlphaValue:1.0];
	}
	else {
		[[self window] orderFront:self];
	}
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:SDNoteAppearanceDidChangeNotification
												  object:nil];
	
//	[boxTrackingArea release];
//	[buttonTrackingArea release];
	[super dealloc];
}

- (NSDictionary*) dictionaryRepresentation {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	dictionary[@"frame"] = NSStringFromRect([[self window] frame]);
	dictionary[@"title"] = [titleLabel stringValue];
	return dictionary;
}

- (void) windowDidLoad {
	[super windowDidLoad];
	
	[[self window] setMovableByWindowBackground:YES];
	[[[self window] contentView] setWantsLayer:YES];

	[self updateNoteAppearance];
	
	if (dictionaryToLoadFrom) {
		NSString *title = dictionaryToLoadFrom[@"title"];
		NSString *frameString = dictionaryToLoadFrom[@"frame"];
		
		NSRect frame = NSRectFromString(frameString);
		
		[self setTitle:title];
		[[[self window] nextRunloopProxy] setFrame:frame display:NO];
		
		[self showWindowWithAnimation:NO];
		
		[dictionaryToLoadFrom release];
		dictionaryToLoadFrom = nil;
	}
	else {
		[self showWindowWithAnimation:YES];
	}
	
	int options = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingInVisibleRect);
	boxTrackingArea = [NSTrackingArea.alloc initWithRect:NSZeroRect
												   options:options
													 owner:self
												  userInfo:nil];
	
	buttonTrackingArea = [boxTrackingArea copy];
	
	[backgroundBox addTrackingArea:boxTrackingArea];
	[closeButton addTrackingArea:buttonTrackingArea];
}

// MARK: -
// MARK: Close Button

- (void) conditionallyShowCloseButton {
	shouldShowCloseButton = ((mouseHoveringOverBox || mouseHoveringOverButton) && (isEditing == NO));
	[[closeButton animator] setHidden:!shouldShowCloseButton];
}

// shit

- (void) setHoveringOverNote:(NSNumber*)hovering {
	mouseHoveringOverBox = [hovering boolValue];
	[self conditionallyShowCloseButton];
}

- (void) futureSetHoveringOverNote:(BOOL)hovering {
	[self performSelector:@selector(setHoveringOverNote:) withObject:@(hovering) afterDelay:0.5];
}

- (void) futureCancelSetHoveringOverNote:(BOOL)hovering {
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(setHoveringOverNote:) object:@(hovering)];
}

// end shit

- (void) mouseEntered:(NSEvent*)event {
	if ([event trackingArea] == boxTrackingArea) {
		[self futureCancelSetHoveringOverNote:NO];
		[self futureSetHoveringOverNote:YES];
	}
	else if ([event trackingArea] == buttonTrackingArea)
		mouseHoveringOverButton = YES;
	
	[self conditionallyShowCloseButton];
}

- (void) mouseExited:(NSEvent*)event {
	if ([event trackingArea] == boxTrackingArea) {
		[self futureCancelSetHoveringOverNote:YES];
		[self futureSetHoveringOverNote:NO];
	}
	else if ([event trackingArea] == buttonTrackingArea)
		mouseHoveringOverButton = NO;
	
	[self conditionallyShowCloseButton];
}

- (IBAction) deleteNote:(id)sender {
	NSWindow *window = [self window];
	
	CAAnimation *animation = [[window animationForKey:@"alphaValue"] copy];
	[window setAnimations:@{ @"alphaValue":animation }];
	animation.delegate = self;
	[[window animator] setAlphaValue:0.0];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	[NSApp tryToPerform:@selector(removeNoteFromCollection:) with:self];
}

// MARK: -
// MARK: Setting Title

- (void) setTitle:(NSString*)title {
	NSCharacterSet *characterSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
	NSString *newTitle = [title stringByTrimmingCharactersInSet:characterSet];
	
	[titleLabel setStringValue:newTitle];
	[titleLabel sizeToFit];
	
	NSSize boxSize = [backgroundBox frame].size;
	boxSize.width = NSWidth([titleLabel frame]) + 26.0;
	[backgroundBox setFrameSize:boxSize];
	
	NSRect windowFrame = [[self window] frame];
	
	float difference = boxSize.width - NSWidth(windowFrame);
	
	windowFrame.origin.x -= difference / 2.0 + 20.0;
	windowFrame.size.width = boxSize.width + 40.0;
	
	[[self window] setFrame:windowFrame display:YES];
}

- (void) editTitle {
	SDEditTitleController *controller = SDEditTitleController.new;
	
	[controller setTitleFieldWidth:NSWidth([titleLabel frame])];
	[controller setTitle:[titleLabel stringValue]];
	
	isEditing = YES;
	
	[[self window] setLevel:kCGNormalWindowLevel];
	
	[NSApp beginSheet:[controller window]
	   modalForWindow:[self window]
		modalDelegate:self
	   didEndSelector:@selector(editTitleSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:(__bridge void *)(controller)];
}

- (void) editTitleSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
//	[[self window] setLevel:kCGDesktopIconWindowLevel];

//	[sheet orderOut:self];
	isEditing = NO;
	
	SDEditTitleController *controller = (__bridge id)contextInfo;

//	if (returnCode == YES)
		[self setTitle:controller.title];
	
//	[controller release];
}

@end
