
#import <AtoZ/AtoZ.h>

@interface AZAppDelegate : NSObject <NSApplicationDelegate, NSOutlineViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property	UAGithubEngine *engine;
@property (weak) IBOutlet AZGists *gistController;
@property (weak) IBOutlet WebView *webView;
@property NSAS* attributedLog;
@end
