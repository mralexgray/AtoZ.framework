//
//  AZGeneralViewController.h
//  AtoZ
//
//  Created by Alex Gray on 11/8/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

//@import AtoZ;
#import <AtoZ/AtoZ.h>


@interface GeneralVC : NSViewController

@property (NA) IBOutlet AZBackgroundProgressBar *pBar;
@property (NA) IBOutlet NSSegmentedControl *segments;
@property (NA) IBOutlet NSView 			*targetView;

@property (NA) AZMedallionView 	*medallion;
@property (NA) BLKVIEW	   	 		*blockView;
@property (NA) AZDebugLayerView  	*debugLayers;
@property (NA, STR) NSIV	 			*badges, *imageNamed;
@property (NA) NSSCRLV 				*contactSheet;
@property (NA) AtoZGridViewAuto   	*picol;
@property (NA) AtoZGridViewAuto	*autoGrid;
@property (NA) AZHostView			*hostView;
@property (NA) AZGrid				*azGrid;
@property (NA) AZPrismView 			*prism;
@property (NA) LetterView			*letterView;

@end
