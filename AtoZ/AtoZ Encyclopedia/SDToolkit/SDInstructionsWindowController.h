//
//  SDIntroWindowController.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>

@protocol SDInstructionsDelegate

- (NSArray*) instructionImageNames;

@end

#import "SDWindowController.h"

@interface SDInstructionsWindowController : SDWindowController {
	NSMutableArray *imageViews;
	NSInteger selectedImageIndex;
	
	IBOutlet NSView *imageViewContainer;
	IBOutlet NSSegmentedControl *backForwardButton;
	
	id <SDInstructionsDelegate> delegate;
}

@property (assign) id <SDInstructionsDelegate> delegate;

- (int) selectedImageIndexPlusOne;

- (IBAction) navigateFromArrowsButton:(NSSegmentedControl*)sender;
- (IBAction) closeWindow:(id)sender;

@end
