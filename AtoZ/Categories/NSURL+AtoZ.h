//
//  NSURL+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 8/4/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtoZ.h"



/* the following categories are added to NSURLRequest and NSMutableURLRequest
 for the purposes of sharing information between the various webView delegate
 routines and the custom protocol implementation defined in this file.  Our
 WebResourceLoadDelegate (WRLD) will intercept resource load requests before they are
 handled and if a NSURLRequest is destined for our special protocol, then the
 WRLD will copy the NSURLRequest to a NSMutableURLRequest and call setSpecialVars
 to attach some data we want to share between the WRLD and our NSURLProtocol
 object. Inside of our NSURLProtocol we can access this data.
 In this example, we store a reference to our WRLD object in the dictionary inside
 of our WRLD method and then we call a method on our WRLD object from inside of our
 startLoading method on our NSURLProtocol object.
 */
@interface NSURLRequest (SpecialProtocol)
- (NSDictionary *)specialVars;
@end
@interface NSMutableURLRequest (SpecialProtocol)
- (void)setSpecialVars:(NSDictionary *)caller;
@end

@interface NSURL (AtoZ)

@end

