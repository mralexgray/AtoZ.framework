
#import <WebKit/WebKit.h"

@interface HTMLServerDoc : NSDocument

@property (weak) IBOutlet WebView 		*webView;
@property (weak) IBOutlet HTTPServer 	*server;
@property (weak) IBOutlet Bootstrap 	*bootstrap;

@end
