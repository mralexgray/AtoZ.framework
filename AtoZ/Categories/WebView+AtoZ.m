
#import <AtoZ/AtoZ.h>
#import "WebView+AtoZ.h"

@implementation WebView (AtoZ)

- (void) loadJQ {


	[self injectCSSAt:@"http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css"];
	[@[	@"http://code.jquery.com/jquery-1.9.1.js",
			@"http://code.jquery.com/ui/1.10.3/jquery-ui.js",
			@"http://mrgray.com/js/jquery.livequery.js"] each:^(id obj) {
				[self evaluateScriptAt:obj];
	}];
}

- (void) evaluateScriptAt:(NSS*)urlString {
	NSS* script = [NSS stringWithContentsOfURL:$URL(urlString) encoding:NSUTF8StringEncoding error:nil];
	[self.windowScriptObject evaluateWebScript:script];
}
- (void) injectCSSAt:(NSS*)urlString{

	NSS *someCSS = [NSS stringWithContentsOfURL:$URL(urlString) encoding:NSUTF8StringEncoding error:nil];
 [self injectCSS:someCSS];
}

- (void) injectCSS:(NSS*)css{

	DOMDocument* domDocument = //self.mainFrameDocument;
	self.mainFrame.DOMDocument;
//	udomDocument);z
	DOMElement* styleElement = [domDocument createElement:@"style"];
	[styleElement setAttribute:@"type" value:@"text/css"];
	DOMText* cssText = [domDocument createTextNode:css];
	[styleElement appendChild:cssText];
	DOMElement* headElement=(DOMElement*)[[domDocument getElementsByTagName:@"head"] item:0];
	NSLog(@"css:%@",styleElement);
	[headElement appendChild:styleElement];
}

- (void) evaluate:(NSS*)jsString { [self.windowScriptObject evaluateWebScript:jsString]; }

- (void) makeMobile
{
	[self setCustomUserAgent:@"Mozilla/5.0 (iPhone; CPU iPhone OS 5_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B179 Safari/7534.48.3"];
}

- (void) loadFileAtPath:(NSS*)path;
{
	[self.mainFrame loadRequest:[NSURLREQ requestWithURL:[NSURL fileURLWithPath:path]]];
}

- (NSImage *)snapshot
{
	WebFrame *frame = self.mainFrame;
	WebFrameView *view = frame.frameView;
	NSRect imageRect = view.documentView.frame;

	imageRect.origin.x = 0;
	imageRect.origin.y = 0;

	NSBitmapImageRep *imageRep = [view.documentView bitmapImageRepForCachingDisplayInRect:view.documentView.frame];
	[view.documentView cacheDisplayInRect:imageRect toBitmapImageRep:imageRep];
	NSImage *image = [NSImage.alloc initWithSize:imageRect.size];
	[image addRepresentation:imageRep];
	return image;
}

-(void)appendTag:(NSS*)tagName attrs:(NSD*)attrs inner:(NSS*)innerHTML {

	// Gets a list of all <body></body> nodes.
	DOMNodeList *bodyNodeList = [self.mainFrame.DOMDocument getElementsByTagName:@"body"];
	// There should be just one in valid HTML, so get the first DOMElement.
	DOMHTMLElement *bodyNode = (DOMHTMLElement *) [bodyNodeList item:0];
	// Create a new element, with a tag name.
	DOMHTMLElement *newNode = (DOMHTMLElement *) [self.mainFrame.DOMDocument createElement:tagName];
	[attrs each:^(id key, id value) {
		[newNode setAttribute:key value:value];
	}];
	// Add the innerHTML for the new element.
	[newNode setInnerHTML:innerHTML];
	// Add the new element to the bodyNode as the last child.
	[bodyNode appendChild:newNode];
}

-(void)appendTagToBody:(NSS*)tagName InnerHTML:(NSS*)innerHTML
{
	// Gets a list of all <body></body> nodes.
	DOMNodeList *bodyNodeList = [self.mainFrame.DOMDocument getElementsByTagName:@"body"];

	// There should be just one in valid HTML, so get the first DOMElement.
	DOMHTMLElement *bodyNode = (DOMHTMLElement *) [bodyNodeList item:0];

	// Create a new element, with a tag name.
	DOMHTMLElement *newNode = (DOMHTMLElement *) [self.mainFrame.DOMDocument createElement:tagName];

	// Add the innerHTML for the new element.
	[newNode setInnerHTML:innerHTML];

	// Add the new element to the bodyNode as the last child.
	[bodyNode appendChild:newNode];
}
//and whenever wanted to change the content,
//-(void)appendString:(NSS*)pString{
//	[self appendTagToBody:@"div" InnerHTML:@"<div><p> Hi there </p></div>"];
//	[self setNeedsDisplay:YES];
//}

@end
