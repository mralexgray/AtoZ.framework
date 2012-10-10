
#import <Foundation/Foundation.h>

@interface NUWeakReference : NSObject {
    id __weak ref;
}

- (id) initWithObject:(id)object;
+ (id) weakReferenceToObject:(id)object;

@property(readonly) id ref;

@end