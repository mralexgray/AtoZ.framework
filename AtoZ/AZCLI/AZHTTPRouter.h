//
//  AZHTTPRouter.h
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//


@interface AZHTTPRouter : RoutingHTTPServer

@property (NATOM, STRNG) 	AssetCollection   *assets;
@property (NATOM, STRNG) 	IBOutlet WebView  *webView;
@property (NATOM, STRNG) 	NSS				 				*baseURL;
@property (NATOM, ASS) 	 	BOOL							 shouldExit;
@property (NATOM, ASS) 	 	int								 exitCode;

-(void) start;

@end

@interface Shortcut : NSObject
@property (STRNG, NATOM) NSS* uri, *syntax;
- (id) initWithURI:(NSS*)uri syntax:(NSS*)syntax;



@end
