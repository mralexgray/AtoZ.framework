//
//  AZAppDelegate.m
//  DockBox
//
//  Created by Alex Gray on 3/15/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "DockBox.h"
#import <AtoZ/AtoZ.h>

@implementation DockBox

//NSW * win() { NSW* 	w = [NSW.alloc initWithContentRect:AZRectFromDim(300) styleMask:NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
//	w.contentView		= [	AZSimpleView withFrame:w.frame color:LINEN  ];
//	[	w setMovableByWindowBackground: 	YES ];								return w;	}


-( void) awakeFromNib
{

	_router.documentRoot = @"/www";
	[_router start];

	NSURLREQ *req = [NSURLREQ requestWithURL:$URL($(@"%@:%u/colorchart/",_router.baseURL, _router.port))];
	[_webView.mainFrame loadRequest:req];
	NSLog(@"Requesting url from webview %@", req.URL);

	[_window setBackgroundColor:RED];

	_ab = [AZAddressBook new];
	NSLog(@"%@ Records", ((AZContact*)_ab.contacts[2]).image);

	
//	[_webView.mainFrame

}


//	b(nil,z);


- (IBAction)getFB:(id)sender {
	_fb = [AZFacebookConnection initWithQuery:@"me/posts" param:@"message" thenDo:^(NSString *text) {
	
//		[_window.contentView addSubview:
//		 [NSTextView textViewForFrame: _window.frame withString:[text.mutableCopy attributedWithFont:AtoZ.controlFont andColor:RANDOMCOLOR]]];
	}];
}

- (IBAction)getColorList:(id)sender {
	[GoogleSpeechAPI recognizeSynthesizedText:[NSS dicksonParagraphWith:10] completion:^(NSS *s) {
//		[NSThread.mainThread pe  [_webView.mainFrame loadHTMLString:s baseURL:$URL(_router.baseURL)];
//		[NSTextView textViewForFrame: [w convertRectFromScreen:w.frame] withString:[s.mutableCopy attributedWithFont:AtoZ.controlFont andColor:RANDOMCOLOR]]];
		AZLOG($(@"The sentence was: %@ and the response ", s));
	}];

}
@end

//int main(int c, const char* v [] ) { @autoreleasepool {	NSApplication.sharedApplication;
//
//	[NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
//
//	NSMenu *menubar = NSMenu.new;		NSMenuItem *app = NSMenuItem.new;		[menubar  addItem:app];
//
//	[NSApp 	 setMainMenu:menubar];							app.submenu  = NSMenu.new;
//	[app.submenu addItem: [NSMenuItem.alloc 		initWithTitle: $(@"Quit %@", AZPROCNAME)
//																	 action: @selector(terminate:) keyEquivalent: @"q"]];

//	WebView *z = 				[WebView.alloc initWithFrame:				AZRectFromDim(200)];
//	NSW			*w = win();
//	[w 				 cascadeTopLeftFromPoint: AZPointFromDim(40)];
//
//	[w.contentView 				 setSubviews: @[z]];
//	[NSApp   activateIgnoringOtherApps:	 YES];
//	[w 						makeKeyAndOrderFront:	 nil];


//	[NSApp run]; 	return 0;  }	}     // (main.exitCode)


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

