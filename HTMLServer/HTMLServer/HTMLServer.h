
#import <WebKit/WebKit.h>

@interface HTMLServer : NSWindowController <NSApplicationDelegate>

@property (nonatomic) RoutingHTTPServer * server;
@property (nonatomic)         Bootstrap * bootstrap;
@property (readonly) 			      NSS * localURL;
@property (copy) 					     NSAS * loadedText;
@property (weak) IBOutlet 		  WebView * webView;
@property (nonatomic)	        AZState   running;
@end
