

@class AZQuadCarousel;
@interface AZEntitlementDelegate : NSObject <NSApplicationDelegate>

@property (NA, STR) AZCalculatorController *cc;
@property (NA, ASS) IBOutlet AZTrackingWindow *north;
@property (NA, ASS) IBOutlet AZTrackingWindow *south;
@property (NA, ASS) IBOutlet AZTrackingWindow *east;
@property (NA, ASS) IBOutlet AZTrackingWindow *west;

@property (NA, STR) NSString *log;
@property (NA, STR) AtoZ *dbx;
@property IBOutlet NSView* imageView;
@property (NA, STR) IBOutlet AZQuadCarousel *quad;

@end

//@property (nonatomic, retain) AZFileGridView *g;
//- (IBAction)saveAction:__ _
                              