
//  AZBackgroundProgressBar.h
//  AtoZ

//  Created by Alex Gray on 8/27/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Cocoa/Cocoa.h>

@interface AZBackgroundProgressBar : NSView
{

BOOL shouldStop;

	//The number of pixels to translate right
CGFloat phase;

	//The time interval from the reference date when the progress bar was last phased. Used to update phase
NSTimeInterval lastUpdate;
}

- (IBAction)startAnimation:(id)sender;
- (IBAction)stopAnimation:(id)sender;
@end
