
// NSOperation-WebFetches-MadeEasy (TM)
// Copyright (C) 2012 by David Hoerl
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ConcurrentOperation.h"

@interface ConcurrentOperation ()
@property(atomic, assign) BOOL executing;
@property(atomic, assign) BOOL finished;
@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic, strong, readwrite) NSThread *thread;

- (void)timer:(NSTimer *)t; // kch
- (void)finish;

@end

@implementation ConcurrentOperation
@synthesize executing;
@synthesize finished;
@synthesize timer;
@synthesize thread;

- (BOOL)isExecuting { return executing; }
- (BOOL)isFinished { return finished; }
- (BOOL)isConcurrent { return YES; }

- (void)start
{
	BOOL isCancelled = [self isCancelled];
	if(isCancelled) {
		// NSLog(@"OPERATION CANCELLED: isCancelled=%d isHostUp=%d", isCancelled, isHostUDown);
		[self willChangeValueForKey:@"isFinished"];
		finished = YES;
		[self didChangeValueForKey:@"isFinished"];
		return;
	}

	@autoreleasepool {
		// do this first, to enable future messaging - 
		[self willChangeValueForKey:@"isExecuting"];
		executing = YES;	// KVO
		[self didChangeValueForKey:@"isExecuting"];

		BOOL allOK = [self setup];

		if(allOK) {
			while(![self isFinished]) {
#ifndef NDEBUG
				BOOL ret = 
#endif
					[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
				assert(ret && "first assert");
			}
		} else {
			[self finish];
		}
		[self cleanup];
	}
}

- (BOOL)setup
{
	thread	= [NSThread currentThread];	

	// makes runloop functional
	timer	= [NSTimer scheduledTimerWithTimeInterval:60*60 target:self selector:@selector(timer:) userInfo:nil repeats:NO];	

	return YES;
}

- (void)cleanup
{
	[timer invalidate], timer = nil;
	
	return;
}

- (void)cancel
{
	[super cancel];
	
	if([self isExecuting]) {
		[self performSelector:@selector(finish) onThread:thread withObject:nil waitUntilDone:NO];
	}
}

- (void)finish
{
	[self willChangeValueForKey:@"isFinished"];
	[self willChangeValueForKey:@"isExecuting"];

    executing = NO;
    finished = YES;

    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)timer:(NSTimer *)t
{
	// Keep Compiler Happy - this never gets called
}

- (void)completed // subclasses to override then finally call super
{
	// we need a tad delay to let the completed return before the KVO message kicks in
	[self performSelector:@selector(finish) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)failed // subclasses to override then finally call super
{
	[self finish];
}

- (void)dealloc
{
	NSLog(@"Concurrent Operation Dealloc");
}

@end

