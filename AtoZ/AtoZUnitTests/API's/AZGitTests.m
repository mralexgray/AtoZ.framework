//
//  AZGoogleImagesTests.m
//  AtoZ
//
//  Created by Alex Gray on 10/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface 			AZGitTests : XCTestCase @end

@implementation 	AZGitTests


- (void) testGitUsername	{

	NSString* user = AZGit.lookupUsername;
	XCTAssertTrue((SameString(user, @"alex@mrgray.com")||SameString(user, @"mralexgray")),
		@" username should equal my user. instead got %@", user);
}

- (void) testCommandlineCall {

	NSString *extip = WANIP(), *anotherWay = taskWithPathAndArgs(@"/sd/UNIX/bin/extip",nil);
	       XX(extip);        XX(anotherWay);
	XX(StringFromBOOL(SameString(extip,anotherWay)));
	XCTAssertTrue(SameString(extip, anotherWay), @" external IP addresses should match. %@ vs %@", extip, anotherWay);
}
- (void) testGitPath {

	NSString* git = AZGit.gitPath;
	XCTAssertTrue(SameString(git, @"/usr/bin/git"), @"should find git Path, found %@", git);
}
@end
