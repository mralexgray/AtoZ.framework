
#import <objc/runtime.h>
#import "AtoZObjC.h"

typedef CALayer * (^layerFromNodeBlock) (AZN*);
@interface   					  AZFactoryView : NSView 
@property			    		  NSSearchField * searchField;
@property (weak) 		 DefinitionController * controller;
@property (nonatomic)   	  NSPathControl * headerPathControl, 	*plistPathControl;
@property (nonatomic) 				 		NSA * nodeRects;
@property (nonatomic)				 		AZN * selectedNode;
@property (nonatomic) 			 		NSRect   nodeRect;//, unitBounds;
//@property (nonatomic)  				  CGFloat   unitHeight;
@property (nonatomic)  				  NSColor * headerColor, *plistColor;
@property (nonatomic,copy)			  CALayer * (^listLayerWithNodes)(NSA*);
@property (copy)	  			layerFromNodeBlock makeNodeLayer, findNodeLayer, nodeCatList;     	  ; // FOR node (finds corresponding)
//@property (copy)	  			     	  CALayer*	(^findNodeLayer) (AZN*); // WITH node (MAKES a layer)
- (id) initWithFrame:(NSRect)f controller:(id)c;
+ (CAGradientLayer*) greyGradLayer;

// alignment = -1 (left) 0 (center) or 1 (right)
+ (NSArray *) RGBFlameArray: (NSColor *)rootColor numberOfColorsInt:(NSUInteger)numberOfColors hueStepDegreesCGFloat:(CGFloat)hueStepDegrees saturationStepDegreesCGFloat:(CGFloat)saturationStepDegrees brightnessStepDegreesCGFloat:(CGFloat)brightnessStepDegrees alignmentInt:(NSInteger)alignment;

@end
