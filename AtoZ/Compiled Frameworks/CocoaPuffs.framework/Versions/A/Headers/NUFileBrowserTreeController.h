
#import <AppKit/AppKit.h>

@interface NUFileBrowserTreeController : NSTreeController
@property (copy,nonatomic) NSURL *rootURL;
@property (retain,nonatomic) NSArray *supportedTypes;
@end
