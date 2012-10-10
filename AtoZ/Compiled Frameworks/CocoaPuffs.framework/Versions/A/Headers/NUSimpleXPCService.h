
#import <Foundation/Foundation.h>
#import <xpc/xpc.h>

extern NSString *kSimpleXPCMessageNameKey;
extern NSString *kSimpleXPCTimestampKey;
extern NSString *kSimpleXPCShouldReplyKey;

@class NUSimpleXPCServer;
@class NUSimpleXPCPeer;
@class NUSimpleXPCEvent;


// -----------------------------------------------------------------------------
   #pragma mark - C-Functions
// -----------------------------------------------------------------------------

xpc_object_t xpcObjectFromObject(id object);
id objectFromXPCObject(xpc_object_t xpc_object);



// -----------------------------------------------------------------------------
   #pragma mark - NSObject Category
// -----------------------------------------------------------------------------

@interface NSObject (NUSimpleXPCServiceExtension)

/**
 
 \brief     Returns a NSObject based on the given XPC object.
 
 \details   Most of the XPC types are supported but the following are NOT:
 
            - XPC_TYPE_SHMEM
            - XPC_TYPE_CONNECTION
            - XPC_TYPE_ENDPOINT
 
            Also, XPC_TYPE_UUID are automatically converted to UUID strings.
 
 */
+ (id) objectFromXPCObject:(xpc_object_t)object;

/**
 
 \brief     Returns a XPC object from a given NSObject descendant.
 
 \details   This method supports only the basic types supported by XPC.
            The following types are NOT supported:
 
            - XPC_TYPE_SHMEM
            - XPC_TYPE_CONNECTION
            - XPC_TYPE_ENDPOINT
 
 */            
- (xpc_object_t) xpcObject;

@end


typedef void (^NUSimpleXPCPeerEventHandler)(NUSimpleXPCEvent *event);

// COV_NF_START

// -----------------------------------------------------------------------------
   #pragma mark - NUSimpleXPCEvent
// -----------------------------------------------------------------------------

@interface NUSimpleXPCEvent : NSObject 

- (id) initWithXPCMessage:(xpc_object_t)xpc_msg withPeer:(NUSimpleXPCPeer*)peer;
+ (id) eventWithXPCMessage:(xpc_object_t)xpc_msg withPeer:(NUSimpleXPCPeer*)peer;

- (id) initFromPeer:(NUSimpleXPCPeer*)peer;
+ (id) eventFromPeer:(NUSimpleXPCPeer*)peer;

@property (readonly) NUSimpleXPCPeer *source;
@property (readonly) NSString        *name;
@property (readonly) NSDate          *timestamp;
@property (readonly) NSDictionary    *message;
@property (readonly) BOOL replyExpected;

- (void) postMessage:(NSDictionary*)msg withName:(NSString*)aName handleReply:(NUSimpleXPCPeerEventHandler)replyBlock;
- (void) postMessage:(NSDictionary*)msg withName:(NSString*)aName;

+ (void) postMessage:(NSDictionary*)msg withName:(NSString*)aName fromPeer:(NUSimpleXPCPeer*)aPeer handleReply:(NUSimpleXPCPeerEventHandler)replyBlock;

@end


// -----------------------------------------------------------------------------
   #pragma mark - NUSimpleXPCPeer
// -----------------------------------------------------------------------------

/**
 
 \brief     Class that can interact with a XPC service.
 
 \details   NUSimpleXPCPeer is a wrapper object that hides some of the details
            of XPC services behind an object facade. To use it correctly both
            the clients and the server should follow some conventions.

            Unlike regular XPC services, NUSimpleXPCPeer forces the user to 
            name his messages (a bit like the NSNotificationCenter). Given 
            than each message has a name here is how the client handles 
            incoming messages from the server:
 
            if there was an error then
 
                if the error was XPC_ERROR_CONNECTION_INTERRUPTED then
                    call handleConnectionInterrupted
                otherwise if the error was XPC_ERROR_CONNECTION_INVALID then
                    call handleConnectionInvalid
                otherwise if the error was XPC_ERROR_TERMINATION_IMMINENT then
                    call handleTerminationImminent
                otherwise   
                    call handleUnknownError
 
            if there was no error and the message is name "message" then

                if "message" is nil then
                    call handleUnknownMessage:withInfo:
                else if method with name handle"message" exists then
                    call handle"message":
                else if peer has a messageHandler then
                    call messageHandler()
                else
                    call handleUnknownMessage:withInfo:
 
            If the peer understands only one or two message names then perhaps
            a message handler is the simplest way to use this object. If many
            messages need to be handled then subclassing and implementing
            handle selectors is the most elegant solution.
 
 */
@interface NUSimpleXPCPeer : NSObject

/// Initializes the peer with an existing connection.
- (id) initWithConnection:(xpc_connection_t)aConnection;
+ (id) peerWithConnection:(xpc_connection_t)aConnection;

/// Creates a peer that connects to a given service name and processes messages on the `queue` dispatch queue.
- (id) initPeerWithServiceName:(NSString*)serviceName onDispactchQueue:(dispatch_queue_t)queue;
+ (id) peerWithServiceName:(NSString*)serviceName onDispactchQueue:(dispatch_queue_t)queue;

/// Creates a peer that connects to a given service name and processes messages on the default dispatch queue.
+ (id) peerWithServiceName:(NSString*)serviceName;

/// Name of the connection, which combines the service name and the process id.
@property (readonly) NSString *name;

/// Block that handles messages if no handleXXX method is found for the gevin message.
@property (copy) NUSimpleXPCPeerEventHandler eventHandler;

/// Connection on which this object relies for communication.
@property (readonly) xpc_connection_t connection;

/// Post a named message with accompanying dictionary.
- (void) postMessage:(NSDictionary*)msg withName:(NSString*)name;

/// Post a message and wait for a reply which can be processed by the block asynchronously.
/// Note that the message name in the reply block will be the same as the posted message.
- (void) postMessage:(NSDictionary*)msg withName:(NSString*)name handleReply:(NUSimpleXPCPeerEventHandler)replyBlock;

/// Handles the XPC_ERROR_CONNECTION_INTERRUPTED error.
/// Default implementation does nothing.
- (void) handleInterruptedConnection;

/// Handles the XPC_ERROR_INVALID_CONNECTION error.
/// Default implementation does nothing.
- (void) handleInvalidConnection;

/// Handles the XPC_ERROR_TERMINATION_IMMINENT error.
/// Default implementation does nothing.
- (void) handleTerminationImminent;

/// Handles all other types of errors that are not handled by other methods.
/// Default implementation does nothing.
- (void) handleUnknownError:(xpc_object_t)error;

/// Handles unnamed messages or messages whose names are not handled.
/// Default implementation does nothing.
- (void) handleUnknownEvent:(NUSimpleXPCEvent*)event;

/// Called whenever some state related to the connection needs to be cleaned-up.
/// Default implementation does nothing.
- (void) cleanup;

/// Low-level message processing facility.
- (void) processMessage:(xpc_object_t)message withReplyBlock:(NUSimpleXPCPeerEventHandler)replyBlock;

@end


// -----------------------------------------------------------------------------
   #pragma mark - NUSimpleXPCServer
// -----------------------------------------------------------------------------


/**
 
 \brief     Encapsulates the behavior of an XPC service.
 
 \details   A server object acts pretty much the same as the peer object except
            that all method calls that all message or error handling calls that
            would normally be directed to the server-side peer connection get
            delegated back to the server object. In other words, the server
            object acts as a delegate to all its peer connections.
 
 */
@interface NUSimpleXPCServer : NUSimpleXPCPeer

+ (id) server;
+ (id) serverWithEventHandler:(NUSimpleXPCPeerEventHandler)eventHandler;
- (id) serverWithConnection:(xpc_connection_t)aConnection;

@end

/// After having initialized a NUSimpleXPCServer call this function.
void NUSimpleXPCServer_main(NUSimpleXPCServer *server);

// COV_NF_END
