
#import "AZQuadCell.h"

@interface AZQuadCarousel : NSObject <iCarouselDataSource, iCarouselDelegate, NSWindowDelegate>

@property (NA, STR) AZTW 	*track_N, 	*track_S, 	*track_E, 	*track_W;
@property (NA, STR) iC 		 *menu_N, 	 *menu_S, 	 *menu_E, 	 *menu_W;
@property (NA) iC *activeMenu;

@property (NA) iCarouselType cType;
@property (NA) CGF 	fontSize;
@property (NA) NSUI 	iconStyle, 	selectedIndex, 	tilt;
@prop_RO NSRNG selectedRange;
@property (NA, STR) NSS 		*activeMenuID,	*activeTrackID;
@property (NA, STR) NSD 		*windowLog;
@prop_RO 			 NSA 		*menus, 			*tracks;

@property (NA) Option option;
@property (UNSF) id refToSelf;

@property (NA, STR) NSMutableArray 	*items;
@property (NA, STR) NSD 					*quads;
@property (NA, STR) AZSegmentedRect 	*seg;

- (IBAction) toggleQuadFlip: _;
                              //- (IBAction) toggleQuad:	 _;
                              //- (IBAction) setType:		 _;
                              
-(IBAction)advance:__ ___
                              -(IBAction)rewind:__ ___
                              
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
