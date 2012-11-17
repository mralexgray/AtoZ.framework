//
//  AZUIViewController.h
//  AtoZ
//
//  Created by Alex Gray on 11/16/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZUIViewController : NSViewController <AtoZGridViewDataSource, AtoZGridViewDelegate>

@property (assign) 	IBOutlet BGHUDTabView *tabView;
@property (assign) 	IBOutlet BGHUDProgressIndicator *bar;
@property (assign) 	IBOutlet BGHUDProgressIndicator *spinner;
@property (assign) 	IBOutlet AtoZGridView *gridView;
@property (assign) 	IBOutlet NSSlider *itemSizeSlider;
@property (assign)  IBOutlet BGHUDView *windowView;
@property (assign)  IBOutlet AtoZColorWell *colorWell;

@property (strong) 		  NSMA *items;

- (IBAction)doSegmentStuff:(id)sender;
- (IBAction)itemSizeSliderAction:(id)sender;
- (IBAction)setViewColor:(id)sender;


@property (assign, nonatomic) BOOL spinning;
@property (assign, nonatomic) double progress;

@end
