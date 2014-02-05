//
//  MediaServer.m
//  QueuedHTTPClientSample
//
//  Created by David Sklenar on 8/20/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//
#import "AtoZ.h"

#import "MediaServer.h"
#import "AtoZModels.h"

#define DEFAULT_TIMEOUT        120.0f
#define SEARCH_RESULTS_PER_TAG 20

@implementation MediaServer

#pragma mark - API

+ (id)sharedMediaServer;
{
    static dispatch_once_t onceToken;
    static id sharedMediaServer = nil;
    dispatch_once(&onceToken, ^{           sharedMediaServer = [self new];  });
    return sharedMediaServer;
}

- (void)fetchTweetsForSearch:(NSString *)searchString block:(FetchBlock)block;
{
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSError *error                          = nil;
        NSHTTPURLResponse *response = nil;

        NSS *encodedSearchString        = [searchString urlEncoded];        // stringWithURLEncoding];
        NSS *URLString    = $(@"http://search.twitter.com/search.json?q=%@&rpp=%i&include_entities=true&result_type=mixed", encodedSearchString, SEARCH_RESULTS_PER_TAG);
        NSURLRequest *request        = [NSURLRequest requestWithURL:$URL(URLString) cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:DEFAULT_TIMEOUT];
        NSData *data        = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSD *JSON        = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        // Serialize JSON response into lightweight Tweet objects for convenience.
        NSA *tweetObjects       = [JSON[@"results"] map:^id (NSD *tweetDictionary) {
                return [Tweet.alloc initWithJSON:tweetDictionary];
            }];
        NSLog(@"Search for '%@' returned %lu results.", searchString, tweetObjects.count);
        // Return to the main queue once the request has been processed.
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
                error ? block(nil, error) : block(tweetObjects, nil);
            }];
    }];
    // Optionally, set the operation priority. This is useful when flooding the operation queue with different requests.
    [operation setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [self.operationQueue addOperation:operation];
}

- (id)init;
{
    if (!(self = [super init]) ) return nil;
    // The maxConcurrentOperationCount should reflect the number of open
    // connections the server can handle. Right now, limit it to two for the sake of this example.
    _operationQueue = NSOperationQueue.new;
    _operationQueue.maxConcurrentOperationCount = 2;
    return self;
}

@end
