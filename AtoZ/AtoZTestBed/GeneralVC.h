//
//  AZGeneralViewController.h
//  AtoZ
//
//  Created by Alex Gray on 11/8/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GeneralVC : NSViewController

@property (NATOM) IBOutlet AZBackgroundProgressBar *pBar;
@property (NATOM) IBOutlet NSSegmentedControl *segments;
@property (NATOM) IBOutlet NSView 			*targetView;

@property (NATOM) AZMedallionView 	*medallion;
@property (NATOM) BLKVIEW	   	 		*blockView;
@property (NATOM) AZDebugLayerView  	*debugLayers;
@property (NATOM, STRNG) NSIV	 			*badges, *imageNamed;
@property (NATOM) NSSCRLV 				*contactSheet;
@property (NATOM) AtoZGridViewAuto   	*picol;
@property (NATOM) AtoZGridViewAuto	*autoGrid;
@property (NATOM) AZHostView			*hostView;
@property (NATOM) AZGrid				*azGrid;
@property (NATOM) AZPrismView 			*prism;
@property (NATOM) LetterView			*letterView;

@end
