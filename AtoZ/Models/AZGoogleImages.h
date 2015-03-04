//
//  AZGoogleImages.h
//  AtoZ
//
//  Created by Alex Gray on 6/28/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>
@class AZGoogleQuery; 	@interface AZGoogleImages : BaseModel

/* USAGE: [AZGoogleImages searchGoogleImages:@"hitler" withBlock:^(NSA *imageURLs) { LOG_EXPR(imageURLs); }]; */

+ (AZGoogleQuery*) searchGoogleImages:(NSS*)query withBlock:(void(^)(NSA*imageURLs))block;
+			   (NSS*) lastQuery;
+			   (NSA*) queries;
+           (NSA*) urlsForQuery:(NSS*)query;


//+ (NSA*) imagesForQuery:(NSS*)q count:(NSUInteger)ct; FIX!

@end
