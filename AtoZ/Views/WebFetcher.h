
// NSOperation-WebFetches-MadeEasy (TM)
// Copyright (C) 2012 by David Hoerl
// 
//@import AtoZUniversal;
//#import <CocoaAsyncSocket/ConcurrentOperation.h>
//#import "ConcurrentOperation.h"

typedef NSRNG (*htmlProcessor)(NSData *arg, const char *classMatch);

@interface WebFetcher : ConcurrentOperation
@property (NA,CP) 			      NSS 	*urlStr;
@property (NA) 		    NSERR   *error;
@property (NA,CP) 			      NSS 	*errorMessage;
@property (NA,CP)	 			      NSS 	*runMessage;	// debugging
_RO   NSURLC  	*connection;
_RO  NSMDATA 	*webData;
@property (NA) 		NSMURLREQ  	*request;	// superclass might want to fiddle with it
@property (NA) 			     NSUI	 htmlStatus;
#ifndef NDEBUG
@property (NA) 			BOOL 		 forceFailure;	// testing
#endif
@end

@interface WebFetcher (NSURLConnectionDelegate) <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@end

@interface WebFetcher (ForSubClassesInternalUse)
+ (BOOL) printDebugging;
- (BOOL) connect;
@end
