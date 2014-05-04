
@interface WebSockets_AtoZTests : XCTestCase

@property ASOCK *listenSocket;
@property NSMutableArray *sockets;
@property dispatch_queue_t dQ;

@end

@implementation WebSockets_AtoZTests

- (void) setUp
{
    	[super setUp];
	 	self.dQ = dispatch_queue_create("SQ",NULL);
		_listenSocket =  [ASOCK.alloc initWithSocketQueue:_dQ];
}

- (void) tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testSocketIsSelf
{
		ASOCK* __weak bSock = self.listenSocket;
		[_listenSocket setDidAcceptNewSocket:^(GCDAsyncSocket *sock, GCDAsyncSocket *nSock) {
			XCTAssertEqualObjects(sock, bSock, @"should be the same");
			WebSocket *ws = [WebSocket webSocketOnSocket:nSock];
			XCTAssertNotNil(ws, @"shouldnt be nil");
		}];
}

@end
