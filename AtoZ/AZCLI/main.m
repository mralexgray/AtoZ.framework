//
//  main.m
//  AZCLI
//
//  Created by Alex Gray on 12/3/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>
#import "AZHTTPRouter.h"
#import "AZFacebookConnection.h"

NSW * win() { NSW* 	w = [NSW.alloc initWithContentRect:AZRectFromDim(300) styleMask:NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
							 			w.contentView		= [	AZSimpleView withFrame:w.frame color:LINEN  ];
									[	w setMovableByWindowBackground: 	YES ];								return w;	}


int main(int c, const char* v [] ) { @autoreleasepool {	NSApplication.sharedApplication;

	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

	NSMenu *menubar = NSMenu.new;		NSMenuItem *app = NSMenuItem.new;		[menubar  addItem:app];

	[NSApp 	 setMainMenu:menubar];							app.submenu  = NSMenu.new;
	[app.submenu addItem: [NSMenuItem.alloc 		initWithTitle: $(@"Quit %@", AZPROCNAME)
							  action: @selector(terminate:) keyEquivalent: @"q"]];

	WebView *z = 				[WebView.alloc initWithFrame:				AZRectFromDim(200)];
	NSW			*w = win();
											[w 				 cascadeTopLeftFromPoint: AZPointFromDim(40)];

											[w.contentView 				 setSubviews: @[z]];
											[NSApp   activateIgnoringOtherApps:	 YES];
											[w 						makeKeyAndOrderFront:	 nil];

	AZHTTPRouter	 *r = AZHTTPRouter.new;
											r.documentRoot = @"/www";									[r start];

	AZFacebookConnection	*f =	AZFacebookConnection.sharedInstance;

[NSApp run]; 	return 0;  }	}     // (main.exitCode)


//	NSRunLoop   		* runLoop;
//	AZHTTPRouter		* main; // replace with desired class
//
//	@autoreleasepool
//	{
//		// create run loop
//		runLoop = NSRunLoop.currentRunLoop;
//		main    = AZHTTPRouter.alloc.init; // replace with init method
//
//		// kick off object, if required
//		[main start];
//		NSLog(@"%@", main.propertiesPlease);
//		// enter run loop
//		while ( !main.shouldExit ) [NSRunLoop.mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
//
//
//		AZLOG(@"Im still here!");
//
////		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
////		while((!(main.shouldExit)) && (([runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]])));
//
//	};
//
//static AZFacebookConnection *fb 	= nil;
//
//
//int main(int argc, const char * argv[])
//{
//	NSRunLoop   		*runLoop;
//	AZHTTPRouter	 	*main;		  								//	replace with desired class
//
//	@autoreleasepool
//	{
//		runLoop = NSRunLoop.currentRunLoop; 		// create run loop
//		main    = AZHTTPRouter.new; 						// replace with init method
//																						// enter run loop
////	while ( main && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]] );
//		{
//
//		AZRUNFOREVER;
//
//
//
//		}
//	return 0;	// (main.exitCode);
//	}
//}
/**

int main(int argc, const char * argv[])
{

	@autoreleasepool {
	
		NSTimer *timer = [NSTimer.alloc initWithFireDate:NSDate.new
			  interval:.05	target:obj  selector:@selector(startIt:)
			    userInfo:nil   repeats:YES];

		NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
		[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
		[runLoop run];

		__block BOOL finished = NO;
		CWTask *y = [CWTask.alloc initWithExecutable:@"/bin/ls" andArguments:@[@"/Users/localadmin"]
										 atDirectory:nil];
		TaskCompletionBlock j = ^{
			NSLog(@"settting task finito");
			finished = YES;
		};
		y.completionBlock = j;
		[y launchTaskOnQueue:AZSharedSingleOperationQueue()
			withCompletionBlock:^(NSString *output, NSError *error){
				 NSLog(@"%@", output)
				 finished = YES;
		}];
//		while (!finished) sleep(1);

//		NSS* i = [y launchTask:nil];
//		NSLog(@"task:%@", i);
//		[NSThread.mainThread performBlock:^{
//			[y launchTaskOnQueue:AZSharedSingleOperationQueue()
//			 withCompletionBlock:^(NSS *output, NSError *error){
//				 NSLog(@"%@", output)
//			 }];
//		}waitUntilDone:YES];

	}
//    return 0;
}

*/


