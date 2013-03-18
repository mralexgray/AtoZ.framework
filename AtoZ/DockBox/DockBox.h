//
//  AZAppDelegate.h
//  DockBox
//
//  Created by Alex Gray on 3/15/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.



typedef void(^openURL)(NSS*url, WebView *w);

@interface DockBox : NSObject <NSApplicationDelegate>

- (IBAction)getFB:(id)sender;
- (IBAction)getColorList:(id)sender;

@property (ASS) IBOutlet NSWindow 					*window;
@property (ASS) IBOutlet WebView 					*webView;
@property (ASS) IBOutlet NSTableView 				*table;
@property (ASS) IBOutlet NSTextView 				*text;

@property (ASS) IBOutlet NSArrayController 		*arrayC;

@property (ASS) IBOutlet AZHTTPRouter 				*router;
@property (ASS) IBOutlet AZFacebookConnection 	*fb;

@end


