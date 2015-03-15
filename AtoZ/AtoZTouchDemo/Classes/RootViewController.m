//
//  RootViewController.m
//  AtoZ
//
//  Created by Alex Gray on 2/17/15.
//  Copyright mrgray.com, inc. 2015. All rights reserved.
//

#import "RootViewController.h"
@import AtoZTouch;

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)s { return self = [super initWithStyle:s] ? self : nil; }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toOrient {

  return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad ?:
                                          toOrient == UIInterfaceOrientationPortrait;
}

TVNumSections       { return 1; }
TVNumRowsInSection  { return 0; }
TVCellForRowAtIP    {

	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier] ?:
                          [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	
	// Configure the cell.
	
	return cell;
}
@end
