//
//  AZAXAuthorization.m
//  AtoZ
//
//  Created by Alex Gray on 6/29/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

//#import "AppController.h"
#import <ApplicationServices/ApplicationServices.h>
#import <Security/Security.h>
//#import <AGFoundation/DBXGridView.h>
#import "AZAXAuthorization.h"


OSStatus LaunchPrivilegedProcess(NSString *path) {	AuthorizationRef  authRef;	OSStatus status =
					AuthorizationCreate( NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authRef);
    if (status == 	errAuthorizationSuccess) {
		status = 	AuthorizationExecuteWithPrivileges(
					authRef, [path UTF8String], kAuthorizationFlagDefaults, NULL, NULL);
        			AuthorizationFree(authRef, kAuthorizationFlagDestroyRights);
}	return status; 	}

static bool amIAuthorized () {			bool returner = false;
    if (AXIsProcessTrusted() == 1) { 	NSLog(@"Main App Bundle Trusted!  TRUE"); returner = true; }
		else 							NSLog(@"Main App Bundle ** NOT ** Trusted.  Testing System AX.");
	if (AXAPIEnabled() == 1) { 			NSLog(@"System AX Enabled AOK! ** TRUE **"); returner = true; }
		else 							NSLog(@"System AX is ** NOT ** Enabled.  FALSE!");
/* 	Crap, not trusted. become a root process using authorization services and
	then call AXMakeProcessTrusted() to makeourselves trusted, then restart.. */ 		return returner;
}

//@class DBXApp;
//@implementation AppController

@implementation AZAXAuthorization

@end

