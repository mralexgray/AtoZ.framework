
#import <objc/runtime.h>
#import "DefinitionController.h"
#import "AtoZNodeProtocol.h"

NSArray* RGBFlameArray(NSC*color, NSUI ct, CGF hueStepDeg, CGF satStepDeg, CGF briStepDeg, NSI align);
CAGradientLayer* greyGradLayer();

#define 	zCATEGORY_FONTSIZE 	20
#define 	zKEYWORDS_FONTSIZE  	14
#define 	zKEYWORDS_V_UNIT  	2 * zKEYWORDS_FONTSIZE
#define  zCATEGORY_RECT			(NSRect){ 0, 0, [self.superlayers.first boundsWidth], zKEYWORDS_V_UNIT }

@interface 		   AZOutlineLayer : CALayer

@property (NATOM,STR)		  NSA * nodeRects;
@property (NATOM,WK)  NSTreeNode * rootNode,
											* selectedNode;

+ (INST)  layerWithNode:(NSTreeNode*)node inLayer:(CAL*)layer withFrame:(NSR)frame;			@end


@interface 			AZOutlineLayerNode : CALayer

@property (WK)				  NSTreeNode * representedNode;
@property (NATOM) AZOutlineCellStyle   cellStyle;

+ (instancetype) layerForNode:AZNODEPRO node style:(AZOutlineCellStyle)style;					@end

@interface AZOutlineLayerScrollableList : AZOutlineLayerNode
@end

@interface   					  AZFactoryView : NSView

- (id) initWithFrame:(NSRect)f rootNode:(NSTreeNode*)node;

@property (NATOM)  			   	NSR   nodeRect;
@property (STR)  	  		  NSTreeNode * rootNode;  // DefinitionController *
@property (STR) 		 AZOutlineLayer * outlineLayer;
@property (STR)	     NSSearchField * searchField;
@property (STR)   	  NSPathControl * headerPathControl,
												 * plistPathControl;
@property (STR)  				  		NSC * headerColor,
												 * plistColor;

@end


//@property (weak) 	NSO<AtoZNodeProtocol> * reprsentedNode;


//@property (NATOM,STR) NSO<AtoZNodeProtocol>* representedNode;
//@property (NATOM,WK)  NSO<AtoZNodeProtocol>* selectedNode;

//@property (nonatomic)  				  CGFloat   unitHeight;
//@property (nonatomic,copy)			  CALayer * (^listLayerWithNodes)(NSA*);
//@property (copy)	  			layerFromNodeBlock makeNodeLayer, findNodeLayer, nodeCatList;     	  ; // FOR node (finds corresponding)
//@property (copy)	  			     	  CALayer*	(^findNodeLayer) (AZN*); // WITH node (MAKES a layer)
//+ (CAGradientLayer*) greyGradLayer;

// alignment = -1 (left) 0 (center) or 1 (right)
//+ (NSArray *) RGBFlameArray: (NSColor *)rootColor numberOfColorsInt:(NSUInteger)numberOfColors hueStepDegreesCGFloat:(CGFloat)hueStepDegrees saturationStepDegreesCGFloat:(CGFloat)saturationStepDegrees brightnessStepDegreesCGFloat:(CGFloat)brightnessStepDegrees alignmentInt:(NSInteger)alignment;
//#import "AtoZObjC.h"
//typedef CALayer * (^layerFromNodeBlock) (AZN*);
