#import "AtoZ.h"
//
//  AZWindowTabViewController.h
//  AtoZ
//
//  Created by Alex Gray on 6/6/13.
//  Copyright (c) 2013 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class AZWindowTab;
@interface AZWindowTabViewController : NSViewController

@property (weak) IBOutlet 		 WebView * webView;
@property (weak) 				AZWindowTab * windowTab;
@property (assign) 		 		 AZAlign   alignment;
//@property (strong) 		 		      id   representedObject;
@end

//@interface AZWindowTabView : NSView
//
//@property (strong) NSImage *tabImage;
//@property (strong) NSBP *path;
//@property (strong) CALayer *vLayer;
//@property (strong) CAShapeLayer *pLayer;
//@property (weak) IBOutlet AZWindowTabViewController *controller;
//@end
