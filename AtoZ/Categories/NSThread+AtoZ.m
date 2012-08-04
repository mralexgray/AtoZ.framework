//
//  NSThread+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "NSThread+AtoZ.h"

@implementation NSThread (BlocksAdditions)


+ (void)performBlockInBackground:(void (^)())block {
	[NSThread performSelectorInBackground:@selector(runBlock:)
	                           withObject:[[block copy] autorelease]];
}
- (void)performBlockOnMainThread:(void (^)())block {
	[[NSThread mainThread] performBlock:block];
}
+ (void)runBlock:(void (^)())block{
	block();
}
- (void)performBlock:(void (^)())block{

	if ([[NSThread currentThread] isEqual:self])
        block();
	else
        [self performBlock:block waitUntilDone:NO];
}
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait{

	[NSThread performSelector:@selector(runBlock:)
					 onThread:self
				   withObject:[[block copy] autorelease]
				waitUntilDone:wait];
}
- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{

	[self performSelector:@selector(performBlock:)
			   withObject:[[block copy] autorelease]
               afterDelay:delay];
}

@end
/*
@implementation NSThread (AZBlocks)

+ (void)performAZBlockOnMainThread:(void (^)())block {
	[[NSThread mainThread] performAZBlock:block];
}

+ (void)performAZBlockInBackground:(void (^)())block{
	[NSThread performSelectorInBackground:@selector(runAZBlock:)
                               withObject:[block copy]]; //autorelease]];
}

+ (void)runAZBlock:(void (^)())block{
	block();
}


- (void)performAZBlock:(void (^)())block{

	if ([[NSThread currentThread] isEqual:self])
        block();
	else
        [self performAZBlock:block waitUntilDone:NO];
}
- (void)performAZBlock:(void (^)())block waitUntilDone:(BOOL)wait{

	[NSThread performSelector:@selector(runAZBlock:)
					 onThread:self
				   withObject:[block copy]// autorelease]
				waitUntilDone:wait];
}

- (void)performAZBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{

	[self performSelector:@selector(performAZBlock:)
			   withObject:[block copy]// autorelease]
               afterDelay:delay];
}
@end
*/
