//
//  KSHTMLWriter+AtoZ.h
//  AtoZ
//
//  Created by Alex Gray on 12/4/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <AtoZ/AtoZ.h>

@interface KSHTMLWriter (AtoZ)

+ (NSS*) markupForScripts:(NSA*)jsSrcs;
+ (NSS*) markupForStyles:(NSA*)cssLinks;
+ (NSS*) markupForStyles:(NSA*)cssLinks base:(NSS*)base;
+ (NSS*) markupForScripts:(NSA*)jsSrcs  base:(NSS*)base;

//  delimeter format ObjectiveCSOurceFile.method.variable, ie. "AZWebSocketServer.baseHTML.js"
+ (NSS*) markupForAZJSWithID:(NSS*)delimeter;


@end
