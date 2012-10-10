
#import <Foundation/Foundation.h>

@interface NUZeroingDictionary : NSMutableDictionary

/// Interval at which the dead references are removed from the dictionary.
@property (assign) float timerInterval;

/// Removes any zeroed weak references from the dictionary.
- (void) removeDeadReferences:(id)sender;

/// Returns shared instance of the dictionary.
+ (NUZeroingDictionary*) sharedInstance;

/// Sets the value for a given key and optionaly makes it a weak reference.
- (void) setObject:(id)anObject forKey:(id<NSCopying>)aKey weakReference:(BOOL)isWeak;

@end
