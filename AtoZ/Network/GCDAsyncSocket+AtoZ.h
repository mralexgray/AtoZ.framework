

#import "AtoZUmbrella.h"

#import "GCDAsyncSocket.h"

#define ASOCK GCDAsyncSocket

typedef NSTimeInterval( ^TimeOutTagsElapsedBytes )(ASOCK*sock, long tag, NSTI elapsed, NSUI len);
typedef 			   void( ^DidConnectToHostPort 	 )(ASOCK*sock, NSS*host, uint16_t port);
typedef 				void( ^DidAcceptNewSocket		 )(ASOCK*sock, ASOCK*nSock);


@interface GCDAsyncSocket (AtoZProperties) <GCDAsyncSocketDelegate>

+ (instancetype) listenOnPort:(NSUInteger) port;

@property (RONLY) NSUInteger port;

/** 	Called when a socket accepts a connection. Another socket is automatically spawned to handle it.
	You must retain the newSocket if you wish to handle the connection.
 	Otherwise the newSocket instance will be released and the spawned connection will be closed.
	By default the new socket will have the same delegate and delegateQueue. You may, of course, change this at any time. */
- (DidAcceptNewSocket) didAcceptNewSocket;
- 					 (void) setDidAcceptNewSocket:(DidAcceptNewSocket)didAcceptNewSocket;

/**	didConnectToHostPort -
	Called when a socket connects and is ready for reading and writing. he host parameter will be an IP address, not a DNS name.
		didWriteDataWithTag -
	Called when a socket has completed writing the requested data. Not called if there is an error.
		didReadDataWithTag -
	Called when a socket has completed reading the requested data into memory. Not called if there is an error.	*/
@property (CP) void (^ didConnectToHostPort) (ASOCK*sock,NSString*host,uint16_t port);
@property (CP) void (^                     didWriteDataWithTag) (ASOCK*,long);
@property (CP) void (^                      didReadDataWithTag) (ASOCK*,NSData*,long);

/**	Called if a read operation has reached its timeout without completing.
	This method allows you to optionally extend the timeout.
	If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
	If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
	The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
	The length parameter is the number of bytes that have been read so far for the read operation.
	Note that this method may be called multiple times for a single read if you return positive numbers.  **/
@property (CP) NSTI (^shouldTimeoutReadWithTagElapsedBytesDone) (ASOCK*,long,NSTI,NSUI);

/**	Called when a socket disconnects with or without error.
	If you call the disc. method, + the socket wasn't already disc, this del meth will be called b4 the disc. meth. returns. */
@property (CP) void (^                  didDisconnectWithError) (ASOCK*,NSERR*);

@end



/**
 * This method is called immediately prior to socket:didAcceptNewSocket:.
 * It optionally allows a listening socket to specify the socketQueue for a new accepted socket.
 * If this method is not implemented, or returns NULL, the new accepted socket will create its own default queue.
 * 
 * Since you cannot autorelease a dispatch_queue,
 * this method uses the "new" prefix in its name to specify that the returned queue has been retained.
 * 
 * Thus you could do something like this in the implementation:
 * return dispatch_queue_create("MyQueue", NULL);
 * 
 * If you are placing multiple sockets on the same queue,
 * then care should be taken to increment the retain count each time this method is invoked.
 * 
 * For example, your implementation might look something like this:
 * dispatch_retain(myExistingQueue);
 * return myExistingQueue;
**/
//- (dispatch_queue_t)newSocketQueueForConnectionFromAddress:(NSData *)address onSocket:(GCDAsyncSocket *)sock;
/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
**/
//- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
**/
//- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;
/**
 * Called if a write operation has reached its timeout without completing.
 * This method allows you to optionally extend the timeout.
 * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
 * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
 * 
 * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
 * The length parameter is the number of bytes that have been written so far for the write operation.
 * 
 * Note that this method may be called multiple times for a single write if you return positive numbers.
**/
//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag
//                                                                  elapsed:(NSTimeInterval)elapsed
//                                                                bytesDone:(NSUInteger)length;
/**
 * Conditionally called if the read stream closes, but the write stream may still be writeable.
 * 
 * This delegate method is only called if autoDisconnectOnClosedReadStream has been set to NO.
 * See the discussion on the autoDisconnectOnClosedReadStream method for more information.
**/
//- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock;
/**
 * Called after the socket has successfully completed SSL/TLS negotiation.
 * This method is not called unless you use the provided startTLS method.
 * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
 * and the socketDidDisconnect:withError: delegate method will be called with the specific SSL error code.	**/
//- (void)socketDidSecure:(GCDAsyncSocket *)sock;

