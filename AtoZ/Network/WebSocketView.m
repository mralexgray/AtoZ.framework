//#import "AtoZCategories.h"
//#import "Bootstrap.h"

#import <AtoZ/AtoZ.h>
#import "AZWebSocketServer.h"
#import "WebSocketView.h"


@class KSHTMLWriter;
@interface WebSocketView () @property AZWebSocketServer *wsServer; @property KSHTMLWriter *writer; @end

@implementation WebSocketView

- (id) init {  SUPERINIT;

	_wsServer = [AZWebSocketServer server];
	_wsServer.port = AZRANDOMPORT;

	NSMS *_mString = NSMS.new;
	_writer = [KSHTMLWriter.alloc initWithOutputWriter:_mString docType:KSHTMLWriterDocTypeHTML_5 encoding:NSUTF8StringEncoding];

	[_writer startDocumentWithDocType:@"html" encoding:NSUTF8StringEncoding];
	[_writer             writeElement:@"head" content:^{
		[@[JQUERY_UI_CSS, BOOTSTRAP_CSS, FONTAWESOME, BOOTSWATCH_UNITED] do:^(id css) {
			[_writer writeLinkToStylesheet:css title:@"" media:@""];
		}];
		[@[JQUERY, BOOTSTRAP_JS, LIVEQUERY] do:^(id js) {
			[_writer writeJavascriptWithSrc:js encoding:NSUTF8StringEncoding];
		}];
	}];

	return self;
}

+ (instancetype) onPort:(NSUI)p baseHTML:(NSS*)html {

	WebSocketView *v = self.new;  [v.writer writeElement:@"body" content:^{	[v.writer writeHTMLString:html]; }];

//	[v.wsServer get:@"/" withBlock:^(RouteRequest *req, RouteResponse *resp) { [resp respondWithString:v.writer.markup]; }];
	return v;
}

@end


//- (void) evaluateScriptAt:(NSS*)urlString {
//	NSS* script = [NSS stringWithContentsOfURL:$URL(urlString) encoding:NSUTF8StringEncoding error:nil];
//	[self.windowScriptObject evaluateWebScript:script];
//}
//- (void) injectCSSAt:(NSS*)urlString{
//
//	NSS *someCSS = [NSS stringWithContentsOfURL:$URL(urlString) encoding:NSUTF8StringEncoding error:nil];
// [self injectCSS:someCSS];
//}

//- (void) injectCSS:(NSS*)css{
//
//	DOMDocument* domDocument = //self.mainFrameDocument;
//	self.mainFrame.DOMDocument;
////	udomDocument);z
//	DOMElement* styleElement = [domDocument createElement:@"style"];
//	[styleElement setAttribute:@"type" value:@"text/css"];
//	DOMText* cssText = [domDocument createTextNode:css];
//	[styleElement appendChild:cssText];
//	DOMElement* headElement=(DOMElement*)[[domDocument getElementsByTagName:@"head"] item:0];
//	NSLog(@"css:%@",styleElement);
//	[headElement appendChild:styleElement];
//}
//- (void) evaluate:(NSS*)jsString { [self.windowScriptObject evaluateWebScript:jsString]; }


