

@class AZQuadCarousel;
@interface AZEntitlementDelegate : NSObject <NSApplicationDelegate>

@property (NATOM, STRNG) AZCalculatorController *cc;
@property (NATOM, ASS) IBOutlet AZTrackingWindow *north;
@property (NATOM, ASS) IBOutlet AZTrackingWindow *south;
@property (NATOM, ASS) IBOutlet AZTrackingWindow *east;
@property (NATOM, ASS) IBOutlet AZTrackingWindow *west;

@property (NATOM, STRNG) NSString *log;
@property (NATOM, STRNG) AtoZ *dbx;
@property IBOutlet NSView* imageView;
@property (NATOM, STRNG) IBOutlet AZQuadCarousel *quad;

@end

//@property (nonatomic, retain) AZFileGridView *g;
//- (IBAction)saveAction:(id)sender;
