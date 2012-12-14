


@interface 	  CAScrollView : NSView

@property (NATOM, STRNG) 	NSMA 		*layerQueue;
@property (NATOM, UNSFE) 	CAL 		*hoveredLayer, *selectedLayer;
@property (NATOM)  		 	AZOrient	orientation;
@property 					StateStyle 	hoverStyle, selectedStyle;

- (IBAction)toggleOrientation:(id)sender;

@end
