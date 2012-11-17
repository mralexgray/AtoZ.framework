
#import "AtoZ.h"


@interface AZBackgroundProgressBar : NSView

@property (NATOM, ASS) BOOL shouldStop, onDark, highContrast;

//The number of pixels to translate right
@property (NATOM, ASS) CGFloat phase;

//The time interval from the reference date when the progress bar was last phased. Used to update phase
@property (NATOM, ASS) NSTimeInterval lastUpdate;

@property (nonatomic, retain) NSC *primaryColor, *secondaryColor;


- (IBAction)startAnimation:(id)sender;
- (IBAction)stopAnimation:(id)sender;
@end
