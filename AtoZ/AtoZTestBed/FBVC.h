//
//  AZFacebookBrowserView.h
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//


@interface FBVC : NSViewController <	PhFacebookDelegate,
										NSOutlineViewDataSource,
										NSOutlineViewDelegate	>

@property (STR) PhFacebook *fb;

@property (UNSF) IBOutlet NSOutlineView		*outlineView;
@property (UNSF) IBOutlet BGHUDTokenFieldCell 	*tokens;

@property (UNSF) IBOutlet NSTextField 	*token_label;
@property (UNSF) IBOutlet NSTextField 	*request_label;
@property (UNSF) IBOutlet NSTextField 	*request_text;
@property (UNSF) IBOutlet NSTextView 		*result_text;
@property (UNSF) IBOutlet NSImageView 	*profile_picture;
@property (UNSF) IBOutlet NSButton 		*send_request;

@property (UNSF) IBOutlet NSView*			scrollV;
@property (UNSF) IBOutlet NSView*			target;

@end
