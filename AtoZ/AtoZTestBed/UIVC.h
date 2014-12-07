//
//  AZUIViewController.h
//  AtoZ
//
//  Created by Alex Gray on 11/16/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//


@interface UIVC : NSViewController <AtoZGridViewDataSource, AtoZGridViewDelegate>

@property (readonly)     		BGThemeManager				*sharedThemeManager;
@property (assign) 	IBOutlet BGHUDTabView 				*tabView;
@property (assign) 	IBOutlet BGHUDProgressIndicator 	*bar;
@property (assign) 	IBOutlet BGHUDProgressIndicator 	*spinner;
@property (assign) 	IBOutlet AtoZGridView 				*gridView;
@property (assign) 	IBOutlet NSSlider					 	*itemSizeSlider;
@property (assign)  	IBOutlet BGHUDView		 			*windowView;
@property (assign)  	IBOutlet AtoZColorWell 				*colorWell;
@property (nonatomic, strong) XLDragDropView 			*xl;


@property (NATOM,strong) NSColor *baseColor;
@property (weak) IBOutlet NSW *window;
@property (strong) 		  NSMA *items;

- (IBAction)doSegmentStuff:_;
                              - (IBAction)itemSizeSliderAction:_;
                              
- (IBAction)showXFLDragDrop:_;
                              
@property (assign, nonatomic) BOOL spinning;
@property (assign, nonatomic) double progress;

@end
