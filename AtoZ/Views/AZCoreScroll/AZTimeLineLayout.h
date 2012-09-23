
#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>


/* Layer attributes:
selectedSnapShot		NSNumber<int>
 
Sublayer attributes:
none 
*/

#define YMARGIN 0
#define XMARGIN 0

extern NSString *selectedSnapShot;

@interface AZTimeLineLayout : NSObject {

}

+ (id)layoutManager;

- (CGPoint)scrollPointForSelected:(CALayer *)layer;

@end
