



@class CAScrollView;
@protocol CAScrollViewDelegate <NSObject>
-(void)scrollView:(CAScrollView*)sc didSelectLayer:(CAL*)layer;
-(void)scrollView:(CAScrollView*)sc isScrolling:(NSE*)e;
-(void)scrollView:(CAScrollView*)sc objectForLayer:(CAL*)e atIndex:(NSUI)idx;
-(NSC*)scrollView:(CAScrollView*)sc colorForObject:(id)o atIndex:(NSUI)idx;
@end

@interface 	  CAScrollView : NSView

@property (NATOM)  			NSSZ		unit;
@property (NATOM) 		NSUI 		fixWatchdog;
@prop_RO				NSA 		*allLayers;
@property (NATOM) 	NSMA 		*layerQueue;
@property (NATOM) 	CAL 		*hoveredLayer, *selectedLayer, *scrollLayer;
@property (NATOM)  		AZOrient		oreo;

@property (UNSF) id <CAScrollViewDelegate>  delegate;
@prop_RO CGF 	firstLaySpan, sublayerOrig, sublayerSpan, lastLaySpan, superBounds, lastLayOrig;
@prop_RO NSUI  sublayerCt;

- (IBAction)toggleOrientation:_;
                              
//@property (NATOM, ASS)	BOOL 	needsLayout;

@end

