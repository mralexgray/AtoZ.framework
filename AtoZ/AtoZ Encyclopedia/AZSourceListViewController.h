
//  AZSourceListViewController.h
//  AtoZ

//  Created by Alex Gray on 8/20/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import <Cocoa/Cocoa.h>
#import <AtoZ/AtoZ.h>

//#import <PLWeakCompatibility/PLWeakCompatibilityStubs.h>

#import "iCarouselViewController.h"

@interface AZSourceListViewController : NSViewController <AZSourceListDataSource, AZToggleArrayViewDelegate>

@property (weak) IBOutlet AZSourceList *sourceList;
//@property (weak) IBOutlet AZToggleArrayView *tv;

//@property (nonatomic, assign) IBOutlet NSString *point1x;
//@property (nonatomic, assign) IBOutlet NSString *point1y;
//@property (nonatomic, assign) IBOutlet NSString *point2x;
//@property (nonatomic, assign) IBOutlet NSString *point2y;
@property (weak) IBOutlet iCarouselViewController *carrie;

- (IBAction) goMouseTest:(id)sender;
- (IBAction) reload:(id)sender;
- (IBAction) moveThemAll:(id) sender;
- (IBAction) cancel:(id) sender;

@end
