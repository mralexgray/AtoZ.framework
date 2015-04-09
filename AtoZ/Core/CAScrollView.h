



@class CAScrollView;
@protocol CAScrollViewDelegate <NSObject>
-(void)scrollView:(CAScrollView*)sc didSelectLayer:(CAL*)layer;
-(void)scrollView:(CAScrollView*)sc isScrolling:(NSE*)e;
-(void)scrollView:(CAScrollView*)sc objectForLayer:(CAL*)e atIndex:(NSUI)idx;
-(NSC*)scrollView:(CAScrollView*)sc colorForObject:(id)o atIndex:(NSUI)idx;
@end

@interface 	  CAScrollView : NSView

@property (NA)  			NSSZ		unit;
@property (NA) 		NSUI 		fixWatchdog;
@prop_RO				NSA 		*allLayers;
@property (NA) 	NSMA 		*layerQueue;
@property (NA) 	CAL 		*hoveredLayer, *selectedLayer, *scrollLayer;
@property (NA)  		AZOrient		oreo;

@property (UNSF) id <CAScrollViewDelegate>  delegate;
@prop_RO CGF 	firstLaySpan, sublayerOrig, sublayerSpan, lastLaySpan, superBounds, lastLayOrig;
@prop_RO NSUI  sublayerCt;

- (IBAction)toggleOrientation _ O ___
                              
//@property (NA, ASS)	BOOL 	needsLayout;

@end

