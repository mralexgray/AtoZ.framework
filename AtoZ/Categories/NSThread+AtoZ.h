//
//  NSThread+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

@import AtoZUniversal;

@interface NSBlockOperation(Completion)
- (void) setCompletionBlockInCurrentThread:(void (^)(void))block;
@end

@interface NSThread (BlocksAdditions)
- _Void_ performBlock:(void (^)())block;
- _Void_ performBlock:(void (^)())block waitUntilDone:(BOOL)wait;
+ (void)performBlockInBackground:(void (^)())block;

+ (void)runBlock:(void (^)())block;
- _Void_ performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end

@interface NSThread (AtoZ)

+ (void) stackTrace;
+ (void) stackTraceAtIndex:(NSUI)index;
@end
/*
@interface NSThread (AZBlocks)

+ (void)performAZBlockOnMainThread:(void (^)())block;
+ (void)performAZBlockInBackground:(void (^)())block;
+ (void)runAZBlock:(void (^)())block;
- _Void_ performAZBlock:(void (^)())block;
- _Void_ performAZBlock:(void (^)())block waitUntilDone:(BOOL)wait;
- _Void_ performAZBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
*/
