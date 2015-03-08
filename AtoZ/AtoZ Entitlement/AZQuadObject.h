
#import "AZQuadCell.h"

@interface AZQuadCarousel : NSObject <iCarouselDataSource, iCarouselDelegate, NSWindowDelegate>

@property (NATOM, STR) AZTW 	*track_N, 	*track_S, 	*track_E, 	*track_W;
@property (NATOM, STR) iC 		 *menu_N, 	 *menu_S, 	 *menu_E, 	 *menu_W;
@property (NATOM) iC *activeMenu;

@property (NATOM) iCarouselType cType;
@property (NATOM) CGF 	fontSize;
@property (NATOM) NSUI 	iconStyle, 	selectedIndex, 	tilt;
@prop_RO NSRNG selectedRange;
@property (NATOM, STR) NSS 		*activeMenuID,	*activeTrackID;
@property (NATOM, STR) NSD 		*windowLog;
@prop_RO 			 NSA 		*menus, 			*tracks;

@property (NATOM) Option option;
@property (UNSF) id refToSelf;

@property (NATOM, STR) NSMutableArray 	*items;
@property (NATOM, STR) NSD 					*quads;
@property (NATOM, STR) AZSegmentedRect 	*seg;

- (IBAction) toggleQuadFlip: _;
                              //- (IBAction) toggleQuad:	 _;
                              //- (IBAction) setType:		 _;
                              
-(IBAction)advance:_;
                              -(IBAction)rewind:_;
                              
@end

//- (IBAction) setVeils:		 _;
                              //@property (nonatomic, strong) IBOutlet NSArray *southWest;
//@property (nonatomic, strong) IBOutlet NSArray *northEast;
//@property (nonatomic, assign) iCarouselType type;
//@property (nonatomic, strong) NSMutableArray* content;
//@property (nonatomic, strong) AZTrackingWindow *floater;
//@property (nonatomic, assign) NSUInteger visibleItems;
//@property (unsafe_unretained)) iCarousel *activeMenu;
//@property (nonatomic, assign) BOOL wrap;

//@property (weak) IBOutlet AZEntitlementDelegate *entitler;
//@property (nonatomic, strong) AZSizer *szr;
//- (id) 		 	objectAtIndex: 	 (NSUInteger)	index 			inQuad:(AZWindowPosition)quadrant;
//- (NSUInteger) 	itemsInQuad:		 (AZWindowPosition)		quadrant;
//- (NSA*) 	contentsOfQuad:  (AZWindowPosition)		quadrant;
//- (void) 	 	insertItem:	 	 (id)			item;
//- (void) 	 	insertItems:	 	 (NSA*)	items;
//- (NSRange)		ofQuad:			 (AZWindowPosition)quadrant;

//- (void) removeItem:(id)item;
//- (void) removeItems:(NSA*)items;
