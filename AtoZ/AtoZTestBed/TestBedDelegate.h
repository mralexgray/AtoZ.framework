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
#import "AZUIViewController.h"

//#import <AtoZUI/AtoZUI.h>


@interface NASpinSeque : NSObject

@property (retain, strong) NSView *v1, *v2, *sV;
@property (retain, strong) CAL *l1, *l2;

+ (id)animateTo:(id)v1 inSuperView:(id)sV;

@end


@interface TestBedDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (weak) IBOutlet AtoZColorWell *colorWell;

@property (weak) IBOutlet NSBUTT *holdOntoViews;
@property (NATOM, STRNG)  AZFileGridView *fileGrid;

@property (NATOM, STRNG)  AZGeometryViewController *geoVC;
@property (NATOM, STRNG)  AZGeneralViewController  *genVC;
@property (NATOM, STRNG)  AZUIViewController		*uiVC;

@property (ASS) IBOutlet NSW *window;
@property (ASS) IBOutlet id	 mainView;
@property (weak) 		 id  activeView;
@property (NATOM, STRNG) NSMD* vcs;


@property (STRNG, NATOM) AtoZ 				*propeller;
@property (STRNG, NATOM) NASpinSeque 		*seque;
@property (STRNG, NATOM) AZSemiResponderWindow 		*mbWindow;


- (IBAction) setViewFromPopUp:(id)sender;

@end
