//
//  AZAppDelegate.m
//  AZUmbrellaTestBed
//
//  Created by Alex Gray on 12/6/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZAppDelegate.h"
#import <AtoZ/AtoZ.h>

@implementation AZAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	NSS* avaiNamesOutput = [[CWTask.alloc initWithExecutable:@"/usr/local/bin/brew" andArguments:@[@"search"] atDirectory:nil] launchTask:nil];
	NSLog(@"availnames: %@", avaiNamesOutput);
	
}

@end
