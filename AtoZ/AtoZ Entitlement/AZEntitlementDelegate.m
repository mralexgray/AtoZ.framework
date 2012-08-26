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
	self.dbx = [AtoZ sharedInstance];
	
//	self.log = $(@"%@", [valueForKeyPath:@"name"]);  // works : directoryContentsAtPath
//	self.log = $(@"%@", [[AtoZ dock]valueForKeyPath:@"name"]);  //  FAIL
	NSRect r = [[self.window contentView] frame];
	AZFileGridView *g = [[AZFileGridView alloc] initWithFrame:r andFiles:[AtoZ appFolder]];
	[[self.window contentView] addSubview:g];

//	AZSizer *r = dbx.ap
	// Insert code here to initialize your application
}

@end
