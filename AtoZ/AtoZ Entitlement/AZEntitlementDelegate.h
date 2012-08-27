//
//  AZAppDelegate.h
//  AtoZ Entitlement
//
//  Created by Alex Gray on 8/25/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>

@interface AZEntitlementDelegate : NSObject <NSApplicationDelegate>

@property (assign, nonatomic) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSString *log;
@property (nonatomic, retain) AtoZ *dbx;
@property (nonatomic, retain) AZFileGridView *g;

@end
