
#import <AtoZ/AtoZ.h>#import <GHUnit/GHUnit.h>
#import <GHUnit/GHTestApp.h>

//void exceptionHandler(NSException *exc) { NSLog(@"%@\n%@",exc.reason, GHUStackTraceFromException(exc)); }
// Default exception handler

int main(int argc, char *argv[]) {
  @autoreleasepool {
  
  // Register any special test case classes
  //[[GHTesting sharedInstance] registerClassName:@"GHSpecialTestCase"];  
  
    int retVal = 0;
    // If GHUNIT_CLI is set we are using the command line interface and run the tests
    // Otherwise load the GUI app
    if (getenv("GHUNIT_CLI")) {
      retVal = [GHTestRunner run];
    } else {
      // To run all tests (from ENV)
      id x = GHTestApp.new;
      // To run a different test suite:
      //GHTestSuite *suite = [GHTestSuite suiteWithTestFilter:@"GHSlowTest,GHAsyncTestCaseTest"];
      //GHTestApp *app = [GHTestApp.alloc initWithSuite:suite];
      // Or set global:
      //GHUnitTest = @"GHSlowTest";
      [(NSApplication*)NSApp run];
    }
    return retVal;
  }
}
	/*!
	 For debugging: "Get Info" for the contextual menu of your (test) executable (in the "Executables" group in the left panel).
	 Then go in the "Arguments" tab. You can add the following environment variables:

	 Default:   	Set to:
	 NSDebugEnabled                        NO       "YES"
	 NSZombieEnabled                       NO       "YES"
	 NSDeallocateZombies                   NO       "YES"
	 NSHangOnUncaughtException             NO       "YES"

	 NSEnableAutoreleasePool              YES       "NO"
	 NSAutoreleaseFreedObjectCheckEnabled  NO       "YES"
	 NSAutoreleaseHighWaterMark             0       non-negative integer
	 NSAutoreleaseHighWaterResolution       0       non-negative integer

	 For info on these varaiables see NSDebug.h; http://theshadow.uw.hu/iPhoneSDKdoc/Foundation.framework/NSDebug.h.html
	 For malloc debugging see: http://developer.apple.com/mac/library/documentation/Performance/Conceptual/ManagingMemory/Articles/MallocDebug.html
	 */

//	NSSetUncaughtExceptionHandler(&exceptionHandler);

//	NSAutoreleasePool *pool = NSAutoreleasePool.new;

	// Register any special test case classes
	//[[GHTesting sharedInstance] registerClassName:@"GHSpecialTestCase"];

 	// If GHUNIT_CLI is set we are using the command line interface and run the test. Otherwise load the GUI app
//	int retVal =	getenv("GHUNIT_CLI") ? GHTestRunner.run : 0;
	// To run all tests (from ENV)
//	YES
//	id app =  YES ?  GHTestApp.new : NO ? [GHTestSuite suiteWithTestFilter:@"GHSlowTest,GHAsyncTestCaseTest"] : NO
//				  NO ? [GHTestApp.alloc initWithSuite:suite]

				 // To run a different test suite:
	// Or set global:
	//GHUnitTest = @"GHSlowTest";
//	[NSApp run];

//}
//[pool drain];
//return retVal;
//}
//
//  main.m
//  AtoZ Entitlement
//
//  Created by Alex Gray on 8/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

//@import AppKit;
//
//int main(int argc, char *argv[])
//{
//	return NSApplicationMain(argc, (const char **)argv);
//}
