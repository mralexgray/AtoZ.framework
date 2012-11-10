//
//  AZApplePrivate.m
//  AtoZ
//
//  Created by Alex Gray on 7/11/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "AZApplePrivate.h"
#import <ApplicationServices/ApplicationServices.h>
extern void _LSCopyAllApplicationURLs(NSArray**);

@implementation AZApplePrivate

+ (AZApplePrivate*) sharedInstance {
	return [super sharedInstance]; 
}

+ (NSA*) registeredApps {
	NSArray *urls;
	_LSCopyAllApplicationURLs(&urls);
	return urls;
}

@end
