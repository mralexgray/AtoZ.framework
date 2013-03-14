//
//  main.m
//  AZCLI
//
//  Created by Alex Gray on 12/3/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>






int main(int argc, const char * argv[])
{
	NSRunLoop   * runLoop;
//	AZHomeBrew     * main; // replace with desired class

	@autoreleasepool
	{
		// create run loop
		runLoop = NSRunLoop.currentRunLoop;
//		main    = AZHomeBrew.instance; // replace with init method


		// enter run loop
//		while((!(main.shouldExit)) && (([runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]])));

	AZRUNFOREVER;
	}
	return 0;//(main.exitCode);
}
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
