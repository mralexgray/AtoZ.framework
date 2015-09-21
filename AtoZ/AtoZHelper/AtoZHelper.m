  //	[_httpServer get:@"/" withBlock:^(RouteRequest *request, RouteResponse *response) { }]
  //	_sockets = [NSAC.alloc initWithContent:NSMA.new];
  //	sock = [ASOCK listenOnPort:12345];
  //	[sock setDidAcceptNewSocket:^(GCDAsyncSocket *sock1, GCDAsyncSocket *nSock) {			NSLog(@"new sock:%@ onsock: %@",sock1,nSock); }];
  //	[_webView.mainFrame loadHTMLString: baseURL:nil]

#import "AtoZHelper.h"

//#import RoutingHTTPServer;

AZAPPMAIN

@implementation AtoZHelper // { ASOCK *sock; }

- (void) awakeFromNib {

  [_httpServer = [RoutingHTTPServer.new wVsfKs:@(3334),@"port",nil]  start:nil];
	[self setupRoutes];
  _webView.mainFrameURL = $(@"http://%s:3334/colorlist", getenv("HOSTNAME"));
	_webView2.mainFrameURL = @"http://mrgray.com:22080/testsocket.html";

	AZAPPACTIVATE;
	[_text setTextDidChange:^(NSText *t) {	NSLog(@"text:%@  socetconnected:%@", t.lastLetter, @"YES"); }]; //StringFromBOOL(sock.isConnected));	}];

	/* Post a notification when we are done launching so the application bridge can inform participating applications
	 NSInteger menuState;
	 menuState == GrowlDockMenu || menuState == GrowlBothMenus ?  [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular] : nil;
	 */
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"ATOZ_IS_READY"
																															 object:nil userInfo:nil deliverImmediately:YES];
}


- (void) colorlist:(RouteRequest*)req withResponse:(RouteResponse*)resp {

  //	[resp respondWithJQueried:
  [resp respondWithString:
  [[NSColor.randomPalette /* colorNames */ reduce:@"<html><head><title>TEST</title>\
                              <style> div { float:left; margin: 20px; padding: 20px; width:100px; height:100px; } </style>\
                              <script src='http://mrgray.com/atoz.js'></script></head><body><ul style='list-style:none;'>".mC withBlock:^id(id sum, NSC* color) {
                                NSS *values = $(@"bright: %f, hue: %f,  sat: %f",	color.brightnessComponent,
                                                color.hueComponent,
                                                color.saturationComponent);
                                [sum appendFormat: @"<li>"\
                                 "<div>%@ %@ </div>"\
                                 "<div style='background-color:#%@; color: %@; %@> %@<div>"\
                                 "<span><img alt='icon' style='width:100%%; height:100%%;' src='data:image/png;base64,%@' /></span>"\
                                 "</li>", 	color.nameOfColor,
                                 color.isBoring ? @"IS VERY BORING": @"IS EXCITING!",
                                 color.toHex,
                                 color.contrastingForegroundColor.toHex,
                                 color.isBoring ? @"'": @" outline:10px solid red;'",
                                 values,[[NSIMG.randomMonoIcon scaledToMax:200] base64EncodingWithFileType:NSPNGFileType]]; return sum;
                              }] withString:@"</ul></body></html>"]];

}

- (void) setupRoutes {

	[@[	@[ @"/colorlist", 	@"colorlist:withResponse:"], 	//	SELECTORS AS STRINGS
      @[ @"/selector",	@"handleSelectorRequest:withResponse:"]] each:^(id obj){

        [_httpServer handle:HTTPGET path:obj[0] target:self action:NSSelectorFromString(obj[1])];
  }];
	[_httpServer get:@"/randomicon" handler:^(RouteRequest *request, RouteResponse *response) {
		[response respondWithData:[[NSIMG.randomMonoIcon scaledToMax:300]PNGRepresentation]];
	}];

	[_httpServer get:@"/hello" handler:^(RouteRequest *request, RouteResponse *response) {
		[response respondWithString:@"Hello!"];
	}];
//	[_httpServer get:@"/hello/:name" withBlock:^(RouteRequest *request, RouteResponse *response) {
//		[response respondWithString:[NSString stringWithFormat:@"Hello %@!", request[@"name"]]];
//	}];
//	[_httpServer get:@"{^/page/(\\d+)}" withBlock:^(RouteRequest *request, RouteResponse *response) {
//		[response respondWithString:[NSString stringWithFormat:@"You requested page %@",request[@"captures"][0]]];
//	}];
//	[_httpServer post:@"/widgets" withBlock:^(RouteRequest *request, RouteResponse *response) {
//		// Create a new widget, [request body] contains the POST body data. For this example we're just going to echo it back.
//		[response respondWithData:[request body]];
//	}];
//	// Routes can also be handled through selectors
//	[_httpServer handleMethod:@"GET" withPath:@"/selector" target:self selector:@selector(handleSelectorRequest:withResponse:)];
//
//	[_httpServer get:@"/say/:phrase" withBlock:^(RouteRequest *request, RouteResponse *response) {
//		NSString *say = request[@"phrase"];
//		NSLog(@"phrase:%@", say);
//		[AZTalker say:say];
//    //		[response respondWithString:say];
//		[AZTalker say:say toURL:^(NSURL *u) {
//			NSLog(@"data:%@", u);
//      //			[response respondWithFile:[u path] async:NO];
//			[response respondWithData:[NSData dataWithContentsOfURL:u]];
//			//[[NSIMG.randomMonoIcon scaledToMax:300]PNGRepresentation]];
//		}];
//	}];
}

//- (void) handleSelectorRequest:(RREQ*)req withResponse:(RRES*)resp {
//  [resp respondWithString:@"Handled through selector"];
//}

/*
 - (void) ebSocketServer:(SOCKSRVR*)webSocketServer didAcceptConnection:(GCDAsyncSocket *)connection{


 NSLog(@"%@", NSStringFromSelector(_cmd));
 NSString *words =  [NSString stringWithContentsOfFile:@"/usr/share/dict/web2" encoding:NSUTF8StringEncoding error:nil];
 //	 @"/sd/git/MBWebSocketServer/README.md"

 [connection writeWebSocketFrame:[words dataUsingEncoding:NSUTF8StringEncoding]];
 }
 //	tmr = [NSTimer timerWithTimeInterval:1.0 target:self
 //													 selector:@selector(spit:) userInfo:@[connection,words] repeats:YES];
 //	[NSRunLoop.mainRunLoop addTimer:tmr forMode:NSDefaultRunLoopMode]; }
 //- (void) spit:(NSTimer*)t{ NSLog(@"FIRE! %@", t.userInfo[0]);
 ////	 if (![t.userInfo[1]count]) return [t invalidate], NSLog(@"I invalidated!!");
 // if (![t.userInfo[1] count]) return [t invalidate], NSLog(@"I invalidated!!");
 //	 NSString* x = t.userInfo[1][0];  NSLog(@"X:%@",t.userInfo);
 //	[t.userInfo[0] writeWebSocketFrame:x];
 //	[t.userInfo[1] removeObjectAtIndex:0];
 //}


 - (void) ebSocketServer:(SOCKSRVR*)webSocketServer clientDisconnected:(ASOCK*)connection {
 NSLog(@"%@", NSStringFromSelector(_cmd));
 }
 - (void) ebSocketServer:(SOCKSRVR*)webSocket didReceiveData:(NSData *)data fromConnection:(ASOCK*)connection{
 NSLog(@"%@", NSStringFromSelector(_cmd));
 }
 - (void) ebSocketServer:(SOCKSRVR*)webSocketServer couldNotParseRawData:(NSData *)rawData fromConnection:(ASOCK*)connection error:(NSError *)error {
 NSLog(@"%@  %@", NSStringFromSelector(_cmd), error);
 }
 */
- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSAPP*)theApplication { return NO; }
- (void) applicationWillTerminate:(NSNOT*)notification													{
  //	[[AtoZ.sharedInstance atozDelegate] isEqualTo:self] ? [AtoZ.sharedInstance setAtozDelegate:nil] : nil;
}
- (IBAction)quitWithWarning:(id)x {
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"HideQuitWarning"])
    {
		NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Are you sure you want to quit?", nil)
																		 defaultButton:NSLocalizedString(@"Yes", nil)
																	 alternateButton:NSLocalizedString(@"No", nil)
																			 otherButton:nil
												 informativeTextWithFormat:NSLocalizedString(@"If you quit Growl you will no longer receive notifications.", nil)];
		[alert setShowsSuppressionButton:YES];

		NSInteger result = [alert runModal];
		if(result == NSOKButton)
      {
			[[NSUserDefaults standardUserDefaults] setBool:[[alert suppressionButton] state] forKey:@"HideQuitWarning"];
			[NSApp terminate:self];
      }
    }
	else
		[NSApp terminate:self];
}
@end
/*
 + (NSString*)getAudioDevice
 {
 NSString *result = nil;
 AudioObjectPropertyAddress propertyAddress = {kAudioHardwarePropertyDefaultSystemOutputDevice, kAudioObjectPropertyScopeGlobal, kAudioObjectPropertyElementMaster};
 UInt32 propertySize;

 if(AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &propertySize) == noErr)
 {
 AudioObjectID deviceID;
 if(AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &propertySize, &deviceID) == noErr)
 {
 NSString *UID = nil;
 propertySize = sizeof(UID);
 propertyAddress.mSelector = kAudioDevicePropertyDeviceUID;
 propertyAddress.mScope = kAudioObjectPropertyScopeGlobal;
 propertyAddress.mElement = kAudioObjectPropertyElementMaster;
 if (AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, NULL, &propertySize, &UID) == noErr)
 {
 result = [NSString stringWithString:UID];
 CFRelease((__bridge CFTypeRef)(UID));
 }
 }
 }
 return result;
 }
 }
 */
/**

 - (void) applicationWillFinishLaunching:(NSNotification *)aNotification {

 BOOL printVersionAndExit = [[NSUserDefaults standardUserDefaults] boolForKey:@"PrintVersionAndExit"];
 if (printVersionAndExit) {
 printf("This is GrowlHelperApp version %s.\n"
 "PrintVersionAndExit was set to %hhi, so GrowlHelperApp will now exit.\n",
 [[self stringWithVersionDictionary:nil] UTF8String],
 printVersionAndExit);
 [NSApp terminate:nil];
 }

 NSFileManager *fs = [NSFileManager defaultManager];

 NSString *destDir, *subDir;
 NSArray *searchPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES); //YES == expandTilde

 destDir = [searchPath objectAtIndex:0U]; //first == last == ~/Library
 destDir = [destDir stringByAppendingPathComponent:@"Application Support"];
 destDir = [destDir stringByAppendingPathComponent:@"Growl"];

 subDir  = [destDir stringByAppendingPathComponent:@"Tickets"];
 [fs createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
 subDir  = [destDir stringByAppendingPathComponent:@"Plugins"];
 [fs createDirectoryAtPath:subDir withIntermediateDirectories:YES attributes:nil error:nil];
 }


 - (BOOL) applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
 Same as applicationDidFinishLaunching, called when we are asked to reopen (that is, we are already running)
 We return yes, so we can handle activating the right window.
 }

 */
#pragma mark Auto-discovery
/*
 called by NSWorkspace when an application launches.
 - (void) applicationLaunched:(NSNotification *)notification {
 NSDictionary *userInfo = [notification userInfo];

 if (!userInfo)
 return;

 NSAutoreleasePool *pool = NSAutoreleasePool.new;
 NSString *appPath = [userInfo objectForKey:@"NSApplicationPath"];

 if (appPath) {
 NSString *ticketPath = [NSBundle pathForResource:@"Growl Registration Ticket" ofType:GROWL_REG_DICT_EXTENSION inDirectory:appPath];
 if (ticketPath) {
 NSURL *ticketURL = [NSURL fileURLWithPath:ticketPath];
 NSMutableDictionary *ticket = [NSDictionary dictionaryWithContentsOfURL:ticketURL];

 if (ticket) {
 NSString *appName = [userInfo objectForKey:@"NSApplicationName"];

 //set the app's name in the dictionary, if it's not present already.
 if (![ticket objectForKey:GROWL_APP_NAME])
 [ticket setObject:appName forKey:GROWL_APP_NAME];

 if ([GrowlApplicationTicket isValidAutoDiscoverableTicketDictionary:ticket]) {
 // set the app's location in the dictionary, avoiding costlylookups later.

 NSURL *url = [NSURL.alloc initFileURLWithPath:appPath];
 NSDictionary *file_data = dockDescriptionWithURL(url);
 id location = file_data ? [NSDictionary dictionaryWithObject:file_data forKey:@"file-data"] : appPath;
 [ticket setObject:location forKey:GROWL_APP_LOCATION];
 [url release];

 //write the new ticket to disk, and be sure to launch this ticket instead of the one in the app bundle.
 CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
 CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid);
 CFRelease(uuid);
 ticketPath = [[NSTemporaryDirectory() stringByAppendingPathComponent:(NSString *)uuidString] stringByAppendingPathExtension:GROWL_REG_DICT_EXTENSION];
 CFRelease(uuidString);
 [ticket writeToFile:ticketPath atomically:NO];

 // open the ticket with ourselves. we need to use LS in order to launch it with this specific	GHA, rather than some other.

 CFURLRef myURL = (CFURLRef)[[NSBundle mainBundle] bundleURL];
 NSArray *URLsToOpen = [NSArray arrayWithObject:[NSURL fileURLWithPath:ticketPath]];
 struct LSLaunchURLSpec spec = {
 .appURL = myURL,
 .itemURLs = (CFArrayRef)URLsToOpen,
 .passThruParams = NULL,
 .launchFlags = kLSLaunchDontAddToRecents | kLSLaunchDontSwitch | kLSLaunchAsync,
 .asyncRefCon = NULL,
 };
 OSStatus err = LSOpenFromURLSpec(&spec, / * outLaunchedURL * / NULL);
 if (err != noErr)
 NSLog(@"The registration ticket for %@ could not be opened (LSOpenFromURLSpec returned %li). Pathname for the ticket file: %@", appName, (long)err, ticketPath);
 } else if ([GrowlApplicationTicket isKnownTicketVersion:ticket]) {
 NSLog(@"%@ (located at %@) contains an invalid registration ticket - developer, please consult Growl developer documentation (http://growl.info/documentation/developer/)", appName, appPath);
 } else {
 NSNumber *versionNum = [ticket objectForKey:GROWL_TICKET_VERSION];
 if (versionNum)
 NSLog(@"%@ (located at %@) contains a ticket whose format version (%i) is unrecognised by this version (%@) of Growl", appName, appPath, [versionNum intValue], [self stringWithVersionDictionary:nil]);
 else
 NSLog(@"%@ (located at %@) contains a ticket with no format version number; Growl requires that a registration dictionary include a format version number, so that Growl knows whether it will understand the dictionary's format. This ticket will be ignored.", appName, appPath);
 }
 }
 }
 }

 [pool release];
 }
 */
#pragma mark Growl Application Bridge delegate
/*click feedback comes here first. GAB picks up the DN and calls our
 *	-growlNotificationWasClicked:/-growlNotificationTimedOut: with it if it's a
 *	GHA notification.
 */
/**
 - (void) rowlNotificationDict:(NSDictionary *)growlNotificationDict didCloseViaNotificationClick:(BOOL)viaClick onLocalMachine:(BOOL)wasLocal
 {
 static BOOL isClosingFromRemoteClick = NO;
 //Don't post a second close notification on the local machine if we close a notification from this method in response to a click on a remote machine.

 if (isClosingFromRemoteClick)
 return;

 id clickContext = [growlNotificationDict objectForKey:GROWL_NOTIFICATION_CLICK_CONTEXT];
 if (clickContext) {
 NSString *suffix, *growlNotificationClickedName;
 NSDictionary *clickInfo;

 NSString *appName = [growlNotificationDict objectForKey:GROWL_APP_NAME];
 NSString *hostName = [growlNotificationDict objectForKey:GROWL_NOTIFICATION_GNTP_SENT_BY];
 GrowlApplicationTicket *ticket = [ticketController ticketForApplicationName:appName hostName:hostName];

 if (viaClick && [ticket clickHandlersEnabled]) {
 suffix = GROWL_DISTRIBUTED_NOTIFICATION_CLICKED_SUFFIX;
 } else {
 // send GROWL_NOTIFICATION_TIMED_OUT instead, so that an application is guaranteed to receive feedback for every notification.
 suffix = GROWL_DISTRIBUTED_NOTIFICATION_TIMED_OUT_SUFFIX;
 }

 //Build the application-specific notification name
 NSNumber *pid = [growlNotificationDict objectForKey:GROWL_APP_PID];
 if (pid)
 growlNotificationClickedName = [NSString.alloc initWithFormat:@"%@-%@-%@",
 appName, pid, suffix];
 else
 growlNotificationClickedName = [NSString.alloc initWithFormat:@"%@%@",
 appName, suffix];
 clickInfo = [NSDictionary dictionaryWithObject:clickContext
 forKey:GROWL_KEY_CLICKED_CONTEXT];
 [[NSDistributedNotificationCenter defaultCenter] postNotificationName:growlNotificationClickedName
 object:nil
 userInfo:clickInfo
 deliverImmediately:YES];
 [growlNotificationClickedName release];
 }

 if (!wasLocal) {
 isClosingFromRemoteClick = YES;
 [[NSNotificationCenter defaultCenter] postNotificationName:GROWL_CLOSE_NOTIFICATION
 object:[growlNotificationDict objectForKey:GROWL_NOTIFICATION_INTERNAL_ID]];
 isClosingFromRemoteClick = NO;
 }
 }
 */
/*
 -( void) awakeFromNib
 {

 _router.documentRoot = @"/www";
 [_router start];

 NSURLREQ *req = [NSURLREQ requestWithURL:$URL($(@"%@:%u/colorchart/",_router.baseURL, _router.port))];
 [_webView.mainFrame loadRequest:req];
 NSLog(@"Requesting url from webview %@", req.URL);

 [_window setBackgroundColor:RED];

 //	_ab = [AZAddressBook new];
 //	NSLog(@"%@ Records", ((AZContact*)_ab.contacts[2]).image);


 //	[_webView.mainFrame

 }


 //	b(nil,z);


 - (IBAction)getFB:(id)sender {
 _fb = [AZFacebookConnection initWithQuery:@"me/posts" param:@"message" thenDo:^(NSString *text) {

 //		[_window.contentView addSubview:
 //		 [NSTextView textViewForFrame: _window.frame withString:[text.mutableCopy attributedWithFont:AtoZ.controlFont andColor:RANDOMCOLOR]]];
 }];
 }

 - (IBAction)getColorList:(id)sender {
 [GoogleSpeechAPI recognizeSynthesizedText:[NSS dicksonParagraphWith:10] completion:^(NSS *s) {
 //		[NSThread.mainThread pe  [_webView.mainFrame loadHTMLString:s baseURL:$URL(_router.baseURL)];
 //		[NSTextView textViewForFrame: [w convertRectFromScreen:w.frame] withString:[s.mutableCopy attributedWithFont:AtoZ.controlFont andColor:RANDOMCOLOR]]];
 AZLOG($(@"The sentence was: %@ and the response ", s));
 }];

 }

 //NSW * win() { NSW* 	w = [NSW.alloc initWithContentRect:AZRectFromDim(300) styleMask:NSResizableWindowMask backing:NSBackingStoreBuffered defer:NO];
 //	w.contentView		= [	AZSimpleView withFrame:w.frame color:LINEN  ];
 //	[	w setMovableByWindowBackground: 	YES ];								return w;	}


 int main(int c, const char* v [] ) { @autoreleasepool {	NSApplication.sharedApplication;

 [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];

 NSMenu *menubar = NSMenu.new;		NSMenuItem *app = NSMenuItem.new;		[menubar  addItem:app];

 [NSApp 	 setMainMenu:menubar];							app.submenu  = NSMenu.new;
 [app.submenu addItem: [NSMenuItem.alloc 		initWithTitle: $(@"Quit %@", AZPROCNAME)
 action: @selector(terminate:) keyEquivalent: @"q"]];

 WebView *z = 				[WebView.alloc initWithFrame:				AZRectFromDim(200)];
 NSW			*w = win();
 [w 				 cascadeTopLeftFromPoint: AZPointFromDim(40)];

 [w.contentView 				 setSubviews: @[z]];
 [NSApp   activateIgnoringOtherApps:	 YES];
 [w 						makeKeyAndOrderFront:	 nil];

 */
/**

 [NSApp run]; 	return 0;  }	}	 // (main.exitCode)
 NSRunLoop   		* runLoop;
 AZHTTPRouter		* main; // replace with desired class

 @autoreleasepool
 {
 // create run loop
 runLoop = NSRunLoop.currentRunLoop;
 main	= AZHTTPRouter.alloc.init; // replace with init method

 // kick off object, if required
 [main start];
 NSLog(@"%@", main.propertiesPlease);
 // enter run loop
 while ( !main.shouldExit ) [NSRunLoop.mainRunLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];


 AZLOG(@"Im still here!");

 //		[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
 //		while((!(main.shouldExit)) && (([runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]])));

 };

 static AZFacebookConnection *fb 	= nil;


 int main(int argc, const char * argv[])
 {
 NSRunLoop   		*runLoop;
 AZHTTPRouter	 	*main;		  								//	replace with desired class

 @autoreleasepool
 {
 runLoop = NSRunLoop.currentRunLoop; 		// create run loop
 main	= AZHTTPRouter.new; 						// replace with init method
 // enter run loop
 //	while ( main && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]] );
 {

 AZRUNFOREVER;



 }
 return 0;	// (main.exitCode);
 }
 }

 int main(int argc, const char * argv[])
 {

 @autoreleasepool {

 NSTimer *timer = [NSTimer.alloc initWithFireDate:NSDate.new
 interval:.05	target:obj  selector:@selector(startIt:)
 userInfo:nil   repeats:YES];

 NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
 [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
 [runLoop run];

 __block BOOL finished = NO;
 CWTask *y = [CWTask.alloc initWithExecutable:@"/bin/ls" andArguments:@[@"/Users/localadmin"]
 atDirectory:nil];
 TaskCompletionBlock j = ^{
 NSLog(@"settting task finito");
 finished = YES;
 };
 y.completionBlock = j;
 [y launchTaskOnQueue:AZSharedSingleOperationQueue()
 withCompletionBlock:^(NSString *output, NSError *error){
 NSLog(@"%@", output)
 finished = YES;
 }];
 //		while (!finished) sleep(1);

 //		NSS* i = [y launchTask:nil];
 //		NSLog(@"task:%@", i);
 //		[NSThread.mainThread performBlock:^{
 //			[y launchTaskOnQueue:AZSharedSingleOperationQueue()
 //			 withCompletionBlock:^(NSS *output, NSError *error){
 //				 NSLog(@"%@", output)
 //			 }];
 //		}waitUntilDone:YES];

 }
 //	return 0;
 }

 @interface SampleClient : NSObject <WebSocketDelegate>
 @property WebSocket *webSocket;
 @end

 @implementation SampleClient

 - (IBAction)reconnect:(id)sender {
 self.webSocket = [WebSocket.alloc initWithURLString:@"ws://localhost:4321" delegate:self];
 [_webSocket open];
 }
 - (void) pplicationDidFinishLaunching:(NSNOT*)aNotification {
 [self reconnect:nil];
 }

 -(void)webSocketDidClose:(WebSocket *)ws {
 NSLog(@"Connection closed");
 }

 -(void)webSocket:(WebSocket *)ws didFailWithError:(NSError *)error {
 //    error.code == WebSocketErrorConnectionFailed  ?	NSLog(@"Connection failed"):
 //    error.code == WebSocketErrorHandshakeFailed		? NSLog(@"Handshake failed"):
 //:
 NSLog(@"Error");
 }
 -(void)webSocket:(WebSocket *)ws didReceiveMessage:(NSString*)message { NSLog(@"Recieved message: %@", message); }
 -(void)webSocketDidOpen:(WebSocket *)ws { NSLog(@"Connected"); }
 -(void)webSocketDidSendMessage:(WebSocket *)ws {    NSLog(@"Did send message"); }
 @end

 extern CFRunLoopRef CFRunLoopGetMain(void);

 @implementation AZShowWindowScriptCommand
 - (id) performDefaultImplementation {    //we always say yes, because this is not a toggle command
 [[AtoZ sharedInstance].azWindow makeKeyAndOrderFront:self];
 return nil;
 }
 @end

 applications that go full-screen (games in particular) are expected to capture
 whatever display(s) they're using.
 we [will] use this to notice, and turn on auto-sticky or something (perhaps
 to be decided by the user), when this happens.

 #if 0
 static BOOL isAnyDisplayCaptured(void) {
 BOOL result = NO;
 CGDisplayCount numDisplays;
 CGDisplayErr err = CGGetActiveDisplayList(/ * maxDisplays * / 0U, / *activeDisplays* / NULL, &numDisplays);
 if (err != noErr)
 NSLog(@"Checking for captured displays: Could not count displays: %li", (long)err);
 else {
 CGDirectDisplayID *displays = malloc(numDisplays * sizeof(CGDirectDisplayID));
 CGGetActiveDisplayList(numDisplays, displays, / *numDisplays * / NULL);
 
 if (!displays)
 NSLog(@"Checking for captured displays: Could not allocate list of displays: %s", strerror(errno));
 else {
 for (CGDisplayCount i = 0U; i < numDisplays; ++i) { if (CGDisplayIsCaptured(displays[i])) { result = YES; break;  }
 }
 free(displays);
 }
 }
 return result;
 }
 #endif
 
 */


