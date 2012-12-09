//#import "AZGeometryViewController.h"
#import "AZGeneralViewController.h"
#import "AZUIViewController.h"
#import "AZColorViewController.h"

typedef NS_ENUM (NSUI, ScrollFix)	{	LayerInsertFront,	LayerInsertEnd,
										LayerRemoveFront,	LayerRemoveEnd,
										LayerStateOK	,		LayerStateUnset		};
@interface 	  CAScrollView : NSView

@property IBOutlet 		 NSV		*hostView;
@property (NATOM, STRNG) NSMA 		*layerQueue;
@property (NATOM, STRNG) CAL 		*scrollLayer, *hostlayer, *focusedLayer;
@property (NATOM)  		 CGF 		offset;
@property (RONLY)  		 CGF 		firstLaySpan, sublayerOrig, sublayerSpan, lastLaySpan, superBounds, lastLayOrig, fixLayerState;
@property (NATOM)  		 AZOrient	orientation;
@property (NATOM)		 ScrollFix	fixState;

-(IBAction)toggleOrientation:(id)sender;
@end



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

@property (weak) IBOutlet AtoZColorWell 			*colorWell;

@property (weak) IBOutlet NSBUTT 					*holdOntoViews;
//@property (NATOM, STRNG)  AZFileGridView 			*fileGrid;

//@property (weak) IBOutlet  AZGeometryViewController *geoVC;
@property (weak) IBOutlet  AZGeneralViewController  *genVC;
@property (weak) IBOutlet  AZUIViewController		*uiVC;
@property (weak) IBOutlet  AZColorViewController	*colorVC;

@property (weak) IBOutlet NSW 					*window;
@property (weak) IBOutlet NSV						*mainView;
@property (weak) IBOutlet CAScrollView			*scrollTest;

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
