//
//  AZURLSnapshot.m
//  AtoZ
//
//  Created by Alex Gray on 12/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


#import "AZURLSnapshot.h"


@interface AZURLSnapshot()
- (id)_initWithCompletionBlock:(void (^)(NSImage *))block;
- (void)_beginDownloadFromURL:(NSURL *)url;
@end

@implementation AZURLSnapshot
+ (void)takeSnapshotOfWebPageAtURL:(NSURL *)url completionBlock:(void (^)(NSImage *))block;
{
	AZURLSnapshot *instance = [[self alloc] _initWithCompletionBlock:block];
	[instance _beginDownloadFromURL:url];
	[instance autorelease];
}


- (id)_initWithCompletionBlock:(void (^)(NSImage *))block;
{
	self = [super init];
	if (self != nil)
	{
		completionBlock = [block copy];

		webView = [[WebView alloc] initWithFrame:NSMakeRect(0.0, 0.0, 1000.0, 1000.0) frameName:nil groupName:nil];
		[webView setFrameLoadDelegate:self];
	}
	return self;
}


- (void)_beginDownloadFromURL:(NSURL *)url;
{
	[self retain];
	[webView setMainFrameURL:[url absoluteString]];
}


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	if (frame != [webView mainFrame])
	{
		return;
	}

	NSView *webFrameViewDocView = [[[webView mainFrame] frameView] documentView];
	NSRect cacheRect = [webFrameViewDocView bounds];

	NSBitmapImageRep *bitmapRep = [webFrameViewDocView bitmapImageRepForCachingDisplayInRect:cacheRect];
	[webFrameViewDocView cacheDisplayInRect:cacheRect toBitmapImageRep:bitmapRep];

	NSSize imgSize = cacheRect.size;
	if (imgSize.height > imgSize.width)
	{
		imgSize.height = imgSize.width;
	}

	NSRect srcRect = NSZeroRect;
	srcRect.size = imgSize;
	srcRect.origin.y = cacheRect.size.height - imgSize.height;

	NSRect destRect = NSZeroRect;
	destRect.size = imgSize;

	NSImage *webImage = [[[NSImage alloc] initWithSize:imgSize] autorelease];
	[webImage lockFocus];
	[bitmapRep drawInRect:destRect fromRect:srcRect operation:NSCompositeCopy fraction:1.0 respectFlipped:YES hints:nil];
	[webImage unlockFocus];

	NSSize defaultDisplaySize;
	defaultDisplaySize.height = 64.0 * (imgSize.height / imgSize.width);
	defaultDisplaySize.width = 64.0;
	[webImage setSize:defaultDisplaySize];

	completionBlock(webImage);

	[self autorelease];
}


- (void)dealloc
{
	[completionBlock release];
	[webView release];

	[super dealloc];
}

@end


