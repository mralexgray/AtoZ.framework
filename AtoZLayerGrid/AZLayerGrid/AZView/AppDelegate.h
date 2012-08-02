//
//  AppDelegate.h
//  AZView
//
//  Created by Alex Gray on 7/24/12.
//  Copyright (c) 2012 Alex Gray. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain,nonatomic) NSNumber *unit;
@end
