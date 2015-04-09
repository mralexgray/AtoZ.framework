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

- (IBAction)add _ x ___
                              //- (IBAction)subtract:__ ___
                              //- (IBAction)multiply:__ ___
                              //- (IBAction)divide:__ ___
                              //- (IBAction)calculate:__ ___
                              //- (IBAction)clear:__ ___
                              - (IBAction)getValue _ v ___
                              - (void) setLabel;
@property (assign) IBOutlet NSTextField *label;
//NSString *labelValue;

@property (nonatomic, strong) CalcModel *calc;

//INHERITED @property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSString *labelValue;

@end
