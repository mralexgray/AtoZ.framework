
#import "AtoZ.h"


@interface AZBackgroundProgressBar : NSView

@property (NATOM, ASS) BOOL shouldStop, onDark, highContrast;

@property (nonatomic, retain) NSC *primaryColor, *secondaryColor;

- (IBAction)startAnimation:(id)sender;
- (IBAction)stopAnimation:(id)sender;
@end
