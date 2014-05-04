// Creates an NSNetServiceBrowser that searches for services of a particular type in a particular domain. If a service is currently being resolved, stop resolving it and stop the service browser from discovering other services. The Bonjour service type to browse for, e.g. @"_http._tcp"  The initial domain to browse in (pass nil to start in domains list)

#define NSNSB NSNetServiceBrowser
#define NSNS NSNetService

#import "AtoZ.h"
#import "AZBonjourBlock.h"

@implementation  NSNetService (URL) - (NSURL*) URL {  return $URL($(@"http://%@:%ld",self.hostName, self.port)); } @end

@interface AZBonjourBlock ()	@property NSNSB* netServiceBrowser; @property NSMA * consumers, * types; @end

@implementation AZBonjourBlock


+ (instancetype) instanceWithTypes:(NSA*)types consumer:(void(^)(NSNS*svc))block {

	AZBonjourBlock *b; 			[b = self.new addConsumer:block];
	b.netServiceBrowser 				= NSNSB.new;
	b.netServiceBrowser.delegate 	= b;
	[types ?: @[@"_http._tcp"] do:^(id obj) { [b.netServiceBrowser searchForServicesOfType:obj inDomain:nil]; }];
	return b;
}

- (void) netServiceBrowser:(NSNSB*)b didFindService:(NSNS*)svc moreComing:(BOOL)more { if (!self.content) self.content = NSMA.new;

	svc.delegate = self; [self addObject:svc]; [svc resolveWithTimeout:5];  // Found one, add it and reosolve it.
	COLORLOG(@"didFindService:",svc.name,@"domain: ", svc.domain, @"port: ", @(svc.port), nil);

}
- (void) netServiceDidResolveAddress:(NSNS*)svc { 	[self updateConsumers];

	COLORLOG(svc, zSPC, AZSELSTR, svc.name, zSPC, svc.domain, zSPC, @(svc.port), nil);
}
- (NSA*) services { return self.content; }

- (void) addConsumer:(void(^)(NSNS*))block{ [_consumers = _consumers ?: NSMA.new addObject:[block copy]]; [self updateConsumers];
}
- (void) updateConsumers {  [_consumers each:^(void(^x)(NSNS*)) { NSA *hash = [x associatedValueForKey:@"bonjourHash"] ?: @[];

		[x setAssociatedValue:[hash arrayByAddingAbsentObjectsFromArray:
									[[self.arrangedObjects arrayWithoutArray:hash] mapArray:^id(NSNS* svc) { x(svc);return svc; }]]
																	forKey:@"bonjourHash"];
	}];
}
//- (void) setServiceBrowser:(NSNetServiceBrowser*)netServiceBrowser didRemoveService:(NSNetService*)service moreComing:(BOOL)moreComing {
//	// If a service went away, stop resolving it if it's currently being resolved,
//	// remove it from the list and update the table view if no more events are queued.
//	[self willChangeValueForKey:@"services"];
//	[self removeObject:service];
//	[self didChangeValueForKey:@"services"];
//	// If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
//	// When moreComing is set, we don't update the UI so that it doesn't 'flash'.
//	if (!moreComing) [self rearrangeObjects];
//}	

//- (void) setServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreServicesComing {

//- (void) setServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
//- (void) setServiceDidResolveAddress:(NSNetService *)service {
//- (void) setServiceDidPublish:(NSNetService *)service {

	// If a service came online, add it to the list and update the table view if no more events are queued.

//	NSLog(@"added Service....  %@  ct: %ld", service, [self.arrangedObjects count]);
//	NSBeep();
//	[self updateConsumers];

//			[NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {

//			} repeats:YES];
	// If moreComing is NO, it means that there are no more messages in the queue from the Bonjour daemon, so we should update the UI.
	// When moreComing is set, we don't update the UI so that it doesn't 'flash'.
//	if (!moreComing) [self rearrangeObjects];
//    if ([@"haurus" isEqualToString:netService.name]) {
//        NSLog(@"didFindService: %@",netService.addresses);
//        NSInputStream		*inStream;
//        NSOutputStream		*outStream;
//        if (![netService getInputStream:&inStream outputStream:&outStream]) {
//            NSLog(@"Failed connecting to server");
//            return;
//        }
//        _inStream=inStream;
//        _outStream=outStream;
//    }

- (void) setServiceWillPublish:(NSNetService *)netService {
    COLORLOG(@"netServiceWillPublish netServicePort:", @(netService.port),nil);	//    [services addObject:netService];
}
- (void) setServiceDidPublish:(NSNetService *)sender {
    COLORLOG(@"netServiceDidPublish netServicePort:",@([sender port]),nil);
	 [self updateConsumers];
}
 
- (void) setService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict {
    COLORLOG(@"didNotPublish netServicePort:%ld", @([sender port]), nil );
}
 
- (void) setServiceWillResolve:(NSNetService *)sender {
   COLORLOG(@"netServiceWillResolve netServicePort:%ld",@([sender port]), nil);
}
 


- (void) setService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {


    NSLog(@"didNotResolve netServicePort:%ld", [sender port]);
}
//    NSLog(@"netServiceDidResolveAddress");
//    NSString *name = nil;
//    NSData *address = nil;
//    struct sockaddr_in *socketAddress = nil;
//    NSString *ipString = nil;
//    int port;
//    name = [netService name];
//    address = [[netService addresses] objectAtIndex: 0];
//    socketAddress = (struct sockaddr_in *) [address bytes];
//    ipString = [NSString stringWithFormat: @"%s",inet_ntoa(socketAddress->sin_addr)];
//    port = socketAddress->sin_port;
//    // This will print the IP and port for you to connect to.
//    NSLog(@"%@", [NSString stringWithFormat:@"Resolved:%@-->%@:%hu\n", [service hostName], ipString, port]);
//    [self openStreams];}

- (void) setService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data {
    NSLog(@"didUpdateTXTRecordData netServicePort:%ld", [sender port]);
}
- (void) setServiceDidStop:(NSNetService *)netService {
    NSLog(@"netServiceDidStop netServicePort:%ld", netService.port); //    [services removeObject:netService];
}
#pragma mark - NSNetServiceBrowserDelegate Methods
- (void) setServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing {
    NSLog(@"didFindDomain");
}
- (void) setServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveDomain:(NSString *)domainName moreComing:(BOOL)moreDomainsComing {
    NSLog(@"didRemoveDomain");
}
- (void) setServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo {
    NSLog(@"didNotSearch");
}
 
- (void) setServiceBrowserWillSearch:(NSNetServiceBrowser *)netServiceBrowser {
    NSLog(@"netServiceBrowserWillSearch");
}
 
- (void) setServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
    NSLog(@"netServiceBrowserDidStopSearch");
}

@end
