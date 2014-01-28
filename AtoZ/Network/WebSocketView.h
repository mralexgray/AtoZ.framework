


@interface WebSocketView : NSObject
@property (NATOM) NSUInteger port;
+ (instancetype) onPort:(NSUInteger)p baseHTML:(NSS*)html;
@end

#import "AZWebSocketServer.h"

@interface WebSocketView ()
@property AZWebSocketServer *wsServer;
@property KSHTMLWriter *writer;
@end
