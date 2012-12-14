
#import "AZEntitlementDelegate.h"
#import "AZQuadCell.h"

@interface AZQuadCarousel : NSObject <iCarouselDataSource, iCarouselDelegate, NSWindowDelegate>

@property (NATOM) iCarouselType cType;
@property (NATOM) CGF 	fontSize,	intrusion;;
@property (NATOM) NSUI 	iconStyle, 	selectedIndex, 	tilt;
@property (NATOM) Option option;
@property (UNSFE) id refToSelf;

@property (NATOM, STRNG) IBOutlet NSMutableArray *items;
@property (NATOM, STRNG) AZSegmentedRect *seg;

- (IBAction) toggleQuadFlip: (id)sender;
- (IBAction) toggleQuad:	 (id)sender;
- (IBAction) setType:		 (id)sender;

-(void) advance;
-(void) rewind;

@end

//- (IBAction) setVeils:		 (id)sender;
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
