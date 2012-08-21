//
//  SDIntroWindowController.m
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//
#import "NSApplication+AppInfo.h"
#import "SDInstructionsWindowController.h"
#import "SDRoundedInstructionsImageView.h"

@implementation SDInstructionsWindowController

@synthesize delegate;

- (id) init {
	if (self = [super initWithWindowNibName:@"InstructionsWindow"]) {
		imageViews = [[NSMutableArray array] retain];
	}
	return self;
}

- (void) dealloc {
	[imageViews release];
	[super dealloc];
}

- (void) windowDidLoad {
	NSWindow *window = [self window];
	
	NSArray *imageNames = [delegate instructionImageNames];
	
	for (NSString *imageName in imageNames) {
		NSImage *image = ( [NSImage imageNamed:imageName] ? [NSImage imageNamed:imageName] : [NSImage imageInFrameworkWithFileName:imageName]);

		NSRect imageViewFrame = NSZeroRect;
		imageViewFrame.size = [imageViewContainer frame].size;
//		imageViewFrame.origin = NSMakePoint(1.0, 1.0);
		imageViewFrame = NSIntegralRect(imageViewFrame);
		
		NSImageView *imageView = [[[SDRoundedInstructionsImageView alloc] initWithFrame:imageViewFrame] autorelease];
		[imageView setImageScaling:NSScaleNone];
		[imageView setImageAlignment:NSImageAlignCenter];
		[imageView setImage:image];
		
		[imageViews addObject:imageView];
	}
	
	// to make it appear right away in the window
	[self willChangeValueForKey:@"selectedImageIndexPlusOne"];
	selectedImageIndex = 0;
	[self didChangeValueForKey:@"selectedImageIndexPlusOne"];
	
	[imageViewContainer setWantsLayer:YES];
	[imageViewContainer addSubview:imageViews[0]];
	
	[window setContentBorderThickness:34.0 forEdge:NSMinYEdge];
	[window setTitle:$(@"%@ %@",[window title], [[NSApplication sharedApplication] appName])];
}

- (int) selectedImageIndexPlusOne {
	return selectedImageIndex + 1;
}

- (void) navigateInDirection:(NSNumber*)dir {
	NSInteger oldSelectedImage = selectedImageIndex;
	
	[self willChangeValueForKey:@"selectedImageIndexPlusOne"];
	
	selectedImageIndex += [dir intValue];
	
	if (selectedImageIndex < 0)
		selectedImageIndex = 0;
	else if (selectedImageIndex == [imageViews count])
		selectedImageIndex = [imageViews count] - 1;
	
	[self didChangeValueForKey:@"selectedImageIndexPlusOne"];
	
	[backForwardButton setEnabled:(selectedImageIndex > 0) forSegment:0];
	[backForwardButton setEnabled:(selectedImageIndex < [imageViews count] - 1) forSegment:1];
	
	if (selectedImageIndex == oldSelectedImage)
		return;
	
	NSView *oldSubview = [[imageViewContainer subviews] lastObject];
	NSView *newSubview = imageViews[selectedImageIndex];
	
	[[imageViewContainer animator] replaceSubview:oldSubview
											 with:newSubview];
}

- (IBAction) navigateFromArrowsButton:(NSSegmentedControl*)sender {
	if ([sender selectedSegment] == 0)
		[self navigateInDirection:@-1];
	else
		[self navigateInDirection:@+1];
}

- (IBAction) closeWindow:(id)sender {
	[self close];
}

@end
