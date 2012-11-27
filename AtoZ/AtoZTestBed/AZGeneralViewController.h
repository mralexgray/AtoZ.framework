//
//  AZGeneralViewController.h
//  AtoZ
//
//  Created by Alex Gray on 11/8/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AZGeneralViewController : NSViewController

@property (STRNG, NATOM) IBOutlet AZBackgroundProgressBar *pBar;
@property (STRNG, NATOM) IBOutlet NSSegmentedControl *segments;
@property (STRNG, NATOM) IBOutlet NSView 			*targetView;

@property (STRNG, NATOM) AZMedallionView *medallion;
@property (STRNG, NATOM) BLKVIEW	   	 	*blockView;
@property (STRNG, NATOM) AZDebugLayerView  	*debugLayers;
@property (STRNG, NATOM) NSIV	 			*badges, *imageNamed;
@property (STRNG, NATOM) NSSV 				*contactSheet;
@property (STRNG, NATOM) AtoZGridViewAuto   *picol;
@property (STRNG, NATOM) AtoZGridViewAuto	*autoGrid;
@property (STRNG, NATOM) AZHostView			*hostView;
@property (STRNG, NATOM) AZGrid				*azGrid;
@property (STRNG, NATOM) AZPrismView 		*prism;
@property (STRNG, NATOM) LetterView			*letterView;

@end
