


#import "AZHomeBrew.h"
	
@interface NSValue (AZWindowPosition)
+ valueWithPosition: (AZWindowPosition) pos;
- (AZWindowPosition) positionValue;
@end

@interface NSValue (AZInstallationStatus)
+ valueWithInstallStatus: (AZInstallationStatus) status;
- (AZInstallationStatus) installStatusValue;
@end


@interface NSData (NSDataExtension)

// Canonical Base32 encoding/decoding.
// decode
+ (NSData *) dataWithBase32String:(NSS*)base32;
// encode
- (NSS*) base32String;

@end
