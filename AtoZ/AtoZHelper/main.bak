//
//  main.m
//  AZCLI
//
//  Created by Alex Gray on 12/3/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AtoZ/AtoZ.h>
//- (NSMA*)needUpdate
//{
//	return _needUpdate = _needUpdate ?:
//		[_installed each:^(id obj) {
//
//		[[CWTask.alloc initWithExecutable:BREWPATH      andArguments:@[@"list"] atDirectory:nil]
//						launchTaskOnQueue:AZSSOQ withCompletionBlock:^(NSS *outP, NSError*e){
//			self.installed = [[outP componentsSeparatedByString:@"\n"]arrayByRemovingLastObject].mutableCopy;
//		}];
//	}
//	return _installed;
//}

//@end

int main(int argc, const char * argv[])
{
	NSRunLoop   * runLoop;
	AZHomeBrew     * main; // replace with desired class

	@autoreleasepool
	{
		// create run loop
		runLoop = NSRunLoop.currentRunLoop;
		main    = AZHomeBrew.instance; // replace with init method
		[main.available logEachPropertiesPlease];
		[main.outdated logEachPropertiesPlease];



		NSS* avaiNamesOutput = [[CWTask.alloc initWithExecutable:@"/usr/local/bin/brew" andArguments:@[@"search"] atDirectory:nil] launchTask:nil];
		NSLog(@"availnames: %@", avaiNamesOutput);
		

		[main addObserver:runLoop keyPath:@"installed" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
			// kick off object, if required
			[main.installed logEachPropertiesPlease];
			main.exitCode = !main.installed ? 99 : 0;
//			main.shouldExit = YES;
		}];
		[main addObserver:runLoop keyPath:@"outdated" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
			NSLog(@"out:%@", main.outdated);
		}];
		// enter run loop
		while((!(main.shouldExit)) && (([runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]])));

	};
	return(main.exitCode);
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
