//
//  AppDelegate.h
//  AtoZ Encyclopedia
//
//  Created by Alex Gray on 8/2/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>
#import <QuartzCore/QuartzCore.h>

#define kCompositeIconHeight 155.0
#define kIconWidth 128.0
#define kFontHeight 25.0
#define kMargin 30.0


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) CALayer *root;


-(IBAction)toggleShake:(id)sender;

@end

