//
//  MediaServer.h
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 8/20/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

/*
 * Queued server to manage concurrency and priority of NSURLRequests.
 */

#import <Foundation/Foundation.h>


typedef void (^FetchBlock)(NSArray *items, NSError *error);

@interface MediaServer : NSObject
@property (strong, nonatomic) NSOperationQueue *operationQueue;

+ (id)sharedMediaServer;
- (void)fetchTweetsForSearch:(NSString *)searchString block:(FetchBlock)block;

@end
