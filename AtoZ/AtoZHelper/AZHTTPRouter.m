//
//  AZHTTPRouter.m
//  AtoZ
//  Created by Alex Gray on 3/13/13.

#import "AZHTTPRouter.h"
#import <WebKit/WebKit.h>
#import "AZSpeechRecognition.h"

@implementation Shortcut
- (id) initWithURI:(NSS*)uri syntax:(NSS*)syntax	{	if (self != super.init ) return nil; _syntax = syntax; _uri = uri; return self; }
@end

@interface AZHTTPRouter ()
@property (strong, nonatomic) NSAC *queriesController;
@end

@implementation AZHTTPRouter

- (void) start	{

	NSD* bundleInfo = @{ @"Vagina, Inc." : @"1.0"};//NSBundle.mainBundle.infoDictionary; // Set a default Server header in the form of YourApp/1.0
	NSS *appVersion = @"1.0, natch."; //bundleInfo[@"CFBundleShortVersionString"] ?: bundleInfo[@"CFBundleVersion"];
	self.defaultHeaders = @{ @"Server": $(@"%@/%@", bundleInfo[@"CFBundleName"],appVersion) };
	self.type	= @"_http._tcp.";
	self.port = 8080;
	self.baseURL = $(@"http://localhost:%ld", self.port);	NSLog(@"Address: %@", _baseURL);

	self.queriesController = NSArrayController.new;

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

@end
