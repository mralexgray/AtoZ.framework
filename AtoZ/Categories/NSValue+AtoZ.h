//
//  NSValue+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 9/30/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AtoZ.h"

@interface NSValue (AZWindowPosition)
+ (id)valueWithPosition: (AZWindowPosition) pos;
- (AZWindowPosition) positionValue;
@end

@interface NSValue (AZInstallationStatus)
+ (id)valueWithInstallStatus: (AZInstallationStatus) status;
- (AZInstallationStatus) installStatusValue;
@end


@interface NSData (NSDataExtension)

// Canonical Base32 encoding/decoding.
// decode
+ (NSData *) dataWithBase32String:(NSS*)base32;
// encode
- (NSS*) base32String;

@end
