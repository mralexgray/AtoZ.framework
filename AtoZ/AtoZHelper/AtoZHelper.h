

#import <AtoZ/AtoZ.h>

@interface AZShowWindowScriptCommand : NSScriptCommand @end

typedef void(^openURL)(NSS*url, WebView *w);

@interface AtoZHelper : NSObject <NSApplicationDelegate, AtoZDelegate>

@property (ASS) IBO     NSW * window;
@property  (WK) IBO      WV * webView,
														* webView2;
@property (ASS) IBO NSTextView * text;
@property					     NSAC * sockets;
@property RoutingHTTPServer * httpServer; //AZHTTPRouter
@property            Gridly * gridly;


@end


//, WebSocketDelegate, AZWebSocketServerDelegate>
//@property AZWebSocketServer *socketServer;
//@property (STRNG) AZAddressBook *ab;
//
//- (IBAction)getFB:(id)sender;
//- (IBAction)getColorList:(id)sender;
//
//@property (ASS) IBOutlet NSWindow 					*window;
//@property (ASS) IBOutlet WebView 					*webView;
//@property (ASS) IBOutlet NSTableView 				*table;
//@property (ASS) IBOutlet NSTextView 				*text;
//
//@property (ASS) IBOutlet NSArrayController 		*arrayC;
//
//@property (ASS) IBOutlet AZHTTPRouter 				*router;
//@property (ASS) IBOutlet AZFacebookConnection 	*fb;

