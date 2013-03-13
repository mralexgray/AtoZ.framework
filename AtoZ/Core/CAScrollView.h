


@interface 	  CAScrollView : NSView

@property (NATOM, STRNG) 	NSMA 		*layerQueue;
@property (NATOM, STRNG) 	CAL 		*hoveredLayer, *selectedLayer;
@property (NATOM, ASS)  	AZOrient		oreo;
@property (NATOM, ASS)		StateStyle 	hoverStyle, selectedStyle;

- (IBAction)toggleOrientation:(id)sender;

@end
