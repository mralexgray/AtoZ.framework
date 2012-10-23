
//  AZLassoLayer.m
//  AtoZ

//  Created by Alex Gray on 8/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.
#import "AZLassoLayer.h"
#import <QuartzCore/QuartzCore.h>
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

@implementation AZLassoLayer

+ (AZLassoLayer*)lasso:(CALayer*)layer{
//	__block BOOL bail = NO;;
	return [layer.sublayers filterOne:^BOOL(id object) {

//		CALayer *aLayer = (CALayer*)layer;
		return [object isKindOfClass:[AZLassoLayer class]];
		//) bail = YES;
//		[aLayer removeFromSuperlayer];
	}] ?: ^{
//		AZLOG($(@"lasso   for %@", StringFromBOOL(bail),layer.debugDescription));
//	if (bail) return ;
//	else {
			AZLassoLayer *new = [AZLassoLayer layer];
							    [layer addSublayer:new];
		   				return new;
	}();
}

//-(void)removeForLayer:(CALayer*) layer;
//{
//	[LassoMaster remove:layer];
//	[self release];// removeFromSuperlayer];
//
//}
- (id)init
{
    self = [super init];
    if (self) {
	self.lasso  	 = [CAShapeLayer layer];
	self.lassoBorder =  [CAShapeLayer layer];
	self.layoutManager = self;
	self.delegate = self;
	return self;
    }
    return self;

}
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
		sender.lineWidth    = half;
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
