
#import "AZSnapShotLayer.h"
#import <CoreText/CoreText.h>
#import "AtoZ.h"
//#import <FunSize/FunSize.h>

#define SFBlackColor	CGColorCreateGenericRGB(0.0f,0.0f,0.0f,1.0f)
#define SFWhiteColor	CGColorCreateGenericRGB(1.0f,1.0f,1.0f,1.0f)

//#define YMARGIN 20.0 // JUST RIGHT
//#define XMARGIN 0.0//30.0

@implementation AZSnapShotLayer	{	CGGradientRef backgroundGradient;	}
static NSInteger snapshotNumber;

//@synthesize trannyLayer, constrainLayer, imageLayer, gradLayer;
+ (AZSnapShotLayer*) rootSnapWithFile:(AZFile *)file andDisplayMode:(AZDisplayMode)mode {

	AZSnapShotLayer *u = [[self class] rootSnapshot];
	u.objectRep = file;				   u.mode = mode;		return  u;
}

+ (AZSnapShotLayer*)rootSnapshot
{
	AZSnapShotLayer *root 		= [[[self class] alloc] init];
//	root.anchorPoint 			= (CGPoint) {.5,.5};
//	root.bounds 				= (CGRect ) { 0, 0,1, 1};
	[root addConstraintsSuperSize];
//	root.layoutManager 			= [CAConstraintLayoutManager layoutManager];
//	root.autoresizingMask 		= kCALayerHeightSizable | kCALayerWidthSizable;
	CALayer *contentLayer 		= NewLayerWithFrame(root.frame);//[CALayer layer];				// Our container layer
	root.contentLayer 			= contentLayer;
//	contentLayer.anchorPoint 	= CGPointMake(0, 0);
//	contentLayer.bounds 		= CGRectMake(00, 00, 50, 50);
//	contentLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
//				.borderWidth 	= 2.0;
//				.borderColor 	= SFWhiteColor;
//				.backgroundColor = SFBlackColor;

//				.constraints = @[ AZConstRelSuper(kCAConstraintHeight), AZConstRelSuper(kCAConstraintWidth) ];
	snapshotNumber++;
	CATextLayer* labelLayer 		= [CATextLayer layer];
	labelLayer.style 			= @{	@"font" 			: @"Ubuntu Mono Bold",
										@"alignmentMode"		: kCAAlignmentCenter,
										@"fontSize"			: @(200),
										@"wrapped" 			: @(NO),			};
	labelLayer.delegate = self;
	labelLayer.foregroundColor 	= CGColorCreateGenericRGB(1, 1, 1, 1);
//	[labelLayer addConstraintsSuperSize];
	[labelLayer addConstraints:@[	AZConstRelSuper(kCAConstraintMinX),
									AZConstRelSuper(kCAConstraintHeight),
									AZConstRelSuper(kCAConstraintWidth)]];
	labelLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
//	labelLayer.frame = contentLayer.bounds;
//	labelLayer.position = CGPointrMake(50, 20+i*50);
//	labelLayer.anchorPoint = AZCenterOfRect(contentLayer.bounds);
//	labelLayer.bounds = CGRectMake(0, 0, contentLayer.bounds.size.w, contentLayer.bounds.size.height);
//	AddBloom(labelLayer);
	AddShadow(labelLayer);
	AddPulsatingBloom(labelLayer);

//	labelLayer.zPosition = 23;

	[contentLayer addSublayer:labelLayer];
	[root setLabelLayer:labelLayer];
	[root addSublayer:contentLayer];
	return root;
}
- (void)didChangeValueForKey:(NSString *)key {
		if ([key isEqualToString:@"bounds"] || [key isEqualToString:@"frame"]) {
		_labelLayer.fontSize = _labelLayer.bounds.size.height;
//		 setNeedsLayout];
	}
	[super didChangeValueForKey:key];
}

- (void) setObjectRep:(id)objectRep {		_objectRep = objectRep;
	self.imageLayer = [CALayer layer];
	_imageLayer.constraints = @[
								AZConstScaleOff(kCAConstraintWidth, @"superlayer", .7, 0),
								AZConstScaleOff(kCAConstraintMaxX, 	@"superlayer", .9,0),
								AZConstRelSuper(kCAConstraintMidY)	];

	_imageLayer.contents = [[objectRep valueForKey:@"image"] imageScaledToFitSize:AZSizeFromDimension(512)];
	_imageLayer.contentsGravity = kCAGravityResizeAspect;
	_imageLayer.autoresizingMask = kCALayerHeightSizable | kCALayerWidthSizable;
	[_contentLayer addSublayer:_imageLayer];

	_labelLayer.string = [[objectRep valueForKey:@"name"] firstLetter];
	NSLog(@"set objectRepcomplete for:%@",[objectRep valueForKey:@"name"]);
	self.mask = _imageLayer;

//	CIFilter *filter = [CIFilter filterWithName:@"CIEdges"];
//	[filter setValue:i forKey:@"inputImage"];
//	[filter setValue:[NSNumber numberWithFloat:4.0] forKey:@"inputIntensity"];
//	CIImage *imageToDraw = [filter valueForKey:@"outputImage"];
//	filter.name			= @"edges";
//	imageLayer.filters 	= @[filter];

}

//- (CALayer *) gradLayer {
//
//	size_t num_locations = 3;
//	CGFloat locations[3] = { 0.0, 0.7, 1.0 };
//	CGFloat components[12] = {	0.0, 0.0, 0.0, 1.0,	  0.5, 0.7, 1.0, 1.0,	1.0, 1.0, 1.0, 1.0 };
//	CGColorSpaceRef colorspace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
//	backgroundGradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
//	CGSize b = self.bounds.size;
//	NSImage* compositeImage = [[NSImage alloc] initWithSize:b];
//		[compositeImage lockFocus];
//	CGContextRef ctx = [AZGRAPHICSCTX graphicsPort];
//	CGContextDrawRadialGradient(ctx, backgroundGradient,
//								CGPointMake(b.width/2, b.height), b.width,
//								CGPointMake(b.width/2, -b.height/2), 0,
//								kCGGradientDrawsAfterEndLocation);
//	return gradLayer;
//}
- (void) setSelected:(BOOL)selected {
	_selected = selected;
	if(!_selected) {
		[CATransaction transactionWithLength:2 actions:^{
			_labelLayer.hidden = NO;
			self.masksToBounds = NO;
			self.mask = _labelLayer;
			CAShapeLayer * l = [self.class lassoLayerForLayer:self];
//			l.name = @"lasso";
//			[self addSublayer:l];
      //		NSBeep();
		}];
//		[self flipDown];
//		self.mask = imageLayer;
//		_labelLayer.hidden = YES;
//		.backgroundColor = SFWhiteColor;
//		_labelLayer.foregroundColor = SFBlackColor;
	} else {
			[CATransaction transactionWithLength:2 actions:^{
				self.mask = _imageLayer;
				_labelLayer.hidden = YES;
			[self sublayersBlockSkippingSelf:^(CALayer *layer) {
				if ([layer.name isEqualToString:@"lasso"]) [layer removeFromSuperlayer];
			}];
			
//		[self flipBack];
//		self.backgroundColor = SFBlackColor;
			_labelLayer.foregroundColor = SFWhiteColor;
		}];

	}
}
@end
