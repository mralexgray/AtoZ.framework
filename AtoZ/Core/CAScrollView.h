


#import "AtoZ.h"


@class CAScrollView;
@protocol CAScrollViewDelegate <NSObject>
-(void)scrollView:(CAScrollView*)sc didSelectLayer:(CAL*)layer;
-(void)scrollView:(CAScrollView*)sc isScrolling:(NSE*)e;
-(void)scrollView:(CAScrollView*)sc objectForLayer:(CAL*)e atIndex:(NSUI)idx;
-(NSC*)scrollView:(CAScrollView*)sc colorForObject:(id)o atIndex:(NSUI)idx;
@end

@interface 	  CAScrollView : RBLScrollView

@property (NATOM,ASS) 		NSUI 		fixWatchdog;
@property (RONLY)				NSA 		*allLayers;
@property (NATOM, STRNG) 	NSMA 		*layerQueue;
@property (NATOM, STRNG) 	CAL 		*hoveredLayer, *selectedLayer, *scrollLayer;
@property (NATOM, ASS)  		AZOrient		oreo;
@property (NATOM, ASS)		StateStyle 	hoverStyle, selectedStyle;
@property (unsafe_unretained) id <CAScrollViewDelegate>  delegate;

- (IBAction)toggleOrientation:(id)sender;

//@property (NATOM, ASS)	BOOL 	needsLayout;

@end



