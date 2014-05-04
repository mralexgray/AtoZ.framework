//
//  AZHTTPURLProtocol.m
//  AtoZ
//
//  Created by Alex Gray on 11/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//
#import "AtoZUmbrella.h"
#import "AZHTTPURLProtocol.h"

@implementation AZHTTPURLProtocol

+ (BOOL) canInitWithRequest:(NSURLRequest *)request
{
	return [[[request URL] scheme] isEqualToString:@"http"];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
	return request;
}

- (void) startLoading
{

	NSURLREQ* request = self.request;
	id<NSURLProtocolClient> client = self.client;
	NSLog(@"start loading!  request: %@  client: %@", self.request, self.client);

	NSData* data = [NSMutableData dataWithCapacity:0];
	NSHTTPURLResponse* response = [NSHTTPURLResponse.alloc initWithURL:[request URL] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:nil];
	[client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
	[client URLProtocol:self didLoadData:data];
	[client URLProtocolDidFinishLoading:self];

	static NSTimeInterval started;	static NSUInteger counter;	static dispatch_once_t onceToken;	static NSInteger lastLog = 1;

	dispatch_once(&onceToken, ^{		started = [NSDate timeIntervalSinceReferenceDate];	});

	counter++;

	NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - started;
	if (lastLog < ceil(elapsed)) {	lastLog++;   NSLog(@"%g/s", counter / elapsed); }
}

- (void) stopLoading	{	}


@end
