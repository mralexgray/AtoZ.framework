//
//  WebView+AtoZ.m
//  AtoZ
//
//  Created by Alex Gray on 11/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import "WebView+AtoZ.h"
#import <WebKit/WebKit.h>



@implementation WebView (AtoZ)


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
	NSImage *image = [[[NSImage alloc] initWithSize:imageRect.size] autorelease];
	[image addRepresentation:imageRep];
	return image;
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
