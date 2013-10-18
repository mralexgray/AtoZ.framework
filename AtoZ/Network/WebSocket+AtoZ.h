


#import "AtoZUmbrella.h"

NSDictionary * AZLocalHosts();		/** 	AZLocalHosts() = {    en1 = "10.0.1.100";
																				    lo0 = "127.0.0.1";		}    */


//@protocol SocketBlockDelegate <NSObject>
//@concrete
//@property (CP) void(^didOpenBlock)			 (WebSocket*ws);
//@property (CP) void(^didCloseBlock)			  (WebSocket*ws);
//@property (CP) void(^didReceiveMessageBlock)(WebSocket*ws, NSS*msg);
//
////@property WebSocket*(^webSocketForURI)(NSString*path);
////- (void) setWebSocketForURI:(WebSocket *(^)(NSString *))webSocketForURI;
////- (WebSocket*(^)(NSString*)) webSocketForURI;
//@end


@interface WebSocket (AtoZBlockDelegate) <WebSocketDelegate>

+ (instancetype) webSocketOnSocket:(ASOCK*)sock;

// The request message which opened the web socket connection.
@property (nonatomic, readonly, strong) HTTPMessage *requestMessage;

@property (CP) void(^didOpenBlock)			  (WebSocket*ws);
@property (CP) void(^didCloseBlock)			  (WebSocket*ws);
@property (CP) void(^didReceiveMessageBlock)(WebSocket*ws, NSS*msg);

@end
