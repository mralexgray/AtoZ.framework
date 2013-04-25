

#import "RoutingHTTPServer.h"

@interface AZHTTPRouter : RoutingHTTPServer

@property (NATOM, STRNG) 	AssetCollection   *assets;
@property (NATOM, STRNG) 	IBOutlet WebView  *webView;
@property (NATOM, STRNG) 	NSS					*baseURL;
@property (NATOM, ASS) 	 	BOOL					shouldExit;
@property (NATOM, ASS) 	 	int					exitCode;

-(void) start;

@end

typedef RES (^GetReturnsString)(REQ *req, NSD* shortcuts);

@interface Shortcut : NSObject

@property (STRNG, NATOM) 	NSS	*uri,*syntax, *string;

//+ (instancetype) initWithURI:(NSS*)uri syntax:(NSS*)syntax;

@end
