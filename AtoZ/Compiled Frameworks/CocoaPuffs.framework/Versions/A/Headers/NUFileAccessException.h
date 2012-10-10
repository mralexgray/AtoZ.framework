
#import <Foundation/Foundation.h>

extern NSString *NUFileAccessExceptionName;
extern NSString *NUFileAccessExceptionErrorKey;

@interface NUFileAccessException : NSException

- (id) initWithError:(NSError*)anError;
+ (id) raiseWithError:(NSError*)anError;

@property (readonly) NSError *error;

@end
