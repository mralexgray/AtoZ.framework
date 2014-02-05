// Originally created by Max Howell in October 2011. This class is in the public domain.
// AZWebSocketServer accepts client connections as soon as it is instantiated.
// Implementated against: http://tools.ietf.org/id/draft-ietf-hybi-thewebsocketprotocol-10

#import "AtoZUmbrella.h"

#define SOCKSRVRD id<AZWebSocketServerDelegate>
#define SOCKSRVR  AZWebSocketServer
#define AZRANDOMPORT RAND_INT_VAL(2500,55000)

JREnumDeclare(WebSocketMessageType,WSText,WSImage,WSJSCode);

@protocol		AZWebSocketServerDelegate ;

@interface					AZWebSocketServer : NSObject <GCDAsyncSocketDelegate>

+ (NSS*) baseHTML;
+ (instancetype) server;
+ (id) webSocketFrameDataForObject:(id)x;
- (id)initWithPort:(NSUInteger)port delegate:(SOCKSRVRD)delegate;

/** Sends this data to all open connections. The object must respond to webSocketFrameData. We provide implementations for NSData and NSString.
		You may like to, eg: provide implementations for NSDictionary, encoding into a JSON string before calling [NSString webSocketFrameData].			*/

- (void)send:(id)object type:(WebSocketMessageType)type;
- (void)send:(id)object;
- (void)send:(id)object toClient:(ASOCK*)sock;

@property				  NSArrayController * connections;
@property						 GCDAsyncSocket * socket;

// Answers to native calls AND responds to all RoutingHttpServer methods via EXTMultiObject proxy object.
@property (RONLY)                id   delegator;
@property (NATOM) RoutingHTTPServer * router;
@property    (WK)				  SOCKSRVRD   delegate;
@property (RONLY)							 NSUI   port,	clientCount;


@property (CP) void(^didAcceptNewSocket)					(ASOCK*);								/* didAcceptNewSocket		*/
@property (CP) void(^socketDidReadDataWithTag)		(ASOCK*,NSData*,long);	/* didReadData					*/
@property (CP) void(^socketDidWriteDataWithTag)		(ASOCK*,NSData*,long);	/* didWriteDataWithTag	*/
@property (CP) void(^socketDidDisconnectWithError)(ASOCK*,NSERR*);				/* socketDidDisconnect	*/

// Setters for autocompletion
- (void) setDidAcceptNewSocket:						(void(^)(GCDAsyncSocket*sock))												didAcceptNewSocket;
- (void) setSocketDidReadDataWithTag:			(void(^)(GCDAsyncSocket*sock, NSData*data, long tag))	socketDidReadDataWithTag;
- (void) setSocketDidWriteDataWithTag:		(void(^)(GCDAsyncSocket*sock, NSData*data, long tag))	socketDidWriteDataWithTag;
- (void) setSocketDidDisconnectWithError:	(void(^)(GCDAsyncSocket*sock, NSError*e))							socketDidDisconnectWithError;

/** Data is passed to you as it was received from the socket, ie. with header & masked. We disconnect the connection immediately after your delegate call returns.
		This always disconnect behavior sucks and should be fixed, but requires more intelligent error handling, so feel free to fix that. */
@property (CP,NATOM) void(^couldNotParseRawDataFromCnxnWithError)	(NSData*,ASOCK*,NSERR*);
@property (CP,NATOM) void(^didReceiveDataFromCnxn)								(NSData*,ASOCK*);
@property (CP,NATOM) void(^clientDisconnected)										(ASOCK*);
@property (CP,NATOM) void(^didAcceptCnxn)													(ASOCK*);

// Setters for autocompletion
- (void) setCouldNotParseRawDataFromCnxnWithError:(void(^)(NSData*data, GCDAsyncSocket*sock, NSError*e))couldNotParse;
- (void) setDidReceiveDataFromCnxn:								(void(^)(NSData*data, GCDAsyncSocket*socket))didReceiveData;
- (void) setDidAcceptCnxn:												(void(^)(ASOCK*socket))didAcceptCnxn;
- (void) setClientDisconnected:										(void(^)(ASOCK*socket))clientDisconnected;
@end

@protocol AZWebSocketServerDelegate
@optional
- (void) webSocketServer:(SOCKSRVR*)me didAcceptConnection:(ASOCK*)cnxn;
- (void) webSocketServer:(SOCKSRVR*)me  clientDisconnected:(ASOCK*)cnxn;
- (void) webSocketServer:(SOCKSRVR*)me       didReceiveData:(NSData*)data		 fromConnection:(ASOCK*)cnxn;
/** Data is passed to you as it was received from the socket, ie. with header & masked. We disconnect the connection immediately after your delegate call returns.
		This always disconnect behavior sucks and should be fixed, but requires more intelligent error handling, so feel free to fix that. */
- (void) webSocketServer:(SOCKSRVR*)me couldNotParseRawData:(NSData*)rawData fromConnection:(ASOCK*)cnxn error:(NSERR*)error;
@end

@interface AZWebSocketServer (PassthroughMethods)
- (void) get:(NSString*)path withBlock:(RequestHandler)block; /* RoutingHTTPServer "get" method			*/
- (void) setPort:(UInt16)p;                                   /* RoutingHTTPServer listen port			*/
- (void) setDocumentRoot:(NSS*)dr;                            /* RoutingHTTPServer "document root"	*/
- (BOOL) start:(NSError *__autoreleasing *)e;
@end

@interface	GCDAsyncSocket (AZWebSocketServer)
- (void)writeWebSocketFrame:(id)object;						@end

@interface        NSString (AZWebSocketServer)
- (id)sha1base64;																	@end

