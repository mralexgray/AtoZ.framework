

#import "AZSnapShotLayer.h"
#import "AtoZ.h"

typedef enum  {
	AZAdobeInitals,
	AZAppleFlip
} 	AZDisplayMode;

@interface AZSnapShotLayer : CALayer

+ (AZSnapShotLayer*) rootSnapshot;
//+ (AZSnapShotLayer*) rootSnapWithFile:(AZFile *)file andDisplayMode:(AZDisplayMode)style;

@property (nonatomic, retain) CATransformLayer				*trannyLayer;
@property (nonatomic, retain) CAConstraintLayoutManager		*constrainLayer;

@property (nonatomic, retain) CALayer		*contentLayer, *gradLayer, 	*imageLayer;;
@property (nonatomic, retain) CATextLayer	*labelLayer;

@property (nonatomic, assign) BOOL 			selected;
@property (nonatomic, assign) AZDisplayMode mode;

@property (nonatomic, retain) id objectRep;

@end
