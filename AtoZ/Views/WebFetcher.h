
// NSOperation-WebFetches-MadeEasy (TM)
// Copyright (C) 2012 by David Hoerl
// 

#import "ConcurrentOperation.h"

typedef NSRNG (*htmlProcessor)(NSData *arg, const char *classMatch);

@interface WebFetcher : ConcurrentOperation
@property (NATOM,CP) 			      NSS 	*urlStr;
@property (NATOM,STRNG) 		    NSERR   *error;
@property (NATOM,CP) 			      NSS 	*errorMessage;
@property (NATOM,CP)	 			      NSS 	*runMessage;	// debugging
@property (NATOM,STRNG,RONLY)    NSURLC  	*connection;
@property (NATOM,STRNG,RONLY)   NSMDATA 	*webData;
@property (NATOM,STRNG) 		NSMURLREQ  	*request;	// superclass might want to fiddle with it
@property (NATOM,ASS) 			     NSUI	 htmlStatus;
#ifndef NDEBUG
@property (NATOM,ASS) 			BOOL 		 forceFailure;	// testing
#endif
@end

@interface WebFetcher (NSURLConnectionDelegate) <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@end

@interface WebFetcher (ForSubClassesInternalUse)
+ (BOOL) printDebugging;
- (BOOL) connect;
@end
