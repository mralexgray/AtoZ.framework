//
//  AZCalculatorController.h
//  AtoZ
//
//  Created by Alex Gray on 9/21/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "CalcModel.h"

@interface AZCalculatorController : NSWindowController
{
//	IBOutlet NSWindow *window;

}
+ (AZCalculatorController *)sharedCalc;
+ (NSString *)nibName;

- (IBAction)add:__ _
                              //- (IBAction)subtract:__ _
                              //- (IBAction)multiply:__ _
                              //- (IBAction)divide:__ _
                              //- (IBAction)calculate:__ _
                              //- (IBAction)clear:__ _
                              - (IBAction)getValue:__ _
                              - (void) setLabel;
@property (assign) IBOutlet NSTextField *label;
//NSString *labelValue;

@property (nonatomic, strong) CalcModel *calc;

//INHERITED @property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSString *labelValue;

@end
