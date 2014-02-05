
#import "AtoZ.h"
#import <CommonCrypto/CommonDigest.h>
#import "AZWebSocketServer.h"														// Originally created by Max Howell in October 2011. This class is in the public domain.


JREnumDefine(WebSocketMessageType);

@implementation AZWebSocketServer {	EXTMultiObject *_delegator;	}

@synthesize delegator = _delegator;

- (void) _delegateSelf		{ [self setDelegate:(SOCKSRVRD)self]; }
- (void) setDidAcceptCnxn:												(void(^)(ASOCK*socket))didAcceptCnxn											{

	[self _delegateSelf]; _didAcceptCnxn = didAcceptCnxn;
}
- (void) setClientDisconnected:										(void(^)(ASOCK*socket))clientDisconnected									{

	[self _delegateSelf]; _clientDisconnected = clientDisconnected;
}
- (void) setCouldNotParseRawDataFromCnxnWithError:(void(^)(NSData*data, ASOCK*sock, NSERR*e))couldNotParse	{

	[self _delegateSelf]; _couldNotParseRawDataFromCnxnWithError = couldNotParse;
}
- (void) setDidReceiveDataFromCnxn:								(void(^)(NSData*data, ASOCK*sock))				didReceiveData	{

	[self _delegateSelf]; _didReceiveDataFromCnxn = didReceiveData;
}

- (BOOL) _shouldDelegate:(NSS*)key	{ return self.delegate == (SOCKSRVRD)self && ([self vFK:key]); }
- (void) webSocketServer:(SOCKSRVR*)me  didAcceptConnection:(ASOCK*)cnxn																									{

  if ([self _shouldDelegate:@"didAcceptCnxn"]) self.didAcceptCnxn(cnxn);
}
- (void) webSocketServer:(SOCKSRVR*)me   clientDisconnected:(ASOCK*)cnxn																									{

	if ([self _shouldDelegate:@"clientDisconnected"]) self.clientDisconnected(cnxn);
}
- (void) webSocketServer:(SOCKSRVR*)me       didReceiveData:(NSData*)data		 fromConnection:(ASOCK*)cnxn									{

	if ([self _shouldDelegate:@"didReceiveDataFromCnxn"]) self.didReceiveDataFromCnxn(data,cnxn);
}
- (void) webSocketServer:(SOCKSRVR*)me couldNotParseRawData:(NSData*)rawData fromConnection:(ASOCK*)cnxn error:(NSERR*)e	{

	if ([self _shouldDelegate:@"couldNotParseRawDataFromCnxnWithError"]) self.couldNotParseRawDataFromCnxnWithError(rawData,cnxn,e);
}

- (RoutingHTTPServer *)router { return _router = _router ?: RoutingHTTPServer.new; }

@passthrough(AZWebSocketServer, get:withBlock:,		self.router);
@passthrough(AZWebSocketServer, setPort:,					self.router);
@passthrough(AZWebSocketServer, setDocumentRoot:, self.router);
@passthrough(AZWebSocketServer, start:,						self.router);

- (EXTMultiObject*) delegator { if (_delegator) return _delegator;

	NSMA *multiObjs = (self.router ? @[_router] : @[]).mutableCopy;

	if (_socket)			[multiObjs addObject:_socket];
	if (_delegate)		[multiObjs addObject:_delegate];
	if (_connections)	[multiObjs addObject:_connections];
	[multiObjs addObject:self];

	return _delegator =  [EXTMultiObject multiObjectForObjectsInArray:multiObjs];
}
- (id) init										{	SUPERINIT;

	_connections	= NSAC.new;
	_connections.content = NSMA.new;
	_socket				= [GCDAsyncSocket.alloc initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
//	[_socket setIPv6Enabled:NO];
	_port					= AZRANDOMPORT;
	return self;
}
+ (instancetype) server				{ __strong static AZWebSocketServer *_server = nil;   static dispatch_once_t uno;

	dispatch_once(&uno, ^{   _server = self.new; NSERR *error = nil;

		[_server.socket acceptOnPort:_server.port error:&error];
		if (error) NSLog(@"MBWebSockerServer failed to initialize: %@", error);
	});
	return _server;
}
+ (NSS*) baseHTML							{ static NSMS *_mString = nil;  if (_mString) return _mString; else _mString = NSMS.new;

	KSHTMLWriter *_writer = [KSHTMLWriter.alloc initWithOutputWriter:_mString docType:KSHTMLWriterDocTypeHTML_5 encoding:NSUTF8StringEncoding];
	[_writer startDocumentWithDocType:@"html" encoding:NSUTF8StringEncoding];

	[_writer writeElement:@"head" content:^{

		[_writer writeStyleElementWithCSSString:@".container{ display:none; }"];

		[@[@"/js/jquery-ui.css",    @"/js/jquery-notify/ui.notify.css"] each:^(id obj) {
			[_writer writeLinkToStylesheet:[@"http://mrgray.com" withString:obj] title:@"" media:@""];
			[_writer startNewline];
		}];
		[_writer writeLinkToStylesheet:@"http://fonts.googleapis.com/css?family=Ubuntu:regular,bold&subset=Latin" title:@"" media:@""];
		[_writer startNewline];
		[@[@"/js/jquery.latest.js",@"/js/jquery-ui.js",@"/js/jquery-notify/src/jquery.notify.js",@"/js/Meny/js/meny.js"]each:^(id obj) {
			[_writer writeJavascriptWithSrc:[@"http://mrgray.com" withString:obj] encoding:NSUTF8StringEncoding];
			[_writer startNewline];;
		}];
		[_writer writeJavascript:[KSHTMLWriter markupForAZJSWithID:@"AZWebSocketServer.baseHTML"] useCDATA:NO];
	}];
/**
    [_writer writeElement:@"body" content:^{
  had to diable because no content selector... is KSHTNMML in ATp or ROuttingframework?
		[_writer writeElement:@"div" className:@"container" content:^{
			[_writer writeElement:@"div" className:@"basic-template" content:^{
				[_writer writeHTMLString:@"<a class='ui-notify-cross ui-notify-close' href='#'>x</a><h1>#{title}</h1><p>#{text}</p>"];
			}];
			[_writer writeElement:@"input" idName:@"input" text:@""];
		}];
	}];
  */
	return _mString;
}

-   (id) initWithPort:(NSUI)port delegate:(SOCKSRVRD)del		{ SUPERINIT; NSError *error = nil;

	_delegate		= del;
	[_socket acceptOnPort:_port = port error:&error];
	return error ? (id)(NSLog(@"MBWebSockerServer failed to initialize: %@", error), nil) : self;
}
- (NSUI) clientCount																				{	return [_connections.content count]; }
- (void) send:(id)obj   toClient:(ASOCK*)sock								{ id payload; if ((payload = [self.class webSocketFrameDataForObject:obj])) [sock writeData:payload withTimeout:-1 tag:3]; }
-   (id) wrapObject:(id)x asType:(WebSocketMessageType)type { 	// id payload = [self.class webSocketFrameDataForObject:x];

	NSD   * d		= @{@"type" :type == WSText ? @"text" : @"OTHER", @"payload": x };
	NSS * json = d.jsonStringValue;

	NSLog(@"d:%@\njson:%@", d, json); //payload, d, json, sendable);
	return json;
}
- (void) send:(id)obj       type:(WebSocketMessageType)type {	[self send:[self wrapObject:obj asType:type]]; }
- (void) send:(id)obj																				{	id payload = [self.class webSocketFrameDataForObject:obj];

	if (payload) [_connections.content each:^(ASOCK *conn ){
		if ([conn ISKINDA:ASOCK.class])	[conn writeData:payload withTimeout:-1 tag:3];
	}];
}

- (NSS*) handshakeResponseForData:(NSData*)data { id(^throw)() = ^{ @throw @"Invalid handshake from client"; return (id)nil; };

	NSA *strings = [NSS stringWithUTF8Data:data].eolines;  /* \r\n */	LOGCOLORS(strings, [NSC randomBrightColor],nil);

	return !strings.count || ![strings[0] isEqualToString:@"GET / HTTP/1.1"] ? throw() : [strings filterNonNil:^id(NSString *line){		NSArray *parts;

		if((parts = [line componentsSeparatedByString:@":"]).count != 2 || ![parts[0] isEqualToString:@"Sec-WebSocket-Key"]) return nil;

		id							  key = [parts[1] stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
		id secWebSocketAccept = [key withString:@"258EAFA5-E914-47DA-95CA-C5AB0DC85B11"].sha1base64;
		return JATExpand( @"HTTP/1.1 101 Web Socket Protocol Handshake\r\n"
										 "Upgrade: websocket\r\n"
										 "Connection: Upgrade\r\n"
										 "Sec-WebSocket-Accept: {secWebSocketAccept}\r\n\r\n", secWebSocketAccept);
	}];
}  // handshake nonsense

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(ASOCK*)sock     didAcceptNewSocket:(ASOCK*)cnxn		{

	//NSLog(@"%@ .. connections:%lu",NSStringFromSelector(_cmd), self.clientCount);
	[self.connections addObject:cnxn]; // retainer
	if (self.didAcceptNewSocket) self.didAcceptNewSocket(cnxn);
	[cnxn readDataWithTimeout:-1 tag:1];

}		/* didAcceptNewSocket */
- (void)socket:(ASOCK*)cnxn					   didReadData:(NSData*)data
																					 withTag:(long)tag			{		//AZLOGCMD;

	@try {	const unsigned char *bytes = data.bytes;

		if (tag == 1) [cnxn writeData:[self handshakeResponseForData:data].UTF8Data withTimeout:-1 tag:2];

		else if (tag == 4) {

			uint64_t const  N = bytes[1] & 0x7f;
			char const opcode = bytes[0] & 0x0f;

			if (!bytes[0] & 0x80)	@throw @"Can't decode fragmented frames!";  // TODO support fragmented frames (first bit unset in control frame)
			if (!bytes[1] & 0x80)	@throw @"Can only handle websocket frames with masks!";
			switch (opcode) {
				case 1:
				case 2:
					if (N >= 126) {	[cnxn readDataToLength:N == 126 ? 2 : 8 withTimeout:-1 buffer:nil bufferOffset:0 tag:16 + opcode];
						break;
					}								// ELSE CONTINUE!
				case 8:						// close frame http://tools.ietf.org/html/rfc6455#section-5.5.1
				case 9:						// ping  frame http://tools.ietf.org/html/rfc6455#section-5.5.2
					if (N >= 126) {	// CLOSE with status code 1002 because CONTROL-FRAMES are not allowed to have payloads greater than 125 characters.
						char rsp[4] = {0x88, 2, 0xEA, 0x3};
						[cnxn writeData:[NSData dataWithBytes:rsp length:4] withTimeout:-1 tag:-1];
						[cnxn disconnect];
						LOGCOLORS(@"CLOSE with status code 1002 because CONTROL-FRAMES are not allowed to have payloads greater than 125 characters.",nil);
					} else	[cnxn readDataToLength:N + 4 withTimeout:-1 buffer:nil bufferOffset:0 tag:32 + opcode];
					break;
				default:	@throw @"Cannot handle this websocket frame opcode!";
			}
		}
		else if (tag == 0x11 || tag == 0x12) {			 uint64_t N; // figure out payload length

			unsigned long long (^ntohll)(unsigned long long) =
			^unsigned long long					 (unsigned long long v){ union { unsigned long lv[2]; unsigned long long llv; } u; u.llv = v;	return ((unsigned long long)ntohl(u.lv[0]) << 32) | (unsigned long long)ntohl(u.lv[1]); };

			if		(data.length == 2)	{	uint16_t *p = (uint16_t *)bytes;	N = ntohs(*p) + 4;	}
			else											{	uint64_t *p = (uint64_t *)bytes;	N = ntohll(*p) + 4;	}

			[cnxn readDataToLength:N withTimeout:-1 buffer:nil bufferOffset:0 tag:16 + tag];
		}
		else if (tag == 0x21 || tag == 0x22 || tag == 0x28 || tag == 0x29) { /* read complete payload (0x21) */

			NSMutableData *unmaskedData = NSMutableData.new;//[NSMutableData dataWithCapacity:data.length - 4];
			for (int x = 4; x < data.length; ++x) {		char c = bytes[x] ^ bytes[x%4];		[unmaskedData appendBytes:&c length:1];	}
			if	((tag & 0xf) == 1 && [(NSO*)_delegate respondsToSelector:@selector(webSocketServer:didReceiveData:fromConnection:)])
				dispatch_async(dispatch_get_main_queue(), ^{ [_delegate webSocketServer:self didReceiveData:unmaskedData fromConnection:cnxn];	});
			else if ((tag & 0xf) == 8) { /*CLOSE*/
				char rsp[4] = {0x88, 2, bytes[1], bytes[0]};	// final two bytes are network-byte-order statusCode that we echo back
				[cnxn writeData:[NSData dataWithBytes:rsp length:4] withTimeout:-1 tag:-1];
			}
			else if ((tag & 0xf) == 9) { /*PING*/

				NSMutableData *pong = [[self.class webSocketFrameDataForObject:unmaskedData]mutableCopy]; // FIXME inefficient (but meh)
				((char*)pong.mutableBytes)[0] = 0x8a;
				[cnxn writeData:pong withTimeout:-1 tag:-1];
			}
			[cnxn readDataToLength:2 withTimeout:-1 buffer:nil bufferOffset:0 tag:4];	// configure the cnxn to wait for the next frame
		}
		else 	@throw [NSString stringWithFormat:@"Unhandled tag: %ld", tag];
	}
	@catch (id msg) {
		id err = [NSError errorWithDomain:@"com.methylblue.webSocketServer" code:1 userInfo:@{NSLocalizedDescriptionKey: msg}];
		if ([(NSO*)_delegate respondsToSelector:@selector(webSocketServer:couldNotParseRawData:fromConnection:error:)])
			dispatch_sync(dispatch_get_main_queue(), ^{	[_delegate webSocketServer:self couldNotParseRawData:data fromConnection:cnxn error:err]; });
		[cnxn disconnect]; // FIXME some cases do not require disconnect
	}
}		/* didReadData */
- (void)socket:(ASOCK*)cnxn    didWriteDataWithTag:(long)tag			{		if (tag != 2) return;

	[AZSOQ addOperationWithBlock:^{

		[_delegate webSocketServer:self didAcceptConnection:cnxn];
//		if (self.socketDidWriteDataWithTag) self.socketDidWriteDataWithTag(cnxn,tag);
	}];

	[cnxn readDataToLength:2 withTimeout:-1 buffer:nil bufferOffset:0 tag:4];

}		/* didWriteDataWithTag */
- (void)socketDidDisconnect:(ASOCK*)cnxn withError:(NSERR*)err		{

	AZLOGCMD;
	[_connections removeObject:cnxn];
	if ([(NSO*)_delegate respondsToSelector:@selector(webSocketServer:clientDisconnected:)])
		[AZSOQ addOperationWithBlock:^{	[_delegate webSocketServer:self clientDisconnected:cnxn];	}];

}   /* socketDidDisconnect */

+  (id) webSocketFrameDataForObject:(id)x {

	if ([x ISKINDA:NSData.class]) {	NSData *object = x; NSMutableData *data = [NSMutableData dataWithLength:10];

		char *header = data.mutableBytes; 	header[0] = 0x81;

		if (object.length > 65535) {
			header[1] = 127;
			header[2] = (object.length >> 56) & 255;
			header[3] = (object.length >> 48) & 255;
			header[4] = (object.length >> 40) & 255;
			header[5] = (object.length >> 32) & 255;
			header[6] = (object.length >> 24) & 255;
			header[7] = (object.length >> 16) & 255;
			header[8] = (object.length >>  8) & 255;
			header[9] = object.length & 255;	}

		else if (object.length > 125) {
			header[1] = 126;
			header[2] = (object.length >> 8) & 255;
			header[3] =  object.length & 255;
			data.length = 4;	}

		else {
			header[1] = object.length;
			data.length = 2;
		}
		[data appendData:object];		return data;
	}
	else if ([x ISKINDA:NSS.class]) return [self webSocketFrameDataForObject:[x UTF8Data]];
	return nil;
}

@end

@implementation																		NSString (AZWebSocketServer)
- (id)sha1base64					{

	NSMutableData* data = (id)self.UTF8Data;	unsigned char input[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(data.bytes, (unsigned)data.length, input);
	static const char map[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
	data = [NSMutableData dataWithLength:28];
	uint8_t* out = (uint8_t*) data.mutableBytes;
	for (int i = 0; i < 20;) {	int v  = 0;
		for (const int N = i + 3; i < N; i++) {	v <<= 8;	v |= 0xFF & input[i]; 	}
		*out++ = map[v >> 18 & 0x3F];
		*out++ = map[v >> 12 & 0x3F];
		*out++ = map[v >>  6 & 0x3F];
		*out++ = map[v >>  0 & 0x3F];
	}
	out[-2] = map[(input[19] & 0x0F) << 2];
	out[-1] = '=';
	return [NSString stringWithData:data encoding:NSASCIIStringEncoding];
}
@end
@implementation															GCDAsyncSocket (AZWebSocketServer)

- (void)writeWebSocketFrame:(id)object {	[self writeData:[AZWebSocketServer webSocketFrameDataForObject:object] withTimeout:-1 tag:3];	}

@end


//	var myObject = eval('(' + e.data + ')'); console.log (myObject); }																																													\n\
//	ws.onerror   = function(e){ outp.append('<p>ERROR: ' + evt.data + '</p>') } \n\
$('#input').keypress(function() {	var currentVal = $(this).val();						\n\
if (currentVal && window.event.keyCode == 13) {		\n\
note('SENT',currentVal)		\n\
ws.send(currentVal)															\n\
$(this).val(null)																\n\
}	})		})",			[RoutingHTTPServer FQDN]);


	//	[self addToOrCreateDelegateMethod:@selector(webSocketServer:didReceiveData:fromConnection:) imp:
	//	void (^impBlock)(id,SOCKSRVR*,NSData*,ASOCK*) = ^(id _self, SOCKSRVR*me,NSData*data,ASOCK*sock) {
	//		((AZWebSocketServer*)_self).didReceiveDataFromCnxn(data, sock);
	//	};
	// create an IMP from the block
	//  void(*impFunct)(id, SEL, SOCKSRVR*,NSData*,ASOCK*) = (void*) imp_implementationWithBlock(impBlock);
	//	class_addMethod([self class],@selector(webSocketServer:didReceiveData:fromConnection:),(IMP)impFunct, "v@:@:@:@");
