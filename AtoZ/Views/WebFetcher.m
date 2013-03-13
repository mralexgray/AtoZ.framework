
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

#import "WebFetcher.h"

// If you have some means to report progress
#define PROGRESS_OFFSET 0.25f
#define PROGRESS_UPDATE(x) ( ((x)*.75f)/(responseLength) + PROGRESS_OFFSET)

@interface WebFetcher ()
@property(nonatomic, strong, readwrite) NSURLConnection *connection;
@property(nonatomic, strong, readwrite) NSMutableData *webData;

@end

@implementation WebFetcher
{
	NSUInteger responseLength;
}
@synthesize urlStr;
@synthesize runMessage;
@synthesize connection;
@synthesize webData;
@synthesize error;
@synthesize errorMessage;
@synthesize request;
@synthesize htmlStatus;
#ifndef NDEBUG
@synthesize forceFailure;
#endif

+ (BOOL)printDebugging { return NO; }			// set to yes for debugging

- (BOOL)setup
{
	[super setup];

	[self.thread setName:runMessage];	// debugging crashes

	NSURL *url = [NSURL URLWithString:urlStr];
	request =  [NSMutableURLRequest requestWithURL:url];
	return request ? [self connect] : NO;
}

- (BOOL)connect
{
#ifndef NDEBUG
	if([[self class] printDebugging]) NSLog(@"URLSTRING1=%@", [request URL]);
#endif

	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];	
	return connection ? YES : NO;
}

- (void)cancel
{
	[super cancel];
	
	if([self isExecuting]) {
		[connection performSelector:@selector(cancel) onThread:self.thread withObject:nil waitUntilDone:NO];	// may be overkill but want to be 100% sure to stop all messages
		[self performSelector:@selector(finish) onThread:self.thread withObject:nil waitUntilDone:NO];
	}
}

- (void)completed // subclasses to override then finally call super
{
	// we need a tad delay to let the completed return before the KVO message kicks in
	[self performSelector:@selector(finish) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)failed // subclasses to override then finally call super
{
	[self performSelector:@selector(finish) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)dealloc
{
	[connection cancel];	// again, just to be 100% sure
}

@end

@implementation WebFetcher (NSURLConnectionDelegate)

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)req redirectResponse:(NSURLResponse *)redirectResponse
{
#ifndef NDEBUG
	if([[self class] printDebugging]) NSLog(@"Connection:willSendRequest %@", request);
#endif

	return request;
}

- (void)connection:(NSURLConnection *)conn didReceiveResponse:(NSURLResponse *)response
{
	if([super isCancelled]) {
		[connection cancel];
#ifndef NDEBUG
	if([[self class] printDebugging]) NSLog(@"Connection:cancelled!");
#endif

		return;
	}

	// cast the response to NSHTTPURLResponse so we can look for 404 etc  
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response; 
	htmlStatus = [httpResponse statusCode];	// if >= 400 might want to take special action

	responseLength = response.expectedContentLength == NSURLResponseUnknownLength ? 1024 : (NSUInteger)response.expectedContentLength;

#ifndef NDEBUG
	if([[self class] printDebugging]) NSLog(@"Connection:didReceiveResponse: response=%@ len=%u", response, responseLength);
	if(webData) NSLog(@"YIKES: already created a webData object!");
#endif
	webData = [NSMutableData dataWithCapacity:responseLength];

	// if(hud) dispatch_async(dispatch_get_main_queue(), ^{ [hud setProgress:PROGRESS_OFFSET]; });
}

- (void)connection:(NSURLConnection *)conn didReceiveData:(NSData *)data
{
#ifndef NDEBUG
	if([[self class] printDebugging]) NSLog(@"Connection:didReceiveData len=%lu", (unsigned long)[data length]);
#endif
	if([super isCancelled]) {
		[connection cancel];
		return;
	}
	[webData appendData:data];
	
	//if(hud) dispatch_async(dispatch_get_main_queue(), ^{ [hud setProgress:PROGRESS_UPDATE([webData length])]; });
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)err
{
#ifndef NDEBUG
	if([[self class] printDebugging]) NSLog(@"Connection:didFailWithError [%@]: error: %@", urlStr, [err description]);
#endif
	error = err;
	[connection cancel];

	[self failed];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)conn
{
#ifndef NDEBUG
	if([[self class] printDebugging]) NSLog(@"Connection:connectionDidFinishLoading len=%u", [webData length]);
#endif

	if([super isCancelled]) {
		[connection cancel];
		return;
	}

#ifndef NDEBUG	// lets us force errors in code
	if(forceFailure) {
		error = [[NSError alloc] initWithDomain:@"self" code:1 userInfo:nil];
		errorMessage = @"Forced Failure";

		[connection cancel];

		[self failed];
		return;
	}
#endif
	[self completed];
}

@end
