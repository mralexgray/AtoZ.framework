
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

typedef NSRange (*htmlProcessor)(NSData *arg, const char *classMatch);

#import "ConcurrentOperation.h"

@interface WebFetcher : ConcurrentOperation
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, copy) NSString *errorMessage;
@property (nonatomic, copy) NSString *runMessage;	// debugging
@property (nonatomic, strong, readonly) NSURLConnection *connection;
@property (nonatomic, strong, readonly) NSMutableData *webData;
@property (nonatomic, strong) NSMutableURLRequest *request;	// superclass might want to fiddle with it
@property (nonatomic, assign) NSUI htmlStatus;
#ifndef NDEBUG
@property (nonatomic, assign) BOOL forceFailure;	// testing
#endif

@end

@interface WebFetcher (NSURLConnectionDelegate) <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@end

@interface WebFetcher (ForSubClassesInternalUse)

+ (BOOL)printDebugging;

- (BOOL)connect;

@end
