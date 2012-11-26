
//  AZLassoLayer.m
//  AtoZ



#import "AZLassoLayer.h"
#import <QuartzCore/QuartzCore.h>


@interface AZLassoLayer ()
@property (nonatomic, strong) CAShapeLayer *lassoBorder, *lasso;
@property (nonatomic, assign) CGFloat dynamicStroke;
@property (nonatomic, strong) NSBezierPath *bPath;
@end

@implementation AZLassoLayer

- (id)initWithLayer
{
	if (!(self = [super init])) return nil;
	self.lasso  	 = 	[CASHL layer];
	self.lassoBorder =  [CASHL layer];
	self.layoutManager = self;
	return self;
}

+ (AZLassoLayer*)lasso:(CALayer*)layer
{
	AZLassoLayer *l = [layer.sublayers filterOne:^BOOL(id object) {
		return [object isKindOfClass:[AZLassoLayer class]];
	}] ?: [[self class] layer];
	
}



//@implementation LassoMaster
//
//+ (NSMutableArray*) lassos{ 	return [[LassoMaster sharedInstance]lassos];}
//
//+ (void)add:(id) obj{			   [[LassoMaster lassos] addObject:obj]; }
//
//+ (BOOL)isLassoed:(id)item {		   [[self lassos] isObjectInArrayWithBlock:^BOOL(id obj) {
//							return [item isEqualTo:obj] ? YES: NO;	 }]; }
//
//+ (void)remove:(id) obj{  [[LassoMaster lassos]removeObjectAtIndex:[[LassoMaster lassos]indexOfObject:obj]];	}

//- (id)objectForKeyedSubscript:(NSString *)key; {
//	return [[[LassoMaster sharedInstance]lassos] filterOne:^BOOL(id object) {
//
//		if ([object valueForKey:@"name"]) { return [[object valueForKey:@"name"] isEqualToString:key] ? YES : NO; }
//		else return [[object valueForKey:@"unqiueID"]isEqualToString:key] ? YES : NO;
//	}];
//}
		//- (void)setObject:(id)newValue forKeyedSubscription:(NSString *)key {
//		[self.lassos setObject:newValue forKey:key];]
//}
//	if (![AZLassoLayer hasSharedInstance]) { AZLOG(@"having too make the lasso share"); filterOne:^BOOL(id object) {  return layer == (CALayer*)[object valueForKey:@"layer"//] ? YES : NO; }];

//@end




//-(void)removeForLayer:(CALayer*) layer;
//{
//	[LassoMaster remove:layer];
//	[self release];// removeFromSuperlayer];
//
//}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
	self.dynamicStroke 			= .1 * AZMaxDim(self.superlayer.bounds.size);
	CGFloat half 				= _dynamicStroke / 2;
//	[self addConstraintsSuperSize];
	self.bPath = [NSBezierPath bezierPathWithRoundedRect:_lasso.frame cornerRadius:layer.cornerRadius];
	[@[_lassoBorder,_lasso] each:^(CAShapeLayer* sender) {
//		[sender addConstraintsSuperSize];
		sender.anchorPoint 	= self.superlayer.anchorPoint;
		sender.bounds 		= NSInsetRect(layer.bounds, _dynamicStroke, _dynamicStroke);
		sender.fillColor 	= cgCLEARCOLOR;
		sender.lineWidth	= half;
		sender.lineJoin		= kCALineJoinRound;
		sender.path			= [_bPath.copy quartzPath];
	}];

//	_lasso.constraints 		= @[		AZConstScaleOff( kCAConstraintMinX,@"superlayer", 1, half),
//											AZConstScaleOff( kCAConstraintMinY,@"superlayer", 1,half), /*2),*/
//											AZConstScaleOff( kCAConstraintMaxY,@"superlayer", 1,half),
//											AZConstScaleOff( kCAConstraintWidth,@"superlayer", 1,NEG(_dynamicStroke)),
//											AZConstScaleOff( kCAConstraintHeight,@"superlayer", 1, NEG(_dynamicStroke)),
//											AZConst( kCAConstraintMidX,@"superlayer"),
//											AZConst( kCAConstraintMidY,@"superlayer") ];

	_lasso.strokeColor 			= cgBLACK;
	_lassoBorder.strokeColor		= cgWHITE;
	_lasso.lineDashPattern 		= @[ @(20), @(20)];
//	_lasso.zPosition = 3300;
	CABasicAnimation *dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
	[dashAnimation setValuesForKeysWithDictionary:@{ 	@"fromValue":@(0.0), 	@"toValue"	   :@(40.0),
	 													@"duration" : @(0.75),	@"repeatCount" : @(10000) }];
	[_lasso addAnimation:dashAnimation forKey:@"linePhase"];

	_lassoBorder.zPosition = 99;
	[self addSublayer:_lassoBorder];
	_lasso.zPosition = 199;
	[self addSublayer:_lasso];
//	NSLog(@"lasso %ld made: %@", [_liveLassos count], [_lasso debugDescription]);
//	[[AZTalker sharedInstance]say:$(@"%ld",[_liveLassos count])];
}

@end
