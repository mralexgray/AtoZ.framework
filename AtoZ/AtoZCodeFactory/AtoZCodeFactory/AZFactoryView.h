
#import <objc/runtime.h>

NSArray* RGBFlameArray(NSC*color, NSUI ct, CGF hueStepDeg, CGF satStepDeg, CGF briStepDeg, NSI align);
CAGradientLayer* greyGradLayer();

#define 	zCATEGORY_FONTSIZE 	20
#define 	zKEYWORDS_FONTSIZE  	14
#define 	zKEYWORDS_V_UNIT  	2 * zKEYWORDS_FONTSIZE
#define  zCATEGORY_RECT			(NSRect){ 0, 0, [self.superlayers.first boundsWidth], zKEYWORDS_V_UNIT }

@interface 				 AZOutlineLayer : CALayer
@property (STR,NATOM)				NSA * nodeRects;
@property (STR)				 	  NSArrayController * nodeController;
@property (WK,NATOM) NSO<AtoZNodeProtocol>* selectedNode;
@end

@interface 			AZOutlineLayerNode : CALayer
@property (weak) 	NSO<AtoZNodeProtocol> * reprsentedNode;
@property (NATOM) AZOutlineCellStyle   cellStyle;
@end
@interface AZOutlineLayerScrollableList : AZOutlineLayerNode
@end

@interface   					  AZFactoryView : NSView

- (id) initWithFrame:(NSRect)f controller:(id)c;

@property (WK) 	 DefinitionController * controller;
@property (STR)   	  NSPathControl * headerPathControl, 	*plistPathControl;
@property (STR) 		 AZOutlineLayer * nodes;
@property (STR)			    		  NSSearchField * searchField;

@property (NATOM) 			 		NSRect   nodeRect;
@property (STR)  				  NSColor * headerColor, 
														 * plistColor;

@end









//@property (nonatomic)  				  CGFloat   unitHeight;
//@property (nonatomic,copy)			  CALayer * (^listLayerWithNodes)(NSA*);
//@property (copy)	  			layerFromNodeBlock makeNodeLayer, findNodeLayer, nodeCatList;     	  ; // FOR node (finds corresponding)
//@property (copy)	  			     	  CALayer*	(^findNodeLayer) (AZN*); // WITH node (MAKES a layer)
//+ (CAGradientLayer*) greyGradLayer;

// alignment = -1 (left) 0 (center) or 1 (right)
//+ (NSArray *) RGBFlameArray: (NSColor *)rootColor numberOfColorsInt:(NSUInteger)numberOfColors hueStepDegreesCGFloat:(CGFloat)hueStepDegrees saturationStepDegreesCGFloat:(CGFloat)saturationStepDegrees brightnessStepDegreesCGFloat:(CGFloat)brightnessStepDegrees alignmentInt:(NSInteger)alignment;
//#import "AtoZObjC.h"
//typedef CALayer * (^layerFromNodeBlock) (AZN*);
