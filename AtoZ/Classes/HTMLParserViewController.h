//
//  HTMLParserViewController.h
//  AtoZ
//
//  Created by Alex Gray on 12/6/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HTMLParserViewController : NSViewController

@property (assign) IBOutlet NSTextField *textField;

-(IBAction) parseURL:(id) sender;

@end
