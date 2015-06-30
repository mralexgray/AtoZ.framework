//
//  AZBonjourBlock.h
//  AtoZ
//
//  Created by Alex Gray on 10/9/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNetService (URL)
_RO NSURL *URL;
@end

@interface AZBonjourBlock : NSArrayController <NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (readonly) NSA* services;
+ (instancetype) instanceWithTypes:(NSArray*)types consumer:(void(^)(NSNetService*svc))block;
- (void) addConsumer:(void(^)(NSNetService*svc))block;

@end
