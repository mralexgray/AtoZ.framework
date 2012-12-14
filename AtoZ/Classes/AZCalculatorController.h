//
//  AZCalculatorController.h
//  AtoZ
//
//  Created by Alex Gray on 9/21/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "CalcModel.h"

@interface AZCalculatorController : NSWindowController
{
//	IBOutlet NSWindow *window;

}
+ (AZCalculatorController *)sharedCalc;
+ (NSString *)nibName;

- (IBAction)add:(id)sender;
//- (IBAction)subtract:(id)sender;
//- (IBAction)multiply:(id)sender;
//- (IBAction)divide:(id)sender;
//- (IBAction)calculate:(id)sender;
//- (IBAction)clear:(id)sender;
- (IBAction)getValue:(id)sender;
- (void)setLabel;
@property (assign) IBOutlet NSTextField *label;
//NSString *labelValue;

@property (nonatomic, strong) CalcModel *calc;

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSString *labelValue;

@end
