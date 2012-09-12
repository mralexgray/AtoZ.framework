//
//  NSNumber+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (AtoZ)


- (NSString*) prettyBytes;
+ (NSNumber*) zero;
+ (NSNumber*) one;
+ (NSNumber*) two;

- (NSNumber*) increment;
- (NSNumber*) abs;
- (NSNumber*) negate;
- (NSNumber*) transpose;

- (NSArray*) times:(id (^)(void))block;

- (NSArray*) to:(NSNumber*) to;
- (NSArray*) to:(NSNumber*) to by:(NSNumber*) by;

@end
