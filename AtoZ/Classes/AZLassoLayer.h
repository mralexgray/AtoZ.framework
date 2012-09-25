
//  AZLassoLayer.h
//  AtoZ

//  Created by Alex Gray on 8/28/12.
//  Copyright (c) 2012 mrgray.com, inc. All rights reserved.


#import "BaseModel.h"
#import "AtoZ.h"
#import <QuartzCore/QuartzCore.h>

//@interface LassoMaster : AZSingleton
//@property (nonatomic, retain) NSMutableArray *lassos;
//+ (void)add:    (id) obj;
//+ (void)remove: (id) obj;
////- (id)objectForKeyedSubscript:(NSString *)key;
//+ (NSMutableArray*) lassos;
//+ (BOOL) isLassoed:(id)item;
//@end

@interface AZLassoLayer : CALayer
+ (instancetype) lasso: (CALayer*)layer;
@property (nonatomic, strong) CAShapeLayer *lassoBorder, *lasso;
@property (nonatomic, assign) CGFloat dynamicStroke;
@property (nonatomic, strong) NSBezierPath *bPath;

@end
