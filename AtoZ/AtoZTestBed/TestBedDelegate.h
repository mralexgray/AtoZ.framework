//#import "AZGeometryViewController.h"
#import "AZGeneralViewController.h"
#import "AZUIViewController.h"
#import "AZColorViewController.h"





//-(IBAction)scrollLowerRight:(id)sender;
//-(IBAction)scrollRight:(id)sender;
//-(IBAction)scrollUp:(id)sender;
//-(IBAction)scrollDown:(id)sender;
//-(IBAction)scrollLeft:(id)sender;
//-(IBAction)scrollUpperLeft:(id)sender;
//-(IBAction)scrollUpperRight:(id)sender;
//-(IBAction)scrollLowerLeft:(id)sender;
//extern NSS* stringForScrollFix(ScrollFix val);


@interface TestBedDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate> //, AZSemiResponder>

@property (STRNG) IBOutlet AtoZColorWell 			*colorWell;

@property (STRNG) IBOutlet NSBUTT 					*holdOntoViews;
//@property (NATOM, STRNG)  AZFileGridView 			*fileGrid;

//@property (weak) IBOutlet  AZGeometryViewController *geoVC;
@property (STRNG) IBOutlet  AZGeneralViewController  *genVC;
@property (STRNG) IBOutlet  AZUIViewController		*uiVC;
@property (STRNG) IBOutlet  AZColorViewController	*colorVC;

@property (STRNG) IBOutlet NSW 					*window;
@property (STRNG) IBOutlet NSV						*mainView;
@property (STRNG) IBOutlet NSView				*scrollTestHost;
@property (STRNG) IBOutlet CAScrollView			*scrollTest;

//@property (weak) IBOutlet NSView	*scrollTest;
//@property (weak) IBOutlet CAScrollView 	*scrollTestLayerView;
//@property (nonatomic, strong) CAScrollLayer *scrollLayer;
//@property (nonatomic, strong) CAL *scrollLayerContent;
//
//@property (RONLY) NSS* visiRect;

//@property (weak) 		 id  					activeView;
//@property (NATOM, STRNG) WeakMutableArray		*vcs;


//@property (STRNG, NATOM) AtoZ 					*propeller;
//@property (STRNG, NATOM) NASpinSeque 			*seque;
//@property (STRNG, NATOM) AZSemiResponderWindow	*semiWindow;

//@property (STRNG, NATOM) NSS	 *semiLog;


- (IBAction) setViewFromPopUp:(id)sender;
- (IBAction) reZhuzhScrollLayer:(id)sender;

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
