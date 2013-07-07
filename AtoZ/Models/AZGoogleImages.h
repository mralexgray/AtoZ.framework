//
//  AZGoogleImages.h
//  AtoZ
//
//  Created by Alex Gray on 6/28/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZ.h"

#define GIMAGEURLSBLK void(^)(NSA*imageURLs)
typedef void(^GoogleImagesUrlsBlock)(NSA*imageURLs);

@interface AZGoogleQuery : NSObject
@property (NATOM) NSUI start;
AZPROP		( NSS,   query );
AZPROP		( NSMA, 	urls  );
AZPROP		( NSURL, url   );
@property 	(copy) void(^imageUrlsBlock)(NSA*);
- (void) loadMoreURLs;
@end

@interface AZGoogleImages : BaseModel

/* USAGE: [AZGoogleImages searchGoogleImages:@"hitler" withBlock:^(NSArray *imageURLs) { LOG_EXPR(imageURLs); }]; */
+ (AZGoogleQuery*) searchGoogleImages:(NSS*)query withBlock:(void(^)(NSA*imageURLs))block;
+ (NSA*) queries;
+ (NSA*) urlsForQuery:(NSS*)query;
@end
