//
//  AZFacebookBrowserView.h
//  AtoZ
//
//  Created by Alex Gray on 3/13/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZFacebookBrowserView : NSViewController <PhFacebookDelegate, NSOutlineViewDataSource, NSOutlineViewDelegate>

@property (nonatomic, retain) PhFacebook *fb;

@property (unsafe_unretained) IBOutlet NSOutlineView* outlineView;


@property (unsafe_unretained) IBOutlet NSTextField *token_label;
@property (unsafe_unretained) IBOutlet NSTextField *request_label;
@property (unsafe_unretained) IBOutlet NSTextField *request_text;
@property (unsafe_unretained) IBOutlet NSTextView *result_text;
@property (unsafe_unretained) IBOutlet NSImageView *profile_picture;
@property (unsafe_unretained) IBOutlet NSButton *send_request;

@property (unsafe_unretained) IBOutlet NSScrollView *scrollV;
@property (unsafe_unretained) IBOutlet NSView *target;

@end
