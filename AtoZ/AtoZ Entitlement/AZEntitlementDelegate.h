

@class AZQuadCarousel;
@interface AZEntitlementDelegate : NSObject <NSApplicationDelegate>

@property (NATOM, STR) AZCalculatorController *cc;
@property (NATOM, ASS) IBOutlet AZTrackingWindow *north;
@property (NATOM, ASS) IBOutlet AZTrackingWindow *south;
@property (NATOM, ASS) IBOutlet AZTrackingWindow *east;
@property (NATOM, ASS) IBOutlet AZTrackingWindow *west;

@property (NATOM, STR) NSString *log;
@property (NATOM, STR) AtoZ *dbx;
@property IBOutlet NSView* imageView;
@property (NATOM, STR) IBOutlet AZQuadCarousel *quad;

@end

//@property (nonatomic, retain) AZFileGridView *g;
//- (IBAction)saveAction:_;
                              