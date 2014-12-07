
// NSOperation-WebFetches-MadeEasy (TM)
// Copyright (C) 2012 by David Hoerl
// 
//#import "AtoZMacroDefines.h"
//#import <CocoaAsyncSocket/ConcurrentOperation.h>
#import "AtoZUmbrella.h"
//#import "ConcurrentOperation.h"

typedef NSRNG (*htmlProcessor)(NSData *arg, const char *classMatch);

@interface WebFetcher : ConcurrentOperation
@property (NATOM,CP) 			      NSS 	*urlStr;
@property (NATOM) 		    NSERR   *error;
@property (NATOM,CP) 			      NSS 	*errorMessage;
@property (NATOM,CP)	 			      NSS 	*runMessage;	// debugging
@prop_RO    NSURLC  	*connection;
@prop_RO   NSMDATA 	*webData;
@property (NATOM) 		NSMURLREQ  	*request;	// superclass might want to fiddle with it
@property (NATOM) 			     NSUI	 htmlStatus;
#ifndef NDEBUG
@property (NATOM) 			BOOL 		 forceFailure;	// testing
#endif
@end

@interface WebFetcher (NSURLConnectionDelegate) <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@end

@interface WebFetcher (ForSubClassesInternalUse)
+ (BOOL) printDebugging;
- (BOOL) connect;
@end
