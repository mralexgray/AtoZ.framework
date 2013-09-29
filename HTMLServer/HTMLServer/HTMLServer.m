
#import "HTMLServerDoc.h"

#define INFOD NSBundle.mainBundle.infoDictionary

//@interface NSDocument (DoesNot
@implementation HTMLServerDoc

- (NSS*) windowNibName	{ 	return @"HTMLServerDoc"; }
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.

- (void) awakeFromNib	{ AZLOGCMD;

	_server			= RoutingHTTPServer.new;
	_server.type 	= @"_http._tcp.";
	[_server setDefaultHeader:@"Server" value:AZBUNDLE.bundleIdentifier];
	_webView.frameLoadDelegate = self;
	_bootstrap 		= Bootstrap.new;
	[self setupRoutes];
}

- (void)webView:(WebView*)sender didFinishLoadForFrame:(WebFrame *)frame {

	self.loadedText = [[sender stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"].tidyHTML attributedWithFont:AtoZ.controlFont andColor:BLACK];
}

- (void) setupRoutes {

	[_server handleMethod:@"GET" withPath:@"/hello" block:^(RouteRequest *request, RouteResponse *response) {
		[response setHeader:@"Content-Type" value:@"text/plain"];
 	   [response respondWithString:@"Hello!"];
	}];

	[_server get:@"/bs" withBlock:^(REQ *req, RES *res) {
		[@"Bootstrap log" log];
		NSString *s = [_bootstrap htmlWithBody:_bootstrap.demo];
		NSLog(@"BS: %@", _bootstrap);
		return [res respondWithString:s.copy];
	}];

	[_server get:@"/" withBlock:^(REQ *req, RES *res) {
		__block NSMS *htmlText = @"<html><head><title>TEST</title>"\
		"<style> div { float:left; margin: 20px; padding: 20px; width:100px; height:100px; } </style>"\
		"</head><body><ul>".mutableCopy;

		[NSColor.randomPalette each:^(NSC* color) {

			NSS *values = $(@"bright: %f, hue: %f,  sat: %f",	color.brightnessComponent,
											color.hueComponent,
											color.saturationComponent);
			[htmlText appendFormat: @"<li>"\
			 "<div>%@ %@ </div>"\
			 "<div style='background-color:#%@; color: %@; %@> %@<div>"\
			 "</li>", 	color.nameOfColor,
			 color.isBoring ? @"IS VERY BORING": @"IS EXCITING!",
			 color.toHex,
			 color.contrastingForegroundColor.toHex,
			 color.isBoring ? @"'": @" outline:10px solid red;'",
			 values];
		}];
		[htmlText appendFormat: @"</ul></body></html>"];
		NSLog(@"sending: %@", htmlText);
		[res respondWithString:htmlText.copy];
	}];
}

- (void) start	{

//	self.queriesController = NSArrayController.new;

//	[@[ GetReturnsString( @"/hello"						: @[ @"/hello", 		 	 @"This text is showing because the URL ends with '/hello'"] },
//		 @{ @"/hello/:name"			:	@[ @"/hello/zYz", $( @"Hello %@!", req.params[@"name"])] },
//		 @{ @"{^/page/(\\d+)$}"	: @[ @"/page/9999", $( @"/page/%@",  req.params[@"captures"][0]) ] },
//		 @{ @"/info"						: @[ @"/info", 			$( @"This could be written as '	%@  ' \n\n Which would output req: %@  \n and response: %@.", @"[self get:@\"/info\" withBlock:^(REQ *req, RES *res) { AZLOG(req);	AZLOG(res);	}]; \n 			[res respondWithString:theResponse]; }]; \n}];'", req, res) ]},
//		 @{ @"/customHTML"			: @[ @"/custom", 		NSS.dicksonBible ] }] each:^(NSD *Shortcut) {
//
//			[_queriesController insertObject:$SHORT(keyP.key, keyP.value) atArrangedObjectIndex:i];
//	 		[self get:keyP.key withBlock:^(REQ *req, RES *res) {	[res respondWithString
//	}]; }];
//
//	[@[	@[ @"/bootstrap",	 	 @"/bootstrap"],	@[ @"{^/ugh.png", 				   			 @"/ugh.png"],
//	 @[ @"/colorlist",	 		@"/colorlist" ],	@[ @"/selector",								@"/selector"],
//	 @[ @"/widgets",		  	   @"/widgets"],	@[ @"/xml",					  					   @"/xml"],
//	 @[ @"/recognize",		 	 @"/recognize"],
//	 @[ @"/wav:",			   		   @"/wav"],	@[ @"http://mrgray.com/sip/sipml5/",   @"/sip"],
//	 @[ @"{^/vageen.png",   @"/vageen.png"]]
//
//	 each:^(id obj) { [_queriesController addObject: $SHORT(obj[1], obj[0])]; }];
//
//	NSLog(@"_queriescontroller: %@", _queriesController.arrangedObjects);

	//	[[_queriesController.arrangedObjects subarrayToIndex:lastItemInMatrix + 1] eachWithIndex:^(Shortcut *obj, NSInteger idx) {

/**
	[self get:@"/sip" withBlock:^(RouteRequest *request, RouteResponse *response) {
		[response setStatusCode:302]; // or 301
		[response setHeader:@"Location" value:@"http://mrgray.com/sip/sipml5/"];//[self.baseURL stringByAppendingString:@"/new"]];
	}];  // redirect

	[self get:@"/request" withBlock:^(REQ *req, RES *res) {  [res respondWithString:$(@"%@",req)]; }];

	[self get:@"/bootstrap" withBlock:^(REQ *req, RES *res) {
//		[Bootstrap initWithUserStyle:nil script:nil andInnerHTML:nil  calling:^(id sender) {
			// 	initWithUserStyles:@"" script:@"" andInnerHTML:@"<P>HELLO</P>" calling:^(id sender) {
//			[res respondWithString:[(NSS*)sender copy]];
//		}];
	}];

	[self get:@"/indexUP.html" withBlock:^(REQ *req, RES *res) {
		NSLog(@"%@", req.params);
		[res respondWithFile:$(@"%@%@",[NSBundle.mainBundle resourcePath],@"/indexUP.html")];
	}];

	[self get:@"/recognize" withBlock:^(REQ *req, RES *res) {

		[GoogleSpeechAPI recognizeSynthesizedText:@"helllo, my name is Alex.  I am a computer." completion:^(NSString*t) {
			[res respondWithString:t];
//			[res respondWithFile:wavpath];
		}];
	}];
	//	SELECTORS AS STRINGS
	[@[	@[ @"/colorlist", 	@"colorlist:withResponse:"],
	 @[ @"/selector",	@"handleSelectorRequest:withResponse:"]] each:^(id obj) {
		 [self handleMethod:@"GET" withPath:obj[0] target:self selector:$SEL(obj[1])];
	 }];

	[self get:@"{^/ugh.png" withBlock:^(RouteRequest *req, RouteResponse *res) {
		NSIMG* rando = [NSIMG.systemImages.randomElement scaledToMax:AZMinDim(_webView.bounds.size)];
		[res respondWithData: PNGRepresentation(rando)];
		//[rando.bitmap representationUsingType:NSJPEGFileType  properties:nil]];
	}];

	[self get:@"{^/vageen.png" withBlock:^(REQ *req, RES *res) {
		//		[self contactSheetWith: [NSIMG.frameworkImages withMaxItems:10]  rect:AZScreenFrame() cols:3
		//					  callback:^(NSIMG *i) {
		[res respondWithData:[[NSImage contactSheetWith:[NSIMG.frameworkImages withMaxRandomItems:10]
																						inFrame:_webView.bounds]
													.bitmap representationUsingType: NSJPEGFileType properties:nil]];
		//		 NSData *result = [i.bitmap	representationUsingType:NSJPEGFileType properties:nil];
		//		NSData *d = [rando.representations[0] bitmapRepresentation];// bitmapRepresentation;//][0] representationUsingType:NSPNGFileType properties:nil];// TIFFRepresentation];
		//						  [res respondWithData:result]; }];
	}];
	[self get:@"/record/*.*" withBlock:^(RouteRequest *req, RouteResponse *res) {
		NSLog(@"req params:  %@", req.params);
		//		[res setStatusCode:302]; // or 301
		//		[res setHeader:@"Location" value:[self.baseURL stringByAppendingString:@"/record/"]];
		[res respondWithFile:[[[NSBundle.mainBundle resourcePath] withPath:@"FlashWavRecorder"]withPath:req.params[@"wildcards"][0]]];
	}];
	[self post:@"/uploadwav" withBlock:^(REQ *req, RES *res) {	// Create a new widget, [request body] contains the POST body data. For this example we're just going to echo it back.
		NSLog(@"Post to /uploadwav %@", req.params);
	}];

	NSError *error;	if (![self start:&error]) 	NSLog(@"Error starting HTTP server: %@", error);	else nil;// [self loadURL:nil];
	
//	return self;
}


- (void)handleSelectorRequest:(REQ *)request withResponse:(RES *)response {
	[response respondWithString:@"Handled through selector"];
}

- (void)colorlist:(REQ *)request withResponse:(RES *)response {

	__block NSMS *htmlText = @"<html><head><title>TEST</title>"\
	"<style> div { float:left; margin: 20px; padding: 20px; width:100px; height:100px; } </style>"\
	"</head><body><ul>".mutableCopy;

	[NSColor.randomPalette  * colorNames * / each:^(NSC* color) {

		NSS *values = $(@"bright: %f, hue: %f,  sat: %f",	color.brightnessComponent,
										color.hueComponent,
										color.saturationComponent);
		[htmlText appendFormat: @"<li>"\
		 "<div>%@ %@ </div>"\
		 "<div style='background-color:#%@; color: %@; %@> %@<div>"\
		 "</li>", 	color.nameOfColor,
		 color.isBoring ? @"IS VERY BORING": @"IS EXCITING!",
		 color.toHex,
		 color.contrastingForegroundColor.toHex,
		 color.isBoring ? @"'": @" outline:10px solid red;'",
		 values];
	}];
	[htmlText appendFormat: @"</ul></body></html>"];
	NSLog(@"sending: %@", htmlText);
	[response respondWithString:htmlText.copy];
	*/
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
	[super windowControllerDidLoadNib:aController];
	// Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace	{    return YES; }

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{


    NSMutableData *data 		= NSMutableData.new;
    NSKeyedArchiver *archiver = [NSKeyedArchiver.alloc initForWritingWithMutableData:data];
    [archiver setOutputFormat: NSPropertyListXMLFormat_v1_0];
//    [archiver encodeObject:_port  forKey: @"port"];
    [archiver finishEncoding];
    return data;

	// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
	// You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
	@throw exception;
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError	{

	NSKeyedUnarchiver *archiver  = [NSKeyedUnarchiver.alloc initForReadingWithData:data];
//	_port = [archiver decodeObjectForKey: @"port"];
	return YES;

	// Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
	// You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
	// If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
	@throw exception;
	return YES;
}

@end
//- (void) setRunning:(AZState)run {  NSError *error;
//
//	if ( _server.isRunning == run == _running)  return ;
//	run  ? [_server start:&error] : [_server stop];
//	if (error || (_running = _server.isRunning) != run) 
//		NSLog(@"Error %@ server: %@", run? @"starting" : @"stopping", error);
//}
// Set a default Server header in the form of YourApp/1.0
//	NSS *appVersion = INFOD[@"CFBundleShortVersionString"] ?: INFOD[@"CFBundleVersion"];
//	_server.defaultHeaders = @{ @"Server": $(@"%@/%@", INFOD[@"CFBundleName"],appVersion) };
