//#import "AZGeometryViewController.h"
#import "AZGeneralViewController.h"
#import "AZUIViewController.h"
#import "AZColorViewController.h"

@interface TestBedDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> //, AZSemiResponder>

@property (weak) IBOutlet AtoZColorWell 			*colorWell;

@property (weak) IBOutlet NSBUTT 					*holdOntoViews;
//@property (NATOM, STRNG)  AZFileGridView 			*fileGrid;

//@property (weak) IBOutlet  AZGeometryViewController *geoVC;
@property (weak) IBOutlet  AZGeneralViewController  *genVC;
@property (weak) IBOutlet  AZUIViewController		*uiVC;
@property (weak) IBOutlet  AZColorViewController	*colorVC;

@property (weak) IBOutlet NSW 					*window;
@property (weak) IBOutlet NSV						*mainView;
//@property (weak) 		 id  					activeView;
//@property (NATOM, STRNG) WeakMutableArray		*vcs;


//@property (STRNG, NATOM) AtoZ 					*propeller;
//@property (STRNG, NATOM) NASpinSeque 			*seque;
//@property (STRNG, NATOM) AZSemiResponderWindow	*semiWindow;

//@property (STRNG, NATOM) NSS	 *semiLog;


- (IBAction) setViewFromPopUp:(id)sender;

@end

//#import <AtoZUI/AtoZUI.h>


//@interface NASpinSeque : NSObject
//
//@property (retain, strong) NSView *v1, *v2, *sV;
//@property (retain, strong) CAL *l1, *l2;
//
//+ (id)animateTo:(id)v1 inSuperView:(id)sV;
//
//@end
