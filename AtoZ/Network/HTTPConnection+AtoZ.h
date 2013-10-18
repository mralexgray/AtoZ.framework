//
//  HTTPConnection+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 10/11/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>


@interface HTTPConnection (SocketBlock)

//@property (nonatomic,readonly,unsafe_unretained) HTTPServer *server;

@property WebSocket*(^webSocketForURI)(NSString*path);
- (void) setWebSocketForURI:(WebSocket *(^)(NSString *))webSocketForURI;
- (WebSocket*(^)(NSString*)) webSocketForURI;


@property NSObject<HTTPResponse>*(^httpResponseForMethod)(NSS*method, NSS*path);
- (void) setHttpResponseForMethod:(NSObject<HTTPResponse> *(^)(NSString *, NSString *))httpResponseForMethod;
- (NSObject<HTTPResponse>*(^)(NSS*method, NSS*path))httpResponseForMethod;

@end
