#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <libkern/OSAtomic.h>

@class UIImage;

enum {
	AZApplicationIconSizeSmall = 29,
	AZApplicationIconSizeLarge = 59
};
typedef NSUInteger AZApplicationIconSize;

@interface AZApplicationList : NSObject

+ (instancetype)sharedApplicationList;

@property (nonatomic, readonly) NSDictionary *applications;
- (NSDictionary *)applicationsFilteredUsingPredicate:(NSPredicate *)predicate;

- (id)valueForKeyPath:(NSString *)keyPath forDisplayIdentifier:(NSString *)displayIdentifier;
- (id)valueForKey:(NSString *)keyPath forDisplayIdentifier:(NSString *)displayIdentifier;

- (CGImageRef)copyIconOfSize:(AZApplicationIconSize)iconSize forDisplayIdentifier:(NSString *)displayIdentifier;
- (UIImage *)iconOfSize:(AZApplicationIconSize)iconSize forDisplayIdentifier:(NSString *)displayIdentifier;
- (BOOL)hasCachedIconOfSize:(AZApplicationIconSize)iconSize forDisplayIdentifier:(NSString *)displayIdentifier;

@end

extern NSString *const ALIconLoadedNotification;
extern NSString *const ALDisplayIdentifierKey;
extern NSString *const ALIconSizeKey;
