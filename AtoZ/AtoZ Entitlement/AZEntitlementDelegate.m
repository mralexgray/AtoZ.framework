//
//  AZAppDelegate.m
//  AtoZ Entitlement
//
//  Created by Alex Gray on 8/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZEntitlementDelegate.h"


@implementation AZEntitlementDelegate
//@synthesize log = _log;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
//	self.log = @"hello, bitch.";  //works : log
//	self.log = $(@"%@", [AtoZ appCategories]); //works  : array
//	self.dbx = [AtoZ sharedInstance];

//	self.log = $(@"%@", [valueForKeyPath:@"name"]);  // works : directoryContentsAtPath
//	self.log = $(@"%@", [[AtoZ dock]valueForKeyPath:@"name"]);  //  FAIL
	NSRect r = [[_window contentView] bounds];
	self.g	 = [[AZFileGridView alloc] initWithFrame:r andFiles:[AtoZ appFolderSamplerWith:RAND_INT_VAL(23, 55)]];
	[_g setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	[_window setAcceptsMouseMovedEvents:YES];
	[_window setContentView:_g];
//	[[_window contentView] debugDescription];
//	AZSizer *r = dbx.ap
	// Insert code here to initialize your application
}


@end
