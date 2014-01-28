
#import "HTMLServer.h"

int main(int argc, const char * argv[])	{ return NSApplicationMain(argc, argv);	}

@implementation HTMLServer

- (void) applicationDidFinishLaunching:(NSNOT*)n	{

	// Configure our logging framework.
	// To keep things simple and fast, we're just going to log to the Xcode console.
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
	// Create server using our custom MyHTTPServer class
	_server = RoutingHTTPServer.new;
	
	// Tell server to use our custom MyHTTPConnection class.
//	_server.connectionClass = [MyHTTPConnection class];

	// Tell the server to broadcast its presence via Bonjour.
	// This allows browsers such as Safari to automatically discover our service.
//	[httpServer setDomain:@"mrgray.local"];
	_server.type = @"_http._tcp.";
	_server.name = AZAPPBUNDLE.infoDictionary[@"CFBundleIdentifier"];
	// Normally there's no need to run our server on any specific port.
	// Technologies like Bonjour allow clients to dynamically discover the server's port at runtime.
	// However, for easy testing you may want force a certain port so you can just hit the refresh button.
	_server.port = 12345;

	// Serve files from our embedded Web folder
	NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Web"];
//	DDLogInfo(@"Setting document root: %@", webPath);

	[httpServer setDocumentRoot:webPath];
	
	// Start the server (and check for problems)
	
	NSError *error;
	if(![httpServer start:&error])
	{
		DDLogError(@"Error starting HTTP Server: %@", error);
	}
	XX(httpServer.URL);
	[_webView bind:@"mainFrameURL" toObject:httpServer withKeyPath:@"URL" transform:^id(id value) {
		return [value path];
	}];
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

- (void) setRunning:(AZState)run {  NSError *error; AZLOGCMD;

	if ( _server.isRunning == run)  return ;

	if (!run && _server && _server.isRunning) return [_server stop];

	if (!_server) {
		_server			= RoutingHTTPServer.new;
		_server.type 	= @"_http._tcp.";
		_server.port   = 6969;
		[_server setDefaultHeader:@"Server" value:AZBUNDLE.bundleIdentifier];

		_webView.frameLoadDelegate = self;
		_bootstrap 		= Bootstrap.new;

//		[self setupRoutes];
		NSError *error;
		if (![_server start:&error]) 	NSLog(@"Error starting HTTP server: %@", error);	else nil;
		[_webView.mainFrame loadRequest:[NSURLREQ requestWithURL:$URL($(@"http://localhost:%u", _server.port))]];

//	if 							(run)  [_server start:&error]; else [_server stop];
//	if (error || _server.isRunning != run) 
//		NSLog(@"Error %@ server: %@", run? @"starting" : @"stopping", error);
	}
}
//- (void) awakeFromNib	{ AZLOGCMD;
//
//	XX(self.window); 
////	if (!self.window) self.widow = [NSWindow wi]
//	[self.window makeKeyAndOrderFront:self]; NSBeep();
//}

- (void)webView:(WebView*)sender didFinishLoadForFrame:(WebFrame *)frame {

//	self.loadedText = [[sender stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"].tidyHTML attributedWithFont:AtoZ.controlFont andColor:BLACK];
}
//	essential for list view to work.
//- (AssetCollection*) assets	{ return _assets = AssetCollection.sharedInstance; 	}




//- (void)tableViewSelectionDidChange:(NSNotification *)notification;
//{
//	AZLOG(notification.object);
//	if (notification.object == _shortcuts)
//		[self loadURL:$(@"%@%@",_baseURL, ((Shortcut*)_queriesController.arrangedObjects[_shortcuts.selectedRow]).uri)];
//	else {
//		NSS *pre = $(@"<pre>%@</pre>", [((Asset*)_assetController.arrangedObjects[_assetTable.selectedRow]).markup encodeHTMLCharacterEntities]);
//
//		[_webView.mainFrame loadHTMLString:[pre wrapInHTML]  baseURL:$URL(_baseURL)];
//	}
//}

- (void)contactSheetWith:(NSA*)images rect:(NSR)rect cols:(NSUI)cols callback:(void (^)(NSImage *))callback  {

	[NSThread performBlockInBackground:^{
		NSIMG* image =	[NSImage contactSheetWith:images inFrame:rect];// columns:cols];
		[[NSThread mainThread] performBlock:^{	callback(image); }];
    }];
}

- (void)handleSelectorRequest:(REQ *)request withResponse:(RES *)response {
	[response respondWithString:@"Handled through selector"];
}

- (void)colorlist:(REQ *)request withResponse:(RES *)response {

	__block NSMS *htmlText = @"<html><head><title>TEST</title>"\
								"<style> div { float:left; margin: 20px; padding: 20px; width:100px; height:100px; } </style>"\
							    "</head><body><ul>".mutableCopy;
				
	[NSColor.randomPalette /*colorNames */ each:^(NSC* color) {

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
}


//-(RoutingHTTPServer*) http
//{
//	if (_http) return _http; else _http = RoutingHTTPServer.new;
//	NSD* bundleInfo = NSBundle.mainBundle.infoDictionary; // Set a default Server header in the form of YourApp/1.0
//	NSS *appVersion = bundleInfo[@"CFBundleShortVersionString"] ?: bundleInfo[@"CFBundleVersion"];
//	_http.defaultHeaders = @{ @"Server": $(@"%@/%@", bundleInfo[@"CFBundleName"],appVersion) };
//	_http.type	= @"_http._tcp.";
//	_http.port = 8080;
//	_baseURL = $(@"http://localhost:%i", _http.port);
//	[self setupRoutes];
//	NSError *error;
//	if (![_http start:&error]) 	NSLog(@"Error starting HTTP server: %@", error);
//	else 									[self loadURL:nil];
//	return _http;
//}


//- (void)awakeFromNib {
//
//	_queries 				= NSMA.new;
//	_urlField.delegate 		= self;
//	self.http.documentRoot 	= LogAndReturn([NSB bundleForClass:KSHTMLWriter.class].resourcePath);//@"/";//[[Bootstrap class]reso];// withPath:@"twitter_bootstrap_admin"];
////	_http.connectionClass	= [WTZHTTPConnection class];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUploadProgressNotification:) name:UPLOAD_FILE_PROGRESS object:nil];
//	
//	[_assetTable registerForDraggedTypes:@[AssetDataType]];
//
//}
//
//- (void)textDidEndEditing: (NSNotification*)note { 	[self loadURL:_urlField.stringValue]; }
//
//- (void)loadURL:(NSS*)string	{	[_webView.mainFrame loadRequest: [NSURLREQ requestWithURL:$URL(string ?: $(@"http://localhost:%i", _http.port))]];	}
//
//- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame	{	_urlField.stringValue = sender.mainFrameURL;	}




//- (void) start	{

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
	[self get:@"/record/ *.*" withBlock:^(RouteRequest *req, RouteResponse *res) {
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
//}

//- (void)windowControllerDidLoadNib:(NSWindowController *)aController
//{
//	[super windowControllerDidLoadNib:aController];
//	// Add any code here that needs to be executed once the windowController has loaded the document's window.
//}

////+ (BOOL)autosavesInPlace	{    return YES; }
////
////- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
////{
////
//
//    NSMutableData *data 		= NSMutableData.new;
//    NSKeyedArchiver *archiver = [NSKeyedArchiver.alloc initForWritingWithMutableData:data];
//    [archiver setOutputFormat: NSPropertyListXMLFormat_v1_0];
////    [archiver encodeObject:_port  forKey: @"port"];
//    [archiver finishEncoding];
//    return data;
//
//	// Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
//	// You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//	@throw exception;
//	return nil;
//}
//
//- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError	{
//
//	NSKeyedUnarchiver *archiver  = [NSKeyedUnarchiver.alloc initForReadingWithData:data];
////	_port = [archiver decodeObjectForKey: @"port"];
//	return YES;
//
//	// Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
//	// You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
//	// If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//	NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//	@throw exception;
//	return YES;
//}


//
//- (void) handlePosts
//{
//	[_http post:@"/xml" withBlock:^(RouteRequest *request, RouteResponse *response) {
//		NSData *bodyData = [request body];
//		NSString *xml = [[NSString alloc] initWithBytes:[bodyData bytes] length:[bodyData length] encoding:NSUTF8StringEncoding];
//
//		// Green?
//		NSRange tagRange = [xml rangeOfString:@"<greenLevel>"];
//		if (tagRange.location != NSNotFound) {
//			NSUInteger start = tagRange.location + tagRange.length;
//			NSUInteger end = [xml rangeOfString:@"<" options:0 range:NSMakeRange(start, [xml length] - start)].location;
//			if (end != NSNotFound) {
//				NSString *greenLevel = [xml substringWithRange:NSMakeRange(start, end - start)];
//				[response respondWithString:greenLevel];
//			}
//		}
//	}];
////	[_http post:@"/widgets" withBlock:^(REQ *req, RES *res) {	// Create a new widget, [request body] contains the POST body data. For this example we're just going to echo it back.
//		NSLog(@"POST: %@", req.body);
//		[res respondWithData:req.body];	}];
		
//		NSLog(@"POST: %@", req.body);
//		[res respondWithData:req.body];	}];
//		HTTPConnection* *con = [res connection];
//		[con respondWithFile:tmp async:YES];
//		NSLog(@"%@, %@, %@", req.body, req.headers, req);//req.connection  );
//		[res.connection processBodyDa]
//		NSData *d = [req body];
		
//		[d writeToFile:tmp atomically:YES];

//		[res.connection  BodyData:req.body];


		 // OK
//newu //] wit atomically:]

//	if([method isEqualToString:@"POST"] && [path isEqualToString:@"/upload.html"]) {
        // here we need to make sure, boundary is set in header
//        NSString* contentType = req.headers[@"Content-Type"];
//        int paramsSeparator = [contentType rangeOfString:@";"].location;
//        if( NSNotFound == paramsSeparator ) {
////            return NO;
//        }
//        if( paramsSeparator >= contentType.length - 1 ) {
////            return NO;
//        }
//        NSString* type = [contentType substringToIndex:paramsSeparator];
//        if( ![type isEqualToString:@"application/json"] ) { //![type isEqualToString:@"multipart/form-data"] ) {
//            // we expect multipart/form-data content type
////			return NO;
//        }
//		return YES;
//	}];
//}
//
/**		// enumerate all params in content-type, and find boundary there
        NSArray* params = [[contentType substringFromIndex:paramsSeparator + 1] componentsSeparatedByString:@";"];
        for( NSString* param in params ) {
            paramsSeparator = [param rangeOfString:@"="].location;
            if( (NSNotFound == paramsSeparator) || paramsSeparator >= param.length - 1 ) {
                continue;
            }
            NSString* paramName = [param substringWithRange:NSMakeRange(1, paramsSeparator-1)];
            NSString* paramValue = [param substringFromIndex:paramsSeparator+1];
            
            if( [paramName isEqualToString: @"boundary"] ) {
                // let's separate the boundary from content-type, to make it more handy to handle
                [request setHeaderField:@"boundary" value:paramValue];
            }
        }
        // check if boundary specified
        if( nil == [request headerField:@"boundary"] )  {
            return NO;
        }
        return YES;
    }
	return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
	HTTPLogTrace();

	if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/upload.html"])
	{

		// this method will generate response with links to uploaded file
		NSMutableString* filesStr = [[NSMutableString alloc] init];

		for( NSString* filePath in uploadedFiles ) {
			//generate links
			[filesStr appendFormat:@"<a href=\"%@\"> %@ </a><br/>",filePath, [filePath lastPathComponent]];
		}
		NSString* templatePath = [[config documentRoot] stringByAppendingPathComponent:@"upload.html"];
		NSDictionary* replacementDict = [NSDictionary dictionaryWithObject:filesStr forKey:@"MyFiles"];
		// use dynamic file response to apply our links to response template
		return [[HTTPDynamicFileResponse alloc] initWithFilePath:templatePath forConnection:self separator:@"%" replacementDictionary:replacementDict];
	}
	if( [method isEqualToString:@"GET"] && [path hasPrefix:@"/upload/"] ) {
		// let download the uploaded files
		return [[HTTPFileResponse alloc] initWithFilePath: [[config documentRoot] stringByAppendingString:path] forConnection:self];
	}

	return [super httpResponseForMethod:method URI:path];
}

- (void)prepareForBodyWithSize:(UInt64)contentLength	{	HTTPLogTrace();

	// set up mime parser
    NSString* boundary = [request headerField:@"boundary"];
    parser = [[MultipartFormDataParser alloc] initWithBoundary:boundary formEncoding:NSUTF8StringEncoding];
    parser.delegate = self;

	uploadedFiles = [[NSMutableArray alloc] init];
}

- (void)processBodyData:(NSData *)postDataChunk
{
	HTTPLogTrace();
    // append data to the parser. It will invoke callbacks to let us handle
    // parsed data.
    [parser appendData:postDataChunk];
}
*/
#pragma mark multipart form data parser delegate
/*
- (void) processStartOfPartWithHeader:(MultipartMessageHeader*) header {
	// in this sample, we are not interested in parts, other then file parts.
	// check content disposition to find out filename

    MultipartMessageHeaderField* disposition = [header.fields objectForKey:@"Content-Disposition"];
	NSString* filename = [[disposition.params objectForKey:@"filename"] lastPathComponent];

    if ( (nil == filename) || [filename isEqualToString: @""] ) {
        // it's either not a file part, or
		// an empty form sent. we won't handle it.
		return;
	}    
	NSString* uploadDirPath = [[config documentRoot] stringByAppendingPathComponent:@"upload"];

	BOOL isDir = YES;
	if (![[NSFileManager defaultManager]fileExistsAtPath:uploadDirPath isDirectory:&isDir ]) {
		[[NSFileManager defaultManager]createDirectoryAtPath:uploadDirPath withIntermediateDirectories:YES attributes:nil error:nil];
	}

    NSString* filePath = [uploadDirPath stringByAppendingPathComponent: filename];
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        storeFile = nil;
    }
    else {
		NSLog(@"Saving file to %@", filePath);

		HTTPLogVerbose(@"Saving file to %@", filePath);
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];	
		storeFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
		[uploadedFiles addObject: [NSString stringWithFormat:@"/upload/%@", filename]];
    }
}

- (void) processContent:(NSData*) data WithHeader:(MultipartMessageHeader*) header 
{
	// here we just write the output from parser to the file.
	if( storeFile ) {
		[storeFile writeData:data];
	}
}

- (void) processEndOfPartWithHeader:(MultipartMessageHeader*) header
{
	// as the file part is over, we close the file.
	[storeFile closeFile];
	storeFile = nil;
}
*/
- (void)handleUploadProgressNotification:(NSNotification *) notification
{
    NSNumber *uploadProgress = (NSNumber *)[notification object];
    [self performSelectorOnMainThread:@selector(changeProgressViewValue:) withObject:uploadProgress waitUntilDone:NO];
}

@end




// Set a default Server header in the form of YourApp/1.0
//	NSS *appVersion = INFOD[@"CFBundleShortVersionString"] ?: INFOD[@"CFBundleVersion"];
//	_server.defaultHeaders = @{ @"Server": $(@"%@/%@", INFOD[@"CFBundleName"],appVersion) };



//- (id) initWithWindowNibName:(NSString *)windowNibName	{ 	
//			return [super initWithWindowNibName:NSStringFromClass(self.class)];
//}

/*


	//	[_http get:@"*" withBlock:^(REQ *req, RES *res) { NSLog(@"Req:%@... Params: %@", req, req.params);   NSLog(@"Res:%@... Params: %@", res, res.headers);   }];
//    NSMutableString *xml = [NSMutableString string];
//    KSXMLWriter *writer = [[KSXMLWriter alloc] initWithOutputWriter:xml];
//
//    [writer startElement:@"foo" attributes:nil];
//    [writer writeCharacters:@"bar"];
//    [writer endElement];
//
//	KSHTMLWriter *_writer = [[KSHTMLWriteralloc initWithOutputWriter:output encoding:NSUTF8StringEncoding];
//	[_writer writeString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"];
//
//	[_writer pushAttribute:@"xmlns" value:@"http://www.sitemaps.org/schemas/sitemap/0.9"];
//	[_writer startElement:@"sitemapindex"];

	//	NSUI lastItemInMatrix = [_queriesController.arrangedObjects indexOfObjectPassingTest:^BOOL(Shortcut *shortcut, NSUI idx, BOOL *stop) {	return [shortcut.uri isEqualToString:@"/custom"];	}];

	[@[	@[ @"/hello",			       @"/hello" ],	@[ @"/hello/:name",			@"/hello/somename"],
		@[ @"{^/page/(\\d+)$}", 	@"/page/9999"],	@[ @"/info",						 @"/info" ],
		@[ @"/customHTML",			   @"/custom"]]

	eachWithIndex:^(id obj, NSI idx) {	[_queriesController insertObject:$SHORT(obj[0], obj[1]) atArrangedObjectIndex:idx];

		[_http get:obj[0] withBlock:^(REQ *req, RES *res) {	[res respondWithString

		: idx == 1 ?    @"This text is showing because the URL ends with '/hello'"
		: idx == 2 ? $( @"Hello %@!", req.params[@"name"])
		: idx == 3 ? $( @"/page/%@",  req.params[@"captures"][0])
		: idx == 4 ? $( @"This could be written as '	%@  ' \n\n Which would output req: %@  \n and response: %@.", @"[_http get:@\"/info\" withBlock:^(REQ *req, RES *res) { AZLOG(req);	AZLOG(res);	}]; \n 			[res respondWithString:theResponse]; }]; \n}];'", req, res)
		: idx == 5 ? ^{ return @"custom placeholder"; }() : @""

	];	}]; }];

	[@[	@[ @"/bootstrap",	 	 @"/bootstrap"],	@[ @"{^/ugh.png", 				   @"/ugh.png"],
		@[ @"/colorlist",	 	@"/colorlist" ],	@[ @"/selector",				  @"/selector"],
		@[ @"/widgets",		  	   @"/widgets"],	@[ @"/xml",			          		   @"/xml"],
		@[ @"/recognize",    	 @"/recognize"],
		@[ @"/wav:",		       	   @"/wav"],	@[ @"http://mrgray.com/sip/sipml5/",   @"/sip"],
		@[ @"{^/vageen.png",    @"/vageen.png"]]
													each:^(id obj) { [_queriesController addObject: $SHORT(obj[1], obj[0])]; }];



//	[[_queriesController.arrangedObjects subarrayToIndex:lastItemInMatrix + 1] eachWithIndex:^(Shortcut *obj, NSInteger idx) {


	[_http get:@"/sip" withBlock:^(RouteRequest *request, RouteResponse *response) {
		[response setStatusCode:302]; // or 301
		[response setHeader:@"Location" value:@"http://mrgray.com/sip/sipml5/"];//[self.baseURL stringByAppendingString:@"/new"]];
	}];

//	[_http get:@"/info" withBlock:^(REQ *req, RES *res) { AZLOG(req);	AZLOG(res);	}];

	[_http get:@"/bootstrap" withBlock:^(REQ *req, RES *res) {
		 [Bootstrap initWithUserStyle:nil script:nil andInnerHTML:nil  calling:^(id sender) {
// 	initWithUserStyles:@"" script:@"" andInnerHTML:@"<P>HELLO</P>" calling:^(id sender) {
			[res respondWithString:[(NSS*)sender copy]];
		 }];
	}];

	[_http get:@"/indexUP.html" withBlock:^(REQ *req, RES *res) {
		NSLog(@"%@", req.params);
			[res respondWithFile:$(@"%@%@",[NSBundle.mainBundle resourcePath],@"/indexUP.html")];
	}];
	
	[_http get:@"/recognize" withBlock:^(REQ *req, RES *res) {

//		GoogleTTS *u = GoogleTTS.instance;
//		[u getText:NSS.dicksonBible withCompletion:^(NSString *text, NSString *wavpath) {
//			[res respondWithFile:wavpath];
//		}];

	}];
	//	SELECTORS AS STRINGS
	[@[	@[ @"/colorlist", 	@"colorlist:withResponse:"],
	 	@[ @"/selector",	@"handleSelectorRequest:withResponse:"]] each:^(id obj) {
		 [_http handleMethod:@"GET" withPath:obj[0] target:self selector:$SEL(obj[1])];
	 }];

	[_http get:@"{^/ugh.png" withBlock:^(RouteRequest *req, RouteResponse *res) {
		NSIMG* rando = [NSIMG.systemImages.randomElement scaledToMax:AZMinDim(_webView.bounds.size)];
		[res respondWithData: PNGRepresentation(rando)];
		//[rando.bitmap representationUsingType:NSJPEGFileType  properties:nil]];
	}];

	[_http get:@"{^/vageen.png" withBlock:^(REQ *req, RES *res) {
//		[self contactSheetWith: [NSIMG.frameworkImages withMaxItems:10]  rect:AZScreenFrame() cols:3
//					  callback:^(NSIMG *i) {
		 [res respondWithData:[[NSImage contactSheetWith:[NSIMG.frameworkImages withMaxRandomItems:10]
										         inFrame:_webView.bounds]
						 .bitmap representationUsingType: NSJPEGFileType properties:nil]];
//		 NSData *result = [i.bitmap	representationUsingType:NSJPEGFileType properties:nil];
						  //		NSData *d = [rando.representations[0] bitmapRepresentation];// bitmapRepresentation;//][0] representationUsingType:NSPNGFileType properties:nil];// TIFFRepresentation];
//						  [res respondWithData:result]; }];
	}];
	[_http get:@"/record/*.*" withBlock:^(RouteRequest *req, RouteResponse *res) {
		NSLog(@"req params:  %@", req.params);
//        [res setStatusCode:302]; // or 301
//        [res setHeader:@"Location" value:[self.baseURL stringByAppendingString:@"/record/"]];
		[res respondWithFile:[[[NSBundle.mainBundle resourcePath] withPath:@"FlashWavRecorder"]withPath:req.params[@"wildcards"][0]]];
	}];
	[_http post:@"/uploadwav" withBlock:^(REQ *req, RES *res) {	// Create a new widget, [request body] contains the POST body data. For this example we're just going to echo it back.
		NSLog(@"Post to /uploadwav %@", req.params);
	}];

}

*/
	//	ADB target:self selector:@selector()];

	//		NSData *d = [rando.representations[0] bitmapRepresentation];// bitmapRepresentation;//][0] representationUsingType:NSPNGFileType properties:nil];// TIFFRepresentation];


//		NSS *thePath = req.params[@"filepath"] ?: @"/Users/localadmin/Desktop/blanche.withspeech.flac";
//		GoogleTTS *u = [GoogleTTS instanceWithWordsToSpeak:NSS.dicksonisms.randomElement];
//		[NSThread performBlockInBackground:^{
//			u.words = NSS.dicksonisms.randomElement;
//			[res respondWithFile:u.nonFlacFile];
//
//				[[NSThread mainThread] performBlock:^{
//										[res respondWithFile:wavpath async:YES];
//				}];
//			}];
//		}];

		//[GoogleTTS instanceWithWordsToSpeak:NSS.dicksonisms.randomElement completion:^(NSString *t, NSS*file) {
//			NSLog(@"wavpath:%@.... u/nonflac: %@",wavpath,  u.nonFlacFile);
//			NSData *bytes	= [NSData dataWithContentsOfURL:$URL(u.nonFlacFile)];//wav g.nonFlacFile]];
//			NSLog(@"sending:'%ld' bytes", [bytes length]);
//			[res respondWithFile:u.nonFlacFile];

/**
	[_http post:@"/xml" withBlock:^(RouteRequest *request, RouteResponse *response) {
		NSData *bodyData = [request body];
		NSString *xml = [[NSString alloc] initWithBytes:[bodyData bytes] length:[bodyData length] encoding:NSUTF8StringEncoding];

		// Green?
		NSRange tagRange = [xml rangeOfString:@"<greenLevel>"];
		if (tagRange.location != NSNotFound) {
			NSUInteger start = tagRange.location + tagRange.length;
			NSUInteger end = [xml rangeOfString:@"<" options:0 range:NSMakeRange(start, [xml length] - start)].location;
			if (end != NSNotFound) {
				NSString *greenLevel = [xml substringWithRange:NSMakeRange(start, end - start)];
				[response respondWithString:greenLevel];
			}
		}
	}];


	[_http post:@"/widgets" withBlock:^(REQ *req, RES *res) {	// Create a new widget, [request body] contains the POST body data. For this example we're just going to echo it back.
		NSLog(@"POST: %@", req.body);
		[res respondWithData:req.body];	}];
*/
	// Routes can also be handled through selectors


/**
	[_http get:@"/wav" withBlock:^(RouteRequest *req, RouteResponse *res) {

		GoogleTTS *g = [GoogleTTS instanceWithWordsToSpeak:NSS.dicksonisms.randomElement completion:^(NSString *s) {

			NSURL *urlPath = [NSURL fileURLWithPath:g.nonFlacFile];
//			NSString *wavbundlepath = [urlPath absoluteString];
//			NSLog(@"wavbundlepath: %@",wavbundlepath);
			NSLog(@"Text from google: %s.... playing WAV.");
			NSData *bytes=[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:g.nonFlacFile]];
			[res respondWithData:bytes];
		}];
//		NSLog(@"bytes: %@",bytes);
	}];

	NSString *recordPostLength = [NSString stringWithFormat:@"%d", [bytes length]];

//	NSMutableString *urlstr = [NSMutableString stringWithFormat:@"%@", @"http://www.myserver.com/api/UploadFile?Name="];
//	[urlstr appendString:@"Temp"];
//	[urlstr appendFormat:@"&MemberID=%d", 0];
//	[urlstr appendFormat:@"&Type=%@",@"Recording"];
//	[urlstr appendFormat:@"&client=%@",@"ios"];
//	NSLog(@"urlstr.......%@",urlstr);

	NSMutableURLRequest *recordRequest = [[NSMutableURLRequest alloc] init] ;
	[recordRequest setURL:[NSURL URLWithString:urlstr]];

	NSInputStream *dataStream = [NSInputStream inputStreamWithData:bytes];
	[recordRequest setHTTPBodyStream:dataStream];

	[recordRequest setHTTPMethod:@"POST"];

	NSURLResponse *recordResponse;
	NSError *recordError;
	NSData *recordResponseData = [NSURLConnection sendSynchronousRequest:recordRequest returningResponse:&recordResponse error:&recordError];

	NSString *recordResp = [[NSString alloc]initWithData:recordResponseData encoding:NSUTF8StringEncoding];
	NSLog(@"recordResp:%@", recordResp);
	recordResponceJson = [recordResp JSONValue];
	NSLog(@"recordResponceJson = %@",recordResponceJson);
	recId = [recordResponceJson valueForKey:@"ID"];
	NSLog(@"recId....%@", recId);
*/
//		[res respondWithFile:@"/Users/localadmin/Desktop/2206 167.jpg"];  //  OK

//		NSS * tmp = [[NSTemporaryDirectory() withPath:NSS.UUIDString] withExt:@"png"]; // OK
//		[NSIMG.frameworkImages.randomElement saveAs:tmp];
//		[res respondWithFile:tmp async:YES];


////			[response respondWithFile:  (NSS *)path async:(BOOL)async;
//
//			NSS*	path = @"/tmp/atoztempfile.CE4DED94-E457-4A0A-B214-B1866616DDBA.png";// [i asTempFile];
//			NSLog(@"image: %@  path: %@", i, path);
//
////			[i openInPreview];
//			[res respondWithFile:path];// (NSS *)path async:(BOOL)async;
//
////			[i lockFocus];
//			NSBIR *bitmapRep = [NSBIR.alloc initWithFocusedViewRect:AZRectFromSize(i.size)];
//			[i unlockFocus];
//
//			NSData *rep = [bitmapRep representationUsingType:NSPNGFileType properties:Nil];

//			NSBIR *bitmapRep = [NSBIR.alloc initWithFocusedViewRect:AZRectBy( i.size.width, i.size.height)];
//			[i unlockFocus];
//			NSData *rep = [bitmapRep representationUsingType:NSPNGFileType properties:Nil];
//			NSLog(@"idata: %@", rep);
//			[res respondWithData:rep];//PNGRepresentation(i)];//rep]; //[self PNGRepresentationOfImage:image]];
//		}];

//	}];
//	NSLog(@"Queries: %@..  Arranged: %@", _queries, _queriesController.arrangedObjects);
//	[_shortcuts reloadData];
