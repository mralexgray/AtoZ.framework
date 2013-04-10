//#import "AZGeometryViewController.h"
#import "GeneralVC.h"
#import "UIVC.h"
#import "ColorVC.h"
#import "FBVC.h"
#import "TUIVVC.h"



@interface TestBedDelegate : NSObject			<	NSApplicationDelegate,
													NSWindowDelegate	>
													//, AZSemiResponder>

@property (STRNG) IBOutlet AtoZColorWell 			*colorWell;

@property (UNSFE) IBOutlet  GeneralVC		*genVC;
@property (UNSFE) IBOutlet  UIVC			*uiVC;
@property (UNSFE) IBOutlet  ColorVC		*colorVC;
@property (UNSFE) IBOutlet  FBVC			*fbV;
@property (UNSFE) IBOutlet  TUIVVC		*tuiVC;

@property (STRNG) IBOutlet id				window;
@property (STRNG) IBOutlet id				contentView;
@property (STRNG) IBOutlet NSView*			targetView;

@property (STRNG) IBOutlet NSView			*scrollTestHost;
@property (STRNG) IBOutlet CAScrollView		*scrollTest;

- (IBAction) setViewFromPopUp:(id)sender;
- (IBAction) reZhuzhScrollLayer:(id)sender;

@property (STRNG) IBOutlet NSBUTT *holdOntoViews;

@property (STRNG)	BLKVIEW  *host;
@property (STRNG) CASCRLL  *scrlr;
@property (NATOM) CAGL	   *hit;
@property (NATOM) NSMD	 *model;
@property (RONLY) 	NSRNG 	 visible, front, back;
@property (RONLY) 	NSS	   *fixState;
@property (RONLY) 	ScrollFix scrollFix;
@property (RONLY) 	NSS 		*visibleSubsString;
@property (NATOM) 	CGF 		off;
@property (NATOM)	NSA		*visibleSubs, *subsAscending; // actually visible, and them sorted
@property (STRNG) 	NSS		*actionStatus; 	 					// Just shows what "actions" are happening.

- (IBAction)scrollFromSegment:(id)sender;
@end
//@property (NATOM, STRNG)  AZFileGridView 			*fileGrid;
//@property (weak) IBOutlet  AZGeometryViewController *geoVC;
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




//#import <AtoZUI/AtoZUI.h>


//@interface NASpinSeque : NSObject
//
//@property (retain, strong) NSView *v1, *v2, *sV;
//@property (retain, strong) CAL *l1, *l2;
//
//+ (id)animateTo:(id)v1 inSuperView:(id)sV;
//
//@end





//-(IBAction)scrollLowerRight:(id)sender;
//-(IBAction)scrollRight:(id)sender;
//-(IBAction)scrollUp:(id)sender;
//-(IBAction)scrollDown:(id)sender;
//-(IBAction)scrollLeft:(id)sender;
//-(IBAction)scrollUpperLeft:(id)sender;
//-(IBAction)scrollUpperRight:(id)sender;
//-(IBAction)scrollLowerLeft:(id)sender;
//extern NSS* stringForScrollFix(ScrollFix val);
