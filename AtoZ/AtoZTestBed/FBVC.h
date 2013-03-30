//
//  AZFacebookBrowserView.h
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FBVC : NSViewController <	PhFacebookDelegate,
										NSOutlineViewDataSource,
										NSOutlineViewDelegate	>

@property (STRNG) PhFacebook *fb;

@property (UNSFE) IBOutlet NSOutlineView		*outlineView;
@property (UNSFE) IBOutlet BGHUDTokenFieldCell 	*tokens;

@property (UNSFE) IBOutlet NSTextField 	*token_label;
@property (UNSFE) IBOutlet NSTextField 	*request_label;
@property (UNSFE) IBOutlet NSTextField 	*request_text;
@property (UNSFE) IBOutlet NSTextView 	*result_text;
@property (UNSFE) IBOutlet NSImageView 	*profile_picture;
@property (UNSFE) IBOutlet NSButton 	*send_request;

@property (UNSFE) IBOutlet NSView*			scrollV;
@property (UNSFE) IBOutlet NSView*			target;

@end
