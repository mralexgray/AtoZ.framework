//
//  WebView+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 11/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <WebKit/WebView.h>

@interface WebView (AtoZ)

- (void) loadJQ;
- (void) makeMobile;
- (void) loadFileAtPath:(NSString*)path;
- (NSImage *)snapshot;

-(void)appendTagToBody:(NSString*)tagName InnerHTML:(NSString*)innerHTML;
-(void)appendTag:(NSString*)tagName attrs:(NSDictionary*)attrs inner:(NSString*)innerHTML;

- (void) evaluate:(NSString*)jsString;
- (void) evaluateScriptAt:(NSString*)urlString;
- (void) injectCSSAt:(NSString*)urlString;
- (void) injectCSS:(NSString*)css;
@end

