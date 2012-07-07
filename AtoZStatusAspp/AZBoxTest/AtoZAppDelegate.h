//
//  AtoZAppDelegate.h
//  AZBoxTest
//
//  Created by Alex Gray on 7/7/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>


@interface AtoZAppDelegate : NSObject <NSApplicationDelegate, AZBoxGridDataSource>

@property IBOutlet NSWindow *window;
@property IBOutlet AZBoxGrid *boxGrid;
@property IBOutlet AZBoxGrid *boxGrid2;
- (IBAction)reload:(id)sender;
- (IBAction)log:(id)sender;
- (IBAction)add:(id)sender;

@end
