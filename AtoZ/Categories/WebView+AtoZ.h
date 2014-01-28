//
//  WebView+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 11/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WebView (AtoZ)

- (void) loadJQ;

- (void) makeMobile;

- (void) loadFileAtPath:(NSS*)path;

- (NSImage *)snapshot;

-(void)appendTagToBody:(NSS*)tagName InnerHTML:(NSS*)innerHTML;
-(void)appendTag:(NSS*)tagName attrs:(NSD*)attrs inner:(NSS*)innerHTML;

- (void) evaluate:(NSS*)jsString;
- (void) evaluateScriptAt:(NSS*)urlString;
- (void) injectCSSAt:(NSS*)urlString;
- (void) injectCSS:(NSS*)css;
@end

