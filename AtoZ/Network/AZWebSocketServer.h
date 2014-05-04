// Originally created by Max Howell in October 2011. This class is in the public domain.
// AZWebSocketServer accepts client connections as soon as it is instantiated.
// Implementated against: http://tools.ietf.org/id/draft-ietf-hybi-thewebsocketprotocol-10
//@protocol		AZWebSocketServerDelegate ;
//@property    (WK)				  SOCKSRVRD   delegate;
//#define SOCKSRVRD     id<AZWebSocketServerDelegate>
//@property (RONLY)  clientCount;

//+ (NSS*) baseHTML;

//+   (id) webSocketFrameDataForObject:(id)x;
//-   (id) initWithPort:(NSUI)port delegate:(SOCKSRVRD)delegate;

/** Sends this data to all open connections. The object must respond to webSocketFrameData. We provide implementations for NSData and NSString.
		You may like to, eg: provide implementations for NSDictionary, encoding into a JSON string before calling [NSString webSocketFrameData].			*/

//- (void) send:(id)object type:(WebSocketMessageType)type;
//- (void) send:(id)object;

//@property				  NSArrayController * connections;


#import "AtoZMacroDefines.h"
#import "BoundingObject.h"

#define WSSRVR        AZWebSocketServer
#define AZRANDOMPORT  RAND_INT_VAL(2500,55000)
#ifndef ASOCK
#define ASOCK GCDAsyncSocket
#endif

JREnumDeclare(WebSocketMessageType, WSText, WSImage, WSJSCode);

@protocol WebSocketFrame <NSO>
@property (RONLY) id webSocketDataValue;
@property WebSocketMessageType type;
@end
@interface NSString (WebsocketData) <WebSocketFrame> @end
@interface NSData   (WebsocketData) <WebSocketFrame> @end

@class GCDAsyncSocket;
@interface AZWebSocketServer : NSO <GCDAsyncSocketDelegate, ArrayLike>

+ (INST) server;
+ (void) broadcast:(id<WebSocketFrame>)object;
- (void) send:(id<WebSocketFrame>)object toClient:(GCDAsyncSocket*)sock;

@property (CP) void(^didAcceptNewSocket)					(GCDAsyncSocket*);								/* didAcceptNewSocket		*/
@property (CP) void(^socketDidReadDataWithTag)		(GCDAsyncSocket*,NSData*,long);	/* didReadData					*/
@property (CP) void(^socketDidWriteDataWithTag)		(GCDAsyncSocket*,NSData*,long);	/* didWriteDataWithTag	*/
@property (CP) void(^socketDidDisconnectWithError)(GCDAsyncSocket*,NSERR*);				/* socketDidDisconnect	*/

/** Data is passed to you as it was received from the socket, ie. with header & masked. We disconnect the connection immediately after your delegate call returns.
		This always disconnect behavior sucks and should be fixed, but requires more intelligent error handling, so feel free to fix that. */
@property (CP,NATOM) void(^couldNotParseRawDataFromCnxnWithError)	(NSData*,GCDAsyncSocket*,NSERR*);
@property (CP,NATOM) void(^didReceiveDataFromCnxn)								(NSData*,GCDAsyncSocket*);
@property (CP,NATOM) void(^clientDisconnected)										(GCDAsyncSocket*);
@property (CP,NATOM) void(^didAcceptCnxn)													(GCDAsyncSocket*);

@end

@interface AZWebSocketServer (PassthroughMethods)
- (void) get:(NSString*)path withBlock:(RequestHandler)block; /* RoutingHTTPServer "get" method			*/
- (void) setPort:(UInt16)p;                                   /* RoutingHTTPServer listen port			*/
- (void) setDocumentRoot:(NSS*)dr;                            /* RoutingHTTPServer "document root"	*/
- (BOOL) start:(NSError *__autoreleasing *)e;

// Setters for autocompletion
- (void) setDidAcceptNewSocket:                   (void(^)(ASOCK*s)                  )d;
- (void) setSocketDidReadDataWithTag:             (void(^)(ASOCK*s,DTA   *d, long  t))d;
- (void) setSocketDidWriteDataWithTag:            (void(^)(ASOCK*s,DTA   *d, long  t))d;
- (void) setCouldNotParseRawDataFromCnxnWithError:(void(^)(DTA  *d,ASOCK *s, NSERR*e))d;
- (void) setSocketDidDisconnectWithError:         (void(^)(ASOCK*s,NSERR *e)         )d;
- (void) setDidReceiveDataFromCnxn:								(void(^)(DTA  *d,ASOCK *s)         )d;
- (void) setDidAcceptCnxn:												(void(^)(ASOCK*s)                  )d;
- (void) setClientDisconnected:										(void(^)(ASOCK*s)                  )d;

@end


//@protocol AZWebSocketServerDelegate
//@optional
//- (void) webSocketServer:(SOCKSRVR*)me didAcceptConnection:(ASOCK*)cnxn;
//- (void) webSocketServer:(SOCKSRVR*)me  clientDisconnected:(ASOCK*)cnxn;
//- (void) webSocketServer:(SOCKSRVR*)me       didReceiveData:(NSData*)data		 fromConnection:(ASOCK*)cnxn;
///** Data is passed to you as it was received from the socket, ie. with header & masked. We disconnect the connection immediately after your delegate call returns.
//		This always disconnect behavior sucks and should be fixed, but requires more intelligent error handling, so feel free to fix that. */
//- (void) webSocketServer:(SOCKSRVR*)me couldNotParseRawData:(NSData*)rawData fromConnection:(ASOCK*)cnxn error:(NSERR*)error;
//@end


@interface	GCDAsyncSocket (AZWebSocketServer)
- (void) writeWebSocketFrame:(id)object;						@end

@interface        NSString (AZWebSocketServer)
- (id)sha1base64;																	@end

