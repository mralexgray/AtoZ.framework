//
//  WebView+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 11/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WebView (AtoZ)

- (void) makeMobile;

- (void) loadFileAtPath:(NSS*)path;

- (NSImage *)snapshot;

-(void)appendTagToBody:(NSS*)tagName InnerHTML:(NSS*)innerHTML;

@end
