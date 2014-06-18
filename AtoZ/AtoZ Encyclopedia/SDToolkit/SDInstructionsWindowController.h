//
//  SDIntroWindowController.h
//  DeskLabels
//
//  Created by Steven Degutis on 7/1/09.
//  Copyright 2009 Thoughtful Tree Software. All rights reserved.
//

#import <AtoZ/AtoZ.h>

@protocol SDInstructionsDelegate

- (NSA*) instructionImageNames;

@end

#import "SDWindowController.h"

@interface SDInstructionsWindowController : SDWindowController {
	NSMutableArray *imageViews;

	IBOutlet NSView *imageViewContainer;
	IBOutlet NSSegmentedControl *backForwardButton;
	
//	id <SDInstructionsDelegate> delegate;
}
@property NSInteger selectedImageIndex;

@property (assign) id <SDInstructionsDelegate> delegate;

- (NSUI) selectedImageIndexPlusOne;

- (IBAction) navigateFromArrowsButton:(NSSegmentedControl*)sender;
- (IBAction) closeWindow:(id)sender;

@end
