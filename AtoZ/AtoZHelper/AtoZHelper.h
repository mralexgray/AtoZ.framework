//
//  AZAppDelegate.h
//  DockBox
//
//  Created by Alex Gray on 3/15/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.

#import <AtoZ/AtoZ.h>

@interface AZShowWindowScriptCommand : NSScriptCommand @end

typedef void(^openURL)(NSS*url, WebView *w);

@interface AtoZHelper : NSObject <NSApplicationDelegate, AtoZDelegate>

//, WebSocketDelegate, AZWebSocketServerDelegate>
@property (ASS) IBOutlet     NSTextView * text;

@property (ASS) IBO     NSW * window;
@property      AZHTTPRouter * httpServer;
@property					     NSAC * sockets;
@property            Gridly * gridly;
@property (WK) IBO  WebView * webView,
														* webView2;


//@property AZWebSocketServer *socketServer;
//@property (STRNG) AZAddressBook *ab;
//
//- (IBAction)getFB:(id)sender;
//- (IBAction)getColorList:(id)sender;
//
//@property (ASS) IBOutlet NSWindow 					*window;
//@property (ASS) IBOutlet WebView 					*webView;
//@property (ASS) IBOutlet NSTableView 				*table;
//@property (ASS) IBOutlet NSTextView 				*text;
//
//@property (ASS) IBOutlet NSArrayController 		*arrayC;
//
//@property (ASS) IBOutlet AZHTTPRouter 				*router;
//@property (ASS) IBOutlet AZFacebookConnection 	*fb;

@end


