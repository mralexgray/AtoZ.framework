//
//  HTTPConnection+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 10/11/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "HTTPConnection+AtoZ.h"
#import "AtoZ.h"

#define DO_RET_1ARG(X,Y) return (self.X && self.delegate == self) ? self.X(Z) : nil


//@implementation RSMConnection
//
//#pragma mark HTTPConnection
//
//- (BOOL)isSecureServer {
//	return self.server.useSSL;
//}
//
//- (NSArray *)sslIdentityAndCertificates {
//	NSArray *identityArray = @[ (__bridge id)self.server.SSLIdentity ];
//	if (self.server.SSLCertificates == nil) return identityArray;
//	return [identityArray arrayByAddingObjectsFromArray:self.server.SSLCertificates];
//}
//
//- (WebSocket *)webSocketForURI:(NSString *)path {
//
//	__weak id weakServer = self.server;
//	RSMWebSocket *socket = [self.class.alloc initWithRequest:request socket:asyncSocket opened:^(RSMWebSocket *socket) {
//		RSMServer *strongServer = weakServer;
//		if (strongServer == nil) return;
//
//		[strongServer->_webSockets sendNext:socket];
//	}];
//
//	return socket;
//}
//
//- (BOOL)shouldAcceptRequest:(HTTPMessage *)newRequest {
//	NSArray *acceptableOrigins = self.server.acceptedOrigins;
//	if (acceptableOrigins == nil) return YES;
//
//	NSString *origin = newRequest.allHeaderFields[@"Origin"];
//	return [acceptableOrigins containsObject:origin];
//}
//
//- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {
//	if (self.server.responseBlock == nil) return nil;
//
//	return self.server.responseBlock(request, path);
//}
//
//#pragma mark Server
//
//- (RSMServer *)server {
//	return (RSMServer *)config.server;
//}
//
//@end

@implementation  HTTPConnection (SocketBlock)

/**
 * This method is called to get a response for a request.
 * You may return any object that adopts the HTTPResponse protocol.
 * The HTTPServer comes with two such classes: HTTPFileResponse and HTTPDataResponse.
 * HTTPFileResponse is a wrapper for an NSFileHandle object, and is the preferred way to send a file response.
 * HTTPDataResponse is a wrapper for an NSData object, and may be used to send a custom response.
**/
//- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path {	HTTPLogTrace();
//
//	
//	// Override me to provide custom responses.
//	
//	NSString *filePath = [self filePathForURI:path allowDirectory:NO];
//	
//	BOOL isDir = NO;
//	
//	if (filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
//	{
//		return [[HTTPFileResponse alloc] initWithFilePath:filePath forConnection:self];
//	
//		// Use me instead for asynchronous file IO.
//		// Generally better for larger files.
//		
//	//	return [[[HTTPAsyncFileResponse alloc] initWithFilePath:filePath forConnection:self] autorelease];
//	}
//	
//	return nil;
//}

//- (WebSocket *)webSocketForURI:(NSString *)path {	HTTPLogTrace();
	// Override me to provide custom WebSocket responses.
	// To do so, simply override the base WebSocket implementation, and add your custom functionality.
	// Then return an instance of your custom WebSocket here.
	// For example:
	// if ([path isEqualToString:@"/myAwesomeWebSocketStream"])
	// {
	//     return [[[MyWebSocket alloc] initWithRequest:request socket:asyncSocket] autorelease];
	// }
	// return [super webSocketForURI:path];
	
//	return nil;
//}


+ (void) load {	[$ swizzleInstanceSelector:@selector(webSocketForURI:)
									  withNewSelector:@selector(swizzleWebSocketForURI:)];

						[$ swizzleInstanceSelector:@selector(httpResponseForMethod:URI:)
									  withNewSelector:@selector(swizzlehttpResponseForMethod:URI:)];	}

-(WebSocket*) swizzleWebSocketForURI:(NSString*)uri {					// Swizzled mmethod.
	return self.webSocketForURI ? self.webSocketForURI(uri) : [self swizzleWebSocketForURI:uri];
}

// ASSociated Category Bliocks

- (void) setWebSocketForURI:(WebSocket *(^)(NSString *))webSocketForURI { SET_ASSOC(webSocketForURI); }

- (WebSocket*(^)(NSString*)) webSocketForURI { RET_ASSOC; }

- (NSObject <HTTPResponse>*)swizzlehttpResponseForMethod:(NSS*)method URI:(NSS*)path {
	return self.httpResponseForMethod ? self.httpResponseForMethod(method,path)
												 : [self swizzlehttpResponseForMethod:method URI:path];   }

- (void) setHttpResponseForMethod:(NSObject<HTTPResponse> *(^)(NSString *, NSString *))httpResponseForMethod
{ SET_ASSOC(httpResponseForMethod); }

- (NSObject<HTTPResponse>*(^)(NSS*method, NSS*path))httpResponseForMethod { RET_ASSOC; }

@end

//							(WebSocket*(^)(NSString *)),
//							(WebSocket*)webSocketForURI:(NSString*)uri,
//							DO_RET_1ARG(webSocketForURI,uri))

//SYNTHESIZE_DELEGATE(	didOpenBlock, setDidOpenBlock,
//							(void(^)(WebSocket*ws)),
//							(void)webSocketDidOpen:(WebSocket*)ws,
//							DO_IF_SELF(didOpenBlock))





//#import "TBHTTPServer.h"
//#import "TBSocketConnection.h"
//#import "TBWebSocket.h"
//@interface TBSocketConnection () <WebSocketDelegate>
//@property WebSocket *socket;
//@end
//
//@implementation TBSocketConnection
//
//- (WebSocket*)webSocketForURI:(NSString*)path {
//
//	return [path isEqualToString:@"/livereload"] ? (self.socket = [TBWebSocket.alloc initWithRequest:request socket:asyncSocket])
//																: [super webSocketForURI:path];
//}
//
//- (NSObject <HTTPResponse>*)httpResponseForMethod:(NSS*)method URI:(NSS*)path {
//	
//	return [path hasPrefix:@"/livereload.js"]
//		?	 [HTTPDataResponse.alloc initWithData:[AZAPPBUNDLE.infoDictionary[@"TBLiveReloadJS"] dataUsingEncoding:NSUTF8StringEncoding]]
//		:	 [super httpResponseForMethod:method URI:path];
//}

//@implementation AZLiveReload
//
//- (id)init {	if (self != super.init) return nil;
//		self.connectionClass = TBSocketConnection.class; return self; }
//
//- (void)refreshPages {
//
//	[webSockets makeObjectsPerformSelector:@selector(sendMessage:)
//										withObject:@"{ \"command\": \"reload\", \"path\": \"/\", \"liveCSS\": true }"];
//}
//@end

