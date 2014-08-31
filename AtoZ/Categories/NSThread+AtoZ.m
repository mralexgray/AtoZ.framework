//
//  NSThread+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>
#import "NSThread+AtoZ.h"


@implementation NSBlockOperation(Completion)

- (void) setCompletionBlockInCurrentThread:(void (^)(void))block { dispatch_queue_t queue = dispatch_get_current_queue();

	self.completionBlock = ^(void) { dispatch_get_current_queue() == queue ? block() : dispatch_sync(queue, block); };
}
@end

@implementation  NSThread (AtoZ)

+ (void) stackTrace                   {

	NSArray *syms = [[self class] callStackSymbols];
	if ([syms count] > 1) {
		NSLog(@"<%@ %p> %@ - caller: %@ ", [self class], self, NSStringFromSelector(_cmd),[syms objectAtIndex:1]);
	} else {
		NSLog(@"<%@ %p> %@", [self class], self, NSStringFromSelector(_cmd));
	}
}
+ (void) stackTraceAtIndex:(NSUI)idx  {

	NSArray *syms = [self.class callStackSymbols];
	syms.count > 1 ? NSLog(@"<%@ %p> %@ - caller: %@ ", self.class, self, NSStringFromSelector(_cmd),syms[idx])
                 : NSLog(@"<%@ %p> %@", self.class, self, NSStringFromSelector(_cmd));
}

@end

@implementation NSThread (BlocksAdditions)

+ (void)                 runBlock:(void(^)())blk  {	blk(); }
- (void)             performBlock:(void(^)())blk  {

	[[NSThread currentThread] isEqual:self] ? blk() : [self performBlock:blk waitUntilDone:NO];
}
+ (void) performBlockInBackground:(void(^)())blk  {
	[NSThread performSelectorInBackground:NSSelectorFromString(@"runBlock:")
							               withObject:[[blk copy] autorelease]];
}
- (void) performBlockOnMainThread:(void(^)())blk  {
	[NSThread.mainThread performBlock:blk];
}
- (void)             performBlock:(void(^)())blk
                       afterDelay:(NSTI)delay     {

	[self performSelector:NSSelectorFromString(@"performBlock:") withObject:[[blk copy] autorelease] afterDelay:delay];
}
- (void)             performBlock:(void(^)())blk
                    waitUntilDone:(BOOL)wait      {

	[NSThread performSelector:NSSelectorFromString(@"runBlock:") onThread:self withObject:[[blk copy] autorelease] waitUntilDone:wait];
}

@end

/*
@implementation NSThread (AZBlocks)

+ (void)performAZBlockOnMainThread:(void (^)())block {
	[NSThread.mainThread performAZBlock:block];
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
