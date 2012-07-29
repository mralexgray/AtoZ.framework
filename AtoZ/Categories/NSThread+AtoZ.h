//
//  NSThread+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (BlocksAdditions)
- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;
+ (void)performBlockInBackground:(void (^)())block;
@end
/*
@interface NSThread (AZBlocks)

+ (void)performAZBlockOnMainThread:(void (^)())block;
+ (void)performAZBlockInBackground:(void (^)())block;
+ (void)runAZBlock:(void (^)())block;
- (void)performAZBlock:(void (^)())block;
- (void)performAZBlock:(void (^)())block waitUntilDone:(BOOL)wait;
- (void)performAZBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end
*/