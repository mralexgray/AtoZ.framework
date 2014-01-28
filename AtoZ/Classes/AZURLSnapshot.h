//
//  AZURLSnapshot.h
//  AtoZ
//
//  Created by Alex Gray on 12/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface AZURLSnapshot : NSObject
{
	void (^completionBlock)(NSImage *image);
	WebView *webView;
}
+ (void)takeSnapshotOfWebPageAtURL:(NSURL *)url completionBlock:(void (^)(NSImage *))block;
@end
