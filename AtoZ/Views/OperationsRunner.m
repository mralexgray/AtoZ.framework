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

#define LOG NSLog

#import "OperationsRunner.h"
#import "OperationsRunnerProtocol.h"
#import "WebFetcher.h"

#pragma mark - Notification constants and keys

NSString * const AZOperationWillStart		= @"AZOperationWillStart";
NSString * const AZOperationDidFinish		= @"AZOperationDidFinish";
NSString * const AZOperationInProgress		= @"AZOperationInProgress";
NSString * const AZOperationWasCancelled	= @"AZOperationWasCancelled";

NSString * const AZOperationContextInfoKey	= @"AZOperationContextInfoKey";
NSString * const AZOperationSuccessKey		= @"AZOperationSuccessKey";
NSString * const AZOperationErrorKey		= @"AZOperationErrorKey";
NSString * const AZOperationProgressKey		= @"AZOperationProgressKey";
NSString * const AZOperationIndeterminateKey	= @"AZOperationIndeterminateKey";


@implementation AZOperation
@synthesize delegate = _delegate;
@synthesize contextInfo = _contextInfo;
@synthesize notifiesOnMainThread = _notifiesOnMainThread;
@synthesize error = _error;
@synthesize willStartSelector = _willStartSelector;
@synthesize wasCancelledSelector = _wasCancelledSelector;
@synthesize inProgressSelector = _inProgressSelector;
@synthesize didFinishSelector = _didFinishSelector;

- (id) init
{
    self = [super init];
	if (self)
	{
        self.notifiesOnMainThread = YES;
        self.willStartSelector = @selector(operationWillStart:);
        self.inProgressSelector = @selector(operationInProgress:);
        self.wasCancelledSelector = @selector(operationWasCancelled:);
        self.didFinishSelector = @selector(operationDidFinish:);
	}
	return self;
}

- (void) dealloc
{
    self.delegate = nil;
    self.contextInfo = nil;
    self.error = nil;
}

- (void) start
{
    [self _sendWillStartNotificationWithInfo: nil];
    [super start];
    [self _sendDidFinishNotificationWithInfo: nil];
}

- (void) cancel
{	
	//Only send a notification the first time we're cancelled,
	//and only if we're in progress when we get cancelled
	if (!self.isCancelled && self.isExecuting)
	{
		[super cancel];
		if (!self.error)
		{
			//If we haven't encountered a more serious error, set the error to indicate that this operation was cancelled.
            self.error = [NSError errorWithDomain: NSCocoaErrorDomain
                                             code: NSUserCancelledError
                                         userInfo: nil];
		}
		[self _sendWasCancelledNotificationWithInfo: nil];
	}
	else [super cancel];
}

- (BOOL) succeeded
{
    return !self.error;
}

//The following are meant to be overridden by subclasses to provide more meaningful progress tracking.
- (AZOperationProgress) currentProgress
{
	return 0.0f;
}

+ (NSSet *) keyPathsForValuesAffectingTimeRemaining
{
	return [NSSet setWithObjects: @"currentProgress", @"isFinished", nil];
}

- (NSTimeInterval) timeRemaining
{
	return self.isFinished ? 0.0 : AZUnknownTimeRemaining;
}

- (BOOL) isIndeterminate
{
	return YES;
}


#pragma mark - Notifications

- (void) _sendWillStartNotificationWithInfo: (NSDictionary *)info
{
	//Don't send start notifications if we're already cancelled
	if (self.isCancelled) return;

	[self _postNotificationName: AZOperationWillStart
			   delegateSelector: self.willStartSelector
	 				   userInfo: info];
}

- (void) _sendWasCancelledNotificationWithInfo: (NSDictionary *)info
{
	[self _postNotificationName: AZOperationWasCancelled
			   delegateSelector: self.wasCancelledSelector
					   userInfo: info];
}

- (void) _sendDidFinishNotificationWithInfo: (NSDictionary *)info
{
	NSMutableDictionary *finishInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   @(self.succeeded), AZOperationSuccessKey,
									   self.error, AZOperationErrorKey,
									   nil];

	if (info)
        [finishInfo addEntriesFromDictionary: info];

	[self _postNotificationName: AZOperationDidFinish
			   delegateSelector: self.didFinishSelector
					   userInfo: finishInfo];
}

- (void) _sendInProgressNotificationWithInfo: (NSDictionary *)info
{
	//Don't send progress notifications if we're already cancelled
	if (self.isCancelled) return;

	NSMutableDictionary *progressInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										 @(self.currentProgress), AZOperationProgressKey,
										 @(self.isIndeterminate), AZOperationIndeterminateKey,
										 nil];
	if (info)
        [progressInfo addEntriesFromDictionary: info];

	[self _postNotificationName: AZOperationInProgress
			   delegateSelector: self.inProgressSelector
					   userInfo: progressInfo];
}


- (void) _postNotificationName: (NSString *)name
			  delegateSelector: (SEL)selector
					  userInfo: (NSDictionary *)userInfo
{
	//Extend the notification dictionary with context info
	if (self.contextInfo)
	{
		NSMutableDictionary *contextDict = [NSMutableDictionary dictionaryWithObject: self.contextInfo
																			  forKey: AZOperationContextInfoKey];
		if (userInfo)
            [contextDict addEntriesFromDictionary: userInfo];
		userInfo = contextDict;
	}

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	NSNotification *notification = [NSNotification notificationWithName: name
																 object: self
															   userInfo: userInfo];

	if ([(NSO*)self.delegate respondsToSelector: selector])
	{
		if (self.notifiesOnMainThread)
			[(id)self.delegate performSelectorOnMainThread: selector withObject: notification waitUntilDone: NO];
		else
			[(NSO*)self.delegate performSelectorWithoutWarnings:selector withObject: notification];
	}

//	if (self.notifiesOnMainThread)
//		[center performSelectorOnMainThread: @selector(postNotification:) withObject: notification waitUntilDone: NO];		
//	else
		[center postNotification: notification];
}

@end


static char *opContext = "opContext";

@implementation OperationsRunner
{
	NSOperationQueue						*queue;
	NSMutableSet							*operations;
	dispatch_queue_t						operationsQueue;
	__weak id <OperationsRunnerProtocol>	delegate;
	long									_priority;
}
@synthesize msgDelOn;						// default is msgDelOnMainThread
@synthesize delegateThread;
@synthesize noDebugMsgs;
@dynamic priority;

- (id)initWithDelegate:(id <OperationsRunnerProtocol>)del
{
	if((self = [super init])) {
		delegate	= del;
		queue		= [NSOperationQueue new];
		
		operations	= [NSMutableSet setWithCapacity:10];
		operationsQueue = dispatch_queue_create("com.lot18.operationsQueue", DISPATCH_QUEUE_SERIAL);
	}
	return self;
}
- (void)dealloc
{
	[self cancelOperations];
	
	dispatch_release(operationsQueue);
}

- (long)priority
{
	return _priority;
}
- (void)setPriority:(long)priority
{
	if(_priority != priority) {
		// keep this around while in development
		switch(priority) {
		case DISPATCH_QUEUE_PRIORITY_HIGH:
		case DISPATCH_QUEUE_PRIORITY_DEFAULT:
		case DISPATCH_QUEUE_PRIORITY_LOW:
		case DISPATCH_QUEUE_PRIORITY_BACKGROUND:
			_priority = priority;
			break;
		default:
			assert(!"Invalid Priority Value");
			return;
		}
		
		dispatch_set_target_queue(operationsQueue, dispatch_get_global_queue(_priority, 0));
	}
}

- (NSUInteger)maxOps
{
	return queue.maxConcurrentOperationCount;
}
- (void)setMaxOps:(NSUInteger)maxOps
{
	queue.maxConcurrentOperationCount = maxOps;
}

- (void)runOperation:(NSOperation *)op withMsg:(NSString *)msg
{
#ifndef NDEBUG
	if(!noDebugMsgs) LOG(@"Run Operation: %@", msg);
	if([op isKindOfClass:[WebFetcher class]]) {
		WebFetcher *fetcher = (WebFetcher *)op;
		fetcher.runMessage = msg;
	}
#endif

	dispatch_async(operationsQueue, ^
		{
			[op addObserver:self forKeyPath:@"isFinished" options:0 context:opContext];	// First, observe isFinished
			[operations addObject:op];	// Second we retain and save a reference to the operation
			[queue addOperation:op];	// Lastly, lets get going!
		} );
}

-(void)cancelOperations
{
	//LOG(@"OP cancelOperations");
	// if user waited for all data, the operation queue will be empty.
	dispatch_sync(operationsQueue, ^	// MUST BE SYNC
		{
			//[operations enumerateObjectsUsingBlock:^(id obj, BOOL *stop) { [obj removeObserver:self forKeyPath:@"isFinished" context:opContext]; }];
			[operations enumerateObjectsUsingBlock:^(NSOperation *op, BOOL *stop)
				{
					[op removeObserver:self forKeyPath:@"isFinished" context:opContext];
				}];
			[operations removeAllObjects];
		} );

	[queue cancelAllOperations];
	[queue waitUntilAllOperationsAreFinished];
}

- (void)enumerateOperations:(void(^)(NSOperation *op))b
{
	//LOG(@"OP enumerateOperations");
	dispatch_sync(operationsQueue, ^
		{
			[operations enumerateObjectsUsingBlock:^(NSOperation *operation, BOOL *stop)
				{
					b(operation);
				}];   
		} );
}

- (void)operationDidFinish:(NSOperation *)operation
{
	//LOG(@"OP operationDidFinish");

	// if you cancel the operation when its in the set, will hit this case
	// since observeValueForKeyPath: queues this message on the main thread
	__block BOOL containsObject;
	dispatch_sync(operationsQueue, ^
		{
			containsObject = [operations containsObject:operation];
		} );
	if(!containsObject) return;
	
	// User cancelled
	if(operation.isCancelled) return;

	//LOG(@"OP RUNNER GOT A MESSAGE %d for thread %@", msgDelOn, delegateThread);

	switch(msgDelOn) {
	case msgDelOnMainThread:
		//dispatch_async(dispatch_get_main_queue(), ^{ [delegate operationFinished:operation]; } );
		[self performSelectorOnMainThread:@selector(_operationFinished:) withObject:operation waitUntilDone:NO];
		break;

	case msgDelOnAnyThread:
		[self _operationFinished:operation];
		break;
	
	case msgOnSpecificThread:
		[self performSelector:@selector(_operationFinished:) onThread:delegateThread withObject:operation waitUntilDone:NO];
		break;
	}
}

- (void)operationFinished:(NSOperation *)op
{
	assert(!"Should never happen!");
}

- (void)_operationFinished:(NSOperation *)op
{
	//LOG(@"_operationFinished: ENTER");
	__block BOOL isCancelled = NO;
	dispatch_sync(operationsQueue, ^
		{
			// Need to see if while this sat in the designated thread, it was cancelled
			isCancelled = ![operations containsObject:op];
			if(!isCancelled) {
				// If we are in the queue, then we have to remove our stuff, and in all cases make sure no KVO enabled
				[op removeObserver:self forKeyPath:@"isFinished" context:opContext];
				[operations removeObject:op];
			}
		} );
	
	//LOG(@"_operationFinished: FINISH isCancelled=%d", isCancelled);
	if(!isCancelled) {
		[delegate operationFinished:op];
	}
}

- (NSSet *)operationsSet
{
	__block NSSet *set;
	dispatch_sync(operationsQueue, ^
		{
			set = [NSSet setWithSet:operations];
		} );
	return set;
}
- (NSUInteger)operationsCount
{
	__block NSUInteger count;
	dispatch_sync(operationsQueue, ^
		{
			count = [operations count];
		} );
	return count;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	//LOG(@"observeValueForKeyPath %s %@", context, self);
	NSOperation *op = object;
	if(context == opContext) {
		//LOG(@"KVO: isFinished=%d %@ op=%@", op.isFinished, NSStringFromClass([self class]), NSStringFromClass([op class]));
		if(op.isFinished == YES) {
			// we get this on the operation's thread
			[self operationDidFinish:op];
		} else {
			//LOG(@"NSOperation starting to RUN!!!");
		}
	} else {
		if([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)])
			[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

@end