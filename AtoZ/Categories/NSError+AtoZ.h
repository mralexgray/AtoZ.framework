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
//- (NSError *)underlyingErrorWithDomain:(NSS*)domain;
//- (NSError *)underlyingErrorWithDomain:(NSS*)domain code:(NSInteger)code;
//- (BOOL)hasUnderlyingErrorDomain:(NSS*)domain code:(NSInteger)code;
//
//- (BOOL)causedByUserCancelling;
//
//- initWithPropertyList:(NSD*)propertyList;
- (NSDictionary*)toPropertyList;
@end
