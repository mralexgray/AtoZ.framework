//
//  GCDAsyncSocket+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 10/9/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "GCDAsyncSocket+AtoZ.h"


//#define RET_ASSOC return objc_getAssociatedObject(self,_cmd)
//#define SET_ASSOC(X)  ({ objc_setAssociatedObject(self, NSSelectorFromString([NSString stringWithUTF8String:#X]),X, OBJC_ASSOCIATION_COPY_NONATOMIC); self.delegate = self; })


@implementation GCDAsyncSocket (AtoZProperties)

+ (instancetype) listenOnPort:(NSUInteger) port {  dispatch_queue_t x = dispatch_queue_create(AZSELSTR.UTF8String,NULL);

	GCDAsyncSocket *sock = [self.alloc initWithSocketQueue:x];
	[sock acceptOnPort:port error:nil]; return sock;
}

- (void(^)(ASOCK*,NSError*)) 			 didDisconnectWithError { RET_ASSOC; }
- (void(^)(ASOCK*,NSString*,uint16_t)) didConnectToHostPort { RET_ASSOC; }
- (void(^)(ASOCK*,ASOCK*))					  didAcceptNewSocket { RET_ASSOC; }
- (void(^)(ASOCK*,NSData*,long))			  didReadDataWithTag { RET_ASSOC; }
- (void(^)(ASOCK*,long))					 didWriteDataWithTag { RET_ASSOC; }
- (TimeOutTagsElapsedBytes) shouldTimeoutReadWithTagElapsedBytesDone { RET_ASSOC; }

- (void) setDidDisconnectWithError:	(void(^)(ASOCK*,NSError*))        didDisconnectWithError { SET_ASSOC_DELEGATE(didDisconnectWithError);}
- (void) setDidConnectToHostPort:	(void(^)(ASOCK*,NSString*,uint16_t))didConnectToHostPort { SET_ASSOC_DELEGATE(didConnectToHostPort); 	}
- (void) setDidAcceptNewSocket:		(void(^)(ASOCK*,ASOCK*))              didAcceptNewSocket	{ SET_ASSOC_DELEGATE(didAcceptNewSocket);	 	}
- (void) setDidReadDataWithTag:		(void(^)(ASOCK*,NSData*,long))        didReadDataWithTag	{ SET_ASSOC_DELEGATE(didReadDataWithTag); 	}
- (void) setDidWriteDataWithTag:		(void(^)(ASOCK*,long))               didWriteDataWithTag	{ SET_ASSOC_DELEGATE(didWriteDataWithTag);  	}
- (void) setShouldTimeoutReadWithTagElapsedBytesDone:(TimeOutTagsElapsedBytes)       timeout { SET_ASSOC_DELEGATE(timeout);}


- (void) socket:(ASOCK*)sock didAcceptNewSocket:(ASOCK*)newSocket { NSLog(@"Inside the blocked delegate!");
	if (self.didAcceptNewSocket)   self.didAcceptNewSocket(sock, newSocket);
}

- (void)socketDidDisconnect:(ASOCK*)sock withError:(NSError *)err {
	if (self.didDisconnectWithError) self.didDisconnectWithError(self, err); }
- (void) socket:(ASOCK*)sock didReadData:(NSData *)data withTag:(long)tag{
	if (self.didReadDataWithTag)   self.didReadDataWithTag(self, data, tag);
}
- (void) socket:(ASOCK*)sock didWriteDataWithTag:(long)tag{ if (self.didWriteDataWithTag)  self.didWriteDataWithTag(self, tag);	}
- (void) socket:(ASOCK*)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
	if (self.didConnectToHostPort) self.didConnectToHostPort(self, host, port);	}
- (NSTimeInterval) socket:(ASOCK*)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length {
	return self.shouldTimeoutReadWithTagElapsedBytesDone ? self.shouldTimeoutReadWithTagElapsedBytesDone(self, tag, elapsed, length) : 0;	}
- (NSUInteger) port { return  [self localPort]; }
@end



#define RUN_ASSOC(CMD,...) do { \
	NSString *sel = NSStringFromSelector(CMD); NSMutableArray *parts = [sel componentsSeparatedByString:@":"].mutableCopy;\
	[parts removeObjectAtIndex:0];  __block NSMutableString *newSel; [parts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL*stop){\
	NSString *adder = [obj stringByReplacingOccurrencesOfString:@":" withString:@""];\
	if (idx == 0) newSel = adder.mutableCopy; else [newSel appendString:adder.uppercaseString]; }];\
	NSLog(@"%@", newSel); \
	/*	id blk; if ((blk = [self valueForKey:newSel])) blk(self,__VA_ARGS__); */\
	} while(0)
//NSTimeInterval (^)(ASOCK*sock, long tag, NSTimeInterval elapsed,NSUInteger len)) shouldTimeoutReadWithTagElapsedBytesDone { RET_ASSOC; }
//NSTimeInterval (^)(ASOCK*sock, long tag, NSTimeInterval elapsed,NSUInteger len))
//		      shouldTimeoutReadWithTagElapsedBytesDone {//NSTimeInterval (^)(ASOCK*sock,long tag,NSTimeInterval elapsed,NSUInteger legth)
//	RUN_ASSOC(_cmd, newSocket);
