//
//  AZAppDelegate.h
//  AtoZTestBed
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>
#import <AtoZ/AtoZ.h>
#import "AZGeometryViewController.h"
#import "AZGeneralViewController.h"

//#import <AtoZUI/AtoZUI.h>


@interface NASpinSeque : NSObject

@property (retain, strong) NSView *v1, *v2, *sV;
@property (retain, strong) CAL *l1, *l2;

+ (id)animateTo:(id)v1 inSuperView:(id)sV;

@end

@interface TestBedDelegate : NSObject <NSApplicationDelegate>

@property (NATOM, STRNG)  AZGeometryViewController *geoVC;
@property (NATOM, STRNG)  AZGeneralViewController *genVC;


@property (ASS) IBOutlet NSWindow 		  	*window;
@property (ASS) IBOutlet NSView				*mainView;


@property (STRNG, NATOM) AtoZ 				*propeller;
@property (STRNG, NATOM) NASpinSeque 		*seque;
@property (STRNG, NATOM) AZMenuBarWindow 		*mbWindow;


@end
