//
//  AZAppDelegate.h
//  AtoZTestBed
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>
#import <AtoZ/AtoZ.h>
#import "AZGeometryViewController.h"
//#import <AtoZUI/AtoZUI.h>


@interface NASpinSeque : NSObject

@property (retain, strong) NSView *v1, *v2, *sV;
@property (retain, strong) CAL *l1, *l2;

+ (id)animateTo:(id)v1 inSuperView:(id)sV;

@end

@interface TestBedDelegate : NSObject <NSApplicationDelegate>

@property (ASS) IBOutlet AZGeometryViewController *geoVC;
@property (ASS) IBOutlet NSWindow 		  	*window;
@property (ASS) IBOutlet NSSegmentedControl *segments;
@property (ASS) IBOutlet NSView 			*targetView;

@property (STRNG, NATOM) AtoZGridViewAuto	*autoGrid;
@property (STRNG, NATOM) AZHostView			*hostView;
@property (STRNG, NATOM) AZGrid				*azGrid;
@property (STRNG, NATOM) NASpinSeque 		*seque;
@property (STRNG, NATOM) AZPrismView 		*prism;
@property (STRNG, NATOM) AtoZ 				*propeller;

@property (STRNG, NATOM) AZMedallionView *medallion;
@property (STRNG, NATOM) BLKVIEW	   	 	*blockView;
@property (STRNG, NATOM) AZDebugLayerView  	*debugLayers;
@property (STRNG, NATOM) NSIV	 			*badges,
											*imageNamed,
											*picol;

@end
