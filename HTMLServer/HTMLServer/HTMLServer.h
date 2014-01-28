

#define INFOD NSBundle.mainBundle.infoDictionary
#define $SHORT(A,B) [Shortcut.alloc initWithURI:A syntax:B]
#define	vLOG(A)	[((AppDelegate*)[NSApp sharedApplication].delegate).textOutField appendToStdOutView:A] // $(@"%s:
#define REQ RouteRequest
#define RES RouteResponse
#define UPLOAD_FILE_PROGRESS @"uploadfileprogress"
//#define HTTPLogVerbose(arg,...) NSLog(arg,...)

@class AssetsViewController;

@interface HTMLServer : NSWindowController
							 < NSApplicationDelegate,
							 	NSTextFieldDelegate,
								NSTableViewDataSource,
								NSTableViewDelegate	>

@property (WK) IBOutlet 		  		 WebView * webView;

@property RoutingHTTPServer * server;
@property Bootstrap * bootstrap;

//@property (nonatomic)	        AZState   running;


//@property (WK) IBOutlet AssetsViewController * assetViewController;
//
//
//@property (RONLY) 			      NSS * localURL;
//@property (CP) 					     NSAS * loadedText;
//
//@property (WK) 	IBOutlet     NSTXTF *urlField;
//@property (ASS) 	IBOutlet     NSTextView *stdOutView;
//@property (WK) 	IBOutlet	   NSTV *shortcuts;
//@property (WK) 	IBOutlet       NSAC *queriesController;
//@property (NATOM, STRNG) 	NSMA 			*queries;
//@property (NATOM, STRNG) 	NSS 			*baseURL;



//- (void) setupRoutes;
//- (void)handleSelectorRequest:(RouteRequest *)request withResponse:(RouteResponse *)response;
@end

//@interface Shortcut : NSObject
//@property (STRNG, NATOM) NSS* uri, *syntax;
//- (id) initWithURI:(NSS*)uri syntax:(NSS*)syntax;
//@end
