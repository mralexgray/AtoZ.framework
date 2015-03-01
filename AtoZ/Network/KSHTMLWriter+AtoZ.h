//
//  KSHTMLWriter+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 12/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <KSHTMLWriter/KSHTMLWriter.h>
@import AtoZUniversal;

@interface KSHTMLWriter (AtoZ)

+ (NSS*) markupForScripts:(NSA*)jsSrcs;
+ (NSS*) markupForStyles:(NSA*)cssLinks;
+ (NSS*) markupForStyles:(NSA*)cssLinks base:(NSS*)base;

//	[KSHTMLWriter markupForStyles:@[@"/js/jquery-ui.css",    @"/js/jquery-notify/ui.notify.css"] base:@"http://mrgray.com"],
/*! Generate markup for linked JS relative to a base URL..

\c	[KSHTMLWriter markupForScripts:@[ @"/js/jquery.latest.js", @"/js/jquery-ui.js" ]
                              base:@"http://mrgray.com"];

*/
+ (NSS*) markupForScripts:(NSA*)jsSrcs  base:(NSS*)base;

//  delimeter format ObjectiveCSOurceFile.method.variable, ie. "AZWebSocketServer.baseHTML.js"
+ (NSS*) markupForAZJSWithID:(NSS*)delimeter;


@end
