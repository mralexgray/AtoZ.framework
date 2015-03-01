
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,AZApplicationIconSize){  AZApplicationIconSizeSmall = 29,
                                                    AZApplicationIconSizeLarge = 59  };


@interface AZApplicationList : NSObject + (instancetype) sharedApplicationList;

@property (readonly) NSDictionary *applications;

- (NSDictionary*) applicationsFilteredUsingPredicate:(NSPredicate*)predicate;

-             valueForKeyPath:(NSString*)kp            forDisplayIdentifier:(NSString*)dispID;
-                 valueForKey:(NSString*)kp            forDisplayIdentifier:(NSString*)dispID;

- (UIImage*)       iconOfSize:(AZApplicationIconSize)_ forDisplayIdentifier:(NSString*)dispID;
- (CGImageRef) copyIconOfSize:(AZApplicationIconSize)_ forDisplayIdentifier:(NSString*)dispID CF_RETURNS_RETAINED;
- (BOOL)  hasCachedIconOfSize:(AZApplicationIconSize)_ forDisplayIdentifier:(NSString*)dispID;

@end

extern NSString *const ALIconLoadedNotification,
                *const ALDisplayIdentifierKey,
                *const ALIconSizeKey;
