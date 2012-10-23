//
//  NSError+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 10/18/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (AtoZ)
//
//- (NSError *)underlyingErrorWithDomain:(NSString *)domain;
//- (NSError *)underlyingErrorWithDomain:(NSString *)domain code:(NSInteger)code;
//- (BOOL)hasUnderlyingErrorDomain:(NSString *)domain code:(NSInteger)code;
//
//- (BOOL)causedByUserCancelling;
//
//- initWithPropertyList:(NSDictionary *)propertyList;
- (NSDictionary *)toPropertyList;
@end
