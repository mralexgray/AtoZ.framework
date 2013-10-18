//
//  WebSocket+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 10/9/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AtoZUmbrella.h"
#import "WebSocket+AtoZ.h"


@implementation WebSocket (Convenience)
+ (instancetype) webSocketOnSocket:(ASOCK*)sock { return [self.alloc initWithRequest:HTTPMessage.alloc.initEmptyRequest socket:sock]; }
@end



//@interface WebSocket ()// Private category for use by RSMWebSocket.
// Initializes the receiver with the given request, socket, and opened block. This should never be called manually.
// message - The request which opened the socket.
// socket  - The underlying socket.
// opened  - A block to be called when the socket has been opened. Cannot be NULL.
// Returns the initialized object.
//- (id)initWithRequest:(HTTPMessage *)message socket:(GCDAsyncSocket *)socket opened:(void (^)(RSMWebSocket *socket))opened;
//
//@end

//@concreteprotocol(SocketBlock)
//SYNTHESIZE_ASC_OBJ(didReceiveMessageBlock, setDidReceiveMessageBlock)
//-(void) websock
//@end

@implementation WebSocket (AtoZBlockDelegate)

SYNTHESIZE_DELEGATE(	didOpenBlock, setDidOpenBlock,
							(void(^)(WebSocket*ws)),
							(void)webSocketDidOpen:(WebSocket*)ws,
							DO_IF_SELF(didOpenBlock))

SYNTHESIZE_DELEGATE(	didCloseBlock, setDidCloseBlock,
							(void(^)(WebSocket*ws)),
							(void)webSocketDidClose:(WebSocket*)ws,
							DO_IF_SELF(didCloseBlock))

SYNTHESIZE_DELEGATE(	didReceiveMessageBlock, setDidReceiveMessageBlock,
							(void (^)(WebSocket*ws,NSString*msg)),
							(void) webSocket:(WebSocket*)ws didReceiveMessage:(NSString *)msg,
							DO_IF_1ARG(didReceiveMessageBlock,msg))

//- (void(^)(WebSocket*ws)) 						  didOpenBlock { RET_ASSOC; }
//- (void(^)(WebSocket*ws)) 						 didCloseBlock { RET_ASSOC; }
//- (void(^)(WebSocket*ws,NSS*msg)) didReceiveMessageBlock { RET_ASSOC; }

//- (void) setDidOpenBlock:				(void (^)(WebSocket*ws              ))openBlk 	{ SET_ASSOC(openBlk);	}
//- (void) setDidCloseBlock:				(void (^)(WebSocket*ws					))closeBlk 	{ SET_ASSOC(closeBlk);	}
//- (void) setDidReceiveMessageBlock: (void (^)(WebSocket*ws,NSString*msg	))recMsgBlk { SET_ASSOC(recMsgBlk); }

//- (void) webSocketDidOpen:	(WebSocket*)ws 												{ DO_IF_SELF(didOpenBlock); 					}
//- (void) webSocketDidClose:(WebSocket*)ws 												{ DO_IF_SELF(didCloseBlock); 					}
//- (void) webSocket:			(WebSocket*)ws didReceiveMessage:(NSString *)msg 	{ DO_IF_1ARG(didReceiveMessageBlock,msg);	}

@end



#import <ifaddrs.h>
#import <netinet/in.h>
#import <sys/socket.h>


NSDictionary * AZLocalHosts() {  NSMutableDictionary* result = [NSMutableDictionary dictionary];
	// An autorelease pool stores objects that are sent a release
	// message when the pool itself is drained.
	@autoreleasepool {

		struct ifaddrs* addrs;    // Creates an ifaddrs structure
		//function creates a linked list of structures describing the network interfaces of the local system, and stores the address of the first item of the list in *ifap.
		BOOL success = (getifaddrs(&addrs) == 0);
		if (success)		// If successful in getting the addresses
		{
			const struct ifaddrs* cursor = addrs;   			// Create a constant read only local attribute
			while (cursor != NULL)											// Loop through the struct while not NULL
			{
				NSMutableString* ip;										            // Creates a local attribute
				if (cursor->ifa_addr->sa_family == AF_INET)            // AF_INET is the address family for an internet socket
				{
					const struct sockaddr_in* dlAddr = (const struct sockaddr_in*)cursor->ifa_addr;	// Create a constant read only local attribute
					const uint8_t* base = (const uint8_t*)&dlAddr->sin_addr;					// Create a constant read only local attribute
					ip = [[NSMutableString new] autorelease];													// Initializes and allocates memory for the new ip
					for (int i = 0; i < 4; i++) 					// Loops through the address and adds a period
					{
						if (i != 0)
							[ip appendFormat:@"."];
						[ip appendFormat:@"%d", base[i]];
					}
					[result setObject:(NSString*)ip forKey:[NSString stringWithFormat:@"%s", cursor->ifa_name]];
				}
				cursor = cursor->ifa_next;
			}
			// frees the address
			freeifaddrs(addrs);
		}
	}
	return result;
}
