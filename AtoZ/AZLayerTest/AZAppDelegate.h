//
//  AZAppDelegate.h
//  AZLayerTest
//
//  Created by Alex Gray on 7/10/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <AtoZ/AZBoxLayer.h>

#define kCompositeIconHeight 155.0
#define kIconWidth 128.0
#define kFontHeight 25.0
#define kMargin 30.0

@interface AZAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) CALayer *root;


-(IBAction)toggleShake:(id)sender;

@end
