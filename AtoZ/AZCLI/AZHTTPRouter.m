//
//  AZHTTPRouter.m
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import "AZHTTPRouter.h"

@implementation AZHTTPRouter


-
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
	GoogleTTS *u = GoogleTTS.instance;
	[u getText:NSS.dicksonBible withCompletion:^(NSString *text, NSString *wavpath) {
		[res respondWithFile:wavpath];
	}];
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
																					inFrame:_webView.bounds columns:4]
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
@end
