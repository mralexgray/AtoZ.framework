
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


//AZOperation is an abstract base class for NSOperations, which can be observed by a delegate and which sends periodic progress notifications.

//AZOperationDelegate defines the interface for delegates.

typedef float AZOperationProgress;
#define AZUnknownTimeRemaining -1

#pragma mark - Notification constants
extern NSString * const AZOperationWillStart;		//	Sent when the operation is about to start.
extern NSString * const AZOperationInProgress;		//	Sent periodically while the operation is in progress.
extern NSString * const AZOperationDidFinish;		//	Sent when the operation ends (be it because of success, failure or cancellation.)
extern NSString * const AZOperationWasCancelled;  	//	Sent when the operation gets cancelled
#pragma mark - Notification user info dictionary keys
extern NSString * const AZOperationContextInfoKey; //	An arbitrary object representing the context for the operation. Included in all notifications, if contextInfo was set.
extern NSString * const AZOperationSuccessKey; 		//	An NSNumber boolean indicating whether the operation succeeded or failed.
																	//	Included with AZOperationFinished.
extern NSString * const AZOperationErrorKey;			//	An NSError containing the details Included with AZOperationFinished if the operation failed.of a failed operation.
extern NSString * const AZOperationProgressKey;		//	An NSNumber float from 0.0 to 1.0 indicating the progress of the operation. Included with AZOperationInProgress.
extern NSString * const AZOperationIndeterminateKey;	//An NSNumber boolean indicating whether the operation cannot currently measure its progress in a meaningful way. Included with AZOperationInProgress.

@protocol AZOperationDelegate;
@interface AZOperation : NSOperation
{
//	__unsafe_unretained id <AZOperationDelegate> _delegate;
//	id _contextInfo;
//	SEL _willStartSelector, _inProgressSelector,_wasCancelledSelector,_didFinishSelector;
//	BOOL _notifiesOnMainThread;
//	NSError *_error;
}

#pragma mark - Configuration properties
//The delegate that will receive notification messages about this operation.
@property (assign) id <AZOperationDelegate> delegate;
//The callback methods that will be called on the delegate for progress notifications.
//These default to AZOperationDelegate operationInProgress:, operationDidFinish: etc.
//and must have the same signatures as those methods.
@property (assign) SEL willStartSelector;
@property (assign) SEL inProgressSelector;
@property (assign) SEL wasCancelledSelector;
@property (assign) SEL didFinishSelector;

//Arbitrary context info for this operation. Included in notification dictionariesfor controlling contexts to use. Note that this is an NSObject and will be retained.
@property (retain) id contextInfo;
//Whether delegate and NSNotificationCenter notifications should be sent on the main thread or on the operation's current thread. Defaults to YES (the main thread).
@property (assign) BOOL notifiesOnMainThread;
#pragma mark Operation status properties
//A float from 0.0f to 1.0f indicating how far through its process the operation is.
@property (readonly) AZOperationProgress currentProgress;
//An estimate of how long remains before the operation completes. Will be 0.0 if the operation has already finished, or AZUnknownTimeRemaining if no estimate can be provided (which usually means isIndeterminate is YES also.)
@property (readonly) NSTimeInterval timeRemaining;
//Indicates whether the process cannot currently provide a meaningful indication of progress (and thus whether the value of currentProgress should be ignored).
//Returns YES by default; intended to be overridden by subclasses that can offer meaningful progress tracking.
@property (readonly, getter=isIndeterminate) BOOL indeterminate;
//Whether the operation has succeeeded or failed: only applicable once the operation finishes, though it can be called at any time.
//In the base implementation, this will return NO if the operation has generated an error, or YES otherwise (even if the operation has not yet finished.)
//This can be overridden by subclasses.
@property (readonly) BOOL succeeded;
//Any showstopping error that occurred when performing the operation. If this is set, succeeded will be NO.
@property (retain) NSError *error;
@end


#pragma mark - Protected method declarations

//These methods are for the use of AZOperation subclasses only.
@interface AZOperation ()
//Post one of the corresponding notifications.
- (void) _sendWillStartNotificationWithInfo: (NSDictionary *)info;
- (void) _sendInProgressNotificationWithInfo: (NSDictionary *)info;
- (void) _sendWasCancelledNotificationWithInfo: (NSDictionary *)info;
- (void) _sendDidFinishNotificationWithInfo: (NSDictionary *)info;

//Shortcut method for sending a notification both to the default notification center and to a selector on our delegate. The object of the notification will be self.
- (void) _postNotificationName: (NSString *)name
			  delegateSelector: (SEL)selector
					  userInfo: (NSDictionary *)userInfo;
@end

@protocol OperationsRunnerProtocol;
typedef enum { msgDelOnMainThread, msgDelOnAnyThread, msgOnSpecificThread } msgType;
@interface OperationsRunner : NSObject
@property (nonatomic, assign) msgType msgDelOn;			// how to message delegate
@property (nonatomic, assign) NSThread *delegateThread;	// how to message delegate
@property (nonatomic, assign) BOOL noDebugMsgs;			// suppress debug messages
@property (nonatomic, assign) long priority;			// targets the internal GCD queue doleing out the operations
@property (nonatomic, assign) NSUInteger maxOps;		// set the NSOperationQueue's maxConcurrentOperationCount

- (id)initWithDelegate:(id <OperationsRunnerProtocol>)del;

- (void)runOperation:(NSOperation *)op withMsg:(NSString *)msg;	// all messages must be sent from the same thread

- (NSSet *)operationsSet;
- (NSUInteger)operationsCount;

- (void)cancelOperations;
- (void)enumerateOperations:(void(^)(NSOperation *op)) b;

@end

#if 0 

// 1) Add either a property or an ivar to the implementation file
OperationsRunner *operationsRunner;

// 2) Add the protocol to the class extension interface (often in the interface file)
@interface MyClass () <OperationsRunnerProtocol>

// 3) Add the header to the implementation file
#import "OperationsRunner.h"

// 4) Add this method to the implementation file (I put it at the bottom, could go into a category too)
- (id)forwardingTargetForSelector:(SEL)sel
{
	if(
		sel == @selector(runOperation:withMsg:)	|| 
		sel == @selector(operationsSet)			|| 
		sel == @selector(operationsCount)		||
		sel == @selector(enumerateOperations:)
	) {
		if(!operationsRunner) {
			// Object only created if needed
			operationsRunner = [OperationsRunner.alloc initWithDelegate:self];
		}
		return operationsRunner;
	} else {
		return [super forwardingTargetForSelector:sel];
	}
}

// 5) Add the cancel to your dealloc (or the whole dealloc if you have none now)
- (void)dealloc
{
	[operationsRunner cancelOperations];
}

// 6) Declare a category with these methods in the interface or implementation file (change MyClass to your class)
@interface MyClass (OperationsRunner)
- (void)runOperation:(NSOperation *)op withMsg:(NSString *)msg;

- (NSSet *)operationsSet;
- (NSUInteger)operationsCount;

- (void)enumerateOperations:(void(^)(NSOperation *op))b;

@end

#endif
